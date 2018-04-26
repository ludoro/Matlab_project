clear
close all

global n_nodes
global n_edges
global n_triangles
global n_trace_vertex
global n_traces
%la traccia va usata spesso, quindi al posto di passarla in una funzione,
%la mettiamo global.
global trace_vertex
global trace
global T
global node
global edge
global T_squared
global toll_t
global accuracy
global info_trace
global queue
global neigh
global triangle
accuracy = 1e-14;
%---------------------------- NODE --------------------------

fp=fopen('quad.1.node','r');
if (fp==-1)
    disp('Errore apertura file nodi.');
    return;
end
A=fscanf(fp,'%d',4);
n_nodes=A(1);
A=fscanf(fp,'%d %f %f %d',[4 n_nodes]);
node = repmat(struct('x',0,'y',0,'side',0,'toll',-1,'edges',[0,0,0],'triangles',[0,0], ...
              'tot_edges',0,'tot_triangles',0,'s',666),n_nodes,1);
for i=1:n_nodes
    node(i).x = A(2,i);
    node(i).y = A(3,i);
end
%STRUTTURA di 'node': vettore di strutture, creato con repmat
%                     side: da che parte sta rispetto alla traccia in esame
%                           valori possibli: 
%                           0 ----> non sappiamo, 
%              à             1 ----> nodo lato concorde alla normale
%                           -1 ---> nodo lato discorde alla normale
%                           2 ----> nodo sulla retta
%         
%                     s: ascissa curvilinea dell'eventuale intersezione 
%                        con la traccia, se s=666 caso brutto.
%                    
%                     
fclose(fp);

%------------------------- TRIANGLE -------------------------
fp=fopen('quad.1.ele','r');
if (fp==-1)
    disp('Errore apertura file triangoli.');
    return;
end
A=fscanf(fp,'%d',3);
n_triangles=A(1);
triangle = -ones(n_triangles,10);
A=fscanf(fp,'%d',[4 n_triangles]);
triangle(:,[1,2,3])=A([2 3 4],:)';

%STRUTTURA di 'triangle': n_triangles righe x 7 colonne
%                         primi 3 colonne vertici
%                         colonne 4,5,6 status degli edge
%                         colonne 7,8,9 s degli edge
%                         colonna 10 flag:  -1 non sappiamo niente
%                                                -2 lista attesa due nodi
%                                                   in comune
%                                                -3 lista attesa un nodo in
%                                                   comune
%                                                0 tagliato
%                                                >0 posizione su .near_tri
fclose(fp);

%---------------------------- EDGE --------------------------
fp=fopen('quad.1.edge','r');
if (fp==-1)
    disp('Errore apertura file edge.');
    return;
end
A=fscanf(fp,'%d',2);
n_edges=A(1);
A=fscanf(fp,'%d',[4 n_edges]);   
edge=A([2 3],:)';
%STRUTTURA di 'edge': edge(n,1)=vertice 1 del segmento n
%                     edge(n,2)= vertice 2 del segmento n 
fclose(fp);

%--------------------------- NEIGH -------------------------
fp=fopen('quad.1.neigh','r');
if (fp==-1)
    disp('Errore apertura file "neigh".');
    return;
end
A=fscanf(fp,'%d',2);
A=fscanf(fp,'%d',[4 n_triangles]);
neigh=A([2 3 4],:)';
%STRUTTURA di 'neigh': neigh(n,2)=vicino 2 del triangolo n
fclose(fp);

%-------------------------- TRACE -------------------------
fp=fopen('trace.trace','r');
if (fp==-1)
    disp('errore apertura file tracce.');
    return;
end
A=fscanf(fp,'%d',4);
n_trace_vertex=A(1);
n_traces=A(2);
A=fscanf(fp,'%f',[3 n_trace_vertex]);
trace_vertex=A([2 3],:)';
%STRUTTURA di 'trace_vertex': trace_vertex(n,2)=coordinata y del vertice n
fscanf(fp,'%d',2);
A=fscanf(fp,'%d',[3 n_traces]);
trace=A([2 3],:)';
%STRUTTURA di 'trace': trace(n,1)=estremo 1 della traccia n
fclose(fp);


%!!!!!! ------- modifiche di prova -------- !!!!!!
trace_vertex(3,:)=[0.1 0.1];
trace_vertex(4,:)=[0.9 0.9];


%creo matrice T che è la matrice che per ogni traccia contiene 
%il vettore tangente alla traccia.
%il vettore 'T_square' contiene la lunghezza al quadrato di ogni T
T = zeros(n_traces,2);
T_squared = zeros(n_traces,1);

for i=1:n_traces
    T(i,1) = trace_vertex(trace(i,2),1) - trace_vertex(trace(i,1),1);
    T(i,2) = trace_vertex(trace(i,2),2) - trace_vertex(trace(i,1),2);
    T_squared(i) = T(i,1)^2 +T(i,2)^2;
end

%vettore che conterrà la tolleranza per ogni traccia. 
toll_t = zeros(n_traces,1);

%info trace è una struttura che contiene per ogni traccia, 
% -cut_tri = struttura che contiene punti della triangolazione, i due
%            poligoni, i triangoli della triangolazione e id del triangolo
%            tagliato
% - s = vettore di ascisse curvilinee (delle intersezioni con la traccia)
% - near_tri = struttura che contiene i triangoli vicini, in particolare:
%               id : numero triangolo vicino, con i due nodi 

info_trace = repmat(struct('cut_tri',struct('points',zeros(5,2),'poly_1',[],...
                                            'poly_2',[],'tri',zeros(3,3),'id',0),...
                           's',[],...
                           'near_tri',struct('id',0,'nodes',[])),n_traces,1);
 
% queue = coda triangoli da controllare      
% per ogni riga:
%-primo elemento id_tri
%-secondo elemento indice nodo condiviso
%-terzo elemento indice eventuale secondo nodo condiviso 
queue = zeros(0,3);                  


clear A fp