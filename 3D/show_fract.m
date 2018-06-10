for j = 1:n_fracts
    X = zeros(fract(j).n_points,1);
    Y = zeros(fract(j).n_points,1);
    Z = zeros(fract(j).n_points,1);
    for i = 1:fract(j).n_points
        X(i) = fract_vertex(fract(j).P(i),1)+0.0001;
        Y(i) = fract_vertex(fract(j).P(i),2)+0.0001;
        Z(i) = fract_vertex(fract(j).P(i),3)+0.0001;
    end
    fill3(X,Y,Z,[1,0,0],'FaceAlpha',0.65,'EdgeColor',[0.5,0,0]);
    hold on;
end
axis equal