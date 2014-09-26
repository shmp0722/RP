%% fs_labelFileToNiftiRoi_Test.m
% to creat nifti Roi files from label files.
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

% set the dir and subject.
fsDir          = '/biac4/wandell/biac2/wandell/data/DWI-Tamagawa-Japan/freesurfer';
roiDir         = '/biac4/wandell/biac2/wandell/data/DWI-Tamagawa-Japan';
subject      = {...
    'JMD1-MM-20121025-DWI','JMD2-KK-20121025-DWI','JMD3-AK-20121026-DWI'...
    'JMD5-KK-20121220-DWI','JMD6-NO-20121220-DWI','LHON1-TK-20121130-DWI'...
    'LHON2-SO-20121130-DWI','LHON3-TO-20121130-DWI','LHON4-GK-20121130-DWI'...
    'LHON5-HS-20121220-DWI','LHON6-SS-20121221-DWI','JMD-Ctl-MT-20121025-DWI'...
    'JMD-Ctl-SY-20130222DWI','JMD-Ctl-YM-20121025-DWI','JMD-Ctl-HH-20120907DWI'...
    'JMD-Ctl-HT-20120907-DWI','JMD-Ctl-FN-20130621-DWI','JMD-Ctl-FN-20130621-DWI'...
};

% loop for subjects
for i = 21:length(subject)
    
    labelfile_name ={...
        'G_and_S_occipital_inf','G_cuneus','G_occipital_middle','G_occipital_sup'...
        'G_oc-temp_lat-fusifor','G_oc-temp_med-Lingual','Pole_occipital','S_calcarine'...
        'S_collat_transv_post','S_oc_middle_and_Lunatus','S_oc_sup_and_transversal'...
        'S_occipital_ant','S_oc-temp_lat','S_oc-temp_med_and_Lingual','S_parieto_occipital'...
        'cortex'};
%         'V1','V2','MT'} ;
% loop for label    
    for j = 1:length(labelfile_name)
        % loop for hemisphere
        for k = 1:2
            % define label file name
            fomatspec = '%s';
            hemi= {'lh.','rh.'};
            hemiLabelfileName = sprintf(fomatspec,hemi{k},labelfile_name{j});    
            labelfile    = sprintf('%s_smooth3mm.label',hemiLabelfileName);
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

