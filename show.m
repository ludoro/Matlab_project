axes('XAxisLocation','origin','YAxisLocation','origin')
hold on

for i=1:n_edges
    plot([node(edge(i,1)).x node(edge(i,2)).x],...
         [node(edge(i,1)).y node(edge(i,2)).y],...
         '.-b');
    hold on
end

for i=1:n_traces
    plot([trace_vertex(trace(i,1),1) trace_vertex(trace(i,2),1)],...
         [trace_vertex(trace(i,1),2) trace_vertex(trace(i,2),2)],...
         '.-r');
    hold on
end
axis equal