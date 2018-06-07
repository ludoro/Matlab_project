
b = triangle(id_tri,10);
already_saved = 0;

% b < -1 := il triangolo non è già stato inserito su near_tri
% b > 0  := il triangolo è già stato inserito su near_tri
%           b indica posizione in near_tri
if(b < -1)
    %controllo che la prima cella di near_tri non contenga triangoli
    if(info_trace(id_t).near_tri(1).id == 0)
        a = 1;
    else
        a = length(info_trace(id_t).near_tri)+1;
    end
        
    info_trace(id_t).near_tri(a) = queue(1);
    triangle(id_tri,10) = a;
    
else % b > 0
     % il triangolo è già near_tri, bisogna controllare i nodi
     for i=1:length(queue(1).points)
         already_saved=0;
         for j=1:length(info_trace(id_t).near_tri(b).points)
            if(queue(1).points(i) == info_trace(id_t).near_tri(b).points(j))
                already_saved = 1;
            end
         end
         
         if(already_saved == 0)
             info_trace(id_t).near_tri(b).points(end+1) = queue(1).points(i);
         end
     end
     for i=1:length(queue(1).edges)
         already_saved=0;
         for j=1:length(info_trace(id_t).near_tri(b).edges)
            if(queue(1).edges(i) == info_trace(id_t).near_tri(b).edges(j))
                already_saved = 1;
            end
         end
         
         if(already_saved == 0)
             info_trace(id_t).near_tri(b).edges(end+1) = queue(1).edges(i);
         end
     end
end


