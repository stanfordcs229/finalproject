features_files = dir('features/features_for_*.csv');
label_files = dir('labels/labels_for_*.csv');

num_files = size(features_files,1);
theta = zeros(num_files, 1);
file_names = cell(num_files,1);
test_error = zeros(num_files,1);

% for total statistics
num_errors = 0;
num_reviews = 0;
fp= zeros(num_files,1);
tp= zeros(num_files,1);
fn= zeros(num_files,1);
num_fp=0;
num_tp=0;
num_fn=0;


for i = 1:num_files
    if features_files(i).isdir == 0 && label_files(i).isdir == 0
        file_names(i) = cellstr(features_files(i).name);
        feature_csv = load(strcat('features/', features_files(i).name));
        label_csv = load(strcat('labels/', label_files(i).name));
        label_csv = label_csv > 3;
        train_test_index = ceil(size(feature_csv,1) * 0.7);
        
        theta = newton(feature_csv([1:train_test_index],:), label_csv([1:train_test_index],:) );
        X_test = feature_csv([train_test_index+1:end],:);
        X_test = [ones(size(X_test,1),1) X_test];
        y_test = label_csv([train_test_index+1:end],:);
        output = (X_test * theta > 0); % predictions
        error = sum(abs(y_test - output));
        test_error(i) = error / size(y_test, 1) * 100;
        num_errors = num_errors + error;
        num_reviews = num_reviews + size(y_test, 1); 
        
        numTestDocs = size(y_test(:,1));
        
        for j=1:numTestDocs
        if (y_test(j) ~= output(j))
            if (y_test(j) == 0)
                fp(i) = fp(i)+1
            else
               fn(i) = fn(i)+1
            end
        end
        
        if (y_test(j) == output(j))
            if (y_test(j) == 1)
                tp(i) = tp(i)+1
            end
        end  
        end      
    end
end
file_names
test_error
overall_error= num_errors/num_reviews
num_tp= sum(tp);
num_fp= sum(fp);
num_fn= sum(fn);
overall_precision= num_tp/(num_tp+num_fp)
overall_recall= num_tp/(num_tp+num_fn)
overall_f1=2*(overall_precision*overall_recall)/(overall_precision+overall_recall)