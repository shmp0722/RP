function fs_labelFileToNiftiRoi_V1segmentation
% to creat nifti Roi files from label files. Especially the ROIs devided V1 into 3 portions
% by hand.
% 
% lh_V1_fovea.label ,lh_V1_fovea_dorsal.label , lh_V1_fovea_ventral.label 
% lh_V1_parafovea.label , lh.V1
% lh_V1_peripheral.label
% lh_V1_


% Now lets get 'Bock S et al. Neuroimage2013' ROIs.
%
% The V1 ROI included the following cortical labels:
%  2 — G_and_S_occipital_inf;
% 11 — G_cuneus;
% 19 — G_occipital_middle;
% 20 — G_occipital_sup;
% 21 — G_oc-temp_lat-fusifor;
% 22 — G_oc-temp_med-Lingual;
% 43 — Pole_occipital; 
% 45 — S_calcarine; 
% 52 — S_collat_transv_post; 
% 58 — S_oc_middle_and_Lunatus; 
% 59 — S_oc_sup_and_transversal;
% 60 — S_occipital_ant; 
% 61 — S_oc-temp_lat; 
% 62 — S_oc-temp_med_and_Lingual; 
% 66 — S_parieto_occipital
%
% See also 

% set the dir and subject.
fsDir          = '/biac4/wandell/biac2/wandell/data/DWI-Tamagawa-Japan/freesurfer';
roiDir         = '/biac4/wandell/biac2/wandell/data/DWI-Tamagawa-Japan';
subject      = {... 
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
%% loop for subjects
for i = 23:length(subject)
    
    labelfile_name ={...
%         'G_and_S_occipital_inf','G_cuneus','G_occipital_middle','G_occipital_sup'...
%         'G_oc-temp_lat-fusifor','G_oc-temp_med-Lingual','Pole_occipital','S_calcarine'...
%         'S_collat_transv_post','S_oc_middle_and_Lunatus','S_oc_sup_and_transversal'...
%         'S_occipital_ant','S_oc-temp_lat','S_oc-temp_med_and_Lingual','S_parieto_occipital'...
%  'cortex','MT' };      
%  'V1','V2'} ;
'V1_fovea','V1_parafovea','V1_peripheral'};

% lh_V1_fovea.label ,lh_V1_fovea_dorsal.label , lh_V1_fovea_ventral.label 
% lh_V1_parafovea.label , lh.V1
% lh_V1_peripheral.label
% lh_V1_



% loop for label    
    for j = 1:length(labelfile_name)
        % loop for hemisphere
        for k = 1:2
            % define label file name
            fomatspec = '%s';
            hemi= {'lh.','rh.'};
            hemiLabelfileName = sprintf(fomatspec,hemi{k},labelfile_name{j});    
            labelfile    = sprintf('%s.label',hemiLabelfileName);
            labelFileName = fullfile(fsDir,subject{i},'label',labelfile);
            
            % define ROI name
            niftiRoiName  = fullfile(fsDir,subject{i},'label',hemiLabelfileName);
            hemisphere    =  {'lh','rh'};
            regMgzFile    = fullfile(fsDir,subject{i},'/mri/rawavg.mgz');
            
            % run fs_labelFileToNiftiRoi
            fs_labelFileToNiftiRoi(subject{i},labelFileName,niftiRoiName,hemisphere{k},regMgzFile);
        end
    end
end
 %% ROI 3mm smooth
            % define label file name
            hemiLabelfileName = sprintf('%s.%s',hemi{k},labelfile_name{j});
            labelfile     = sprintf('%s_smooth3mm',hemiLabelfileName);
            labelFileName = sprintf('%s.label',fullfile(fsDir,subJ{i},'label',labelfile));
            
            % define ROI name
            niftiRoiName  = fullfile(fsDir,subJ{i},'label',labelfile);

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




