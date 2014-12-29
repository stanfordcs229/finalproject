function grad = gradient(X,y,theta)

% h is the hypothesis function
%% h(X) = g(theta*X) where g is the sigmoid function
hX = sigmoid(X*theta);
grad = transpose(X) * (y-hX);

