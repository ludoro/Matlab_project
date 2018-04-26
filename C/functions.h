#ifndef FUNCTIONS_H
#define FUNCTIONS_H
#include <utility>

// returning side,s
std::pair<int,int> which_side(int id_t,int p);

// returning status and s
// Attenzione, s potrebbe essere int ma c'è autocasting, cioè:
// int a = 1, double b = 1.00000000 ----> a == b grazie a dio
std::pair<int, double> intersect(int id_t, int p_1, int p_2);
void enqueue_tri_to_check(int id_tri);
void edges_for_node();
void triangles_for_node();
void ricerca_triangolo(int id_t);
void toll_for_node();
void it_is_near();
void it_is_cut();

#endif
