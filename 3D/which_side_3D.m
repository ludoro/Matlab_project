function [side] = which_side_3D(id_f,p)
%possibili side:
% side = 1 o -1 come in 2D
% side = 4 se sta sul piano
global fract;
global fract_vertex;
global node;
v = [0,0,0];

v(1)=node(p).x-fract_vertex(fract(id_f).P(1),1);
v(2)=node(p).y-fract_vertex(fract(id_f).P(1),2);
v(3)=node(p).z-fract_vertex(fract(id_f).P(1),3);

scalar=dot(fract(id_p).N,v);
toll=node(p).toll;

if(scalar<-toll)
    side=-1;
elseif(scalar>toll)
    side=1;
else
    side=4;
end
end

