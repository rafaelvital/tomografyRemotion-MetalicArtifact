function [ImpR] = lineare(R,mapRmo)
% [ImpR] = lineare(R,mapRmo)
% Inpainting della imagine R com interpolazione lineare
% ImpR = Imagine riempita
% R = Imagine
% mapRmo = Map che dice qualle pixel fare la interpolazione

    Rnew=R-R.*mapRmo;
    
    for a=1:size(Rnew,2)
        posto=find(Rnew(:,a));
        posto1=interp1(posto,Rnew(posto,a),posto(1):1:posto(end),'linear'); 
        Rnew(posto(1):1:posto(end),a)=posto1;
    end
    
    ImpR = zeros(size(R));
    ImpR(mapRmo>0) = Rnew(mapRmo>0);

end