function [ out,fimg1 ] = SDSE( img )
% img: Original hyperspectral image;
% out: the structural profile
% Dimention reduction
 img2=average_fusion(img,40);
 [no_lines, no_rows, no_bands] = size(img);
%%% normalization

no_bands=size(img2,3);
fimg=reshape(img2,[no_lines*no_rows no_bands]);
[fimg] = scale_new(fimg);
fimg=reshape(fimg,[no_lines no_rows no_bands]);
fimg1 = satv(fimg,1,[],[],'L2');
out =kpca(fimg1, 1000,20, 'Gaussian',20);
end

