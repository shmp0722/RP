%% SO_ORPipeline_V13mm_clipped_LGN4mm.m

%% MergeROis_NOTROI.m
% merge ROIs to create Big NOT ROI.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% ctl HT does not have cerebellum segmentation file!
% If you want to creat ROI which include cerebelum,
% You should exclude HT, and create HT's ROI by hand.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Set directory
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
    'JMD-Ctl-HT-20120907-DWI'};

%loop subject
% for
i =2;%:length(subDir)

SubDir = fullfile(homeDir,subDir{i});
fgDir  = fullfile(SubDir,'/dwi_2nd/fibers/conTrack/OR_Top100K_V1_3mm_clipped_LGN4mm');
roiDir = fullfile(SubDir,'/dwi_2nd/ROIs');
dtDir  = fullfile(homeDir,subDir{i},'dwi_2nd');

cd(fgDir)
mkdir('R-OR_check')
cd(roiDir)

% ROI file names you want to mergefg
for hemisphere = 1;%:2
    if i<21
        switch(hemisphere)
            case  1 % Left-WhiteMatter
                roiname = {...'Brain-Stem',...
%                     'Right-Cerebellum-White-Matter'
%                     'Right-Cerebellum-Cortex'
%                     'Left-Cerebellum-White-Matter'
%                     'Left-Cerebellum-Cortex'
                    'Right-Hippocampus'
%                     'Right-Hippocampus_FA_p15'
%                     'Right-Hippocampus_FA_p20'
%                     'Left-Lateral-Ventricle'
                    'Right-Lateral-Ventricle'
%                     'Right-Cerebral-Cortex_FA_p15'
                    'Left-Cerebral-White-Matter'
                    'Right-Thalamus-Proper'
                    'Right-Cerebral-Cortex_V13mm_setdiff'};
            case 2 % Right-WhiteMatter
                roiname = {...'Brain-Stem',...
                    %                         'Right-Cerebellum-White-Matter'
                    %                         'Right-Cerebellum-Cortex'
                    %                         'Left-Cerebellum-White-Matter'
                    %                         'Left-Cerebellum-Cortex'
%                     'Left-Hippocampus'
%                     'Left-Hippocampus_FA_p15'
%                     'Left-Hippocampus_FA_p20'
                    %                         'Left-Lateral-Ventricle'%,'Right-Lateral-Ventricle'
                    %                         'Left-Cerebral-Cortex_FA_p15'
                    %                         'Right-Cerebral-White-Matter'
                    'Left-Thalamus-Proper'};
        end
    else i = 21;
        switch(hemisphere)
            case  1 % Left-WhiteMatter
                roiname = {...'Brain-Stem',...
                    ...'Right-Cerebellum-White-Matter','Right-Cerebellum-Cortex',...
                    ...'Left-Cerebellum-White-Matter','Left-Cerebellum-Cortex',...
                    'Left-Hippocampus'
                    'Right-Hippocampus'
                    %                         'Left-Lateral-Ventricle','Right-Lateral-Ventricle',,'Right-Cerebral-Cortex_FA_p15'
                    'Left-Cerebral-White-Matter'};
            case 2 % Right-WhiteMatter
                roiname = {...'Brain-Stem',...
                    ...'Right-Cerebellum-White-Matter','Right-Cerebellum-Cortex',...
                    ...'Left-Cerebellum-White-Matter','Left-Cerebellum-Cortex',...
                    'Left-Hippocampus'
                    'Right-Hippocampus'
                    %                         'Left-Lateral-Ventricle','Right-Lateral-Ventricle','Left-Cerebral-Cortex_FA_p15'
                    'Right-Cerebral-White-Matter'};
        end
    end
   
    
    % Intersect raw OR with Not ROIs
    cd(fgDir)
    fgF = {'fg_OR_Top100K_V1_3mm_clipped_LGN4mm_Rt-LGN4_rh_V1_smooth3mm_NOT_2013-07-10_16.50.36.pdb'
        'fg_OR_Top100K_V1_3mm_clipped_LGN4mm_Lt-LGN4_lh_V1_smooth3mm_NOT_2013-07-10_16.50.36.pdb'};
    
    % define
    fg  = fullfile(fgDir,fgF{hemisphere});
    fg  = fgRead(fg);
    
    cd('R-OR_check')
    
    for m = 1:length(roiname)
        newROI = dtiReadRoi(fullfile(roiDir,roiname{m}));
        
        [fgOut1,contentiousFibers1, keep1, keepID1] = dtiIntersectFibersWithRoi([], 'not', [], newROI, fg);
        keep = ~keep1;
        for l =1:length(fgOut1.params)
            fgOut1.params{1,l}.stat=fgOut1.params{1,l}.stat(keep);
        end
        fgOut1.pathwayInfo = fgOut1.pathwayInfo(keep);
        
        if hemisphere == 1;
            fprintf('%s_%s_%d','R-OR', newROI.name,100000-length(fgOut1.fibers));
        else 
            fprintf('%s_%s_%d','L-OR', newROI.name,100000-length(fgOut1.fibers));
        end;
        
        % Save file
        fgOut1.name = sprintf('%s.pdb',fgOut1.name);
        mtrExportFibers(fgOut1, fgOut1.name,[],[],[],2)
    end
end
return
% save new fg.pdb file
savefilename = sprintf('%s.pdb',fgOut1.name);
mtrExportFibers(fgOut1,savefilename,[],[],[],2);

%         end

return


