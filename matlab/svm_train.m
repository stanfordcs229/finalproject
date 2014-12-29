function model = svm_train(X, y)

addpath('../liblinear-1.7/matlab');  % add LIBLINEAR to the path

model = train(y, sparse(X));