%%

AFQdata = '/biac4/wandell/biac2/wandell/data/DWI-Tamagawa-Japan';

subs = {...
    'JMD1-MM-20121025-DWI'...
    'JMD2-KK-20121025-DWI'...
    'JMD3-AK-20121026-DWI'...
    'JMD4-AM-20121026-DWI'...
    'JMD5-KK-20121220-DWI'...
    'JMD6-NO-20121220-DWI'...
    'JMD7-YN-20130621-DWI'...
    'JMD8-HT-20130621-DWI'...
    'JMD9-TY-20130621-DWI'...
    'LHON1-TK-20121130-DWI'...
    'LHON2-SO-20121130-DWI'...
    'LHON3-TO-20121130-DWI'...
    'LHON4-GK-20121130-DWI'...
    'LHON5-HS-20121220-DWI'...
    'LHON6-SS-20121221-DWI'...
    'JMD-Ctl-MT-20121025-DWI'...
    'JMD-Ctl-YM-20121025-DWI'...
    'JMD-Ctl-SY-20130222DWI'...
    'JMD-Ctl-HH-20120907DWI'...
    'JMD-Ctl-HT-20120907-DWI'...
    };
%for
i = 9;%:length(subs);

    dt  = fullfile(AFQdata,subs{i},'/dwi_2nd','dt6.mat');
    roiDir = fullfile(AFQdata,subs{i},'/dwi_2nd/ROIs');
    roi = fullfile(roiDir,'LOR_rect0626.mat');
     
%% Argument check
    if ischar(dt)
        dt = dtiLoadDt6(dt);
    end
    
    if ischar(roi)
        roi = dtiReadRoi(roi);
    end

    %% Compute the PDD at each point in evry ROI
    roi_pdd = dtiGetValFromTensors(dt.dt6, roi.coords, inv(dt.xformToAcpc), 'pdd');
    
    % Select the voxel which have the PDD value more than PDDthreth value
    % in Y direction
    
    a = abs(roi_pdd);
    
    % define RGB threshold
    Ythresh = 0.22;   Xthresh = 0.5; Zthresh = 0.5;
    
    pddY = a(:,2) > Ythresh; % 2 pdd value threshhold in Y direction
    pddX = a(:,1) < Xthresh;
    pddZ = a(:,3) < Zthresh;
    pddXYZ = sum(horzcat(pddX,pddY,pddZ),2)==3;
    
    % Retain VOF ROI coordinates that have a PDD in the Y direction
%     roi.coords = roi.coords(pddY,:);
    roi.coords = roi.coords(pddXYZ,:);
    % Save new ROI
    name = [roi.name '_Y_'];
 
    b =  sprintf('%s%s_%d',roi.name,'_Y',Ythresh*100);
    roi.name = b;
    dtiWriteRoi(roi,roi.name)
    
    
    
    
