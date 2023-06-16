% analysis_FeaturePrediction    Run feature prediction
%
% Author: Tomoyasu Horikawa <horikawa-t@atr.jp>, Shuntaro C. Aoki <aoki@atr.jp>
%


clear all;


%% Initial settings %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Data settings
% subjectList  : List of subject IDs [cell array]
% dataFileList : List of data files containing brain data for each subject in `subjectList` [cell array]
% featureList  : List of image features [cell array]
% roiList      : List of ROIs [cell array]
% numVoxelList : List of num of voxels included in the analysis for each ROI in `rois` [cell array]

subjectList  = {'Subject1', 'Subject2', 'Subject3', 'Subject4', 'Subject5'};
dataFileList = {'Subject1.mat', 'Subject2.mat', 'Subject3.mat', 'Subject4.mat', 'Subject5.mat'};
roiList      = {'V1', 'V2', 'V3', 'V4', 'FFA', 'LOC', 'PPA', 'LVC', 'HVC',  'VC'};
numVoxelList = { 500,  500,  500,  500,   500,   500,   500,  1000,  1000,  1000};
featureList  = {'cnn1', 'cnn2', 'cnn3', 'cnn4', ...
                'cnn5', 'cnn6', 'cnn7', 'cnn8', ...
                'hmax1', 'hmax2', 'hmax3', 'gist', 'sift'};

% Image feature data
imageFeatureFile = 'ImageFeatures.mat';

%% Directory settings
workDir = pwd;
dataDir = fullfile(workDir, 'data');       % Directory containing brain and image feature data
resultsDir = fullfile(workDir, 'results'); % Directory to save analysis results
lockDir = fullfile(workDir, 'tmp');        % Directory to save lock files

%% File name settings
resultFileNameFormat = @(s, r, f) fullfile(resultsDir, sprintf('%s/%s/%s.mat', s, r, f));

%% Model parameters
nTrain = 200; % Num of total training iteration
nSkip  = 200; % Num of skip steps for display info

%--------------------------------------------------------------------------------%
% Note: The num of training iteration (`nTrain`) was 2000 in the original paper. %
%--------------------------------------------------------------------------------%


%% Analysis Main %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fprintf('%s started\n', mfilename);%%mfilename用于返回当前脚本的文件名

%%----------------------------------------------------------------------
%% Initialization
%%----------------------------------------------------------------------

addpath(genpath('./lib'));%%ddpath函数用于将指定路径添加到MATLAB的搜索路径中，genpath('./lib')函数会返回一个包含'./lib'目录下所有子目录的字符向量

setupdir(resultsDir);
setupdir(lockDir);

%%----------------------------------------------------------------------
%% Load data
%%----------------------------------------------------------------------

%% Load brain data
fprintf('Loading brain data...\n');

for n = 1:length(subjectList)
    [dataset, metadata] = load_data(fullfile(dataDir, dataFileList{n}));

    dat(n).subject = subjectList{n};
    dat(n).dataSet = dataset;
    dat(n).metaData = metadata;
end

%% Load image features
fprintf('Loading image feature data...\n');

[feat.dataSet, feat.metaData] = load_data(fullfile(dataDir, imageFeatureFile));

%%----------------------------------------------------------------------
%% Create analysis parameter matrix (analysisParam)
%%----------------------------------------------------------------------
%%三重循环的作用是生成所有可能的subject、ROI和特征的组合方案，并将它们的索引保存到数组analysisParam中
analysisParam = uint16(zeros(length(subjectList) * length(roiList) * length(featureList), 3));

c = 1;
for iSbj = 1:length(subjectList)
for iRoi = 1:length(roiList)
for iFeat = 1:length(featureList)
    analysisParam(c, :) = [iSbj, iRoi, iFeat];
    c =  c + 1;
end
end
end

if c < size(analysisParam, 1)
    analysisParam(c:end, :) = [];
end

%%----------------------------------------------------------------------
%% Analysis loop
%%----------------------------------------------------------------------
%%size(analysisParam, 1)：获取数组analysisParam的行数。对于analysisParam中的每一行，执行以下操作。


for n = 1:size(analysisParam, 1)

    %% Initialization --------------------------------------------------

    % Get data index in the current analysis
    iSbj = analysisParam(n, 1);
    iRoi = analysisParam(n, 2);
    iFeat = analysisParam(n, 3);

    % Set analysis ID and a result file name
    analysisId = sprintf('%s-%s-%s-%s', ...
                         mfilename, ...
                         subjectList{iSbj}, ...
                         roiList{iRoi}, ...
                         featureList{iFeat});
    resultFile = resultFileNameFormat(subjectList{iSbj}, ...
                                      roiList{iRoi}, ...
                                      featureList{iFeat});

    % Check or double-running
    if checkfiles(resultFile)
        % Analysis result already exists
        fprintf('Analysis %s is already done and skipped\n', analysisId);
        continue;
    end

    if islocked(analysisId, lockDir)
        % Analysis is already running
        fprintf('Analysis %s is already running and skipped\n', analysisId);
        continue;
    end

    fprintf('Start %s\n', analysisId);
    lockcomput(analysisId, lockDir);%%这段代码的作用是开始运行当前分析任务，并将任务锁定，防止其他程序同时运行相同的任务。将锁定信息保存到文件中，可以保证同一时间只有一个程序可以运行相同的任务。

    %% Load data -------------------------------------------------------

    %% Get brain data
    voxSelector = sprintf('ROI_%s = 1', roiList{iRoi});
    nVox = numVoxelList{iRoi};
    
    %%select_data函数会根据输入的数据集和元数据，以及选择脑区的字符串，返回选择的脑区数据。例如，如果需要选择的脑区是v1，那么返回的数据将只包含脑区v1的数据，即nVox_v1 x nTimepoints的矩阵。
    brainData = select_data(dat(iSbj).dataSet, dat(iSbj).metaData, voxSelector);

    dataType = get_dataset(dat(iSbj).dataSet, dat(iSbj).metaData, 'DataType');%%类型：1训练2测试
    labels = get_dataset(dat(iSbj).dataSet, dat(iSbj).metaData, 'Label');%%标签 3列4469 4470 4471
    labels = labels(:,1);  %%得到第一列数据，即4469列数据

    % dataType
    % --------
    %
    % - 1: Training data
    % - 2: Test data (percept)
    % - 3: Test data (imagery)
    %

    % Get brain data for training and test
    indTrain = dataType == 1;       % Index of training data使用相等运算符将dataType中值为1的位置赋值为1，其余位置赋值为0，得到一个与dataType等长的逻辑向量，表示训练数据的索引。


    indTestPercept = dataType == 2; % Index of percept test data
    indTestimagery = dataType == 3; % index of imagery test data

    trainData = brainData(indTrain, :);
    testPerceptData = brainData(indTestPercept, :);
    testImageryData = brainData(indTestimagery, :);

    trainLabels = labels(indTrain, :);
    testPerceptLabels = labels(indTestPercept, :);
    testimageryLabels = labels(indTestimagery, :);

    %% Get image features
    layerFeat = select_data(feat.dataSet, feat.metaData, ...
                            sprintf('%s = 1', featureList{iFeat}));
    featType = get_dataset(feat.dataSet, feat.metaData, 'FeatureType');
    imageIds = get_dataset(feat.dataSet, feat.metaData, 'ImageID');

    % featType
    % --------
    %
    % - 1 = training
    % - 2 = test
    % - 3 = category test
    % - 4 = category others
    %

    % Get image features for training and test
    trainFeat = layerFeat(featType == 1, :);
    trainImageIds = imageIds(featType == 1, :);

    trainFeat = get_refdata(trainFeat, trainImageIds, trainLabels);%使用get_refdata函数根据trainImageIds和trainLabels的值，从trainFeat中提取出训练数据，并将它们存储在trainFeat中。

    %% Preprocessing ---------------------------------------------------

    %% Normalize brain data
    [trainData, xMean, xNorm] = zscore(trainData);%使用zscore函数对训练数据trainData进行标准化处理，使其满足均值为0、标准差为1的正态分布，并将其存储在trainData中。同时，将标准化所需的均值和标准差分别存储在xMean和xNorm中。

    testPerceptData = bsxfun(@rdivide, bsxfun(@minus, testPerceptData, xMean), xNorm);%使用bsxfun函数对测试感性数据testPerceptData进行归一化处理，具体包括：先将testPerceptData中的每个元素减去xMean，然后将得到的结果除以xNorm。最后将处理后的结果存储在testPerceptData中。
    testImageryData = bsxfun(@rdivide, bsxfun(@minus, testImageryData, xMean), xNorm);%testImageryData = bsxfun(@rdivide, bsxfun(@minus, testImageryData, xMean), xNorm)；同样使用bsxfun函数对测试想象数据testImageryData进行归一化处理，具体也是先将其每个元素减去xMean，然后将得到的结果除以xNorm。最后将处理后的结果存储在testImageryData中。

    %% Normalize image features
    [trainFeat, yMean, yNorm] = zscore(trainFeat);%使用zscore函数对训练特征trainFeat进行标准化处理，使其满足均值为0、标准差为1的正态分布，并将其存储在trainFeat中。同时，将标准化所需的均值和标准差分别存储在yMean和yNorm中。

    %% Feature prediction ----------------------------------------------

    predictPercept = [];  % Predicted labels for perception test
    predictImagery = [];  % Predicted labels for imagery test

    numUnits = size(trainFeat, 2);%使用size函数获取trainFeat的数据尺寸，具体包括样本数和特征数。由于需要获取的是特征数，因此选取size函数的第二个输出参数（即列数），将其存储在numUnits中。
    %numUnits = 100;  % For quick test

    for i = 1:numUnits
        fprintf('Unit %d\n', i);

        %% Get features in the current unit
        yTrain = trainFeat(:, i);

        %% Voxel selection based on correlation
        cor = fastcorr(trainData, yTrain);%使用fastcorr函数计算trainData和yTrain之间的相关系数矩阵cor，即每个训练数据和当前特征向量之间的相关性
        [xTrain, selInd] = select_top(trainData, abs(cor), nVox);%使用select_top函数从trainData中选取与yTrain具有最强相关性的nVox个特征向量。其中，abs(cor)表示使用相关系数矩阵的绝对值，以确保选择的特征具有正相关或负相关，而不会出现不相关的特征。selInd表示被选取的特征在trainData中的列索引，xTrain为所选取的特征向量集合。
        xTestPercept = testPerceptData(:, selInd);%将测试数据集中与trainData中选取的特征向量相对应的特征向量提取出来，并存储在xTestPercept和xTestImagery中，用于后续的分类器模型的构建和测试。
        xTestImagery = testImageryData(:, selInd);

        %% Add bias terms and transpose matrixes for SLR functions
        xTrain = add_bias(xTrain)';%使用add_bias函数将xTrain矩阵的最后一列设置为全1向量，并使用'转置运算符将结果进行转置，即将xTrain转换为nVox+1行样本数列的矩阵，其中nVox表示所选取特征数目。
        xTestPercept = add_bias(xTestPercept)';
        xTestImagery = add_bias(xTestImagery)';

        yTrain = yTrain';%使用'转置运算符将yTrain向量转换为1行样本数列的矩阵，以匹配经典的单变量线性回归（SLR）模型对标签向量的要求

        %% Image feature decoding --------------------------------------

        %% Model parameters
        param.Ntrain = nTrain;
        param.Nskip  = nSkip;
        param.data_norm = 1;
        param.num_comp = nVox;

        param.xmean = xMean;
        param.xnorm = xNorm;
        param.ymean = yMean(i);
        param.ynorm = yNorm(i);

        %% Model training
        model = linear_map_sparse_cov(xTrain, yTrain, [], param);%使用linear_map_sparse_cov函数基于训练数据xTrain和标签yTrain构建一个线性回归模型，该函数的输入参数包括训练数据xTrain、标签yTrain、稀疏正则化参数、以及线性回归模型的参数param。其中第三个参数[]表示没有稀疏正则化项。
        %%最终返回的结果为一个线性回归模型model，包含权重向量w和偏置项b，它们是通过最小二乘法在训练数据集上拟合得到的。

        %% Image feature prediction
        yPredPercept = predict_output(xTestPercept, model, param)';
        yPredImagery = predict_output(xTestImagery, model, param)';

        predictPercept = [predictPercept, yPredPercept];%将yPredPercept添加到predictPercept数组中，以便后续进行结果可视化和分析
        predictImagery = [predictImagery, yPredImagery];
    end

    %% Average prediction results for each category
    categoryTestPercept = unique(floor(testPerceptLabels));%获取测试数据集的感知类别标签，并使用unique函数将其转换为唯一的整数值categoryTestPercept，以便后续的分类和分析
    categoryTestImagery = unique(floor(testimageryLabels));

    predictPerceptAveraged = [];%初始化predictPerceptAveraged数组为空，以便后续存储不同类别的预测输出结果
    predictImageryAveraged = [];
    for j = 1:length(categoryTestPercept)
        categ = categoryTestPercept(j);
        predictPerceptAveraged(j, :) = mean(predictPercept(floor(testPerceptLabels) == categ, :));%根据当前循环的类别标签，从predictPercept数组中获取对应类别的所有预测输出值，并使用mean函数计算它们的平均值。最终将平均值存储在predictPerceptAveraged数组中相应位置。
    end
    for j = 1:length(categoryTestImagery)
        categ = categoryTestImagery(j);
        predictImageryAveraged(j, :) = mean(predictImagery(floor(testimageryLabels) == categ, :));
    end

    %% Save data -------------------------------------------------------
    [rDir, rFileBase, rExt] = fileparts(resultFile);%使用fileparts函数获取resultFile的路径（rDir）、文件名（rFileBase）和扩展名（rExt），并将它们存储在对应的变量中。
    setupdir(rDir);%使用setupdir函数设置当前工作目录为rDir，即结果文件所在的目录。

    save(resultFile, ...
         'predictPercept', 'predictImagery', ...
         'predictPerceptAveraged', 'predictImageryAveraged', ...
         'categoryTestPercept', 'categoryTestImagery', ...
         '-v7.3');

    %% Remove lock file ------------------------------------------------
    unlockcomput(analysisId, lockDir);

end

fprintf('%s done\n', mfilename);
