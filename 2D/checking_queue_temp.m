
while(size(queue_temp,1)>0)
    
    called_which_side=[0,0,0];
    called_intersect =[0,0,0];
    id_tri = queue_temp(1,1); % prendo il primo triangolo nella coda
    
    %controllo solo se non Ë gi‡ stato controllato
    if(triangle(id_tri,10)==-4)
        
        tr=triangle(id_tri,:);
        %chiamo which_side se serve
        for i=1:3
            if(node(tr(i)).side==0)
                [side(i), node(tr(i)).s]=which_side(id_t,tr(i));
                node(tr(i)).side=side(i);
                called_which_side(i) = 1;
            else
               side(i)=node(tr(i)).side;
            end
        end
        
        sum=side(1)+side(2)+side(3);

        %il caso sum==0 || sum==4 non Ë da considerare
        
%--------------- 1 NODO SULLA TRACCIA, ALTRI 2 DISCORDI -------------------
        if(sum==2)
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
            % s_temp(1) = s del nodo
            % s_temp(2) = s del lato tagliato dalla traccia
            if(tr(node_on_trace+3) == -1) %status del lato non conosciuto

                [tr(node_on_trace+3),s_temp(2)] = ...
                    intersect(id_t,tr(opposite_nodes(1)),tr(opposite_nodes(2)));

                called_intersect(node_on_trace)=1;
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
            else% status del lato conosciuto
                s_temp(2) = tr(node_on_trace+6);
            end
            
            s_temp(1) = node(tr(node_on_trace)).s;
            
            %inserisco le s in infotrace.s
            %provo a inserire solo quella del lato (s_temp(2)), quella del
            %nodo deve essere gi‡ stata inserita
            
            if(s_temp(2) <= 1 && s_temp(2) >=0 && ...
               called_intersect(node_on_trace) == 1)
                info_trace(id_t).s(end+1) = s_temp(2);
            end
            
            if((s_temp(1) > 0 && s_temp(1) < 1) ||...
            (tr(node_on_trace+3) ~= 0) )
            % √ tagliato 
            it_is_cut;
            enqueue_tri_to_check(id_tri);
            %trovo coordinate quarto punto
            info_trace(id_t).cut_tri(end).points(4,:) = ...
                       trace_vertex(trace(id_t,1),:) + s_temp(2)*...
                       (trace_vertex(trace(id_t,2),:) - ...
                       trace_vertex(trace(id_t,1),:));
                    
            %poligonalizzazione (coincide con triangolazione)
            info_trace(id_t).cut_tri(end).poly_1 = ...
                 [node_on_trace,opposite_nodes(1),4,0];
            info_trace(id_t).cut_tri(end).poly_2 = ...
                 [node_on_trace,4,opposite_nodes(2)];
             
             %triangolazione
            info_trace(id_t).cut_tri(end).tri(1,:) = ...
                 [node_on_trace,opposite_nodes(1),4];
            info_trace(id_t).cut_tri(end).tri(2,:) = ...
                 [node_on_trace,4,opposite_nodes(2)];
            end
            
%-------------- 2 NODI SULLA TRACCIA --------------------------
        elseif(sum==3 || sum==5)
            
            %controllo quale nodo √® fuori dal segmento parallelo
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
                   && called_which_side(nodes_on_trace(i))==1)

                   info_trace(id_t).s(end+1) = s_temp(i);

                end
            end
            
            %chiamo intersect
            if(tr(lonely_point+3) == -1)
       
                [tr(lonely_point+3),s_intersect] = ...
                    intersect(id_t,tr(nodes_on_trace(1)),tr(nodes_on_trace(2)));
                called_intersect(lonely_point) = 1;
                triangle(id_tri,lonely_point+3) = tr(lonely_point+3);
                triangle(id_tri,lonely_point+6) = s_intersect;
        
                %salvo lo status anche nel triangolo vicino
                for j=1:3
                    if(neigh(id_tri,lonely_point)~= -1)
                       if(neigh(neigh(id_tri,lonely_point),j)==id_tri)
                          triangle(neigh(id_tri,lonely_point),j+3)=...
                              tr(lonely_point+3);
                          triangle(neigh(id_tri,lonely_point),j+6)=...
                              s_intersect;
                        end
                    end
                end
            else
                s_intersect = tr(lonely_point+6);
            end
            
            %considero status(1)
            status(1) = tr(lonely_point+3);
            %status 0 non ci interessa perch√® non tocca la traccia
            if(status(1) == 2)
               %tagliato
               it_is_cut;
               enqueue_tri_to_check(id_tri);

               % inserisco la s_intersect
               if(called_intersect(lonely_point) == 1)
                  info_trace(id_t).s(end+1) = s_intersect;
               end

               if(s_intersect == 0)
                  %√® il primo punto della traccia 
                  info_trace(id_t).cut_tri(end).points(4,:) = ...
                  trace_vertex(trace(id_t,1),:);

                else % s_intersect==1
                  info_trace(id_t).cut_tri(end).points(4,:) = ...
                  trace_vertex(trace(id_t,2),:);
               end

               %p0lig0n0
               info_trace(id_t).cut_tri(end).poly_1 = [1,2,3,0];

               %triangolazione
               info_trace(id_t).cut_tri(end).tri(1,:) = ...
                   [lonely_point,nodes_on_trace(1),4];

               info_trace(id_t).cut_tri(end).tri(2,:) = ...
                   [lonely_point,4,nodes_on_trace(2)];

            elseif(status(1)==4)
                for j=[1 2]
                    if(tr(nodes_on_trace(j))~=queue_temp(1,2))
                        for i=1:node(tr(nodes_on_trace(j))).tot_triangles
                            if(node(tr(nodes_on_trace(j))).triangles(i)~=id_tri && ...
                                triangle(node(tr(nodes_on_trace(j))).triangles(i),10)==-1)

                                queue_temp(end+1,1)=node(tr(nodes_on_trace(j))).triangles(i);
                                queue_temp(end,2)=tr(nodes_on_trace(j));

                                triangle(node(tr(nodes_on_trace(j))).triangles(i),10)=-4;
                            end
                        end
                    end
                end
            end
            
        end
    end
    queue_temp=queue_temp(2:end,:);
end