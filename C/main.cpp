
#include <stdio.h>
#include <Eigen/Dense>
#include <iostream>

int main(){

  Eigen::Matrix3f m;
  m << 1, 2, 3,
       4, 5, 6,
       7, 8, 9;
  std::cout << m;



  return 0;
}
