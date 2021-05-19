function [restaurato] = restaura(ImpR,R,mapRmo,maxR,minR,spacingtheta,thetamax)
% [restaurato] = restaura(ImpR,R,mapRmo,maxR,minR,spacingtheta,thetamax)
% Aggiunge il inpaint con il origninale
% Fa la trasformata inversa con parametri pacingtheta,thetamax

theta=0:spacingtheta:thetamax-1;

Inpainted(:,:) = (R).*(not(mapRmo)) + ImpR.*(mapRmo);
imp=(maxR-minR)*Inpainted+minR*ones(size(R));

Recu= iradon(imp, theta);
restaurato=Recu(2:end-1,2:end-1);

end