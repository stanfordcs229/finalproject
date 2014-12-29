function [accuracy, error, tp, fp, fn] = svm_test(X, y, model)

addpath('../ps2/liblinear-1.7/matlab');  % add LIBLINEAR to the path

%---------------
% YOUR CODE HERE
output = zeros(size(y,1), 1);
[output, accuracy, prob_estimates] = predict(output, sparse(X), model);

%---------------


% Compute the error on the test set
error=0;
tp=0;
fn=0;
fp=0;
for i=1:size(y,1)
  if (y(i) ~= output(i))
    error=error+1;
    if (output(i)==1)
        fp=fp+1;
    else
        fn=fn+1;
    end
  end
  
  if (y(i) == output(i))
      if(output(i) == 1)
          tp=tp+1;
      end
  end
  
end

%Print out the classification error on the test set
accuracy = error/size(y,1);
precision= tp/(tp+fp);
recall= tp/(tp+fn);
f1=2*(precision*recall)/(precision+recall);