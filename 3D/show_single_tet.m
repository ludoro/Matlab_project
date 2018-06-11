function [] = show_single_tet(v_tet,face_alpha)
global tet;
global face;
global node;

for j = 1:length(v_tet)
    id_tet = v_tet(j);
for i = 1:4
    X = [node(face(tet(id_tet).faces(i),1)).coord(1),node(face(tet(id_tet).faces(i),2)).coord(1),node(face(tet(id_tet).faces(i),3)).coord(1)];
    Y = [node(face(tet(id_tet).faces(i),1)).coord(2),node(face(tet(id_tet).faces(i),2)).coord(2),node(face(tet(id_tet).faces(i),3)).coord(2)];
    Z = [node(face(tet(id_tet).faces(i),1)).coord(3),node(face(tet(id_tet).faces(i),2)).coord(3),node(face(tet(id_tet).faces(i),3)).coord(3)];
    fill3(X,Y,Z,[1,1,0],'FaceAlpha',face_alpha,...
          'EdgeAlpha',0.6);
    hold on;
end
end
axis equal;
end

