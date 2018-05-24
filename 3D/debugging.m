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
for i = 1:4
node_plane(i).coord = fract_vertex(i,[1:2]) + [10 0];
end


