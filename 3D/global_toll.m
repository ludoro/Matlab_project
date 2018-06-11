%vogliamo trovare una tollerenza globale
%Media aritmetica delle lunghezze in norma 1 moltiplicata per 
%un valore predefinito di accuracy.
global toll;
sum = 0;
v = [0,0,0];
for i = 1:n_edges
    v = node(edge(i).P(2)).coord - node(edge(i).P(1)).coord;
    sum = sum + norm(v,1);
end
toll = sum/n_edges*accuracy;
