function MMesh(damesh)


        %%
        A=im2bw(damesh,0.5); %mappa

        [yy,xx]=find(A); %% vertici della mia triangolazione
        YY=DelaunayTri(xx,yy); %traingolazione dell'inviluppo convesso dei miei vertici (no good)
        my=YY.X; % vertici della mia triangolazione

        %% trovo tutto il contorno del mio dominio
        A_borders = bwperim(A);
%         imshow(A_borders);
        [ay,ax]=find(A_borders);% coordinate bordo
        [flagB,posB]=ismember([ax ay],my,'rows'); % dove stanno in YY.X;

        %% trovo descrizione boundary esterno
        BE=bwtraceboundary(A,[yy(1) xx(1)],'S',4,1000000000,'clockwise');
        BE=[BE(:,2) BE(:,1)]; % prima colonna=x, seconda colonna= y

        % devo ora trovare a quali vertici su YY.X; corrispondono quelli di BE
        [flagBE,posBE]=ismember(BE,my,'rows'); % ritorna se e dove la riga di BE sta in My e dove;

        %%  costruisco matrice edges esterni con i punti descritti dalla riga su
        % cui si trovano su YY.X;
        poss=posBE(1:end-1); 
        CE=zeros(size(poss,1),2);
        CE(:,1)=poss; % prendo i punti inziali degli edges esterni
        CE(:,2)=circshift(poss,-1); % prendo i punti finali degli edges esterni
        aux1=ismember((1:size(my,1))',poss);

        %% vediamo ora se il mio dominio ha anche dei buchi al suo interno

        posBIT = setdiff(posB, posBE) ; %border - borderesterno= border interno;

        flagmesh=0;
        aux2=zeros(size(aux1));
        C=[];
        while(size(posBIT,1)) % presenza di buchi

             flagmesh=flagmesh+1;

             BI = bwtraceboundary(A,[my(posBIT(1),2),my(posBIT(1),1)],'N',4,1000000000,'counterclockwise');
%              BI = bwtraceboundary(A,[my(posBIT(1),2),my(posBIT(1),1)],'N',8,1000000,'counterclockwise');
             BI=[BI(:,2) BI(:,1)];
             [flagBI,posBI]=ismember(BI,my,'rows');

             possbi=posBI(1:end-1);
             CI=zeros(size(possbi,1),2);
             CI(:,1)=possbi;
             CI(:,2)=circshift(possbi,-1);

             aux2=2*ismember((1:size(my,1))',possbi); 

             posBIT = setdiff(posBIT,posBI) ;
             
             C=[C;CI];
             
        end 

        % per rendere più robusto l'algoritmo per domini brutti, andrebbe tratta il
        % caso di buchi vicini tra loro e il caso dei buchi piccoli


        
        %% impongo vincoli a quello che ora l'inviluppo convesso
        YY.Constraints=[CE;C];
%         YY.Constraints=[C];
        IO = inOutStatus(YY);
        %% plotta mesh
%           figure;
%          triplot(YY(IO, :), YY.X(:,1), YY.X(:,2));

        %% trovo prima ed ultima proiezione
        pos1=find(BE(:,1)==1); % cerco i punti sul lato 1
        poss1=posBE(pos1(2:end-1));
        CC1=zeros(size(poss1,1),2);
        CC1(:,1)=poss1;
        CC1(:,2)=circshift(poss1,-1);
        CC1(end,2)=1;
        [flagc1,posc1]=ismember(CC1,CE,'rows');
        ppp1=posc1(find(posc1));
        %%
        pos360=find(BE(:,1)==size(A,2));
        poss360=posBE(pos360(1:end-1));
        CC360=zeros(size(poss360,1),2);
        CC360(:,1)=poss360;
        CC360(:,2)=posBE(pos360(2:end));
        [flagc360,posc360]=ismember(CC360,CE,'rows');
        ppp360=posc360(find(posc360));

         %% costruisco border list vertex list e triangle list

        trianglelist= zeros(size(YY(IO, :),1),4);
        trianglelist(:,1:3)=YY(IO, :);

        %come labels metti 1 per l'esterno 2 per il lato 1, 3 per il lato 360, 4
        %per gli interni

        borderlist(1:size(CE,1),1:3)=[CE ones(size(CE,1),1)];
        borderlist(ppp1,3)=3;
        borderlist(ppp360,3)=4;

        aux3=2*ismember((1:size(my,1))',posBE(pos1(2:end)));
        aux4=3*ismember((1:size(my,1))',posBE(pos360(1:end)));
        aux=aux1+aux3+aux4;

        vertexlist=[my,aux];

        if(flagmesh)
            borderlist(size(CE,1)+1:size(C,1)+size(CE,1),1:3)=[C 2.*ones(size(C,1),1)];
            vertexlist=[my,aux+aux2];
        end


        %%

        cd temp
        filegriglia = fopen ('griglia.msh', 'w');
        fprintf(filegriglia, '%d %d %d\n', length(vertexlist), length(trianglelist),length(borderlist));
        for j= 1:length(vertexlist)
            fprintf(filegriglia, '%d %d %d\n', vertexlist(j,:));
        end
        for j= 1:length(trianglelist)
            fprintf(filegriglia, '%d %d %d %d\n', trianglelist(j,:));
        end
        for j= 1:length(borderlist)
            fprintf(filegriglia, '%d %d %d\n', borderlist(j,:));
        end
        fclose(filegriglia);
        cd ..

        %%

return
