close all
clear 

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
P(3,:)=[1 3.5];
P(4,:)=[-2.5 3.5];
P(5,:)=P(1,:);

fill(F(:,1),F(:,2),[1 0 0],'FaceAlpha',0.3, ...
    'EdgeColor',[0.6 0 0],'Marker','.','MarkerSize',10);
hold on

plot(P(:,1),P(:,2),'.-','MarkerSize',8,'LineWidth',1.25,'Color',[0 0 1]);
hold on

I(1,:)=[1 2.5];
A=[P(5,1)-P(4,1), F(7,1) - F(8,1); ...
   P(5,2)-P(4,2), F(7,2) - F(8,2)];
b=[F(7,1)-P(4,1);
   F(7,2)-P(4,2)];
st = A\b; 
I(2,:)=F(7,:)+st(2)*(F(8,:)-F(7,:));

pol(1,:)=P(1,:);
pol(2,:)=F(2,:);
pol(3,:)=F(3,:);
pol(4,:)=F(4,:);
pol(5,:)=I(1,:);
pol(6,:)=F(6,:);
pol(7,:)=F(7,:);
pol(8,:)=I(2,:);

fill(pol(:,1),pol(:,2),'b','FaceAlpha',0.3,'Marker','o',...
    'MarkerSize',10,'EdgeColor','b','EdgeAlpha',0);
hold on

axis equal
axis off