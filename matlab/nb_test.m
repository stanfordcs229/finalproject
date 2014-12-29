function [accuracy, error, tp, fp, fn] = nb_test(X, y, phi_y, phi_x_given_y1, phi_x_given_y0)

category = y;
testMatrix = X;
numTestDocs = size(testMatrix, 1);

% Assume nb_train.m has just been executed, and all the parameters computed/needed
% by your classifier are in memory through that execution. You can also assume 
% that the columns in the test set are arranged in exactly the same way as for the
% training set (i.e., the j-th column represents the same token in the test data 
% matrix as in the original training data matrix).

% Write code below to classify each document in the test set (ie, each row
% in the current document word matrix) as 1 for SPAM and 0 for NON-SPAM.

% Construct the (numTestDocs x 1) vector 'output' such that the i-th entry 
% of this vector is the predicted class (1/0) for the i-th  email (i-th row 
% in testMatrix) in the test set.
output = zeros(numTestDocs, 1);

%---------------
% YOUR CODE HERE
p_y1 = zeros(numTestDocs, 1);
p_y0 = zeros(numTestDocs, 1);
for i = 1 : numTestDocs
	p_y1(i) = testMatrix(i,:) * log(phi_x_given_y1) + log(phi_y);
	p_y0(i) = testMatrix(i,:) * log(phi_x_given_y0) + log(1-phi_y);
end
output = p_y1 > p_y0;
%---------------


% Compute the error on the test set
error=0;
tp=0;
fn=0;
fp=0;

for i=1:numTestDocs
  if (category(i) ~= output(i))
    error=error+1;
    if (output(i) == 1)
        fp=fp+1;
    else
        fn=fn+1;
    end
  end
  
  if (category(i) == output(i))
      if (output(i) == 1)
          tp = tp+1;
      end    
  end
  
end

%Print out the classification error on the test set
accuracy = error/numTestDocs;
precision= tp/(tp+fp);
recall= tp/(tp+fn);
f1=2*(precision*recall)/(precision+recall);