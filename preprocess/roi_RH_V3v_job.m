%-----------------------------------------------------------------------
% Job saved on 30-May-2023 15:39:27 by cfg_util (rev $Rev: 7345 $)
% spm SPM - SPM12 (7771)
% cfg_basicio BasicIO - Unknown
%-----------------------------------------------------------------------
matlabbatch{1}.spm.util.imcalc.input = {
                                        'D:\program_data\sub01_test\roitest\derivatives_preproc-spm_output_sub-01_ses-imageryTest01_func_sub-01_ses-imageryTest01_task-imagery_run-01_bold_preproc.nii,1'
                                        'D:\program_data\sub01_test\roitest\sourcedata_sub-01_anat_sub-01_mask_RH_V3v.nii,1'
                                        };
matlabbatch{1}.spm.util.imcalc.output = 'output612342';
matlabbatch{1}.spm.util.imcalc.outdir = {'D:\program_data\sub01_test\roitest'};
matlabbatch{1}.spm.util.imcalc.expression = 'i1.*(i2>0)';
matlabbatch{1}.spm.util.imcalc.var = struct('name', {}, 'value', {});
matlabbatch{1}.spm.util.imcalc.options.dmtx = 0;
matlabbatch{1}.spm.util.imcalc.options.mask = 0;
matlabbatch{1}.spm.util.imcalc.options.interp = 1;
matlabbatch{1}.spm.util.imcalc.options.dtype = 4;
