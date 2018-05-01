#ifndef FUNCTIONS_H
#define FUNCTIONS_H
#include <utility>

void checking_queue_temp();
void edges_for_node();
void enqueue_tri_to_check(int id_tri);
void finding_all_the_others(int id_t);
void finding_first_triangle(int id_t);

// returning status and s
// Attenzione, s potrebbe essere int ma c'è autocasting, cioè:
// int a = 1, double b = 1.00000000 ----> a == b grazie a dio
std::pair<int, double> intersect(int id_t, int p_1, int p_2);
void it_is_cut();
void it_is_near();
void saving_in_neigh();
void toll_for_node();
void triangles_for_node();

// returning side,s
std::pair<int,int> which_side(int id_t,int p);









#endif
