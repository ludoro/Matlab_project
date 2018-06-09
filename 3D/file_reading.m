clear 
close all 
global fract_vertex;
global node;
global tet;
global coord_to_use;
global accuracy;
global info_fract;
global fract;
global node_plane;
global info_node;
global queue;
global queue_temp;
global edge;
global neigh;
global face;
global n_fracts;
global n_tets;

accuracy = 1e-14;

%N.B. fscanf legge il file al "contrario", quindi nelle matrici è necessario
%trasporre. 

%---------------------------- NODE --------------------------

fp = fopen('barra.1.node','r'); 
if (fp==-1) 
    disp('Errore apertura file nodi.'); 
    return ; 
end
A = fscanf(fp,'%d',4); 
n_nodes = A(1);

A = fscanf(fp,'%d %f %f %f',[4 n_nodes]);

%s = -1 se il punto non sta sul piano della frattura
%s > 0 da la riga corrispondente di node_fract
node = repmat(struct('coord',[0 0 0],'side',0,'edges',[0,0,0],...
    'tets',[0,0,0,0],'tot_edges',0,'tot_tets',0,'where_on_plane',-1),n_nodes,1);


for i=1:n_nodes 
    node(i).coord = (A(2:4,i))';
end 

fclose(fp); 

%---------------------------- TETHRAEDRONS --------------------------
    
fp = fopen('barra.1.ele','r'); 
if(fp==-1) 
    disp('Errore apertura file tetraedri'); 
end

A = fscanf(fp,'%d',3); 
n_tets = A(1) ; 

A = fscanf(fp,'%d',[5 n_tets]); 
    tet=A([2 3 4 5],:)';

tet = repmat(struct('P',[0,0,0,0],'faces',[0,0,0,0],'status_queue',-1,...
            'edges',[0 0 0 0 0 0]),n_tets,1);
% status_queue = -1 se sconosciuto
% status_queue = -2 condivide 1 nodo
% status_queue = -3 condivide 2 nodi 
% status_queue = -4 condivide 3 nodi
% status_queue = -5 si trova su queue_temp
% status_queue = 0 se tagliato
% status_queue > 0 posizione in info_trace.near_tet 
for i = 1:n_tets
    tet(i).P = A([2,3,4,5],i);
end

    
% STRUTTURA di 'tets' : tets(n,3) = terzo vertice dell' n_esimo tetraedro 
fclose(fp); 

%---------------------------- EDGE --------------------------
    
 fp = fopen('barra.1.edge','r'); 
 if(fp==-1)
     disp('Errore apertura file edge.');  
 end 
 
 A = fscanf(fp,'%d',2); 
 n_edges=A(1);
 edge = repmat(struct('P',[0,0],'checked',-1,'tets',[]),n_edges,1);
 A = fscanf(fp,'%d',[5 n_edges]);
 for i = 1:n_edges
     edge(i).P = A([2 3],i);
 end

 %edge checked -1 sconosciuto,
 %     checked 0 se ho controllato e non tagliato
 %     checked > 0 posizione in node_plane
 fclose(fp) ;           
 
 %--------------------------- NEIGH -------------------------
 
 fp = fopen('barra.1.neigh','r'); 
 if(fp==-1)
     disp('Errore apertura file neigh.');
 end 
 
 A = fscanf(fp,'%d',2); 
 n_neigh = A(1); 

 A = fscanf(fp,'%d',[5 n_neigh]);
 neigh = A([2 3 4 5],:)';
 
 %STRUTTURA di neigh :  neigh(n,1) =  primo vicino al tetraedro n-esimo
 %                      neigh(n,2) = secondo vicino al tetraedro n-esimo
 
 
 %--------------------------- FACE -------------------------
 
fp = fopen('barra.1.face','r'); 
 if(fp==-1)
     disp('Errore apertura file face.');
 end 
 
 A = fscanf(fp,'%d',2); 
 n_faces = A(1); 
 
 A = fscanf(fp,'%d',[7 n_faces]);
 face = A([2 3 4 6 7],:)';
 
 %STRUTTURA di face :  face(n,1) =  primo punto della n-esima faccia
 %                     face(n,2) = secondo punto della n-esima faccia
 
 
  %--------------------------- FRACT -------------------------
  
  fp = fopen('fract.pol','r');
  if(fp==-1)
     disp('Errore apertura file fract.');
  end 
  
  A = fscanf(fp,'%d',4); 
  n_fract_vertex = A(1);
  
  
  A = fscanf(fp,'%f',[4 n_fract_vertex]);
  fract_vertex = A([2 3 4],:)'; 
  
  %STRUTTURA di fract_vertex : fract_vertex(n,2) coordinata y del vertice n
  %                            fract_vertex(n,3) coordinata z del vertice n
  
  %!!!!!!!!!!!!!!!1 --DEBUGGING-- !!!!!!!!!!!!!!!!!!!!
  x_debug=[-0.5 1.5];
  m=0;
  q=1;
  z_debug=[-2 2];
  fract_vertex(1,:)=[x_debug(1) m*x_debug(1)+q z_debug(1)];
  fract_vertex(2,:)=[x_debug(1) m*x_debug(1)+q z_debug(2)];
  fract_vertex(4,:)=[x_debug(2) m*x_debug(2)+q z_debug(2)];
  fract_vertex(3,:)=[x_debug(2) m*x_debug(2)+q z_debug(1)];
  
  A = fscanf(fp,'%d',2); 
  n_fracts = A(1); 
  
  fract =repmat(struct('P', [], 'n_points', 0, 'N',[0;0;0],'d',0,...
                       'G',[0,0],'r',0,'side_int',0,'protocol',-1),...
                n_fracts,1);
  %il campo .side_int serve ad avere un riferimento per capire se un punto
  %è interno o no alla frattura. Si fa la prova con il baricentro. 
  %RIEMPITO SU: "global_toll.m"
  
  %protocol = 0 standard
  %protocol = -1 non so ancora
  %protocol = 1 casi patologici frattura minuscola 
  
  %le fratture possono avere un numero di nodi da 3 a n, uso un ciclo for
  %e memorizzo in una matrice le cui righe hanno dim diversa
  for i=1:n_fracts 
      A = fscanf(fp,'%d',2);
      fract(i).n_points = A(2); 
      A = fscanf(fp,'%d',fract(i).n_points);
      fract(i).P =A(1:fract(i).n_points);
  end
  clear i
% vettore di strutture inizialmente vuoto che contiene per ogni frattura
% le informazioni dei nodi che stanno sul piano.
% coord contiene le coordinate x e y (già proiettate)
% sides contiene tutti i side del punto rispetto ai lati della frattura

node_plane = repmat(struct('coord', [], 'sides',[],'in_info',-1,'is_out',-1,...
                           'near_nodes',zeros(0,2),'from_edge',-1,'third_coord',0),0,1);
% -1 nella seconda colonna di near_nodes quando non ci sono intersezioni 
% e quindi non ci sono informazioni su info_node
%from_edge = 1 deriva intersezione piano edge
%          = 0 deriva da un nodo che giace sul piano
info_node = repmat(struct('n_intersect',0,'in',0,...
                          'out',0,'in_info',[0 0]),0,1);
                      
  %STRUTTURA di 'fract': fract(n,1)=punto 1 della frattura n
  fclose(fp);  
info_fract = repmat(struct('cut_tet',struct('id',0,'points',zeros(0,3),...
                                            'poly_1',[],'poly_2',[],...
                                            'faces',zeros(0,4)),...
                           'near_tet',struct('id',0,'points',[],'edges',[],'faces',[]),...
       'points',zeros(0,3),'pol',struct('v',[])),n_fracts,1);
   
queue = repmat(struct('id',-1,'points',[],'edges',[],'faces',[]),0,1);
queue_temp = zeros(0,2); 

  clear A fp