%{
Script che mette in coda i tetraedri da controllare 
id_tet = id tetraedro considerato
%}

%inserisco i vicini di faccia
for i = 1:4
    if(neigh(id_tet,i) ~= -1)
        if(tet(neigh(id_tet,i)).status_queue ~= 0)
            queue(end+1).id = neigh(id_tet,i);
            %Prendiamo tutti i punti tranne l'i-esimo
            %sperimentiamo con vettore logico
            queue(end).points = tet(neigh(id_tet,i)).P(1:4~=i);
            queue(end).faces = face(tet(neigh(id_tet,i)).faces(i));
            queue(end).edges = [0 0 0];
            for j = 1:3
                queue(end).edges(j) = which_edge(queue(end).points(j),...
                                     queue(end).points(mod(j,3)+1));
            end  
        end
    end
end

% vettore locale che salva tetraedi vicini con l'edge
tet_second_level = [];

%inserisco i vicini di edge
for i = 1:6
    for j = 1:length(edge(tet(id_tet).edges(i)).tets)
        id_temp = edge(tet(id_tet).edges(i)).tets(j);
        if(~ismember(id_tet,neigh(id_tet,:)) && id_temp ~= id_temp)
            if(tet(neigh(id_tet,i)).status_queue ~= 0)
                queue(end+1).id = id_temp;
                queue(end).points = edge(tet(id_tet).edges(i)).P;
                queue(end).faces = [];
                queue(end).edges = tet(id_tet).edges(i);
                tet_second_level(end+1) = id_temp;
            end
        end
    end
end

%inserisco i vicini di punto
for i = 1:4
    for j = 1:node(tet(id_tet).P(i)).tot_tets
        id_temp = node(tet(id_tet));
        if(~ismember(id_temp,tet_second_level) &&...
           ~ismember(id_tet,neigh(id_tet,:)) && id_temp ~= id_temp)
            queue(end+1).id = id_temp;
            queue(end).points = tet(id_tet).P(i);
            queue(end).faces = [];
            queue(end).edges = [];
        end
    end
end

clear tet_second_level id_temp;
