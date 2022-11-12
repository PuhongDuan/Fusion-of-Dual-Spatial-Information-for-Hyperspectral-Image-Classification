clc;
clear;
close all;
%% Please cite this work:
%% Puhong Duan, Pedram Ghamisi, Xudong Kang, Behnood Rasti, Shutao Li, and Richard Gloaguen,
%% Fusion of Dual Spatial Information for Hyperspectral Image Classification,2020, DOI: 10.1109/TGRS.2020.3031928
addpath('SDSE');
addpath('Datasets');
addpath('SVM')
addpath('ERW')
addpath('drtoolbox')
%% load data
load PaviaU
load Pavia_trainingtest.mat
img=Normalization(img);
%% size of image 
[no_lines, no_rows, no_bands] = size(img);
Tr=zeros(no_lines, no_rows);
Tr(train_SL(1,:))=train_SL(2,:);
Te=zeros(no_lines, no_rows);
Te(test_SL(1,:))=test_SL(2,:);
%% Extraction of spatial information
[Pre_re Pre_pro ] = pre_classification( img,Tr,Te );
[ Pos_re Pos_pro] = post_classification( img,Tr,Te );
%% Decision fusion
t=0.3;% a tunable parameter
Fuse_pro=t.*Pre_pro+(1-t).*Pos_pro;
[Class_pro,Fuse_Result]=max(Fuse_pro,[],3);
Result=reshape(Fuse_Result,[no_lines*no_rows 1]);
GroudTest = double(test_SL(2,:));
ResultTest = Result(test_SL(1,:),:);
%% Objective Evaluation
[SVM_OA,SVM_AA,SVM_Kappa,SVM_CA]=confusion(GroudTest,ResultTest);
Result = reshape(Result,no_lines,no_rows);
%% Display visual map
VClassMap=label2colord(Result,'hu');
figure,imshow(VClassMap);
disp('%%%%%%%%%%%%%%%%%%% Classification Results of FDSI Method %%%%%%%%%%%%%%%%')
disp(['OA',' = ',num2str(SVM_OA),' ||  ','AA',' = ',num2str(SVM_AA),'  ||  ','Kappa',' = ',num2str(SVM_Kappa)])
