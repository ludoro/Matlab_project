#include "global_variables.h"
#include "functions.h"

void ricerca_triangolo(){
/*
%suppongo che la matrice 'triangle' abbia 6 colonne: dalla 4 alla 6
%contenenti gli status dei lati. Status sconociuto: -1
*/
int found = 0;
int id_tri = 1; //id del triangolo in esame
double s_temp[2] = [0,0]; //le coordinate curvilinee dell'eventuale intersezione
int tr[6] = [0,0,0,0,0,0]; // info sul triangolo corrente
int side[3] = [0,0,0]; //semipiani di appartenenza dei tre vertici
int called_which_side[3] = [0,0,0]; //vettore che ci dice se abbiamo chiamato la
                                    // funzione which_side
                                    // 0---> no chiamata
                                    // 1---> si chiamata
int status[2] = [0,0]; //status delle eventuali intersezioni con due lati di un
                       // triangolo

int points_to_check[2][2] = [0,0;0,0];
int edges_to_check[2] = [0,0];
int node_on_trace = 0; //indica nodo su traccia
int nodes_on_trace[2] = [0,0];

//prima parte di ricerca
while(id_tri<=n_triangles && found==0){
  called_which_side = [0,0,0];
  for(int i = 0; i<6; i++){
    tr[i] = triangle[id_tri][i];
  }
  







}




}
