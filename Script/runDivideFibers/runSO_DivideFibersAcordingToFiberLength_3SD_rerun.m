function [TractProfile] = runSO_DivideFibersAcordingToFiberLength_3SD_rerun
%     [TractProfile, fg_SDm3,fg_SDm2,fg_SDm1,fg_SD1,fg_SD2,fg_SD3] = ...

%%
homeDir = '/biac4/wandell/biac2/wandell/data/DWI-Tamagawa-Japan';

subDir = {...
    'JMD1-MM-20121025-DWI'
    'JMD3-AK-20121026-DWI'
    'JMD5-KK-20121220-DWI'
    'JMD6-NO-20121220-DWI'
    'JMD2-KK-20121025-DWI'
    'JMD4-AM-20121026-DWI'
    'JMD7-YN-20130621-DWI'
    'JMD8-HT-20130621-DWI'
    'JMD9-TY-20130621-DWI'
%     'LHON1-TK-20121130-DWI'
%     'LHON2-SO-20121130-DWI'
%     'LHON3-TO-20121130-DWI'
%     'LHON4-GK-20121130-DWI'
%     'LHON5-HS-20121220-DWI'
%     'LHON6-SS-20121221-DWI'
%     'JMD-Ctl-MT-20121025-DWI'
%     'JMD-Ctl-YM-20121025-DWI'
%     'JMD-Ctl-SY-20130222DWI'
%     'JMD-Ctl-HH-20120907DWI'
%     'JMD-Ctl-HT-20120907-DWI'
%     'JMD-Ctl-FN-20130621-DWI'
%     'JMD-Ctl-AM-20130726-DWI'
%     'JMD-Ctl-SO-20130726-DWI'
%     'RP1-TT-2013-11-01'
%     'RP2-KI-2013-11-01'
%     'RP3-TO-13120611-DWI'
%     'LHON6-SS-20131206-DWI'
%     'RP4-AK-2014-01-31'
%     'RP5-KS-2014-01-31'
%     'JMD3-AK-20140228-dMRI'
%     'JMD-Ctl-09-RN-20130909'
%     'JMD-Ctl-10-JN-20140205'
%     'JMD-Ctl-11-MT-20140217'
%     'RP6-SY-2014-02-28-dMRI'
%     'Ctl-12-SA-20140307'
%     'Ctl-13-MW-20140313-dMRI-Anatomy'
%     'Ctl-14-YM-20140314-dMRI-Anatomy'
%     'RP7-EU-2014-03-14-dMRI-Anatomy'
%     'RP8-YT-2014-03-14-dMRI-Anatomy'
    };


%% Calculate vals along the fibers and return TP structure
for i =1:length(subDir)
    % define directory
    SubDir = fullfile(homeDir,subDir{i});
    fgDir  = fullfile(SubDir,'/dwi_2nd/fibers/conTrack/OR_rerun');
    %     newDir = fullfile(SubDir,'/dwi_2nd/fibers/conTrack/OR_1130');
    %     roiDir = fullfile(SubDir,'/dwi_2nd/ROIs');
    dt  = fullfile(homeDir,subDir{i},'dwi_2nd','dt6.mat');
    dt  = dtiLoadDt6(dt);
    
%     cd /biac4/wandell/biac3/wandell7/shumpei/matlab/git/LHON/3RP
    
    
    fgN ={'*Rh_NOT1201_D4L2_rerun.pdb','*Lh_NOT1201_D4L2_rerun.pdb'};
    
%         ,'ROTD4L4_1206.pdb','LOTD4L4_1206.pdb',...
%         'ROTD3L2_1206.pdb','LOTD3L2_1206.pdb'};
    
    for j =1:length(fgN)
        cd(fgDir) 
        fg = dir(fgN{j});
        fgF{j} = fgRead(fullfile(fgDir,fg.name));
        
        %     [TractProfile{i,j}, fg_SDm3{i,j},fg_SDm2{i,j},fg_SDm1{i,j},fg_SD1{i,j},fg_SD2{i,j},fg_SD3{i,j}]...
        %         = SO_DivideFibersAcordingToFiberLength_SD3(fgF{j},dt,0,'AP',100);
        
        [TractProfile{i,j}, ~,~,~,~,~,~]...
            = SO_DivideFibersAcordingToFiberLength_SD3(fgF{j},dt,0,'AP',100);
    end
end

%
cd /biac4/wandell/biac3/wandell7/shumpei/matlab/git/LHON/3RP/Rerun_dtiInit
save rerun_tama1_3SD_TractProfile TractProfile
return