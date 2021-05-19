function y = map(x)
%Usato para creare la imagine con artefati a partire della imagine
%originale, solo per il Phanton Hip
    y = (12/log(2.2)*log(x+1)+1).*x;
end