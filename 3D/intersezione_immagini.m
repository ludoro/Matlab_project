function [I] = intersezione_immagini(v_plane,P_1,P_2)

a=v_plane(1);
b=v_plane(2);
c=v_plane(3);
d=v_plane(4);

s = -(a*P_1(1)+b*P_1(2)+c*P_1(3)+d)/(a*(P_2(1)-P_1(1))+b*(P_2(2)-P_1(2))+...
      c*(P_2(3)-P_1(3)));

I=P_1 + s*(P_2-P_1);


end

