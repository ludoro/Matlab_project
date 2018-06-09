function [] = show_near_tet(id_f)
global info_fract;
global node;
global face;
global tet;
if(info_fract(id_f).near_tet(1).id~=0)
for j = 1:length(info_fract(id_f).near_tet)
    id_tet = info_fract(id_f).near_tet(j).id;
    for i = 1:4
        X = [node(face(tet(id_tet).faces(i),1)).coord(1),node(face(tet(id_tet).faces(i),2)).coord(1),node(face(tet(id_tet).faces(i),3)).coord(1)];
        Y = [node(face(tet(id_tet).faces(i),1)).coord(2),node(face(tet(id_tet).faces(i),2)).coord(2),node(face(tet(id_tet).faces(i),3)).coord(2)];
        Z = [node(face(tet(id_tet).faces(i),1)).coord(3),node(face(tet(id_tet).faces(i),2)).coord(3),node(face(tet(id_tet).faces(i),3)).coord(3)];
        fill3(X,Y,Z,[1,0.4,0.7],'FaceAlpha',0.2,'EdgeAlpha',0.6);   
        hold on;
    end
end
end
end

