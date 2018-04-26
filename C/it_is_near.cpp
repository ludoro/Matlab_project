#include "global_variables.h"

void it_is_near(){
  //Inizializzo a 2 la lunghezza del vettore di nodi.
  info_trace[id_t].cut_tri[0].nodes.resize(2);
  info_trace[id_t].cut_tri[1].nodes.resize(2);
  double b = triangle(id_tri,9);
  int already_saved = 0;
  if(b<-1){
    //controllo che la prima cella di near_tri_ non contenga triangoli
    if(info_trace[id_t].near_tri_[0].id == 0){
      info_trace[id_t].near_tri[0].id = id_tri;
      triangle[id_tri][9] = 1;
      if(b==-2){
        for(int i = 0; i<2; i++){
        info_trace[id_t].near_tri[0].nodes[i] = queue[0][i+1];
        }
      }
      else{//b==-3
        info_trace[id_t].near_tri[0].nodes[0] = queue[0][1];
        }
      }
    else{//near_tri contiene già dei triangoli
      info_trace[id_t].near_tri.resize(len(info_trace[id_t].near_tri)+1);
      triangle[id_tri][9] = length(info_trace[id_t].near_tri);
      if(b==-2){

        for(int i = 0; i < 2; i++){
        info_trace(id_t).near_tri[len(info_trace[id_t].near_tri)-1].nodes[i] =
                      queue[0][i+1];
            }

      }
      else{//b==-3
        info_trace[id_t].near_tri[len(info_trace[id_t].near_tri)-1].nodes[0] =
                        queue[0][1];

      }
    }
    else{ // b > 0
      // il triangolo è già near_tri, bisogna controllare i nodi
      for(int i = 1; i < 3; i++){
        already_saved = 0;
        for(j=0; j < len(info_trace[id_t].near_tri[b].nodes); j++){
          if(queue[0][i] == info_trace[id_t].near_tri[b].nodes[j]){
            already_saved = 1;
          }
        }
        if(queue[0][i] != 0 && already_saved == 0){
          info_trace[id_t].near_tri[b].nodes.
          resize(len(info_trace[id_t].near_tri[b].nodes)+1);
          info_trace[id_t].near_tri[b].
          nodes[len(info_trace[id_t].near_tri[b].nodes)] = queue[0][i];

        }
      }
    }
  }
}
