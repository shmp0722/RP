function SO_dtiGetRoiStats

[homeDir,subDir,JMD,CRD,LHON,Ctl,RP] = Tama_subj2;

for i = 1:length(subDir);
    
    SubDir = fullfile(homeDir,subDir{i});
    %fgDir  = fullfile(SubDir,'/dwi_2nd/fibers/conTrack/OR_Top100K_V1_3mm_clipped');
    roiDir = fullfile(SubDir,'/dwi_2nd/ROIs');
    dtDir  = fullfile(homeDir,subDir{i},'dwi_2nd');
    
    % define
    %fg  = fullfile(fgDir,'');
    roi = fullfile(roiDir,'Optic-Chiasm.mat');
    dt  = fullfile(dtDir,'dt6.mat');
    
    
    %% Argument checking
    
    dt = dtiLoadDt6(dt);
    
    %         fg = fgRead(fg);
    
    roi = dtiReadRoi(roi);
    
    coords{i} = roi.coords;
    
    % compute fa value in ROI
    fa{i} = dtiGetValFromTensors(dt.dt6, coords{i}, inv(dt.xformToAcpc), 'fa', []);
    
    % comupute Roi Volume
    t1 = niftiRead(dt.files.t1);
    val(i) = dtiGetRoiVolume(roi,t1,dt);
    
end

return
%% calculate stats
for i= 1:21;
    % number of subjects
    n = length(subDir);
    % group mean diffusion profile
    m(i)  = nanmean(fa{i});
    % standard deviation at each node
    sd(i) = nanstd(fa{i});
    % standard error of the mean at each node
    se(i) = sd(i)./sqrt(n);
    
    min(i)= nanmin(fa{i});
    max(i)= nanmax(fa{i});
    
end


%     % run dtiGetRoiStats.m
%     [s, str] = dtiGetRoiStats([], 0, 'false') ;
%

%%
%% SO_dtiGetRoiStats.m
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
    'JMD-Ctl-AM-20130726-DWI'};
%%
for i = 1; %:length(subDir);
    
    SubDir = fullfile(homeDir,subDir{i});
    %fgDir  = fullfile(SubDir,'/dwi_2nd/fibers/conTrack/OR_Top100K_V1_3mm_clipped');
    roiDir = fullfile(SubDir,'/dwi_2nd/ROIs');
    dtDir  = fullfile(homeDir,subDir{i},'dwi_2nd');
    
    cd(dtDir)
    
    [~,dtiH] = mrDiffusion('off','dt6.mat');
    
    roi = fullfile(roiDir,'Optic-Chiasm.mat');
    anat = dtiGet(dtiH,'current anatomy data');
    dtiSet(dtiH,'add roi',roi,1);
    
    [s, str] = dtiGetRoiStats([], [], []) ;
end