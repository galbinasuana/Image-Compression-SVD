% incarcare imagine monocrom
imagine_monocrom = imread("BADSCAN.BMP");

% conversie imagine intr-o matrice
matrice_imagine = double(imagine_monocrom);

% descompunere svd a imaginii
[U, S, V] = svd(matrice_imagine);

% calculare numar total de valori singulare
total_valori_singulare = min(size(S));

% se introduce la rulare procentul dorit pentru compresie
procent_string = input('Introduceti procentul dorit pentru compresie: ', 's');
procent = str2double(strrep(procent_string, '%', ''));
k = round(procent/100 * total_valori_singulare);

% verificari pentru k<=0 sau k>total_valori_singulare
if k <= 0
  error('Numarul de valori singulare pentru compresie trebuie sa fie mai mare decat zero.');
elseif k > total_valori_singulare
  error('Numarul de valori singulare calculat depaseste numarul total de valori singulare disponibile.');
end

% realizare compresie
U_comprimat = U(:, 1:k);
S_comprimat = S(1:k, 1:k);
V_comprimat = V(:, 1:k);

% reconstruire imagine folosind matricele compresate
imagine_comprimata = U_comprimat * S_comprimat * V_comprimat';

% afisare imagine originala
subplot(1,2,1);
imshow(uint8(matrice_imagine));
title('Imaginea Alb-Negru originala');

% afisare imagine comprimata + salvare
subplot(1,2,2);
imshow(uint8(imagine_comprimata));
title(['Imagine comprimata la ' procent_string ' cu k = ' num2str(k)]);
imwrite(uint8(imagine_comprimata), ["imagine_monocrom_comprimata_" procent_string ".jpg"]);