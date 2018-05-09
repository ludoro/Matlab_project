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
node = repmat(struct('x',0,'y',0,'z',0,'side',0,'toll',-1,'edges',[0,0,0],...
    'tet',[0,0,0,0],'tot_edges',0,'tot_tets',0,'where_on_plane',-1),n_nodes,1);

for i=1:n_nodes 
    node(i).x = A(2,i);
    node(i).y = A(3,i);
    node(i).z = A(4,i); 
    
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
    
% STRUTTURA di 'tets' : tets(n,3) = terzo vertice dell' n_esimo tetraedro 
fclose(fp); 

%---------------------------- EDGE --------------------------
    
 fp = fopen('barra.1.edge','r'); 
 if(fp==-1)
     disp('Errore apertura file edge.');  
 end 
 
 A = fscanf(fp,'%d',2); 
 n_edges=A(1);
 edge = repmat(struct('P',[0,0],'checked',-1),n_edges,1);
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
 face = A([2 3 4],:)';
 
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
  
  A = fscanf(fp,'%d',2); 
  n_fractures = A(1); 
  
  fract =repmat(struct('P', [], 'n_points', 0, 'N',[0,0,0],'d',0,...
                       'G',[0,0],'r',0),...
                n_fractures,1);
  
  %le fratture possono avere un numero di nodi da 3 a n, uso un ciclo for
  %e memorizzo in una matrice le cui righe hanno dim diversa
  for i=1:n_fractures 
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

node_plane = repmat(struct('coord', [], 'sides',[]),0,1);

  %STRUTTURA di 'fract': fract(n,1)=punto 1 della frattura n
  fclose(fp);  
info_fract = repmat(struct('cut_tet',struct('id',0,'points',zeros(0,3),...
                                            'poly_1',[],'poly_2',[]),...
                           'near_tet',struct('id',0,'nodes',[],'edges',[]),...
       'div',struct('points',zeros(0,3),'pol',struct('v',[]))),n_fracts,1);
  clear A fp