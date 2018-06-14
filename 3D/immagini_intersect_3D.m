close all
clear 

i=4;
F=[ -2 0;
    0 0;
    0.5 0.25;
    1 0.75;
    1.5 2;
    0 3.5;
    -1.75 3.5;
    -3 2];

text(F(1,1)-0.1,F(1,2)-0.15,'1','FontSize',12);
hold on
text(F(2,1),F(2,2)-0.15,'2','FontSize',12);
hold on
text(F(3,1)+0.05,F(3,2)-0.15,'3','FontSize',12);
hold on
text(F(4,1)+0.1,F(4,2)-0.1,'4','FontSize',12);
hold on
text(F(5,1)+0.1,F(5,2),'5','FontSize',12);
hold on
text(F(6,1),F(6,2)+0.15,'6','FontSize',12);
hold on
text(F(7,1),F(7,2)+0.15,'7','FontSize',12);
hold on
text(F(8,1)-0.2,F(8,2),'8','FontSize',12);
hold on

P(1,:)=[ -1.5 0.25];
P(2,:)=[1 -(0.25/1.5)];
if(i>=2)
P(3,:)=[1 3.5];
end
if(i>=3)
P(4,:)=[-2.5 3.5];
end
if(i==4)
P(5,:)=P(1,:);
end


fill(F(:,1),F(:,2),[1 0 0],'FaceAlpha',0.3,...
    'EdgeColor',[0.6 0 0],'Marker','.','MarkerSize',10);
hold on

plot(P(1:(end-1),1),P(1:(end-1),2),'.-','MarkerSize',8,'LineWidth',1.25,'Color',0.4*[1 1 1]);
hold on
plot(P((end-1):end,1),P((end-1):end,2),'-b.','MarkerSize',8,'LineWidth',1.25);
hold on

%lato 1
if(i==1)
    plot(P(1,1),P(1,2),'o','MarkerSize',14,'Color',[1 0 0]);
    hold on
    plot(P(1,1),P(1,2),'o','MarkerSize',13,'Color',[1 0 0]);
    hold on
    plot(P(1,1),P(1,2),'o','MarkerSize',12,'Color',[1 0 0]);
    hold on

    plot(F(2,1),F(2,2),'o','MarkerSize',12,'Color',[1 0 0]);
    hold on
    plot(F(2,1),F(2,2),'o','MarkerSize',13,'Color',[1 0 0]);
    hold on
    plot(F(2,1),F(2,2),'o','MarkerSize',14,'Color',[1 0 0]);
    hold on
elseif(i==2)
    %lato 2
    plot(F(3,1),F(3,2),'o','MarkerSize',12,'Color',[1 0 0]);
    hold on
    
    plot(F(4,1),F(4,2),'o','MarkerSize',12,'Color',[1 0 0]);
    hold on
    plot(F(4,1),F(4,2),'o','MarkerSize',13,'Color',[1 0 0]);
    hold on
    plot(F(4,1),F(4,2),'o','MarkerSize',14,'Color',[1 0 0]);
    hold on

    I=[1,2.5];
    plot(I(1),I(2),'o','MarkerSize',12,'Color',[1 0 0]);
    hold on
    plot(I(1),I(2),'o','MarkerSize',13,'Color',[1 0 0]);
    hold on
    plot(I(1),I(2),'o','MarkerSize',14,'Color',[1 0 0]);
    hold on
elseif(i==3)
    %lato 3
    
    I=F(6,:);
    plot(I(1),I(2),'o','MarkerSize',12,'Color',[1 0 0]);
    hold on
    plot(I(1),I(2),'o','MarkerSize',13,'Color',[1 0 0]);
    hold on
    plot(I(1),I(2),'o','MarkerSize',14,'Color',[1 0 0]);
    hold on

    I=F(7,:);
    plot(I(1),I(2),'o','MarkerSize',12,'Color',[1 0 0]);
    hold on
    plot(I(1),I(2),'o','MarkerSize',13,'Color',[1 0 0]);
    hold on
    plot(I(1),I(2),'o','MarkerSize',14,'Color',[1 0 0]);
    hold on
elseif(i==4)
    %lato 4
    A=[P(5,1)-P(4,1), F(7,1) - F(8,1); ...
       P(5,2)-P(4,2), F(7,2) - F(8,2)];

    b=[F(7,1)-P(4,1);
       F(7,2)-P(4,2)];

    st = A\b; %prima posizione t(segmento) , seconda posizione s(frattura)
            %devo controllare i valori di st(2)
    I=F(7,:)+st(2)*(F(8,:)-F(7,:));
    plot(I(1),I(2),'o','MarkerSize',12,'Color',[1 0 0]);
    hold on
    plot(I(1),I(2),'o','MarkerSize',13,'Color',[1 0 0]);
    hold on
    plot(I(1),I(2),'o','MarkerSize',14,'Color',[1 0 0]);
    hold on
end

if(i>=2)
    plot(P(1,1),P(1,2),'o','MarkerSize',12,'Color',0.4*[1 1 1]);
    hold on
    plot(F(2,1),F(2,2),'o','MarkerSize',12,'Color',0.4*[1 1 1]);
    hold on
end
if(i>=3)
    I=[1,2.5];
    plot(I(1),I(2),'o','MarkerSize',12,'Color',0.4*[1 1 1]);
    hold on
    plot(F(4,1),F(4,2),'o','MarkerSize',12,'Color',0.4*[1 1 1]);
    hold on
    plot(F(3,1),F(3,2),'o','MarkerSize',12,'Color',0.4*[1 1 1]);
    hold on
end
if(i>=4)
    plot(F(6,1),F(6,2),'o','MarkerSize',12,'Color',0.4*[1 1 1]);
    hold on
    plot(F(7,1),F(7,2),'o','MarkerSize',12,'Color',0.4*[1 1 1]);
    hold on
end

axis equal
axis off