#include <stdio.h>
#include <iostream>
#include <Eigen/Dense>

void load_matrix() {
  int x, y;
  ifstream input("prova_input.txt");

  if (!input) {
    cout << "Cannot open file.\n";
    return;
  }

  for (y = 0; y < 3; y++) {
    for (x = 0; x < 3; x++) {
      input >> A[x][y];
    }
  }

  input.close();
}
