
found=0;
id_tri=1;       %id del triangolo in esame
s_temp=[0 0]; %le coordinate curvilinee dell'eventuale intersezione
s_intersect = 0; %usato in (sum == 3 o sum == 5): s restituita da intersect
tr=zeros(1,10);  %le info del triangolo corrente
side=[0 0 0];   %i semipiani di appartenenza dei tre vertici
called_which_side=[0, 0, 0]; %vettore che ci dice se abbiamo già chiamato la 
                           %funzione which_side, per l'i-esimo nodo,
                           % 0 --> no chiamata
                           % 1 --> si chiamata
status = [0, 0]; % status degli eventuali due lati intersecati
%usati in (sum==1 or sum==-1)
%usati in (sum==3 or sum==5) oppure in (sum==0 or sum==4)
node_on_trace=0;%indica nodo su traccia
nodes_on_trace=[];
points_together = [0,0];

%prima parte di ricerca
while(id_tri<=n_triangles && found==0)
    called_which_side=[0,0,0];
    tr=triangle(id_tri,:);
    for i=1:3
        if(node(tr(i)).side==0)
            [side(i), node(tr(i)).s]=which_side(id_t,tr(i));
            node(tr(i)).side=side(i);
            called_which_side(i) = 1;
        else
            side(i)=node(tr(i)).side;
        end
    end
    if(side(1)~=side(2) || side(2)~=side(3))    %potrebbe incrociare la traccia
        
        sum=side(1)+side(2)+side(3);
        
        %---------NESSUN VERTICE SULLA TRACCIA----------%
        if(sum==-1 || sum==1)
            
            
            %capire quali sono i due lati da controllare
            
            if(side(1)==side(2))
                points_together(1) = 1;
                points_together(2) = 2;
                lonely_point =3;
                
            elseif(side(2)==side(3))
                points_together(1) = 2;
                points_together(2) = 3;
                lonely_point =1;
                
            else %side(1)==side(3)
                points_together(1) = 3;
                points_together(2) = 1;
                lonely_point = 2;
                
            end
            
            %per ora s_temp non contiene info utili. se li status saranno
            %positivi, allora verranno salvati permanentemente
            
            %calcolo i due status dei lati se sconosciuti
            for i=[1 2]
                if(tr(points_together(i)+3)==-1)
                    %alla funzione intersect passo lonely point e
                    % l'altro point_together del segmento
                    % i = 1 ---> points_together(2)
                    % i = 2 ---> points_together(1)
                 
                    [tr(points_together(i)+3), s_temp(i)]=...
                        intersect(id_t, tr(lonely_point),...
                        tr(points_together(mod(i,2)+1)));
                    
                    %salvo le informazioni nella matrice globale
                    triangle(id_tri,points_together(i)+3)=...
                                        tr(points_together(i)+3);
                    triangle(id_tri,points_together(i)+6) = ...
                                        s_temp(i);
                                    
                    %salvo lo status anche nel triangolo vicino
                    saving_in_neigh;
                else
                    s_temp(i) = tr(points_together(i)+6);
                end
            end
            %tr(points_together([1 2])+3) contiene i due status
            status=tr(points_together([1 2])+3);
          
            if(status(1)~=0 || status(2)~=0)
                %IL TRIANGOLO SICURAMENTE TAGLIATO
                found = 1;
                it_is_cut;
                enqueue_tri_to_check(id_tri);
                
                if((status(1) == 0 && status(2) == 2) || ...
                   (status(2) == 0 && status(1) == 2) )
                    if(status(1) == 0 && status(2) == 2)
                        a = 2;
                    else
                        a = 1;
                    end
                    %La s che ci interessa è in s_temp(a)
                    
                    info_trace(id_t).s(end+1) = s_temp(a);
        
                    %Dobbiamo capire se vale 0 o 1, per inserire le
                    %coordinate del quarto punto.
                    
                    if(s_temp(a) == 0)
                        %è il primo punto della traccia 
                      info_trace(id_t).cut_tri(1).points(4,:) = ...
                      trace_vertex(trace(id_t,1),:);
                    else % s_temp(a)==1
                        info_trace(id_t).cut_tri(1).points(4,:) = ...
                        trace_vertex(trace(id_t,2),:);
                    end
       
                    %caso con 1 poligono(il triangolo intero)
                    %e due triangoli
                    info_trace(id_t).cut_tri(1).poly_1 = ...
                        [1,2,3,0];
                    
                    %inseriamo info per triangolazione
                   
                    if(a == 1)
                        info_trace(id_t).cut_tri(1).tri(1) = ...
                        [points_together(a),points_together(a+1),4];
                        info_trace(id_t).cut_tri(1).tri(2) = ...
                        [points_together(a),4,lonely_point];
                    
                    else%a == 2
                        info_trace(id_t).cut_tri(1).tri(1) = ...
                        [points_together(a-1),points_together(a),4];
                        info_trace(id_t).cut_tri(1).tri(2) = ...
                        [points_together(a),lonely_point,4];
                        
                    end
                      
                else % 3 triangoli nella triangolazione
              
                    %metto ascisse curvilinee dentro info_trace
                    for i = [1,2]
                        if(s_temp(i) <= 1 && s_temp(i)>=0)
                           info_trace(id_t).s(end+1) = s_temp(i);
                        end
                    end
                    
                    % trovo coordinate punti intersezione traccia-segmento
                    for i=[1,2]
                    info_trace(id_t).cut_tri(1).points(i+3,:) = ...
                        trace_vertex(trace(id_t,1),:) + s_temp(i)*...
                        (trace_vertex(trace(id_t,2),:) - ...
                        trace_vertex(trace(id_t,1),:));
                    end
                    
                    % ora che ho tutti i punti scrivo poligonalizzazione e
                    % e triangolazione
                    
                    %poligonalizzazione
                    info_trace(id_t).cut_tri(1).poly_1 = ...
                        [points_together(1),points_together(2),4,5];
                    
                    info_trace(id_t).cut_tri(1).poly_2 = ...
                        [4,lonely_point,5];
                    
                    %triangolazione 
                    
                    %il primo triangolo coincide con il secondo 
                    %poligono
                    info_trace(id_t).cut_tri(1).tri(1,:) = ...
                        info_trace(id_t).cut_tri(1).poly_2;
                    
                    info_trace(id_t).cut_tri(1).tri(2,:) = ...
                        [points_together(2),4,5];
                    
                    info_trace(id_t).cut_tri(1).tri(3,:) = ...
                        [points_together(1),points_together(2),5];
                end
                
 %--------UN VERTICE SULLA RETTA DELLA TRACCIA E GLI ALTRI DUE CONCORDI---
            
            % Da considerare più avanti se abbiamo tempo
            
            elseif(sum==0 || sum==4)
            %uso solo s_temp(1)
            for i=1:3
              
                if(side(i)==2)
                    s_temp(1)=node(tr(i)).s; % no taglio ma intersection
                end
            end
            %La s del nodo non è stata inserita in precedenza se è
            %stata chiamata which_side
            if(s_temp(1) >= 0 && s_temp(1)<= 1 && called_which_side(i) == 1)
                info_trace(id_t).s(end+1) = s_temp(1);
            end
            
            
            
            
            
        %-----NODO SULLA TRACCIA, ALTRI DUE DISCORDI--------
        elseif(sum==2)
            
        %trovo quale nodo sta sulla traccia e su opposite nodes metto gli
        %altri che mi serviranno per intersect e triangolazione
        if(side(1) == 2)
            node_on_trace = 1;
            opposite_nodes = [2,3];
            
        elseif(side(2) == 2)
            node_on_trace = 2;
            opposite_nodes = [3,1];
            
        else %(side(3) == 2)
            node_on_trace = 3;
            opposite_nodes = [1,2];
          
        end
        
        if(tr(node_on_trace+3) == -1)
            
        [tr(node_on_trace+3),s_temp(2)] = ...
            intersect(id_t,tr(opposite_nodes(1)),tr(opposite_nodes(2)));
        
        triangle(id_tri,node_on_trace+3) = tr(node_on_trace+3);
        triangle(id_tri,node_on_trace+6) = s_temp(2);
        
        
        %salvo lo status e la s anche nel triangolo vicino
        for j=1:3
            if(neigh(id_tri,node_on_trace)~= -1)
               if(neigh(neigh(id_tri,node_on_trace),j)==id_tri)
                  triangle(neigh(id_tri,node_on_trace),j+3)=...
                      tr(node_on_trace+3);
                  triangle(neigh(id_tri,node_on_trace),j+6) = s_temp(2);
                end
             end
        end
        
        end
        s_temp(1) = node(tr(node_on_trace)).s;
         
        if((s_temp(1) > 0 && s_temp(1) < 1) ||...
            (tr(node_on_trace+3) ~= 0) )
            % è tagliato 
            found = 1;
            it_is_cut;
             
            %trovo coordinate quarto punto
            info_trace(id_t).cut_tri(1).points(4,:) = ...
                       trace_vertex(trace(id_t,1),:) + s_temp(2)*...
                       (trace_vertex(trace(id_t,2),:) - ...
                       trace_vertex(trace(id_t,1),:));
                    
            %poligonalizzazione (coincide con triangolazione)
             
            info_trace(id_t).cut_tri(1).poly_1(1:3) = ...
                 [node_on_trace,opposite_nodes(1),4];
            info_trace(id_t).cut_tri(1).poly_2 = ...
                 [node_on_trace,4,opposite_nodes(2)];
             
             %triangolazione
            info_trace(id_t).cut_tri(1).tri(1,:) = ...
                 [node_on_trace,opposite_nodes(1),4];
            info_trace(id_t).cut_tri(1).tri(2,:) = ...
                 [node_on_trace,4,opposite_nodes(2)];
        end
        
        %Chiamo per triangoli vicini
        enqueue_tri_to_check(id_tri);
        
        % inserisco le s in info_trace
        if(s_temp(1) <= 1 && s_temp(1) >=0 && ... 
           called_which_side(node_on_trace) == 1 )
           info_trace(id_t).s(end+1) = s_temp(1);
        end
        
        if(s_temp(2) <= 1 && s_temp(2) >=0)
            info_trace(id_t).s(end+1) = s_temp(2);
        end
    
        else %sum==3 || sum==5 %traccia coincidente e parallela segmento
            
            %controllo quale nodo è fuori dal segmento parallelo
            
            if(side(1) ~= 2)
                lonely_point = 1;
                nodes_on_trace(1) = 2;
                nodes_on_trace(2) = 3;
            elseif(side(2) ~= 2)
                lonely_point = 2;
                nodes_on_trace(1) = 3;
                nodes_on_trace(2) = 1;
            else%side(3) ~=2
                lonely_point = 3;
                nodes_on_trace(1) = 1;
                nodes_on_trace(2) = 2;
            end
            
            s_temp(1) = node(tr(nodes_on_trace(1))).s;
            s_temp(2) = node(tr(nodes_on_trace(2))).s;
        
        % metto s in info_trace.s
        for i=1:2
            if(s_temp(i) <= 1 ...
               && s_temp(i) >= 0 ...
               && called_which_side(i)==1)
            info_trace(id_t).s(end+1) = s_temp(i);
            end
        end
            
        if(tr(lonely_point+3) == -1)
       
        [tr(lonely_point+3),s_intersect] = ...
            intersect(id_t,tr(nodes_on_trace(1)),tr(nodes_on_trace(2)));
        
        triangle(id_tri,lonely_point+3) = tr(lonely_point+3);
        triangle(id_tri,lonely_point+6) = s_intersect;
        
        %salvo lo status anche nel triangolo vicino
        for j=1:3
            if(neigh(id_tri,lonely_point,j)~= -1)
               if(neigh(neigh(id_tri,lonely_point),j)==id_tri)
                  triangle(neigh(id_tri,lonely_point),j+3)=...
                      tr(lonely_point+3);
                  triangle(neigh(id_tri,lonely_point),j+6)=...
                      s_intersect;
                end
            end
             
        end
  
        end
        
        %considero status(1)
        status(1) = tr(lonely_point+3);
        %status 0,3 e 4 non ci interessano perchè non è tagliato
        if(status(1) == 2)
           %tagliato
           found = 1;
           it_is_cut;
           info_trace(id_t).s(end+1) = s_intersect;
           
           if(s_intersect == 0)
              %è il primo punto della traccia 
              info_trace(id_t).cut_tri(1).points(4,:) = ...
              trace_vertex(trace(id_t,1),:);
            else % s_intersect==1
              info_trace(id_t).cut_tri(1).points(4,:) = ...
              trace_vertex(trace(id_t,2),:);
           end
           
           %p0lig0n0
           info_trace(id_t).cut_tri(1).poly_1 = [1,2,3];
                                           
           %triangolazione
           info_trace(id_t).cut_tri(1).tri(1,:) = ...
               [lonely_point,nodes_on_trace(1),4];
           
           info_trace(id_t).cut_tri(1).tri(2,:) = ...
               [lonely_point,4,nodes_on_trace(2)];
        
         elseif(status(1) == 5)
             %traccia interna al segmento CASO PATOLOGIC0
             
             %tagliato
             found = 1;
             it_is_cut;
             info_trace(id_t).s = [0,1];
             
             %Primo nodo della traccia o secondo nodo della traccia?
             if(s_temp(1) < 0)
                 info_trace(id_t).cut_tri(1).points(4,:) = ...
                     trace_vertex(trace(id_t,1),:);
                 info_trace(id_t).cut_tri(1).points(5,:) = ...
                    trace_vertex(trace(id_t,2),:);
             
             else%s_temp(1) > 1
                 info_trace(id_t).cut_tri(1).points(4,:) = ...
                     trace_vertex(trace(id_t,2),:);
                 info_trace(id_t).cut_tri(1).points(5,:) = ...
                    trace_vertex(trace(id_t,1),:);
             end
             
             %poligono
             info_trace(id_t).cut_tri(1).poly_1 = [1,2,3];
             
             %triangolazione
             info_trace(id_t).cut_tri(1).tri(1,:) = ...
                 [lonely_point,nodes_on_trace(1),4];
              
             info_trace(id_t).cut_tri(1).tri(1,:) = ...
                 [lonely_point,4,5];
             
             info_trace(id_t).cut_tri(1).tri(1,:) = ...
                 [lonely_point,5,nodes_on_trace(2)];
             
             %funzione per triangoli vicini
             enqueue_tri_to_check(id_tri);
             
        end
            end
        end
    end
    id_tri=id_tri+1;
end
num_tri_checked = id_tri-1;