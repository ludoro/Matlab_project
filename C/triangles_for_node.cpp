#include "global_variables.h"

void triangles_for_node(){
  /*
   Inizialmente il tot_triangles è 0
    Scorriamo tutti i triangles e aggiungiamo per tutti i tre nodi dell'
    i_esimo triangolo l'indice del triangolo nel vettore
    node(...).triangles infine aumentiamo il tot_triangles che conta i
    triangoli condivisi.

     N.B.
     "triangle" è la matrice contenente i triangoli e i nodi che la
     costituiscono.
    "triangles" è il campo della struttura "node" che contiene l'indice
    dei triangoli aventi quel nodo come vertice.
  */
  for(int i = 0; i< n_triangles; i++){
    int n_1;
    int n_2;
    int n_3;
    n_1 = node[triangle[i][0]].tot_triangles;
    node[triangle[i][0]].triangles[n_1+1] = i+1;
    node[triangle[i][0]].tot_triangles = n_1 + 1;

    n_2 = node[triangle[i][1]].tot_triangles;
    node[triangle[i][1]].triangles[n_2+1] = i+1;
    node[triangle[i][1]].tot_triangles = n_2 + 1;

    n_3 = node[triangle[i][2]].tot_triangles;
    node[triangle[i][2]].triangles[n_3+1] = i+1;
    node[triangle[i][2]].tot_triangles = n_3 + 1;

  }




}
