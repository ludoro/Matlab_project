#include "global_variables.h"

void enqueue_tri_to_check(int id_tri){
  //se non sappiamo niente
  if(neigh[id_tri][0] != -1){
    if(triangle[neigh[id_tri][0]][6] == -1){
      queue.resize(queue.size()+1);
      queue[queue.size()-1][0] = neigh[id_tri][1];
      queue[queue.size()-1][1] = triangle[id_tri][0];
      queue[queue.size()-1][2] = triangle[id_tri][2];
      triangle[neigh[id_tri][0]][6] = -2;
    }
  }

  if(neigh[id_tri][1] != -1){
    if(triangle[neigh[id_tri][1]][6] == -1){
      queue.resize(queue.size()+1);
      queue[queue.size()-1][0] = neigh[id_tri][1];
      queue[queue.size()-1][1] = triangle[id_tri][0];
      queue[queue.size()-1][2] = triangle[id_tri][2];
      triangle[neigh[id_tri][1]][6] = -2;
    }
  }

  if(neigh[id_tri][2] != -1){
    if(triangle[neigh[id_tri][2]][6] == -1){
      queue.resize(queue.size()+1);
      queue[queue.size()-1][0] = neigh[id_tri][2];
      queue[queue.size()-1][1] = triangle[id_tri][0];
      queue[queue.size()-1][2] = triangle[id_tri][1];
      triangle[neigh[id_tri][2]][6] = -2;
    }
  }

  for(int i = 0; i<3; i++){
    for(int j=0; j<node[triangle[id_tri][i]].tot_triangles; j++){
      if(triangle[node[triangle[id_tri][i]].triangles[j]][6] == -1 &&
         node[triangle[id_tri][i]].triangles[j] != id_tri){
           queue.resize(queue.size()+1);
           queue[queue.size()-1][0] = node[triangle[id_tri][i]].triangles[j];
           queue[queue.size()-1][1] = triangle[id_tri][i];
           queue[queue.size()-1][2] = 0; // per scrupolo
           triangle[node[triangle[id_tri][i]].triangles[j]][6] = -3;
         }

    }
  }



}
