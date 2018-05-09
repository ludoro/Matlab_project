function [it_is_cut] = intersect_3D(id_f,id_node_plane)
%Questa funzione va a riempire info_trace.div
%id_f = id della frattura
%node_plane = i punti di taglio del piano
%id_node_plane = indici da considerare di node plane

% it_is_cut = 0 se non è tagliato
% it_is_cut = 2 se è tagliato nello step 2(se la sezione del tetraedro è
%               interna alla frattura)
% it_is_cut = 1 se è tagliato nello step 3 
global fract_vertex;
global node;
global tet;
global coord_to_use;
global accuracy;
global info_fract;
global fract;
global node_plane;
%salvo subito coordinate frattura
num_f = fract(id_f).n_points;
F = zeros(num_f,2);
for i = 1:num_f
    F(i,:) = fract_vertex(fract(id_f).P(i),coord_to_use(id_f,:));
end
if(id_nodes_plane(3) == -1)
    n_to_check = 2;
elseif(id_nodes_plane(4) == -1)
    n_to_check = 3;
else
    n_to_check = 4;
end
P = zeros(n_to_check,2);
for i = 1:n_to_check
    P(i,:) = node_plane(id_node_plane(i)).coord;
end
if(n_to_check > 2)
%-----STEP 1-----------
%controllo grossolano
G_f = fract(id_f).G;
r_f = fract(id_f).r;

g_temp = [0,0];
for i = 1:n_to_check
    g_temp = g_temp + P(i,:);
end
G_p = g_temp/n_to_check;

r_p = norm(P(1,:)-G_p,inf);
for i = 2:n_to_check
    r_temp = norm(P(i,:)-G_p,inf);
    if(r_p < r_temp)
        r_p = r_temp;
    end
end
% se la distanza dei due baricentri è maggiore della somma dei due raggi, 
% allora non si toccano
if(norm(G_f-G_p,inf) > r_p + r_f)
    it_is_cut = 0;
else
    %------STEP 2---------------
    side = zeros(n_to_check,num_f);
    for i=1:n_to_check
        if(is_empty(node_plane(id_node_plane(i)).sides))
            node_plane(id_node_plane(i)).sides = zeros(num_f,1);
            for j=1:num_f
                node_plane(id_node_plane(i)).sides(j) = ...  
                which_side_2D(P(i,:),F(j,:),F(mod(j,num_f)+1,:));
            end
        end
        side(i,:) = node_plane(id_node_plane(i)).sides;
    end
    
    side_int = which_side_2D(G_f,F(1,:),F(2,:));
    
    it_is_out = zeroes(n_to_check,1);
    all_out = 0;
    j = 1;
    for i = 1:n_to_check
        while(it_is_out(i) == 0 && j <= num_f)
            if(side(i,j) == -side_int)
                all_out = 1;
                it_is_out(i) = 1;
            end
            j = j + 1;
        end
    end
    
    if(all_out == 0)
        it_is_cut = 2;
    else
        %-----------STEP 3--------------------
        
        
    end
        
    
    
    
end

else% n_to_check == 2
    
end
    






end

