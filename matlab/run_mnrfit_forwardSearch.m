clear;

features_files = dir('../v3/features/features_for_*.csv');
label_files = dir('../v3/labels/labels_for_*.csv');

sample_feature_csv = load(strcat('../v3/features/', features_files(1).name));
N = size(sample_feature_csv, 2);
F = 30; % number of features we want to select
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
            test_error = zeros(num_files,1);
            
            % for total statistics
            num_errors = 0;
            num_reviews = 0;
            fp = zeros(num_files,1);
            tp = zeros(num_files,1);
            fn = zeros(num_files,1);
            
            for i = 1:num_files
                if features_files(i).isdir == 0 && label_files(i).isdir == 0
                    file_names(i) = cellstr(features_files(i).name);
                    feature_csv = load(strcat('../v3/features/', features_files(i).name));
                    feature_csv = feature_csv(:, test_features); %%% FORWARD SEARCH STEP in nb_train and nb_test call
                    label_csv = load(strcat('../v3/labels/', label_files(i).name));
                    train_test_index = ceil(size(feature_csv,1) * 0.7);
                    
                    [~, SCORE] = princomp(feature_csv, 'econ'); % PCA
                    
                    X_train = SCORE([1:train_test_index],:);
                    X_test = SCORE([train_test_index+1:end],:);
                    y_train = categorical(label_csv([1:train_test_index],:));
                    y_test = label_csv([train_test_index+1:end],:);
                    
                    % run multinomial regression
                    B = mnrfit(X_train, y_train);
                    probabilities = mnrval(B, X_test);
                    [max_probability, predictions] = max(probabilities, [], 2);
                    
                    % Compute the classification error on the test set
                    error = sum(y_test ~= predictions);
                    num_errors = num_errors + error;
                    num_reviews = num_reviews + size(y_test,1);
                    
                    for j=1:size(y_test,1)
                        if (y_test(j) ~= predictions(j))
                            if (y_test(j) == 0)
                                fp(i) = fp(i)+1;
                            else
                                fn(i) = fn(i)+1;
                            end
                        end
                        
                        if (y_test(j) == predictions(j))
                            if (y_test(j) == 1)
                                tp(i) = tp(i)+1;
                            end
                        end
                    end
                end
            end
            forward_search(jN) = num_errors/num_reviews;
            num_tp = sum(tp);
            overall_precision = num_tp/(num_tp+sum(fp));
            overall_recall = num_tp/(num_tp+sum(fn));
            f1_scores(jN) = 2*(overall_precision*overall_recall)/(overall_precision+overall_recall);
            disp([jN forward_search(jN)]);
        else
            forward_search(jN) = 1;
        end
    end
    [min_error, index] = min(forward_search);
    min_f1= f1_scores(index,1);
    disp([iN, min_error, index, min_f1]);
    chosen(iN) = index;
    chosen_error(iN) = min_error;
    chosen_f1(iN) = min_f1;
    if min_error == 0
        break
    end
end

disp([chosen' chosen_error chosen_f1]);
