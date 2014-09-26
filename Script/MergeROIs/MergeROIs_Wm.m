%% Merge ROIs
% merge ROIs for feClip

% Set directory
homeDir = '/biac4/wandell/biac2/wandell/data/DWI-Tamagawa-Japan';

subDir = {...
%     'JMD1-MM-20121025-DWI'
%     'JMD2-KK-20121025-DWI'
%     'JMD3-AK-20121026-DWI'
%     'JMD4-AM-20121026-DWI'
%     'JMD5-KK-20121220-DWI'
%     'JMD6-NO-20121220-DWI'
%     'JMD7-YN-20130621-DWI'
%     'JMD8-HT-20130621-DWI'
%     'JMD9-TY-20130621-DWI'
%     'LHON1-TK-20121130-DWI'
%     'LHON2-SO-20121130-DWI'
%     'LHON3-TO-20121130-DWI'
%     'LHON4-GK-20121130-DWI'
%     'LHON5-HS-20121220-DWI'
%     'LHON6-SS-20121221-DWI'
%     'JMD-Ctl-MT-20121025-DWI'
%     'JMD-Ctl-SY-20130222DWI'
%     'JMD-Ctl-YM-20121025-DWI'
%     'JMD-Ctl-HH-20120907DWI'
%     'JMD-Ctl-HT-20120907-DWI'
%     'JMD-Ctl-FN-20130621-DWI'
%     'JMD-Ctl-AM-20130726-DWI'
%     'JMD-Ctl-SO-20130726-DWI'
    'RP1-TT-2013-11-01'
     'RP2-KI-2013-11-01'
    'RP3-TO-13120611-DWI'};

%%loop subject
for i = 1:length(subDir)
    
    cd(fullfile(homeDir,subDir{i},'/dwi_2nd/ROIs'))
    
    % ROI file names you want to merge
    for k=1:2;
        switch k
            case 1
                roiname = {'Left-Cerebral-White-Matter','Lt-LGN4'};%,'Left-Thalamus-Proper'};
            case 2
                roiname = {'Right-Cerebral-White-Matter','Rt-LGN4'};%,'Right-Thalamus-Proper'};
        end
        % load all ROIs
        for j = 1:length(roiname)
            roi{j} = dtiReadRoi(roiname{j});
        end
        
        % Merge ROI one by one
        newROI = roi{1,1};
        for kk=2:length(roiname)
            newROI = dtiMergeROIs(newROI,roi{1,kk});
        end
        switch k
            case 1
                newROI.name = 'Left-Cerebral-White-Matter_Lt-LGN4';%,'Left-Thalamus-Proper'};
            case 2
                newROI.name = 'Right-Cerebral-White-Matter_Rt-LGN4';%,'Right-Thalamus-Proper'};
        end
        
        % Save the new NOT ROI
        dtiWriteRoi(newROI,newROI.name,1)
    end
end
%% WMmask
for i = 1:length(subDir)
    
    cd(fullfile(homeDir,subDir{i},'/dwi_2nd/ROIs'))
    
    % ROI file names you want to merge
    roiname = {'Left-Cerebral-White-Matter_Lt-LGN4'
        'Right-Cerebral-White-Matter_Rt-LGN4'
        'fs_CC'
        'Left-Thalamus-Proper'
        'Right-Thalamus-Proper'};%,'Left-Thalamus-Proper'};
    
    % load all ROIs
    for j = 1:length(roiname)
        roi{j} = dtiReadRoi(roiname{j});
    end
    
    % Merge ROI one by one
    newROI = roi{1,1};
    for kk=2:length(roiname)
        newROI = dtiMergeROIs(newROI,roi{1,kk});
    end
    newROI.name = 'WMmask';
    % Save the new NOT ROI
    dtiWriteRoi(newROI,newROI.name,1)
    % Save new niROI
    imagef = fullfile(homeDir,subDir{i},'t1.nii.gz'); 
    ni = dtiRoiNiftiFromMat(newROI,imagef);
    
end