function [] = show_intersection(id_f,e)
P = [0,0,0];
global coord_to_use;
[P(coord_to_use(id_f,:)),...
 P(6-coord_to_use(id_f,1)-coord_to_use(id_f,2))] = intersect_plane_edge(id_f,e);
plot3(P(1),P(2),P(3),'Marker','p');
end

