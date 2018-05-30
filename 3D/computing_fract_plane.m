coord_to_use = zeros(n_fracts,2);
N_temp = zeros(3,1);

for id_f = 1:n_fracts
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
    if(abs(fract(id_f).N(max)) < abs(fract(id_f).N(2)))
       max = 2;
    end
    if(abs(fract(id_f).N(max)) < abs(fract(id_f).N(3)))
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
    
    % calcolo anche il baricentro (2 coordinate) e il raggio
    
    g_temp = [0,0];
    for i = 1:fract(id_f).n_points
        g_temp = g_temp + fract_vertex(fract(id_f).P(i),...
                                       coord_to_use(id_f,:));
    end
    fract(id_f).G = g_temp/fract(id_f).n_points;
    
    max = norm(fract_vertex(fract(id_f).P(1),coord_to_use(id_f,:)) - ...
                fract(id_f).G,inf);
    for i = 2:fract(id_f).n_points
        r_temp = norm(fract_vertex(fract(id_f).P(i),coord_to_use(id_f,:)) - ...
                fract(id_f).G,inf);
        if(r_temp > max)
            max = r_temp;
        end
    end
    fract(id_f).r = max;
    
    %riempio il campo fract.side_int
    %prima di poter chiamare la funzione which_side_2D era necessario conoscere
    %la tolleranza "toll"
    fract(id_f).side_int = which_side_2D(fract(id_f).G, ...
        fract_vertex(fract(id_f).P(1),coord_to_use(id_f,:)), ...
        fract_vertex(fract(id_f).P(2),coord_to_use(id_f,:)));
    
    
    clear max r_temp;
    % metto i vertici di ogni frattura in info_fract.points

    info_fract(id_f).points = zeros(fract(id_f).n_points,3);
    for j = 1:fract(id_f).n_points
        info_fract(id_f).points(j,:) = fract_vertex(fract(id_f).P(j),:);
    end

end

