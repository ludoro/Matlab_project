function [] = show_edge(id_e)
global node;
global edge;
X=zeros(2,1);
Y=zeros(2,1);
Z=zeros(2,1);

for i=1:2
    X(i)=node(edge(id_e).P(i)).coord(1);
    Y(i)=node(edge(id_e).P(i)).coord(2);
    Z(i)=node(edge(id_e).P(i)).coord(3);
end

line(X,Y,Z,'Color',[0 0 0],'Marker','o');
hold on
end

