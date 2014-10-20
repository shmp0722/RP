functions SO_dtiCleanROIForLife.m
%
%
%
%
%
%
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

%%
for i = 1:length(subDir);
    
    SubDir = fullfile(homeDir,subDir{i});
    fgDir  = fullfile(SubDir,'/dwi_2nd/fibers/life_mrtrix');
    roiDir = fullfile(SubDir,'/dwi_2nd/ROIs');
    dtDir  = fullfile(homeDir,subDir{i},'dwi_2nd');
    
    % define
    roiF = {'Lt-LGN4.mat','lh_V1_smooth3mm_NOT.mat','Rt-LGN4','rh_V1_smooth3mm_NOT.mat'};
    cd(roiDir)
    
    for ij = 1:length(roiF)
        roi = fullfile(roiDir,roiF{ij});
        roi = dtiReadRoi(roi);
        roi = dtiRoiClean(roi,1,['fillholes', 'dilate', 'removesat']);      
        roi = dtiRoiClean(roi,1,['fillholes', 'dilate', 'removesat']);
        roi.name = [roi.name, '_clean'];
        
        cd(roiDir)
        dtiWriteRoi(roi, roi.name)
    end
    
    for ij = 1:2
        % load roi to intersect fibers
        if ij == 1 % L-OR
            roi1 = [roiF{1}(1:end-4),'_clean','.mat'];
            roi2 = [roiF{2}(1:end-4),'_clean','.mat'];
        else % R-OR
            roi1 = [roiF{3}(1:end-4),'_clean','.mat'];
            roi2 = [roiF{4}(1:end-4),'_clean','.mat'];
        end;              
            roi1 = dtiReadRoi(roi1);
            roi2 = dtiReadRoi(roi2);        
            
            % load whole brain connectome
            fg  = fullfile(fgDir,'dwi2nd_aligned_trilin_csd_lmax2_dwi2nd_aligned_trilin_brainmask_dwi2nd_aligned_trilin_wm_prob-500000.pdb');
            fg = fgRead(fg);
            
            % Identify specific fiber by using dialted ROI
            fgOut = dtiIntersectFibersWithRoi([],'and',0.87,roi1,fg);
            fgOut = dtiIntersectFibersWithRoi([],'and',0.87,roi2,fgOut);
            cd(fgDir)
            switch ij
                case 1
                                fgOut.name = 'L-OR2';
                case 2
                                fgOut.name = 'R-OR2';
            end;

            fgWrite(fgOut,fgOut.name,'pdb')
        end
        
        return
        
