% set the dir and subject.
fsDir          = '/biac4/wandell/biac2/wandell/data/DWI-Tamagawa-Japan/freesurfer';
cd(fsDir)
roiDir         = '/biac4/wandell/biac2/wandell/data/DWI-Tamagawa-Japan';
subject      = {...
    'JMD1-MM-20121025-DWI','JMD2-KK-20121025-DWI','JMD3-AK-20121026-DWI'...
    'JMD4-AM-20121026-DWI','JMD5-KK-20121220-DWI','JMD6-NO-20121220-DWI'...
    'LHON1-TK-20121130-DWI','LHON2-SO-20121130-DWI','LHON3-TO-20121130-DWI'...
    'LHON4-GK-20121130-DWI','LHON5-HS-20121220-DWI','LHON6-SS-20121221-DWI'...
    'JMD-Ctl-MT-20121025-DWI','JMD-Ctl-SY-20130222DWI','JMD-Ctl-YM-20121025-DWI'...
    'JMD-Ctl-HH-20120907DWI','JMD-Ctl-HT-20120907-DWI'};

%%  creat a mat ROI from a nifti ROI.

% loop for subjects
for i = 1:length(subject)
        labelfile_name ={...
%         'G_and_S_occipital_inf','G_cuneus','G_occipital_middle','G_occipital_sup'...
%         'G_oc-temp_lat-fusifor','G_oc-temp_med-Lingual','Pole_occipital','S_calcarine'...
%         'S_collat_transv_post','S_oc_middle_and_Lunatus','S_oc_sup_and_transversal'...
%         'S_occipital_ant','S_oc-temp_lat','S_oc-temp_med_and_Lingual','S_parieto_occipital'...
%         'V1','V2','MT'
        'CC_Posterior','CC_Mid_Posterior','CC_Central','CC_Mid_Anterior','CC_Anterior'};
% loop for label    
    for j = 1:length(labelfile_name)
       
      
            % define label file name 
            fomatspec = '%s';
         
            hemiLabelfileName = sprintf(fomatspec,labelfile_name{j});    
            labelfile    = sprintf('%s.nii.gz',labelfile_name{j});
            labelFileName = fullfile(fsDir,subject{i},'mri',labelfile);
            
            % set parameters
            nifti       =  labelFileName;
            maskValue   =  0;       % All nonZero values are used for the mask                
            outName     = sprintf('%s.mat',hemiLabelfileName);
            outFile     = fullfile(roiDir,subject{i},'dwi_2nd','ROIs',outName);
            outType     = 'mat';
            binary      = true;
            save        = true;
            
            % run main
            dtiRoiFromNifti(nifti,maskValue,outFile,outType,binary,save);
        
    end
end