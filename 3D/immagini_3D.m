close all
F(1,:)=[0 0 0];
F(2,:)=[12 0 0];
F(3,:)=[12 12 0];
F(4,:)=[0 12 0];

v_plane=[0 0 1 0];

T(1,:)=[6 6 6];
T(2,:)=[2 3 0];
T(3,:)=[10 3 0];
T(4,:)=[6 10 0];

%visualizzo la frattura
fill3(F(:,1),F(:,2),F(:,3),0.5*[1 1 1],'FaceAlpha',0.5,'EdgeAlpha',0)
hold on

%visualizzazione tetraedro

for i=1%:2
    for j=(i+1):3
        for k=(j+1):4
            v=[i j k];
            fill3(T(v,1),T(v,2),T(v,3),[0 150 256]/256,'FaceAlpha',0.3,...
                'Marker','.','MarkerSize',11,'EdgeColor',[0 0 0.8]);
            hold on
        end
    end
end

I=zeros(0,3);
%visualizzazione intersezione
% for i=2:4
%     I(i-1,:) = intersezione_immagini(v_plane,T(1,:),T(i,:));
% end

% for j=3:4
%     I(end+1,:) = intersezione_immagini(v_plane,T(1,:),T(j,:));
% end
% for j=[4 3]
%     I(end+1,:) = intersezione_immagini(v_plane,T(2,:),T(j,:));
% end

% I(1,:)=T(1,:);
% for i=3:4
%     I(end+1,:)=intersezione_immagini(v_plane,T(2,:),T(i,:));
% end
I(1,:)=T(2,:);
I(2,:)=T(3,:);
%I(3,:)=intersezione_immagini(v_plane,T(3,:),T(4,:));
I(3,:)=T(4,:);

fill3(I(:,1),I(:,2),I(:,3)+1e-4*[1 1 1],[1 0 0],'EdgeColor',[1 0 0],'FaceAlpha',0.9)
hold on


axis equal
axis off