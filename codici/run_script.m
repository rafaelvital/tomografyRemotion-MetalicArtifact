% script che chiama la fuzione/script run diverse volta, o sia fa le prove
% in sequenzia

treshold = 7;
[Imet,Inm] = segmentaMetallo(Part,treshold);
Imet2 = Imet;
Imet2(Imet2>0) = 1;
Imet2 = imerode(Imet2,strel('disk',10));
Imet2 = imdilate(Imet2,strel('disk',10));
Imet(:,:) = 0;
Imet(Imet2>0) = Part(Imet2>0);

Prima = 'Lin';
Seconda = 'Lin';
Dil = 8;
K = 10;
vecfusionN = [1 5 10 20];
vecfusionT = [0.15 0.45 0.75];
filterV = 20;
filterT = 0.5;

for i=1:length(vecfusionN)
    for j=1:length(vecfusionT)
       
        fusionN = vecfusionN(i);
        fusionT = vecfusionT(j);

        run(Prima,Seconda,Dil, K, fusionN, fusionT, filterV, filterT,Part,Pori,Imet);
    end
end


