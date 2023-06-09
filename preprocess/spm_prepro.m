
ID={'01', '02', '03', '04'};

for i=1:5
    if ~exist(['D:/program_data/sub01_test/OpenNEURO_data/1st_level/sub-' ID{i}])
        mkdir(['D:/program_data/sub01_test/OpenNEURO_data/1st_level/sub-' ID{i}])
    end
    matlabbatch = preproc(ID{i});
    spm_jobman('run', matlabbatch)
end





function matlabbatch = preproc(ID)
    prefix = ['D:/program_data/sub01_test/OpenNEURO_data/sub-' ID '/func/sub-' ID '_task-affect_'];
    outputdir = ['D:/program_data/sub01_test/OpenNEURO_data/1st_level/sub-' ID];
    run01=[prefix 'run-1_bold.nii'];
    run02=[prefix 'run-2_bold.nii'];
    run03=[prefix 'run-3_bold.nii'];
    anat =['D:/program_data/sub01_test/OpenNEURO_data/sub-' ID '/anat/sub-' ID '_T1w.nii'];
    json01=[prefix 'run-1_bold.json'];


    tsv01=[prefix 'run-1_events.tsv'];
    tsv02=[prefix 'run-2_events.tsv'];
    tsv03=[prefix 'run-3_events.tsv'];

   
   % { 
    rp01=['D:/program_data/sub01_test/OpenNEURO_data/sub-' ID '/rp_asub-' ID '_func_sub-' ID '_task-affect_run-1_bold.txt'];
    rp02=['D:/program_data/sub01_test/OpenNEURO_data/sub-' ID '/rp_asub-' ID '_func_sub-' ID '_task-affect_run-2_bold.txt'];
    rp03=['D:/program_data/sub01_test/OpenNEURO_data/sub-' ID '/rp_asub-' ID '_func_sub-' ID '_task-affect_run-3_bold.txt'];
    %}


    matlabbatch{1}.cfg_basicio.file_dir.file_ops.cfg_named_file.name = 'raw';
    matlabbatch{1}.cfg_basicio.file_dir.file_ops.cfg_named_file.files = {
                                                                         {run01}
                                                                         {run02}
                                                                         {run03}
                                                                         {anat}
                                                                         }';
    matlabbatch{2}.spm.temporal.st.scans{1}(1) = cfg_dep('Named File Selector: raw(1) - Files', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files', '{}',{1}));
    matlabbatch{2}.spm.temporal.st.scans{2}(1) = cfg_dep('Named File Selector: raw(2) - Files', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files', '{}',{2}));
    matlabbatch{2}.spm.temporal.st.scans{3}(1) = cfg_dep('Named File Selector: raw(3) - Files', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files', '{}',{3}));
    matlabbatch{2}.spm.temporal.st.nslices = 40;
    matlabbatch{2}.spm.temporal.st.tr = 1;
    matlabbatch{2}.spm.temporal.st.ta = 0;
    % read slice timing from json file of first run
    json = jsondecode(fileread(json01));
    %matlabbatch{2}.spm.temporal.st.so = [0 0.685 0.3925 0.0975 0.785 0.49 0.1975 0.8825 0.5875 0.295 0 0.685 0.3925 0.0975 0.785 0.49 0.1975 0.8825 0.5875 0.295 0 0.685 0.3925 0.0975 0.785 0.49 0.1975 0.8825 0.5875 0.295 0 0.685 0.3925 0.0975 0.785 0.49 0.1975 0.8825 0.5875 0.295];
    matlabbatch{2}.spm.temporal.st.so=json.SliceTiming';
    matlabbatch{2}.spm.temporal.st.refslice = 1;
    matlabbatch{2}.spm.temporal.st.prefix = 'a';
    matlabbatch{3}.spm.spatial.realign.estwrite.data{1}(1) = cfg_dep('Slice Timing: Slice Timing Corr. Images (Sess 1)', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('()',{1}, '.','files'));
    matlabbatch{3}.spm.spatial.realign.estwrite.data{2}(1) = cfg_dep('Slice Timing: Slice Timing Corr. Images (Sess 2)', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('()',{2}, '.','files'));
    matlabbatch{3}.spm.spatial.realign.estwrite.data{3}(1) = cfg_dep('Slice Timing: Slice Timing Corr. Images (Sess 3)', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('()',{3}, '.','files'));
    matlabbatch{3}.spm.spatial.realign.estwrite.eoptions.quality = 0.9;
    matlabbatch{3}.spm.spatial.realign.estwrite.eoptions.sep = 4;
    matlabbatch{3}.spm.spatial.realign.estwrite.eoptions.fwhm = 5;
    matlabbatch{3}.spm.spatial.realign.estwrite.eoptions.rtm = 1;
    matlabbatch{3}.spm.spatial.realign.estwrite.eoptions.interp = 2;
    matlabbatch{3}.spm.spatial.realign.estwrite.eoptions.wrap = [0 0 0];
    matlabbatch{3}.spm.spatial.realign.estwrite.eoptions.weight = '';
    matlabbatch{3}.spm.spatial.realign.estwrite.roptions.which = [2 1];
    matlabbatch{3}.spm.spatial.realign.estwrite.roptions.interp = 4;
    matlabbatch{3}.spm.spatial.realign.estwrite.roptions.wrap = [0 0 0];
    matlabbatch{3}.spm.spatial.realign.estwrite.roptions.mask = 1;
    matlabbatch{3}.spm.spatial.realign.estwrite.roptions.prefix = 'r';
    matlabbatch{4}.spm.spatial.coreg.estimate.ref(1) = cfg_dep('Named File Selector: raw(4) - Files', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files', '{}',{4}));
    matlabbatch{4}.spm.spatial.coreg.estimate.source(1) = cfg_dep('Realign: Estimate & Reslice: Mean Image', substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','rmean'));
    matlabbatch{4}.spm.spatial.coreg.estimate.other(1) = cfg_dep('Realign: Estimate & Reslice: Resliced Images (Sess 1)', substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','sess', '()',{1}, '.','rfiles'));
    matlabbatch{4}.spm.spatial.coreg.estimate.other(2) = cfg_dep('Realign: Estimate & Reslice: Resliced Images (Sess 2)', substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','sess', '()',{2}, '.','rfiles'));
    matlabbatch{4}.spm.spatial.coreg.estimate.other(3) = cfg_dep('Realign: Estimate & Reslice: Resliced Images (Sess 3)', substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','sess', '()',{3}, '.','rfiles'));
    matlabbatch{4}.spm.spatial.coreg.estimate.eoptions.cost_fun = 'nmi';
    matlabbatch{4}.spm.spatial.coreg.estimate.eoptions.sep = [4 2];
    matlabbatch{4}.spm.spatial.coreg.estimate.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
    matlabbatch{4}.spm.spatial.coreg.estimate.eoptions.fwhm = [7 7];
    matlabbatch{5}.spm.spatial.normalise.estwrite.subj.vol(1) = cfg_dep('Named File Selector: raw(4) - Files', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files', '{}',{4}));
    matlabbatch{5}.spm.spatial.normalise.estwrite.subj.resample(1) = cfg_dep('Realign: Estimate & Reslice: Resliced Images (Sess 1)', substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','sess', '()',{1}, '.','rfiles'));
    matlabbatch{5}.spm.spatial.normalise.estwrite.subj.resample(2) = cfg_dep('Realign: Estimate & Reslice: Resliced Images (Sess 2)', substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','sess', '()',{2}, '.','rfiles'));
    matlabbatch{5}.spm.spatial.normalise.estwrite.subj.resample(3) = cfg_dep('Realign: Estimate & Reslice: Resliced Images (Sess 3)', substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','sess', '()',{3}, '.','rfiles'));
    matlabbatch{5}.spm.spatial.normalise.estwrite.eoptions.biasreg = 0.0001;
    matlabbatch{5}.spm.spatial.normalise.estwrite.eoptions.biasfwhm = 60;
    matlabbatch{5}.spm.spatial.normalise.estwrite.eoptions.tpm = {'D:/Tools/MatLab2022/toolbox/spm12/tpm/TPM.nii'};
    matlabbatch{5}.spm.spatial.normalise.estwrite.eoptions.affreg = 'mni';
    matlabbatch{5}.spm.spatial.normalise.estwrite.eoptions.reg = [0 0.001 0.5 0.05 0.2];
    matlabbatch{5}.spm.spatial.normalise.estwrite.eoptions.fwhm = 0;
    matlabbatch{5}.spm.spatial.normalise.estwrite.eoptions.samp = 3;
    matlabbatch{5}.spm.spatial.normalise.estwrite.woptions.bb = [-78 -112 -70
                                                                 78 76 85];
    matlabbatch{5}.spm.spatial.normalise.estwrite.woptions.vox = [2 2 2];
    matlabbatch{5}.spm.spatial.normalise.estwrite.woptions.interp = 4;
    matlabbatch{5}.spm.spatial.normalise.estwrite.woptions.prefix = 'w';
    matlabbatch{6}.spm.spatial.smooth.data(1) = cfg_dep('Normalise: Estimate & Write: Normalised Images (Subj 1)', substruct('.','val', '{}',{5}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('()',{1}, '.','files'));
    matlabbatch{6}.spm.spatial.smooth.fwhm = [8 8 8];
    matlabbatch{6}.spm.spatial.smooth.dtype = 0;
    matlabbatch{6}.spm.spatial.smooth.im = 0;
    matlabbatch{6}.spm.spatial.smooth.prefix = 's';
    matlabbatch{7}.cfg_basicio.file_dir.file_ops.cfg_file_split.name = 'prepro-ed';
    matlabbatch{7}.cfg_basicio.file_dir.file_ops.cfg_file_split.files(1) = cfg_dep('Smooth: Smoothed Images', substruct('.','val', '{}',{6}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files'));
    matlabbatch{7}.cfg_basicio.file_dir.file_ops.cfg_file_split.index = {
                                                                         1
                                                                         2
                                                                         3
                                                                         }';
    %                                                    
    onsets_run1 = tdfread(tsv01);
    matlabbatch{8}.spm.stats.fmri_spec.dir = {outputdir};
    matlabbatch{8}.spm.stats.fmri_spec.timing.units = 'secs';
    matlabbatch{8}.spm.stats.fmri_spec.timing.RT = 1;
    matlabbatch{8}.spm.stats.fmri_spec.timing.fmri_t = 16;
    matlabbatch{8}.spm.stats.fmri_spec.timing.fmri_t0 = 8;
    matlabbatch{8}.spm.stats.fmri_spec.sess(1).scans(1) = cfg_dep('File Set Split: prepro-ed (1)', substruct('.','val', '{}',{7}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('{}',{1}));
    matlabbatch{8}.spm.stats.fmri_spec.sess(1).cond(1).name = 'VpAp';
    %%

    matlabbatch{8}.spm.stats.fmri_spec.sess(1).cond(1).onset = onsets_run1.onset(onsets_run1.trial_type==1);
    %%
    matlabbatch{8}.spm.stats.fmri_spec.sess(1).cond(1).duration = 3;
    matlabbatch{8}.spm.stats.fmri_spec.sess(1).cond(1).tmod = 0;
    matlabbatch{8}.spm.stats.fmri_spec.sess(1).cond(1).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{8}.spm.stats.fmri_spec.sess(1).cond(1).orth = 1;
    matlabbatch{8}.spm.stats.fmri_spec.sess(1).cond(2).name = 'VpAn';
    %%
    matlabbatch{8}.spm.stats.fmri_spec.sess(1).cond(2).onset = onsets_run1.onset(onsets_run1.trial_type==2);
    %%
    matlabbatch{8}.spm.stats.fmri_spec.sess(1).cond(2).duration = 3;
    matlabbatch{8}.spm.stats.fmri_spec.sess(1).cond(2).tmod = 0;
    matlabbatch{8}.spm.stats.fmri_spec.sess(1).cond(2).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{8}.spm.stats.fmri_spec.sess(1).cond(2).orth = 1;
    matlabbatch{8}.spm.stats.fmri_spec.sess(1).cond(3).name = 'VnAp';
    %%
    matlabbatch{8}.spm.stats.fmri_spec.sess(1).cond(3).onset = onsets_run1.onset(onsets_run1.trial_type==3);
    %%
    matlabbatch{8}.spm.stats.fmri_spec.sess(1).cond(3).duration = 3;
    matlabbatch{8}.spm.stats.fmri_spec.sess(1).cond(3).tmod = 0;
    matlabbatch{8}.spm.stats.fmri_spec.sess(1).cond(3).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{8}.spm.stats.fmri_spec.sess(1).cond(3).orth = 1;
    matlabbatch{8}.spm.stats.fmri_spec.sess(1).cond(4).name = 'VnAn';
    %%
    matlabbatch{8}.spm.stats.fmri_spec.sess(1).cond(4).onset = onsets_run1.onset(onsets_run1.trial_type==4);
    %%
    matlabbatch{8}.spm.stats.fmri_spec.sess(1).cond(4).duration = 3;
    matlabbatch{8}.spm.stats.fmri_spec.sess(1).cond(4).tmod = 0;
    matlabbatch{8}.spm.stats.fmri_spec.sess(1).cond(4).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{8}.spm.stats.fmri_spec.sess(1).cond(4).orth = 1;
    matlabbatch{8}.spm.stats.fmri_spec.sess(1).cond(5).name = 'catch';
    matlabbatch{8}.spm.stats.fmri_spec.sess(1).cond(5).onset = onsets_run1.onset(onsets_run1.trial_type==5);
    matlabbatch{8}.spm.stats.fmri_spec.sess(1).cond(5).duration = 3;
    matlabbatch{8}.spm.stats.fmri_spec.sess(1).cond(5).tmod = 0;
    matlabbatch{8}.spm.stats.fmri_spec.sess(1).cond(5).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{8}.spm.stats.fmri_spec.sess(1).cond(5).orth = 1;
    matlabbatch{8}.spm.stats.fmri_spec.sess(1).multi = {''};
    matlabbatch{8}.spm.stats.fmri_spec.sess(1).regress = struct('name', {}, 'val', {});
    matlabbatch{8}.spm.stats.fmri_spec.sess(1).multi_reg = {rp01};
    matlabbatch{8}.spm.stats.fmri_spec.sess(1).hpf = 128;
    matlabbatch{8}.spm.stats.fmri_spec.sess(2).scans(1) = cfg_dep('File Set Split: prepro-ed (2)', substruct('.','val', '{}',{7}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('{}',{2}));
    matlabbatch{8}.spm.stats.fmri_spec.sess(2).cond(1).name = 'VpAp';
    onsets_run2 = tdfread(tsv02);
    %%
    matlabbatch{8}.spm.stats.fmri_spec.sess(2).cond(1).onset = onsets_run2.onset(onsets_run2.trial_type==1);
    %%
    matlabbatch{8}.spm.stats.fmri_spec.sess(2).cond(1).duration = 3;
    matlabbatch{8}.spm.stats.fmri_spec.sess(2).cond(1).tmod = 0;
    matlabbatch{8}.spm.stats.fmri_spec.sess(2).cond(1).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{8}.spm.stats.fmri_spec.sess(2).cond(1).orth = 1;
    matlabbatch{8}.spm.stats.fmri_spec.sess(2).cond(2).name = 'VpAn';
    %%
    matlabbatch{8}.spm.stats.fmri_spec.sess(2).cond(2).onset = onsets_run2.onset(onsets_run2.trial_type==2);
    %%
    matlabbatch{8}.spm.stats.fmri_spec.sess(2).cond(2).duration = 3;
    matlabbatch{8}.spm.stats.fmri_spec.sess(2).cond(2).tmod = 0;
    matlabbatch{8}.spm.stats.fmri_spec.sess(2).cond(2).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{8}.spm.stats.fmri_spec.sess(2).cond(2).orth = 1;
    matlabbatch{8}.spm.stats.fmri_spec.sess(2).cond(3).name = 'VnAp';
    %%
    matlabbatch{8}.spm.stats.fmri_spec.sess(2).cond(3).onset = onsets_run2.onset(onsets_run2.trial_type==3);
    %%
    matlabbatch{8}.spm.stats.fmri_spec.sess(2).cond(3).duration = 3;
    matlabbatch{8}.spm.stats.fmri_spec.sess(2).cond(3).tmod = 0;
    matlabbatch{8}.spm.stats.fmri_spec.sess(2).cond(3).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{8}.spm.stats.fmri_spec.sess(2).cond(3).orth = 1;
    matlabbatch{8}.spm.stats.fmri_spec.sess(2).cond(4).name = 'VnAn';
    %%
    matlabbatch{8}.spm.stats.fmri_spec.sess(2).cond(4).onset = onsets_run2.onset(onsets_run2.trial_type==4);
    %%
    matlabbatch{8}.spm.stats.fmri_spec.sess(2).cond(4).duration = 3;
    matlabbatch{8}.spm.stats.fmri_spec.sess(2).cond(4).tmod = 0;
    matlabbatch{8}.spm.stats.fmri_spec.sess(2).cond(4).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{8}.spm.stats.fmri_spec.sess(2).cond(4).orth = 1;
    matlabbatch{8}.spm.stats.fmri_spec.sess(2).cond(5).name = 'catch';
    matlabbatch{8}.spm.stats.fmri_spec.sess(2).cond(5).onset = onsets_run2.onset(onsets_run2.trial_type==5);
    matlabbatch{8}.spm.stats.fmri_spec.sess(2).cond(5).duration = 3;
    matlabbatch{8}.spm.stats.fmri_spec.sess(2).cond(5).tmod = 0;
    matlabbatch{8}.spm.stats.fmri_spec.sess(2).cond(5).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{8}.spm.stats.fmri_spec.sess(2).cond(5).orth = 1;
    matlabbatch{8}.spm.stats.fmri_spec.sess(2).multi = {''};
    matlabbatch{8}.spm.stats.fmri_spec.sess(2).regress = struct('name', {}, 'val', {});
    matlabbatch{8}.spm.stats.fmri_spec.sess(2).multi_reg = {rp02};
    matlabbatch{8}.spm.stats.fmri_spec.sess(2).hpf = 128;
    matlabbatch{8}.spm.stats.fmri_spec.sess(3).scans(1) = cfg_dep('File Set Split: prepro-ed (3)', substruct('.','val', '{}',{7}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('{}',{3}));
    matlabbatch{8}.spm.stats.fmri_spec.sess(3).cond(1).name = 'VpAp';
    onsets_run3 = tdfread(tsv03);
    %%
    matlabbatch{8}.spm.stats.fmri_spec.sess(3).cond(1).onset = onsets_run3.onset(onsets_run3.trial_type==1);
    %%
    matlabbatch{8}.spm.stats.fmri_spec.sess(3).cond(1).duration = 3;
    matlabbatch{8}.spm.stats.fmri_spec.sess(3).cond(1).tmod = 0;
    matlabbatch{8}.spm.stats.fmri_spec.sess(3).cond(1).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{8}.spm.stats.fmri_spec.sess(3).cond(1).orth = 1;
    matlabbatch{8}.spm.stats.fmri_spec.sess(3).cond(2).name = 'VpAn';
    %%
    matlabbatch{8}.spm.stats.fmri_spec.sess(3).cond(2).onset = onsets_run3.onset(onsets_run3.trial_type==2);
    %%
    matlabbatch{8}.spm.stats.fmri_spec.sess(3).cond(2).duration = 3;
    matlabbatch{8}.spm.stats.fmri_spec.sess(3).cond(2).tmod = 0;
    matlabbatch{8}.spm.stats.fmri_spec.sess(3).cond(2).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{8}.spm.stats.fmri_spec.sess(3).cond(2).orth = 1;
    matlabbatch{8}.spm.stats.fmri_spec.sess(3).cond(3).name = 'VnAp';
    %%
    matlabbatch{8}.spm.stats.fmri_spec.sess(3).cond(3).onset = onsets_run3.onset(onsets_run3.trial_type==3);
    %%
    matlabbatch{8}.spm.stats.fmri_spec.sess(3).cond(3).duration = 3;
    matlabbatch{8}.spm.stats.fmri_spec.sess(3).cond(3).tmod = 0;
    matlabbatch{8}.spm.stats.fmri_spec.sess(3).cond(3).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{8}.spm.stats.fmri_spec.sess(3).cond(3).orth = 1;
    matlabbatch{8}.spm.stats.fmri_spec.sess(3).cond(4).name = 'VnAn';
    %%
    matlabbatch{8}.spm.stats.fmri_spec.sess(3).cond(4).onset = onsets_run3.onset(onsets_run3.trial_type==4);
    %%
    matlabbatch{8}.spm.stats.fmri_spec.sess(3).cond(4).duration = 3;
    matlabbatch{8}.spm.stats.fmri_spec.sess(3).cond(4).tmod = 0;
    matlabbatch{8}.spm.stats.fmri_spec.sess(3).cond(4).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{8}.spm.stats.fmri_spec.sess(3).cond(4).orth = 1;
    matlabbatch{8}.spm.stats.fmri_spec.sess(3).cond(5).name = 'catch';
    matlabbatch{8}.spm.stats.fmri_spec.sess(3).cond(5).onset = onsets_run3.onset(onsets_run3.trial_type==5);
    matlabbatch{8}.spm.stats.fmri_spec.sess(3).cond(5).duration = 3;
    matlabbatch{8}.spm.stats.fmri_spec.sess(3).cond(5).tmod = 0;
    matlabbatch{8}.spm.stats.fmri_spec.sess(3).cond(5).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{8}.spm.stats.fmri_spec.sess(3).cond(5).orth = 1;
    matlabbatch{8}.spm.stats.fmri_spec.sess(3).multi = {''};
    matlabbatch{8}.spm.stats.fmri_spec.sess(3).regress = struct('name', {}, 'val', {});
    matlabbatch{8}.spm.stats.fmri_spec.sess(3).multi_reg = {rp03};
    matlabbatch{8}.spm.stats.fmri_spec.sess(3).hpf = 128;
    matlabbatch{8}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
    matlabbatch{8}.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];
    matlabbatch{8}.spm.stats.fmri_spec.volt = 1;
    matlabbatch{8}.spm.stats.fmri_spec.global = 'None';
    matlabbatch{8}.spm.stats.fmri_spec.mthresh = 0.8;
    matlabbatch{8}.spm.stats.fmri_spec.mask = {''};
    matlabbatch{8}.spm.stats.fmri_spec.cvi = 'AR(1)';
    matlabbatch{9}.spm.stats.fmri_est.spmmat(1) = cfg_dep('fMRI model specification: SPM.mat File', substruct('.','val', '{}',{8}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
    matlabbatch{9}.spm.stats.fmri_est.write_residuals = 0;
    matlabbatch{9}.spm.stats.fmri_est.method.Classical = 1;
    matlabbatch{10}.spm.stats.con.spmmat(1) = cfg_dep('Model estimation: SPM.mat File', substruct('.','val', '{}',{9}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
    matlabbatch{10}.spm.stats.con.consess{1}.tcon.name = 'pos-neg';
    matlabbatch{10}.spm.stats.con.consess{1}.tcon.weights = [1 0 0 -1 0];
    matlabbatch{10}.spm.stats.con.consess{1}.tcon.sessrep = 'replsc';
    matlabbatch{10}.spm.stats.con.consess{2}.tcon.name = 'pos-rest';
    matlabbatch{10}.spm.stats.con.consess{2}.tcon.weights = 1;
    matlabbatch{10}.spm.stats.con.consess{2}.tcon.sessrep = 'replsc';
    matlabbatch{10}.spm.stats.con.consess{3}.tcon.name = 'neg-rest';
    matlabbatch{10}.spm.stats.con.consess{3}.tcon.weights = [0 0 0 1];
    matlabbatch{10}.spm.stats.con.consess{3}.tcon.sessrep = 'replsc';
    matlabbatch{10}.spm.stats.con.consess{4}.tcon.name = 'con-incon';
    matlabbatch{10}.spm.stats.con.consess{4}.tcon.weights = [1 -1 -1 1 ];
    matlabbatch{10}.spm.stats.con.consess{4}.tcon.sessrep = 'replsc';
    matlabbatch{10}.spm.stats.con.consess{5}.tcon.name = 'con-rest';
    matlabbatch{10}.spm.stats.con.consess{5}.tcon.weights = [1 0 0 1 ];
    matlabbatch{10}.spm.stats.con.consess{5}.tcon.sessrep = 'replsc';
    matlabbatch{10}.spm.stats.con.consess{6}.tcon.name = 'incon-rest';
    matlabbatch{10}.spm.stats.con.consess{6}.tcon.weights = [0 1 1 0 ];
    matlabbatch{10}.spm.stats.con.consess{6}.tcon.sessrep = 'replsc';    
    matlabbatch{10}.spm.stats.con.delete = 0;
end