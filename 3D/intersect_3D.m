function [it_is_cut] = intersect_3D(id_f,id_node_plane,third_coord)
%Questa funzione va a riempire info_trace.div
%id_f = id della frattura
%node_plane = i punti di taglio del piano
%id_node_plane = indici da considerare di node plane

% it_is_cut = 0 se non è tagliato
% it_is_cut = 1 se è tagliato nello step 3 
% it_is_cut = 2 non è tagliato quando tetraedro è appoggiato sul piano
% se n_to_check == 2:
% it_is_cut == 0 o 1
global fract_vertex;
global coord_to_use;
global info_fract;
global fract;
global node_plane;
global info_node;
it_is_cut=0;

%salvo subito coordinate frattura
num_f = fract(id_f).n_points;
F = zeros(num_f,2);
for i = 1:num_f
    F(i,:) = fract_vertex(fract(id_f).P(i),coord_to_use(id_f,:));
end
n_to_check = length(id_node_plane);
P = zeros(n_to_check,2);
for i = 1:n_to_check
    P(i,:) = node_plane(id_node_plane(i)).coord;
end

%-----STEP 1-----------
%controllo grossolano
G_f = fract(id_f).G;
r_f = fract(id_f).r;

g_temp = [0,0];
for i = 1:n_to_check
    g_temp = g_temp + P(i,:);
end
G_p = g_temp/n_to_check;

r_p = norm(P(1,:)-G_p,inf);
for i = 2:n_to_check
    r_temp = norm(P(i,:)-G_p,inf);
    if(r_p < r_temp)
        r_p = r_temp;
    end
end
% se la distanza dei due baricentri è maggiore della somma dei due raggi, 
% allora non si toccano
if(norm(G_f-G_p,inf) > r_p + r_f)
    it_is_cut = 0;
    
else
    %tutta l'impronta è tutta interna o ha almeno un punto esterno
    
    %--------------------------STEP 2----------------------------------
    %impronta tutta interna 
    side = zeros(n_to_check,num_f);
    for i=1:n_to_check
        if(isempty(node_plane(id_node_plane(i)).sides))
            node_plane(id_node_plane(i)).sides = zeros(num_f,1);
            for j=1:num_f
                node_plane(id_node_plane(i)).sides(j) = ...  
                which_side_2D(P(i,:),F(j,:),F(mod(j,num_f)+1,:));
            end
        end
        side(i,:) = node_plane(id_node_plane(i)).sides;
    end
    
    %salvo il "side campione"
    side_int = fract(id_f).side_int;
    it_is_out = zeros(n_to_check,1);
    some_out = 0;
    for i = 1:n_to_check
        if(node_plane(id_node_plane(i)).is_out==-1)
            node_plane(id_node_plane(i)).is_out=0;
            j=1;
            while(node_plane(id_node_plane(i)).is_out == 0 && j <= num_f)
                if(side(i,j) == -side_int)
                    some_out = 1;
                    node_plane(id_node_plane(i)).is_out = 1;
                end
                j = j + 1;
            end
        elseif(node_plane(id_node_plane(i)).is_out==1)
            some_out=1;
        end
    end
    
    %inserisco i punti interni in info_fract.points
    for i = 1:n_to_check
        if(node_plane(id_node_plane(i)).is_out == 0 ...
           && node_plane(id_node_plane(i)).in_info == -1 )
            %inserisco il punto in info_fract.points
            info_fract(id_f).points(end+1,coord_to_use(id_f,:))=P(i,:);
            %calcolo la terza coordinata 
            %con indice = 6-coord_to_use(id_f,1)-coord_to_use(id_f,2)
            info_fract(id_f).points(end,6-coord_to_use(id_f,1)-coord_to_use(id_f,2)) = ...
                third_coord(i);
            node_plane(id_node_plane(i)).in_info = size(info_fract(id_f).points,1);
        end
    end
    
    
    if(n_to_check > 2)
        
    if(some_out == 0)
        
        %faccio poligonazione
        if(isempty(info_fract(id_f).pol(1).v))
            info_fract(id_f).pol(1).v=zeros(n_to_check,1);
        else
            info_fract(id_f).pol(end+1).v=zeros(n_to_check,1);
        end
        for i = 1:n_to_check
            info_fract(id_f).pol(end).v(i)=node_plane(id_node_plane(i)).in_info;
        end
        it_is_cut = 2;
        %modifico protocol
        fract(id_f).protocol = 0;
    else
        %-----------STEP 3--------------------
        
        %!!!!!!!!!!!! DEGUGGING !!!!!!!!!!!
        %disp('entrato step3');
        
        %controllo ed eventualmente inverto P per avere verso concorde
        %controllo con prodotto vettoriale
        v_1 = F(2,:) - F(1,:);
        v_2 = F(3,:) - F(2,:);
        orient_f = v_1(1)*v_2(2)-v_1(2)*v_2(1);
        v_1 = P(2,:) - P(1,:);
        v_2 = P(3,:) - P(2,:);
        orient_p = v_1(1)*v_2(2)-v_1(2)*v_2(1);
        
        %in questo caso sono discordi quindi devo invertire P
        if( (orient_f < 0 && orient_p > 0) ||  ...
            (orient_f > 0 && orient_p < 0) )
            if(n_to_check == 3)
                temp = id_node_plane(3);
                id_node_plane(3) = id_node_plane(1);
                id_node_plane(1) = temp;
                
            else
                temp = id_node_plane(4);
                id_node_plane(4) = id_node_plane(1);
                id_node_plane(1) = temp;
                
                temp = id_node_plane(3);
                id_node_plane(3)= id_node_plane(2);
                id_node_plane(2) = temp;
            end
        end
        
        %salvo temporaneamente il poligono, successivamente considero se
        %salvarlo su info_fract oppure no
        pol_temp = [];
        P_intersect = [0 0; 0 0];
        n_intersect = 0;
        in = 0;
        in_first = 0;
        out = 0;
        out_temp = 0;
        for i = 1:n_to_check
            %------comincio "girotondo"------
            if(node_plane(id_node_plane(i)).is_out == 0)
                %già messo in info_fract.points nello step 2
                pol_temp(end+1) = node_plane(id_node_plane(i)).in_info;
            end   
            %controllo che i punti(i i+1) non siano entrambi dentro
            if( node_plane(id_node_plane(i)).is_out == 1 || ...
                node_plane(id_node_plane(mod(i,n_to_check)+1)).is_out == 1)
                %controllo che id_node_plane(i+1) sia tra i "vicini" di
                %id_node_plane(i)
                j = 1;
                flag = 0;
                while(j <= size(node_plane(id_node_plane(i)).near_nodes,1)...
                        && flag == 0)
                    if(node_plane(id_node_plane(i)).near_nodes(j,1) == ...
                       id_node_plane(mod(i,n_to_check)+1))
                        %id_node_plane(i+1) E' VICINO di id_node_plane(i)
                        flag = 1;
                        %a = posizione delle informazioni su info_node
                        a = node_plane(id_node_plane(i)).near_nodes(j,2);%(j,2)informazioni nodo vicino
                        if(a == -1)%no intersezione, quindi no informazioni 
                            n_intersect = 0;
                            in = 0;
                            out_temp = 0;
                            in_info = [0 0];
                        else
                            n_intersect = info_node(a).n_intersect;
                            in = info_node(a).in;
                            out_temp = info_node(a).out;
                            in_info = info_node(a).in_info;
                        end
                    end
                    j = j + 1;
                end
                
                if(flag == 0)
                    %se è 0 significa che %id_node_plane(i+1) NON ERA tra i
                    %.near_nodes di id_node_plane(i), quindi dobbiamo aggiungerlo
                    [P_intersect,n_intersect,in,out_temp]... 
                     = intersect_2D(id_f,id_node_plane(i),...
                              id_node_plane(mod(i,n_to_check)+1));
                          
                    
                    
                    in_info = [0 0];
                    
                    %lato "trapassa" la frattura
                    if(in ~= 0 || out_temp ~= 0)
                        
                        %salvare in info_nodes
                        %Nell'impronta vicina, il verso è opposto!!!!!
                        info_node(end+1).in = out_temp;
                        info_node(end).out = in;
                        info_node(end).n_intersect = n_intersect;
                        
                        %salvare in info_fract le intersezioni
                        for k = 1:n_intersect
                            info_fract(id_f).points(end+1,coord_to_use(id_f,:))=...
                                P_intersect(k,:);

                            %calcolo coordinata mancante
                            info_fract(id_f).points(end,6-coord_to_use(id_f,1)...
                                                   -coord_to_use(id_f,2)) = ...
                            -(fract(id_f).N(coord_to_use(id_f,1))*P_intersect(k,1) + ...
                              fract(id_f).N(coord_to_use(id_f,2))*P_intersect(k,2) + ...
                              fract(id_f).d)/(fract(id_f).N(...
                              6-coord_to_use(id_f,1)-coord_to_use(id_f,2)));

                            in_info(k) = size(info_fract(id_f).points,1);
                        end
                        %se le intersezioni sono 2, il giro successivo
                        %l'ordine E' SCAMBIATO!!!!
                        if(n_intersect==2)
                            info_node(end).in_info = in_info([2 1]);
                        else
                            info_node(end).in_info = in_info;
                        end
                        %salvo su node_plane.near_nodes, ho trovato dei
                        %nuovi vicini
                        node_plane(id_node_plane(i)).near_nodes(end+1,1) = ...
                            id_node_plane(mod(i,n_to_check)+1);
                        node_plane(id_node_plane(i)).near_nodes(end,2) = ...
                            length(info_node);
                        
                        node_plane(id_node_plane(mod(i,n_to_check)+1)).near_nodes(end+1,1) = ...
                            id_node_plane(i);
                        node_plane(id_node_plane(mod(i,n_to_check)+1)).near_nodes(end,2) = ...
                            length(info_node);
                            
                            
                    else%non devo salvare nulla
                        node_plane(id_node_plane(i)).near_nodes(end+1,1) = ...
                            id_node_plane(mod(i,n_to_check)+1);
                        node_plane(id_node_plane(i)).near_nodes(end,2) = -1;
                        node_plane(id_node_plane(mod(i,n_to_check)+1)).near_nodes(end+1,1) = ...
                            id_node_plane(i);
                        node_plane(id_node_plane(mod(i,n_to_check)+1)).near_nodes(end,2) = -1;
                    end 
                end

                %----blocco algoritmico di "uscita/entrata" dalla frattura-
                if(in ~= 0)
                    if(out == 0)
                        in_first = in;
                    else%out ~= 0 
                        %devo andare ad inserire i punti in mezzo
                        j = out;
                        while(j ~= in)
                            j = mod(j,num_f)+1;
                            pol_temp(end+1) = j;
                        end
                    end
                end
                %out è l'entrata nella frattura precedente, ora lo aggiorno
                % se out_temp = 0 non sono uscito, quindi non devo fare
                % nulla
                % se out_temp ~= 0 allora è uscito e aggiorno out
                if(out_temp ~= 0) 
                    out = out_temp;
                end
                
                %inserisco le eventuali intersezioni
                for j = 1:n_intersect
                    %forse dovrebbe essere =
                    %node_plane(id_node_plane(i)).in_info(j)???
                    %pol_temp(end+1) = in_info(j);
                    pol_temp(end+1) = in_info(j);
                end
            end
        end
        
        if(in_first ~= 0)
            %devo inserire punti tra out e in_first
             j = out;
             
             while(j ~= in_first)
                j= mod(j,num_f) + 1;
                pol_temp(end+1) = j;
             end
        end
        
        %DETTAGLIO: quando è tagliato oppure no?
        
        if(length(pol_temp) > 2)
            if(isempty(info_fract(id_f).pol(1).v))
                info_fract(id_f).pol(1).v = pol_temp;
            else
                info_fract(id_f).pol(end+1).v = pol_temp;
            end
            it_is_cut = 1;
            %modifico protocol
            fract(id_f).protocol = 0;
        else
            if(fract(id_f).protocol == -1)
                
                %controllo se baricentro della frattura è interno o esterno
                side_int_imprint = which_side_2D(G_p,...
                                   node_plane(id_node_plane(1)).coord,...
                                   node_plane(id_node_plane(2)).coord);
                G_f_is_out = 0; %flag che indica in o out di G_f
                c = 1;
                while(c <= n_to_check && G_f_is_out == 0)
                    side_G_f = which_side_2D(G_f,...
                                node_plane(id_node_plane(c)).coord,...
                                node_plane(id_node_plane(mod(c,n_to_check)+1)).coord);
                    if(side_G_f == -side_int_imprint)
                        G_f_is_out = 1;
                    end
                    c = c+1;
                end
                if(G_f_is_out == 0)
                    fract(id_f).protocol = 1;
                    it_is_cut = 1;
                end
            end
            
            if(fract(id_f).protocol ~= 1)
                
                if(length(pol_temp) == 2)
                    counter = 0;
                    points_inside = [0 0];
                    for i = 1:n_to_check
                        if(node_plane(id_node_plane(i)).is_out == 0)
                            counter = counter + 1;
                            points_inside(counter) = id_node_plane(i);
                        end
                    end
            
                    if(counter == 2)
                        if(node_plane(points_inside(1)).from_edge == 0 && ...
                           node_plane(points_inside(2)).from_edge == 0)
                            it_is_cut = 0;
                        else%almeno un vertice non veramente vertice del tetraedro
                            it_is_cut = 1;
                        end

                    else%counter == 1 || counter == 0
                        it_is_cut = 1;
                    end
            
                elseif(length(pol_temp) == 1)
                    i=1;
                    one_inside = 0;
                    %cerco quale vertice è interno
                    while(i <= n_to_check && one_inside == 0)
                        if(node_plane(id_node_plane(i)).is_out == 0)
                            one_inside = i;
                        end
                        i=i+1;
                    end
                    
                    if(one_inside == 0)
                        it_is_cut = 1;
                    else%one_inside == nodo interno
                        if(node_plane(id_node_plane(one_inside)).from_edge == 1)
                            it_is_cut = 1;
                        else
                            it_is_cut = 0;
                        end
                    end
                else%lenght(pol_temp) == 0
                    
                    if(in_first == 0)
                        
                        %controllo G_f
                        %so che se mi trovo in questo punto allora
                        %fract.protocol~=1, quindi G_f è esterno    
                        it_is_cut=0;
                    else%in_first ~= 0
                        %so che se mi trovo in questo punto allora
                        %fract.protocol~=1, quindi G_f è esterno
                       
                        it_is_cut=1;
                    end
                end
            end
        end
       
    end
    
    else % n_to_check == 2
        if(node_plane(id_node_plane(1)).is_out == 0 && ...
           node_plane(id_node_plane(2)).is_out == 0)
            %entrambi interni, non c'è taglio.
            it_is_cut = 0;
            
        else%bisogna vedere se sono propriamente interni
            it_is_in = [1,1];
            
            for i = 1:2
                j = 1;
                while(j <= num_f && it_is_in(i) == 1)
                    if(side(i,j) ~= side_int)
                        it_is_in(i) = 0;
                    end
                    j=j+1;
                end 
            end
            if(it_is_in(1) == 1 || it_is_in(2) == 1)
                it_is_cut = 1;
                
            else%nessuno dei due è totalmente interno
                % due esterni oppure uno completamente esterno e uno
                % frontiera
                
               
             
                if(node_plane(id_node_plane(1)).is_out == 1 && ...
                    node_plane(id_node_plane(2)).is_out == 1)
                    [garbage1,garbage2,in,out]... 
                      = intersect_2D(id_f,id_node_plane(1),id_node_plane(2));
                    if(in ~= 0 && out ~=0 && in ~= out)
                        it_is_cut = 1;
                    else
                        it_is_cut = 0;
                    end
                else
                    n_intersect = intersect_2D_bis(id_f,id_node_plane(1),id_node_plane(2));
                    n_intersect
                    if(n_intersect == 1)
                        it_is_cut=0;
                    else%n_intersect = 2
                        it_is_cut=1;
                    end
                end
            end
        end
    end
end
end