#include "global_variables.h"
#include "functions.h"

void checking_queue_temp(){

  while(queue_temp[0].size > 0){
    int called_which_side[3] = {0,0,0};
    int called_intersect[3] = {0,0,0};
    int id_tri = queue_temp[0][0];
    int node_on_trace;
    int opposite_nodes[2];

    if(triangle[id_tri-1][9] == -4){
      for(int i = 0; i < 3; i++){
        if(node[tri[i]-1].side == 0){
          std::pair<int,int> return_which = which_side(id_t,tr[i]);
          node[tri[i]-1].side = side[i];
          called_which_side[i] = 1;
        }
        else{
          side[i] = node[tri[i]-1].side;
        }
      }
    }

    int sum = side[0] + side[1] + side[2];

    if(sum == 2){

      if(side[0] == 2){
        node_on_trace = 1;
        opposite_nodes[0] = 2;
        opposite_nodes[1] = 3;
      }
      else if(side[1] == 2){
        node_on_trace = 2;
        opposite_nodes[0] = 3;
        opposite_nodes[1] = 1;
      }
      else{
        node_on_trace = 3;
        opposite_nodes[0] = 1;
        opposite_nodes[1] = 2;
      }
      if(tr[node_on_trace+3-1] == -1){
        std::pair<int,double> return_intersect =
        intersect(id_t,tr[opposite_nodes[0]],tr[opposite_nodes[1]]);
        called_intersect[node_on_trace-1] = 1;
        triangle[id_tri-1][node_on_trace+3-1] = return_intersect.first;
        triangle[id_tri-1][node_on_trace+6-1] = return_intersect.second;

        for(int j = 0; j < 3; j++){
          if(neigh[id_tri-1][node_on_trace-1] != -1){
            if(neigh[neigh[id_tri-1][node_on_trace-1]][j] == id_tri){
              triangle[neigh[id_tri-1][node_on_trace-1]][j+3] =
                            tr[node_on_trace+3-1];
              triangle[neigh[id_tri-1][node_on_trace-1]][j+6] = s_temp[1];
            }
          }
        }


      }

      else{
        s_temp[1] = tr[node_on_trace+6-1];
      }

      s_temp[0] = node[tr[node_on_trace-1]-1].s;

      if(s_temp[1] <= 1 && s_temp[1] >= 0 &&
         called_intersect[node_on_trace-1] == 1){
           info_trace[id_t-1].s.resize((info_trace[id_t-1].s).size() + 1));
           info_trace[id_t-1].s[info_trace[id_t-1].s.size()-1] = s_temp[1];
         }
      if( (s_temp[0] > 0 && s_temp[0] < 1) ||
          (tr[node_on_trace+3-1] != 0)){
            it_is_cut();
            enqueue_tri_to_check(id_tri);

            int sizecut = info_trace[id_t-1].cut_tri.size();
            //trovo coordinate quarto punto
            for(k = 0; k < 2; k++){
              info_trace[id_t-1].cut_tri[sizecut-1].points[3,k] =
              trace_vertex[trace[id_t-1][0]][k] + s_temp[1] *
              trace_vertex[trace[id_t-1][1]][k] -
              trace_vertex[trace[id_t-1][0]][k];
            }

            info_trace[id_t-1].cut_tri[sizecut-1].poly_1[0] = node_on_trace;
            info_trace[id_t-1].cut_tri[sizecut-1].poly_1[1] = opposite_nodes[0];
            info_trace[id_t-1].cut_tri[sizecut-1].poly_1[2] = 4;
            info_trace[id_t-1].cut_tri[sizecut-1].poly_1[3] = 0;

            info_trace[id_t-1].cut_tri[sizecut-1].poly_2[0] = node_on_trace;
            info_trace[id_t-1].cut_tri[sizecut-1].poly_2[1] = 4;
            info_trace[id_t-1].cut_tri[sizecut-1].poly_2[2] = opposite_nodes[1];

            info_trace[id_t-1].cut_tri[sizecut-1].tri[0][0] = node_on_trace;
            info_trace[id_t-1].cut_tri[sizecut-1].tri[0][1] = opposite_nodes[0];
            info_trace[id_t-1].cut_tri[sizecut-1].tri[0][2] = 4;

            info_trace[id_t-1].cut_tri[sizecut-1].tri[1][0] = node_on_trace;
            info_trace[id_t-1].cut_tri[sizecut-1].tri[1][1] = 4;
            info_trace[id_t-1].cut_tri[sizecut-1].tri[1][2] = opposite_nodes[0];

          }



    }
    else if(sum == 3 || sum == 5){

      int nodes_on_trace[2];

      if(side[0] != 2){
        lonely_point = 1;
        nodes_on_trace[0] = 2;
        nodes_on_trace[1] = 3;
      }
      else if(side[1] != 2){
        lonely_point = 2;
        nodes_on_trace[0] = 3;
        nodes_on_trace[1] = 1;
      }
      else{
        lonely_point = 3;
        nodes_on_trace[0] = 1;
        nodes_on_trace[1] = 2;
      }
      s_temp[0] = node[tr[nodes_on_trace[0]-1]-1].s;
      s_temp[1] = node[tr[nodes_on_trace[1]-1]-1].s;

      for(int i = 0; i < 2; i++){
        if(s_temp[i] <= 1 && s_temp[i] >= 0 &&
           called_which_side[nodes_on_trace[i]-1] == 1){
             info_trace[id_t-1].s.resize(info_trace[id_t-1].s.size() + 1);
             info_trace[id_t-1].s[size-1] = s_temp[i];
           }
      }

      if(tr[lonely_point+3-1] == -1){
        std::pair<int,double> return_intersect =
        intersect(id_t,tr[opposite_nodes[0]],tr[opposite_nodes[1]]);
        double s_intersect = return_intersect.second;
        called_intersect[lonely_point-1] = 1;
        triangle[id_tri-1][lonely_point+3-1] = return_intersect.first;
        triangle[id_tri-1][lonely_point+6-1] = s_intersect;

        for(int j = 0; j < 3; j++){
          if(neigh[id_tri-1][lonely_point-1] != -1){
            if(neigh[neigh[id_tri-1][lonely_point-1]][j] == id_tri){
              triangle[neigh[id_tri-1][lonely_point-1]][j+3] =
                            tr[lonely_point+3-1];
              triangle[neigh[id_tri-1][lonely_point-1]][j+6] = s_intersect;
            }
          }
        }


      }
      else{
        s_intersect = tr[lonely_point+6-1];
      }
      status = tr[lonely_point+3-1];
      if (status == 2){
        it_is_cut();
        enqueue_tri_to_check(id_tri);

        if(called_intersect[lonely_point-1] == 1){
          info_trace[id_t-1].s.resize(info_trace[id_t-1].s.size()+1);
          info_trace[id_t-1].s[info_trace[id_t-1].s.size()-1] = s_intersect;
        }
        int sizecut = info_trace[id_t-1].cut_tri.size();
        if(s_intersect == 0){
          for(int k = 0; k<2; k++){
            info_trace[id_t-1].cut_tri[sizecut-1].points
            [3][k] = trace_vertex[trace[id_t-1][1]][k];
          }
        }
       else{
         for(int k = 0; k<2; k++){
           info_trace[id_t-1].cut_tri[sizecut-1].points
           [3][k] = trace_vertex[trace[id_t-1][2]][k];
         }
       }
       info_trace[id_t-1].cut_tri[sizecut-1].poly_1[0] = 1
       info_trace[id_t-1].cut_tri[sizecut-1].poly_1[1] = 2
       info_trace[id_t-1].cut_tri[sizecut-1].poly_1[2] = 3
       info_trace[id_t-1].cut_tri[sizecut-1].poly_1[3] = 0;

       info_trace[id_t-1].cut_tri[sizecut-1].tri[1][0] = lonely_point;
       info_trace[id_t-1].cut_tri[sizecut-1].tri[1][1] = node_on_trace[0];
       info_trace[id_t-1].cut_tri[sizecut-1].tri[1][2] = 4;

       info_trace[id_t-1].cut_tri[sizecut-1].tri[2][0] = lonely_point;
       info_trace[id_t-1].cut_tri[sizecut-1].tri[2][1] = 4;
       info_trace[id_t-1].cut_tri[sizecut-1].tri[2][2] = node_on_trace[1];
       }
       else if(status == 4){
         for(j = 0; j<2 ; j++){
           if(tr[nodes_on_trace[j]-1] != queue_temp[0][1]){
             for(i = 0; i < node[tr[nodes_on_trace[j]-1]-1]; i++){
               if(node[tr[nodes_on_trace[j]-1]-1].triangles[i] != id_tri &&
                  triangle[node[tr[nodes_on_trace[j]-1]-1].triangles[i]][9] == -1)
                  int queue_size = queue_temp.size();
                  queue_temp.resize(queue_size+1);
                  queue_temp[queue_temp.size()][0] =
                        node[tr[nodes_on_trace[j]-1]-1].triangles[i];
                 queue_temp[queue_temp.size()][1] = tr[nodes_on_trace[j]-1];

                 triangle[node[tr[nodes_on_trace[j]-1]-1].triangles[i]][9] = -4;
             }
           }
         }
       }






      }



    }






  }



}
