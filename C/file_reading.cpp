#include <stdio.h>
#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include "global_variables.h"


int n_nodes;
int n_triangles;
int n_edges;
int n_neigh;
int n_traces;

std::vector<NODE> node;

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


    //-------PRENDO N_TRACES----------
    std::ifstream input4;
    input4.open("quad.1.neigh.txt");

    if (!input4) {
      std::cout << "Cannot open file.\n";
      return;
    }
    input4 >> n_traces;
    input4.close();

};

node.resize(n_nodes);

void load_matrices(){
  //--------RIEMPO NODE----------------
  std::ifstream input;
  input.open("quad.1.node.txt");

  if (!input) {
    std::cout << "Cannot open file.\n";
    return;
  }
  std::string sGarbage;
  int garbage;
  getline(input,sGarbage);
  for(int i = 0; i<n_nodes; i++){
    input >> garbage;
    input >> node[i].x;
    input >> node[i].y;
    input >> garbage;
  }
  input.close();


};
