% mrTrix 500,000 vs AFQ_run wholeBrainFG

%%
FG = fullfile('/biac4/wandell/biac2/wandell/data/DWI-Tamagawa-Japan/JMD1-MM-20121025-DWI/dwi_2nd/fibers/life_mrtrix',...
   'dwi2nd_aligned_trilin_csd_lmax2_dwi2nd_aligned_trilin_brainmask_dwi2nd_aligned_trilin_wm_prob-500000.mat');
wholeFG = fgRead(FG);

dt6File = '/biac4/wandell/biac2/wandell/data/DWI-Tamagawa-Japan/JMD1-MM-20121025-DWI/dwi_2nd/dt6.mat';

Atlas='MNI_JHU_tracts_prob.nii.gz';

%%
[fg_classified,fg_unclassified,classification,fg] = ...
    AFQ_SegmentFiberGroups(dt6File, wholeFG, Atlas, ...
    0, 1);

%%
FG2 = '/biac4/wandell/biac2/wandell/data/DWI-Tamagawa-Japan/JMD1-MM-20121025-DWI/dwi_2nd/WholeBrainFG.mat';
wholeFG = fgRead(FG2);

[fg_classified_2,fg_unclassified_2,classification_2,fg_2] = ...
    AFQ_SegmentFiberGroups(dt6File, wholeFG, Atlas, ...
    0, 1);