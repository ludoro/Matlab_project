%Per ogni tetraedro trovo le facce 
for i = 1:n_faces
    for j = 4:5
        if(face(i,j) ~= -1)
        k = 1;
        position = 0;
        while(k <= 4 && position == 0)
            w = 1;
            same_node = 0;
            while(w <= 3 && same_node == 0)
                % w controlla i 3 punti della faccia
                if(tet(face(i,j)).P(k) == face(i,w))
                    same_node = 1;
                end
                w = w + 1;
            end
            if(same_node == 0)
                %i 3 nodi sono diversi
                %abbiamo trovato posizione della faccia!
                %k-esimo punto del j-esimo tetraedo non è nella faccia
                %considerata, quindi la faccia è quella opposta al k-esimo
                %punto
                tet(face(i,j)).faces(k) = i;
                position = 1;
            end
            k = k + 1;
        end
        end
    end
end