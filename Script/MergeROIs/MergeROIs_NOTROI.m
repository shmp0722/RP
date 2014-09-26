%% MergeROis_NOTROI.m
% merge ROIs to create Big NOT ROI.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% ctl HT does not have cerebellum segmentation file!
% If you want to creat ROI which include cerebelum,
% You should exclude HT, and create HT's ROI by hand.ssssssssss

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Set directory
homeDir = '/biac4/wandell/biac2/wandell/data/DWI-Tamagawa-Japan';

subDir = {...
        'JMD1-MM-20121025-DWI','JMD2-KK-20121025-DWI','JMD3-AK-20121026-DWI',...
        'JMD4-AM-20121026-DWI','JMD5-KK-20121220-DWI','JMD6-NO-20121220-DWI',...
        'JMD7-YN-20130621-DWI','JMD8-HT-20130621-DWI','JMD9-TY-20130621-DWI',...
        'LHON1-TK-20121130-DWI','LHON2-SO-20121130-DWI','LHON3-TO-20121130-DWI',...
        'LHON4-GK-20121130-DWI','LHON5-HS-20121220-DWI','LHON6-SS-20121221-DWI',...
        'JMD-Ctl-MT-20121025-DWI','JMD-Ctl-SY-20130222DWI','JMD-Ctl-YM-20121025-DWI',...
        'JMD-Ctl-HH-20120907DWI'};
    
subDir2 ='JMD-Ctl-HT-20120907-DWI';


%loop subject
for i = 1:length(subDir)
    
    cd(fullfile(homeDir,subDir{i},'/dwi_2nd/ROIs'))
    
    % ROI file names you want to merge
    for hemisphere = 1:2
        switch(hemisphere)
            case  1 % for  Left-WhiteMatter
                roiname = {'Brain-Stem',...
                    'Right-Cerebellum-White-Matter','Right-Cerebellum-Cortex',...
                    'Left-Cerebellum-White-Matter','Left-Cerebellum-Cortex',...
                    'Left-Hippocampus','Right-Hippocampus','Left-Lateral-Ventricle',...
                    'Right-Lateral-Ventricle','Left-Cerebral-White-Matter',...
                    'Right-Cerebral-Cortex_rh_V1_smooth3mm.mat'};
            case 2 % Right-WhiteMatter
                roiname = {'Brain-Stem',...
                    'Right-Cerebellum-White-Matter','Right-Cerebellum-Cortex',...
                    'Left-Cerebellum-White-Matter','Left-Cerebellum-Cortex',...
                    'Left-Hippocampus','Right-Hippocampus','Left-Lateral-Ventricle',...
                    'Right-Lateral-Ventricle','Right-Cerebral-White-Matter',...
                    'Left-Cerebral-Cortex_lh_V1_smooth3mm.mat'};
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
        
        % Save the new NOT ROI
        switch(hemisphere)
            case 1 % Left-WhiteMatter
                newROI.name = 'Lh_BigNotROI3';
            case 2 % Right-WhiteMatter
                newROI.name = 'Rh_BigNotROI3';
        end
        
        dtiWriteRoi(newROI,newROI.name,1)
    end
end

%% For Ctr-HT
cd(fullfile(homeDir,subDir2,'/dwi_2nd/ROIs'))

 % ROI file names you want to merge
    for hemisphere = 1:2
        switch(hemisphere)
            case  1 % Left-WhiteMatter
                roiname = {'Brain-Stem',...
                    ...'Right-Cerebellum-White-Matter','Right-Cerebellum-Cortex',...
                    ...'Left-Cerebellum-White-Matter','Left-Cerebellum-Cortex',...
                    'Left-Hippocampus','Right-Hippocampus','Left-Lateral-Ventricle',...
                    'Right-Lateral-Ventricle','Left-Cerebral-White-Matter',...
                    'Right-Cerebral-Cortex_rh_V1_smooth3mm.mat'};
            case 2 % Right-WhiteMatter
                roiname = {'Brain-Stem',...
                    ...'Right-Cerebellum-White-Matter','Right-Cerebellum-Cortex',...
                    ...'Left-Cerebellum-White-Matter','Left-Cerebellum-Cortex',...
                    'Left-Hippocampus','Right-Hippocampus','Left-Lateral-Ventricle',...
                    'Right-Lateral-Ventricle','Right-Cerebral-White-Matter',...
                    'Left-Cerebral-Cortex_lh_V1_smooth3mm.mat'};
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
        
        % Save the new NOT ROI
        switch(hemisphere)
            case 1 % Left-WhiteMatter
                newROI.name = 'Lh_BigNotROI3';
            case 2 % Right-WhiteMatter
                newROI.name = 'Rh_BigNotROI3';
        end
        
        dtiWriteRoi(newROI,newROI.name,1)
    end
