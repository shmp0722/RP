%% SO_ORPipeline_V13mm_clipped_LGN4mm.m

%% MergeROis_NOTROI.m
% merge ROIs to create Big NOT ROI.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% ctl HT does not have cerebellum segmentation file!
% If you want to creat ROI which include cerebelum,
% You should exclude HT, and create HT's ROI by hand.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
    };

%% make directory and define Dirs
for i = 1:length(subDir)
    
    SubDir = fullfile(homeDir,subDir{i});
    fgDir  = fullfile(SubDir,'/dwi_2nd/fibers/conTrack/OR_Top100K_V1_3mm_clipped_LGN4mm');
    roiDir = fullfile(SubDir,'/dwi_2nd/ROIs');
    dtDir  = fullfile(homeDir,subDir{i},'dwi_2nd');
    cd(fgDir)
%     mkdir('NOT5_Contrack70_0731')
end

%% make NOT ROI
for i = 1:length(subDir)
    SubDir = fullfile(homeDir,subDir{i});
    fgDir  = fullfile(SubDir,'/dwi_2nd/fibers/conTrack/OR_Top100K_V1_3mm_clipped_LGN4mm');
    roiDir = fullfile(SubDir,'/dwi_2nd/ROIs');
    dtDir  = fullfile(homeDir,subDir{i},'dwi_2nd');
    cd(roiDir)
    
    % ROI file names you want to merge
    for hemisphere = 1:2
        if i<22
            switch(hemisphere)
                case  1 % Left-WhiteMatter
                    roiname = {...'Brain-Stem',...
                        'Right-Cerebellum-White-Matter'
                        'Right-Cerebellum-Cortex'
                        'Left-Cerebellum-White-Matter'
                        'Left-Cerebellum-Cortex'
                        'Left-Hippocampus'
                        'Right-Hippocampus'
                        'Left-Lateral-Ventricle'
                        'Right-Lateral-Ventricle'
                        'Left-Cerebral-White-Matter'
                        'Right-Cerebral-Cortex_V13mm_setdiff.mat'};
                case 2 % Right-WhiteMatter
                    roiname = {...'Brain-Stem',...
                        'Right-Cerebellum-White-Matter'
                        'Right-Cerebellum-Cortex'
                        'Left-Cerebellum-White-Matter'
                        'Left-Cerebellum-Cortex'
                        'Left-Hippocampus'
                        'Right-Hippocampus'
                        'Left-Lateral-Ventricle'
                        'Right-Lateral-Ventricle'
                        'Right-Cerebral-White-Matter'
                        'Left-Cerebral-Cortex_V13mm_setdiff.mat'};
            end
        else i = 22;
            switch(hemisphere)
                case  1 % Left-WhiteMatter
                    roiname = {...'Brain-Stem',...
                        ...'Right-Cerebellum-White-Matter','Right-Cerebellum-Cortex',...
                        ...'Left-Cerebellum-White-Matter','Left-Cerebellum-Cortex',...
                        'Left-Hippocampus'
                        'Right-Hippocampus'
                        'Left-Lateral-Ventricle'
                        'Right-Lateral-Ventricle'
                        'Left-Cerebral-White-Matter'
                        'Right-Cerebral-Cortex_V13mm_setdiff.mat'};
                case 2 % Right-WhiteMatter
                    roiname = {...'Brain-Stem',HippoWmCerebellumVentricle...
                        ...'Right-Cerebellum-White-Matter','Right-Cerebellum-Cortex',...
                        ...'Left-Cerebellum-White-Matter','Left-Cerebellum-Cortex',...
                        'Left-Hippocampus'
                        'Right-Hippocampus'
                        'Left-Lateral-Ventricle'
                        'Right-Lateral-Ventricle'
                        'Right-Cerebral-White-Matter'
                        'Left-Cerebral-Cortex_V13mm_setdiff.mat'};
            end
        end
        
        % load all ROIs
        for j = 1:length(roiname)
            roi{j} = dtiReadRoi(roiname{j});
            
            % make sure ROI
            if 1 == isempty(roi{j}.coords)
                disp(roi{j}.name)
                disp('number of corrds = 0')
                return
            end
        end
        
        % Merge ROI one by one
        newROI = roi{1,1};
        for kk=2:length(roiname)
            newROI = dtiMergeROIs(newROI,roi{1,kk});
        end
        
        % Save the new NOT ROI
        % define file name
        
        switch(hemisphere)
            case 1 % Left-WhiteMatter
                newROI.name = 'Lh_NOT0801';
            case 2 % Right-WhiteMatter
                newROI.name = 'Rh_NOT0801';
        end
        % Save Roi
        dtiWriteRoi(newROI,newROI.name,1)
    end
end


%% dtiINtersectFibers
for i =[20,21] %1:length(subDir)
    SubDir = fullfile(homeDir,subDir{i});
    fgDir  = fullfile(SubDir,'/dwi_2nd/fibers/conTrack/OR_Top100K_V1_3mm_clipped_LGN4mm');
    roiDir = fullfile(SubDir,'/dwi_2nd/ROIs');
    dtDir  = fullfile(homeDir,subDir{i},'dwi_2nd');
    
    % ROI file names you want to merge
    for hemisphere = 1:2
        
        % Intersect raw OR with Not ROIs
        cd(fgDir)
        if i == 21
            fgF ={'fg_OR_Top100K_V1_3mm_clipped_LGN4mm_Rt-LGN4_rh_V1_smooth3mm_NOT_2013-07-28_09.05.36.pdb'
                'fg_OR_Top100K_V1_3mm_clipped_LGN4mm_Lt-LGN4_lh_V1_smooth3mm_NOT_2013-07-28_09.05.36.pdb'};
        elseif i==2
            fgF ={'fg_OR_Top100K_V1_3mm_clipped_LGN4mm_Rt-LGN4_rh_V1_smooth3mm_NOT_2013-07-17_10.55.52.pdb'
                'fg_OR_Top100K_V1_3mm_clipped_LGN4mm_Lt-LGN4_lh_V1_smooth3mm_NOT_2013-07-10_16.50.36.pdb'};
        else
            fgF = {'fg_OR_Top100K_V1_3mm_clipped_LGN4mm_Rt-LGN4_rh_V1_smooth3mm_NOT_2013-07-10_16.50.36.pdb'
                'fg_OR_Top100K_V1_3mm_clipped_LGN4mm_Lt-LGN4_lh_V1_smooth3mm_NOT_2013-07-10_16.50.36.pdb'};
        end
        
        % load fg and ROI
        fg  = fullfile(fgDir,fgF{hemisphere});
        fg  = fgRead(fg);
        
        ROIname = {'Lh_NOT0801.mat','Rh_NOT0801.mat'};
        ROIf = fullfile(roiDir, ROIname{hemisphere});
        ROI = dtiReadRoi(ROIf);
        
        % dtiIntersectFibers
        [fgOut1,contentiousFibers1, keep1, keepID1] = dtiIntersectFibersWithRoi([], 'not', [], ROI, fg);
        keep = ~keep1;
        for l =1:length(fgOut1.params)
            fgOut1.params{1,l}.stat=fgOut1.params{1,l}.stat(keep);
        end
        fgOut1.pathwayInfo = fgOut1.pathwayInfo(keep);
        
        % save new fg.pdb file
        cd(fullfile(fgDir,'NOT5_Contrack70_0731'))
        savefilename = sprintf('%s.pdb',fgOut1.name);
        mtrExportFibers(fgOut1,savefilename,[],[],[],2);
    end
end
%         %% conTrack score
%         nFiber = round(length(fgOut1.fibers)*0.7);
%         
%         % get .txt and .pdb filename
%         tmp = strfind(fgOut1.name, '_');
%         n = fgOut1.name(tmp(1):tmp(14)-4);
%         
%         dTxt = sprintf('%s/%s%s.txt',fgDir,'ctrSampler',n);
%         dPdb = sprintf('%s/%s.pdb',fgDir,fgOut1.name);
%         
%         % define filename for output fiber group
%         outputfibername = fullfile(fgDir, sprintf('%s_%d.pdb',fgOut1.name,nFiber));
%         
%         % make command to get 80% fibers for contrack
%         ContCommand = sprintf('contrack_score.glxa64 -i %s -p %s --thresh %d --sort %s', ...
%             dTxt, outputfibername, nFiber, dPdb);
%         
%         % run contrack
%         system(ContCommand);
%     end
% end
% return
% %% reduce number of fibers to 64%
% % define how many fibers you want to reduce into
% nFiber = round(nFiber*0.8);
% 
% % define filename for output fiber group
% outputfibername = fullfile(fgDir, sprintf('%s_%d.pdb',fgOut1.name,nFiber));
% 
% % make command to get 25000 fibers for contrack
% ContCommand = sprintf('contrack_score.glxa64 -i %s -p %s --thresh %d --sort %s', ...
%     dTxt, outputfibername, nFiber, dPdb);
% 
% % run contrack
% system(ContCommand);
% 
% return
%
%         % inputfiberpath = 'fgIn.pdb';
%          Ids = {...
%         '_Rt-LGN4_rh_V1_smooth3mm'
%         '_Lt-LGN4_lh_V1_smooth3mm'};
%      for ij = 1:length(Ids)
%
%         fileidentifier = Ids{ij};
%         dTxt = matchfiles(sprintf('%s/*%s*.pdb',fgDir,fileidentifier),'tr');
%         dPdb = matchfiles(sprintf('%s/*%s*.pdb',fgDir,fileidentifier),'tr');
%         [~, tmp] = fileparts(dPdb{1});
%
%     end


