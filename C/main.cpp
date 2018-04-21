#include <stdio.h>
#include <iostream>
#include "global_variables.h"
#include "file_reading.h"

int main(){
  load_max_numbers();
  load_matrices();
  for(int i = 0; i< n_nodes; i++){
    printf("%f", node[i].x);
  }
  return 0;
}
