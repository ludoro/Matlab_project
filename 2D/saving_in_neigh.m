for j=1:3
    if(neigh(id_tri,points_together(i))~= -1)
        if(neigh(neigh(id_tri,points_together(i)),j)==id_tri)
            triangle(neigh(id_tri,points_together(i)),j+3)=...
            tr(points_together(i)+3);
            triangle(neigh(id_tri,points_together(i)),j+6) = s_temp(i);
        end
    end
end