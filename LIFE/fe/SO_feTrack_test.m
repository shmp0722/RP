%% SO_feTrack_test.m
% Whole brain tractography using Mrtrix
[homeDir,subDir] = Tama_subj2;

%% matlabpool
% if you want to do simultaneously
matlabpool open 8

%% generate fibers 
parfor i = 2:10;    
    SubDir = fullfile(homeDir,subDir{i});
    fgDir  = fullfile(SubDir,'/dwi_2nd/fibers/mrtrix_WB');
    rawDir = fullfile(SubDir,'raw');
    dt6  = fullfile(SubDir,'dwi_2nd','dt6.mat');   
    
    % Organize directory structure. Because I moved these files into raw directory by hand before. 
    % The information in dt6 file does not match with precise path  
    cd(rawDir)
    if exist('dwi2nd_aligned_trilin.bvals'); copyfile('dwi2nd_aligned_trilin.bvals',SubDir);end
    if exist('dwi2nd_aligned_trilin.bvecs'); copyfile('dwi2nd_aligned_trilin.bvecs',SubDir);end
    if exist('dwi2nd_aligned_trilin.nii.gz'); copyfile('dwi2nd_aligned_trilin.nii.gz',SubDir);end

    %% feTrack    
    trackingAlgorithm = 'prob'; dtFile =dt6; fibersFolder = fgDir; lmax =2; nSeeds = 500000; wmMask = [];
    
    [status, results, fg, pathstr] = SO_feTrack(trackingAlgorithm, dtFile,fibersFolder,lmax,nSeeds,wmMask);
end
return
%%
parfor i = 11:length(subDir);    
    SubDir = fullfile(homeDir,subDir{i});
    fgDir  = fullfile(SubDir,'/dwi_2nd/fibers/mrtrix_WB');
    rawDir = fullfile(SubDir,'raw');
    dt6  = fullfile(SubDir,'dwi_2nd','dt6.mat');   
    
    % Organize directory structure. Because I moved these files into raw directory by hand before. 
    % The information in dt6 file does not match with precise path  
    cd(rawDir)
    if exist('dwi2nd_aligned_trilin.bvals'); copyfile('dwi2nd_aligned_trilin.bvals',SubDir);end
    if exist('dwi2nd_aligned_trilin.bvecs'); copyfile('dwi2nd_aligned_trilin.bvecs',SubDir);end
    if exist('dwi2nd_aligned_trilin.nii.gz'); copyfile('dwi2nd_aligned_trilin.nii.gz',SubDir);end

    %% feTrack    
    trackingAlgorithm = 'prob'; dtFile =dt6; fibersFolder = fgDir; lmax =2; nSeeds = 500000; wmMask = [];
    
    [status, results, fg, pathstr] = SO_feTrack(trackingAlgorithm, dtFile,fibersFolder,lmax,nSeeds,wmMask);
end


matlabpool close;
