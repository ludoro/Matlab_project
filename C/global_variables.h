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
    int side = 0;
    double toll = -1;
    int edges[3] = {0,0,0};
    int triangles[2] = {0,0};
    int tot_edges = 0;
    int tot_triangles = 0;
    int s = 666;
};

extern std::vector<NODE> node;



#endif
