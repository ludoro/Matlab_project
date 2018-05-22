grid on
% for id_n=1:n_nodes
%     X(id_n,:) = node(id_n).coord;
% end
% T = zeros(n_tets,4);
% for i = 1:n_tets
%     T(i,:) = tet(i).P;
% end
% tetramesh(T,X,'FaceAlpha',0.3,'FaceColor','b');
for i = 1:n_faces
    X = [node(face(i,1)).coord(1),node(face(i,2)).coord(1),node(face(i,3)).coord(1)];
    Y = [node(face(i,1)).coord(2),node(face(i,2)).coord(2),node(face(i,3)).coord(2)];
    Z = [node(face(i,1)).coord(3),node(face(i,2)).coord(3),node(face(i,3)).coord(3)];
    fill3(X,Y,Z,[0,0.7,0.5],'FaceAlpha',0.2,'EdgeColor',[0,0,0.6],...
          'EdgeAlpha',0);
    hold on;
end

axis equal
% 
% 
% for i=1:n_fractures
%     j=1;
%     while j<length(fract(i,:))
%     plot3( [fract_vertex(fract(i,j),1) fract_vertex(fract(i,j+1),1)],...
%           [fract_vertex(fract(i,j),2) fract_vertex(fract(i,j+1),2)],...
%           [fract_vertex(fract(i,j),3) fract_vertex(fract(i,j+1),3)],'.-b' )
%           hold on
%     j=j+1;
%     end
%     %plotto il segmento finale (trovare soluzione più elegante)
%     plot3( [fract_vertex(fract(i,1),1) fract_vertex(fract(i,end),1)],...
%           [fract_vertex(fract(i,1),2) fract_vertex(fract(i,end),2)],...
%           [fract_vertex(fract(i,1),3) fract_vertex(fract(i,end),3)],'.-b' )
%           hold on
% end
% 
% fill3(fract_vertex(fract(1,:),1),fract_vertex(fract(1,:),2),...
%       fract_vertex(fract(1,:),3),'r');
% 
%     
%     
% clear j; 