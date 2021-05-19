% Script per Restaurazione usando il metodo Fusion

Ioriginale = Part;
treshold = 7;
spacingtheta = 0.25;
thetamax = 360;

t = tic;
[Imet,Inm] = segmentaMetallo(Ioriginale,treshold);
Imet2 = Imet;
Imet2(Imet2>0) = 1;
Imet2 = imerode(Imet2,strel('disk',10));
Imet2 = imdilate(Imet2,strel('disk',10));
Imet(:,:) = 0;
Imet(Imet2>0) = Ioriginale(Imet2>0);
tsegm = toc(t);

t = tic;
[R,Rmo,Rnm,minR,maxR] = trasRadon(Ioriginale,Imet2,spacingtheta,thetamax,0);
tradon =  toc(t);

mapRmo = Rmo;
mapRmo(mapRmo>0) = 1;

t = tic;
Imp =lineare(R,mapRmo);
timpating =  toc(t);

% t = tic;
% mapRmo = geraMesh(Rmo,'square',7);
% tmesh =  toc(t);
% 
% t = tic;
% Imp =inpainting(R,mapRmo,20);
% timpating =  toc(t);
% % 
t = tic;
Restaurato = restaura(Imp,R,mapRmo,maxR,minR,spacingtheta,thetamax);
trestauro =  toc(t);

Restauratof=filterEdge(Restaurato,20,0.7);

RestMet = Restaurato;
RestMet(Imet > 0 ) = Imet(Imet > 0 );

imshow(RestMet,[]);

% % % % % 

        Iunc = Ioriginale;
        Iunc(Imet > 0 ) = 0;
        Restaurato(Imet > 0 ) = 0;

        F = fusion(Restaurato,Iunc,0.45,10);
        
        theta=0:spacingtheta:thetamax-1;
        [R,xp]=radon(Iunc,theta);
        [RF,xp]=radon(F,theta);        
        RD = R-RF;
      
         mapRmo = imdilate(mapRmo,strel('disk',1));
         Imp2=lineare(RD,mapRmo);
        
% %         nomaliza RD
%         maxR=max(max(RD));
%         minR=min(min(RD));
%         RD=(RD-minR*ones(size(RD)))./(maxR-minR);
%         
% 
%         mapRmo = geraMesh(Rmo,'square',8);
%         Imp2 =inpainting(RD,mapRmo,20);        
%         Imp2= (Imp2).*mapRmo + RD.*(not(mapRmo));
% 
% %        desnormaliza Imp2/RD
%         Imp2=(maxR-minR)*Imp2+minR*ones(size(RD));
%         
%         
        
        Imp2 = Imp2+RF;

        Recu= iradon(Imp2, theta);
        Restaurato2=Recu(2:end-1,2:end-1);
        
        RestMet2 = Restaurato2;
        RestMet2(Imet > 0 ) = Imet(Imet > 0 );
         
        Restauratof2=filterEdge(Restaurato2,5,0.7);
        RestMet2 = Restauratof2;
        RestMet2(Imet > 0 ) = Imet(Imet > 0 );
 
