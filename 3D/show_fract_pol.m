for i = 1:length(info_fract(id_f).pol)
    n_vertexes = length(info_fract(id_f).pol(i).v);
    X = zeros(n_vertexes,1);
    Y = zeros(n_vertexes,1);
    Z = zeros(n_vertexes,1);

    for j = 1:n_vertexes
        X(j) = info_fract(id_f).points(...
               info_fract(id_f).pol(i).v(j),1);
        Y(j) = info_fract(id_f).points(...
               info_fract(id_f).pol(i).v(j),2);
        Z(j) = info_fract(id_f).points(...
               info_fract(id_f).pol(i).v(j),3);
    end
    fill3(X,Y,Z,[1 1 1],'LineWidth',2.5,'FaceAlpha',0,'EdgeColor',[1,1,0],'Marker','p');
    hold on;

end
axis equal;
