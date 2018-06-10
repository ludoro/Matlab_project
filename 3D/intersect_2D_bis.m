function [n_intersect] = intersect_2D_bis(id_f,p_1,p_2)
%
%
%
global fract;
global fract_vertex;
global accuracy;
global node_plane;
global coord_to_use;
global toll;

if(isempty(node_plane(p_1).sides) || isempty(node_plane(p_1).sides))
    disp('Big problem in intersect_2D_bis');
end

n_intersect = 0;
num_f=fract(id_f).n_points;
%salvo localmente le variabili della frattura
F = zeros(num_f,2);
for i = 1:num_f
    F(i,:) = fract_vertex(fract(id_f).P(i),coord_to_use(id_f,:));
end

side = [0,0];
i=1;
flag=1; %porre flag=0 per uscire dal while
%dentro -> fuori:   in_out=2
%fuori -> dentro:   in_out=1
%fuori -> fuori:    in_out=3


while(i <= num_f && flag) 
    side(1) = node_plane(p_1).sides(i);
    side(2) = node_plane(p_2).sides(i);
    %node_plane.sides non dovrebbe essere vuoto
    if(side(1)+side(2)==0 || side(1)+side(2) == 3 || side(1)+side(2) == 1)
        %un punto da una parte e uno dall'altra => faccio il sistema
        %In realtà sorprendentemente anche gli altri due casi funzionano
        %qui dentro, cioè quando un vertice sta sul segmento 
        A=[node_plane(p_2).coord(1)-node_plane(p_1).coord(1), ...
           F(i,1) - F(mod(i,num_f)+1,1); ...
           node_plane(p_2).coord(2)-node_plane(p_1).coord(2), ...
           F(i,2) - F(mod(i,num_f)+1,2)];
       
        b=[F(i,1)-node_plane(p_1).coord(1);
           F(i,2)-node_plane(p_1).coord(2)];
       
        st = A\b; %prima posizione t(segmento) , seconda posizione s(frattura)
        %devo controllare i valori di st(2)
        if(st(2)<1-accuracy && st(2)>=accuracy)
            n_intersect = n_intersect + 1;
        end
            
    elseif(side(1) + side(2) == 4)
        disp('qui');
        %punto medio segmento analizzare
        G = (node_plane(p_1).coord + node_plane(p_2).coord)/2;
        G_f = (F(i,:)+F(mod(i,num_f)+1,:))/2;
        sum_r = norm(G_f - F(i,:),inf) + norm(G - node_plane(p_1).coord,inf);
        if(norm(G-G_f,inf) < sum_r - toll)
            n_intersect = 2;
        else%compresa
            n_intersect = 1;
            
        end
        flag = 0;
    end
    i = i + 1;
end
end

