spm_prepro.m  批处理fmri数据。使用数据地址：https://openneuro.org/datasets/ds003507/versions/1.0.1，测试所用数据为sub01的数据。

roi_RH_V3v.m  利用掩膜文件提取感兴趣区域的体素。所用数据为object_decoding论文的掩膜文件，主要利用spm的Image Calculator工具

alexnet_identify.m   利用alexnet实现目标分类。

alexnet_rsa.m  基于alexnet输出conv1层特征向量和fc6层特征向量，做表征相似性分析。所测试数据为object_decoding论文images/training中的13张图片

RSA.pdf  alexnet_rsa.m所做的表征相似性分析结果，分别为conv1层和fc层。


