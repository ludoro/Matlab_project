#ifndef GLOBAL_VARIABLES_H_
#define GLOBAL_VARIABLES_H_

#include <vector>
extern int n_nodes;
extern int n_triangles;
extern int n_edges;
extern int n_neigh;
extern int n_traces;
extern int n_trace_vertex;
extern double accuracy;

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

extern std::vector<std::vector<int> > triangle;

extern std::vector<std::vector<int> > edge;

extern std::vector<std::vector<int> > neigh;

extern std::vector<std::vector<double> > trace_vertex;

extern std::vector<std::vector<int> > trace;

extern std::vector<std::vector<double> > T;

extern std::vector<double> T_squared;

extern std::vector<double> toll_t;

extern std::vector<std::vector<int> > queue;

#endif
