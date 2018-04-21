#ifndef GLOBAL_VARIABLES_H_
#define GLOBAL_VARIABLES_H_

#include <vector>
extern int n_nodes;
extern int n_triangles;
extern int n_edges;
extern int n_neigh;
extern int n_traces;

struct NODE{
    double x;
    double y;
    int side;
    double toll;
    int edges[3];
    int triangles[2];
    int tot_edges;
    int tot_triangles;
    int s;
};

extern std::vector<NODE> node;



#endif
