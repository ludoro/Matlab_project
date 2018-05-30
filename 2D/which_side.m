function [side, s] = which_side(id_t,p)
%Per una data traccia e un punto, l'output è:
%side 1 o -1 se non sta sulla retta della traccia 
%side 2 se sta sulla retta della traccia, in questo caso, viena calcolata
%la coordinata curvilinea.

global node
global T
global T_squared
global trace
global trace_vertex
global toll_t

v = [node(p).x - trace_vertex(trace(id_t,1),1);
     node(p).y - trace_vertex(trace(id_t,1),2)];
N = [-T(id_t,2);
     T(id_t,1)];
% scalar rappresenta la distanza punto traccia, per un valore esatto
% dovremmo usare la norma-2, ma è più costosa per via della radice.
scalar = dot(N,v)/norm(N,1);
toll = node(p).toll;
if(scalar<-toll)
    side=-1;
    s=0;
elseif(scalar>toll)
    side=1;
    s=0;
else
    side=2;
    
%conti per trovare la coordinata curvilinea associata.
%In particolare ci serve la norma al quadrato di T. 
%avremo che s = dot(T,v)/(T^2)

    s=dot(T(id_t,:),v)/T_squared(id_t); 
    
    if( s <= toll_t(id_t) && s >= -toll_t(id_t) )
        s = 0;
    elseif (s <= 1 + toll_t(id_t) && s >= 1 - toll_t(id_t))
        s = 1;
    end
end
end


