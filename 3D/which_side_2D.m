function [side] = which_side_2D(P,A,B)
global toll;
%modo per capire il side del punto P rispetto al segmento formato da A e B
v=B-A;
n = [-v(2),v(1)];
v_p = P-A;
scalar = dot(n,v_p)/norm(n,1);
if(scalar > toll)
    side = 1;
elseif( scalar < -toll)
    side = -1;
else
    side = 2;
end
end

