for i=1:n_edges
    %Inizialmente il tot_edges è 0. 
    %Scorriamo tutti gli n_edges e aggiungiamo, per entrambi i nodi 
    %dell'i-esimo edge, l'indice corrente dell'edge nel vettore 
    %node(...).edges e di conseguenza aumentiamo il numero di edge
    %condivisi. Analogo al caso 2D. 
    
    n_1 = node(edge(i,1)).tot_edges; 
    node(edge(i,1)).edges(n_1+1) = i; 
    node(edge(i,1)).tot_edges = n_1 + 1; 
    
    n_2 = node(edge(i,2)).tot_edges; 
    node(edge(i,2)).edges(n_2+1) = i;
    node(edge(i,2)).tot_edges = n_2+1; 
    
end
   
