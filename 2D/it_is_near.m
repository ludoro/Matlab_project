
b = triangle(id_tri,10);
already_saved = 0;
if( b < -1)
    
    %controllo che la prima cella di near_tri non contenga triangoli
    if(info_trace(id_t).near_tri(1).id == 0)
        
        info_trace(id_t).near_tri(1).id = id_tri;
        triangle(id_tri,10) = 1;
        if(b== -2)
            info_trace(id_t).near_tri(1).nodes = queue(1,[2,3]);
        else%%b==-3
            info_trace(id_t).near_tri(1).nodes = queue(1,2);
        end
        
    
     else %near_tri contiene già dei triangoli
         info_trace(id_t).near_tri(end+1).id = id_tri;
         triangle(id_tri,10) = length(info_trace(id_t).near_tri);
         if(b== -2)
            info_trace(id_t).near_tri(end).nodes = queue(1,[2,3]);
         else%%b==-3
            info_trace(id_t).near_tri(end).nodes = queue(1,2);
         end
     end
    
else % b > 0
     % il triangolo è già near_tri, bisogna controllare i nodi
     for i=2:3
         for j=1:length(info_trace(id_t).near_tri(b).nodes)
            if(queue(1,i) == info_trace(id_t).near_tri(b).nodes(j))
                already_saved = 1;
            end
         end
         
         if(queue(1,i) ~= 0 && already_saved == 0)
             info_trace(id_t).near_tri(b).nodes(end+1) = queue(1,i);
         end
     end
     
end


