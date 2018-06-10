function [] = show_shared(id_f,id_tet_near)

global info_fract;

show_single_tet(info_fract(id_f).near_tet(id_tet_near).id,0)

for i = 1:length(info_fract(id_f).near_tet(id_tet_near).points)
    id_point = info_fract(id_f).near_tet(id_tet_near).points(i);
    show_node(id_point);
    hold on
end

for i = 1:length(info_fract(id_f).near_tet(id_tet_near).edges)
    id_edge = info_fract(id_f).near_tet(id_tet_near).edges(i);
    show_edge(id_edge);
    hold on;
end

for i = 1:length(info_fract(id_f).near_tet(id_tet_near).faces)
    id_face = info_fract(id_f).near_tet(id_tet_near).faces(i);
    show_face(id_face);
    hold on
end