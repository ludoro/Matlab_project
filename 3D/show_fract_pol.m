for id_f = 1:n_fracts
    X = zeros(fract(id_f).n_points,1);
    Y = zeros(fract(id_f).n_points,1);
    Z = zeros(fract(id_f).n_points,1);
    for i = 1:fract(id_f).n_points
        X(i) = fract_vertex(fract(id_f).P(i),1);
        Y(i) = fract_vertex(fract(id_f).P(i),2);
        Z(i) = fract_vertex(fract(id_f).P(i),3);
    end
    fill3(X,Y,Z,[1,0.4,0.4],'FaceAlpha',0.9,'EdgeColor',[0.8,0,0]);
    hold on;
    
    %ora faccio pol
    
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
        fill3(X,Y,Z,[1 1 1],'FaceAlpha',0,'EdgeColor',[0,0,0],'Marker','p');
        hold on;
        
    end
end
axis equal;
