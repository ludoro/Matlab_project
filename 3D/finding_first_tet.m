found = 0;
id_tet = 1;
%called_which_side = [0,0,0];
side = [0,0,0,0];
lonely_point = 0;
nodes_together = [0,0,0];
e_temp = [0,0,0,0];
id_node_plane = [-1,-1,-1,-1];
third_coord = [0,0,0,0];
it_is_cut = -1;
while(id_tet <= n_tets && found == 0 && fract(id_f).protocol ~= 1)
    id_node_plane = [-1,-1,-1,-1]; %indici nodi 
    %called_which_side = [0,0,0,0]; %flag
    %chiamo which_side
    for i =1:4
        if(node(tet(id_tet).P(i)).side == 0)
            side(i) = which_side_3D(id_f,tet(id_tet).P(i));
            node(tet(id_tet).P(i)).side = side(i);
            called_which_side(i) = 1;
        else
            side(i) = node(tet(id_tet).P(i)).side;
        end
    end  
    if( ~(side(1) == side(2) == side(3) == side(4)) )
        %potrebbe essere tagliato 
        
        sum = side(1)+side(2)+side(3)+side(4);
%--------------------------------------------------------------------------
%------------------------INIZIO SUDDIVISIONE-------------------------------
%--------------------------------------------------------------------------

%-------1 nodo da una parte, 3 dall'altra parte----------------------------
        if(sum == 2 || sum == -2)
            %capiamo quale nodo sta da solo, spezzando in due casi
            if(sum == 2)
                if(side(1) == -1)
                    lonely_point=1;
                    nodes_together=[2,3,4];
                elseif(side(2) == -1)
                    lonely_point=2;
                    nodes_together=[1,3,4]; 
                elseif(side(3) == -1)
                    lonely_point=3;
                    nodes_together=[1,2,4];
                else %side(4)==-1
                    lonely_point=4;
                    nodes_together=[1,2,3]; 
                end
            else%sum == -2
                if(side(1) == 1)
                    lonely_point=1;
                    nodes_together=[2,3,4];
                    
                elseif(side(2) == 1)
                    lonely_point=2;
                    nodes_together=[1,3,4];
                    
                elseif(side(3) == 1)
                    lonely_point=3;
                    nodes_together=[1,2,4];
                    
                else %side(4)==1
                    lonely_point=4;
                    nodes_together=[1,2,3];
                end
            end
            %salvo in e_temp indici degli edge che tagliano il piano
            %e lavoro su node_plane
            for i = 1:3
                e_temp(i) = which_edge(tet(id_tet).P(lonely_point),...
                                       tet(id_tet).P(nodes_together(i)));  
                if(edge(e_temp(i)).checked == -1)
                   [node_plane(end+1).coord,third_coord(i)] = intersect_plane_edge...
                                             (id_f,e_temp(i));
                   node_plane(end).in_info = -1;
                   node_plane(end).is_out = -1;
                   node_plane(end).from_edge = 1;
                   edge(e_temp(i)).checked = length(node_plane);
                end
                id_node_plane(i) = edge(e_temp(i)).checked;
            end
            
            %chiamo la funzione intersect_3D
            it_is_cut = intersect_3D(id_f,id_node_plane(1:3),third_coord(1:3));
            
            if(it_is_cut ~= 0)
                %------------TAGLIATO-------------
                found = 1;
                tet(id_tet).status_queue = 0;
                info_fract(id_f).cut_tet(1).id = id_tet;
                %devo riempire points e quindi up middle e down
                
                info_fract(id_f).cut_tet(1).points = zeros(7,3);
                %inizio con punta
                info_fract(id_f).cut_tet(1).points(1,:) = ...
                      node(tet(id_tet).P(lonely_point)).coord;
                  
                % metto quelli della base
                for i = 2:4
                    info_fract(id_f).cut_tet(1).points(i,:) = ...
                        node(tet(id_tet).P(nodes_together(i-1))).coord;
                end
                
                %metto le intersezioni
                for i = 5:7
                    info_fract(id_f).cut_tet(1).points...
                    (i,coord_to_use(id_f,:)) = node_plane(id_node_plane(i-4)).coord;
                    info_fract(id_f).cut_tet(1).points...
                    (i,6-coord_to_use(id_f,1)-coord_to_use(id_f,2)) = third_coord(i-4);
                end
                id_cut = 1;
                up = 1;
                middle = [5,6,7];
                down = [2,3,4];
                slicing_tet;
                enqueue_tet_to_check;
            end
            
%---------------2 nodi da una parte, 2 dall'altra parte--------------------
        elseif(sum == 0)
            %ATTENZIONE ALL'ORDINE IN CUI I PUNTI DI INTERSEZIONE SONO
            %MESSI IN id_node_plane.
            if(side(1) == side(2))
                nodes_together_1 = [1,2];
                nodes_together_2 = [3,4];
            elseif(side(1) == side(3))
                nodes_together_1 = [1,3];
                nodes_together_2 = [2,4];
            else%side(1) == side(4)
                nodes_together_1 = [1,4];
                nodes_together_2 = [2,3];
            end
            
            %trovo i quattro punti sul piano, stando attento all'ordine
            e_temp(1) = which_edge(tet(id_tet).P(nodes_together_1(1)),...
                                   tet(id_tet).P(nodes_together_2(2)));
            e_temp(2) = which_edge(tet(id_tet).P(nodes_together_1(1)),...
                                   tet(id_tet).P(nodes_together_2(1)));
            e_temp(3) = which_edge(tet(id_tet).P(nodes_together_1(2)),...
                                   tet(id_tet).P(nodes_together_2(1)));
            e_temp(4) = which_edge(tet(id_tet).P(nodes_together_1(2)),...
                                   tet(id_tet).P(nodes_together_2(2)));
            for i = 1:4
                if(edge(e_temp(i)).checked == -1)
                   [node_plane(end+1).coord,third_coord(i)] = ...
                       intersect_plane_edge(id_f,e_temp(i));                   
                   node_plane(end).in_info = -1;
                   node_plane(end).is_out = -1;
                   node_plane(end).from_edge = 1;
                   edge(e_temp(i)).checked = length(node_plane);
                end
                id_node_plane(i) = edge(e_temp(i)).checked;
            end
            
            %chiamo la funzione intersect_3D
            it_is_cut = intersect_3D(id_f,id_node_plane,third_coord);
            
            if(it_is_cut ~= 0)
                %---------TAGLIATO-------------
                found = 1;
                tet(id_tet).status_queue = 0;
                info_fract(id_f).cut_tet(1).id = id_tet;
                %devo riempire points e quindi up middle e down
                
                info_fract(id_f).cut_tet(1).points = zeros(8,3);
                %inizio con i 2 sopra
                info_fract(id_f).cut_tet(1).points(1:2,:) = ...
                    node(tet(id_tet).P(nodes_together_1)).coord;
                
                %metto i 2 sotto
                info_fract(id_f).cut_tet(1).points(3:4,:) = ...
                    node(tet(id_tet).P(nodes_together_2)).coord;
                
                %metto le 4 intersezioni
                for i = 5:8
                    info_fract(id_f).cut_tet(1).points...
                    (i,coord_to_use(id_f,:)) = node_plane(id_node_plane(i-4)).coord;
                    info_fract(id_f).cut_tet(1).points...
                    (i,6-coord_to_use(id_f,1)-coord_to_use(id_f,2)) = third_coord(i-4);
                end
                id_cut = 1;
                up = [1,2];
                middle = [5,6,7,8];
                down = [3,4];
                slicing_tet;
                enqueue_tet_to_check;
            end
            
%---------------1 nodo su piano, altri discordi----------------------------
        elseif(sum == 3 || sum == 5)
            if(side(1) == side(2))
                nodes_together = [1,2];
                if(side(3) == 4)
                    lonely_point = 4;
                    point_on_plane = 3;
                else%side(4) == 4
                    lonely_point = 3;
                    point_on_plane = 4;
                end
                
            elseif(side(1) == side(3))
                nodes_together = [1,3];
                if(side(2) == 4)
                    lonely_point = 4;
                    point_on_plane = 2;
                else%side(4) == 4
                    lonely_point = 2;
                    point_on_plane = 4;
                end
            elseif(side(1) == side(4))
                nodes_together = [1,4];
                if(side(2) == 4)
                    lonely_point = 3;
                    point_on_plane = 2;
                else%side(3) == 4
                    lonely_point = 2;
                    point_on_plane = 3;
                end
            elseif(side(2) == side(3))
                nodes_together = [2,3];
                if(side(1) == 4)
                    lonely_point = 4;
                    point_on_plane = 1;
                else%side(4) == 4
                    lonely_point = 1;
                    point_on_plane = 4;
                end
            elseif(side(2) == side(4))
                nodes_together = [2,4];
                if(side(1) == 4)
                    lonely_point = 3;
                    point_on_plane = 1;
                else%side(3) == 4
                    lonely_point = 1;
                    point_on_plane = 3;
                end
            else%side(3) == side(4) 
                nodes_together = [3,4];
                if(side(1) == 4)
                    lonely_point = 2;
                    point_on_plane = 1;
                else%side(2) == 4
                    lonely_point = 1;
                    point_on_plane =2;
                end
            end
            
            for i = 1:2
                e_temp(i) = which_edge(tet(id_tet).P(lonely_point),...
                                       tet(id_tet).P(nodes_together(i)));
                if(edge(e_temp(i)).checked == -1)
                   [node_plane(end+1).coord,third_coord(i)] = ...
                       intersect_plane_edge(id_f,e_temp(i));                   
                   node_plane(end).in_info = -1;
                   node_plane(end).is_out = -1;
                   node_plane(end).from_edge = 1;
                   edge(e_temp(i)).checked = length(node_plane);
                end
                id_node_plane(i) = edge(e_temp(i)).checked;
            end
            
            %aggiungo in node_plane il punto tet(id_tet).P(point_on_plane)
            
            if(node(tet(id_tet).P(point_on_plane)).where_on_plane == -1)
                node_plane(end+1).coord = ...
                    node(tet(id_tet).P(point_on_plane)).coord(coord_to_use(id_f,:));
                
                node(tet(id_tet).P(point_on_plane)).where_on_plane = ...
                    length(node_plane);
                
                node_plane(end).in_info = -1;
                node_plane(end).is_out = -1;
                node_plane(end).from_edge = 0;
                
            end
            id_node_plane(3) = node(tet(id_tet).P(point_on_plane)).where_on_plane;
            
            third_coord(3) = ...
                  node(tet(id_tet).P(point_on_plane)).coord(...
                  6-coord_to_use(id_f,1)-coord_to_use(id_f,2));
              
            it_is_cut = intersect_3D(id_f,id_node_plane(1:3),third_coord(1:3));
            
            if(it_is_cut ~= 0)
                found = 1;
                info_fract(id_f).cut_tet(1).id = id_tet;
                %devo riempire points e quindi up middle e down
                
                info_fract(id_f).cut_tet(1).points = zeros(6,3);
                
                %inizio con il lonely_point
                info_fract(id_f).cut_tet(1).points(1,:) = ...
                    node(tet(id_tet).P(lonely_point)).coord;
                
                %metto point_on_plane
                info_fract(id_f).cut_tet(1).points(2,:) = ...
                    node(tet(id_tet).P(point_on_plane)).coord;
                
                %metto nodes_together
                for i = 3:4
                    info_fract(id_f).cut_tet(1).points(i,:) = ...
                        node(tet(id_tet).P(nodes_together(i-2))).coord;   
                end
                
                %metto intersezioni
                for i = 5:6
                    info_fract(id_f).cut_tet(1).points...
                    (i,coord_to_use(id_f,:)) = node_plane(id_node_plane(i-4)).coord;
                    info_fract(id_f).cut_tet(1).points...
                    (i,6-coord_to_use(id_f,1)-coord_to_use(id_f,2)) = third_coord(i-4);
                end
                id_cut = 1;
                up = 1;
                middle = [2,5,6];
                down = [3,4];
                slicing_tet;
                enqueue_tet_to_check;
            end
            
        %----2 nodi su piano altri concordi-------
        elseif(sum == 10 || sum == 6)
            if(side(1) == side(2) == 4)
                nodes_on_plane = [1,2];
                nodes_together = [3,4];
            elseif(side(1) == side(3) == 4)
                nodes_on_plane = [1,3];
                nodes_together = [2,4];
            elseif(side(1) == side(4) == 4)
                nodes_on_plane = [1,4];
                nodes_together = [2,3];
            elseif(side(2) == side(3) == 4)
                nodes_on_plane = [2,3];
                nodes_together = [1,4];
            elseif(side(2) == side(4) == 4)
                nodes_on_plane = [2,4];
                nodes_together = [1,3];
            else%side(3) == side(4) == 4
                nodes_on_plane = [3,4];
                nodes_together = [1,2];
            end
            
            for i = 1:2
                if(node(tet(id_tet).P(nodes_on_plane(i))).where_on_plane == -1)
                    node_plane(end+1).coord = ...
                      node(tet(id_tet).P(nodes_on_plane(i))).coord(coord_to_use(id_f,:));
                    
                    node(tet(id_tet).P(nodes_on_plane(i))).where_on_plane =...
                      length(node_plane);
                  
                    node_plane(end).in_info = -1;
                    node_plane(end).is_out = -1;
                    node_plane(end).from_edge = 0;
                end
                id_node_plane(i) = ...
                    node(tet(id_tet).P(nodes_on_plane(i))).where_on_plane;
                third_coord(i) = ...
                  node(tet(id_tet).P(nodes_on_plane(i))).coord(...
                  6-coord_to_use(id_f,1)-coord_to_use(id_f,2));
            end
            
            it_is_cut = intersect_3D(id_f,id_node_plane(1:2),third_coord(1:2));
            
            if(it_is_cut == 1)
                found = 1;
                info_fract(id_f).cut_tet(1).id = id_tet;
                
                %metto punti e facce 
                info_fract(id_f).cut_tet(1).points = zeros(4,3);
                info_fract(id_f).cut_tet(1).faces = zeros(4,3);
                for i=1:4
                    info_fract(id_f).cut_tet(1).points(i,:) = ...
                        tet(id_tet).P(i);
                    info_fract(id_f).cut_tet(1).faces(i,:) = ...
                        find(1:4~=i);
                end
                
                %metto poliedri
                info_fract(id_f).cut_tet(1).poly_1 = [1,2,3,4];
                info_fract(id_f).cut_tet(1).poly_2 = [];
                
                enqueue_tet_to_check;
            end
            
        %-----2 nodi su piano altri discordi----
        elseif(sum == 8)
            if(side(1) == side(2) == 4)
                nodes_on_plane = [1,2];
                lonely_point_1 = 3;
                lonely_point_2 = 4;
            elseif(side(1) == side(3) == 4)
                nodes_on_plane = [1,3];
                lonely_point_1 = 2;
                lonely_point_2 = 4;
            elseif(side(1) == side(4) == 4)
                nodes_on_plane = [1,4];
                lonely_point_1 = 2;
                lonely_point_2 = 3;
            elseif(side(2) == side(3) == 4)
                nodes_on_plane = [2,3];
                lonely_point_1 = 1;
                lonely_point_2 = 4;
            elseif(side(2) == side(4) == 4)
                nodes_on_plane = [2,4];
                lonely_point_1 = 1;
                lonely_point_2 = 3;
            else%side(3) == side(4) == 4
                nodes_on_plane = [3,4];
                lonely_point_1 = 1;
                lonely_point_2 = 2;
            end
            e_temp(1) = ...
                which_edge(tet(id_tet).P(lonely_point_1),...
                           tet(id_tet).P(lonely_point_2));
            if(edge(e_temp(1)).checked == -1)
                [node_plane(end+1).coord,third_coord(1)] = ...
                    intersect_plane_edge(id_f,e_temp(1));
                
                node_plane(end).in_info = -1;
                node_plane(end).is_out = -1;
                node_plane(end).from_edge = 1;
                
                edge(e_temp(1)).checked = length(node_plane);
            end
            id_node_plane(1) = edge(e_temp(1)).checked;
            
            %inserisco i 2 nodi del tetraedro su node_plane
            for i = 1:2
                if(node(tet(id_tet).P(nodes_on_plane(i))).where_on_plane == -1)
                    node_plane(end+1).coord = ...
                      node(tet(id_tet).P(nodes_on_plane(i))).coord(coord_to_use(id_f,:));
                    
                    node(tet(id_tet).P(nodes_on_plane(i))).where_on_plane =...
                      length(node_plane);
                  
                    node_plane(end).in_info = -1;
                    node_plane(end).is_out = -1;
                    node_plane(end).from_edge = 0;
                end
                id_node_plane(i+1) = ...
                    node(tet(id_tet).P(nodes_on_plane(i))).where_on_plane;
                third_coord(i+1) = ...
                  node(tet(id_tet).P(nodes_on_plane(i))).coord(...
                  6-coord_to_use(id_f,1)-coord_to_use(id_f,2));
            end
            
            it_is_cut = intersect_3D(id_f,id_node_plane(1:3),third_coord(1:3));
            
            if(it_is_cut ~= 0)
                %----TAGLIATO-----
                found = 1;
                tet(id_tet).status_queue = 0;
                info_fract(id_f).cut_tet(1).id = id_tet;
                info_fract(id_f).cut_tet(1).points = zeros(5,3);
                
                %metto punto in alto
                info_fract(id_f).cut_tet(1).points(1,:) = ...
                    node(tet(id_tet).P(lonely_point_1)).coord;
                %metto punto basso
                info_fract(id_f).cut_tet(1).points(4,:) = ...
                    node(tet(id_tet).P(lonely_point_2)).coord;
                %metto nodes_on_plane
                for i = 2:3
                    info_fract(id_f).cut_tet(1).points(i,:) = ...
                    node(tet(id_tet).P(nodes_on_plane(i-1))).coord;
                end
                %metto punto intersezione
                info_fract(id_f).cut_tet(1).points(5,coord_to_use(id_f,:)) = ...
                    node_plane(id_node_plane(1)).coord;
                info_fract(id_f).cut_tet(1).points(5,...
                    6-coord_to_use(id_f,1)-coord_to_use(id_f,2)) = ...
                        third_coord(1);
                up = 1;
                middle = [2,3,5];
                down = 4;
                id_cut = 1;
                slicing_tet;
                enqueue_tet_to_check;   
            end
            
        %------3 nodi sul piano-------
        elseif(sum == 13 || sum == 11)
            if(side(1) == side(2) == side(3) == 4)
                nodes_on_plane = [1,2,3];
                lonely_point = 4;
            elseif(side(2) == side(3) == side(4) == 4)
                nodes_on_plane = [2,3,4];
                lonely_point = 1;
            else%side(3) == side(4) == side(1) == 4
                nodes_on_plane = [1,3,4];
                lonely_point = 2;
            end
            
            for i = 1:3
                if(node(tet(id_tet).P(nodes_on_plane(i))).checked == -1)
                    node_plane(end+1).coord = ...
                        node(tet(id_tet).P(nodes_on_plane(i))).coord(coord_to_use(id_f,:));
                    
                    node(tet(id_tet).P(nodes_on_plane(i))).where_on_plane =...
                      length(node_plane);
                  
                    node_plane(end).in_info = -1;
                    node_plane(end).is_out = -1;
                    node_plane(end).from_edge = 0;
                end
                id_node_plane(i) = ...
                    node(tet(id_tet).P(nodes_on_plane(i))).where_on_plane;
                third_coord(i) = ...
                  node(tet(id_tet).P(nodes_on_plane(i))).coord(...
                  6-coord_to_use(id_f,1)-coord_to_use(id_f,2));
            end
            
            it_is_cut = intersect_3D(id_f,id_node_plane(1:3),third_coord(1:3));
            
            if(it_is_cut ~= 0 && it_is_cut ~=2)
                %-----TAGLIATO------
                found = 1;
                tet(id_tet).status_queue = 0;
                info_fract(id_f).cut_tet(1).id = id_tet;
                
                %metto punti e facce 
                info_fract(id_f).cut_tet(1).points = zeros(4,3);
                info_fract(id_f).cut_tet(1).faces = zeros(4,3);
                for i=1:4
                    info_fract(id_f).cut_tet(1).points(i,:) = ...
                        tet(id_tet).P(i);
                    info_fract(id_f).cut_tet(1).faces(i,:) = ...
                        find(1:4~=i);
                end
                
                %metto poliedri
                info_fract(id_f).cut_tet(1).poly_1 = [1,2,3,4];
                info_fract(id_f).cut_tet(1).poly_2 = [];
                
                enqueue_tet_to_check;
                
            elseif(it_is_cut == 2)
                %riempo queue_temp
                found = 1;
                edge_to_avoid = 0;
                filling_queue_temp;
            end
        end
    end
    id_tet = id_tet + 1;
end
last_checked = id_tet - 1;