function [] = enqueue_tri_to_check(id_tri)

% se non sappiamo niente
if(triangle(neigh(id_tri,1),7) == -1)
    queue(end+1,1) = neigh(id_tri,1);
    queue(end,2) = triangle(id_tri,2);
    queue(end,3) = triangle(id_tri,3);
    triangle(neigh(id_tri,1),7) = -2;
    
end

if(triangle(neigh(id_tri,2),7) == -1)
    queue(end+1,1) = neigh(id_tri,2);
    queue(end,2) = triangle(id_tri,1);
    queue(end,3) = triangle(id_tri,3);
    triangle(neigh(id_tri,2),7) = -2;
    
end

if(triangle(neigh(id_tri,3),7) == -1)
    queue(end+1,1) = neigh(id_tri,3);
    queue(end,2) = triangle(id_tri,1);
    queue(end,3) = triangle(id_tri,2);
    triangle(neigh(id_tri,3),7) = -2;
    
end


end

