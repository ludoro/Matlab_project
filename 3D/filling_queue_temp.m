%id_tet = indice del tetraedro considerato
%lonely_point = 1....4 quale nodo del tetraedro 
%               NON sta sulla frattura  
%edge_to_avoid = contiene l'indice dell'edge di aggancio

%riempo queue_temp



%trovo indice faccia che sta sul piano
face_temp = tet(id_tet).faces(lonely_point);

% quello speculare non va aggiunto in queue_temp, 
% cambio solo lo status
if(tet(neigh(id_tet,lonely_point)).status_queue == -1)
    tet(neigh(id_tet,lonely_point)).status_queue = -5;
end

%aggiungo vicini di edge
for i = 1:3
    e_temp = which_edge(face(face_temp,i),face(face_temp,mod(i,3)+1));
    if(edge_to_avoid ~= e_temp)
        for j = 1:length(edge(e_temp).tets)
            if(edge(e_temp).tets(j) ~= id_tet && ...
               edge(e_temp).tets(j) ~= neigh(id_tet,lonely_point) &&...
               tet(edge(e_temp).tets(j)).status_queue == -1)
                %aggiungo il j-esimo in queue_temp
                queue_temp(end+1,1) = edge(e_temp).tets(j);
                queue_temp(end+1,2) = e_temp;
            end
        end
    end
end