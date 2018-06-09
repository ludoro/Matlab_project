function [id_neigh] = which_neigh(id_tet,n)
global neigh;
global tet;
%può restituire anche -1
%n : nodo che il tetraedro vicino NON deve contenere 
%Quale dei quattro vicini non contiene quel nodo?
node_to_avoid = tet(id_tet).P(n);
i = 1;
found = 0;
id_neigh = -1;
while(i <= 4 && found == 0)
    if(neigh(id_tet,i) ~= -1)
        j = 1;
        found_node_to_avoid = 0;
        while(j<= 4 && found_node_to_avoid == 0)
            if(node_to_avoid == tet(neigh(id_tet,i)).P(j))
                found_node_to_avoid = 1;
            end
            j = j + 1;
        end
        if(found_node_to_avoid == 0)
            id_neigh = neigh(id_tet,i);
            found = 1;
        end
    end
    i = i + 1;
end
end

