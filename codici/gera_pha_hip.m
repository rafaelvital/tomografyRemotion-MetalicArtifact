% Script che crea il phanton generico

n=1500;
m=1.2;
o=0.9;

Pha = imread('hippha.png');
Pha = im2double(Pha);
Pha = Pha(:,:,1);
[r, c]= size(Pha);

if(r>c) 
    Pori = zeros(r);
    Pori(:,floor((r-c)/2):floor((r+c)/2)) = Pha(:,:);
end
if(c>r) 
    Pori = zeros(c);
    Pori(floor((c-r)/2):floor((c+r)/2)-1,:) = Pha(:,:);
end
Pori = imresize(Pori,[512,512]);

[Imet,Inm] = segmentaMetallo(Pori,0.85);
[Iosso,Inosso] = segmentaMetallo(Inm,0.4);
Iosso2 = Iosso;
Iosso2(Iosso2>0) = 1;
Iosso2 = imerode(Iosso2,strel('disk',1));
Iosso2 = imdilate(Iosso2,strel('disk',1));

Pori(Imet>0) = m;
Pori(Iosso2>0) = o;
Pori = map(Pori);

theta=0:1:(360-1);
[R,xp]=radon(Pori,theta);

R(R>n) = n;

PNew= iradon(R, theta,'linear','Ram-Lak');
PNew=PNew(2:end-1,2:end-1);

H = fspecial('gaussian',3,1);
Part=imfilter(PNew,H);

figure;
imshow(Part,[]);


