function [Imet,Inm] = segmentaMetallo(Ioriginal,treshold)
%segmenta metallo della imagine originale atraverso treshold
%[Imet,Inm] = segmentaMetallo(Ioriginal,treshold)

Imet=zeros(size(Ioriginal));
Inm=zeros(size(Ioriginal));
Imet(Ioriginal>treshold)=Ioriginal(Ioriginal>treshold);
Inm(Ioriginal<treshold)=Ioriginal(Ioriginal<treshold);

end