%{
Script che mette in coda i tetraedri da controllare 
id_tet = id tetraedro considerato
%}

%inserisco i vicini
for i = 1:4
    if(neigh(id_tet,i) ~= -1)
        if(tet(neigh(id_tet,i)).status_queue ~= 0)
            queue(end+1).id = neigh(id_tet,i);
            queue(end).points = tet(neigh(id_tet,i)).P(1:4~=i);
            queue(end).face = face(tet(neigh(id_tet,i)).faces(i));
            queue(end).edge = [0 0 0];
            for j = 1:3
                queue(end).edge(j) = which_edge(queue(end).points(j),...
                                     queue(end).points(mod(j,3)+1));
            end
            
        end
    end
end

