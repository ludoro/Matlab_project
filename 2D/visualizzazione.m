id_t=2;
for i = 1:length(info_trace(id_t).cut_tri)
v_tagliati(i) = info_trace(id_t).cut_tri(i).id;

end
for i = 1:length(info_trace(id_t).near_tri)
    v_vicini(i).id = info_trace(id_t).near_tri(i).id;
    v_vicini(i).nodes = info_trace(id_t).near_tri(i).nodes;
    [v_vicini(i).id, v_vicini(i).nodes]
end
for i=1:n_nodes
    v_side_nodi(i,:)=[i, node(i).side, node(i).s];
end

