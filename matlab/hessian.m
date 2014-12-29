function [hess] = hessian ( X, y, theta)
% returns the Hessian, a matrix of second order partial derivatives of the
% function l.
hX = sigmoid(X*theta);

hess = transpose(X) * diag(-hX .* (1-hX)) * X;

