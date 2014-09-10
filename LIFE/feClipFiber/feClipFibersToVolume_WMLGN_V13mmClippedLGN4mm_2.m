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

subDir ={
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
    'JMD-Ctl-FN-20130621-DWI'};

fgfile = {...
        'fg_OR_Top100K_V1_3mm_clipped_LGN4mm_Lt-LGN4_lh_V1_smooth3mm_NOT_2013-07-10_16.50.36.pdb'
        'fg_OR_Top100K_V1_3mm_clipped_LGN4mm_Rt-LGN4_rh_V1_smooth3mm_NOT_2013-07-10_16.50.36.pdb'};

%% dtiIntersectFiberWithRoi 
for i = 19:length(subDir)
    % INPUTS
    SubDir =fullfile(homeDir,subDir{i});
    roiDir =fullfile(homeDir,subDir{i},'/dwi_2nd/ROIs');
    fgDir  = (fullfile(SubDir,'/dwi_2nd/fibers/conTrack/OR_Top100K_V1_3mm_clipped_LGN4mm'));
    
    for k= 1:length(fgfile)
        % Load roi
%        Merged ROIs
%          case  1 % Left-WhiteMatter
%                     roiname = {'Brain-Stem',...
%                         'Right-Cerebellum-White-Matter'
%                         'Right-Cerebellum-Cortex'
%                         'Left-Cerebellum-White-Matter'
%                         'Left-Cerebellum-Cortex'
%                         'Left-Hippocampus'
%                         'Right-Hippocampus'
%                         'Left-Lateral-Ventricle'
%                         'Right-Lateral-Ventricle'
%                         'Left-Cerebral-White-Matter','Left-Cerebral-Cortex_NOT'};
%                 case 2 % Right-WhiteMatter
%                     roiname = {'Brain-Stem',...
%                         'Right-Cerebellum-White-Matter'
%                         'Right-Cerebellum-Cortex'
%                         'Left-Cerebellum-White-Matter'
%                         'Left-Cerebellum-Cortex'
%                         'Left-Hippocampus'
%                         'Right-Hippocampus'
%                         'Left-Lateral-Ventricle'
%                         'Right-Lateral-Ventricle'
%                         'Right-Cerebral-White-Matter','Right-Cerebral-Cortex_NOT'};
        
        switch k
            case 1 % for left hemi-sphere fg
                NOTroiFile =  'Rh_NOT0712_setdiffV13mm';                
                roiFile = 'Left-Cerebral-White-Matter_Lt-LGN_Left-Thalamus-Proper';
            case 2 % for right hemisphere fg
                NOTroiFile =  'Lh_NOT0712_setdiffV13mm';                
                roiFile = 'Right-Cerebral-White-Matter_Rt-LGN_Right-Thalamus-Proper';
        end
        % load roi, fg
        % NOT roi is for dtiIntersect, AND roi is for feClip
        
        % load roi
        cd(roiDir)
        NOTroi = dtiReadRoi(NOTroiFile);       
        ANDroi = dtiReadRoi(roiFile);
        %%
        % load fg
        cd(fgDir)    
        fg=fgRead(fgfile{k});
        
        % Intersect interhemisphere fibers using NOTroi
        [fgOut,~,keep,~] = dtiIntersectFibersWithRoi([],'not',[],NOTroi,fg);
        
        % keep pathwayInfo and Params.stat for contrack scoring
        keep1 = ~keep;
        for l = 1:length(fgOut.params)
            fgOut.params{1,l}.stat=fgOut.params{1,l}.stat(keep1);
        end
        fgOut.pathwayInfo = fgOut.pathwayInfo(keep1);
        fgOut.name = sprintf('%s.pdb',fgOut.name);
        mtrExportFibers(fgOut, fgOut.name,[],[],[],2)
    
    
    end
end
return

%% conTrack scoring
for i = 1:length(subDir)
    for k=1:2;
        switch k
            case 1 % for left hemi-sphere fg
                NOTroiFile =  'Rh_NOT0712_setdiffV13mm';                
                roiFile = 'Left-Cerebral-White-Matter_Lt-LGN_Left-Thalamus-Proper';
            case 2 % for right hemisphere fg
                NOTroiFile =  'Lh_NOT0712_setdiffV13mm';                
                roiFile = 'Right-Cerebral-White-Matter_Rt-LGN_Right-Thalamus-Proper';
        end
%% contrack scoring
        fname = [fgfile{k}(1:end-4), '-' ,NOTroiFile, '.pdb'];
        name  = ['ctrSampler_', fgfile{k}(1:end-4)];
        fg = fgRead(fname);
        % reduce 20% fibers by conTrack scoring
        nFiber = round(length(fg.fibers)*0.7);
        
        % get oldest files to match the identifier in the folder
        dTxt = fullfile(pwd,sprintf('%s%s.txt','ctrSampler',name));
        dPdb =fg.name;
%         [~, tmp] = fileparts(dPdb{1});
%         
%         inds = strfind(tmp,fileidentifier);
%         name = tmp(1:inds-1);
%         
        % define filename for fiber group
        
        m = strfind(fg.name,'.'); fg.name(m)='_';
        outputfibername = fullfile(pwd, sprintf('%s%s_%d.pdb',fg.name,'_Ctr',nFiber));
        
        % make command to get 25000 fibers for contrack
        ContCommand = sprintf('contrack_score.glxa64 -i %s -p %s --thresh %d --sort %s', ...
            dTxt, outputfibername, nFiber, dPdb);
        
        % run contrack
        system(ContCommand);
        
        %% AFQ_removeoutlier
        fg = fgRead(outputfibername);
        [fgclean, keep2]=AFQ_removeFiberOutliers(fg,5,4,50,'mean',1, 5,[]);
        % keep pathwayInfo and Params.stat for contrack scoring
        for l = 1:length(fgclean.params)
            fgclean.params{1,l}.stat=fgclean.params{1,l}.stat(keep2);
        end
        fgclean.pathwayInfo = fgclean.pathwayInfo(keep2);
        fgclean.name = sprintf('%s_AFQ_%d.pdb',fgclean.name,length(fgclean.fibers));
        mtrExportFibers(fgclean, fgclean.name,[],[],[],2)
        
    end
end
matlabpool close;
return
%         %% run feClipFibersVolume
% %          fg = fgRead(outputfibername);
%         % Keep parameters, once
%         params      = fgclean.params;
%         pathwayInfo = fgclean.pathwayInfo;
%         
%         % Clear parameters fields that we do not need:
%         fgclean.params      = [];
%         fgclean.pathwayInfo = [];
%         
%         % Clip the fibers' nodes that are 1mm away from the WM.
%         maxVolDist = 0; % mm
%         fg1 = feClipFibersToVolume(fg,ANDroi.coords,maxVolDist);
%         
%         % Back parameter
%         
%         % % Show a random 2000 fibers
%         % fg1=fg;
%         % fg1.fibers = fg1.fibers(randsample(1:length(fg1.fibers),500));
%         % feConnectomeDisplay(fg1,figure)
%         
%         % Save the clipped fiber group back to disk.
%         fg1.name = sprintf('%s_BWhiteMatter',fg1.name);
%         fgWrite(fg1,fg1.name,'mat')
%     end
% end
% 
% matlabpool close;
return

