clc; clear; close all;

% Load dataset
data = load('All_Resulte.mat');
x = data.All_Resulte;
y_data = load('y_accel.mat');
y_accel = y_data.y_accel;

% Cross-validation parameters
k = 10;
cv = cvpartition(y_accel, 'KFold', k);

% Models and configurations
models = {
    'k-NN', @(X, Y) fitcknn(X, Y, 'NumNeighbors', 3);
    'SVM', @(X, Y) fitcecoc(X, Y, 'Learners', templateSVM('KernelFunction', 'linear', 'Standardize', true));
    'Decision Tree', @(X, Y) fitctree(X, Y);
    'Naive Bayes', @(X, Y) fitcnb(X, Y, 'DistributionNames', 'kernel');
    'Random Forest', @(X, Y) TreeBagger(8, X, Y, 'OOBPrediction', 'On', 'Method', 'classification')
};

% Loop over each model
for m = 1:size(models, 1)
    modelName = models{m, 1};
    trainFcn = models{m, 2};
    [allPredictions, accuracies] = cross_validate(cv, x, y_accel, trainFcn);
    
    % Display results
    confMat = confusionmat(y_accel, allPredictions);
    disp([modelName, ' Confusion Matrix:']);
    disp(confMat);
    heatmap(confMat, 'Title', [modelName, ' Confusion Matrix'], 'XLabel', 'Predicted Class', 'YLabel', 'True Class');
    disp(['Average Accuracy for ', modelName, ': ', num2str(mean(accuracies) * 100), '%']);
end

% Save model
finalModel = fitcknn(x, y_accel, 'NumNeighbors', 3);
save('trained_model.mat', 'finalModel');

% Helper function for cross-validation
function [allPredictions, accuracies] = cross_validate(cv, X, y, trainFcn)
    k = cv.NumTestSets;
    allPredictions = zeros(size(y));
    accuracies = zeros(k, 1);
    
    for i = 1:k
        trainIdx = training(cv, i); testIdx = test(cv, i);
        Mdl = trainFcn(X(trainIdx, :), y(trainIdx));
        y_pred = predict_model(Mdl, X(testIdx, :));
        allPredictions(testIdx) = y_pred;
        accuracies(i) = mean(y_pred == y(testIdx));
    end
end

% Helper function for prediction (handles TreeBagger cell output)
function y_pred = predict_model(Mdl, X)
    if isa(Mdl, 'TreeBagger')
        y_pred = str2double(predict(Mdl, X));
    else
        y_pred = predict(Mdl, X);
    end
end
