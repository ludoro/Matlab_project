function [] = show_shared(id_f,id_tet_near)
global info_fract;
global node;
id_tet = info_fract(id_f).near_tet(id_tet_near).id;
for i = 1:length(info_fract(id_f).near_tet(id_tet_near).points)
    id_point = info_fract(id_f).near_tet(id_tet_near).points(i);
    plot3(node(id_point).coord(1),...
          node(id_point).coord(2),node(id_point).coord(3),...
          'g-p','MarkerSize',10);
      hold on;
end

for i = 1:length(info_fract(id_f).near_tet(id_tet_near).edges)
    id_edge = info_fract(id_f).near_tet(id_tet_near).edges(i);
    show_edge(id_edge);
    hold on;
end

for i = 1:length(info_fract(id_f).near_tet(id_tet_near).faces)
    id_edge = info_fract(id_f).near_tet(id_tet_near).faces(i);
    

end