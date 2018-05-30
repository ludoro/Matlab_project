side = [0,0,0,0];
id_tet = 11;
id_f = 1;
for i = 1:4
    side(i) = node(tet(id_tet).P(i)).side;
end
%side
coord = zeros(4,3);
for i = 1:4
    coord(i,:) = node(tet(id_tet).P(i)).coord;
end
coord
P_intersect = zeros(3,3);

% for i = [1,2,4]
%     [P_intersect(i-mod(i,3)+mod(i,4),coord_to_use(id_f,:)),...
%      P_intersect(i-mod(i,3)+mod(i,4),6-coord_to_use(id_f,1)-coord_to_use(id_f,2))]= ... 
%         intersect_plane_edge(id_f,which_edge(tet(id_tet).P(3),...
%                          tet(id_tet).P(i)));
% end
for i = 2:4
    [P_intersect(i-1,coord_to_use(id_f,:)),...
     P_intersect(i-1,6-coord_to_use(id_f,1)-coord_to_use(id_f,2))]= ... 
        intersect_plane_edge(id_f,which_edge(tet(id_tet).P(1),...
                         tet(id_tet).P(i)));
end

P_intersect

info_fract(id_f).cut_tet(1).points