function [P_intersect,n_intersections,edge_intersection]... 
            = intersect_2D(id_f,p_1,p_2) 
% p_1 e p_2 sono gli indici di nodeplane
% P_intersect matrice 2x2 di coordinate di punti di intersezione
% se n_intersection = numero intersezioni proprie (escluse i vertici della
%                     frattura)
% edge_intersection = in quale lato entra? in quale lato esce?

global fract;
global fract_vertex;
global accuracy;
global node_plane;
global coord_to_use

if(is_empty(node_plane(p_1).sides) || is_empty(node_plane(p_1).sides))
    disp('Big problem in intersect_2D');
end

n_intersections=0;
P_temp=[0 0];
P_intersect=[0 0;0 0];
edge_intersection=[0 0];

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
%dentro -> fuori:   in_out=2
%fuori -> dentro:   in_out=1
%fuori -> fuori:    in_out=3
if(node_plane(p_1).is_out==0 && node_plane(p_2).is_out==1)
    in_out=2;
elseif(node_plane(p_1).is_out==1 && node_plane(p_2).is_out==0)
    in_out=1;
else %node_plane(p_1).is_out==1 && node_plane(p_2).is_out==1
    in_out=3;
end

while(i <= num_f && flag)
    side(1) = node_plane(p_1).sides(i);
    side(2) = node_plane(p_2).sides(i);
    %node_plane.sides non dovrebbe essere vuoto
    if(side(1)+side(2)==0 || side(1)+side(2) == 3 || side(1)+side(2) == 1)
        %un punto da una parte e uno dall'altra => faccio il sistema
        %In realtà sorprendentemente anche gli altri due casi funzionano
        %qui dentro, cioè quando un vertice sta sul segmento 
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
                edge_intersection(in_out)=i;
                if(side(1) == 2 || side(2) == 2)
                    %controllo se side(1) + side(2) == 1 oppure 3
                    n_intersections = 0;
                else 
                    n_intersections=1;
                    P_intersect(1,:)=F(i,:)+st(2)*(F(mod(i,num_f)+1,:)-F(i,:));
                end
            else %in_out==3
                n_intersections = n_intersections+1;
                if(n_intersections==1)
                    P_intersect(1,:)=F(i,:)+st(2)*(F(mod(i,num_f)+1,:)-F(i,:));
                    edge_intersection(1)=i;
                else %n_intersections==2
                    flag=0;
                    P_temp=F(i,:)+st(2)*(F(mod(i,num_f)+1,:)-F(i,:));
                    if(edge_intersections_temp(2)==0)
                        %tutto normale
                        %controllo se l'ordine è quello giusto
                        if(norm(P_intersect(1,:)-node_plane(p_1).coord,inf)>...
                                norm(P_temp-node_plane(p_1).coord,inf))
                            %scambio
                            P_intersect(2,:)=P_intersect(1,:);
                            P_intersect(1,:)=P_temp;
                            edge_intersection(2)=edge_intersection(1);
                            edge_intersection(1)=i;
                        else
                            P_intersect(2,:)=P_temp;
                            edge_intersection(2)=i;
                        end
                    else %il punto precedente era un vertice della frattura
                        %controllo se l'ordine è quello giusto
                        n_intersections=1;
                        if(norm(P_intersect(1,:)-node_plane(p_1).coord,inf)>...
                                norm(P_temp-node_plane(p_1).coord,inf))
                            %scambio
                            edge_intersection(2) = ...
                                     mod(edge_intersection(1)-2,num_f) + 1;
                            edge_intersection(1) = i;
                        else%ordine giusto
                            edge_intersection(2) = i;
                        end
                        % non voglio mettere il punto critico in output
                        P_intersect(1,:) = P_temp; 
                    end
                end
            end
            
        elseif(st(2)<=accuracy && st(2)>=-accuracy)
            % entrante : edge_intersection = i
            % uscente : edge_intersection = i-1
            if(in_out==2)
                flag=0;
                n_intersections=0;
                edge_intersection(2)=mod(i-2,num_f)+1; % "i-1"
            elseif(in_out==1)
                flag=0;
                n_intersections=0;
                edge_intersection(1)=i;
            else %in_out==3
                n_intersection=n_intersection+1;
                if(n_intersection==1)
                    P_intersect(1,:)=F(i,:);
                    %momentaneamente salvo i su entrambi gli
                    %edge_intersect_temp
                    edge_intersection=[i i];
                else %n_intersection==2
                    P_temp = F(i,:);
                    if(edge_intersection(2) == 0)
                        %tutto normale
                        if(norm(P_intersect(1,:)-node_plane(p_1).coord,inf)>...
                                norm(P_temp-node_plane(p_1).coord,inf))
                            %scambio
                            edge_intersection(2) = edge_intersecton(1);
                            edge_intersection(1) = i;
                        else%ordine giusto
                            edge_intersection(2) = mod(i-2,num_f)+1; %i-1
                        end
                        n_intersections = 1;
                       
                    else%punto precedente è vertice
                        if(norm(P_intersect(1,:)-node_plane(p_1).coord,inf)>...
                                norm(P_temp-node_plane(p_1).coord,inf))
                            %scambio
                            edge_intersection(2) = mod(edge_intersection(1)-2,num_f)+1;
                            edge_intersection(1) = i;
                        else%ordine giusto
                            edge_intersection(2) = mod(i-2,num_f)+1;
                        end
                        n_intersections = 0;
                    end
                end
            end
        end
    end
    i=i+1;
end
%problema: potrebbe essere che da fuori a fuori abbia solo un intersezione,
%con un vertice della frattura, ma la funzione in questo caso si aspetta
%due intersezioni, risolviamo il problema:
if(flag == 1 && n_intersections == 1)
    n_intersections = 0;
end
end

