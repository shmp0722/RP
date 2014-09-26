function Netta30_GetRoi_PipeLine
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Set directory
homeDir = '/biac4/wandell/biac3/wandell4/data/reading_longitude/dti_adults';
fsDir   = fullfile(homeDir,'freesurfer');

% subs in colum
subJ ={'aab050307','ah051003','am090121','ams051015','as050307'...
    'aw040809','bw040922','ct060309','db061209','dla050311'...
    'gd040901','gf050826','gm050308','jl040902','jm061209'...
    'jy060309','ka040923','mbs040503','me050126','mo061209'...
    'mod070307','mz040828','pp050208','rfd040630','rk050524'...
    'sc060523','sd050527','sn040831','sp050303','tl051015'};

%% fs_mgzSegToNifti.m
% create aparc+aseg.nii.gz from .mgz

% subject loop
parfor i = 1:length(subJ)
    mgzInDir = fullfile(fsDir,subJ{i},'/mri');
    mgzInF = {'aparc+aseg','aseg','aparc.a2009s+aseg','brain.finalsurfs','brainmask.auto','wm'};
    for k = 1:length(mgzInF)
        mgzIn = sprintf('%s.mgz',fullfile(mgzInDir, mgzInF{k}));
        refImg = fullfile(homeDir,subJ{i},'t1','t1.nii.gz');
        outName = sprintf('%s.nii.gz',fullfile(mgzInDir,mgzInF{k}));
        orient = 'RAS';
        fs_mgzSegToNifti(mgzIn, refImg, outName, orient)
    end
end

%% fs_aparcAsegLabelToNiftiRoi.m
% Create ROI.mat from aseg.nii.gz (especially Cerebral Cortex).
% the other way is fs_ribbon2itk.m
labelVal = {'42','3'};
outfileName = {'Right-Cerebral-Cortex','Left-Cerebral-Cortex'};

parfor i = 1:length(subJ)
    matRoiDir = fullfile(homeDir,subJ{i},'dwi_2nd/ROIs');

    %loop for every label
    
    for ii =1:length(outfileName);
        fsInDir =fullfile(fsDir,subJ{i},'mri');
        cd(fsInDir)
        fsIn = fullfile(fsDir,subJ{i},'mri', 'aseg.nii.gz');
        % create and save nifti ROI in 'fs/mri' directory
        savefile =fullfile(fsDir,subJ{i},'mri',outfileName{ii});
        fs_aparcAsegLabelToNiftiRoi(fsIn,labelVal{ii},savefile)
        
        % Save '.mat' ROI in /ROIs directory
        % Set parameters
        nifti       = sprintf('%s.nii.gz',savefile);
        maskValue   = 0; % All nonZero values are used for the mask
        outFile     = sprintf('%s.mat',savefile);
        outType     = 'mat';  binary = true; save = true;
        
        % run dtiRoiFromNifti and Save mat Roi in ROIs directory
        roi = dtiRoiFromNifti(nifti,maskValue,outFile,outType,binary,0);
        cd(matRoiDir)
        dtiWriteRoi(roi,outfileName{ii})
        
        
    end
end
%% Create fs.mat ROI from aparc+ase.nii.gz
% loop for each subject
parfor i =1:length(subJ);
    %     cd(mgzInDir)
    
    fsIn =fullfile(fsDir,subJ{i},'mri','aparc+aseg.nii.gz');
    
    %% Run fs_aparcAsegLabelToNiftiRoi
    
    labelVal = {...
                '1021'
                '2021'
                '85'
                '4'
                '43'
                '17'
                '53'
                '12'
                '51'
                '2'
                '41'
                '251'
                '252'
                '253'
                '254'
                '255'
                '9'
                '10'
                '48'
                '49'
                '16'
                '24'
                '7'
                '8'
                '46'
                '47'
                '219'
                '220'
                '16'
%         '400'
%         '401'
        };
    
    
    outfileName = {...
                'ctx-lh-pericalcarine'
                'ctx-rh-pericalcarine'
                'Optic-Chiasm'
                'Left-Lateral-Ventricle'
                'Right-Lateral-Ventricle'
                'Left-Hippocampus'
                'Right-Hippocampus'
                'Left-Putamen'
                'Right-Putamen'
                'Left-Cerebral-White-Matter'
                'Right-Cerebral-White-Matter'
                'CC_Posterior'
                'CC_Mid_Posterior'
                'CC_Central'
                'CC_Mid_Anterior'
                'CC_Anterior'
                'Left-Thalamus'
                'Left-Thalamus-Proper'
                'Right-Thalamus'
                'Right-Thalamus-Proper'
                'Brain-Stem'
                'CSF'
                'Left-Cerebellum-White-Matter'
                'Left-Cerebellum-Cortex'
                'Right-Cerebellum-White-Matter'
                'Right-Cerebellum-Cortex'
                'Cerebral_White_Matter'
                'Cerebral_Cortex'
                'Brain-Stem'
%         'V1'
%         'V2'
        };
    
    
    %loop for every file
    
    for ii = 1:length(outfileName);
        
        % save nifti ROI in mri directory
        savefile =fullfile(fsDir,subJ{i},'mri',outfileName{ii});
        fs_aparcAsegLabelToNiftiRoi(fsIn,labelVal{ii},savefile)
        
        % Save 'mat' ROI in ROIs directory
        % Set parameters
        nifti       =  sprintf('%s.nii.gz',savefile);
        maskValue   =  0;       % All nonZero values are used for the mask
        outName     = sprintf('%s.mat',outfileName{ii});
        outFile     = fullfile(homeDir,subJ{i},'dwi_2nd','ROIs',outName);
        outType     = 'mat';  binary = true; save = true;
        
        % run dtiRoiFromNifti
        dtiRoiFromNifti(nifti,maskValue,outFile,outType,binary,save);
        
    end
end

%% create V1,V2 ROI.mat from label file
% If you finish fs_Autosegmentation. You already have V1,V2, and MT label file.
% If you want to get other file. SEE: fs_annotationToLabelFiles.m
% Try 'aparc.annot.a2009s.ctab' as annotation.
% loop for subjects
for i = 1:length(subJ)
    % loop for hemisphere
    for k = 1:2
        hemisphere     = {'lh','rh'};
        annotation     = 'aparc';
%                        = 'aparc.annot.a2009s.ctab';
        annotationFile = fullfile(fsDir,subJ{i},'label',annotation);
        regMgzFile    = fullfile(fsDir,subJ{i},'/mri/rawavg.mgz');
        
        cmd            = fs_annotationToLabelFiles(subJ{i},annotationFile,hemisphere{k});
        
        labelfile_name ={...
            %             'G_and_S_occipital_inf','G_cuneus','G_occipital_middle','G_occipital_sup'...
            %             'G_oc-temp_lat-fusifor','G_oc-temp_med-Lingual','Pole_occipital','S_calcarine'...
            %             'S_collat_transv_post','S_oc_middle_and_Lunatus','S_oc_sup_and_transversal'...
            %             'S_occipital_ant','S_oc-temp_lat','S_oc-temp_med_and_Lingual','S_parieto_occipital'...
            'V1','V2'};%,'MT'} ;
        
        % loop for label
        for j = 1:length(labelfile_name)    
            %% ROI not delated
            % define label file name
            hemi= {'lh','rh'};
            hemiLabelfileName = sprintf('%s.%s',hemi{k},labelfile_name{j});
            labelfile    = sprintf('%s.label',hemiLabelfileName);
            labelFileName = fullfile(fsDir,subJ{i},'label',labelfile);
            
            % define ROI name
            niftiRoiName  = fullfile(fsDir,subJ{i},'label',hemiLabelfileName);
            regMgzFile    = fullfile(fsDir,subJ{i},'mri/rawavg.mgz');
            
            % run fs_labelFileToNiftiRoi
            fs_labelFileToNiftiRoi(subJ{i},labelFileName,niftiRoiName,hemi{k},regMgzFile);
            
            % Save 'mat' ROI in ROIs directory
            % Set parameters
            niftiRoiName(niftiRoiName == '.') = '_';
            nifti = sprintf('%s.nii.gz',niftiRoiName);
            maskValue   =  0;       % All nonZero values are used for the mask
            
            hemiLabelfileName(hemiLabelfileName == '.') = '_';
            outName     = sprintf('%s.mat',hemiLabelfileName);
            outFile     = fullfile(homeDir,subJ{i},'dwi_2nd','ROIs',outName);
            outType     = 'mat';  binary = true; save = true;
            
            % run dtiRoiFromNifti
            dtiRoiFromNifti(nifti,maskValue,outFile,outType,binary,save);
            
            
            %% ROI 3mm smooth
            % define label file name
            hemiLabelfileName = sprintf('%s.%s',hemi{k},labelfile_name{j});
            labelfile     = sprintf('%s_smooth3mm',hemiLabelfileName);
            labelFileName = sprintf('%s.label',fullfile(fsDir,subJ{i},'label',labelfile));
            
            % define ROI name
            niftiRoiName  = fullfile(fsDir,subJ{i},'label',labelfile);
            % regMgzFile    = fullfile(fsDir,subJ{i},'/mri/rawavg.mgz');
            % run fs_labelFileToNiftiRoi
            % fs_labelFileToNiftiRoi(subJ{i},labelFileName,niftiRoiName,hemi{k},regMgzFile);
            
            % Save 'mat' ROI in ROIs directory
            % Set parameters
            niftiRoiName(niftiRoiName == '.') = '_';
            nifti = sprintf('%s.nii.gz',niftiRoiName);
            maskValue   =  0;       % All nonZero values are used for the mask
            
            hemiLabelfileName(hemiLabelfileName == '.') = '_';
            outName     = sprintf('%s_smooth3mm.mat',hemiLabelfileName);
            outFile     = fullfile(homeDir,subJ{i},'dwi_2nd','ROIs',outName);
            %             outType     = 'mat';  binary = true; save = true;
            
            % run dtiRoiFromNifti
            dtiRoiFromNifti(nifti,maskValue,outFile,outType,binary,save);
            
        end
    end
end

%% Lets clip V1_smooth3mm.mat
% SO_dtiRoiClip_V1_3mm
%
% this code give me more posterior part of V13mm_smooth than -60mm

%% lets remove V1_smooth 3mm_NOT from cerebral cortex
% SO_dtiRoiClean_GM.m

%%
%  SO_dtiRestrictToImageValueRange.m

%% Merge big NotROI and Wm

% run MergeROIs_NOTROI5.m and MergeROIs_Wm.m
%




