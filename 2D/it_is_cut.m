if(info_trace(id_t).cut_tri(1).id == 0)
    
    info_trace(id_t).cut_tri(1).id = id_tri;
    triangle(id_tri,10)= 0;
    
    %mettiamo info dei punti del triangolo che stiamo
    %considerando in info trace. 
    for j = 1:3
        info_trace(id_t).cut_tri(1).points(j,1) = node(tr(j)).x;
        info_trace(id_t).cut_tri(1).points(j,2) = node(tr(j)).y;
    end
else
    info_trace(id_t).cut_tri(end+1).id = id_tri;
    triangle(id_tri,10)= 0;
    
    %mettiamo info dei punti del triangolo che stiamo
    %considerando in info trace. 
    for j = 1:3
        info_trace(id_t).cut_tri(end).points(j,1) = node(tr(j)).x;
        info_trace(id_t).cut_tri(end).points(j,2) = node(tr(j)).y;
    end
end