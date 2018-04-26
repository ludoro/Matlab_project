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

//definizione delle strutture che andranno in info_trace
struct NEAR_TRI{
  int id;
  std::vector<int> nodes;
};

struct CUT_TRI{
  std::vector<int> points;
  std::vector<int> poly_1;
  std::vector<int> poly_2;
  std::vector<std::vector<int> > tri;
  int id;
};

struct INFO_TRACE{
  CUT_TRI cut_tri;
  std::vector<double> s;
  NEAR_TRI near_tri;
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

extern std::vector<INFO_TRACE> info_trace;

#endif
