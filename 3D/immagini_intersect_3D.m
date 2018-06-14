close all
F=[ -2 0;
    0 0;
    0.5 0.25;
    1 0.75;
    1.5 2;
    0 3.5;
    -1.75 3.5;
    -2.5 1.5];

P=[ -1.5 0.25;
    1 

fill(F(:,1),F(:,2),[1 0 0],'FaceAlpha',0.3,...
    'EdgeColor',[0.6 0 0],'Marker','.','MarkerSize',10);
hold on

axis equal
axis off