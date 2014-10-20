% cmd = fs_annotationToLabelFiles(fs_subject,annotationFileName,hemisphere,labelsDir)
%
% Creates .label files from a FreeSurfer annotation file, which is created
% during the reconall segementation and percellation process.
%
%  cmd = fs_annotationToLabelFiles(fs_subject,[annotationFileName],[hemisphere],[regMgzFile])
%
% 
% INPUTS:
%      fs_subject    - The FreeSurfer folder for the subject. It is
%                      a folder under $SUBJECTS_DIR
%      annotationFileName - The fullpath to a .annotation FreeSurfer file.
%      hemisphere    - Optional. Either 'lh' or 'rh'. This is necessary to load the
%                      FreeSurfer surface and fill in the ROi into the
%                      gray matter. If this inptu is omitted we assume that
%                      the labelFileName lives under: 
%                      $SUBJECTS_DIR/<this_subject>/label/
%                      and that the file name starts with either 'lh' or
%                      'rh' which is the standard for labels created
%                      automatically with the FreeSurfer autsegmentation.
% 
%      regMgzFile    - Optional. The fullpath to a file to be used for registering
%                      the nifti ROI. Generally we register everything to
%                      ACPC, which means to the T1 volume. 
%                      If the regMgzFile is NOT passed in and the file 
%                      $SUBJECTS_DIR/<this_subject>/mri/rawavg.mgz exists,
%                      we align automatically to such file. Which is our
%                      standard for ACPC.
%
% OUTPUTS:
%        cmd - is a cell array with the FreeSurfer commands launched in the shell.
%              Note: .label files will be written directly on disk. A list of
%              the files will be shown in the matlab prompt.
% 
% EXAMPLE USAGE: 
%   fsDir          = getenv('SUBJECTS_DIR');
%   subject        = 'subject';
%   hemisphere     = 'lh'; 
%   annotation     = 'aparc'; 
%   annotationFile = fullfile(fsDir,subject,'label',annotation);
%   cmd            = fs_annotationToLabelFiles(subject,annotationFile)
%
% Written by Franco Pestilli (c) Stanford University, Vistasoft 2013
fsDir          = getenv('SUBJECTS_DIR');
subject      = {...   
%     'JMD1-MM-20121025-DWI'...
%     'JMD2-KK-20121025-DWI'...
%     'JMD3-AK-20121026-DWI'...
%     'JMD4-AM-20121026-DWI'...
%     'JMD5-KK-20121220-DWI'...
%     'JMD6-NO-20121220-DWI'...
%     'JMD7-YN-20130621-DWI'...
%     'JMD8-HT-20130621-DWI'...
%     'JMD9-TY-20130621-DWI'...
%     'LHON1-TK-20121130-DWI'...
%     'LHON2-SO-20121130-DWI'...
%     'LHON3-TO-20121130-DWI'...
%     'LHON4-GK-20121130-DWI'...
%     'LHON5-HS-20121220-DWI'...
%     'LHON6-SS-20121221-DWI'...
%     'JMD-Ctl-MT-20121025-DWI'...
%     'JMD-Ctl-YM-20121025-DWI'...
%     'JMD-Ctl-SY-20130222DWI'...
%     'JMD-Ctl-HH-20120907DWI'...
%     'JMD-Ctl-HT-20120907-DWI'...
    'JMD-Ctl-FN-20130621-DWI'};


% loop for subjects
for i = 1:length(subject)
    % loop for hemisphere
    for k = 1:2
        roiDir         = '/biac4/wandell/biac2/wandell/data/DWI-Tamagawa-Japan';
        hemisphere     = {'lh','rh'};
        annotation     = 'aparc';
        annotationFile = fullfile(fsDir,subject{i},'label',annotation);
        regMgzFile    = fullfile(fsDir,subject{i},'/mri/rawavg.mgz');

        cmd            = fs_annotationToLabelFiles(subject,annotationFile,hemisphere{k});
        
        labelfile_name ={...
%             'G_and_S_occipital_inf','G_cuneus','G_occipital_middle','G_occipital_sup'...
%             'G_oc-temp_lat-fusifor','G_oc-temp_med-Lingual','Pole_occipital','S_calcarine'...
%             'S_collat_transv_post','S_oc_middle_and_Lunatus','S_oc_sup_and_transversal'...
%             'S_occipital_ant','S_oc-temp_lat','S_oc-temp_med_and_Lingual','S_parieto_occipital'...
            'V1','V2','MT'} ;
        % loop for label
        for j = 1:length(labelfile_name)
            
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

