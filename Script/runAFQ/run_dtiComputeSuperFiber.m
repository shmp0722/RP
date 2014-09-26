%% run_dtiComputeSuperFiber.m
%% Set the path to data directory
homeDir = '/biac4/wandell/biac2/wandell/data/DWI-Tamagawa-Japan';
subDir = {...
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
    'JMD-Ctl-SO-20130726-DWI'};


for i = 1:length(subDir);
        
    SubDir = fullfile(homeDir,subDir{i});
    fgDir  = fullfile(SubDir,'/dwi_2nd/fibers');
    roiDir = fullfile(SubDir,'/dwi_2nd/ROIs');
    dtDir  = fullfile(homeDir,subDir{i},'dwi_2nd');
    
    % define
    fg  = fullfile(fgDir,'RORV13mmClipBigNotROI5_clean_clean_D5_L4.mat');
    dt  = fullfile(dtDir,'dt6.mat');
     
    % Argument 
        dt = dtiLoadDt6(dt);
        fg = fgRead(fg);
        numNodes = 100;
    % run dtiCSpF
    [SuperFiber, sfg] = dtiComputeSuperFiberRepresentation(fg, [], numNodes);
    sFg = dtiNewFiberGroup(['RORV13mmClipBigNotROI5_clean_clean_D5_L4' '_superFiber'],[0 0 155],[],[],SuperFiber.fibers);
    % Save the superfiber
    cd(fgDir)
    mtrExportFibers(sFg,sFg.name);
end