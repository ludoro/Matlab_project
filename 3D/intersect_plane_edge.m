function [p_intersect] = intersect_plane_edge(id_f,e)%e = id_edge
global fract;
global node;
global edge;
global coord_to_use;

a = fract(id_f).N(1);
b = fract(id_f).N(2);
c = fract(id_f).N(3);
d = fract(id_f).d;

P_1 = [node(edge(e).P(1)).x;
       node(edge(e).P(1)).y;
       node(edge(e).P(1)).z];
   
P_2 = [node(edge(e).P(2)).x;
       node(edge(e).P(2)).y;
       node(edge(e).P(2)).z];

s = -(a*P_1(1)+b*P_1(2)+c*P_1(3)+d)/(a*(P_2(1)-P_1(1))+b*(P_2(2)-P_1(1))+...
      c*(P_2(3)-P_1(3)));

p_intersect = P_1(coord_to_use(id_f,:))+s*(P_2(coord_to_use(id_f,:))- ...
                  P_1(coord_to_use(id_f,:)));
end

