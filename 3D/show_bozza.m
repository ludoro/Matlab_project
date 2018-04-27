
grid on

% for i=1:n_edges
%     plot3([node(edge(i,1)).x node(edge(i,2)).x ],...
%           [node(edge(i,1)).y node(edge(i,2)).y ],...
%           [node(edge(i,1)).z node(edge(i,2)).z ],...
%           '.-b','LineWidth',1.3);
%       hold on
% end 

for id_n=1:n_nodes
X(id_n,:) = [node(id_n).x node(id_n).y node(id_n).z];
end
tetramesh(tets,X,'FaceAlpha',0.3,'LineWidth',1) ;
axis equal

% for i=1:n_fractures
%     j=1;
%     while j<length(fract(i))
%     plot3( [fract_vertex(fract(i,j),1) fract_vertex(fract(i,j+1),1)],...
%           [fract_vertex(fract(i,j),2) fract_vertex(fract(i,j+1),2)],...
%           [fract_vertex(fract(i,j),3) fract_vertex(fract(i,j+1),3)],'.b' )
%           hold on
%     j=j+1;
%     end
% end
% clear j;