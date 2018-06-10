function [] = show_all_shared(id_f)
global info_fract
for i=1:length(info_fract(id_f).near_tet)
    show_shared(id_f,i)
end
end

