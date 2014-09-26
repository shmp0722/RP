%% SO_fefgGet.m

%% Set the path to data directory
homeDir = '/biac4/wandell/biac2/wandell/data/DWI-Tamagawa-Japan';
subDir = {...
    'JMD1-MM-20121025-DWI'
    'JMD2-KK-20121025-DWI'
    'JMD3-AK-20121026-DWI'
    'JMD4-AM-20121026-DWI'
    'JMD5-KK-20121220-DWI'
    'JMD6-NO-20121220-DWI'
    'JMD7-YN-20130621-DWI'
    'JMD8-HT-20130621-DWI'
    'JMD9-TY-20130621-DWI'
    'LHON1-TK-20121130-DWI'
    'LHON2-SO-20121130-DWI'
    'LHON3-TO-20121130-DWI'
    'LHON4-GK-20121130-DWI'
    'LHON5-HS-20121220-DWI'
    'LHON6-SS-20121221-DWI'
    'JMD-Ctl-MT-20121025-DWI'
    'JMD-Ctl-SY-20130222DWI'
    'JMD-Ctl-YM-20121025-DWI'
    'JMD-Ctl-HH-20120907DWI'
    'JMD-Ctl-HT-20120907-DWI'
    'JMD-Ctl-FN-20130621-DWI'
    'JMD-Ctl-AM-20130726-DWI'};

%% Run fefgGet to compute R-OR
for i = 1:length(subDir);
    
    SubDir = fullfile(homeDir,subDir{i});
    fgDir  = fullfile(SubDir,'/dwi_2nd/fibers');
    roiDir = fullfile(SubDir,'/dwi_2nd/ROIs');
    dtDir  = fullfile(homeDir,subDir{i},'dwi_2nd');
    
    % define
    fgf= 'RORV13mmClipBigNotROI5_clean_WM.mat';
    %     'LORV13mmClipBigNotROI5_clean_WM.mat'};
    dt  = fullfile(dtDir,'dt6.mat');
    
    % Load fg
    fg  = fullfile(fgDir,fgf);
    fg = fgRead(fg);
    
    % run fefgGet
    faR{i} = fefgGet(fg,'fa',dt);
    mdR{i} = fefgGet(fg,'md',dt);
    adR{i} = fefgGet(fg,'ad',dt);
    rdR{i} = fefgGet(fg,'rd',dt);
    
end
%% Comupute stats R-OR

for i = 1:length(subDir);
    
    SubDir = fullfile(homeDir,subDir{i});
    fgDir  = fullfile(SubDir,'/dwi_2nd/fibers');
    roiDir = fullfile(SubDir,'/dwi_2nd/ROIs');
    dtDir  = fullfile(homeDir,subDir{i},'dwi_2nd');
    
    % define
    fgf= 'RORV13mmClipBigNotROI5_clean_WM.mat';
    %     'LORV13mmClipBigNotROI5_clean_WM.mat'};
    dt  = fullfile(dtDir,'dt6.mat');
    dt  = dtiLoadDt6(dt);
%     [~,dtiH] = mrDiffusion('off',dt);
    
    % Load fg
    fg  = fullfile(fgDir,fgf);
    fg = fgRead(fg);
    
    % The following two computations allow measuring the mean and std of
    % the FA values collapsing across the whole volume of the tract
    %
    % Get the unique coordinates in the fiber group
    % THis computations disregards the number of fibers/nodes in eahc
    % voxles and computes the mean FA only in the unique voxels in the
    % fiber group.
    
    % Xform the fibers into image sapce
%     xform = dtiGet(dtiH,'acpc2img xform');
    xform = dt.xformToAcpc;
    fgImg = dtiXformFiberCoords(fg,xform,'img');
    
    for ifib = 1:length(fgImg.fibers);
        % Find the unique voxels in the fiber
        [a,ind] = unique(floor(fgImg.fibers{ifib})','rows');
        
        % Extract the Fa only out of the unique voxels
        vox_faROR{i}{ifib} = faR{i}{ifib}(ind);
        vox_mdROR{i}{ifib} = mdR{i}{ifib}(ind);
        vox_adROR{i}{ifib} = adR{i}{ifib}(ind);
        vox_rdROR{i}{ifib} = rdR{i}{ifib}(ind);
    end
    % Compute the mean and the std of the tract
    stats_faROR{i}  = prctile(vertcat(vox_faROR{i}{:}),[5 33 50 66 95]);
    stats_mdROR{i}  = prctile(vertcat(vox_mdROR{i}{:}),[5 33 50 66 95]);
    stats_adROR{i}  = prctile(vertcat(vox_adROR{i}{:}),[5 33 50 66 95]);
    stats_rdROR{i}  = prctile(vertcat(vox_rdROR{i}{:}),[5 33 50 66 95]);
    
end

%% Run fefgGet to calculate R-OR NOT5
for i = 2:length(subDir);
    
    SubDir = fullfile(homeDir,subDir{i});
    fgDir  = fullfile(SubDir,'/dwi_2nd/fibers');
    roiDir = fullfile(SubDir,'/dwi_2nd/ROIs');
    dtDir  = fullfile(homeDir,subDir{i},'dwi_2nd');
    
    % define
    fgf= 'RORV13mmClipBigNotROI5_clean.pdb';
    %     'LORV13mmClipBigNotROI5_clean_WM.mat'};
    dt  = fullfile(dtDir,'dt6.mat');
    
    % Load fg
    fg  = fullfile(fgDir,fgf);
    fg = fgRead(fg);
    
    % run fefgGet
    faR_NOT5{i} = fefgGet(fg,'fa',dt);
    mdR_NOT5{i} = fefgGet(fg,'md',dt);
    adR_NOT5{i} = fefgGet(fg,'ad',dt);
    rdR_NOT5{i} = fefgGet(fg,'rd',dt);
    
end


%% Comupute stats R-OR not5

for i = 2:length(subDir);
    
    SubDir = fullfile(homeDir,subDir{i});
    fgDir  = fullfile(SubDir,'/dwi_2nd/fibers');
    roiDir = fullfile(SubDir,'/dwi_2nd/ROIs');
    dtDir  = fullfile(homeDir,subDir{i},'dwi_2nd');
    cd(fgDir)
    % define
    fgf= 'RORV13mmClipBigNotROI5_clean.pdb';
    %     'LORV13mmClipBigNotROI5_clean_WM.mat'};
    dt  = fullfile(dtDir,'dt6.mat');
    [~,dtiH] = mrDiffusion('off',dt);
    
    % Load fg
    fg  = fullfile(fgDir,fgf);
    fg = fgRead(fg);
    
    % The following two computations allow measuring the mean and std of
    % the FA values collapsing across the whole volume of the tract
    %
    % Get the unique coordinates in the fiber group
    % THis computations disregards the number of fibers/nodes in eahc
    % voxles and computes the mean FA only in the unique voxels in the
    % fiber group.
    %
    % Xform the fibers into image sapce
    xform = dtiGet(dtiH,'acpc2img xform');
    fgImg = dtiXformFiberCoords(fg,xform,'img');
    
    for ifib = 1:length(fgImg.fibers);
        % Find the unique voxels in the fiber
        [a,ind] = unique(floor(fgImg.fibers{ifib})','rows');
        
        % Extract the Fa only out of the unique voxels
        vox_faROR_NOT5{i}{ifib} = faR_NOT5{i}{ifib}(ind);
%         vox_mdROR_NOT5{i}{ifib} = mdR_NOT5{i}{ifib}(ind);
%         vox_adROR_NOT5{i}{ifib} = adR_NOT5{i}{ifib}(ind);
%         vox_rdROR_NOT5{i}{ifib} = rdR_NOT5{i}{ifib}(ind);
    end
    % Compute the mean and the std of the tract
    stats_faROR_NOT5{i}  = prctile(vertcat(vox_faROR_NOT5{i}{:}),[5 33 50 66 95]);
    stats_mdROR_NOT5{i}  = prctile(vertcat(vox_mdROR_NOT5{i}{:}),[5 33 50 66 95]);
    stats_adROR_NOT5{i}  = prctile(vertcat(vox_adROR_NOT5{i}{:}),[5 33 50 66 95]);
    stats_rdROR_NOT5{i}  = prctile(vertcat(vox_rdROR_NOT5{i}{:}),[5 33 50 66 95]);
    
end

%% Compute diffusivities in L-OR
for i = 1:length(subDir);
    
    SubDir = fullfile(homeDir,subDir{i});
    fgDir  = fullfile(SubDir,'/dwi_2nd/fibers');
    roiDir = fullfile(SubDir,'/dwi_2nd/ROIs');
    dtDir  = fullfile(homeDir,subDir{i},'dwi_2nd');
    
    fgf ='LORV13mmClipBigNotROI5_clean_WM.mat';
    dt  = fullfile(dtDir,'dt6.mat');
    
    % load fg
    fg  = fullfile(fgDir,fgf);
    fg = fgRead(fg);
    
    % fefgGet
    faL{i} = fefgGet(fg,'fa',dt);
    mdL{i} = fefgGet(fg,'md',dt);
    adL{i} = fefgGet(fg,'ad',dt);
    rdL{i} = fefgGet(fg,'rd',dt);
    
end

%% Comupute stats of L-OR

for i = 1:length(subDir);
    
    SubDir = fullfile(homeDir,subDir{i});
    fgDir  = fullfile(SubDir,'/dwi_2nd/fibers');
    roiDir = fullfile(SubDir,'/dwi_2nd/ROIs');
    dtDir  = fullfile(homeDir,subDir{i},'dwi_2nd');
    
    % define
    fgf= 'LORV13mmClipBigNotROI5_clean_WM.mat';
    dt  = fullfile(dtDir,'dt6.mat');
    [~,dtiH] = mrDiffusion('off',dt);
    
    % Load fg
    fg  = fullfile(fgDir,fgf);
    fg = fgRead(fg);
    
    % The following two computations allow measuring the mean and std of
    % the FA values collapsing across the whole volume of the tract
    %
    % Get the unique coordinates in the fiber group
    % THis computations disregards the number of fibers/nodes in eahc
    % voxles and computes the mean FA only in the unique voxels in the
    % fiber group.
    %
    % Xform the fibers into image sapce
    xform = dtiGet(dtiH,'acpc2img xform');
    fgImg = dtiXformFiberCoords(fg,xform,'img');
    
    for ifib = 1:length(fgImg.fibers);
        % Find the unique voxels in the fiber
        [~,ind] = unique(floor(fgImg.fibers{ifib})','rows');
        
        % Extract the Fa only out of the unique voxels
        vox_faLOR{i}{ifib} = faL{i}{ifib}(ind);
        vox_mdLOR{i}{ifib} = mdL{i}{ifib}(ind);
        vox_adLOR{i}{ifib} = adL{i}{ifib}(ind);
        vox_rdLOR{i}{ifib} = rdL{i}{ifib}(ind);
    end
    % Compute the mean and the std of the tract
    stats_faLOR{i}  = prctile(vertcat(vox_faLOR{i}{:}),[2.5 33 50 66 97.5]);
    stats_mdLOR{i}  = prctile(vertcat(vox_mdLOR{i}{:}),[2.5 33 50 66 97.5]);
    stats_adLOR{i}  = prctile(vertcat(vox_adLOR{i}{:}),[2.5 33 50 66 97.5]);
    stats_rdLOR{i}  = prctile(vertcat(vox_rdLOR{i}{:}),[2.5 33 50 66 97.5]);
    
end

return
%% Comupute difusivities in OCF
for i =1:length(subDir);
    
    SubDir = fullfile(homeDir,subDir{i});
    fgDir  = fullfile(SubDir,'/dwi_2nd/fibers/conTrack/OCF_Top50K_fsV1V2_3mm');
    roiDir = fullfile(SubDir,'/dwi_2nd/ROIs');
    dtDir  = fullfile(homeDir,subDir{i},'dwi_2nd');
    cd(fgDir)
    
    dt  = fullfile(dtDir,'dt6.mat');
    
    % load fg
    %     fg  = matchfiles(fullfile(fgDir,'*_WM.mat'));
    fg  = dir('fg_OCF_Top50K_fsV1V2_3mm_lh_V1_smooth3mm_lh_V2_smooth3mm_rh_V1_smooth3mm_rh_V2_smooth3mm_*_WM.mat');
    fg = fgRead(fg.name);
    
    % fefgGet
    faOCF{i} = fefgGet(fg,'fa',dt);
    mdOCF{i} = fefgGet(fg,'md',dt);
    adOCF{i} = fefgGet(fg,'ad',dt);
    rdOCF{i} = fefgGet(fg,'rd',dt);
end

%% Comupute stats OCF

for i = 1:length(subDir);
    
    SubDir = fullfile(homeDir,subDir{i});
    fgDir  = fullfile(SubDir,'/dwi_2nd/fibers/conTrack/OCF_Top50K_fsV1V2_3mm');
    roiDir = fullfile(SubDir,'/dwi_2nd/ROIs');
    dtDir  = fullfile(homeDir,subDir{i},'dwi_2nd');
    cd(fgDir)
    
    % load fg
    fg  = dir('fg_OCF_Top50K_fsV1V2_3mm_lh_V1_smooth3mm_lh_V2_smooth3mm_rh_V1_smooth3mm_rh_V2_smooth3mm_*_WM.mat');
    fg = fgRead(fg.name);
    % define
    dt  = fullfile(dtDir,'dt6.mat');
    
    [~,dtiH] = mrDiffusion('off',dt);
    
    
    % The following two computations allow measuring the mean and std of
    % the FA values collapsing across the whole volume of the tract
    %
    % Get the unique coordinates in the fiber group
    % THis computations disregards the number of fibers/nodes in eahc
    % voxles and computes the mean FA only in the unique voxels in the
    % fiber group.
    %
    % Xform the fibers into image sapce
    xform = dtiGet(dtiH,'acpc2img xform');
    fgImg = dtiXformFiberCoords(fg,xform,'img');
    
    for ifib = 1:length(fgImg.fibers);
        % Find the unique voxels in the fiber
        [~,ind] = unique(floor(fgImg.fibers{ifib})','rows');
        
        % Extract the Fa only out of the unique voxels
        vox_faOCF{i}{ifib} = faOCF{i}{ifib}(ind);
        vox_mdOCF{i}{ifib} = mdOCF{i}{ifib}(ind);
        vox_adOCF{i}{ifib} = adOCF{i}{ifib}(ind);
        vox_rdOCF{i}{ifib} = rdOCF{i}{ifib}(ind);
    end
    % Compute the mean and the std of the tract
    stats_faOCF{i}  = prctile(vertcat(vox_faOCF{i}{:}),[5 33 50 66 95]);
    stats_mdOCF{i}  = prctile(vertcat(vox_mdOCF{i}{:}),[5 33 50 66 95]);
    stats_adOCF{i}  = prctile(vertcat(vox_adOCF{i}{:}),[5 33 50 66 95]);
    stats_rdOCF{i}  = prctile(vertcat(vox_rdOCF{i}{:}),[5 33 50 66 95]);
    
end

%% Plots of R-OR

X=1:22;
for k=1:length(stats_faROR)
    Mean{k} = stats_faROR{1,k}(3);
    p5{k}   = stats_faROR{1,k}(1);
    p95{k}  = stats_faROR{1,k}(5);
end

boxplot()


