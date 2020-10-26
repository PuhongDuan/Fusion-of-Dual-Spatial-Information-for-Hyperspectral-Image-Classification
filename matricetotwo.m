function GroundT=matricetotwo(gt)
% j将图像GT  m*n的矩阵转换成2*k
Train_Label = [];
Train_index = [];
no_classes=max(gt(:));
%% generate 
for ii = 1: no_classes
   index_ii =  find(gt == ii);
   class_ii = ones(length(index_ii),1)* double(ii);
   Train_Label = [Train_Label class_ii'];
   Train_index = [Train_index index_ii'];   
end
trainall = zeros(2,length(Train_index));
trainall(1,:) = Train_index;
trainall(2,:) = Train_Label;

GroundT=[];
GroundT=trainall;
end
