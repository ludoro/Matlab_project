%Script che trova tutti i tetraedri condivisi da un nodo 

for i=1:n_tets
    %Inizialmente il tot_tets � 0 per ogni nodo
    %Scorriamo tutti i tetraedri e aggiungiamo per ciascuno dei 4 nodi
    %dell' i-esimo tetraedro l'indice del tetraedro nel vettore
    %node(...).tets e infine aumentiamo il tot_tets che conta il numero di 
    %tetraedri condivisi.
    
    
    n_1 = node(tets(i,1)).tot_tets; 
    node(tets(i,1)).tet(n_1+1) = i; 
    node(tets(i,1)).tot_tets = n_1+1; 
    
    n_2 = node(tets(i,2)).tot_tets; 
    node(tets(i,2)).tet(n_2+1) = i; 
    node(tets(i,2)).tot_tets = n_2+1;
    
    n_3 = node(tets(i,3)).tot_tets; 
    node(tets(i,3)).tet(n_3+1) = i; 
    node(tets(i,3)).tot_tets = n_3+1;
    
    n_4 = node(tets(i,4)).tot_tets; 
    node(tets(i,4)).tet(n_4+1) = i; 
    node(tets(i,4)).tot_tets = n_4+1;
end

clear n_1 n_2 n_3 n_4 ; 
