if(i==1)
    trasl=[0 0];
elseif(i==2)
    trasl=[7 0];
elseif(i==3)
    trasl=[0 -8];
else
    trasl=[7 -8];
end
%frattura
F=[ 0 0;
    3 0;
    4 2.5;
    1.5 4;
    -1 2.5];

% segmento
if(i==1)
P(1,:)=[1.5 0];
P(2,:)=[2 -2];
elseif(i==2)
P(1,:)=[1.5 0];
P(2,:)=[4 4.5];
elseif(i==3)
P(1,:)=[0 0];
P(2,:)=[0.7 -0.7*2.5];
else
P(1,:)=[-0.7 0.7*2.5];
P(2,:)=[0.7 -0.7*2.5];
end

if(i>=3)
plot([-2 1.2]+trasl(1),[5 -2.5*1.2]+trasl(2),'--','Color',0.55*[1 1 1])
hold on
end

fill(F(:,1)+trasl(1),F(:,2)+trasl(2),[1 0 0],'FaceAlpha',0.3,...
    'EdgeColor',[0.6 0 0],'Marker','.','MarkerSize',10);
hold on

plot(P(:,1)+trasl(1),P(:,2)+trasl(2),'-bo','MarkerSize',6,'LineWidth',1.25);
hold on

axis off
axis equal