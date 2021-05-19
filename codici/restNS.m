% Script per Restaurazione Lineare

Ioriginale = Par2;
treshold = 0.99;
spacingtheta = 0.25;
thetamax = 360;

t = tic;
[Imet,Inm] = segmentaMetallo(Ioriginale,treshold);
Imet2 = Imet;
Imet2(Imet2>0) = 1;
Imet2 = imclose(Imet2,strel('disk',5));
Imet2 = imdilate(Imet2,strel('disk',4 ));
Imet(Imet2>0) = Ioriginale(Imet2>0);
tsegm = toc(t);

t = tic;
[R,Rmo,Rnm,minR,maxR] = trasRadon(Ioriginale,Imet2,spacingtheta,thetamax,0);
tradon =  toc(t);

t = tic;
mapRmo = geraMesh(Rmo,'square',1);
tmesh =  toc(t);

t = tic;
Imp =inpainting(R,mapRmo,20);
timpating =  toc(t);

t = tic;
Restaurato = restaura(Imp,R,mapRmo,maxR,minR,spacingtheta,thetamax);
trestauro =  toc(t);

RestMet = Restaurato;
RestMet(Imet > 0 ) = Imet(Imet > 0 );

