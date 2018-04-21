#include <utility>
#include <math.h>
#include "global_variables.h"
// returning status and s
// Attenzione, s potrebbe essere int ma c'è autocasting, cioè:
// int a = 1, double b = 1.00000000 ----> a == b grazie a dio
/*
status:
% 0 ---> non si intersecano
% 1 ---> caso a croce
% 2 ---> traccia muore dentro il segmento
% 3 ---> segmento muore dentro traccia oppure si toccano negli estremi
% 4 ---> segmento completamente interno alla traccia, questo comprende
%        anche il caso in cui siano esattamente coincidenti.
% 5 ---> traccia completamente interna al segmento
*/
// returning status and s
std::pair<int, double> intersect(int id_t, int p_1, int p_2){
/*
  %prima di intersect bisogna chiamare la funzione "which_side" per ogni
  %vertice del triangolo in analisi. Diamo per scontato che side sia
  %conosciuto, quindi che node().side sia diverso da 0.
*/
int status;
double s;
double toll_trace = toll_t[id_t];
int prodotto = node[p_1].side*node[p_2].side;

if(prodotto == 1){
  s = 0;
  status = 666;
}
else if(prodotto == -1){
  double A[2][2];
  A[0][0] = node[p_2].x - node[p_1].x;
  A[0][1] = -T[id_t][1];
  A[1][0] = node[p_2].y - node[p_1].y;
  A[1][1] = -T[id_t][2];
  double b[2];
  b[0] = trace_vertex[trace[id_t][1]][1] - node[p_1].x;
  b[1] = trace_vertex[trace[id_t][1]][2] - node[p_1].y;
  double st[2];

  //st = A\b IMPLEMENTARE METODO GAUSS QUI (O USARE LIBRERIA ESTERNA?)
  s = st[1];

if((s < -toll_trace) || (s>1 + toll_trace)){
    // non c'è intersezione, quindi status = 0.
    status = 0;
  }
else if(s <= +toll_trace && s>= -toll_trace){
    //la traccia muore nel segmento in un punto singolo
    status = 2;
    s = 0;
}
else if(s < 1 - toll_trace && s > toll_trace){
    //intersezione a croce
    status = 1;
}
else{ //s >= 1 - toll_trace && s <= 1 + toll_trace
    //traccia muore dentro il segmento in un punto singolo
    status = 2;
    s = 1;
}
}

else if(prodotto == 4){
  /*Diamo per scontato che il campo s di p_1 e di p_2 contenga dei valori
    %utili, inseriti alla chiamata di which_side, la quale deve già essere
    %stata eseguita.*/

    double s_1 = node[p_1].s;
    double s_2 = node[p_2].s;

    //primo sotto-caso
    if(s_1 < 0){

        if(s_2 < 0){
             //non c'è intersezione perchè sono paralleli ma uno
             //finisce prima
             status = 0;
             s = 666;
           }

        else if(s_2 == 0){
            //segmento e traccia sono adiacenti, c'è intersezione,
            //ma non c'è taglio.
            status = 3;
            s = 0;
          }
        else if(s_2 <= 1 && s_2 > 0){
            //traccia muore dentro il segmento
            s = 0;
            status = 2;
          }
        else{ // s_2 > 1
            //traccia interna al segmento
            status = 5;
            s = 666;
        }
      }

    //secondo sottocaso
    else if(s_1 == 0){

        if(s_2 < 0){
             //segmento e traccia adiacenti
             status = 3;
             s = 0;
           }

        else if(s_2 == 0){
            //segmento dentro punto iniziale traccia
            status = -1;
            printf("I punti %d e %d coincidono con il punto iniziale della traccia", p_1, p_2);
            s = 0;
          }
        else if(s_2 <= 1 && s_2 > 0){
            //segmento interno alla traccia con un estremo o due coincidenti
            s = 666;
            status = 4;
          }
        else {// s_2 > 1
            //traccia tutta interna al segmento, con un estremo coincidente.
            //Intersezione con taglio.
            status = 2;
            s = 1;
          }
        }

    //terzo sottocaso
    else if(s_1 > 0 && s_1 < 1){

        if(s_2 < 0){
           //traccia muore dentro segmento, si taglio
           status = 2;
           s = 0;
         }

        else if(s_2 >= 0 && s_2 <=1){
            //segmento tutto dentro traccia, no taglio
            status = 4;
            s = 666;
          }

        else {//s_2 > 1
            //analogo al caso s_2 < 0, ma dall'altro lato
            status=2;
            s = 1;
          }
        }


    else if(s_1 == 1){

        if(s_2 < 0){
            //traccia tutta dentro, si taglio
            status = 2;
            s = 0;
          }
        else if(s_2 >= 0 && s_2 < 1){

            //segmento completamente interno alla traccia o coincidente, in
            //entrambi i casi non tagliato
            status = 4;
            s = 666;
          }

        else if(s_2 == 1){

            //segmento dentro il punto finale della traccia
            status = -1;
            printf("I punti %d e %d coincidono con il punto finale della traccia", p_1, p_2);
            s = 666;
          }
        else{ //% s_2 > 1
            //adiacenti
            status = 3;
            s = 666;
          }
        }

    else {// s_1 > 1
        if(s_2 < 0){
            //traccia completamente interna
            status = 5;
            s = 666;
          }

        else if(s_2 >= 0 && s_2 < 1){
            //traccia muore dentro il segmento, si taglio
            status = 2;
            s = 1;
          }

        else if(s_2 == 1){
            //traccia e segmento adiacenti, no taglio
            status = 3;
            s = 666;
          }

        else{ // s_2 > 1
            //non si intersecano
            status = 0;
            s = 666;
          }
        }
    }
    else if(prodotto == -2 || prodotto == 2){
      if(node[p_1].side == 2){
          s = node[p_1].s;
        }
      else{
          s = node[p_2].s;
        }
        if(s < 0 || s>1){
        //non c'è intersezione, quindi status = 0.
        status = 0;
          }
        else{ //tutti i casi rimanenti sono accorpati,perchè hanno tutti stat =3

        status = 3;
        }
    }
    else{//prodotto == 0 non dovrebbe succedere
      printf("Errore. node(%d).side = %d e node(%d).side = %d", p_1,node[p_1].side,p_2,node[p_2].side);
      s = 666;
      status = -1;
    }
    return std::make_pair(status,s);
}
