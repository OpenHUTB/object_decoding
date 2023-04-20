# Generic Object Decoding
利用 fMRI 激活来预测类别模式。

This repository contains the data and demo codes for replicating results in our paper: [Horikawa and Kamitani (2017) Generic decoding of seen and imagined objects using hierarchical visual features. Nature Communications 8:15037](https://www.nature.com/articles/ncomms15037).
The generic object decoding approach enabled decoding of arbitrary object categories including those not used in model training.

## 数据 (fMRI 数据和视觉特征)

The preprocessed fMRI data for five subjects (training, test_perception, and test_imagery) and visual features (CNN1-8, HMAX1-3, GIST, and SIFT) are available at [figshare](https://figshare.com/articles/Generic_Object_Decoding/7387130).
The fMRI data were saved as the [BrainDecoderToolbox2](https://github.com/KamitaniLab/BrainDecoderToolbox2)/[bdpy](https://github.com/KamitaniLab/bdpy) format.

The unpreprocessed fMRI data is available at [OpenNeuro](https://openneuro.org/datasets/ds001246).

## 视觉图片

For copyright reasons, we do not make the visual images used in our experiments publicly available.
You can request us to share the stimulus images at <https://forms.gle/ujvA34948Xg49jdn9>.

Stimulus images used for higher visual area locazlier experiments in this study are available via <https://forms.gle/c6HGatLrt7JtTGQk7>.

## 示例程序

Demo programs for Matlab and Python are available in [code/matlab](code/matlab/) and [code/python](code/python), respectively.
See README.md in each directory for the details.



# Generic Decoding Demo/Matlab

This is MATLAB code for Generic Decoding Demo.

## 要求

- [BrainDecoderToolbox2](https://github.com/KamitaniLab/BrainDecoderToolbox2)
下载后放置在 `matlab\software\matlab_utils\BrainDecoderToolbox2-0.9.17` 目录中

- [SPR](https://bicr.atr.jp//cbi/sparse_estimation/sato/VBSR.html)
安装 1.0 版本的 SPR（位于matlab\software\matlab_utils\SPR_2011_1111），代码和.c文件放在同一目录下，并用mex_compile进行重新编译。
注意：高版本需要在 `mex_compile.m` 中添加兼容性数组维度，否则出现“请求的数组超过预设的最大数组大小”错误。
```matlab
mex -v weight_out_delay_time.c '-compatibleArrayDims'
```

## 数据组织

相关数据和依赖软件的[百度网盘链接](https://pan.baidu.com/s/1aKY7aP0ggQasj9ky9xiwZA) ，提取码：dong

All data should be placed in `matlab/data`.
Data can be obrained from [figshare](https://figshare.com/articles/Generic_Object_Decoding/7387130).
The data directory should have the following files:

    data/ --+-- Subject1.mat (fMRI data, subject 1)
            |
            +-- Subject2.mat (fMRI data, subject 2)
            |
            +-- Subject3.mat (fMRI data, subject 3)
            |
            +-- Subject4.mat (fMRI data, subject 4)
            |
            +-- Subject5.mat (fMRI data, subject 5)
            |
            +-- ImageFeatures.mat (image features extracted with Matconvnet)

Download links:

- [Subject1.mat](https://ndownloader.figshare.com/files/13663487)
- [Subject2.mat](https://ndownloader.figshare.com/files/13663490)
- [Subject3.mat](https://ndownloader.figshare.com/files/13663493)
- [Subject4.mat](https://ndownloader.figshare.com/files/13663496)
- [Subject5.mat](https://ndownloader.figshare.com/files/13663499)
- [ImageFeatures.mat](https://ndownloader.figshare.com/files/15015977)

## 分析

在Matlab中运行下列脚本。

```matlab
analysis_FeaturePrediction  # （10个CPU运行2天以上）
analysis_FeaturePredictionAccuracy
analysis_CategoryIdentification
createfigure  # 绘制 特征解码/类别识别 精度图
convert_decodedfeatures # 为深度图像重建 转换 特征预测结果
```

所有的结果会保存在 `results` 目录中。

To visualize the results, run the following script.

```
>> createfigure
```

`createfigure.m` will create two figures: one shows the results of image feature and category-averaged feature prediction, and the other displays the results of category identification. The figures will be saved in `results` directory in PDF format (`FeaturePredictionAccuracy.pdf` and `IdentificationAccuracy.pdf`).


# 参考
[代码](https://github.com/KamitaniLab/GenericObjectDecoding) 