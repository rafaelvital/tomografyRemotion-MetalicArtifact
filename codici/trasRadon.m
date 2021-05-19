function  [R,Rmo,Rnm,minR,maxR] = trasRadon(Ioriginale,Imet,spacingtheta,thetamax,plotare)
% [R,Rmo,Rnm,minR,maxR] = trasRadon(Ioriginale,Imet,spacingtheta,thetamax,plotare)
% Trasformata di radon normalizzata con parametri spacingtheta e thetamax
% della imagine originale, metalica e non metallica
% R = Radon della imagine originale ( Normalizzata)
% Rmo = Radon della parte metallica
% Rnm =  Radon della parte non metallica
% minR e maxR = Parametri di normalizzazione
% plotare = 1 per plotare i grafici


theta=0:spacingtheta:thetamax-1;

Inonmet=not(Imet);
Imo=Imet.*Ioriginale;
Inm=Inonmet.*Ioriginale;

[R,xp]=radon(Ioriginale,theta);
Rmo=radon(Imo,theta);
Rnm=radon(Inm,theta);

maxR=max(max(R));
minR=min(min(R));
R=(R-minR*ones(size(R)))./(maxR-minR);

%% plots
if(plotare==1)
    figure;
    imshow(Ioriginale,[]);title('originale')
    figure;
    imshow(Inm,[]);title('Immagine w/o metal')
    figure;
    imshow(Imo,[]);title('Immagine  metal only')

    figure,imshow(R,[])
    xlabel('\theta (degrees)')
    ylabel('x''')
    colormap(gray);title('sinogramma immagine ')

    figure,imshow(Rmo,[])
    xlabel('\theta (degrees)')
    ylabel('x''')
    colormap(gray);title('sinogramma metal only ')

    figure,imshow(Rnm,[])
    xlabel('\theta (degrees)')
    ylabel('x''')
    colormap(gray);title('sinogramma non metal only ')
end
end