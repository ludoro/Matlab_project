#include "global_variables.h"
#include "functions.h"

void saving_in_neigh(){
  for( int j = 0; j < 3; j++){
    if(neigh[neigh[id_tri-1][points_together[i]-1][j] == id_tri ){
      triangle[neigh[id_tri][points_together[i]-1]][j+3] =
                            tr[points_together[j]+3-1];
      triangle[neigh[id_tri-1][points_together[i]-1]][j+6] = s_temp[i];
    }
  }
}
