%function [roi] = SO_dtiRestrictRoiToRange(roi, dt,[range1,range2], valName)
%% SO_dtiRestrictToImageValueRange.m
%
% dt = dtiLoadDt6(dt)
% range1 = 0.5
% range2 = 1.0 default
% roi =  dtiReadRoi(roi)
% varagin = ''
% 'fa', 'md', 'ad', 'rd', 'pddY', 'pddX', 'pddZ'
%
% If range is provided, the use will be prompted. The range should be
% specified in real imag value units.
%
% HISTORY:
%  SO (c) Stanford VISTASOFT Team, 2013

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
    'JMD-Ctl-AM-20130726-DWI'};

% %% Parameter initialization
% if(~exist('xform','var') || isempty(xform)),  xform = eye(4); end
if(~exist('valName','var') || isempty(valName)),  valName = 'fa'; end
% if(~exist('interpMethod','var') || isempty(interpMethod))
%     interpMethod = 'trilin';
% end

%% dtiRestrict

for i = 1:length(subDir)
    
    % give name to Dir
    SubDir = fullfile(homeDir,subDir{i});
    fgDir  = (fullfile(SubDir,'/dwi_2nd/fibers/conTrack/OR_Top100K_V1_3mm_clipped_LGN4mm'));
    roiDir = fullfile(SubDir,'/dwi_2nd/ROIs');
    dtDir  = fullfile(SubDir,'dwi_2nd');
    % load dt6
    dt = fullfile(dtDir,'dt6.mat');
    dt = dtiLoadDt6(dt);
    % load roi
    roi  ={...
        %          'Left-Cerebral-Cortex.mat'
        % %          'Left-Hippocampus.mat',...
        %          'Right-Cerebral-Cortex.mat'
        % % ,'Right-Hippocampus.mat'...
        %         'Right-Cerebral-Cortex_rh_V1_smooth3mm_NOT'...
        %         'Left-Cerebral-Cortex_lh_V1_smooth3mm_NOT'
        'Right-Cerebral-Cortex_V13mm_setdiff.mat'
        'Left-Cerebral-Cortex_V13mm_setdiff.mat'
        };
    for j = 1:length(roi)
        croi = dtiReadRoi(fullfile(roiDir,roi{j}));
        
        % Compute fa value
        fa = dtiGetValFromTensors(dt.dt6, croi.coords, inv(dt.xformToAcpc), 'fa');
        % Set the value range
        range = [0 0.12];
        keepCoords = fa >=range(1) & fa <=range(2);
        croi.coords =croi.coords(keepCoords,:);
        b =  range(2)*100;
        croi.name= sprintf('%s%s%d', croi.name,'_FA_p',b);
        
        cd(roiDir)
        dtiWriteRoi(croi, croi.name)
        
    end
end

%% dtiIntersectFiber

for i = 1:length(subDir)
    
    % give name to Dir
    SubDir = fullfile(homeDir,subDir{i});
    fgDir  = (fullfile(SubDir,'/dwi_2nd/fibers/conTrack/OR_Top100K_V1_3mm_clipped_LGN4mm'));
    roiDir = fullfile(SubDir,'/dwi_2nd/ROIs');
    dtDir  = fullfile(SubDir,'dwi_2nd');
    
    cd(roiDir)
    
    roif = {'Left-Cerebral-Cortex_V13mm_setdiff_FA_p12.mat'
        'Right-Cerebral-Cortex_V13mm_setdiff_FA_p12.mat'};
    roif2= {'Rh_NOT0711.mat','Lh_NOT0711.mat'};
    
    for j = 1:2;
        roi = dtiReadRoi(roif{j});
        roi2 = dtiReadRoi(roif2{j});
        
        newROI = dtiMergeROIs(roi,roi2);
        
        % load fg for 'OR_Top100K_V1_3mm_clipped'
        %         switch i
        %             case {1,2,3,4,5,6,10,11,12,13,14,15,16,17,18,19,20}
        %                 fgfile = {'fg_OR_Top100K_V1_3mm_clipped_Lt-LGN_lh_V1_smooth3mm_NOT_2013-06-19_18.12.51.pdb'
        %                     'fg_OR_Top100K_V1_3mm_clipped_Rt-LGN_rh_V1_smooth3mm_NOT_2013-06-19_18.12.51.pdb'};
        %             case {7,8,9}
        %                 fgfile = {'fg_OR_Top100K_V1_3mm_clipped_Lt-LGN_lh_V1_smooth3mm_NOT_2013-06-26_16.58.13.pdb'
        %                     'fg_OR_Top100K_V1_3mm_clipped_Rt-LGN_rh_V1_smooth3mm_NOT_2013-06-26_16.58.13.pdb'};
        %             case {21}
        %                 fgfile = {'fg_OR_Top100K_V1_3mm_clipped_Lt-LGN_lh_V1_smooth3mm_NOT_2013-07-02_15.23.28.pdb'
        %                     'fg_OR_Top100K_V1_3mm_clipped_Rt-LGN_rh_V1_smooth3mm_NOT_2013-07-02_15.23.28.pdb'};
        %             case {22}
        %                 fgfile = {'fg_OR_Top100K_V1_3mm_clipped_LGN4mm_Lt-LGN4_lh_V1_smooth3mm_NOT_2013-07-28_09.05.36.pdb'
        %                     'fg_OR_Top100K_V1_3mm_clipped_LGN4mm_Rt-LGN4_rh_V1_smooth3mm_NOT_2013-07-28_09.05.36.pdb'};
        %         end
        
        if i==2
            fgfile ={...
                'fg_OR_Top100K_V1_3mm_clipped_LGN4mm_Lt-LGN4_lh_V1_smooth3mm_NOT_2013-07-10_16.50.36.pdb'
                'fg_OR_Top100K_V1_3mm_clipped_LGN4mm_Rt-LGN4_rh_V1_smooth3mm_NOT_2013-07-17_10.55.52.pdb'};
        elseif i==22
            fgfile ={...
                'fg_OR_Top100K_V1_3mm_clipped_LGN4mm_Lt-LGN4_lh_V1_smooth3mm_NOT_2013-07-28_09.05.36.pdb'
                'fg_OR_Top100K_V1_3mm_clipped_LGN4mm_Rt-LGN4_rh_V1_smooth3mm_NOT_2013-07-28_09.05.36.pdb'};
         
        else
            fgfile = {...
                'fg_OR_Top100K_V1_3mm_clipped_LGN4mm_Lt-LGN4_lh_V1_smooth3mm_NOT_2013-07-10_16.50.36.pdb'
                'fg_OR_Top100K_V1_3mm_clipped_LGN4mm_Rt-LGN4_rh_V1_smooth3mm_NOT_2013-07-10_16.50.36.pdb'};
        end
        
        % load fg
        cd(fgDir)
        fg=fgRead(fgfile{j});
        
        % Intersect interhemisphere fibers using NOTroi
        [fgOut,~,keep,~] = dtiIntersectFibersWithRoi([],'not',[],newROI,fg);
        
        % keep pathwayInfo and Params.stat for contrack scoring
        keep1 = ~keep;
        for l = 1:length(fgOut.params)
            fgOut.params{1,l}.stat=fgOut.params{1,l}.stat(keep1);
        end
        fgOut.pathwayInfo = fgOut.pathwayInfo(keep1);
        cd()
        
        name = sprintf('%s.pdb',fgOut.name);
        % Save fg was removed interhemisphere fibers
        mtrExportFibers(fgOut, name,[],[],[],2)
    end
end

