function [] = show_all(id_f)
global tet;
global info_fract;
global fract;
global n_fracts;
global fract_vertex;
global n_tets;

show_fract;
show_fract_pol;
show_near_tet(id_f);
for id_tet = 1:n_tets
    if(tet(id_tet).status_queue ~= 0)
        show_single_tet(id_tet,0);
    end
    
end
    for id_tet = 1:length(info_fract(id_f).cut_tet)
        show_tet_poly(id_f,id_tet);
    end
end