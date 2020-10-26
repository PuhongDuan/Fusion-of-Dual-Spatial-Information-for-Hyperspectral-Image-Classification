function [ varargout ] = ERW_AL( varargin )
img = varargin{1}; % 1st parameter is the data set
s=img.s;
rows=s(1);
cols=s(2);
bands=s(3);
classes=s(4);
if ~numel(img),error('the data set is empty');end
train = varargin{2}; % the 2nd parameter is the training set
if isempty(train), error('the train data set is empty, please provide the training samples');end
no_classes = max(train(2,:));

if nargin >2
    test = varargin{3}; % the 3rd parameter is the test
else
    fprintf('the test set is empty, thus we use the training set as the validation set \n')
    test = train;
end
if nargin >3
    AL_sampling = varargin{4};
else
    AL_sampling = [];
end

if isempty(AL_sampling)
    tot_sim = 1;
else
    tot_sim = AL_sampling.U/AL_sampling.u +1;
end
if nargin >4
    no_sslsamples = varargin{5};
else
    no_sslsamples = 20;
end
train1=train;
for iter = 1:tot_sim
    trainset = img.im(:,train(1,:));
    [no_lines, no_rows, no_bands] = size(img);
    train_samples = trainset;
    train_labels  = train(2,:)';
% vectorization
fimg=img.im;


% Normalize the training set and original image
[train_samples,M,m] = scale_func(train_samples');
[fimg] = scale_func(fimg',M,m);

% Select the paramter for SVM with five-fold cross validation
% [Ccv Gcv cv cv_t]=cross_validation_svm(train_labels,train_samples);

% Training using a Gaussian RBF kernel
%give the parameters of the SVM (Thanks Pedram for providing the
% parameters of the SVM)
parameter=sprintf('-s 0 -t 2 -c %f -g %f -m 500 -b 1',10,8); 

%%% Train the SVM
model=svmtrain(train_labels,train_samples,parameter);

[SVMresult, accuracy,prob] = svmpredict(ones(rows*cols,1) ,fimg,model,'-b 1');  
% Evaluation the performance of the SVM

% Display the result of SVM
prob=reshape(prob,[rows cols no_classes]);
%%%%%种子点的位置和种子的标号
seeds = [train(1,:)];
labels= [train(2,:)];  
gamma=0.1^5; % or 
 %gamma = 710 ;
 %beta = 0.1^5; 
 beta=710;
[ERWresult,probability] = RWOptimize(img.im',seeds,labels,beta,prob,gamma,1); 
[seg_results.OA(iter),seg_results.kappa(iter), seg_results.AA(iter),seg_results.CA(iter,:)]= calcError(test(2,:)-1, ERWresult(test(1,:))-1,[1:no_classes]);
 seg_results.map=ERWresult;
 candind= test(1,:);
 candlabel= test(2,:);

 

%%%% 估计random walks优化的性能
% Comprasion
   
 % figure(4),imshow(mapt);
% figure,imshow(mapt1);
    if isempty(AL_sampling)
        fprintf( 'No active selection sampling will be addressed \n' );
    elseif strcmp(AL_sampling.AL_method,'RS');
        per_indexR = randperm(size(AL_sampling.candidate,2));
        xp = per_indexR(1:AL_sampling.u);
        trainnew1 = AL_sampling.candidate(:,xp);
        train = [train,trainnew1];
        AL_sampling.candidate(:,xp) = [];
    end
end
varargout(1) = {seg_results};
varargout(2) = {probability};
% if nargout == 2, varargout(2) = {seg_results};end
end


