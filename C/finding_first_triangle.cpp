#include "global_variables.h"
#include "functions.h"

void finding_first_triangle(int id_t){
/*
%suppongo che la matrice 'triangle' abbia 6 colonne: dalla 4 alla 6
%contenenti gli status dei lati. Status sconociuto: -1
*/
id_t = id_t -1;
int num_tri_checked;
int found = 0;
int id_tri = 1;
double s_temp[2] = {0,0}; //le coordinate curvilinee dell'eventuale intersezione
int tr[10] = {0,0,0,0,0,0,0,0,0,0}; // info sul triangolo corrente
int side[3] = {0,0,0}; //semipiani di appartenenza dei tre vertici
int called_which_side[3]; //vettore che ci dice se abbiamo chiamato la
                                    // funzione which_side
                                    // 0---> no chiamata
                                    // 1---> si chiamata
int status[2] = {0,0}; //status delle eventuali intersezioni con due lati di un
                       // triangolo
int node_on_trace = 0; //indica nodo su traccia
int nodes_on_trace[2] = {0,0};
int sum = 0;
int lonely_point;
int points_together[2] = {0,0};

//prima parte di ricerca
while(id_tri<=n_triangles && found==0){
  for(int j = 0; j<3; j++){
    called_which_side[j] = 0;
  }
  for(int i = 0; i<6; i++){
    tr[i] = triangle[id_tri-1][i];
  }
  for(int i = 0; i<3; i++){
    if(node[tr[i]-1].side == 0){
      //N.B Which side ritorna side,status
      std::pair<int,int> return_which = which_side(id_t,tr[i]);
      node[tr[i]-1].side = return_which.first;
      called_which_side[i] = 1;
    }
    else{
      side[i] = node[tr[i]-1].side;
        }


  }

  if(side[0] != side[1] || side[1] != side[2] ){//potrebbero incrociarsi
    sum = side[0]+side[1]+side[2];

    //-------NESSUN VERTICE SULLA TRACCIA---------
    if(sum == -1 !! sum == 1){
      // capire quali sono i due lati da controllare


      if( side[0] == side[1]){
        points_together[0] = 1;
        points_together[1] = 2;
        lonely_point = 3;

      }
      else if( side[1] == side[2] ){
        points_together[0] = 2;
        points_together[1] = 3;
        lonely_point = 1;

      }
      else{//side(1) == side(3)
        points_together[0] = 3;
        points_together[1] = 1;
        lonely_point = 2;
      }
      /*
      Per ora s_temp non contiene info utili, se li status saranno positivi
      allora verranno salvati permanentmente
      */
      for(int i = 0; i<2; i++){
        if(tr[points_together[i]+3-1] == -1){
          std::pair<int,double> return_intersect =
          intersect(id_t,tr[lonely_point-1],tr[points_together[((i+1)%2)]-1]);
          tr[points_together[i]+3-1] = return_intersect.first;
          s_temp[i] = return_intersect.second;

          //salvo le informazioni nella variabile globale.
          triangle[id_tri-1][points_together[i]+3-1] = tr[points_together[i]+3-1];
          triangle[id_tri-1][points_together[i]+6-1] = s_temp[i];

          //salvo lo status anche nel triangolo vicino
          saving_in_neigh();
        }
        else{
          s_temp[i] = tr[points_together[i]+6-1];
        }

      }

      //tr(edges_to_check([1 2])) contiene i due status
      status[0] = tr[points_together[0]+3-1];
      status[1] = tr[points_together[1]+3-1];
      if (status[0] != 0 || status[1] != 0){
        //IL TRIANGOLO E' SICURAMENTE TAGLIATO
        found = 1;
        it_is_cut();
        enqueue_tri_to_check(id_tri);
        if( (status[0] == 0 && status[1] == 2) ||
            (status[1] == 0 && status[0] == 2) ){

              if(status[0] == 0 && status[1] == 2){
                int a = 2;
              }
              else{
                int a = 1;
              }
              info_trace[id_t].s.resize(info_trace[id_t].s.size()+1);
              info_trace[id_t].s[info_trace[id_t].s.size()-1] = s_temp[a-1];

              if(s_temp[a-1] == 0){
                for(int k = 0; k < 2; k++){
                  info_trace[id_t].cut_tri[0].points[3][k]=
                  trace_vertex[trace[id_t][0]]][k];
                }
              }
              else{
                for(int k = 0; k < 2; k++){
                  info_trace[id_t].cut_tri[0].points[3][k]=
                  trace_vertex[trace[id_t][1]]][k];
                }

              }

              info_trace[id_t].cut_tri[0].poly_1[0] = 1;
              info_trace[id_t].cut_tri[0].poly_1[0] = 2;
              info_trace[id_t].cut_tri[0].poly_1[0] = 3;
              info_trace[id_t].cut_tri[0].poly_1[0] = 0;

              if(a == 1){
                info_trace[id_t].cut_tri[0].tri[0][0] = points_together[a-1];
                info_trace[id_t].cut_tri[0].tri[0][1] = points_together[a+1-1];
                info_trace[id_t].cut_tri[0].tri[0][2] = 4;

                info_trace[id_t].cut_tri[0].tri[1][0] = points_together[a-1];
                info_trace[id_t].cut_tri[0].tri[1][1] = 4;
                info_trace[id_t].cut_tri[0].tri[1][2] = lonely_point;
              }
              else{
                info_trace[id_t].cut_tri[0].tri[0][0] = points_together[a-1-1];
                info_trace[id_t].cut_tri[0].tri[0][1] = points_together[a+1-1];
                info_trace[id_t].cut_tri[0].tri[0][2] = 4;

                info_trace[id_t].cut_tri[0].tri[1][0] = points_together[a-1];
                info_trace[id_t].cut_tri[0].tri[1][1] = 4;
                info_trace[id_t].cut_tri[0].tri[1][2] = lonely_point;

              }



            }
            else{//tre triangoli nella triangolazione
                for(int i = 0; i <2; i++){
                  if(s_temp[i] <= 1 && s_temp[i] >= 0){
                    info_trace[id_t].s.resize(info_trace[id_t].s.size()+1);
                    info_trace[id_t].s[info_trace[id_t].s.size()-1] = s_temp[i];
                  }
                }

                for(int i = 0; i<2; i++){
                  info_trace[id_t].cut_tri[0].points[i+3,i] =
                  trace_vertex[trace[id_t][0]][i] + s_temp[i]*
                  trace_vertex[trace[id_t][1]][i] -
                  trace_vertex[trace[id_t][0]][i];
                }

                info_trace[id_t].cut_tri[0].poly_1[0] = points_together[0];
                info_trace[id_t].cut_tri[0].poly_1[1] = points_together[1];
                info_trace[id_t].cut_tri[0].poly_1[2] = 4;
                info_trace[id_t].cut_tri[0].poly_1[3] = 5;

                info_trace[id_t].cut_tri[0].poly_2[0] = 4;
                info_trace[id_t].cut_tri[0].poly_2[1] = lonely_point;
                info_trace[id_t].cut_tri[0].poly_1[2] = 5;

                info_trace[id_t].cut_tri[1].tri[0][0] = 4;
                info_trace[id_t].cut_tri[1].tri[0][1] = lonely_point;
                info_trace[id_t].cut_tri[1].tri[0][2] = 5;

                info_trace[id_t].cut_tri[1].tri[1][0] = points_together[0];
                info_trace[id_t].cut_tri[1].tri[1][1] = points_together[1];
                info_trace[id_t].cut_tri[1].tri[1][2] = 5;
            }
          }

        else if(sum == 0 || sum == 4){
          for(int i = 0; i < 3; i++){
            if(side[i] == 2){
              s_temp[0] = node[tr[i]-1].s;
              node_on_trace = i;
            }
          }

          if(s_temp[0] >= 0 && s_temp[0] <= 1){
            found = 1;
            if(called_which_side[node_on_trace-1] == 1){
              info_trace[id_t].s.resize(info_trace[id_t].s.size()+1);
              info_trace[id_t].s[info_trace.s.size()-1] = s_temp[i];
            }
            for(int i = 0; i < node[tr[node_on_trace]-1].tot_triangles; i++){
              if(node[tr[node_on_trace]-1].triangles[i] != id_tri){
                queue_temp.resize(queue_temp.size()+1);
                queue_temp[queue_temp.size()-1][0] =
                          node[tr[node_on_trace-1]-1].triangles[i];
                queue_temp[queue_temp.size()-1][1] = tr[node_on_trace-1];
                triqangle[node[tr[node_on_trace-1]-1].triangles[i]][9] = -4;
              }

            }

          }


        }
        else if(sum==2){
          if(side[0] == 2){
            node_on_trace = 1;
            opposite_nodes[0] = 2;
            opposite_nodes[1] = 3;
          }
          else if(side[1] == 2){
            node_on_trace = 1;
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
            intersect(id_t,tr[opposite_nodes[0]-1],tr[opposite_nodes[1]-1])
            tr[node_on_trace+3-1] = return_intersect.first;
            s_temp[1] = return_intersect.second;

            for(int j = 0; j < 3; j++){
              if(neigh[id_tri-1][node_on_trace-1] != -1){
                if(neigh[neigh[id_tri-1][node_on_trace-1]][j] == id_tri){
                  triangle[neigh[id_tri-1][node_on_trace-1]][j+3] =
                          tr[node_on_trace+3-1];
                  triangle[neigh[id_tri-1][node_on_trace-1]][j+6] =
                          s_temp[1];
                }
              }
            }
          }
          s_temp[0] = node[tr[node_on_trace-1]-1].s;
          if((s_temp[0]>0) && s_temp[0] < 1) || (tr[node_on_trace+3-1] != 0)){
            found = 1;
            it_is_cut;
            for(int k = 0; k<2; k++){
              info_trace[id_t].cut_tri[0].points[3][k] =
              trace_vertex[trace[id_t][0]][k] + s_temp[1]*
              trace_vertex[trace[id_t][1]][k] -
              trace_vertex[trace[id_t][0]][k];
            }
            info_trace.cut_tri[0].poly_1[0] = node_on_trace;
            info_trace.cut_tri[0].poly_1[1] = opposite_nodes[0];
            info_trace.cut_tri[0].poly_1[2] = 4;
            info_trace.cut_tri[0].poly_1[3] = 0;

            info_trace.cut_tri[0].poly_2[0] = node_on_trace;
            info_trace.cut_tri[0].poly_2[1] = 4;
            info_trace.cut_tri[0].poly_2[2] = opposite_nodes[1];

            info_trace[id_t].cut_tri[0].tri[0][0] = node_on_trace;
            info_trace[id_t].cut_tri[0].tri[0][1] = opposite_nodes[0];
            info_trace[id_t].cut_tri[0].tri[0][2] = 4;

            info_trace[id_t].cut_tri[0].tri[1][0] = node_on_trace;
            info_trace[id_t].cut_tri[0].tri[1][1] = 4;
            info_trace[id_t].cut_tri[0].tri[1][2] = opposite_nodes[1];
          }
          enqueue_tri_to_check(id_tri);

          if(s_temp[0] <= 1 && s_temp[0] >= 0 &&
             called_which_side[node_on_trace-1] == 1){

               info_trace[id_t].s.resize(info_trace[id_t].s.size()+1);
               info_trace[id_t].s[info_trace[id_t].size()-1] = s_temp[1];
             }



        }

        else{//sum==3 || sum == 5
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

          for(int i = 0; i<2; i++){
            if(s_temp[i] <= 1 && s_temp[i] >= 0 &&
               called_which_side[nodes_on_trace[i]-1] == 1){
                 info_trace[id_t].s.resize(info_trace[id_t].size()+1);
                 info_trace[id_t].s[info_trace[id_t].s.size()-1] = s_temp[i];
               }
          }

          if(tr[lonely_point+3-1] == -1){
            std::pair<int,double> return_intersect =
            intersect(id_t,tr[nodes_on_trace[0]-1],tr[nodes_on_trace[1]-1]);
            tr[lonely_point+3-1] = return_intersect.first;
            s_intersect = return_intersect.second;
            triangle[id_tri-1][lonely_point+3-1] = tr[lonely_point+3-1];
            triangle[id_tri-1][lonely_point+6-1] = s_intersect;

            for(int j = 0; j < 3; j++){
              if(neigh[id_tri-1][lonely_point-1] != -1){
                if(neigh[neigh[id_tri-1][lonely_point-1]][j] == id_tri){
                  triangle[neigh[id_tri-1][lonely_point-1]][j+3] =
                  tr[lonely_point+3-1];
                  triangle[neigh[id_tri-1][lonely_point-1]][j+6] =
                  s_intersect;
                }
              }
            }
          }

          status[0] = tr[lonely_point+3-1];

          if(status[0] == 2){
            found = 1;
            it_is_cut();
            info_trace[id_t].s.resize(info_trace[id_t].s.size()+1);
            info_trace[id_t].s[info_trace[id_t].s.size()-1] = s_intersect;
            enqueue_tri_to_check(id_tri);

            if(s_intersect == 0){
              for(int k = 0; k<2; k++){
              info_trace[id_t].cut_tri[0].points[3][k] =
              trace_vertex[trace[id_t][0]][k];
              }
            }
          else{
            for(int k = 0; k<2; k++){
            info_trace[id_t].cut_tri[0].points[3][k] =
            trace_vertex[trace[id_t][1]][k];
            }
          }
          info_trace[id_t].cut_tri[0].poly_1[0] = 1;
          info_trace[id_t].cut_tri[0].poly_1[1] = 2;
          info_trace[id_t].cut_tri[0].poly_1[2] = 3;
          info_trace[id_t].cut_tri[0].poly_1[3] = 0;

          info_trace[id_t].cut_tri[0].tri[0][0] = lonely_point;
          info_trace[id_t].cut_tri[0].tri[0][1] = nodes_on_trace[0];
          info_trace[id_t].cut_tri[0].tri[0][2] = 4;

          info_trace[id_t].cut_tri[0].tri[1][0] = lonely_point;
          info_trace[id_t].cut_tri[0].tri[1][1] = 4;
          info_trace[id_t].cut_tri[0].tri[1][2] = nodes_on_trace[1];
          }
          else if(status[0] == 5){
            found = 1;
            it_is_cut();
            info_trace[id_t].s[0] = 0;
            info_trace[id_t].s[1] = 1;

            if(s_temp[0] < 0){
              for(int k = 0; k<2; k++){
              info_trace[id_t].cut_tri[0].points[3][k] =
              trace_vertex[trace[id_t][0]][k];
              info_trace[id_t].cut_tri[0].points[4][k] =
              trace_vertex[trace[id_t][1]][k];
              }
            }
            else{
              for(int k = 0; k<2; k++){
              info_trace[id_t].cut_tri[0].points[3][k] =
              trace_vertex[trace[id_t][1]][k];
              info_trace[id_t].cut_tri[0].points[4][k] =
              trace_vertex[trace[id_t][0]][k];
              }
            }
            info_trace[id_t].cut_tri[0].poly_1[0] = 1;
            info_trace[id_t].cut_tri[0].poly_1[1] = 2;
            info_trace[id_t].cut_tri[0].poly_1[2] = 3;
            info_trace[id_t].cut_tri[0].poly_1[3] = 0;

            info_trace[id_t].cut_tri[0].tri[0][0] = lonely_point;
            info_trace[id_t].cut_tri[0].tri[0][1] = nodes_on_trace[0];
            info_trace[id_t].cut_tri[0].tri[0][2] = 4;

            info_trace[id_t].cut_tri[0].tri[1][0] = lonely_point;
            info_trace[id_t].cut_tri[0].tri[1][1] = 4;
            info_trace[id_t].cut_tri[0].tri[1][2] = 5;

            info_trace[id_t].cut_tri[0].tri[2][0] = lonely_point;
            info_trace[id_t].cut_tri[0].tri[2][1] = 5;
            info_trace[id_t].cut_tri[0].tri[2][2] = nodes_on_trace[1];

            enqueue_tri_to_check(id_tri);
          }
          else if(status[0] == 4){
            found = 1;
            for(int j = 0; j<2; j++){
              for(int i = 0; i< node[tr[nodes_on_trace[j]-1]-1].tot_triangles){
                if(node[tr[nodes_on_trace[j]-1]-1].triangles[i] != id_tri &&
                triangle[node[tr[nodes_on_trace[j]-1]-1].triangles[i]][9] ==-1){
                  queue_temp.resize(queue_temp.size()+1);
                  queue_temp[queue_temp.size()-1][0] =
                                  node[tr[nodes_on_trace[j]-1]-1];
                  queue_temp[queue_temp.size()-1][1] = tr[nodes_on_trace[j]-1];

                }
              }
            }
          }
        }

      }
    }
    id_tri = id_tri+1;
  }
num_tri_checked= id_tri -1;
}
