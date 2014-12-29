features_files = dir('features/features_for_*.csv');
label_files = dir('labels/labels_for_*.csv');

sample_feature_csv = load(strcat('features/', features_files(1).name));
N = size(sample_feature_csv, 2);
F = 30;
chosen = zeros(0);
chosen_error = ones(F,1);
chosen_f1 = ones(F,1);



for iN = 1:F
    forward_search = zeros(N, 1);
    f1_scores = zeros(N,1);
    for jN = 1:N
        if ismember(jN, chosen) == 0
            test_features = chosen;
            test_features(iN) = jN;
            num_files = size(features_files,1);
            file_names = cell(num_files,1);

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
                    feature_csv = feature_csv(:, test_features); %%% FORWARD SEARCH STEP in nb_train and nb_test call
                    label_csv = load(strcat('labels/', label_files(i).name));
                    label_csv = 2*(label_csv > 3) - 1;
                    train_test_index = ceil(size(feature_csv,1) * 0.7);

                    model = svm_train(feature_csv([1:train_test_index],:), label_csv([1:train_test_index],:) );
                    [~, error, tp, fp, fn] = svm_test(feature_csv([train_test_index+1:end],:), label_csv([train_test_index+1:end],:), model);
                    num_errors = num_errors + error;
                    num_reviews = num_reviews + size(label_csv([train_test_index+1:end],:),1);
                    num_tp = num_tp + tp;
                    num_fn = num_fn + fn;
                    num_fp = num_fp + fp;
                end
            end

            forward_search(jN) = num_errors/num_reviews;
            overall_precision = num_tp/(num_tp+num_fp);
            overall_recall = num_tp/(num_tp+num_fn);
            f1_scores(jN) = 2*(overall_precision*overall_recall)/(overall_precision+overall_recall);
        else
            forward_search(jN) = 1;
        end
    end
    [min_error, index] = min(forward_search);
    chosen_f1(iN) = f1_scores(index,1);
    disp([iN, min_error, index, chosen_f1(iN)]);
    chosen(iN) = index;
    chosen_error(iN) = min_error;
    if min_error == 0 
        break
    end
end

disp([chosen' chosen_error chosen_f1]);