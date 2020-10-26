function [ s ] = sparse_new(d)
%SPARSE_NEW Summary of this function goes here
%   Detailed explanation goes here
N=length(d);
x=1:N;
s=sparse(x,x,d,N,N);
end

