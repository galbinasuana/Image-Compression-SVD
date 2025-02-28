% incarcare imagine color
imagine_color = imread("LENNA.BMP");

% extragere canale de culoare din imagine
canal_culoare = cell(1,3);
for i = 1:3
  canal_culoare{i} = double(imagine_color(:,:,i));
end

% descompunere svd pentru fiecare canal de culoare
[U, S, V] = deal(cell(1,3));
for i = 1:3
  [U{i}, S{i}, V{i}] = svd(canal_culoare{i});
end

% calculare numar total de valori singulare
total_valori_singulare = cellfun(@(x) min(size(x)), S);

% se introduce la rulare procentul dorit pentru compresie
procent_string = input('Introduceti procentul dorit pentru compresie: ', 's');
procent = str2double(strrep(procent_string, '%', ''));
k = round(procent/100 * total_valori_singulare);

% verificari pentru k<=0 sau k>total_valori_singulare
for i = 1:3
    if k(i) <= 0
        error('Numarul de valori singulare pentru compresie trebuie sa fie mai mare decat zero.');
    elseif k(i) > total_valori_singulare(i)
        error('Numarul de valori singulare calculat depaseste numarul total de valori singulare disponibile.');
    end
end

% realizare compresie pentru fiecare canal de culoare
U_comprimat = cell(1, 3);
S_comprimat = cell(1, 3);
V_comprimat = cell(1, 3);
canal_comprimat = cell(1, 3);
for i = 1:3
    U_comprimat{i} = U{i}(:, 1:k(i));
    S_comprimat{i} = S{i}(1:k(i), 1:k(i));
    V_comprimat{i} = V{i}(:, 1:k(i));
    canal_comprimat{i} = U_comprimat{i} * S_comprimat{i} * V_comprimat{i}';
end

% reconstruire imagine comprimata
imagine_color_comprimata = cat(3, canal_comprimat{:});

% afisare imagine originala
subplot(2,2,1);
imshow(uint8(imagine_color));
title('Imaginea originala');

% afisare imagine comprimata + salvare
subplot(2,2,2);
imshow(uint8(imagine_color_comprimata));
title(['Imagine comprimata la ' procent_string ' cu k = ' num2str(k(1))]);
imwrite(uint8(imagine_color_comprimata), ["imagine_color_comprimata_" procent_string ".jpg"]);

% afisare canale de culoare comprimate
canal_titlu = {'canal rosu', 'canal verde', 'canal albastru'};
for i = 1:3
    subplot(2,3,i+3);
    imagine_canal_comprimat = uint8(zeros(size(imagine_color)));
    imagine_canal_comprimat(:,:,i) = canal_comprimat{i};
    imshow(imagine_canal_comprimat);
    title(['Imagine comprimata (' canal_titlu{i} ')']);
end