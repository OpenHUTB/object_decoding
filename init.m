
clear;

%% 配置信息
% 运行之前需要修改的路径
utils_dir = fullfile(matlabroot, 'software', 'matlab_utils'); % spr_1_0 和 BrainDecoderToolbox2-0.9.17 所在的目录
workDir = 'D:\data\neuro\object_decoding';  % 原始数据、中间文件、结果文件 所在的目录

%% 目录设置
if ~exist(workDir, 'dir')
    workDir = pwd;
end
dataDir = workDir;       % 包含大脑和图像特征数据的目录
resultsDir = fullfile(workDir, 'results'); % 保存分析结果的目录
lockDir = fullfile(workDir, 'tmp');        % 保存文件锁（正在分析的过程）的目录
