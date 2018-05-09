coord_to_use = zeros(n_fractures,2);
N_temp = zeros(3,1);

for id_f = 1:n_fractures
    for i = 2:(fract(id_f).n_points-1)
        v_1 = fract_vertex(fract(id_f).P(i),:) - ...
              fract_vertex(fract(id_f).P(1),:);
        v_2 = fract_vertex(fract(id_f).P(i+1),:) - ...
              fract_vertex(fract(id_f).P(1),:);
          
        N_temp(1) = v_1(2)*v_2(3) - v_1(3)*v_2(2);
        N_temp(2) = v_1(3)*v_2(1) - v_1(1)*v_2(3);
        N_temp(3) = v_1(1)*v_2(2) - v_1(2)*v_2(1);
        
        fract(id_f).N = fract(id_f).N + N_temp;
    end
    fract(id_f).N = fract(id_f).N/norm(fract(id_f).N,1);
    fract(id_f).d = -(fract(id_f).N(1)*fract_vertex(fract(id_f).P(1),1)+...
                      fract(id_f).N(2)*fract_vertex(fract(id_f).P(1),2)+...
                      fract(id_f).N(3)*fract_vertex(fract(id_f).P(1),3));
    
    %Cerchiamo la coordinata massima di .N per proiezione ottimale
    max = 1;
    if(fract(id_f).N(max) < fract(id_f).N(2))
       max = 2;
    end
    if(max < fract(id_f).N(3))
       max = 3;
    end
    
    if(max == 1)
        coord_to_use(id_f,1) = 2;
        coord_to_use(id_f,2) = 3;
    elseif(max == 2)
        coord_to_use(id_f,1) = 1;
        coord_to_use(id_f,2) = 3;
    else%max == 3
        coord_to_use(id_f,1) = 1;
        coord_to_use(id_f,2) = 2;
    end                   
end