%% runAFQonMySubjects_AdultJMD_7Ctl.m
% set directories
% to compare 6JMD to 5normal these data were aquired at Tamagawa Univ.
% Siemens scanner.

AFQdata = '/biac4/wandell/biac2/wandell/data/DWI-Tamagawa-Japan';

subs = {...
    'JMD1-MM-20121025-DWI'
    'JMD2-KK-20121025-DWI'
    'JMD3-AK-20121026-DWI'
    'JMD4-AM-20121026-DWI'
    'JMD5-KK-20121220-DWI'
    'JMD6-NO-20121220-DWI'
    'JMD7-YN-20130621-DWI'
    'JMD8-HT-20130621-DWI'
    'JMD9-TY-20130621-DWI'
    'JMD-Ctl-MT-20121025-DWI'
    'JMD-Ctl-YM-20121025-DWI'
    'JMD-Ctl-SY-20130222DWI'
    'JMD-Ctl-HH-20120907DWI'
    'JMD-Ctl-HT-20120907-DWI'
    'JMD-Ctl-FN-20130621-DWI'
    'JMD-Ctl-AM-20130726-DWI'};

% Make directory structure for each subject
for ii = 1:length(subs)
    sub_dirs{ii} = fullfile(AFQdata, subs{ii},'dwi_2nd');
end

% Subject grouping is a little bit funny because afq only takes two groups
% but we have 3. For now we will divide it up this way but we can do more
% later
sub_group = [1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0];

% Now create and afq structure
afq = AFQ_Create('sub_dirs', sub_dirs, 'sub_group', sub_group, 'clip2rois', 0);

afq.params.cutoff=[5 95];
afq.params.outdir = ...
fullfile(AFQdata,'AFQ_results/9JMD_7Ctl');
afq.params.outname = 'AFQ_9JMD_7Ctl.mat';
afq.params.computeCSD = 1;
%% Run AFQ on these subjects
afq = AFQ_run(sub_dirs, sub_group, afq);

save 

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
% %% R-optic radiation
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
% 
% afq = AFQ_AddNewFiberGroup(afq, fgName, roi1Name, roi2Name, 0, 1);

%% OR 0801
fgName = 'RORV13mmC_Not0801.pdb';
        
roi1Name= 'Rt-LGN4.mat';
roi2Name = 'rh_V1_smooth3mm_NOT.mat';
afq = AFQ_AddNewFiberGroup_2(afq, fgName, roi1Name, roi2Name, 0, 1);


fgName   = 'LORV13mmC_Not0801.pdb';
roi1Name = 'Lt-LGN4.mat';
roi2Name = 'lh_V1_smooth3mm_NOT.mat';
afq = AFQ_AddNewFiberGroup_2(afq, fgName, roi1Name, roi2Name, 0, 1);


%% ADD OR BigNotROI
fgName = 'RORV13mmClipBigNotROI5.pdb';
        
roi1Name= 'Rt-LGN.mat';
roi2Name = 'rh_V1_smooth3mm_NOT.mat';
afq = AFQ_AddNewFiberGroup_2(afq, fgName, roi1Name, roi2Name, 1, 1);


fgName   = 'LORV13mmClipBigNotROI5.pdb';
roi1Name = 'Lt-LGN.mat';
roi2Name = 'lh_V1_smooth3mm_NOT.mat';
afq = AFQ_AddNewFiberGroup_2(afq, fgName, roi1Name, roi2Name, 1, 1);

save afq;

%% ADD OR BigNotROI
fgName = 'RORV13mmClipBigNotROI5_clean.pdb';
        
roi1Name= 'Rt-LGN.mat';
roi2Name = 'rh_V1_smooth3mm_NOT.mat';
afq = AFQ_AddNewFiberGroup(afq, fgName, roi1Name, roi2Name, 0, 1);


fgName   = 'LORV13mmClipBigNotROI5_clean.pdb';
roi1Name = 'Lt-LGN.mat';
roi2Name = 'lh_V1_smooth3mm_NOT.mat';
afq = AFQ_AddNewFiberGroup(afq, fgName, roi1Name, roi2Name, 0, 1);

%% ADD OR BigNotROI_WM
% using SO_AFQ

fgName = 'RORV13mmClipBigNotROI5_clean_WM.pdb';
        
roi1Name= 'Rt-LGN.mat';
roi2Name = 'rh_V1_smooth3mm_NOT.mat';
afq = SO_AFQ_AddNewFiberGroup(afq, fgName, roi1Name, roi2Name, 0, 1);


fgName   = 'LORV13mmClipBigNotROI5_cleanWM.pdb';
roi1Name = 'Lt-LGN.mat';
roi2Name = 'lh_V1_smooth3mm_NOT.mat';
afq = SO_AFQ_AddNewFiberGroup(afq, fgName, roi1Name, roi2Name, 0, 1);

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
% %%
% % add L-OCF_MD2
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
% %% add OCFbyV1V2_MD3
% fgName = 'OCFbyV1V2_MD3.pdb';
% 
% roi1Name = 'lh_V1_smooth3mm_lh_V2_smooth3mm.mat';
% roi2Name = 'rh_V1_smooth3mm_rh_V2_smooth3mm.mat';
% 
% afq = AFQ_AddNewFiberGroup(afq, fgName, roi1Name, roi2Name, 0, 1);
% 
% % add OCFbyV1V2_MD4
% fgName = 'OCFbyV1V2_MD4.pdb';
% 
% roi1Name = 'lh_V1_smooth3mm_lh_V2_smooth3mm.mat';
% roi2Name = 'rh_V1_smooth3mm_rh_V2_smooth3mm.mat';
% 
% afq = AFQ_AddNewFiberGroup(afq, fgName, roi1Name, roi2Name, 0, 1);
% 
% % add OCFbyV1V2_MD5
% fgName = 'OCFbyV1V2_MD5.pdb';
% 
% roi1Name = 'lh_V1_smooth3mm_lh_V2_smooth3mm.mat';
% roi2Name = 'rh_V1_smooth3mm_rh_V2_smooth3mm.mat';
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
% % 3000
% fgName = 'Mori_Occ3000.pdb';
% 
% roi1Name = 'Mori_LOcc.mat';
% roi2Name = 'Mori_ROcc.mat';
% 
% afq = AFQ_AddNewFiberGroup(afq, fgName, roi1Name, roi2Name, 0, 1);
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
% 
% 
% % % wholeBrainFG fa>0.2
% % fgName = 'OCF20Mori.pdb';
% % 
% % roi1Name = 'Mori_LOcc.mat';  
% % roi2Name = 'Mori_ROcc.mat';
% % 
% % afq = AFQ_AddNewFiberGroup(afq, fgName, roi1Name, roi2Name, 0, 1);
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


%% Here are some notes about the afq structure

% Lets load up the dt6 file for subject 13
dt = dtiLoadDt6(afq.files.dt6{1});

% Now let's load up the segmented fiber group for subject 13
% fg = dtiReadFibers(afq.files.fibers.clean{13}); % dtireadFibers for .mat,
% dtiLoadFiberGroup for .pdb 
% fg = dtiLoadFiberGroup(afq.files.fibers.LOR_MD3{12});
fg = fgRead(afq.files.fibers.ROCF_MD3{1});

% Now let's render the left hemisphere ILF just to see it. The ILF is fiber
% group number 13. For time's sake we will onl`y render 100 fibers from the
% fiber group
AFQ_RenderFibers(fg, 'numfibers', 1000 ,'color', [.7 .7 1]);

AFQ_RenderFibers(fg(9),'camera', 'axial'); % 'coronal', 'axial', 'saggital'

% 
AFQ_RenderFibers(fg,'dt',dt)

% Add a slice from the t1. The path to this image is saved in the dt6 file
t1 = niftiRead(dt.files.t1);
AFQ_AddImageTo3dPlot(t1, [5 0 0]);

AFQ_AddImageTo3dPlot(t1, [0 -30 0]);


%%
for i = 7:11
% fg = fgRead(afq.files.fibers.LOCF_MD2{1});
% fg = fgRead(afq.files.fibers.clean{i,1});
fg = fgRead(afq.files.fibers.clean{i,1});

AFQ_RenderFibers(fg(9), 'numfibers', 100 ,'color', [.7 .7 1],'camera','axial'); %fg() = fg
% title('JMD','FontSize',12,'FontName','Times');

end
%%
for i = 1:11
% fg = fgRead(afq.files.fibers.LOCF_MD2{1});
% fg = fgRead(afq.files.fibers.clean{i,1});
fg = fgRead(afq.files.fibers.ROCF_MD3{i});

AFQ_RenderFibers(fg, 'numfibers', 100 ,'color', [.7 .7 1],'camera','axial'); %fg() = fg
% title('JMD','FontSize',12,'FontName','Times');

end
%%
for i = 1:11
% fg = fgRead(afq.files.fibers.LOCF_MD2{1});
% fg = fgRead(afq.files.fibers.clean{i,1});
fg = fgRead(afq.files.fibers.ROCF_MD3{i});

AFQ_RenderFibers(fg, 'newfig', [1],'numfibers', 100 ,'color', [.7 .7 1],'camera','axial'); %fg() = fg

fg = fgRead(afq.files.fibers.LOCF_MD3{i});

% title('JMD','FontSize',12,'FontName','Times');
AFQ_RenderFibers(fg, 'newfig', [0],'numfibers', 100 ,'color', [.7 .7 1],'camera','axial'); %fg() = fg

end

% AFQ_RenderFibers(fg,'newfig', [1]) - Check if rendering should be in new
% window [1] or added to an old window [0]. Default is new figure.

%% render fiber group with fa colormap 
for i = 1:11
% fg = fgRead(afq.files.fibers.LOCF_MD2{1});
% fg = fgRead(afq.files.fibers.clean{i,1});

dt = dtiLoadDt6(afq.files.dt6{i});

fg = fgRead(afq.files.fibers.LOCF_MD3{i});

vals = dtiGetValFromFibers(dt.dt6,fg,inv(dt.xformToAcpc),'fa');
rgb = vals2colormap(vals);
%AFQ_RenderFibers(fg, 'numfibers', 100 ,'color', rgb,'camera','axial');

% Now let's render the tract profile meaning the values along the fiber
% core. Let's dop it for a new tract.
AFQ_RenderFibers(fg, 'numfibers',100 ,'dt', dt, 'radius', [.4 3],'camera','axial','val','fa','crange',[0.2 1.0]);

% AFQ_RenderFibers(fg, 'numfibers', 100 ,'color', [.7 .7 1],'camera','axial'); %fg() = fg
% title('JMD','FontSize',12,'FontName','Times');

end

%% render fiber group with fa colormap 
for i = 1
% fg = fgRead(afq.files.fibers.LOCF_MD2{1});
% fg = fgRead(afq.files.fibers.clean{i,1});

dt = dtiLoadDt6(afq.files.dt6{i});

fg = fgRead(afq.files.fibers.OCFbyV1V2_MD3{i});

vals = dtiGetValFromFibers(dt.dt6,fg,inv(dt.xformToAcpc),'fa');
rgb = vals2colormap(vals);
%AFQ_RenderFibers(fg, 'numfibers', 100 ,'color', rgb,'camera','axial');

% Now let's render the tract profile meaning the values along the fiber
% core. Let's dop it for a new tract.
AFQ_RenderFibers(fg, 'numfibers',100 ,'dt', dt, 'radius', [.4 3],'camera','axial','val','fa','crange',[0.2 1.0]);

% AFQ_RenderFibers(fg, 'numfibers', 100 ,'color', [.7 .7 1],'camera','axial'); %fg() = fg
% title('JMD','FontSize',12,'FontName','Times');

end

%%
% Now lets render a fiber group heatmapped for fa values.
% First get FA for each point of each fiber
% valName.  The current valname options are:
%    - 'fa' (fractional anisotropy) (DEFAULT)
%    - 'md' (mean diffusivity)
%    - 'eigvals' (triplet of values for 1st, 2nd and 3rd eigenvalues)
%    - 'shapes' (triplet of values indicating linearity, planarity and
%              spherisity)
%    - 'dt6' (the full tensor in [Dxx Dyy Dzz Dxy Dxz Dyz] format
%    - 'pdd' (principal diffusion direction)
%    - 'linearity'
%    - 'fa md pdd', 'fa md ad rd', 'fa md pdd dt6'
%    - 'fa md ad rd shape'

% vals = dtiGetValFromFibers(dt.dt6,fg(16),inv(dt.xformToAcpc),'fa');

vals = dtiGetValFromFibers(dt.dt6,fg,inv(dt.xformToAcpc),'fa');
% vals = dtiGetValFromFibers(dt.dt6,fg,inv(dt.xformToAcpc),'md');
% vals = dtiGetValFromFibers(dt.dt6,fg,inv(dt.xformToAcpc),'ad');
% vals = dtiGetValFromFibers(dt.dt6,fg,inv(dt.xformToAcpc),'rd');
% vals = dtiGetValFromFibers(dt.dt6,fg,inv(dt.xformToAcpc),'pdd');
% vals = dtiGetValFromFibers(dt.dt6,fg,inv(dt.xformToAcpc),'dt6');
% vals = dtiGetValFromFibers(dt.dt6,fg,inv(dt.xformToAcpc),'shapes');

% Then convert each fa value to a color
rgb = vals2colormap(vals);

% Now render the fibers colored based on fa
% AFQ_RenderFibers(fg(13), 'numfibers', 100 ,'color', rgb);
AFQ_RenderFibers(fg, 'numfibers', 100 ,'color', rgb,'camera','axial');
AFQ_AddImageTo3dPlot(t1, [-10 0 0]);




% Now let's render the tract profile meaning the values along the fiber
% core. Let's dop it for a new tract. how about the inferior fronto
% occipital fasciculus
% AFQ_RenderFibers(fg(11), 'numfibers',200 ,'dt', dt, 'radius', [.5 3]);
AFQ_RenderFibers(fg, 'numfibers',100 ,'dt', dt, 'radius', [.5 3],'camera','axial','val','fa','crange',[0.2 1.0]);
AFQ_RenderFibers(fg(9), 'numfibers',100 ,'dt', dt, 'radius', [.5 3],'camera','axial','val','rd','crange',[0.2 1.0]);
AFQ_RenderFibers(fg(9), 'numfibers',100 ,'dt', dt, 'radius', [.5 3],'camera','axial','val','md','crange',[0.5 1.0]);
AFQ_RenderFibers(fg(9), 'numfibers',100 ,'dt', dt, 'radius', [.5 3],'camera','axial','val','ad','crange',[0.8 2.0]);

AFQ_RenderFibers(fg(9), 'numfibers',100 ,'dt', dt, 'radius', [.5 3],'camera','saggital','crange',[0.2 1.0]);

AFQ_AddImageTo3dPlot(t1, [-10 0 0]);
AFQ_AddImageTo3dPlot(t1, [0 0 -1]);
AFQ_AddImageTo3dPlot(t1, [1 0 0]);




% Now let's render the RD profile

AFQ_RenderFibers(fg, 'numfibers',200 ,'dt', dt, 'radius', [.5 3],'val','rd','crange',[.5 .6]);
AFQ_AddImageTo3dPlot(t1, [-10 0 0]);

% Let's add an ROI to the plot
[roi1 roi2] = AFQ_LoadROIs(1,[], afq);

AFQ_RenderRoi(roi1, [1 0 0])

%% Here are some aditional notes on our fiber group structure

% Your optic radiations fiber groups each contain just a single fiber group
LOR = dtiLoadFiberGroup(afq.files.fibers.LOR_MD3{10});

% While the "MoriGroups.mat" fiber group contains 20 fiber groups in it
mori = dtiLoadFiberGroup(afq.files.fibers.clean{10})

%% AFQ_plot
% [patient_data control_data]=AFQ_run(sub_dirs, sub_group); afq.fgnames{21 22} = { 'LOR_MD3' ROR_MD3}
 AFQ_plot('patient',afq.patient_data(21),'control',afq.control_data(21), 'group','property','ad');
 AFQ_plot('patient',afq.patient_data(22),'control',afq.control_data(22), 'group','property','ad');

 AFQ_plot('patient',afq.patient_data(21),'control',afq.control_data(21), 'group','property','fa');
 AFQ_plot('patient',afq.patient_data(22),'control',afq.control_data(22), 'group','property','fa');
 
 AFQ_plot('patient',afq.patient_data(21),'control',afq.control_data(21), 'group','property','rd');
 AFQ_plot('patient',afq.patient_data(22),'control',afq.control_data(22), 'group','property','rd');
 
 AFQ_plot('patient',afq.patient_data(21),'control',afq.control_data(21), 'group','property','md');
 AFQ_plot('patient',afq.patient_data(22),'control',afq.control_data(22), 'group','property','md');
 %,'property',rd);

%% %% plot L-Occupital Calossal Fiber,R-OCF=

 AFQ_plot('patient',afq.patient_data(9),'control',afq.control_data(9), 'group','property','ad');

 AFQ_plot('patient',afq.patient_data(9),'control',afq.control_data(9), 'group','property','fa');
 
 AFQ_plot('patient',afq.patient_data(9),'control',afq.control_data(9), 'group','property','md');
 
 AFQ_plot('patient',afq.patient_data(9),'control',afq.control_data(9), 'group','property','rd');
 
%%
% AFQ_plot(afq , 'group')
AFQ_plot(afq,'group','tracts',[32:34])
% AFQ_plot(afq,'individual','tracts',[32:34],'range',[0.2 1.0])
% 
% AFQ_plot(afq,'group','tracts',[35:36])
% AFQ_plot(afq,'individual','tracts',[35:36],'range',[0.2 1.0])

% AFQ_plot(afq,'group','tracts',[39:41])
% AFQ_plot(afq,'individual','tracts',[39:41],'range',[0.2 1.0])

AFQ_plot(afq,'individual','tracts',[42:43],'range',[0.2 1.0])
AFQ_plot(afq,'group','tracts',[42:43],'range',[0.2 1.0])

AFQ_plot(afq,'group','tracts',[27:29],'range',[0.2 1.0])
AFQ_plot(afq,'individual','tracts',[42:43],'range',[0.2 1.0])
 
%%  Create figure
figure1 = figure;

% Create axes
axes1 = axes('Parent',figure1,'FontSize',12,'FontName','Times');
hold(axes1,'all');

% Create multiple lines using matrix input to plot
plot1 = plot(YMatrix1,'Parent',axes1,'LineStyle','--');
set(plot1(1),'LineWidth',3,'DisplayName','patient','LineStyle','-');
set(plot1(4),'LineWidth',3,'Color',[0 0.5 0],'DisplayName','control',...
    'LineStyle','-');
set(plot1(5),'Color',[0 0.5 0]);
set(plot1(6),'Color',[0 0.5 0]);

% Create xlabel
xlabel('Location','FontSize',12,'FontName','Times');

% Create ylabel
ylabel('Radial Diffusivity','FontSize',12,'FontName','Times');

% Create title
title('Left Thalmic Radiation','FontSize',12,'FontName','Times');
title('Callosum Forceps Major JMD','FontSize',12,'FontName','Times');

