function [] = enqueue_tri_to_check(id_tri)

global triangle
global neigh
global queue
global node 

% se non sappiamo niente
if(neigh(id_tri,1) ~= -1)
if(triangle(neigh(id_tri,1),10) ~=0 )
    queue(end+1,1) = neigh(id_tri,1);
    queue(end,2) = triangle(id_tri,2);
    queue(end,3) = triangle(id_tri,3);
    if(triangle(neigh(id_tri,1),10) == -1 || triangle(neigh(id_tri,1),10) == -4)
       triangle(neigh(id_tri,1),10) = -2;
    end
end
end

if(neigh(id_tri,2) ~= -1)
if(triangle(neigh(id_tri,2),10) ~=0)
    queue(end+1,1) = neigh(id_tri,2);
    queue(end,2) = triangle(id_tri,1);
    queue(end,3) = triangle(id_tri,3);
    if(triangle(neigh(id_tri,2),10) == -1 || triangle(neigh(id_tri,2),10) == -4)
       triangle(neigh(id_tri,2),10) = -2;
    end
 
end
end

if(neigh(id_tri,3) ~= -1)
if(triangle(neigh(id_tri,3),10) ~=0)
    queue(end+1,1) = neigh(id_tri,3);
    queue(end,2) = triangle(id_tri,1);
    queue(end,3) = triangle(id_tri,2);
    if(triangle(neigh(id_tri,3),10) == -1 || triangle(neigh(id_tri,3),10) == -4)
       triangle(neigh(id_tri,3),10) = -2;
    end
    
end
end

for i = 1:3
    for j = 1:node(triangle(id_tri,i)).tot_triangles
        
           if( triangle(node(triangle(id_tri,i)).triangles(j),10) ~= 0 ...
                && node(triangle(id_tri,i)).triangles(j) ~= id_tri ...
                && node(triangle(id_tri,i)).triangles(j) ~= neigh(id_tri,1)...
                && node(triangle(id_tri,i)).triangles(j) ~= neigh(id_tri,2)...
                && node(triangle(id_tri,i)).triangles(j) ~= neigh(id_tri,3))
           
               queue(end+1,1) = node(triangle(id_tri,i)).triangles(j);
               queue(end,2) = triangle(id_tri,i);
               queue(end,3) = 0; % per scrupolo
               
               if(triangle(node(triangle(id_tri,i)).triangles(j),10) == -1 || ...
                  triangle(node(triangle(id_tri,i)).triangles(j),10) == -4)
                  triangle(node(triangle(id_tri,i)).triangles(j),10) = -3;
               end
           end
    end
end
end

