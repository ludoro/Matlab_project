while(~isempty(queue_temp))

    id_tet = queue_temp(1,1);
    
    % se lo status_queue ~ da 5, già stato controllato
    if(tet(id_tet).status_queue == -5)
        
        %chiamo which_side
        side = [0,0,0,0];
        for i =1:4
            if(node(tet(id_tet).P(i)).side == 0)
                side(i) = which_side_3D(id_f,tet(id_tet).P(i));
                node(tet(id_tet).P(i)).side = side(i);
                called_which_side(i) = 1;
            else
                side(i) = node(tet(id_tet).P(i)).side;
            end
        end  
        sum = side(1) + side(2) + side(3) + side(4);
        
        %3 nodi sul piano 1 fuori
        if(sum == 13 || sum == 11)
            
            %"estendo" queue_temp
            if(side(4) == 1 || side(4)==-1)
                nodes_on_plane = [1,2,3];
                lonely_point = 4;
            elseif(side(1)== 1 || side(1)==-1)
                nodes_on_plane = [2,3,4];
                lonely_point = 1;
            elseif(side(2) == 1 || side(2) == -1)
                nodes_on_plane = [1,3,4];
                lonely_point = 2;
            else%side(3)==1 || s1de(3)==-1
                nodes_on_plane = [1,2,4];
                lonely_point = 3;
            end
            
            %controllo se è tagliato
            for i = 1:3
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
            
            %se il tetraedro opposto è tagliato, allora lo è anche
            %questo, senza bisogno di chiamare intersect_3D
            if(neigh(id_tet,lonely_point)==-1)
                it_is_cut = intersect_3D(id_f,id_node_plane(1:3),third_coord(1:3));
            else
                if(tet(neigh(id_tet,lonely_point)).status_queue==0)
                    it_is_cut=1;
                elseif(tet(neigh(id_tet,lonely_point)).status_queue>0)
                    it_is_cut=0;
                else
                    it_is_cut = intersect_3D(id_f,id_node_plane(1:3),third_coord(1:3));
                end
            end
            
            if(it_is_cut ~= 0 && it_is_cut ~=2)
                %-----tagliato------
                
                tet(id_tet).status_queue=0;
                if(info_fract(id_f).cut_tet(1).id == 0)
                    %dove inserire il tetraedro tagliato
                    a = 1;
                else
                    info_fract(id_f).cut_tet(end+1).id = 0;
                    a = length(info_fract(id_f).cut_tet);
                end
                
                info_fract(id_f).cut_tet(a).id = id_tet;
                
                %metto punti e facce 
                info_fract(id_f).cut_tet(a).points = zeros(4,3);
                info_fract(id_f).cut_tet(a).faces = zeros(4,4);
                for i=1:4
                    info_fract(id_f).cut_tet(a).points(i,:) = ...
                            node(tet(id_tet).P(i)).coord;
                    info_fract(id_f).cut_tet(a).faces(i,:) = ...
                            [find(1:4~=i),0];
                end
                
                %metto poliedri
                info_fract(id_f).cut_tet(a).poly_1 = [1,2,3,4];
                info_fract(id_f).cut_tet(a).poly_2 = [];
                
                enqueue_tet_to_check;
                
            elseif(it_is_cut == 2)
                %riempo queue_temp
                edge_to_avoid = queue_temp(1,2);
                filling_queue_temp;
            end
            
            
        elseif(sum == 8)
            if(side(1) == side(2))
                nodes_on_plane = [1,2];
                lonely_point_1 = 3;
                lonely_point_2 = 4;
            elseif(side(1) == side(3))
                nodes_on_plane = [1,3];
                lonely_point_1 = 2;
                lonely_point_2 = 4;
            elseif(side(1) == side(4))
                nodes_on_plane = [1,4];
                lonely_point_1 = 2;
                lonely_point_2 = 3;
            elseif(side(2) == side(3))
                nodes_on_plane = [2,3];
                lonely_point_1 = 1;
                lonely_point_2 = 4;
            elseif(side(2) == side(4))
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
                %----tagliato-----
                if(info_fract(id_f).cut_tet(1).id == 0)
                    a = 1;
                else
                    info_fract(id_f).cut_tet(end+1).id = 0;
                    a = lenght(info_fract(id_f).cut_tet);
                end
                
                info_fract(id_f).cut_tet(a).id = id_tet;
                info_fract(id_f).cut_tet(a).points = zeros(5,3);
                
                %metto punto in alto
                info_fract(id_f).cut_tet(a).points(1,:) = ...
                    node(tet(id_tet).P(lonely_point_1)).coord;
                %metto punto basso
                info_fract(id_f).cut_tet(a).points(4,:) = ...
                    node(tet(id_tet).P(lonely_point_2)).coord;
                %metto nodes_on_plane
                for i = 2:3
                    info_fract(id_f).cut_tet(a).points(i,:) = ...
                    node(tet(id_tet).P(nodes_on_plane(i-1))).coord;
                end
                %metto punto intersezione
                info_fract(id_f).cut_tet(a).points(5,coord_to_use(id_f,:)) = ...
                    node_plane(id_node_plane(1)).coord;
                info_fract(id_f).cut_tet(a).points(5,...
                    6-coord_to_use(id_f,1)-coord_to_use(id_f,2)) = ...
                        third_coord(1);
                up = 1;
                middle = [2,3,5];
                down = 4;
                id_cut = a;
                slicing_tet;
                enqueue_tet_to_check;   
            end
        end
    end
    queue_temp = queue_temp(2:end,:);
end