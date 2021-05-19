% Script che crea il phanton generico

e= [
%     1   .920  .690   	0     	0        90
     1 	.874 	.6624   	0      -.0184     90
    -0.4 	.310 	.1100     .22    	  0       72
    -0.4	.410 	.1600    -.22    	  0      108 
    1.1  	.250 	.2100   	0     	.35       90 
    1.1  	.0460 	.046   	    0     	.1         0 
    1.1  	.0460 	.046  	    0      -.1         0 
    1.1  	.0460 	.023     -.08      -.605       0 
    1.1  	.0230 	.023    	0      -.605       0 
    1.1  	.046  	.023   	  .06      -.605      90 
    20  	.03 	.03   	0     	.46         0 % metal inside write region
    4   .06     .06     0       .37        0
    
%     6      .018 	.018    .46    -.46         90 % metal inside back region
%     0      .018 	.018     .24    0         90 % metal inside back region
%     0  	.018  	.018     0     -.35          0
    ]; % met

sizeP=256;
Pori=phantom(e,sizeP); % genero phantom


% Blurred=Pori+0.01*rand(sizeP,sizeP)-0.01*rand(sizeP,sizeP);
% H=fspecial('gaussian',5,2); %filtro gaussiano
% Blurred=imfilter(Blurred,H,'replicate');%filtraggio gaussiano(passa basso)
% 
% 
theta=0:0.25:(360-0.25);
[R,xp]=radon(Pori,theta);
% figure,imshow(R,[],'Xdata',theta,'Ydata',xp,...
%             'InitialMagnification','fit')
% xlabel('\theta (degrees)')
% ylabel('x''')
% colormap(gray);title('sinogramma di (phantom rumore additivo + filtraggio gaussiano)')


n=size(Pori,1);
m=size(Pori,2);
treshold=8;
Imet=[];
Inonmet=[];
for i=1:n
    for j=1:m
        if(Pori(i,j)>treshold) 
            Imet(i,j)=1;
            Inonmet(i,j)=0; 
        else
            Imet(i,j)=0;
            Inonmet(i,j)=1;
        end
    end
end

%% costrusisco sino metal only e nonmetal only
Imo=Imet.*Pori;
[Rmo,xmo]=radon(Imo,theta);

Inm=Inonmet.*Pori;
[Rnm,xnm]=radon(Inm,theta);

%% costruzione metal artifacts

[u,v]=size(Rmo);
mapRmo=[]; %mappa del sinogramma metal only
for i=1:u
    for j=1:v
        if(Rmo(i,j)>0) 
            mapRmo(i,j)=1;
        else
            mapRmo(i,j)=0;
        end
    end
end

Rmax=max(max(R));
sinonew=R;
Rn=[];

sinonew(mapRmo==1) = 0.8*Rmax;

% figure;
% imshow(sinonew,[],'Xdata',theta,'Ydata',xp,...
%             'InitialMagnification','fit')
% xlabel('\theta (degrees)')
% ylabel('x''')
% colormap(gray);title('sinogramma danneggiato');


PNew= iradon(sinonew, theta,'linear','shepp-logan',0.9);
PNew=PNew(2:end-1,2:end-1);

PNew(PNew>12)=12;
figure,imshow(PNew,[]),title(' metal artifacts reconstruction');


figure;
imshow(Pori,[]);title('phantom originale');
% figure;
% imshow(Blurred,[]);title('phantom rumore additivo + filtraggio gaussiano')