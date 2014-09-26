function [LOR_1L, ROR_1L, LOR_C, ROR_C] = SO_SelectORCenterFiber
%
%
%

%% Set directory
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
    'JMD-Ctl-FN-20130621-DWI'
    'JMD-Ctl-AM-20130726-DWI'
    'JMD-Ctl-HT-20120907-DWI'
    'JMD-Ctl-SO-20130726-DWI'
    'RP1-TT-2013-11-01'
    'RP2-KI-2013-11-01'
    'RP3-TO-13120611-DWI'};
%% 

for i =1:length(subDir)
    % define dire
    SubDir = fullfile(homeDir,subDir{i});
    fgDir  = fullfile(SubDir,'/dwi_2nd/fibers');
    newDir = fullfile(SubDir,'/dwi_2nd/fibers/conTrack/OR_1130');
    roiDir = fullfile(SubDir,'/dwi_2nd/ROIs');
    dtDir  = fullfile(homeDir,subDir{i},'dwi_2nd');
    
    cd(newDir)
    %% load OR and V1 roi
    LORf = dir('*Lt-LGN4*NOT1201_D4_L4.pdb');
    RORf = dir('*Rt-LGN4*NOT1201_D4_L4.pdb');
    
    %      ORf = dir('*_D5_L4.pdb');
    %     for ij = 1:2
    %         cd(newDir)
    fgL = fgRead(LORf.name);
    fgR = fgRead(RORf.name);
    roiL_orig = dtiReadRoi(fullfile(roiDir,'lh_V1_smooth3mm_NOT.mat'));
    roiR_orig = dtiReadRoi(fullfile(roiDir,'rh_V1_smooth3mm_NOT.mat'));    
    
    % Intersect fibers using clipped V1 ROI
    roiL = dtiReadRoi(fullfile(roiDir,'lh_V1_smooth3mm_NOT_NOT.mat'));
    roiR = dtiReadRoi(fullfile(roiDir,'rh_V1_smooth3mm_NOT_NOT.mat'));
    
    fgL_center = dtiIntersectFibersWithRoi([],'and',[],roiL,fgL);
    fgR_center = dtiIntersectFibersWithRoi([],'and',[],roiR,fgR);
    
    % save the fascicles in the new directory
    fgWrite(fgL_center,'fgL_center.pdb','pdb')
    fgWrite(fgR_center,'fgR_center.pdb','pdb')

    
%     %% Check Original OR fiber
%     AFQ_RenderFibers(fgL,'numfibers',100,'camera','axial','tubes', 1,'radius', [.5 5],'newfig',1)
%     AFQ_RenderFibers(fgR,'numfibers',100,'camera','axial','tubes', 1,'radius', [.5 5],'newfig',0)
%     AFQ_RenderRoi(roiL_orig); AFQ_RenderRoi(roiR_orig);
%     axis image
%     
%     %% Check Clipped center OR fiber fig
%     AFQ_RenderFibers(fgL_center,'numfibers',100,'camera','axial','tubes', 1,'radius', [.5 5],'newfig',1)
%     AFQ_RenderFibers(fgR_center,'numfibers',100,'camera','axial','tubes', 1,'radius', [.5 5],'newfig',0)
%     AFQ_RenderRoi(roiL); AFQ_RenderRoi(roiR);
    
    %% Confirm fiber length distribution once more
%     Lnorm_fgL     = AFQ_FiberLengthHist(fgL,0);
%     Lnorm_fgR     = AFQ_FiberLengthHist(fgR,0);
    
    Lnorm_fgL_C  = AFQ_FiberLengthHist(fgL_center,0);
    Lnorm_fgR_C  = AFQ_FiberLengthHist(fgR_center,0);
    
    % select fibers length with in 1 sd
    keepLC =  -1< Lnorm_fgL_C <1;
    keepRC =  -1< Lnorm_fgR_C <1;
    
    fgL_C1L = dtiNewFiberGroup('fgL_C1L','b',[],[],fgL_center.fibers(logical(keepLC)));
    fgR_C1L = dtiNewFiberGroup('fgR_C1L','b',[],[],fgR_center.fibers(logical(keepRC)));
%     %% recheck fascicle shape one more
%     AFQ_RenderFibers(fgL_C1L,'numfibers',100,'camera','axial','tubes', 1,'radius', [.5 5],'newfig',1)
%     AFQ_RenderFibers(fgR_C1L,'numfibers',100,'camera','axial','tubes', 1,'radius', [.5 5],'newfig',0)
%     axis image

%% save fibers
%     fgWrite(fgL_C1L,'fgL_center1L.pdb','pdb')
%     fgWrite(fgR_C1L,'fgR_center1L.pdb','pdb')
       
    %     cd /biac4/wandell/biac3/wandell7/shumpei/matlab/git/LHON/3RP
    
    %% caliculate diffusivity of the fascicles
    dt = dtiLoadDt6(fullfile(dtDir,'dt6.mat'));
    
    LOR_1L{i} = SO_FiberValsInTractProfiles(fgL_C1L,dt,'AP',100,1);
        LOR_1L{i}.name = fullfile(subDir{i},fgL_C1L.name);
    ROR_1L{i} = SO_FiberValsInTractProfiles(fgR_C1L,dt,'AP',100,1);
        ROR_1L{i}.name = fullfile(subDir{i},fgR_C1L.name);

    
    LOR_C{i} = SO_FiberValsInTractProfiles(fgL_center,dt,'AP',100,1);
        LOR_C{i}.name = fullfile(subDir{i},fgL_center.name);

    ROR_C{i} = SO_FiberValsInTractProfiles(fgR_center,dt,'AP',100,1);
        ROR_C{i}.name = fullfile(subDir{i},fgR_center.name);

    
end
return


cd /biac4/wandell/biac3/wandell7/shumpei/matlab/git/LHON/3RP

save LOR_1L LOR_1L
save ROR_1L ROR_1L
save LOR_C LOR_C
save ROR_C ROR_C
