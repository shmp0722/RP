%% SO_OpticRadiationClip_LtrlVent.m
% Clip OR fg to compare clean part of OR  

% homeDir
homeDir = '/biac4/wandell/biac2/wandell/data/DWI-Tamagawa-Japan';

% subs in colum
subJ = {...
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
    'JMD-Ctl-HT-20120907-DWI'};



%loop subject
for i = 1:length(subJ)  % 3 imcomplete

    % define derectory   
    RoiDir = fullfile(homeDir,subJ{i},'/dwi_2nd/ROIs');
    fgDir  = fullfile(homeDir,subJ{i},'/dwi_2nd/fibers');
    dtDir  = fullfile(homeDir,subJ{i},'dwi_2nd');
        
    % load dt, fg, roi
    fgL = fullfile(fgDir,'LOR_MD4.pdb');
    fgR = fullfile(fgDir,'ROR_MD4.pdb');
    
    dt= fullfile(dtDir ,'dt6.mat');
    roi1 =fullfile(RoiDir,'Left-Lateral-Ventricle.mat');
    roi2 =fullfile(RoiDir,'Right-Lateral-Ventricle.mat');
    roi3 =fullfile(RoiDir,'Lt-LGN.mat');
    roi4 =fullfile(RoiDir,'Rt-LGN.mat');
    roi5 =fullfile(RoiDir,'lh_V1_smooth3mm.mat');
    roi6 =fullfile(RoiDir,'rh_V1_smooth3mm.mat');

    cd(fgDir)
    
    %% Argument checking
    if ischar(dt)
        dt = dtiLoadDt6(dt);
    end
    if ischar(fgL)
        fgL = fgRead(fgL);
    end
    if ischar(fgR)
        fgR = fgRead(fgR);
    end
    if ischar(roi1)
        roi1 = dtiReadRoi(roi1);
    end
    if ischar(roi2)
        roi2 = dtiReadRoi(roi2);
    end
    if ischar(roi3)
        roi3 = dtiReadRoi(roi3);
    end
    if ischar(roi4)
        roi4 = dtiReadRoi(roi4);
    end
    if ischar(roi5)
        roi5 = dtiReadRoi(roi5);
    end
    if ischar(roi6)
        roi6 = dtiReadRoi(roi6);
    end
    %% Clip L-OR
    % Define the portion of fg by Lateral Ventricle and LGN ROI
    L_LtrlVent_endPointY = min(roi1.coords(:,2));
    L_LGN_endPointY      = min(roi3.coords(:,2));
        
    % nearest voxels of L-lateral ventricle to midline
    L_LtrlVent_Voxels     = roi1.coords(:,2)==L_LtrlVent_endPointY;
    L_LtrlVent_endVoxelsX = roi1.coords(L_LtrlVent_Voxels,:);
    L_LateralClipPartX      = min(L_LtrlVent_endVoxelsX(:,1));
        
    % Clip fg
    AnteriorClipPoint = [L_LGN_endPointY, 80];
    PosterorClipPoint = [-120, L_LtrlVent_endPointY];
    LateralClipPoint  = [L_LateralClipPartX, 10];
    
    fgL  = dtiClipFiberGroup(fgL, [], AnteriorClipPoint, [],[]);
    fgL  = dtiClipFiberGroup(fgL, [], PosterorClipPoint, [],[]);
    fgL  = dtiClipFiberGroup(fgL, LateralClipPoint ,[],[],[1]);

    % Clip V1 roi to clean unnecessary fibers which remain more midside
    % than Ventricle
    [roi5, ~] = dtiRoiClip(roi5, [], PosterorClipPoint, []);
    roi5 = dtiRoiClean(roi5, 3, ['fillholes', 'dilate', 'removesat']);
    % %% Add new fg to afq structure
% cd(fullfile(homeDir,'AFQ_results','6LHON_6JMD_5ctl'))
% load 'AFQ_6LHON5Normal0610.mat'
% %% Change the file name
% for i = 1:length(subJ)
% fromfile = fullfile(fgDir,'LOR_MD4_clip_clip_clip-lh_V1_smooth3mm.pdb');
% gofile   = fullfile(fgDir,'LOR_MD4_ClippedByLV.pdb');
% 
% copyfile(fromfile,gofile)
%  'JMD1-MM-20121025-DWI'...
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
    'JMD-Ctl-HT-20120907-DWI'};
% fromfile = fullfile(fgDir,'ROR_MD4_clip_clip_clip-rh_V1_smooth3mm.pdb');
% gofile   = fullfile(fgDir,'ROR_MD4_ClippedByLV.pdb');
% 
% copyfile(fromfile,gofile)
% end
% 
% %% Add 
% 
% fgName = 'LOR_MD4_ClippedByLV.pdb';
% roi1Name = 'Lt-LGN.mat';
% roi2Name = 'ctx-lh-pericalcarine.mat';
% afq = AFQ_AddNewFiberGroup(afq, fgName, roi1Name, roi2Name, 0, 1);
% 
% fgName = 'ROR_MD4_ClippedByLV.pdb';
% roi1Name = 'Rt-LGN.mat';
% roi2Name = 'ctx-rh-pericalcarine.mat';
% afq = AFQ_AddNewFiberGroup(afq, fgName, roi1Name, roi2Name, 0, 1);
% 

    [fgOut1,~,~] = dtiIntersectFibersWithRoi([],'not',[],roi5,fgL);
    fgWrite(fgOut1,fgOut1.name)
    
    %% Clip R-OR
    % Define the portion of fg by Lateral Ventricle and LGN ROI
    R_LtrlVent_endPointY = min(roi2.coords(:,2));
    R_LGN_endPointY      = min(roi4.coords(:,2));
        
    % nearest voxels of L-lateral ventricle to midline
    R_LtrlVent_Voxels     = roi2.coords(:,2)==R_LtrlVent_endPointY;
    R_LtrlVent_endVoxelsX = roi2.coords(R_LtrlVent_Voxels,:);
    R_LateralClipPartX    = min(R_LtrlVent_endVoxelsX(:,1));
        
    % Clip fg
    AnteriorClipPoint = [R_LGN_endPointY, 80];
    PosterorClipPoint = [-120, R_LtrlVent_endPointY];
    LateralClipPoint  = [-10, R_LateralClipPartX];
    
    fgR  = dtiClipFiberGroup(fgR, [], AnteriorClipPoint, [],[]);
    fgR  = dtiClipFiberGroup(fgR, [], PosterorClipPoint, [],[]);
    fgR  = dtiClipFiberGroup(fgR, LateralClipPoint ,[],[],[]);

    % Clip V1 roi to clean unnecessary fibers which remain more midside
    % than Ventricle
    [roi6, ~] = dtiRoiClip(roi6, [], PosterorClipPoint, []);
    roi6 = dtiRoiClean(roi6, 3, ['fillholes', 'dilate', 'removesat']);
    
    [fgOut2,~,~] = dtiIntersectFibersWithRoi([],'not',[],roi6,fgR);
    fgWrite(fgOut2,fgOut2.name)
    fgWrite(fgR,fgR.name)
    % AFQ_RenderFibers(fgOut2,'dt',dt,'numfibers',100)
    
end
return
% %% Add new fg to afq structure
% cd(fullfile(homeDir,'AFQ_results','6LHON_6JMD_5ctl'))
% load 'AFQ_6LHON5Normal0610.mat'
% %% Change the file name
% for i = 1:length(subJ)
% fromfile = fullfile(fgDir,'LOR_MD4_clip_clip_clip-lh_V1_smooth3mm.pdb');
% gofile   = fullfile(fgDir,'LOR_MD4_ClippedByLV.pdb');
% 
% copyfile(fromfile,gofile)
% 
% fromfile = fullfile(fgDir,'ROR_MD4_clip_clip_clip-rh_V1_smooth3mm.pdb');
% gofile   = fullfile(fgDir,'ROR_MD4_ClippedByLV.pdb');
% 
% copyfile(fromfile,gofile)
% end
% 
% %% Add 
% 
% fgName = 'LOR_MD4_ClippedByLV.pdb';
% roi1Name = 'Lt-LGN.mat';
% roi2Name = 'ctx-lh-pericalcarine.mat';
% afq = AFQ_AddNewFiberGroup(afq, fgName, roi1Name, roi2Name, 0, 1);
% 
% fgName = 'ROR_MD4_ClippedByLV.pdb';
% roi1Name = 'Rt-LGN.mat';
% roi2Name = 'ctx-rh-pericalcarine.mat';
% afq = AFQ_AddNewFiberGroup(afq, fgName, roi1Name, roi2Name, 0, 1);
% 

