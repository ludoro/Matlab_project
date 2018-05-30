%{
Abbiamo bisogno di queste cose prima di chiamare lo script.
id_f = indice frattura
(id_cut) = indice tetraedro tagliato
sum = somma dei side
up,middle,down = vettori contententi gli indici dei punti su info_fract.points
                 che stanno sopra sotto e in mezzo al piano della frattura
%}

if(sum == 2 || sum == -2)
    %caso classico 
    %points già stati messi
    
    %giri facce antiorario
    
    %messo tetraedro sopra
    info_fract(id_f).cut_tet(id_cut).faces(1,:) = [up,middle(1),middle(2),0];
    info_fract(id_f).cut_tet(id_cut).faces(2,:) = [up,middle(2),middle(3),0];
    info_fract(id_f).cut_tet(id_cut).faces(3,:) = [up,middle(1),middle(3),0];
    info_fract(id_f).cut_tet(id_cut).faces(4,:) = [middle(1),middle(2),middle(3),0];
    
    %metto poliedro sotto
    info_fract(id_f).cut_tet(id_cut).faces(5,:) = [middle(1),down(1),down(2),middle(2)];
    info_fract(id_f).cut_tet(id_cut).faces(6,:) = [middle(2),down(2),down(3),middle(3)];
    info_fract(id_f).cut_tet(id_cut).faces(7,:) = [middle(3),down(3),down(1),middle(1)];
    info_fract(id_f).cut_tet(id_cut).faces(8,:) = [down,0];  
    
    info_fract(id_f).cut_tet(id_cut).poly_1 = [1,2,3,4];
    info_fract(id_f).cut_tet(id_cut).poly_2 = [4,5,6,7,8];
    
elseif(sum == 0)
    
    %primo poliedro
    info_fract(id_f).cut_tet(id_cut).faces(1,:) = [up(1),middle(1),middle(2),0];
    info_fract(id_f).cut_tet(id_cut).faces(2,:) = [up(1),middle(2),middle(3),up(2)];
    info_fract(id_f).cut_tet(id_cut).faces(3,:) = [up(2),middle(3),middle(4),0];
    info_fract(id_f).cut_tet(id_cut).faces(4,:) = [up(2),middle(4),middle(1),up(1)];
    info_fract(id_f).cut_tet(id_cut).faces(5,:) = [middle(1),middle(2),middle(3),middle(4)];
    
    %secondo poliedro
    info_fract(id_f).cut_tet(id_cut).faces(6,:) = [middle(1),down(2),down(1),middle(2)];
    info_fract(id_f).cut_tet(id_cut).faces(7,:) = [middle(2),down(1),middle(3),0];
    info_fract(id_f).cut_tet(id_cut).faces(8,:) = [middle(3),down(1),down(2),middle(4)];
    info_fract(id_f).cut_tet(id_cut).faces(9,:) = [middle(4),down(2),middle(1),0];
    
    info_fract(id_f).cut_tet(id_cut).poly_1 = [1,2,3,4,5];
    info_fract(id_f).cut_tet(id_cut).poly_2 = [6,7,8,9,5];
    

elseif(sum == 3 || sum == 5)
    
    %primo tetraedro
    info_fract(id_f).cut_tet(id_cut).faces(1,:) = [up(1),middle(1),middle(2),0];
    info_fract(id_f).cut_tet(id_cut).faces(2,:) = [up(1),middle(2),middle(3),0];
    info_fract(id_f).cut_tet(id_cut).faces(3,:) = [up(1),middle(3),middle(1),0];
    info_fract(id_f).cut_tet(id_cut).faces(4,:) = [middle(1),middle(2),middle(3),0];
    
    %poliedro
    info_fract(id_f).cut_tet(id_cut).faces(5,:) = [middle(1),down(1),middle(2),0];
    info_fract(id_f).cut_tet(id_cut).faces(6,:) = [middle(2),down(1),down(2),middle(3)];
    info_fract(id_f).cut_tet(id_cut).faces(7,:) = [middle(3),down(2),middle(1),0];
    info_fract(id_f).cut_tet(id_cut).faces(8,:) = [middle(1),down(1),down(2),0];
   
    
    info_fract(id_f).cut_tet.poly_1 = [1,2,3,4];
    info_fract(id_f).cut_tet.poly_2 = [5,6,7,4];

else%sum == 8
    
    %primo tetraedro
    info_fract(id_f).cut_tet(id_cut).faces(1,:) = [up(1),middle(2),middle(3),0];
    info_fract(id_f).cut_tet(id_cut).faces(2,:) = [up(1),middle(3),middle(1),0];
    info_fract(id_f).cut_tet(id_cut).faces(3,:) = [up(1),middle(1),middle(2),0];
    info_fract(id_f).cut_tet(id_cut).faces(4,:) = [middle(1),middle(2),middle(3),0];
    
    %secondo tetraedro
    
    info_fract(id_f).cut_tet(id_cut).faces(5,:) = [middle(2),down(1),middle(3),0];
    info_fract(id_f).cut_tet(id_cut).faces(6,:) = [middle(3),down(1),middle(1),0];
    info_fract(id_f).cut_tet(id_cut).faces(7,:) = [middle(1),down(1),middle(2),0];
    
    info_fract(id_f).cut_tet.poly_1 = [1,2,3,4];
    info_fract(id_f).cut_tet.poly_2 = [5,6,7,4];

end
