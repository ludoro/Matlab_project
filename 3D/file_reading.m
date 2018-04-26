clear 
close all 

%N.B. fscanf legge il file al "contrario", quindi nelle matrici � necessario
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

node = repmat(struct('x',0,'y',0,'z',0,'side',0,'toll',-1,'edges',[0,0,0],...
    'tet',[0,0,0,0],'tot_edges',0,'tot_tets',0,'s',666),n_nodes,1);

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
    tets=A([2 3 4 5],:)';
    
% STRUTTURA di 'tets' : tets(n,3) = terzo vertice dell' n_esimo tetraedro 
fclose(fp); 

%---------------------------- EDGE --------------------------
    
 fp = fopen('barra.1.edge','r'); 
 if(fp==-1)
     disp('Errore apertura file edge.');  
 end 
 
 A = fscanf(fp,'%d',2); 
 n_edges=A(1);
 
 A = fscanf(fp,'%d',[5 n_edges]);
 edge(:,[1 2])= A([2 3],:)';
 
 %STRUTTURA di 'edge' : edge(n,1) = primo punto dell' n-esimo edge
 %                      edge(n,2) = secondo punto dell' n-esimo edge 
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
   
  
  A = fscanf(fp,'%d',[4 n_fract_vertex]);
  fract_vertex = A([2 3 4],:)'; 
  
  %STRUTTURA di fract_vertex : fract_vertex(n,2) coordinata y del vertice n
  %                            fract_vertex(n,3) coordinata z del vertice n
  
  A = fscanf(fp,'%d',2); 
  n_fractures = A(1); 
  
  %le fratture possono avere un numero di nodi da 3 a n, uso un ciclo for
  %e memorizzo in una matrice le cui righe hanno dim diversa
  for i=1:n_fractures 
      A = fscanf(fp,'%d',2);
      n_points = A(2); 
      A = fscanf(fp,'%d',n_points);
      fract(i,:)=A(1:n_points);
  end
  clear i
  
  %STRUTTURA di 'fract': fract(n,1)=ppunto 1 della frattura n
  fclose(fp);    
  
  
      
  clear A fp
 
  
 
 
 
 
 
 
 
    
    
    