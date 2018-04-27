%Usiamo un procedimento analogo al caso 2D per calcolare le tolleranze, 
%Facciamo una media delle lunghezze (norme computazionalmente convenienti)
%dei segmenti che hanno quel nodo come estremo.

absolute_toll = 0 ;
for id_n=1:n_nodes
    sum=0; 
    
    tot_edges = node(id_n).tot_edges;
    e = node(id_n).edges;
    
    for i=1:tot_edges
        v_temp = [node(edge(e(i),2)).x - node(edge(e(i),1)).x;
                  node(edge(e(i),2)).y - node(edge(e(i),1)).y;
                  node(edge(e(i),2)).z - node(edge(e(i),1)).z];
        sum = sum + norm(v_temp,inf);
    end 
    
    node(id_n).toll = sum/tot_edges*(1e-14);
    absolute_toll = absolute_toll + node(id_n).toll; 
end

absolute_toll = absolute_toll/n_nodes; 
