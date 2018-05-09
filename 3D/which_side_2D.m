function [side] = which_side_2D(P,A,B)
global toll;
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

