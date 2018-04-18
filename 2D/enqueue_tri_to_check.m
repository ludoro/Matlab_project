function [] = enqueue_tri_to_check(id_tri)

global triangle
global neigh
global queue
global node 

% se non sappiamo niente
if(neigh(id_tri,1) ~= -1)
if(triangle(neigh(id_tri,1),7) == -1)
    queue(end+1,1) = neigh(id_tri,1);
    queue(end,2) = triangle(id_tri,2);
    queue(end,3) = triangle(id_tri,3);
    triangle(neigh(id_tri,1),7) = -2;
    
end
end

if(neigh(id_tri,2) ~= -1)
if(triangle(neigh(id_tri,2),7) == -1)
    queue(end+1,1) = neigh(id_tri,2);
    queue(end,2) = triangle(id_tri,1);
    queue(end,3) = triangle(id_tri,3);
    triangle(neigh(id_tri,2),7) = -2;
    
end
end

if(neigh(id_tri,3) ~= -1)
if(triangle(neigh(id_tri,3),7) == -1)
    queue(end+1,1) = neigh(id_tri,3);
    queue(end,2) = triangle(id_tri,1);
    queue(end,3) = triangle(id_tri,2);
    triangle(neigh(id_tri,3),7) = -2;
    
end
end

for i = [1:3]
    for j = [1:node(triangle(id_tri,i)).tot_triangles]
           if(triangle(node(triangle(id_tri,i)).triangles(j),7) == -1 ...
               &&...
               node(triangle(id_tri,i)).triangles(j) ~= id_tri)
           
               queue(end+1,1) = node(triangle(id_tri,i)).triangles(j);
               queue(end,2) = triangle(id_tri,i);
               queue(end,3) = 0; % per scrupolo
               triangle(node(triangle(id_tri,i)).triangles(j),7) = -3;
           end
        
    end
end
end

