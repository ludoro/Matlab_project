function [] = show_node(id_node)

global node
plot3(node(id_node).coord(1),...
      node(id_node).coord(2),node(id_node).coord(3),...
      'g-p','MarkerSize',10);
hold on;

end

