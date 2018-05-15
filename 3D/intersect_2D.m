function [P_intersect,n_intersections,edge_intersection_in,edge_intersection_out]... 
            = intersect_2D(id_f,p_1,p_2) 
% p_1 e p_2 sono gli indici di nodeplane
% P_intersect matrice 2x2 di coordinate di punti di intersezione
global fract;
global fract_vertex;
global toll;
global accuracy;
global node_plane;


if(is_empty(node_plane(p_1).sides) || is_empty(node_plane(p_1).sides))
    disp('Big problem in intersect_2D');
end

n_intersections=0;
P_temp=[0 0];
P_intersect=[0 0;0 0];
edge_intersection_temp=[0 0];

num_f=fract(id_f).n_points;
%salvo localmente le variabili della frattura
F = zeros(num_f,2);
for i = 1:num_f
    F(i,:) = fract_vertex(fract(id_f).P(i),coord_to_use(id_f,:));
end

side = [0,0];
i=1;
flag=1; %porre flag=0 per uscire dal while
in_out=0;
%dentro -> fuori:   in_out=1
%fuori -> dentro:   in_out=2
%fuori -> fuori:    in_out=3
if(node_plane(p_1).is_out==0 && node_plane(p_2).is_out==1)
    in_out=1;
elseif(node_plane(p_1).is_out==1 && node_plane(p_2).is_out==0)
    in_out=2;
else %node_plane(p_1).is_out==1 && node_plane(p_2).is_out==1
    in_out=3;
end

while(i <= num_f && flag)
    side(1) = node_plane(p_1).sides(i);
    side(2) = node_plane(p_2).sides(i);
    %node_plane.sides non dovrebbe essere vuoto
    if(side(1)+side(2)==0)
        %un punto da una parte e uno dall'altra => faccio il sistema
        A=[node_plane(p_2).coord(1)-node_plane(p_1).coord(1), ...
           F(1,1) - F(mod(i,num_f)+1,1); ...
           node_plane(p_2).coord(2)-node_plane(p_1).coord(2), ...
           F(1,2) - F(mod(i,num_f)+1,2)];
       
        b=[F(1,1)-node_plane(p_1).coord(1);
           F(1,2)-node_plane(p_1).coord(2)];
       
        st = A\b; %prima posizione t(segmento) , seconda posizione s(frattura)
        %devo controllare i valori di st(2)
        if(st(2)<1-accuracy && st(2)>accuracy)
            if(in_out<=2)
                flag=0;
                n_intersections=1;
                P_intersect=F(i,:)+st(2)*(F(mod(i,num_f)+1,:)-F(i,:));
                
                edge_intersection_temp(in_out)=i;
                
            else %in_out==3
                n_intersections = n_intersections+1;
                if(n_intersections==1)
                    P_intersect(1,:)=F(i,:)+st(2)*(F(mod(i,num_f)+1,:)-F(i,:));
                    edge_intersection_temp(1)=i;
                else %n_intersections==2
                    flag=0;
                    P_temp=F(i,:)+st(2)*(F(mod(i,num_f)+1,:)-F(i,:));
                    if(edge_intersections_temp(2)==0)
                        %tutto normale
                        %controllo se l'ordine � quello giusto
                        if(norm(P_intersect(1,:)-node_plane(p_1).coord,inf)>...
                                norm(P_temp-node_plane(p_1).coord,inf))
                            %scambio
                            P_intersect(2,:)=P_intersect(1,:);
                            P_intersect(1,:)=P_temp;
                            edge_intersection_temp(2)=edge_intersection_temp(1);
                            edge_intersection_temp(1)=i;
                        else
                            P_intersect(2,:)=P_temp;
                            edge_intersection_temp(2)=i;
                        end
                    else %il punto precedente era un vertice della frattura
                        %controllo se l'ordine � quello giusto
                        n_intersections=1;
                        if(norm(P_intersect(1,:)-node_plane(p_1).coord,inf)>...
                                norm(P_temp-node_plane(p_1).coord,inf))
                            
                    end
                end
            end
            
        elseif(st(2)<=accuracy && st(2)>=-accuracy)
            if(in_out==1)
                flag=0;
                n_intersections=0;
                edge_intersection_temp(1)=mod(i-2,num_f)+1; % "i-1"
            elseif(in_out==2)
                flag=0;
                n_intersections=0;
                edge_intersection_temp(2)=i;
            else %in_out==3
                n_intersection=n_intersection+1;
                if(n_intersection==1)
                    P_intersect(1,:)=F(i,:);
                    %momentaneamente salvo i su entrambi gli
                    %edge_intersect_temp
                    edge_intersection_temp=[i i];
                else %n_intersection==2
                    
                end
            end
        
        end
        
    end
    i=i+1;
end



end

