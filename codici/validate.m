function [MSE,PSNR,CC,mssim,FSIM] = validate(img,orig,region)
% prende i indice per confrontare la similarita di img e orig 

% Osso
if(region==1)
    [MSE,PSNR,CC,mssim,ssim_map,FSIM] = validatePH(img(185:325,130:215),orig(185:325,130:215));
end

% Palla
if(region==2)
    [MSE,PSNR,CC,mssim,ssim_map,FSIM] = validatePH(img(240:270,230:280),orig(240:270,230:280));
end

% Tutta
if(region==3)
    [MSE,PSNR,CC,mssim,ssim_map,FSIM] = validatePH(img(120:390,:),orig(120:390,:));
end

end