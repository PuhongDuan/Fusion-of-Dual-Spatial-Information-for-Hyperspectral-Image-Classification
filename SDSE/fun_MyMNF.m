function [RD_img]  = fun_MyMNF(img, d)
% Maximun Noise Fraction Based Dimensionality Reduction
% img: input 3D HSI image (m*n*l)
% d: excepted output dimensionality
% RD_img: output dimensionality reduced HSI

% reference: A Transformation for Ordering Multispectral Data in
%                   Terms of Image Quality with Implications for Noise
%                   Removal. TGRS 1987.  X = S+N

[m, n, l]  =  size(img);
Z = reshape(img, m*n, l)';
% [Z,scale_factor] = mapstd(Z);
center_Z = Z - mean(Z,2)*ones( 1,m*n);

% Step1: calculate the covaraince matrix of whole data
Sigma_X = (1/(m*n-1))*center_Z*center_Z';


% Step2: estimate the covaraince matrix of noise (with minimum/maximum autocorrelation factors (MAF),)
D_above =zeros(m,n,l);
for i = 2: m
    D_above(i,:,:) = img(i,:,:)- img(i-1,:,:); 
end

 D_right = zeros(m,n,l);
for i = 1:n-1
    D_right(:,i,:) = img(:,i,:)- img(:,i+1,:); 
end

D = (D_above+D_right)./2;

% for i = 1:n-1
%     D(:,i,:) = img(:,i,:)- img(:,i+1,:); 
% end

sz = size(D);

% for i =1:sz(3)
%     D(:,:,i) = D(:,:,i)./std2(D(:,:,i) );
% end

D_mat = reshape(D, sz(1)*sz(2), sz(3))';
%  [D_mat,scale_factor] = mapminmax(D_mat);
%[D_mat,scale_factor] = mapstd(D_mat);
center_D_mat = D_mat-mean(D_mat,2)*ones( 1,sz(1)*sz(2));
Sigma_N = (1/(sz(1)*sz(2)-1))*center_D_mat*center_D_mat';
% [U,S,V] = svd(Sigma_N);
% Sigma_X_adj = (U'*inv(S))'*Sigma_X* (U'*inv(S));
[eig_vectors, eig_value] = eig(inv(Sigma_N)*Sigma_X);
project_H = eig_vectors(:, 1:d);
RD_img_mat = project_H'*Z;
RD_img = reshape(RD_img_mat' , [m,n,d]);
end