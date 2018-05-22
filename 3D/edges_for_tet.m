%per ogni edge, in che tetraedro sono
for id_tet = 1:n_tets
    for i = 1:3
        for j = i+1:4
            e_temp = which_edge(tet(id_tet).P(i),tet(id_tet).P(j));
            edge(e_temp).tets(end+1) = id_tet;
            if(i == 1)
                tet(id_tet).edge(i+j-2) = e_temp;
            else
                tet(id_tet).edge(i+j-1) = e_temp;
            end
        end
    end
end
