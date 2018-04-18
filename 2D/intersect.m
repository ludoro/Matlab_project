function [status,s] = intersect(id_t,p_1,p_2)

% status:
% 0 ---> non si intersecano
% 1 ---> caso a croce 
% 2 ---> traccia muore dentro il segmento
% 3 ---> segmento muore dentro traccia oppure si toccano negli estremi 
% 4 ---> segmento completamente interno alla traccia, questo comprende 
%        anche il caso in cui siano esattamente coincidenti.
% 5 ---> traccia completamente interna al segmento

% s = ascissa curvilinea della traccia


global node
global toll_t
global T
global trace
global trace_vertex 

%prima di intersect bisogna chiamare la funzione "which_side" per ogni 
%vertice del triangolo in analisi. Diamo per scontato che side sia 
%conosciuto, quindi che node().side sia diverso da 0. 


toll_trace = toll_t(id_t);
prodotto = node(p_1).side*node(p_2).side;


if(prodotto == 1)
    status = 0;
    s = 666;

    
elseif(prodotto == -1)
    %prima colonna differenza x e y nodi
    %secondo colonna differenza x e y della traccia cambiati di segno
    A = [node(p_2).x - node(p_1).x, -T(id_t,1);
         node(p_2).y - node(p_1).y, -T(id_t,2)];
     
    %vettore colonna con differenza primo punto traccia meno primo punto
    %segmento x e y
    
    
    b = [trace_vertex(trace(id_t,1),1) - node(p_1).x;
         trace_vertex(trace(id_t,1),2) - node(p_1).y]; 
    
    st = A\b; %prima posizione t(segmento) , seconda posizione s(traccia)
              
    s = st(2);
    
    if((s < -toll_trace) || (s>1 + toll_trace))
        % non c'è intersezione, quindi status = 0.
        status = 0;
        
    elseif(s <= +toll_trace && s>= -toll_trace)
        % la traccia muore nel segmento in un punto singolo
        status = 2;
        s = 0;
        
    elseif(s < 1 - toll_trace && s > toll_trace)
        % intersezione a croce 
        status = 1;
        
    else % s >= 1 - toll_trace && s <= 1 + toll_trace
        % traccia muore dentro il segmento in un punto singolo
        status = 2;
        s = 1;
    end
     
elseif(prodotto ==4)
    %Diamo per scontato che il campo s di p_1 e di p_2 contenga dei valori 
    %utili, inseriti alla chiamata di which_side, la quale deve già essere
    %stata eseguita.
    
    s_1 = node(p_1).s;
    s_2 = node(p_2).s;
    
    %primo sotto-caso
    if(s_1 < 0) 
        
        if(s_2 < 0)
             %non c'è intersezione perchè sono paralleli ma uno 
             %finisce prima
             status = 0;
             s = 666;
                
        elseif(s_2 == 0)
            %segmento e traccia sono adiacenti, c'è intersezione, 
            %ma non c'è taglio. 
            status = 3;
            s = 0;
            
        elseif(s_2 <= 1 && s_2 > 0)
            %traccia muore dentro il segmento
            s = [0,s_2];
            status = 2;
           
        else % s_2 > 1
            %traccia interna al segmento
            status = 5;
            s = [0,1];
        end
        
    %secondo sottocaso
    elseif(s_1 == 0)
        
        if(s_2 < 0)
             %segmento e traccia adiacenti 
             status = 3;
             s = 0;
                
        elseif(s_2 == 0)
            % segmento dentro punto iniziale traccia 
            status = -1;
            %printf("I punti %d e %d coincidono con il punto iniziale della traccia", p_1, p_2);
            disp("Due punti coincidono con il punto iniziale della traccia")
            s = 0;
                   
        elseif(s_2 <= 1 && s_2 > 0)
            %segmento interno alla traccia con un estremo o due coincidenti
            s = [0,s_2];
            status = 4;
               
        else % s_2 > 1
            %traccia tutta interna al segmento, con un estremo coincidente. 
            %Intersezione con taglio.
            status = 2;
            s = [0,1];
        end
    
    %terzo sottocaso
    elseif(s_1 > 0 && s_1 < 1)
        
        if(s_2 < 0)
            
           %traccia muore dentro segmento, si taglio
           status = 2;
           s = [0,s_1];
           
        elseif(s_2 >= 0 && s_2 <=1)
            
            %segmento tutto dentro traccia, no taglio
            
            status = 4;
            s = [s_1,s_2];
            
        else %s_2 > 1
            %analogo al caso s_2 < 0, ma dall'altro lato
            status=2;
            s = [s_1,1];
            
        end
        
    elseif(s_1 == 1)
        
        if(s_2 < 0)
            
            %traccia tutta dentro, si taglio
            status = 2;
            s = [0,1];
            
        elseif(s_2 >= 0 && s_2 < 1)
            
            %segmento completamente interno alla traccia o coincidente, in
            %entrambi i casi non tagliato
            status = 4;
            s = [s_2,1]; 
            
        elseif(s_2 == 1)
            
            % segmento dentro punto finale traccia 
            status = -1;
            %printf("I punti %d e %d coincidono con il punto finale della traccia", p_1, p_2);
            disp("Due punti coincidono con il punto finale della traccia");
            s = 0;
            
        else % s_2 > 1
            % adiacenti
            status = 3;
            s = s_1;
        end
        
    else % s_1 > 1
        if(s_2 < 1)
            %traccia completamente interna 
            status = 5;
            s = [0,1];
            
        elseif(s_2 >= 0 && s_2 < 1)
            % traccia muore dentro il segmento, si taglio
            status = 2;
            s = [s_2, 1];
            
        elseif(s_2 == 1)
            %traccia e segmento adiacenti, no taglio
            status = 3;
            s = 1;
            
        else % s_2 > 1
            % non si intersecano 
            status = 0;
            s = 666;
        end
    end
    
elseif(prodotto ==-2 || prodotto == 2)
    
    if(node(p_1).side == 2)
        s = node(p_1).s;
    else
        s = node(p_2).s;
    end
        
    if(s < 0 || s>1)
        % non c'è intersezione, quindi status = 0.
        status = 0;
        
    else %tutti i casi rimanenti sono accorpati,perchè hanno tutti
         % status = 3. 
        status = 3;
    end
    
else % prodotto == 0 non dovrebbe succedere
    %printf("Errore. node(%d).side = %d e node(%d).side = %d", p_1,node(p_1).side,p_2,node(p_2).side);
    disp("Errore prodotto = 0");
    s = 666;
    status = -1;
end
end