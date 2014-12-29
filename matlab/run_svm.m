features_files = dir('features/features_for_*.csv');
label_files = dir('labels/labels_for_*.csv');

num_files = size(features_files,1);
file_names = cell(num_files,1);
test_error = zeros(num_files,1);

% for total statistics
num_errors = 0;
num_reviews = 0;
num_fp= 0;
num_tp= 0;
num_fn=0;

for i = 1:num_files
    if features_files(i).isdir == 0 && label_files(i).isdir == 0
        file_names(i) = cellstr(features_files(i).name);
        feature_csv = load(strcat('features/', features_files(i).name));
        label_csv = load(strcat('labels/', label_files(i).name));
        label_csv = 2*(label_csv > 3) - 1;

        train_test_index = ceil(size(feature_csv,1) * 0.7);

        model = svm_train(feature_csv([1:train_test_index],:), label_csv([1:train_test_index],:) );
        [test_error(i), error, tp, fp, fn] = svm_test(feature_csv([train_test_index+1:end],:), label_csv([train_test_index+1:end],:), model);
        num_errors = num_errors + error;
        num_reviews = num_reviews + size(label_csv([train_test_index+1:end],:),1);
        num_tp = num_tp + tp;
        num_fn = num_fn + fn;
        num_fp = num_fp + fp;
    end
end
file_names
test_error
num_errors
num_reviews
num_tp
num_fp
num_fn
overall_error= num_errors/num_reviews
overall_precision= num_tp/(num_tp+num_fp)
overall_recall= num_tp/(num_tp+num_fn)
overall_f1=2*(overall_precision*overall_recall)/(overall_precision+overall_recall)
