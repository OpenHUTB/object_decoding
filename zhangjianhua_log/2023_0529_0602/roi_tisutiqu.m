


% 假设 mask 的文件名为 "mask.nii"
mask_filename = 'D:/program_data/sub01_test/roitest/output1543.nii';

% 使用 SPM 打开 mask 文件，并获取其头信息
mask_vol = spm_vol(mask_filename);
mask_data = spm_read_vols(mask_vol);

% 获取 mask 中的所有体素值，并存储到列表中
list_of_voxels = mask_data(mask_data > 0);

% 现在，list_of_voxels 包含了 mask 中所有非零的体素值