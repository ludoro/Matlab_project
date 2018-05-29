function [] = show_single_tet(v_tet)
global fract;
global fract_vertex;
global tet;
global face;
global node;
global n_fracts;
for j = 1:length(v_tet)
    id_tet = v_tet(j);
for i = 1:4
    X = [node(face(tet(id_tet).faces(i),1)).coord(1),node(face(tet(id_tet).faces(i),2)).coord(1),node(face(tet(id_tet).faces(i),3)).coord(1)];
    Y = [node(face(tet(id_tet).faces(i),1)).coord(2),node(face(tet(id_tet).faces(i),2)).coord(2),node(face(tet(id_tet).faces(i),3)).coord(2)];
    Z = [node(face(tet(id_tet).faces(i),1)).coord(3),node(face(tet(id_tet).faces(i),2)).coord(3),node(face(tet(id_tet).faces(i),3)).coord(3)];
    fill3(X,Y,Z,[1,1,0],'FaceAlpha',0.6,'EdgeColor',[0,0,0.6],...
          'EdgeAlpha',0.6);
    hold on;
end
end
for j = 1:n_fracts
    X = zeros(fract(j).n_points,1);
    Y = zeros(fract(j).n_points,1);
    Z = zeros(fract(j).n_points,1);
    for i = 1:fract(j).n_points
        X(i) = fract_vertex(fract(j).P(i),1);
        Y(i) = fract_vertex(fract(j).P(i),2);
        Z(i) = fract_vertex(fract(j).P(i),3);
    end
    fill3(X,Y,Z,[1,0,0],'FaceAlpha',0.9,'EdgeColor',[0.8,0,0]);
    hold on;
end
axis equal;

end

