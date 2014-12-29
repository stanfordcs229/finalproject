function [theta] = perceptron(X, y)
% X is feature vector
% y is result vector
% output theta: parameters

X = [ones(size(X,1),1) X];
theta = zeros(size(X,2),1); % initialise theta
alpha = 0.0001;
max_iters = 50;

for k = 1:max_iters
  hx = (X*theta) >= 0;
  theta = theta + alpha * X' * (y-hx); 
end