function [] = show_tet_poly(id_f,v_tet)
%v_tet vettore indici di info_fract.cut_tet
global info_fract;
for k = 1:length(v_tet)
    id_tet = v_tet(k);
    if(isempty(info_fract(id_f).cut_tet(id_tet).poly_2))
        color_1 = [1,1,0];
    else
        %color_1 = [1,0.6,0.6];
        color_1 = [0.4,0.8,1];
    end
    color_2 = [0.4,1,0.4];
    
%     for i = 1:length(info_fract(id_f).cut_tet(id_tet).poly_1)
%         id_face = info_fract(id_f).cut_tet(id_tet).poly_1(i);
%         if(info_fract(id_f).cut_tet(id_tet).faces(id_face,4) ~= 0)
%             X = [0,0,0,0];
%             Y = [0,0,0,0];
%             Z = [0,0,0,0];
%         else
%             X = [0,0,0];
%             Y = [0,0,0];
%             Z = [0,0,0];
%         end
%         for j = 1:4
%             if(info_fract(id_f).cut_tet(id_tet).faces(id_face,j) ~= 0)
%                 id_vertex = info_fract(id_f).cut_tet(id_tet).faces(id_face,j);
%                 X(j) = info_fract(id_f).cut_tet(id_tet).points(id_vertex,1);
%                 Y(j) = info_fract(id_f).cut_tet(id_tet).points(id_vertex,2);
%                 Z(j) = info_fract(id_f).cut_tet(id_tet).points(id_vertex,3);
%             end
%         end
%         fill3(X,Y,Z,color_1,'FaceAlpha',0.65);
%         hold on
%         
%         
%     end
    
    for i = 1:length(info_fract(id_f).cut_tet(id_tet).poly_2)
        id_face = info_fract(id_f).cut_tet(id_tet).poly_2(i);
        if(info_fract(id_f).cut_tet(id_tet).faces(id_face,4) ~= 0)
            X = [0,0,0,0];
            Y = [0,0,0,0];
            Z = [0,0,0,0];
        else
            X = [0,0,0];
            Y = [0,0,0];
            Z = [0,0,0];
        end
        for j = 1:4
            if(info_fract(id_f).cut_tet(id_tet).faces(id_face,j) ~= 0)
                id_vertex = info_fract(id_f).cut_tet(id_tet).faces(id_face,j);
                X(j) = info_fract(id_f).cut_tet(id_tet).points(id_vertex,1);
                Y(j) = info_fract(id_f).cut_tet(id_tet).points(id_vertex,2);
                Z(j) = info_fract(id_f).cut_tet(id_tet).points(id_vertex,3);
            end
        end
        fill3(X,Y,Z,color_2,'FaceAlpha',0.65);
        hold on  
    end
end
axis equal
end