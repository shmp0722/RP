function SuperFiberVoxels_2(subID,fg,dt)
% this function returns clipped the paticular portion of superfiber  

%% Set the path to data directory
homeDir = '/biac4/wandell/biac2/wandell/data/DWI-Tamagawa-Japan';
subDir ={
    'JMD1-MM-20121025-DWI'
    'JMD3-AK-20121026-DWI'
    'JMD5-KK-20121220-DWI'
    'JMD6-NO-20121220-DWI'
    'JMD2-KK-20121025-DWI'
    'JMD4-AM-20121026-DWI'
    'JMD7-YN-20130621-DWI'
    'JMD8-HT-20130621-DWI'
    'JMD9-TY-20130621-DWI'
    'LHON1-TK-20121130-DWI'
    'LHON2-SO-20121130-DWI'
    'LHON3-TO-20121130-DWI'
    'LHON4-GK-20121130-DWI'
    'LHON5-HS-20121220-DWI'
    'LHON6-SS-20121221-DWI'
    'JMD-Ctl-MT-20121025-DWI'  % Ctl 1; i= 16
    'JMD-Ctl-YM-20121025-DWI'  % Ctl 2; i =17
    'JMD-Ctl-SY-20130222DWI'   % Ctl 3
    'JMD-Ctl-HH-20120907DWI'   % Ctl 4
    'JMD-Ctl-HT-20120907-DWI'  % Ctl 5
    'JMD-Ctl-FN-20130621-DWI'  % Ctl 6
    'JMD-Ctl-AM-20130726-DWI'  % Ctl 7
    'JMD-Ctl-SO-20130726-DWI'};

%%
for i = 1:length(subDir);
    
    
    SubDir = fullfile(homeDir,subDir{i});
    fgDir  = fullfile(SubDir,'/dwi_2nd/fibers');
    roiDir = fullfile(SubDir,'/dwi_2nd/ROIs');
    dtDir  = fullfile(homeDir,subDir{i},'dwi_2nd');
    
    % define
    fg  = fullfile(fgDir,'RORV13mmClipBigNotROI5_clean_clean_D5_L4_superFiber.pdb');
    fgOrig = fullfile(fgDir,'RORV13mmClipBigNotROI5_clean_clean_D5_L4.mat');
    fgOT  = fullfile(fgDir,'ROT100_clean.pdb');
    
    %     roi = fullfile(roiDir,'');
    dt  = fullfile(dtDir,'dt6.mat');
    
    %% Argument checking
    
    dt = dtiLoadDt6(dt);
    fg = fgRead(fg);
    fgOrig =  fgRead(fgOrig);
    fgOT = fgRead(fgOT);
    
    % Check fiber length
    nodePfiber = fgGet(fgOrig, 'nodes perfiber');
    FiberCoords = fgGet(fgOrig, 'fibers');
    
    nodePfiberOT = fgGet(fgOT, 'nodes perfiber');
    FiberCoordsOT = fgGet(fgOT, 'fibers');
    
    % resample OT fiber to 100 nodes
    fgR_OT = dtiResampleFiberGroup(fgOT, 100,'N');% 10 nodes
    
    
    acpcP = round(fg.fibers{1});
    
    if fgR_OT.fibers{1}(2,1)<fgR_OT.fibers{1}(2,end)
        acpcP_OT = fliplr(round(fgR_OT.fibers{1}));
    else
        acpcP_OT = round(fgR_OT.fibers{1});
    end
    
    % difine SuperFiber axis Y
    antY = acpcP(2,50);
    postY = acpcP(2,85);
    
    % clip the innesecary part off
    % ROR
    fgclip = dtiClipFiberGroup(fg,[],[-120,postY],[],[]);
    fgclip = dtiClipFiberGroup(fgclip,[],[antY, 0],[],[]);
    cd(fgDir)
    fgWrite(fgclip,fgclip.name,'pdb')
    
    % difine SuperFiber axis Y
    % ROT
    antY = acpcP_OT(2,70);
    
    % clip the innesecary part off
    % ROR
    fgOTclip = dtiClipFiberGroup(fgR_OT,[],[-120,antY],[],[]);
    cd(fgDir)
    fgWrite(fgOTclip,fgOTclip.name,'pdb')
    
end


