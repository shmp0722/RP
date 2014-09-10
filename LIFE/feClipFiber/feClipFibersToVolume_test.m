%% feClipFibersToVolume_test.m
%Clip fibers to be constrained withint a Volume.
%
%  function fibers = feClipFibersToVolume(fibers,coords,maxVolDist)
%
% INPUTS:
%        fibers         - A cell array of fibers, each defined as a 3xN array
%                         of x,y,z coordinates. E.g., fg.fibers.
%        coords         - A volume of defined as a 3xN array of x,y,z coordinates.
%        maxVolDist     - The farther distance (in mm) from the volume a node can
%                         be to be kept in the fiber.
%
% OUTPUTS:
%        fibersOut      - A cell-array of fibers clipped within the volume
%                        defined by coords.
%
% SEE ALSO: feClipFiberNodes.m, feConnectomePreprocess.m
%
% Franco (c) 2012 Stanford Vista Team.

%% Initializing the parallel toolbox
poolwasopen=1; % if a matlabpool was open already we do not open nor close one
if (matlabpool('size') == 0),
    c = parcluster;
    c.NumWorkers = 8;
    matlabpool(c);
    poolwasopen=0;
end

%%
homeDir = '/biac4/wandell/biac2/wandell/data/DWI-Tamagawa-Japan';

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

parfor i=1%:length(subs)
    
    
    % INPUTS:
    fgDir  = fullfile(homeDir,subs{i},'/dwi_2nd/fibers/conTrack/OR_Top100K_V1_3mm_clipped_LGN4mm');
    roiDir = fullfile(homeDir,subs{i},'/dwi_2nd/ROIs');
    cd(fgDir)
    
    % subs switch
    switch i
        case {1,2,3,4,5,6,10,11,12,13,14,15,16,17,18,19,20}
            %             fgfile  = {'fg_OR_Top100K_V1_3mm_clipped_Lt-LGN_lh_V1_smooth3mm_NOT_2013-06-19_18.12.51.pdb'
            %                 'fg_OR_Top100K_V1_3mm_clipped_Rt-LGN_rh_V1_smooth3mm_NOT_2013-06-19_18.12.51.pdb'};
            
            fgfile  ={'fg_OR_Top100K_V1_3mm_clipped_LGN4mm_Lt-LGN4_lh_V1_smooth3mm_NOT_2013-07-03_02.37.16.pdb'
                'fg_OR_Top100K_V1_3mm_clipped_LGN4mm_Rt-LGN4_rh_V1_smooth3mm_NOT_2013-07-03_02.37.16.pdb'};
                
        case {7,8,9}
            fgfile  = {'fg_OR_Top100K_V1_3mm_clipped_Lt-LGN_lh_V1_smooth3mm_NOT_2013-06-26_16.58.13.pdb'
                'fg_OR_Top100K_V1_3mm_clipped_Rt-LGN_rh_V1_smooth3mm_NOT_2013-06-26_16.58.13.pdb'};
        case {21}
            fgfile = {'fg_OR_Top100K_V1_3mm_clipped_Lt-LGN_lh_V1_smooth3mm_NOT_2013-07-02_15.23.28.pdb'
                'fg_OR_Top100K_V1_3mm_clipped_Rt-LGN_rh_V1_smooth3mm_NOT_2013-07-02_15.23.28.pdb'};
            
    end
     
    % loop 
    for k = 1:2
        fg = fgRead(fgfile{k});
        % Keep parameters, once
        params      = fg.params;
        pathwayInfo = fg.pathwayInfo;
        
        % Clear parameters fields that we do not need:
        fg.params      = [];
        fg.pathwayInfo = [];
        
        % Get the coordinates of the White matter from the WM mask
        
        % roi = dtiRoiFromNifti(fullfile(homeDir,subs{i},'WmMask.nii.gz'),1,[],'mat');
        % roi = dtiRoiClean(roi,3,['fillholes']);
        % dtiWriteRoi(roi,fullfile(homeDir,subs{i},'WmMask_roi'))
        
        roi = dtiReadRoi(fullfile(roiDir,'Left-Cerebral-Cortex_Right-Cerebral-Cortex_Lt-LGN_Rt-LGN.mat'));
       
        % Clip the fibers' nodespdb that are 1mm away from the WM.
        maxVolDist = 0 ; % mm
        fg = feClipFibersToVolume(fg,roi.coords,maxVolDist);
        
        % Back parameter
        
        % % Show a random 2000 fibers
        % fg1=fg;
        % fg1.fibers = fg1.fibers(randsample(1:length(fg1.fibers),500));
        % feConnectomeDisplay(fg1,figure)
        
        % Save the clipped fiber group back to disk.
        %% Caution! file name is too long? file name doesn't change.
        fg.name = sprintf('%s_Life_BWm0701.mat',fg.name);
        fgWrite(fg, fg.name,'mat')
    end     
end


