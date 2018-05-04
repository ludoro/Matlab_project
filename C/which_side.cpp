#include <utility>
#include "global_variables.h"
#include <math.h>

// returning side, s
std::pair<int,int> which_side(int id_t,int p){
  id_t = id_t - 1;
  p = p - 1;
  double v[2];
  double N[2];
  double scalar;
  double norm_N_1;
  double dot;
  int side;
  int s;
  double ss;
  v[0] = node[p].x - trace_vertex[trace[id_t][0]][0] ;
  v[1] = node[p].y - trace_vertex[trace[id_t][0]][1];
  N[0] = -T[id_t][1];
  N[1] = T[id_t][1];
  dot = v[0]*N[0] + v[1]*N[1];
  norm_N_1 = abs(N[0]) + abs(N[1]);
  scalar = dot/norm_N_1;
  if(scalar < -node[p].toll){
    side = -1;
    s = 0;
  }
  else if(scalar > node[p].toll){
    side = 1;
    s = 0;
  }
  else{
    side = 2;
  }
  ss = ((T[id_t][0]*v[0])+T[id_t][1]*v[1])/T_squared[id_t];
  if (s <= toll_t[id_t] && s >= -toll_t[id_t] ){
    s = 0;
  }
  else{
    s = 1;
  }
  return std::make_pair(side,s);
}
