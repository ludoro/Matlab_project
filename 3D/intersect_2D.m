function [P_intersect,n_intersections,edge_intersection_1,edge_intersection_2]... 
            = intersect_2D(id_f,p_1,p_2) 
% p_1 e p_2 sono gli indici di nodeplane
% P_intersect matrice 2x2 di coordinate di punti di intersezione
global fract;
global fract_vertex;
global toll;
global node_plane;


if(is_empty(node_plane(p_1).sides) || is_empty(node_plane(p_1).sides))
    disp('Big problem in intersect_2D');
end

side = [0,0];
for id_t = 1:fract(id_f).n_points
    side(1) = node_plane(p_1).sides(id_t);
    side(2) = node_plane(p_2).sides(id_t);
    if(side(1) ~= side(2))
        
        
    end
    
    
end



end
