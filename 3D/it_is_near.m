% id_tet = id tetraedro considerato
%salvo status_queue
b = tet(id_tet).status_queue;
n_points_on_queue = length(queue(1).points);
n_edges_on_queue = length(queue(1).edges);
n_faces_on_queue = length(queue(1).faces);

% b < -1 := il tetraedro non � gi� stato inserito su near_tet
% b > 0  := il tetraedro � gi� stato inserito su near_tet
%           b indica posizione in near_tet

if(b < -1)
    if(info_fract(id_f).near_tet(1).id == 0)
        a = 1;
    else
        a = length(info_fract(id_f).near_tet)+1;
    end
    
    info_fract(id_f).near_tet(a) = queue(1);
    tet(id_tet).status_queue = a;
else%b > 0
    %controllo eventuali nuovi punti
    
    for i = 1:n_points_on_queue
        if(~ismember(queue(1).points(i),info_fract(id_f).near_tet(b).points))
            info_fract(id_f).near_tet(b).points(end+1) = queue(1).points(i);
        end
    end
    
    for i = 1:n_edges_on_queue
        if(~ismember(queue(1).edges(i),info_fract(id_f).near_tet(b).edges))
            info_fract(id_f).near_tet(b).edges(end+1) = queue(1).edges(i);
        end
    end
    
    for i = 1:n_faces_on_queue
        if(~ismember(queue(1).faces(i),info_fract(id_f).near_tet(b).faces))
            info_fract(id_f).near_tet(b).faces(end+1) = queue(1).faces(i);
        end
    end
end