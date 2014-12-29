function [theta] = newton(X, y)
% X is feature vector
% y is result vector
% to load X and y
%% X = load('../v2_features_for_FcjwXnuDuN8not6PoHID3w_train.csv');
%% y = load('../v2_labels_for_FcjwXnuDuN8not6PoHID3w_train.csv');

X = [ones(size(X,1),1) X]; % add intercept term
theta = zeros(size(X,2),1); % initialise theta to be the zero vector
max_iters = 50;

for k = 1:max_iters
	theta = theta - pinv(hessian(X,y,theta))*gradient(X,y,theta);
end
