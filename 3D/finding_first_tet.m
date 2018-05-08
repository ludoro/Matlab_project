found = 0;
id_tet = 1;
called_which_side = [0,0,0];
side = [0,0,0,0];
while(id_tet <= n_tets && found == 0)
    called_which_side = [0,0,0];
    
    for i =1:4
        if(node(tet(id_tet,i)).side == 0)
            side(i) = which_side(id_f,tet(id_tet,i));
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
           
            
        %------2 nodi da una parte e 2 dall'altra parte-------
        elseif(sum == 0)
            
        %-----NON TAGLIATO 1 nodo su piano 3 concordi-----
        elseif(sum == 7 || sum == 1)
            
            
        %-----1 nodo su piano, altri discordi------
        elseif(sum == 3 || sum == 5)
            
        
        %----2 nodi su piano altri concordi-------
        elseif(sum == 10 || sum == 6)
            
        
        %-----2 nodi su piano altri discordi----
        elseif(sum == 8)
            
            
        %------3 nodi sul piano-------
        else%sum == 13 || sum == 11
        
        
        end
        
    end
        
    
        
    
    
    
    
    
    
    
    
    
    
    id_tet = id_tet + 1;
end