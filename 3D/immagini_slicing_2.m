close all
P(1,:)=[0 0 0];
P(2,:)=[2 0 0];
P(3,:)=[1 2 0];
P(4,:)=[1 1 3];

M(1,:)=[1 0 0];
M(2,:)=[1.5 1 0];
M(3,:)=[0.5 1 0];

dir(1,:)=[0 -1];
dir(2,:)=[2 1];
dir(3,:)=[-2 1];

dir(2,:)=dir(2,:)./norm(dir(2,:));
dir(3,:)=dir(3,:)./norm(dir(3,:));

for i=1:3
    I(i,:)=intersezione_immagini([0 0 1 -1.5],P(4,:),P(i,:));
end

alpha=0.8;
%base
fill3(P(1:3,1),P(1:3,2),P(1:3,3),[1 1 0],'FaceAlpha',alpha);
hold on

%laterali inferiori
for i=1:3
    X=[P(i,1), P(mod(i,3)+1,1), I(mod(i,3)+1,1), I(i,1)];
    Y=[P(i,2), P(mod(i,3)+1,2), I(mod(i,3)+1,2), I(i,2)];
    Z=[P(i,3), P(mod(i,3)+1,3), I(mod(i,3)+1,3), I(i,3)];
    
    fill3(X,Y,Z,[0 1 0],'FaceAlpha',alpha);
    hold on
end

%intermedie
h=0.4;
fill3(I(:,1),I(:,2),I(:,3)+h,[0 0.75 1],'FaceAlpha',alpha);
hold on

fill3(I(:,1),I(:,2),I(:,3),[0 0.75 1],'FaceAlpha',alpha);
hold on

%laterali superiori
for i=1:3
    X=[I(i,1), I(mod(i,3)+1,1), P(4,1)];
    Y=[I(i,2), I(mod(i,3)+1,2), P(4,2)];
    Z=[I(i,3), I(mod(i,3)+1,3), P(4,3)];
    
    fill3(X,Y,Z+h,[1 0 0],'FaceAlpha',alpha);
    hold on
end

s=0.2;
i=2;
P_e=M(i,:)+s*(P(4,:)-M(i,:));
P_i=P_e + [1.5 -0.33 0.1];
plot3([P_e(1), P_i(1)],[P_e(2), P_i(2)],[P_e(3), P_i(3)],'Color',0.2*[1 1 1]);
plot3(P_e(1),P_e(2),P_e(3),'k.','MarkerSize',12);
text(P_i(1)+dir(i,1)*0.12,P_i(2)+dir(i,2)*0.12,P_i(3)+0.08,'poly\_2  =  [4 5 6 7 8]','FontSize',12);

s=0.65;
i=2;
P_e=M(i,:)+s*(P(4,:)-M(i,:))+[0 0 h];
P_i=P_e + [1 -0.25 0.1];
plot3([P_e(1), P_i(1)],[P_e(2), P_i(2)],[P_e(3), P_i(3)],'Color',0.2*[1 1 1]);
plot3(P_e(1),P_e(2),P_e(3),'k.','MarkerSize',12);
text(P_i(1)+dir(i,1)*0.12,P_i(2)+dir(i,2)*0.12,P_i(3)+0.08,'poly\_1  =  [1 2 3 4]','FontSize',12);


axis equal
axis off