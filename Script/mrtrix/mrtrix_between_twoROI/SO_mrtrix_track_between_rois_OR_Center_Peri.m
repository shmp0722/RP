function fibersPDB = SO_mrtrix_track_between_rois_OR_Center_Peri
%
% This functions shows how to track between two ROIS using mrtrix.
% This s very helpful for ideintifying some fiber groups for example the
% optic radiation.
%
% This is how the code works.
% 1. We load two ROIs in the brain, for Shumpei's project for example we
%    will load the right-LGN and the right-Visual cortex
% 2. We create union ROI by combining these two ROIs. The union ROI is used
%    as seeding for the fibers. mrtrix will initiate and terminate fibers only
%    within the volume defined by the Union ROI.
% 3. We create a white matter mask. THis mask is generally a large portion
%    of the white matter. A portion that contains both union ROIs. For example
%    the right hemisphere.
% 4. We use mrtrix to track between the right-LGN and righ-visual cortex.
% mrtrix will initiate fibers by seeding within the UNION ROI and it will
% only keep fibers that have paths within the white matter masks.
%
% The final result of this script is to generate lot's of candate fibers
% that specifically end and start from the ROI of interest. This is an
% approach similar to Contrack.
%
% INPUTS: none
% OUTPUTS: the finela name of the ROI created at each iteration
%
% Written by Franco Pestilli (c) Stanford University Vistasoft

%%
baseDir = '/biac4/wandell/biac2/wandell/data/DWI-Tamagawa-Japan';

subjDir = {...
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
    'JMD-Ctl-AM-20130726-DWI'
    'JMD-Ctl-SO-20130726-DWI'
    'RP1-TT-2013-11-01'
    'RP2-KI-2013-11-01'
    'RP3-TO-13120611-DWI'};

%% Set directory % JMD4(i = 4), HH(19), Ht(20) didn't work
for i = 2:length(subjDir);
    
    dtFile = fullfile(baseDir, subjDir{i}, '/dwi_2nd/dt6.mat');
    refImg = fullfile(baseDir, subjDir{i}, '/t1.nii.gz');
    fibersFolder = fullfile(baseDir, subjDir{i}, '/dwi_2nd/fibers/mrtrix_OR_center_peri');
    if ~exist(fibersFolder); mkdir(fibersFolder);end
%     cd(fibersFolder)
    roisFolder   = fullfile(baseDir, subjDir{i}, '/dwi_2nd/ROIs');
    
    % We want to track the cortical pathway (LGN -> V1/V2 and V1/V2 -> MT)
    
    %     for hemi = 1:2 % R = 1, L= 2;
    fromRois = {'Rt-LGN4','Lt-LGN4','Rt-LGN4','Lt-LGN4'};
    toRois   = {'rh_V1_Center','lh_V1_Center','rh_V1_Peri','lh_V1_Peri'};
    
    for k = 1:length(fromRois)
        % Set up the MRtrix trakign parameters
        trackingAlgorithm = {'prob'};
        lmax    = [2]; % The appropriate value depends on # of directions. For 32, use lower #'s like 4 or 6. For 70+ dir, 6 or 10 is good [10];
        
        %         wmMask  = '/biac4/wandell/biac2/wandell/data/DWI-Tamagawa-Japan/JMD4-AM-20121026-DWI/dwi_2nd/bin/wmMask.nii.gz';
        wmMask  = [];
        
        % Make an (include) white matter mask ROI. This mask is the smallest
        % set of white matter that contains both ROIS (fromRois and toRois)
        %
        % We use a nifti ROi to select the portion of the White matter to use for
        % seeding
        switch fromRois{k}
            case 'Rt-LGN4'
                Hemi_wm = 'Right-Cerebral-White-Matter_Rt-LGN4';
            case 'Lt-LGN4'
                Hemi_wm = 'Left-Cerebral-White-Matter_Lt-LGN4';
        end
        
        
        wmMaskName      = fullfile(baseDir,  subjDir{i}, '/dwi_2nd/ROIs',Hemi_wm);
        [~, wmMaskName] = dtiRoiNiftiFromMat(wmMaskName,refImg,wmMaskName,1);
        
        % Then transform the niftis into .mif
        [p,f,e] = fileparts(wmMaskName);
        wmMaskMifName    = fullfile(p,sprintf('%s.mif',f));
        wmMaskNiftiName  = sprintf('%s.nii.gz',wmMaskName);
        mrtrix_mrconvert(wmMaskNiftiName, wmMaskMifName);
        
        % This first step initializes all the files necessary for mrtrix.
        % This can take a long time.
        files = SO_mrtrix_init(dtFile,lmax,fibersFolder,wmMask);
%                 files = mrtrix_init(dtFile,lmax,fibersFolder,wmMask);

        % We use a nifti ROI to select the portion of the White matter to use for
        % seeding
        %
        fromRoisName      = fullfile(roisFolder,fromRois{k});
        [~, fromRoisName] = dtiRoiNiftiFromMat(fromRoisName,refImg,fromRoisName,1);
        
        % Then transform the niftis into .mif
        [p,f,e] = fileparts(fromRoisName);
        fromRoisFName    = fullfile(p,sprintf('%s.mif',f));
        fromRoisNiftiName  = sprintf('%s.nii.gz',fromRoisName);
        mrtrix_mrconvert(fromRoisNiftiName, fromRoisFName);
        %
        toRoisName      = fullfile(roisFolder,toRois{k});
        [~, toRoisName] = dtiRoiNiftiFromMat(toRoisName,refImg,toRoisName,1);
        
        % Then transform the niftis into .mif
        [p,f,e] = fileparts(toRoisName);
        toRoisFName    = fullfile(p,sprintf('%s.mif',f));
        toRoisNiftiName  = sprintf('%s.nii.gz',toRoisName);
        mrtrix_mrconvert(toRoisNiftiName, toRoisFName);
        
        
        % Create joint from/to Rois to use as a mask
        
        % MRTRIX tracking between 2 ROIs template.
        roi{1} = fullfile(roisFolder, fromRois{k});
        roi{2} = fullfile(roisFolder, toRois{k});
        
        roi1 = dtiReadRoi([roi{1} '.mat']);
        roi2 = dtiReadRoi([roi{2} '.mat']);
        
        % Merge form and to ROI in one
        newROI = dtiMergeROIs(roi1,roi2);
        
        % Save newROI
        dtiWriteRoi(newROI, newROI.name)
        
        % Make a union ROI to use as a seed mask:
        % We will generate as many seeds as requested but only inside the voume
        % defined by the Union ROI.
        %
        % The union ROI is used as seed, fibers will be generated starting Only
        % within this union ROI.
        
        roiUnion        = newROI; % seed union roi with roi1 info
        %             roiUnion.name   = ['union of ' roi1.name ' and ' roi2.name]; % r lgn calcarine';
        %             roiUnion.coords = vertcat(roiUnion.coords,roi2.coords);
        
        % transform ROI into .mif
        ref   = niftiRead(refImg);
        xform = ref.qto_xyz;
        bb    = [-size(ref.data)/2; size(ref.data)/2-1];
        
        %% Create the roiImg and xForm from the roi
        [roiImg, imgXform] = dtiRoiToImg(newROI,xform,bb);
        
        %% Set ROI as a nifti struct and save
        ni = niftiGetStruct(uint8(roiImg),imgXform);
        ni.fname = newROI.name;
        cd(roisFolder)
        niftiWrite(ni);
        
        % Set file names
        roiName         = fullfile(baseDir, subjDir{i}, '/ROIs/',ni.fname);
        [~, seedMask]   = dtiRoiNiftiFromMat(roiUnion,refImg,roiName,1);
        seedRoiNiftiName= sprintf('%s.nii.gz',seedMask);
        seedRoiMifName  = sprintf('%s.mif',seedMask);
        
        % Transform the niftis into .mif
        mrtrix_mrconvert(seedRoiNiftiName, seedRoiMifName);
        
        % We cd into the folder where we want to see the fibers.
        cd(fibersFolder);
        
        nSeeds  = 500000; % 10000;
        nFibers = 5000000; %1000000;
        
        % We genrate and save the fibers in the current folder.
        [fibersPDB{k}, status, results] = mrtrix_track_roi2roi(files, [roi{1} '.mif'], [roi{2} '.mif'], ...
            seedRoiMifName, wmMaskMifName, trackingAlgorithm{1}, ...
            nSeeds, nFibers);
    end
    % fgWrite(fibersPDB,['fibername'],'pwd')
end

%% exclude unneccesary fiber by fiber length

return
