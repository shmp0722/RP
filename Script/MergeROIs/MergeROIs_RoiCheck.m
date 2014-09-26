%% MergeROis_NOTROI.m
% merge ROIs to create Big NOT ROI.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% ctl HT does not have cerebellum segmentation file!
% If you want to creat ROI which include cerebelum,
% You should exclude HT, and create HT's ROI by hand.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
%    'JMD-Ctl-MT-20121025-DWI'
%     'JMD-Ctl-SY-20130222DWI'
%     'JMD-Ctl-YM-20121025-DWI'
%     'JMD-Ctl-HH-20120907DWI'
%     'JMD-Ctl-HT-20120907-DWI'
%     'JMD-Ctl-FN-20130621-DWI'
%     'JMD-Ctl-AM-20130726-DWI'
%     'JMD-Ctl-SO-20130726-DWI'};
%     'RP1-TT-2013-11-01'
    'RP2-KI-2013-11-01'};

%%loop subject
ROI = {};
for i =1:length(subDir)
    
    cd(fullfile(homeDir,subDir{i},'/dwi_2nd/ROIs'))
    
    ROI.name = {'Brain-Stem',...
        'Right-Cerebellum-White-Matter','Right-Cerebellum-Cortex',...
        'Left-Cerebellum-White-Matter','Left-Cerebellum-Cortex',...
        'Left-Hippocampus','Right-Hippocampus','Left-Lateral-Ventricle',...
        'Right-Lateral-Ventricle','Left-Cerebral-White-Matter',...
        'Right-Thalamus-Proper','Left-Thalamus-Proper',...
        };
    
    
    % load all ROIs
    for k = 1:length(ROI.name)
    ROI.roi{k} = dtiReadRoi(ROI.name{k});
    
    
    % make sure ROI
    if 1 == isempty(ROI.roi{k}.coords)
        disp(ROI.roi{k}.name)
        disp('number of corrds = 0')
        return;
    end;
    end
    
end

for  k= 1:21;
    length(roi{1,k}.coords)
end

