#include "global_variables.h"

void edges_for_node(){
  for(int i = 0; i < n_edges; i++){
    int n_1;
    int n_2;
    n_1 = node[edge[i][0]].tot_edges;
    node[edge[i][0]].edges[n_1+1] = i+1;
    node[edge[i][0]].tot_edges = n_1 + 1;

    n_2 = node[edge[i][1]].tot_edges;
    node[edge[i][1]].edges[n_2+1] = i+1;
    node[edge[i][0]].tot_edges = n_2 + 1;

  }







}
