%% SO_dtiROIDiffusivities.m
% Calcurate diffusivities of ROI. Tentative trial is Optic-chiasm.
%
%
%% Set the path to data directory
[homeDir,subDir] = Tama_subj;

%% get ROI diffusivities and volume

for i = 1:length(subDir);
    
    SubDir = fullfile(homeDir,subDir{i});
    fgDir  = fullfile(SubDir,'/dwi_2nd/fibers');
    roiDir = fullfile(SubDir,'/dwi_2nd/ROIs');
    dtDir  = fullfile(homeDir,subDir{i},'dwi_2nd');
    
    % define files
    roi = fullfile(roiDir,'Optic-Chiasm.mat');
    dt  = fullfile(dtDir,'dt6.mat');
    
    roi = dtiReadRoi(roi);
    dt  = dtiLoadDt6(dt);
    %1. Get coords from ROI-- roi.coords!
    %2. Compute FA, MD, RD properties for ROI
    [val1,val2,val3,val4,val5,val6] =...
        dtiGetValFromTensors(dt.dt6, roi.coords, inv(dt.xformToAcpc),'dt6','nearest');
    dt6 = [val1,val2,val3,val4,val5,val6];
    [vec,val] = dtiEig(dt6);
    
    % diffusivities
    [fa{i},md{i},rd{i},ad{i}] = dtiComputeFA(val);
    
    % volume
    t1 = readFileNifti(fullfile(SubDir,'t1.nii.gz'));
    v{i} = dtiGetRoiVolume(roi,t1,dt);    
     
end

for i = 1:length(subDir)
volume{i} =   v{i}.volume;
end

OC_Volume = mat2dataset(volume);
OC_fa = mat2dataset(fa);
OC_md = mat2dataset(md);
OC_ad = mat2dataset(ad);
OC_rd = mat2dataset(rd);

% See exampleFgAnalysisForTama

