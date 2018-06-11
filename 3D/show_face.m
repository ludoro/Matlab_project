function [] = show_face(id_face)

global node;
global face;

for i=1:3
    X(i)=node(face(id_face,i)).coord(1);
    Y(i)=node(face(id_face,i)).coord(2);
    Z(i)=node(face(id_face,i)).coord(3);
end
fill3(X,Y,Z,[0.4 1 0],'FaceAlpha',0.5,'EdgeAlpha',0);
hold on
end

