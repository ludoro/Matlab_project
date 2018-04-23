#include "global_variables.h"
#include "math.h"
void toll_for_node(){
  double absolute_toll = 0;
  double sum;
  int tot_edges;
  int e[3];
  for(int id_n = 0; id_n< n_edges; id_n++){
    sum = 0;
    tot_edges = node[id_n].tot_edges;
    for(int j = 0; j<3; j++){
      e[j] = node[id_n].edges[j];
    }

/*
%L'idea è che per ogni nodo, trovo la lunghezza di tutti i segmenti e ne
%faccio la media. Abbiamo utilizzato la norma inf per evitare la radice
%quadrata visto che è un'operazione dispendiosa.
*/
  for(int i = 0; i < tot_edges; i++){
    double v_temp[2] = {node[edge[e[i]][1]].x - node[edge[e[i]][0]].x,
                         node[edge[e[i]][1]].y - node[edge[e[i]][0]].y };
    double norm_inf = v_temp[0];
    if ( abs(v_temp[0]) < abs(v_temp[1]) ){
      norm_inf = v_temp[1];
    }
    sum += norm_inf;

    }
    node[id_n].toll = sum/tot_edges*(accuracy);
    absolute_toll += node[id_n].toll;
  }
  absolute_toll = absolute_toll/n_nodes;

  for(int i = 0; i <n_traces; i++){
    double norm_t_1 = 0;
    for(int j = 0; j < 2; j++){
      norm_t_1 += abs(T[i][j]);
    }
    toll_t[i] = absolute_toll/norm_t_1;
  }


}
