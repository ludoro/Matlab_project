#include "global_variables.h"
#include "functions.h"

void finding_first_triangle(int id_t){
/*
%suppongo che la matrice 'triangle' abbia 6 colonne: dalla 4 alla 6
%contenenti gli status dei lati. Status sconociuto: -1
*/
id_t = id_t -1;
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
    tr[i] = triangle[id_tri][i];
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
          triangle[id_tri][points_together[i]+3-1] = tr[points_together[i]+3-1];
          triangle[id_tri][points_together[i]+6-1] = s_temp[i];

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


        /*
        Mettiamo info dei punto del triangolo che stiamo considerando in info
        trace.
        */
        for(int j = 0; j<3; j++){
          info_trace[id_t].cut_tri[0].points[j][0] = node[tr[j]].x;
          info_trace[id_t].cut_tri[0].points[j][1] = node[tr[j]].y;

        }

        if(status[0] == 0 && status[1] == 2){
          //la s che ci interessa è in s_temp(2)
          info_trace[id_t].s = s_temp[1];
          //Dobbiamo capire se vale 0 o 1, per inserire le coordinate del quarto
          // punto.
          if(s_temp[1] == 0){
            //è il primo punto della traccia
            for(int k=0;k<2;k++){
              info_trace[id_t].cut_tri[0].points[3][k] =
                            trace_vertex[trace[id_t][0]][k];
            }
        else{//s_temp(2) ==1;
          for(int k=0;k<2;k++){
            info_trace[id_t].cut_tri[1].points[3][k] =
                          trace_vertex[trace[id_t][1]][k];
          }

        }

          }

          info_trace[id_t].cut_tri[0].poly_1[0] = edges_to_check[1]-3;
          info_trace[id_t].cut_tri[0].poly_1[1] = 4;
          info_trace[id_t].cut_tri[0].poly_1[2] = (edges_to_check(1) + 2)%3;

          info_trace[id_t].cut_tri[0].poly_2[0]=edges_to_check[1]-3;
          info_trace[id_t].cut_tri[0].poly_2[1]=4;
          info_trace[id_t].cut_tri[0].poly_2[2]=(edges_to_check[2]+2)%3;

          if(info_trace[id_t].cut_tri[0].poly_1[1] == 0){
            info_trace[id_t].cut_tri[0].poly_1[1] = 3;
          }
          if(info_trace[id_t].cut_tri[0].poly_2[2]==0){
            info_trace[id_t].cut_tri[0].poly_2[2] = 3;
          }
          /*INSERIAMO INFO PER TRIANGOLAZIONE, IN QUESTO CASO COINCIDE CON I DUE
          POLIGONI*/
          for(int k = 0; k < 3; k++){
            info_trace[id_t].cut_tri[0].tri[0][k] =
                              info_trace[id_t].cut_tri[0].poly_1[k];
            info_trace[id_t].cut_tri[0].tri[1][k] =
                              info_trace[id_t].cut_tri[0].poly_2[k];

          }

          //FUNZIONE PER TRIANGOLI VICINI
          enqueue_tri_to_check(id_tri);
        }
          else if(status[0] == 2 && status[1] == 0){
            // la s che ci interssa è in s_temp(1)
            info_trace[id_t].s = s_temp[0];
            //dobbiamo capire se vale 0 o 1, per inserire le coordinate
            // del quarto punto
            if(s_tempo[0] == 0){
              for(int k = 0; k<2 ; k++){
              info_trace[id_t].cut_tri[0].points[3][k] =
                        trace_vertex[trace[id_t][0]][k];
                      }
            }
            else{
              for(int k = 0; k<2 ; k++){
              info_trace[id_t].cut_tri[0].points[3][k] =
                        trace_vertex[trace[id_t][1]][k];
              }
            }
            info_trace[id_t].cut_tri[0].poly_1[0]= edges_to_check(0)-3;
            info_trace[id_t].cut_tri[0].poly_1[1]=(edges_to_check[0]+1)%3;
            info_trace[id_t].cut_tri[0].poly_1[2]=4;

            info_trace[id_t].cut_tri[0].poly_2[0]=edges_to_check(1)-3;
            info_trace[id_t].cut_tri[0].poly_2[1]=4;
            info_trace[id_t].cut_tri[0].poly_2[2]=(edges_to_check[0]+2)%3;

            if(info_trace[id_t].cut_tri[0].poly_1[1] == 0){
              info_trace[id_t].cut_tri[0].poly_1[1] = 3;
            }
            if(info_trace[id_t].cut_tri[0].poly_2[2] == 0){
              info_trace[id_t].cut_tri[0].poly_2[2] = 3;
            }
            //inseriamo info per la triangolazione
            //in questo caso la triangolazione coincide con i due POLIGONI

            for(int k = 0; k < 3; k++){
              info_trace[id_t].cut_tri[0].tri[0][k] =
                                info_trace[id_t].cut_tri[0].poly_1[k];
              info_trace[id_t].cut_tri[0].tri[1][k] =
                                info_trace[id_t].cut_tri[0].poly_2[k];

            }

            //FUNZIONE PER TRIANGOLI VICINI
            enqueue_tri_to_check(id_tri);
          }

          else{// 3 triangoli nella triangolazione
            //richiamo intersect nello status==0, perchè potrei non
            // conoscere la coordinata curvilinea
            for(int i = 0; i <2; i++){
              if(status[i]==0){
                std::pair<int, double> return_intersect =
                                        intersect(id_t,points_to_check[i][0],
                                                  points_to_check[i][1]);
              int a = return_intersect.first;
              s_temp[i] = return_intersect.second;
              if ( a != 0){
                printf("ERRORE");
              }

              }
            }
            // metto ascisse curvilinee dentro info_trace
            for(int i = 0; i<2; i++){
              if(s_temp[i] <= 1 && s_temp[i] >= 0){
                info_trace[id_t].s.resize((info_trace[id_t].s).size() + 1));
                info_trace[id_t].s[info_trace[id_t].s.size()] = s_temp[i];
              }
            }
            //trovo coordinate punti intersezione traccia segmento
            for(int i = 0; i<2; i++){

            }
          }

      }

    }

  }









}




}
