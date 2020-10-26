function [C, G, cv, cv_t]=cross_validation_svm(train_label,train_set)

%
% function  [C G cv cv_t]=cross_validation(train_label,train_set,kernel)
%
% This function performs a cross_validation to select goods
% parameter for the training of a binary svm
%
% INPUT
% train_label: the label in row column
% train_set: the sample corresponding to the label
%
% OUPUT
% C: the optimal value of c coressponding to the best cv
% g: the optimal value of g coressponding to the best cv
% cv: the best cross validation accuracy
% cv_t: the cross validation grid

h = waitbar(0,'cross_validation...');
c=10.^(-2:4);
g=2.^(-3:1:4);

c_s=length(c);
g_s=length(g);

k=0;
for i=1:g_s
    for j=1:c_s
        k=k+1;
        waitbar(k/(g_s*c_s));
        parameter=sprintf('-c %f -g %f -m 1000 -v 5 -q',c(j),g(i));
        cv_t(i,j)=svmtrain(train_label, train_set,parameter);
    end
end

[li, co]=find(max(max(cv_t))==cv_t);
C=c(co(1));
G=g(li(1));
cv=max(max(cv_t));
close(h)