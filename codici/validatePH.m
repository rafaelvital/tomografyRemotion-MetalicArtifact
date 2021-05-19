function [MSE,PSNR,CC,mssim,ssim_map,FSIM]=validatePH(img,orig)
%Perform validation on images img comparing with the original image orig

%L2 norm

if size(img)~=size(orig)
    fprintf 'Error, size not equal'
else
    N=size(img,1)*size(img,2);
    l2=sum((img(:)-orig(:)).^2);
    %Mean Square Error
    MSE = (1/N) *l2;
    %Peak Signal to Noise Ratio
    %come MAXI bisognerebbe usare il massimo valore che può assumere
    %l'immagine (per una immagine codificata a 8bit sarebbe 256. Matlab
    %però il phantom lo genera tra 0,1 e anche più come MAXI userei il
    %valore max dell'immagine originale.
    MAX=max(max(orig));
    PSNR=10*log10(MAX^2/MSE);
    %Cross Correlation
    %sdorig=sqrt(sum(sum((orig-mean(mean(orig))).^2)));
    %sdimg=sqrt(sum(sum((img-mean(mean(img))).^2)));
    CC=sum(sum((orig-mean(mean(orig))).*(img-mean(mean(img)))))./sqrt(sum(sum((orig-mean(mean(orig))).^2))*sum(sum((img-mean(mean(img))).^2)));
    [mssim, ssim_map] = compute_ssim_index(orig, img);
    FSIM = FeatureSIM(orig, img);
    
end    
    