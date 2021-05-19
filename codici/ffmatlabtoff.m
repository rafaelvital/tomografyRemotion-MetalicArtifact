function ffmatlabtoff(file,A)
%function ffmatlabtoff('filepath_and_name',A)
%per Freefem. Salva prima il numero di elementi, 
%poi tutti i valori di A come float

fid = fopen(file,'w');
fprintf(fid,'%f\n',numel(A));
A = reshape(A',numel(A),1);
fprintf(fid,'%f\n',A);
fclose(fid);
return
