function AFQ_removeFiberOutlier_OR_mrt
%% AFQ_removeFiberOutlier_OR_mrt
% remove outlier fibers from Opic radiation made by mrTrix.
% 
%
%
%% set directry
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
%     'JMD-Ctl-HT-20120907-DWI'
    'JMD-Ctl-FN-20130621-DWI'
    'JMD-Ctl-AM-20130726-DWI'
    'JMD-Ctl-SO-20130726-DWI'
    };
% i =4
%% make directory and define Dirs
for i = 1:length(subDir)
    
    SubDir = fullfile(homeDir,subDir{i});
    fgDir  = fullfile(SubDir,'/dwi_2nd/fibers/mrtrix2');
    roiDir = fullfile(SubDir,'/dwi_2nd/ROIs');
    dtDir  = fullfile(homeDir,subDir{i},'dwi_2nd');
    cd(fgDir)
    
    fgF{1} = dir('*dwi2nd_aligned_trilin_csd_lmax2_Lt*_Lt-LGN4_prob.pdb');
    fgF{2} = dir('*dwi2nd_aligned_trilin_csd_lmax2_Rt*_Rt-LGN4_prob.pdb');
    
    for ij = 1:2
        fg = fgRead(fgF{ij}.name);
        
        % Run AFQ with different maximum distance
        for k=4;
            
            maxDist = k;
            maxLen = 4;
            numNodes = 100;
            M = 'mean';
            count = 1;
            show = 1;
            
            [fgclean, ~] =  AFQ_removeFiberOutliers(fg,maxDist,maxLen,numNodes,M,count,show);
            
            %% to save the pdb file.
            fgclean.name = sprintf('%s_MD%d',fgclean.name,maxDist);
            fibername       = sprintf('%s/%s.pdb',fgDir,fgclean.name);
            mtrExportFibers(fgclean,fibername);
        end
    end
end