function [it_is_cut] = intersect_3D(id_f,id_node_plane)
%Questa funzione va a riempire info_trace.div
%id_f = id della frattura
%node_plane = i punti di taglio del piano
%id_node_plane = indici da considerare di node plane
global fract_vertex;
global node;
global tet;
global coord_to_use;
global accuracy;
global info_fract;
global fract;
%salvo subito coordinate frattura
F = zeros(fract(id_f).n_points,2);
for i = 1:fract(id_f).n_points
    F(i,:) = fract_vertex(fract(id_f).P(i),coord_to_use(id_f,:));
end
%-----STEP 1-----------
%calcolo del "baricentro" controllo grossolano






end

