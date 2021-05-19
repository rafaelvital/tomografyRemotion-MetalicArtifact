function run(Prima,Seconda,Dil, K, fusionN, fusionT, filterV, filterT,Part,Pori,Imet)
% Algoritimo per fare la restaurazione di imagine usando il metodo fusion.
% L'algoritmo possui i parametri per fare diversi testi in sequenza
% Quando finisce, salva i risultati e fa l'analise dei dati.
% é obbligatorio che il .mat 'Resultado.mat' esista e che abbia le
% variabile comp, interator e line anche il txt che registra le prove
% deve esistire

% Valori amissibile per il parametro Prima = Lin, NS
% Valori amissibile per il parametro Seconda = Lin, NS e nulla

spacingtheta = 0.25;
thetamax = 360;
Imet2 = Imet;
Imet2(Imet2>0) = 1;
[R,Rmo,~,minR,maxR] = trasRadon(Part,Imet2,spacingtheta,thetamax,0);
mapRmo = Rmo;
mapRmo(mapRmo>0) = 1;

if(strcmp(Prima,'Lin'))
     Imp =lineare(R,mapRmo);
end

if(strcmp(Prima,'NS'))
    mapRmo = geraMesh(Rmo,'disk',Dil);
    t = tic;
    Imp =inpainting(R,mapRmo,K);
    tradon =  toc(t);
end

Restaurato = restaura(Imp,R,mapRmo,maxR,minR,spacingtheta,thetamax);
Restauratof=filterEdge(Restaurato,filterV,filterT);

% RestMet = Restauratof;
% RestMet(Imet > 0 ) = Imet(Imet > 0 );
% B = takeline(RestMet);

% % % % % % % % % % % % % % % % % % % %
if(~strcmp(Seconda,'nulla'))
    Iunc = Part;
    Iunc(Imet > 0 ) = 0;
    Restauratof(Imet > 0 ) = 0;
    F = fusion(Restauratof,Iunc,fusionT,fusionN);

    theta=0:spacingtheta:thetamax-1;
    [R,~]=radon(Iunc,theta);
    [RF,~]=radon(F,theta);
    RD = R-RF;

    if(strcmp(Seconda,'Lin'))
        Imp2=lineare(RD,mapRmo);
    end


    if(strcmp(Seconda,'NS'))
        %  nomaliza RD
        maxR=max(max(RD));
        minR=min(min(RD));
        RD=(RD-minR*ones(size(RD)))./(maxR-minR);

        mapRmo = geraMesh(Rmo,'disk',Dil);
        Imp2 =inpainting(RD,mapRmo,K);
        Imp2= (Imp2).*mapRmo + RD.*(not(mapRmo));

        % desnormaliza Imp2/RD
        Imp2=(maxR-minR)*Imp2+minR*ones(size(RD));
    end

    Imp2 = Imp2+RF;

    Recu= iradon(Imp2, theta);
    Restaurato2=Recu(2:end-1,2:end-1);

    Restauratof2=filterEdge(Restaurato2,filterV,filterT);
else
    Restauratof2 = Restauratof;
end

RestMet2 = Restauratof2;
RestMet2(Imet > 0 ) = Imet(Imet > 0 );

B = takeline(RestMet2);
    
Comp = [];
[MSE,PSNR,CC,mssim,FSIM] = validate(RestMet2,Pori,1);
Comp = [Comp MSE PSNR CC mssim FSIM];
[MSE,PSNR,CC,mssim,FSIM] = validate(RestMet2,Pori,2);
Comp = [Comp MSE PSNR CC mssim FSIM];
[MSE,PSNR,CC,mssim,FSIM] = validate(RestMet2,Pori,3);
Comp = [Comp MSE PSNR CC mssim FSIM];

l= load('Resultado.mat');
l.iterator = l.iterator+1;
l.comp(l.iterator,:) = Comp;
l.line(l.iterator,:) = B;
imshow(RestMet2,[]);
saveas(gcf,strcat('resultado\final\prova',num2str(l.iterator)),'jpeg');
fid = fopen('resultado/final/listprove.txt','a+');
fprintf(fid,'Prove %d \n %s %s %d  %g %g %g %g %g %g\n',l.iterator,Prima,Seconda,Dil, K, fusionN, fusionT, filterV, filterT);
fclose(fid);

comp = l.comp;
line = l.line;
iterator = l.iterator;
save('Resultado.mat','comp','line','iterator');

end