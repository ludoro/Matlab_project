#include "global_variables.h"

void it_is_cut(){
  //Inizializzo a 2 la lunghezza del vettore di nodi.
  info_trace[id_t].cut_tri[0].nodes.resize(2);
  info_trace[id_t].cut_tri[1].nodes.resize(2);
  
  if(info_trace[id_t].cut_tri[0].id == 0){
     info_trace[id_t].cut_tri[0].id = id_t;
     triangle[id_t][9] = 0;
    /*
    %mettiamo info dei punti del triangolo che stiamo
    %considerando in info trace.
    */
    for(j=0; j<3; j++){
      info_trace[id_t].cut_tri[0].points[j][0] = node[tr[j]].x;
      info_trace[id_t].cut_tri[0].points[j][1] = node[tr[j]].y;
    }
  }
  else{
    info_trace[id_t].cut_tri.resize(len(info_trace[id_t].cut_tri)+1);
    info_trace[id_t].cut_tri[len(info_trace[id_t].cut_tri)] = id_tri;
    triangle[id_t][9] = 0;
    /*
    %mettiamo info dei punti del triangolo che stiamo
    %considerando in info trace.
    */
    for(int j = 0; j<3; j++){
      info_trace[id_t].cut_tri[len(info_trace[id_t].cut_tri)-1]points[j][0]
         = node(tr(j)).x;
      info_trace[id_t].cut_tri[len(info_trace[id_t].cut_tri)-1]points[j][1]
         = node(tr(j)).Y;
    }
  }

}
