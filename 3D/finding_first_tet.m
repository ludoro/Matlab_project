found = 0;
id_tet = 1;
called_which_side = [0,0,0];
side = [0,0,0,0];
lonely_point = 0;
nodes_together = [0,0,0];
e_temp = [0,0,0,0];
id_node_plane = [-1,-1,-1,-1];

while(id_tet <= n_tets && found == 0)
    id_node_plane = [-1,-1,-1,-1]; %indici nodi 
    called_which_side = [0,0,0,0]; %flag
    
    %chiamo which_side
    for i =1:4
        if(node(tet(id_tet,i)).side == 0)
            side(i) = which_side_3D(id_f,tet(id_tet,i));
            node(tet(id_tet,i)).side = side(i);
            called_which_side(i) = 1;
        else
            side(i) = node(tet(id_tet,i)).side;
        end
    end
    
    if( ~(side(1) == side(2) == side(3) == side(4)) )
        %potrebbe essere tagliato 
        sum = side(1)+side(2)+side(3)+side(4);

        %-------1 nodo da una parte, 3 dall'altra parte--------- 
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
            %salvo in e_temp indici degli edge 
            %e lavoro su node_plane
            for i = 1:3
                e_temp(i) = which_edge(tet(id_tet,lonely_point),...
                                       tet(id_tet,nodes_together(i)));  
                if(edge(e_temp(i)).checked == -1)
                   node_plane(end+1).coord = intersect_plane_edge...
                                             (id_f,e_temp(i));
                   node_plane(end).in_info = -1;
                   node_plane(end).is_out = -1;
                   edge(e_temp(i)).checked = length(node_plane);
                end
                id_nodes_plane(i) = edge(e_temp(i)).checked;
            end 
        %------2 nodi da una parte e 2 dall'altra parte-------
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
            
        %-----1 nodo su piano, altri discordi------
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
        end
        
    end
        
    
        
    
    
    
    
    
    
    
    
    
    
    id_tet = id_tet + 1;
end