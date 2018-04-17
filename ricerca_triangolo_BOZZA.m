%suppongo che la matrice 'triangle' abbia 6 colonne: dalla 4 alla 6
%contenenti gli status dei lati. Status sconociuto: -1
found=0;
id_tri=1;       %id del triangolo in esame
s_temp=[0 0];   %le coordinate curvilinee dell'eventuale intersezione
tr=zeros(1,6);  %le info del triangolo corrente
side=[0 0 0];   %i semipiani di appartenenza dei tre vertici

%usati in (sum==1 or sum==-1)
points_to_check=zeros(2,2);
edges_to_check=[0 0];
%usati in (sum==3 or sum==5) oppure in (sum==0 or sum==4)
points_on_trace=[0 0];
edge_on_trace=0;

%prima parte di ricerca
while(id_tri<=n_triangles && found==0)
    tr=triangle(id_tri,:);
    for i=1:3
        if(node(tr(i)).side==0)
            [side(i), node(tr(i)).s]=which_side(id_t,tr(i));
            node(tr(i)).side=side(i);
        else
            side(i)=node(tr(i)).side;
        end
    end
    if(side(1)~=side(2) || side(2)~=side(3))    %potrebbe incrociare la traccia
        
        sum=side(1)+side(2)+side(3);
        
        if(sum==-1 || sum==1)
            %NESSUN VERTICE SULLA RETTA DELLA TRACCIA
            
            %capire quali sono i due lati da controllare
            %points_to_check(i,:) sono i due punti di edges_to_check(i)
            if(side(1)==side(2))
                points_to_check(1,1)=tr(1); 
                points_to_check(1,2)=tr(3);
                points_to_check(2,1)=tr(2);
                points_to_check(2,2)=tr(3);
                edges_to_check(1)=5; %2+3
                edges_to_check(2)=4; %1+3
                
            elseif(side(2)==side(3))
                points_to_check(1,1)=tr(2);
                points_to_check(1,2)=tr(1);
                points_to_check(2,1)=tr(3);
                points_to_check(2,2)=tr(1);
                edges_to_check(1)=5; %2+3
                edges_to_check(2)=6; %3+3
                
            else %side(1)==side(3)
                points_to_check(1,1)=tr(1);
                points_to_check(1,2)=tr(2);
                points_to_check(2,1)=tr(3);
                points_to_check(2,2)=tr(2);
                edges_to_check(1)=4; %1+3
                edges_to_check(2)=6; %3+3
            end
            
            %per ora s_temp non contiene info utili. se li status saranno
            %positivi, allora verranno salvati permanentemente
            
            %calcolo i due status dei lati se sconosciuti
            for i=[1 2]
                if(tr(edges_to_check(i))==-1)
                    [tr(edges_to_check(i)), s_temp(i)]=...
                        intersect(id_t,points_to_check(i,1),points_to_check(i,2));
                    
                    %salvo le informazioni nella matrice globale
                    triangle(id_tri,edges_to_check(i))=tr(edges_to_check(i));
                    
                    %salvo lo status anche nel triangolo vicino
                    for j=1:3
                        if(neigh(neigh(id_tri,edges_to_check(i)-3),j)==id_tri)
                            triangle(neigh(id_tri,edges_to_check(i)-3),j+3)=tr(edges_to_check(i));
                        end
                    end
                end
            end
            %tr(edges_to_check([1 2])) contiene i due status
            status=tr(edges_to_check([1 2]));
            
            %se status(1)~=0 || status(2)~=0:
            % - ESEGUIRE TRIANGOLAZIONE; 
            % - found=1; 
            % - SALVARE COORDINATE CURVILINEE;
            % - METTERE IN CODA I TRIANGOLI VICINI;
            
            if(status(1)~=0 || status(2)~=0)
                %il triangolo � sicuramente tagliato
                info_trace(id_t).cut_tri(1).id = id_tri;
                %mettiamo info dei punti del triangolo che stiamo
                %considerando in info trace. 
                for j = 1:3
                    info_trace(id_t).cut_tri(1).points(j,1) = node(tr(j)).x;
                    info_trace(id_t).cut_tri(1).points(j,2) = node(tr(j)).y;
                end
               
                if(status(1) == 0 && status(2) == 2)
                    %La s che ci interessa � in s_temp(2)
                    
        
                    %Dobbiamo capire se vale 0 o 1, per inserire le
                    %coordinate del quarto punto.
                    
                    if(s_temp(2) == 0)
                        %� il primo punto della traccia 
                      info_trace(id_t).cut_tri(1).points(4,:) = ...
                      trace_vertex(trace(id_t,1),:);
                    else % s_temp(2)==1
                        info_trace(id_t).cut_tri(1).points(4,:) = ...
                      trace_vertex(trace(id_t,2),:);
                    end
       
                    info_trace(id_t).cut_tri(1).poly_1 = ...
                        [edges_to_check(2)-3, mod(edges_to_check(2)+1,3),4];
                
                    info_trace(id_t).cut_tri(1).poly_2 = ...
                        [edges_to_check(2)-3,4,mod(edges_to_check(2)+2,3)];
                
                    if(info_trace(id_t).cut_tri(1).poly_1(2) == 0)
                       info_trace(id_t).cut_tri(1).poly_1(2) = 3;
                    end
                    
                    if(info_trace(id_t).cut_tri(1).poly_2(3) == 0)
                       info_trace(id_t).cut_tri(1).poly_2(3) = 3;
                    end
                    
                    %inseriamo info per triangolazione
                    %in questo caso la triangolazione coincide con i due 
                    %poligoni 
                    
                    info_trace(id_t).cut_tri(1).tri(1,:) = ...
                        info_trace(id_t).cut_tri(1).poly_1(1:3);
                    
                    info_trace(id_t).cut_tri(1).tri(2,:) = ...
                        info_trace(id_t).cut_tri(1).poly_2;
                    
                    
                    
                    
                    %CREARE FUNZIONE PER TRIANGOLI VICINI 
                        
                
                elseif(status(1) == 2 && status(2) == 0)
                    
                    %La s che ci interessa � in s_temp(1)
                    
        
                    %Dobbiamo capire se vale 0 o 1, per inserire le
                    %coordinate del quarto punto.
                    
                    if(s_temp(1) == 0)
                        %� il primo punto della traccia 
                      info_trace(id_t).cut_tri(1).points(4,:) = ...
                      trace_vertex(trace(id_t,1),:);
                    else % s_temp(1)==1
                        info_trace(id_t).cut_tri(1).points(4,:) = ...
                      trace_vertex(trace(id_t,2),:);
                    end
       
                    info_trace(id_t).cut_tri(1).poly_1 = ...
                        [edges_to_check(1)-3, mod(edges_to_check(1)+1,3),4];
                
                    info_trace(id_t).cut_tri(1).poly_2 = ...
                        [edges_to_check(1)-3,4,mod(edges_to_check(1)+2,3)];
                
                    if(info_trace(id_t).cut_tri(1).poly_1(2) == 0)
                       info_trace(id_t).cut_tri(1).poly_1(2) = 3;
                    end
                    
                    if(info_trace(id_t).cut_tri(1).poly_2(3) == 0)
                       info_trace(id_t).cut_tri(1).poly_2(3) = 3;
                    end
                    
                    %inseriamo info per triangolazione
                    %in questo caso la triangolazione coincide con i due 
                    %poligoni 
                    
                    info_trace(id_t).cut_tri(1).tri(1,:) = ...
                        info_trace(id_t).cut_tri(1).poly_1(1:3); %#poly_1=4 
                    
                    info_trace(id_t).cut_tri(1).tri(2,:) = ...
                        info_trace(id_t).cut_tri(1).poly_2;
                    
                    
                    
                    
                    %CREARE FUNZIONE PER TRIANGOLI VICINI 
                    
                else % 3 triangoli nella triangolazione
                    
                    % richiamo la funzione intersect nel caso in cui lo
                    % status � uguale a 0, perch� potrei non conoscere la
                    % coordinata curvilinea.
                    for i =[1,2]
                    
                        if(status(i) == 0)
                            
                            [a,s_temp(i)] = ...
                                intersect(id_t,points_to_check(i,1),...
                                           points_to_check(i,2));
                        if(a~=0)
                            disp("ERRORE");
                            clear a;
                        end
      
                        end
                    end
                    
                    % trovo coordinate punti intersezione traccia-segmento
                    
                    
                    
                    
                    
                    
                    
                    
                  
                  
                        
                        
                   
                    
                   
             
                
                
                
                
            
                
          
        elseif(sum==0 || sum==4)
            %UN VERTICE SULLA RETTA DELLA TRACCIA E GLI ALTRI DUE CONCORDI
            
            %uso solo s_temp(1) e nodes_on_trace(1)
            for i=1:3
                if(side(i)==2)
                    s_temp(1)=node(tr(i)).s;
                    nodes_on_trace(1)=tr(i);
                end
            end
            
            
            
            
        elseif(sum==2)
            
            
        else %sum==3 || sum==5
            
            
            
        end
        
        
        
    end
        
    
    
    id_tri=id_tri+1; 
end