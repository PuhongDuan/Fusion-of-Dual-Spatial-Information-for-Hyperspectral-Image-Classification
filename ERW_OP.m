function [ ERWresult,probability ] = ERW_OP( img,train,prob )

%%%%%种子点的位置和种子的标号
seeds = [train(1,:)];
labels= [train(2,:)];  
gamma=0.1^5; % or 
 %gamma = 710 ;
 %beta = 0.1^5; 
 beta=710;
[ERWresult,probability] = RWOptimize(img,seeds,labels,beta,prob,gamma,1); 


end

