global toll;
sum = 0;
v = [0,0,0];
for i = 1:n_edges
    v(1) = node(edge(i).P(2)).x - node(edge(i).P(1)).x;
    v(2) = node(edge(i).P(2)).y - node(edge(i).P(1)).y;
    v(3) = node(edge(i).P(2)).z - node(edge(i).P(1)).z;
    sum = sum + norm(v,1);
end
toll = sum/n_edges*accuracy;
