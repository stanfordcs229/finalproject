function [phi_y, phi_x_given_y1, phi_x_given_y0] = nb_train(X, y)

numTrainDocs = size(X, 1);
numTokens = size(X,2);

%% I want to calculate all the phi here
phi_y = sum(y(:) == 1) / numTrainDocs;

denominator_phi_x_given_y1 = sum( y' * X) + numTokens;
denominator_phi_x_given_y0 = sum(~y' * X) + numTokens;

phi_x_given_y1 = zeros(numTokens, 1);
phi_x_given_y0 = zeros(numTokens, 1);
for k = 1 : numTokens
	phi_x_given_y1(k) = sum(X(:,k) .*  y) + 1;
	phi_x_given_y0(k) = sum(X(:,k) .* ~y) + 1;
end

phi_x_given_y1 = phi_x_given_y1 / denominator_phi_x_given_y1;
phi_x_given_y0 = phi_x_given_y0 / denominator_phi_x_given_y0;
end