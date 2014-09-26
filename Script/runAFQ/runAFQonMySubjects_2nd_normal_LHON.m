%% set directories

AFQdata = '/biac4/wandell/biac2/wandell/data/DWI-Tamagawa-Japan';

subs = {...
    'LHON1-TK-20121130-DWI'...
    'LHON2-SO-20121130-DWI'...
    'LHON3-TO-20121130-DWI'...
    'LHON4-GK-20121130-DWI'...
    'LHON5-HS-20121220-DWI'...
    'LHON6-SS-20121221-DWI'...
    'JMD-Ctl-MT-20121025-DWI'...
    'JMD-Ctl-YM-20121025-DWI'...
    'JMD-Ctl-SY-20130222DWI'...
    'JMD-Ctl-HH-20120907DWI'...
    'JMD-Ctl-HT-20120907-DWI'...
    'JMD-Ctl-FN-20130621-DWI'...
    };

% Make directory structure for each subject
for ii = 1:length(subs)
    sub_dirs{ii} = fullfile(AFQdata, subs{ii},'dwi_2nd');
end

% Subject grouping is a little bit funny because afq only takes two groups
% but we have 3. For now we will divide it up this way but we can do more
% later
sub_group = [1 1 1 1 1 1 0 0 0 0 0 0];

% Now create and afq structure
afq = AFQ_Create('sub_dirs', sub_dirs, 'sub_group', sub_group, 'clip2rois', 0);
% if you would like to use ants for normalization
afq = AFQ_Create('sub_dirs', sub_dirs, 'sub_group', sub_group, 'clip2rois', 0,'normalization','ants');

% To have afq overwrite the old fibers
afq = AFQ_set(afq,'overwritesegmentation',1);
afq = AFQ_set(afq,'overwritecleaning',1);

afq.params.cutoff=[5 95];
afq.params.outdir = ...
fullfile(AFQdata,'/AFQ_results/6LHON_6Ctl');
afq.params.outname = 'AFQ_6LHON_7Ctl_new.mat';

% Run AFQ on these subjects
afq = AFQ_run(sub_dirs, sub_group, afq);


% For this project we may not care about the other groups AFQ gives but we
% do care about the optic radiations. So lets add the optic radiations to
% the afq structure. Before running this save each subject's fiber tract
% and ROIs in the /fibers and /ROIs directory
%afq = AFQ_AddNewFiberGroup(afq,fgName,roi1Name,roi2Name,cleanFibers,computeVals)

% %% add more fiber groups of opticradiation to afq structure
% 
% % R-optic radiation
% fgName = 'ROR_MD3.pdb';
% roi1Name = 'Rt-LGN.mat';
% roi2Name = 'ctx-rh-pericalcarine.mat';
% 
% afq = AFQ_AddNewFiberGroup(afq, fgName, roi1Name, roi2Name, 0, 1);
% 
% % L-optic radiation
% fgName = 'LOR_MD3.pdb';
% roi1Name = 'Lt-LGN.mat';
% roi2Name = 'ctx-lh-pericalcarine.mat';
% 
% afq = AFQ_AddNewFiberGroup(afq, fgName, roi1Name, roi2Name, 0, 1);
% 
% % MD4
% % R-optic radiation
% fgName = 'ROR_MD4.pdb';
% roi1Name = 'Rt-LGN.mat';
% roi2Name = 'ctx-rh-pericalcarine.mat';
% 
% afq = AFQ_AddNewFiberGroup(afq, fgName, roi1Name, roi2Name, 0, 1);
% 
% % L-optic radiation
% fgName = 'LOR_MD4.pdb';
% roi1Name = 'Lt-LGN.mat'; 
% roi2Name = 'ctx-lh-pericalcarine.mat';
% afq = AFQ_AddNewFiberGroup(afq, fgName, roi1Name, roi2Name, 0, 1);
% 
% %% addsuperfibers of optic radiation
% 
% % R-optic radiation
% fgName = 'ROR_MD3_superFiber_Mean.pdb';
% roi1Name = 'Rt-LGN.mat';
% roi2Name = 'ctx-rh-pericalcarine.mat';
% afq = AFQ_AddNewFiberGroup(afq, fgName, roi1Name, roi2Name, 0, 1);
% 
% 
% % L-optic radiation
% fgName = 'LOR_MD3_superFiber_Mean.pdb';
% roi1Name = 'Lt-LGN.mat';
% roi2Name = 'ctx-lh-pericalcarine.mat';
% 
% afq = AFQ_AddNewFiberGroup(afq, fgName, roi1Name, roi2Name, 0, 1);
% %%
% % R-optic radiation
% fgName = 'ROR_MD4_superFiber_Mean.pdb';
% roi1Name = 'Rt-LGN.mat';
% roi2Name = 'ctx-rh-pericalcarine.mat';
% afq = AFQ_AddNewFiberGroup(afq, fgName, roi1Name, roi2Name, 0, 1);
% 
% 
% % L-optic radiation
% fgName = 'LOR_MD4_superFiber_Mean.pdb';
% roi1Name = 'Lt-LGN.mat';
% roi2Name = 'ctx-lh-pericalcarine.mat';
% 
% afq = AFQ_AddNewFiberGroup(afq, fgName, roi1Name, roi2Name, 0, 1);
% 
% 
% 
% %% add OR V1 3mm
% 
% fgName = 'LOR_V13mm_MD3.pdb';
% 
% roi1Name = 'Lt-LGN.mat';
% roi2Name = 'lh_V1_smooth3mm.mat';
% 
% afq = AFQ_AddNewFiberGroup(afq, fgName, roi1Name, roi2Name, 0, 1);
% 
% fgName = 'LOR_V13mm_MD4.pdb';
% 
% roi1Name = 'Lt-LGN.mat';
% roi2Name = 'lh_V1_smooth3mm.mat';
% 
% afq = AFQ_AddNewFiberGroup(afq, fgName, roi1Name, roi2Name, 0, 1);
% 
% fgName = 'LOR_V13mm_MD5.pdb';
% 
% roi1Name = 'Lt-LGN.mat';
% roi2Name = 'lh_V1_smooth3mm.mat';
% 
% afq = AFQ_AddNewFiberGroup(afq, fgName, roi1Name, roi2Name, 0, 1);
% 
% fgName = 'ROR_V13mm_MD3.pdb';
% 
% roi1Name = 'Rt-LGN.mat';
% roi2Name = 'rh_V1_smooth3mm.mat';
% 
% afq = AFQ_AddNewFiberGroup(afq, fgName, roi1Name, roi2Name, 0, 1);
% 
% fgName = 'ROR_V13mm_MD4.pdb';
% 
% roi1Name = 'Rt-LGN.mat';
% roi2Name = 'rh_V1_smooth3mm.mat';
% 
% afq = AFQ_AddNewFiberGroup(afq, fgName, roi1Name, roi2Name, 0, 1);
% 
% fgName = 'ROR_V13mm_MD5.pdb';
% 
% roi1Name = 'Rt-LGN.mat';
% roi2Name = 'rh_V1_smooth3mm.mat';
% 
% afq = AFQ_AddNewFiberGroup(afq, fgName, roi1Name, roi2Name, 0, 1);
% 
% %% add OR V1 3mm NOT ROI
% 
% fgName = 'fg_LOR_BigNotROI_MD3.pdb';
% 
% roi1Name = 'Lt-LGN.mat';
% roi2Name = 'lh_V1_smooth3mm.mat';
% 
% afq = AFQ_AddNewFiberGroup(afq, fgName, roi1Name, roi2Name, 0, 1);
% 
% fgName = 'fg_LOR_BigNotROI_MD4.pdb';
% 
% roi1Name = 'Lt-LGN.mat';
% roi2Name = 'lh_V1_smooth3mm.mat';
% 
% afq = AFQ_AddNewFiberGroup(afq, fgName, roi1Name, roi2Name, 0, 1);
% 
% fgName = 'fg_LOR_BigNotROI_MD5.pdb';
% 
% roi1Name = 'Lt-LGN.mat';
% roi2Name = 'lh_V1_smooth3mm.mat';
% 
% afq = AFQ_AddNewFiberGroup(afq, fgName, roi1Name, roi2Name, 0, 1);
% 
% fgName = 'fg_ROR_BigNotROI_MD3.pdb';
% 
% roi1Name = 'Rt-LGN.mat';
% roi2Name = 'rh_V1_smooth3mm.mat';
% 
% afq = AFQ_AddNewFiberGroup(afq, fgName, roi1Name, roi2Name, 0, 1);
% 
% fgName = 'fg_ROR_BigNotROI_MD4.pdb';
% 
% roi1Name = 'Rt-LGN.mat';
% roi2Name = 'rh_V1_smooth3mm.mat';
% 
% afq = AFQ_AddNewFiberGroup(afq, fgName, roi1Name, roi2Name, 0, 1);
% 
% fgName = 'fg_ROR_BigNotROI_MD5.pdb';
% 
% roi1Name = 'Rt-LGN.mat';
% roi2Name = 'rh_V1_smooth3mm.mat';
% 
% afq = AFQ_AddNewFiberGroup(afq, fgName, roi1Name, roi2Name, 0, 1);
% %% ADD OR BigNotROI
% fgName = 'RORV13mmClipBigNotROI5.pdb';
%         
% roi1Name= 'Rt-LGN.mat';
% roi2Name = 'rh_V1_smooth3mm_NOT.mat';
% afq = AFQ_AddNewFiberGroup(afq, fgName, roi1Name, roi2Name, 1, 1);
% 
% 
% fgName   = 'LORV13mmClipBigNotROI5.pdb';
% roi1Name = 'Lt-LGN.mat';
% roi2Name = 'lh_V1_smooth3mm_NOT.mat';
% afq = AFQ_AddNewFiberGroup(afq, fgName, roi1Name, roi2Name, 1, 1);
% 
% save afq;
%% ADD OR BigNotROI
fgName = 'RORV13mmClipBigNotROI5_clean.pdb';
        
roi1Name= 'Rt-LGN.mat';
roi2Name = 'rh_V1_smooth3mm_NOT.mat';
afq = AFQ_AddNewFiberGroup(afq, fgName, roi1Name, roi2Name, 1, 1);


fgName   = 'LORV13mmClipBigNotROI5_clean.pdb';
roi1Name = 'Lt-LGN.mat';
roi2Name = 'lh_V1_smooth3mm_NOT.mat';
afq = AFQ_AddNewFiberGroup(afq, fgName, roi1Name, roi2Name, 1, 1);


%% OCF 
fgName = 'OCF50kV1V23mmFsCCnode50_MD4.pdb';
        
roi1Name= 'lh_V1_smooth3mm_lh_V2_smooth3mm.mat';
roi2Name = 'rh_V1_smooth3mm_rh_V2_smooth3mm.mat';
afq = AFQ_AddNewFiberGroup(afq, fgName, roi1Name, roi2Name, 0, 1);

%% OR 0801
fgName = 'RORV13mmC_Not0801.pdb';
        
roi1Name= 'Rt-LGN4.mat';
roi2Name = 'rh_V1_smooth3mm_NOT.mat';
afq = AFQ_AddNewFiberGroup(afq, fgName, roi1Name, roi2Name, 1, 1);


fgName   = 'LORV13mmC_Not0801.pdb';
roi1Name = 'Lt-LGN4.mat';
roi2Name = 'lh_V1_smooth3mm_NOT.mat';
afq = AFQ_AddNewFiberGroup(afq, fgName, roi1Name, roi2Name, 1, 1);


%%


% %% add OCF probabilistic way  
% fgName = 'LOCF1000.pdb';
% roi1Name = 'CC.mat';
% roi2Name = 'ctx-lh-pericalcarine.mat';
% 
% afq = AFQ_AddNewFiberGroup(afq, fgName, roi1Name, roi2Name, 0, 1);
% 
% fgName = 'ROCF1000.pdb';
% roi1Name = 'CC.mat';
% roi2Name = 'ctx-rh-pericalcarine.mat';
% 
% afq = AFQ_AddNewFiberGroup(afq, fgName, roi1Name, roi2Name, 0, 1);
% 
% %% add L-OCF_MD2
% fgName = 'LOCF_MD2.pdb';
% 
% roi1Name = 'CC.mat';
% roi2Name = 'ctx-lh-pericalcarine.mat';
% 
% afq = AFQ_AddNewFiberGroup(afq, fgName, roi1Name, roi2Name, 0, 1);
% 
% % add R-OCF_MD2
% fgName = 'ROCF_MD2.pdb';
% 
% roi1Name = 'CC.mat';
% roi2Name = 'ctx-rh-pericalcarine.mat';
% 
% afq = AFQ_AddNewFiberGroup(afq, fgName, roi1Name, roi2Name, 0, 1);
% 
% %% add OCF_MD3
% fgName = 'LOCF_MD3.pdb';
% 
% roi1Name = 'CC.mat';
% roi2Name = 'ctx-lh-pericalcarine.mat';
% 
% afq = AFQ_AddNewFiberGroup(afq, fgName, roi1Name, roi2Name, 0, 1);
% 
% % add R-OCF_MD2
% fgName = 'ROCF_MD3.pdb';
% 
% roi1Name = 'CC.mat';
% roi2Name = 'ctx-rh-pericalcarine.mat';
% 
% afq = AFQ_AddNewFiberGroup(afq, fgName, roi1Name, roi2Name, 0, 1);
% 
% %% add OCF_MD4
% fgName = 'LOCF_MD4.pdb';
% 
% roi1Name = 'CC.mat';
% roi2Name = 'ctx-lh-pericalcarine.mat';
% 
% afq = AFQ_AddNewFiberGroup(afq, fgName, roi1Name, roi2Name, 0, 1);
% 
% % add R-OCF_MD2
% fgName = 'ROCF_MD4.pdb';
% 
% roi1Name = 'CC.mat';
% roi2Name = 'ctx-rh-pericalcarine.mat';
% 
% afq = AFQ_AddNewFiberGroup(afq, fgName, roi1Name, roi2Name, 0, 1);
% 
% %% add probabilistic OCF 1000 3000 5000
% % 1000
% fgName = 'Mori_Occ1000.pdb';
% 
% roi1Name = 'Mori_LOcc.mat';
% roi2Name = 'Mori_ROcc.mat';
% 
% afq = AFQ_AddNewFiberGroup(afq, fgName, roi1Name, roi2Name, 0, 1);
% 
% % % 3000
% % fgName = 'Mori_Occ3000.pdb';
% % 
% % roi1Name = 'Mori_LOcc.mat';
% % roi2Name = 'Mori_ROcc.mat';
% % 
% % afq = AFQ_AddNewFiberGroup(afq, fgName, roi1Name, roi2Name, 0, 1);
% 
% % 5000
% fgName = 'Mori_Occ5000.pdb';
% 
% roi1Name = 'Mori_LOcc.mat';
% roi2Name = 'Mori_ROcc.mat';
% 
% afq = AFQ_AddNewFiberGroup(afq, fgName, roi1Name, roi2Name, 0, 1);
% 
% %% add deterministic(STT) OCF
% fgName = 'MoriOccDt.pdb';
% 
% roi1Name = 'FP_L.mat';
% roi2Name = 'FP_R.mat';
% 
% afq = AFQ_AddNewFiberGroup(afq, fgName, roi1Name, roi2Name, 0, 1);
% 
% %% add OCFby2ROI(form L to R calcarine )
% % MD2
% fgName = 'OCFby2ROI_MD2.pdb';
% 
% roi1Name = 'ctx-lh-pericalcarine.mat';
% roi2Name = 'ctx-rh-pericalcarine.mat';
% 
% afq = AFQ_AddNewFiberGroup(afq, fgName, roi1Name, roi2Name, 0, 1);
% 
% %% MD3
% fgName = 'OCFby2ROI_MD3.pdb';
% 
% roi1Name = 'ctx-lh-pericalcarine.mat';
% roi2Name = 'ctx-rh-pericalcarine.mat';
% 
% afq = AFQ_AddNewFiberGroup(afq, fgName, roi1Name, roi2Name, 0, 1);
% 
% %% MD4
% fgName = 'OCFby2ROI_MD4.pdb';
% 
% roi1Name = 'ctx-lh-pericalcarine.mat';
% roi2Name = 'ctx-rh-pericalcarine.mat';
% 
% afq = AFQ_AddNewFiberGroup(afq, fgName, roi1Name, roi2Name, 0, 1);
% 
% %% add OCFby2ROI(form L to R V1V2 )
% % MD3
% fgName = 'OCFV1V2Not3mm_MD3.pdb';
% 
% roi1Name = 'lh_V1_lh_V2.mat';
% roi2Name = 'rh_V1_rh_V2.mat';
% 
% afq = AFQ_AddNewFiberGroup(afq, fgName, roi1Name, roi2Name, 0, 1);
% 
% % MD4
% fgName = 'OCFV1V2Not3mm_MD4.pdb';
% 
% roi1Name = 'lh_V1_lh_V2.mat';
% roi2Name = 'rh_V1_rh_V2.mat';
% 
% afq = AFQ_AddNewFiberGroup(afq, fgName, roi1Name, roi2Name, 0, 1);
% 
% % MD5
% fgName = 'OCFV1V2Not3mm_MD5.pdb';
% 
% roi1Name = 'lh_V1_lh_V2.mat';
% roi2Name = 'rh_V1_rh_V2.mat';
% 
% afq = AFQ_AddNewFiberGroup(afq, fgName, roi1Name, roi2Name, 0, 1);
% %% add OCF fa0.07 deterministic
% % fgName = 'wholeBrain07+FP_L+FP_R.pdb';
% % 
% % roi1Name = 'FP_L.mat';
% % roi2Name = 'FP_R.mat';
% % 
% % afq = AFQ_AddNewFiberGroup(afq, fgName, roi1Name, roi2Name, 0, 1);
% 
% % wholeBrainFG fa>0.07
% fgName = 'OCF07Mori.pdb';
% 
% roi1Name = 'Mori_LOcc.mat';  
% roi2Name = 'Mori_ROcc.mat';
% 
% afq = AFQ_AddNewFiberGroup(afq, fgName, roi1Name, roi2Name, 0, 1);
% 
% 
% % wholeBrainFG fa>0.07
% fgName = 'OCF07Mori_MD3.pdb';
% 
% roi1Name = 'Mori_LOcc.mat';  
% roi2Name = 'Mori_ROcc.mat';
% 
% afq = AFQ_AddNewFiberGroup(afq, fgName, roi1Name, roi2Name, 0, 1);
% 
% % wholeBrainFG fa>0.07
% fgName = 'OCF07Mori_MD4.pdb';
% 
% roi1Name = 'Mori_LOcc.mat';  
% roi2Name = 'Mori_ROcc.mat';
% 
% afq = AFQ_AddNewFiberGroup(afq, fgName, roi1Name, roi2Name, 0, 1);
% 
% % wholeBrainFG fa>0.07
% fgName = 'OCF07Mori_MD5.pdb';
% 
% roi1Name = 'Mori_LOcc.mat';  
% roi2Name = 'Mori_ROcc.mat';
% 
% afq = AFQ_AddNewFiberGroup(afq, fgName, roi1Name, roi2Name, 0, 1);
% 
% %% wholeBrainFG and 'Mori_OCC'_cleaned fa>0.07 
% fgName = 'OCF07Mori_clean.pdb';
% 
% roi1Name = 'Mori_LOcc.mat';  
% roi2Name = 'Mori_ROcc.mat';
% 
% afq = AFQ_AddNewFiberGroup(afq, fgName, roi1Name, roi2Name, 0, 1);
% 
% %% add wholeBrain_fa0.07 + calcarine ROI
% 
% fgName = 'wholeBrain07_calc0111.pdb';
% 
% roi1Name = 'ctx-lh-pericalcarine_clean0111.mat';                  
% roi2Name = 'ctx-rh-pericalcarine_clean0111.mat';
% 
% afq = AFQ_AddNewFiberGroup(afq, fgName, roi1Name, roi2Name, 0, 1);
% 
% 
% %%
% 
% fgName = 'R-ILF07.pdb';
% 
% roi1Name = 'ILF_roi1_R.mat';
% roi2Name = 'ILF_roi2_R.mat';
% 
% afq = AFQ_AddNewFiberGroup(afq, fgName, roi1Name, roi2Name, 0, 1);
% 
% fgName = 'L-ILF07.pdb';
% 
% roi1Name = 'ILF_roi1_L.mat';
% roi2Name = 'ILF_roi2_L.mat';
% 
% afq = AFQ_AddNewFiberGroup(afq, fgName, roi1Name, roi2Name, 0, 1);
% 
% % save AFQ_6LHON5Normal.mat
% 
% 
% 
% %% Here are some notes about the afq structure
% 
% % Lets load up the dt6 file for subject 1
% dt = dtiLoadDt6(afq.files.dt6{6});
% 
% % Now let's load up the segmented fiber group for subject 13
% % fg = dtiReadFibers(afq.files.fibers.clean{13});
% fg = dtiLoadFiberGroup(afq.files.fibers.LOR_MD3{1});% {1} = subj 1
% 
% fg = dtiReadFibers(afq.files.fibers.clean{6}); % 1 = all of MORIfg of subj 1
% % fg = dtiReadFibers(afq.files.fibers.L);
% 
% % Now let's render the left hemisphere ILF just to see it. The ILF is fiber
% % group number 13. For time's sake we will onl`y render 100 fibers from the
% % fiber group
% %AFQ_RenderFibers(fg(13), 'numfibers', 1000 ,'color', [.7 .7 1]);
% 
% AFQ_RenderFibers(fg(9), 'numfibers', 10000 ,'color', [.7 .7 1]);
% 
% % Add a slice from the t1. The path to this image is saved in the dt6 file
% t1 = niftiRead(dt.files.t1);
% AFQ_AddImageTo3dPlot(t1, [5 0 0]);
% 
% %%
% % Lets load up the dt6 file for subject 1
% dt = dtiLoadDt6(afq.files.dt6{1}); % subject{}
% fg = dtiReadFibers(afq.files.fibers.clean{1}); %subject{}
% fg = dtiReadFibers(afq.files.fibers.segmented{1});
% 
% 
% AFQ_RenderFibers(fg(9), 'numfibers', 10000 ,'color', [.7 .7 1]); %fg() = fg
% %%
% for i = 1:11
% % fg = fgRead(afq.files.fibers.LOCF_MD2{1});
% % fg = fgRead(afq.files.fibers.clean{i,1});
% fg = fgRead(afq.files.fibers.ROR_MD3{i});
% 
% AFQ_RenderFibers(fg, 'numfibers', 10000 ,'color', [.7 .7 1],'camera','axial'); %fg() = fg
% 
% end
% %
% %%
% for i = 1:11
% % fg = fgRead(afq.files.fibers.LOCF_MD2{1});
% % fg = fgRead(afq.files.fibers.clean{i,1});
% fg = fgRead(afq.files.fibers.OCF07Mori_MD4{i});
% 
% AFQ_RenderFibers(fg, 'numfibers', 100 ,'color', [.7 .7 1],'camera','axial'); %fg() = fg
% 
% end
% %%
% 
% 
% 
% % Now lets render a fiber group heatmapped for fa values.
% % First get FA for each point of each fiber
% % valName.  The current valname options are:
% %    - 'fa' (fractional anisotropy) (DEFAULT)
% %    - 'md' (mean diffusivity)
% %    - 'eigvals' (triplet of values for 1st, 2nd and 3rd eigenvalues)
% %    - 'shapes' (triplet of values indicating linearity, planarity and
% %              spherisity)
% %    - 'dt6' (the full tensor in [Dxx Dyy Dzz Dxy Dxz Dyz] format
% %    - 'pdd' (principal diffusion direction)
% %    - 'linearity'
% %    - 'fa md pdd', 'fa md ad rd', 'fa md pdd dt6'
% %    - 'fa md ad rd shape'
% 
% vals = dtiGetValFromFibers(dt.dt6,fg(9),inv(dt.xformToAcpc),'fa');
% vals = dtiGetValFromFibers(dt.dt6,fg(9),inv(dt.xformToAcpc),'md');
% 
% vals = dtiGetValFromFibers(dt.dt6,fg,inv(dt.xformToAcpc),'fa');
% 
% 
% % Then convert each fa value to a color
% rgb = vals2colormap(vals);
% % Now render the fibers colored based on fa
% AFQ_RenderFibers(fg, 'numfibers', 10000 ,'color', rgb);
% AFQ_AddImageTo3dPlot(t1, [-10 0 0]);
% 
% % Now let's render the tract profile meaning the values along the fiber
% % core. Let's dop it for a new tract. how about the inferior fronto
% % occipital fasciculus
% AFQ_RenderFibers(fg(9), 'numfibers',1000 ,'dt', dt, 'radius', [.5 3]);
% AFQ_AddImageTo3dPlot(t1, [-10 0 0]);
% 
% % Now let's render the RD profile
% 
% AFQ_RenderFibers(fg(9), 'numfibers',100 ,'dt', dt, 'radius', [.5 3],'val','rd','crange',[.5 .6]);
% AFQ_AddImageTo3dPlot(t1, [-10 0 0]);
% 
% % Let's add an ROI to the plot
% [roi1 roi2] = AFQ_LoadROIs(9,[], afq);
% 
% AFQ_RenderRoi(roi1, [1 0 0])
% AFQ_RenderRoi(roi2, [1 0 0])
% 
% %% plot LOR_MD3,ROR_MD3
% %AFQ_plot 
% % [patient_data control_data]=AFQ_run(sub_dirs, sub_group); afq.fgnames{21 26} = {ROR_MD3 LOR_MD3}
%  AFQ_plot('patient',afq.patient_data(21),'control',afq.control_data(21), 'group','property','ad');
%  AFQ_plot('patient',afq.patient_data(26),'control',afq.control_data(26), 'group','property','ad');
% 
%  AFQ_plot('patient',afq.patient_data(21),'control',afq.control_data(21), 'group','property','fa');
%  AFQ_plot('patient',afq.patient_data(26),'control',afq.control_data(26), 'group','property','fa');
%   AFQ_plot('patient',afq.patient_data(28),'control',afq.control_data(28), 'group','property','fa');
%  
%  AFQ_plot('patient',afq.patient_data(21),'control',afq.control_data(21), 'group','property','md');
%  AFQ_plot('patient',afq.patient_data(26),'control',afq.control_data(26), 'group','property','md');
%  
%  AFQ_plot('patient',afq.patient_data(21),'control',afq.control_data(21), 'group','property','rd');
%  AFQ_plot('patient',afq.patient_data(26),'control',afq.control_data(26), 'group','property','rd');
%  
%  %,'property',rd);
%  %% plot 'group' and 'individual'
%  
%  AFQ_plot('patient',afq.patient_data,'control',afq.control_data,'tracts',[24:31],'group');
%  AFQ_plot('patient',afq.patient_data,'control',afq.control_data,'tracts',[32:34],'group');
%  
%  % B-OR V1 MD3-5
%  AFQ_plot(afq, 'group','tracts',[52:57]);
%  
%  % B-OR MD3-4
%  AFQ_plot(afq, 'group','tracts',[21:22,42,43]);
%  
%  AFQ_plot(afq, 'individual',[52:57]);
% 
% axis([0,100,0,0.68])
%  
%  
%  AFQ_plot(afq, 'group','tracts',[47]);
% AFQ_plot(afq,'individual','tracts',[47]) ;
% AFQ_plot(afq,'indivisual','tracts',[24:31]);
%  
%  
% %% %% plot Occupital Forceps Major
% 
%  AFQ_plot('patient',afq.patient_data(9),'control',afq.control_data(9), 'group','property','ad');
% 
%  AFQ_plot('patient',afq.patient_data(9),'control',afq.control_data(9), 'group','property','fa');
%  
%  AFQ_plot('patient',afq.patient_data(9),'control',afq.control_data(9), 'group','property','md');
%  
%  AFQ_plot('patient',afq.patient_data(9),'control',afq.control_data(9), 'group','property','rd');
%  
% %%  Create figure
% figure1 = figure;
% 
% % Create axes
% axes1 = axes('Parent',figure1,'FontSize',12,'FontName','Times');
% hold(axes1,'all');
% 
% % Create multiple lines using matrix input to plot
% plot1 = plot(YMatrix1,'Parent',axes1,'LineStyle','--');
% set(plot1(1),'LineWidth',3,'DisplayName','patient','LineStyle','-');
% set(plot1(4),'LineWidth',3,'Color',[0 0.5 0],'DisplayName','control',...
%     'LineStyle','-');
% set(plot1(5),'Color',[0 0.5 0]);
% set(plot1(6),'Color',[0 0.5 0]);
% 
% % Create xlabel
% xlabel('Location','FontSize',12,'FontName','Times');
% 
% % Create ylabel
% ylabel('Radial Diffusivity','FontSize',12,'FontName','Times');
% 
% % Create title
% title('Left Thalmic Radiation','FontSize',12,'FontName','Times');
% title('Callosum Forceps Major LHON','FontSize',12,'FontName','Times');
% 
% 
% 
% % Create legend
% legend(axes1,'show');
% 
% %%
% figure1 = figure;
% % OCF1000,5000
% plot1 = plot(afq.patient_data(1, 26).FA(end,:));text(20,0.9,'OCF1000');
% plot2 = plot(afq.patient_data(1, 25).FA(end,:));text(OCF5000);
% title('LHON6 OCF1000','FontSize',12,'FontName','Times');
% 
% % OCF5000
% plot(afq.patient_data(1, 25).FA(end,:));
% title('LHON6 OCF1000','FontSize',12,'FontName','Times');
% 
% % OCF 
% plot(afq.patient_data(1, 25).FA(end,:));figure(gcf);
% 
%  
% %%
% % [abn abnTracts] = AFQ_ComparePatientsToNorms(patient_data, norms, cutoff, property, comp)
% % 
% %  Inputs:
% %  patient_data = Fiber tract diffusion profiles for the patients.  See
% %                 AFQ_ComputeTractProperties and AFQ_ComputeNorms
% %  norms        = Normative fiber tract diffusion profiles see AFQ_ComputeNorms
% %  cutoff       = Percentile bands that define the range to be considered
% %                 normal
% %  property     = String defining what property to analyze.  For example
% %                 'FA' or 'RD'
% %  comp         = Defines whether to compare tract means (comp = 'mean') or
% %                 compare pointwise along the tract profile
% %                 (comp ='profile').  The default is to compare along the
% %                 tract profiles.
% % 
% % 
% %  Outputs:
% %  abn          = A 1 x N vector where N is the number of patients.
% %                 Each patient that is abnormal on at least one tract is
% %                 marked with a 1 and each subject that is normal on every
% %                 tract is marked with a 0. The criteria for abnormal is
% %                 defined in afq.params.cutoff.  See AFQ create
% % 
% %  abnTracts    = An M by N matrix where M is the number of subjects and N
% %                 is the number of tracts. Each row is a subject and each
% %                 column is a tract.  1 means that tract was abnormal for
% %                 that subject and 0 means it was normal.
% 
% 
% 

