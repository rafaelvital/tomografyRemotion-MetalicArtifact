function  [mapRmo] = geraMesh(Rmo,forma,lunguezza)
% [mapRmo] = geraMesh(Rmo,forma,lunguezza)
% Crea Mesh della parte metallica dilatada con strel(forma,lunguezza);  
% mapRmo = pixel do dominio di inpainting

mapRmo=zeros(size(Rmo));
mapRmo(find(Rmo))=1;

B = strel(forma,lunguezza); 
mapRmo= imdilate(mapRmo, B); % traccia dilatata
mapRmo(:,end)=mapRmo(:,1);
mapRmo(:,end-1)=mapRmo(:,end); %stiam barando un poco

MMesh(mapRmo);
end