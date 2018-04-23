#include "global_variables.h"
#include "functions.h"

void ricerca_triangolo(int id_t){
/*
%suppongo che la matrice 'triangle' abbia 6 colonne: dalla 4 alla 6
%contenenti gli status dei lati. Status sconociuto: -1
*/
int found = 0;
int id_tri = 1; //id del triangolo in esame
double s_temp[2] = {0,0}; //le coordinate curvilinee dell'eventuale intersezione
int tr[6] = {0,0,0,0,0,0}; // info sul triangolo corrente
int side[3] = {0,0,0}; //semipiani di appartenenza dei tre vertici
int called_which_side[3]; //vettore che ci dice se abbiamo chiamato la
                                    // funzione which_side
                                    // 0---> no chiamata
                                    // 1---> si chiamata
int status[2] = {0,0}; //status delle eventuali intersezioni con due lati di un
                       // triangolo

int points_to_check[2][2] = {{0,0},{0,0}};
int edges_to_check[2] = {0,0};
int node_on_trace = 0; //indica nodo su traccia
int nodes_on_trace[2] = {0,0};
int sum = 0;
int lonely_point;
//prima parte di ricerca
while(id_tri<=n_triangles && found==0){
  for(int j = 0; j<2;j++){
    called_which_side[j] = 0;
  }
  for(int i = 0; i<6; i++){
    tr[i] = triangle[id_tri][i];
  }
  for(int i = 0; i<3; i++){
    if(node[tr[i]].side == 0){
      //N.B Which side ritorna side,status
      std::pair<int,int> return_which = which_side(id_t,tr[i]);
      node[tr[i]].side = return_which.first;
      called_which_side[i] = 1;
    }
    else{
      side[i] = node[tr[i]].side;
        }


  }

  if(side[0] != side[1] || side[1] != side[2] ){//potrebbero incrociarsi
    sum = side[0]+side[1]+side[2];

    //-------NESSUN VERTICE SULLA TRACCIA---------
    if(sum == -1 !! sum == 1){
      /*
       %capire quali sono i due lati da controllare
       %points_to_check(i,:) sono i due punti di edges_to_check(i)
       % in points_to_check(i,1) ci metto il vertice in
       % comune
      */

      //DOMANDA IMPORTANTE: DEVO TOGLIERE UNO ANCHE DA RIGA 63 64 4 70?
      // e dalle successive nello stesso modo??? HELPPPP
      if( side[0] == side[1]){
        edges_to_check[1] = 5;
        edges_to_check[0] = 4;

        points_to_check[1][0]=tr[2];
        points_to_check[1][1]=tr[0];
        points_to_check[1][1]=tr[2];
        points_to_check[0][1]=tr[1];
        lonely_point = 3;
      }
      else if( side[1] == side[2] ){
        edges_to_check[0] = 5;
        edges_to_check[1] = 6;
        points_to_check[0][0]=tr[0];
        points_to_check[0][1]=tr[2];
        points_to_check[1][0]=tr[0];
        points_to_check[1][1]=tr[1];
        lonely_point = 1;
      }
      else{//side(1) == side(3)
        edges_to_check[1] = 4;
        edges_to_check[0] = 6;
        points_to_check[1][0]=tr[1];
        points_to_check[1][1]=tr[0];
        points_to_check[0][0]=tr[1];
        points_to_check[0][1]=tr[2];
        lonely_point = 2;

      }
      /*
      Per ora s_temp non contiene info utili, se li status saranno positivi
      allora verranno salvati permanentmente
      */
      for(int i = 0; i<2; i++){
        if(tr[edges_to_check[i]] == -1){
          std::pair<int,double> return_intersect =
          intersect(id_t,points_to_check[i][0],points_to_check[i][1]);
          tr[edges_to_check[i]] = return_intersect.first;
          s_temp[i] = return_intersect.second;

          //salvo le informazioni nella variabile globale.
          triangle[id_tri][edges_to_check[i]] = tr[edges_to_check[i]];

          //salvo lo status anche nel triangolo vicino
          for(int j = 0; j<3; j++){
            if(neigh[id_tri][edges_to_check[i]-3][j] != -1){
              if(neigh[neigh[id_tri][edges_to_check[i]-3][j]] == id_tri){
                triangle[neigh[id_tri][edges_to_check(i)-3][j+3]]=tr[edges_to_check[i]];
              }
            }
          }
        }

      }
      //tr(edges_to_check([1 2])) contiene i due status
      status[0] = tr[edges_to_check[0]];
      status[1] = tr[edges_to_check[1]];
      if (status[0] != 0 || status[1] != 0){
        //IL TRIANGOLO E' SICURAMENTE TAGLIATO
        found = 1;
        info_trace[id_t].cut_tri[0].id = id_tri;
        triangle[id_tri][6] = 0;
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
            
          }
        }
      }

    }

  }









}




}
