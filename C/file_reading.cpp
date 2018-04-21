#include <stdio.h>
#include <iostream>
#include <fstream>
#include <string>
#include <math.h>
#include "global_variables.h"


int n_nodes;
int n_triangles;
int n_edges;
int n_neigh;
int n_traces;
int n_trace_vertex;
double accuracy = pow(10,-14);

std::vector<NODE> node;
std::vector<std::vector<int> > triangle;
std::vector<std::vector<int> > edge;
std::vector<std::vector<int> > neigh;
std::vector<std::vector<double> > trace_vertex;
std::vector<std::vector<int> > trace;
std::vector<std::vector<double> > T;
std::vector<double> T_squared;
std::vector<double> toll_t;
std::vector<std::vector<int> > queue;

void load_max_numbers() {

  //-------PRENDO N_NODES----------
  std::ifstream input;
  input.open("quad.1.node.txt");

  if (!input) {
    std::cout << "Cannot open file.\n";
    return;
  }
  input >> n_nodes;

  input.close();

  //-------PRENDO N_TRIANGLES----------
  std::ifstream input1;
  input1.open("quad.1.ele.txt");

  if (!input1) {
    std::cout << "Cannot open file.\n";
    return;
  }
  input1 >> n_triangles;
  input1.close();

  //-------PRENDO N_EDGES----------
  std::ifstream input2;
  input2.open("quad.1.edge.txt");

  if (!input2) {
    std::cout << "Cannot open file.\n";
    return;
  }
  input2 >> n_edges;
  input2.close();

  //-------PRENDO N_NEIGH----------
  std::ifstream input3;
  input3.open("quad.1.neigh.txt");

  if (!input3) {
    std::cout << "Cannot open file.\n";
    return;
  }
  input3 >> n_neigh;
  input3.close();


    //-------PRENDO N_TRACES e N_TRACES_VERTEX----------
    std::ifstream input4;
    input4.open("quad.1.neigh.txt");

    if (!input4) {
      std::cout << "Cannot open file.\n";
      return;
    }
    input4 >> n_trace_vertex;
    input4 >> n_traces;
    input4.close();

};


void load_matrices(){

  // variabili temporanee per mangiare righe e valori
  std::string sGarbage;
  int garbage;

  //--------RIEMPO NODE----------------
  // matrice di vettori, definita in global_variables.h
  node.resize(n_nodes);
  std::ifstream input;
  input.open("quad.1.node.txt");

  if (!input) {
    std::cout << "Cannot open file.\n";
    return;
  }
  getline(input,sGarbage);
  for(int i = 0; i<n_nodes; i++){
    input >> garbage;
    input >> node[i].x;
    input >> node[i].y;
    input >> garbage;
    node[i].side = 0;
    node[i].toll = -1;
    node[i].edges[0] = 0;
    node[i].edges[1] = 0;
    node[i].edges[2] = 0;
    node[i].triangles[0] = 0;
    node[i].triangles[1] = 0;
    node[i].tot_edges = 0;
    node[i].tot_triangles = 0;
    node[i].s = 666;
  }
  input.close();

  //------RIEMPO TRIANGLE-----------
  // triangle(n_triangles,7)
  // prime tre colonne indici nodi, seconde tre colonne status edge,
  // ultima colonna flag
  triangle.resize(n_triangles); // faccio crescere le righe
  for(int j = 0; j<n_triangles; j++){
    triangle[j].resize(7); // faccio crescere le colonne per ogni riga
  }

  std::ifstream input1;
  input1.open("quad.1.ele.txt");

  if (!input1) {
    std::cout << "Cannot open file.\n";
    return;
  }
  getline(input1,sGarbage); // mangio prima riga del file
  int j = 0;
  for(int i = 0; i<n_triangles; i++){
    input1 >> garbage;
    input1 >> triangle[i][j];
    input1 >> triangle[i][j+1];
    input1 >> triangle[i][j+2];
    triangle[i][j+3] = -1;
    triangle[i][j+4] = -1;
    triangle[i][j+5] = -1;
    triangle[i][j+6] = -1;
    }
  input1.close();

//------RIEMPO EDGE--------
// edge(n_edges,3)
// edge(n,1) vertice 1 del segmento n
// edge(n,2) vertice 2 del segmento n
// edge(n,3) status con la traccia
edge.resize(n_edges); // faccio crescere righe
for (int i = 0; i<n_edges; i++){
  edge[i].resize(3); // per ogni riga faccio crescere la colonna
}

std::ifstream input2;
input2.open("quad.1.edge.txt");

if (!input2) {
  std::cout << "Cannot open file.\n";
  return;
}

getline(input2,sGarbage);
for(int i = 0; i < n_edges; i++){
  input2 >> garbage;
  input2 >> edge[i][0];
  input2 >> edge[i][1];
  input2 >> garbage;
  edge[i][2] = -1;
}
input2.close();

//-------RIEMPO NEIGH--------
// neigh(n_neigh,3)
// neigh(5,2) vicino 2 del triangolo 5, -1 default per non vicino.

neigh.resize(n_neigh); // faccio crescere righe
for(int i = 0; i<n_neigh; i++){
  neigh[i].resize(3); // faccio crescere colonne;
}

std::ifstream input3;
input3.open("quad.1.neigh.txt");

if (!input3) {
  std::cout << "Cannot open file.\n";
  return;
}

getline(input3,sGarbage);
for(int i = 0; i<n_neigh; i++){
    input3 >> garbage;
    input3 >> neigh[i][j];
    input3 >> neigh[i][j+1];
    input3 >> neigh[i][j+2];
}
input3.close();

//------RIEMPO TRACE_VERTEX E TRACE----------

//TRACE VERTEX
trace_vertex.resize(n_trace_vertex); // righe
for(int i = 0; i<n_trace_vertex; i++){
  trace_vertex[i].resize(2); // colonne
}
std::ifstream input4;
input4.open("trace_trace");

if (!input4) {
  std::cout << "Cannot open file.\n";
  return;
}

getline(input4,sGarbage);
for(int i = 0; i<n_trace_vertex; i++){
  input >> garbage;
  input >> trace_vertex[i][0];
  input >> trace_vertex[i][1];
}

//TRACE
trace.resize(n_traces);
for(int i = 0; i < n_traces; i++){
  trace[i].resize(2);
}
getline(input4,sGarbage);
for(int i = 0; i<n_traces; i++){
  input >> garbage;
  input >> trace[i][0];
  input >> trace[i][1];
}
input4.close();

};

void create_additional_structures(){

  // T vettore che per ogni traccia contiene vettore tangente a traccia
  T.resize(n_traces);
  for(int i = 0; i < n_traces; i++){
    T[i].resize(2);
  }

  T_squared.resize(n_traces); // lunghezza al quadrato di ogni T;

  for ( int i = 0; i < n_traces; i++){
    T[i][0]= trace_vertex[trace[i][1]][0] - trace_vertex[trace[i][0]][0];
    T[i][1]= trace_vertex[trace[i][1]][1] - trace_vertex[trace[i][0]][1];
    T_squared[i] = T[i][0]*T[i][0] + T[i][1]*T[i][1];
  }


}
