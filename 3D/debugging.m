file_reading;
fract_vertex = [0 0 0;
                1 0 0;
                1 1 0;
                0 1 0];            
fract(1).P = [1,2,3,4];
global_toll;
edges_for_node;
tets_for_node;
faces_for_tet;
edges_for_tet;
computing_fract_plane;
% for i = 1:4
% node_plane(i).coord = fract_vertex(i,1:2) + [10 0];
% end
node_plane(1).coord = [1,1];
node_plane(2).coord = [0.5,1.5];
node_plane(3).coord = [-0.5,0.5];
node_plane(4).coord = [0.3,-0.3];
for i = 1:4
    node_plane(i).in_info = -1;
    node_plane(i).is_out = -1;
    node_plane(i).from_edge = 1;
end
output = intersect_3D(1,[1,2,3,4],[0,0,0,0]);