function [side] = which_side_3D(id_f,p)
%possibili side:
% side = 1 o -1 come in 2D
% side = 4 se sta sul piano
global fract;
global fract_vertex;
global node;

v = node(p).coord-fract_vertex(fract(id_f).P(1),:);
scalar=dot(fract(id_f).N,v);
toll=node(p).toll;

if(scalar<-toll)
    side=-1;
elseif(scalar>toll)
    side=1;
else
    side=4;
end
end

