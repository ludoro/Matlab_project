%Inizializzo le variabili che mi servono. Per alleggerire la scrittura 
%chiamiamo il vettore di edge che vanno nel nodo in esame "e".
absolute_toll = 0;
for id_n=1:n_nodes
sum = 0;
tot_edges = node(id_n).tot_edges;
e = node(id_n).edges;

%L'idea è che per ogni nodo, trovo la lunghezza di tutti i segmenti e ne 
%faccio la media. Abbiamo utilizzato la norma inf per evitare la radice 
%quadrata visto che è un'operazione dispendiosa. 
for i=1:tot_edges
        v_temp = [node(edge(e(i),2)).x - node(edge(e(i),1)).x;
                  node(edge(e(i),2)).y - node(edge(e(i),1)).y];    
        sum = sum + norm(v_temp,inf);
      
end
node(id_n).toll = sum/tot_edges*(accuracy);
absolute_toll = absolute_toll + node(id_n).toll;
end
absolute_toll = absolute_toll/n_nodes;

for i=1:n_traces
    toll_t(i)= absolute_toll/norm(T(i,:),1);
end