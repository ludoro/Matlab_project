function id_e = which_edge(p_1,p_2)
global node;
found = 0;
i = 1;
j = 1;
id_e = -1;
%controlliamo tra gli edge che condividono p_1 e p_2
while(found == 0 && i <= node(p_1).tot_edges)
    j = 1;
    while(found == 0 && j <= node(p_2).tot_edges)
        if(node(p_1).edges(i) == node(p_2).edges(j))
            id_e = node(p_1).edges(i);
            found = 1;
        end
        j = j + 1;
    end
    i = i + 1;
end
end
