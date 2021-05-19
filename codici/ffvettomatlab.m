function A = ffvettomatlab(file,M,N)
%function A=ffvettomatlab('filepath_and_name',#row,#col)
%per Freefem. Carica il file e lo resituisce castato a int
%come matrice MxN

fid=fopen(file);
n=fscanf(fid,'%f',1);
A=fscanf(fid,'%f',inf);
fclose(fid);
%A = uint8(reshape(A,N,M)');
A = reshape(A,N,M)';

return
