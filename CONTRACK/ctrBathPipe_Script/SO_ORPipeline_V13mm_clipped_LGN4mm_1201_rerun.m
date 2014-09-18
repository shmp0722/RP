function SO_ORPipeline_V13mm_clipped_LGN4mm_1201_rerun
%
%
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
%     'LHON1-TK-20121130-DWI'
%     'LHON2-SO-20121130-DWI'
%     'LHON3-TO-20121130-DWI'
%     'LHON4-GK-20121130-DWI'
%     'LHON5-HS-20121220-DWI'
%     'LHON6-SS-20121221-DWI'
%     'JMD-Ctl-MT-20121025-DWI'
%     'JMD-Ctl-SY-20130222DWI'
%     'JMD-Ctl-YM-20121025-DWI'
%     'JMD-Ctl-HH-20120907DWI'
%     'JMD-Ctl-FN-20130621-DWI'
%     'JMD-Ctl-AM-20130726-DWI'
%     'JMD-Ctl-HT-20120907-DWI'
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
%     'RP6-SY-2014-02-28-dMRI'};
%     'Ctl-12-SA-20140307'
%     'Ctl-13-MW-20140313-dMRI-Anatomy'
%     'Ctl-14-YM-20140314-dMRI-Anatomy'
%     'RP7-EU-2014-03-14-dMRI-Anatomy'
%     'RP8-YT-2014-03-14-dMRI-Anatomy'
};

%% make new directory
for i = 1:length(subDir)
    
    SubDir = fullfile(homeDir,subDir{i});
    
    mkdir(fullfile(SubDir,'/dwi_2nd/fibers/conTrack/OR_rerun'))
    
end

% make NOT ROI
for i = 1:length(subDir)
    SubDir = fullfile(homeDir,subDir{i});
    roiDir = fullfile(SubDir,'/dwi_2nd/ROIs');
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
                        'Left-Cerebral-White-Matter'};
                    %                         'Right-Cerebral-Cortex_V13mm_setdiff.mat'};
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
                        'Right-Cerebral-White-Matter'};
                    %                         'Left-Cerebral-Cortex_V13mm_setdiff.mat'};
            end
        else 
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
                newROI.name = 'Lh_NOT1201';
            case 2 % Right-WhiteMatter
                newROI.name = 'Rh_NOT1201';
        end
        % Save Roi
        dtiWriteRoi(newROI,newROI.name,1)
    end
end


%% dtiIntersectFibers
for i = 1:length(subDir)
    SubDir = fullfile(homeDir,subDir{i});
    fgDir  = fullfile(SubDir,'/dwi_2nd/fibers/conTrack/OR_rerun');
    roiDir = fullfile(SubDir,'/dwi_2nd/ROIs');
%     newDir = fullfile(SubDir,'/dwi_2nd/fibers/conTrack/OR_rerun');
    %     dtDir  = fullfile(homeDir,subDir{i},'dwi_2nd');
    
    % ROI file names you want to merge
    for hemisphere = 1:2
        
        % Intersect raw OR with Not ROIs
        cd(fgDir)
%         if i<25
%         fgF = {'*_Rt-LGN4_rh_V1_smooth3mm_NOT_2013*.pdb'
%             '*_Lt-LGN4_lh_V1_smooth3mm_NOT_2013*.pdb'};
%         else
         fgF = {'*_Rt-LGN4_rh_V1_smooth3mm_NOT_*.pdb'
            '*_Lt-LGN4_lh_V1_smooth3mm_NOT_*.pdb'};
%         end;
        
        % load fg and ROI
        fg  = dir(fullfile(fgDir,fgF{hemisphere}));
        [~,ik] = sort(cat(2,fg.datenum),2,'ascend');
        fg = fg(ik);
        fg  = fgRead(fg(1).name);
        
        ROIname = {'Lh_NOT1201.mat','Rh_NOT1201.mat'};
        ROIf = fullfile(roiDir, ROIname{hemisphere});
        ROI = dtiReadRoi(ROIf);
        
        % dtiIntersectFibers
        [fgOut1,~, keep1, ~] = dtiIntersectFibersWithRoi([], 'not', [], ROI, fg);
        keep = ~keep1;
        for l =1:length(fgOut1.params)
            fgOut1.params{1,l}.stat=fgOut1.params{1,l}.stat(keep);
        end
        fgOut1.pathwayInfo = fgOut1.pathwayInfo(keep);
        
        % save new fg.pdb file
        
        savefilename = sprintf('%s.pdb',fgOut1.name);
        mtrExportFibers(fgOut1,savefilename,[],[],[],2);
    end
end

% %% conTrack scoring
% for i =23:length(subDir)
%     SubDir = fullfile(homeDir,subDir{i});
%     fgDir  = fullfile(SubDir,'/dwi_2nd/fibers/conTrack/OR_Top100K_V1_3mm_clipped_LGN4mm');
%     roiDir = fullfile(SubDir,'/dwi_2nd/ROIs');
%     dtDir  = fullfile(homeDir,subDir{i},'dwi_2nd');
%
%     cd(fgDir)
%
%     % Set number of fibers you want
%     nFiber = round(length(fgOut1.fibers)*0.7);
%     %15578;%5236;%10342;%round(length(fgOut1.fibers)*0.7);
%
%     % get .txt and .pdb filename
%     ORf{1} = dir('*fg_OR_Top100K_V1_3mm_clipped_LGN4mm_Rt-LGN4*-Lh_NOT1201.pdb');
%     ORf{2} = dir('*fg_OR_Top100K_V1_3mm_clipped_LGN4mm_Lt-LGN4*-Rh_NOT1201.pdb');
%     for j = 1:2
%         tmp = strfind(ORf{j}.name, '_');
%         n = ORf{j}.name(tmp(1):tmp(14)-4);
%
%         dTxt = sprintf('%s/%s%s.txt',fgDir,'ctrSampler',n);
%         dPdb = sprintf('%s/%s',fgDir,ORf{j}.name);
%
%         % Set number of fibers you want
%         fg =fgRead(dPdb);
%         nFiber = round(length(fg.fibers)*0.7);
%         %15578;%5236;%10342;%round(length(fgOut1.fibers)*0.7);
%
%         % define filename for output fiber group
%         outputfibername = fullfile(fgDir, sprintf('%s_%d.pdb',ORf{j}.name(1:end-4),nFiber));
%
%         % make command to get 80% fibers for contrack
%         ContCommand = sprintf('contrack_score.glxa64 -i %s -p %s --thresh %d --sort %s', ...
%             dTxt, outputfibername, nFiber, dPdb);
%
%         % run contrack
%         system(ContCommand);
%     end
% end


%% AFQ_removeFiberOutliers
for i =1:length(subDir)
    SubDir = fullfile(homeDir,subDir{i});
    fgDir  = fullfile(SubDir,'/dwi_2nd/fibers/conTrack/OR_rerun');
    newDir = fullfile(SubDir,'/dwi_2nd/fibers/conTrack/OR_rerun');
    %     roiDir = fullfile(SubDir,'/dwi_2nd/ROIs');
    %     dtDir  = fullfile(homeDir,subDir{i},'dwi_2nd');
    
    cd(fgDir)
    % get .pdb filename
    ORf(1) = dir('*fg_OR_Top100K_V1_3mm_clipped_LGN4mm_Rt-LGN4*NOT1201.pdb');
    ORf(2) = dir('*fg_OR_Top100K_V1_3mm_clipped_LGN4mm_Lt-LGN4*NOT1201.pdb');
    
    for ij = 1:2
        cd(fgDir)
        fg = fgRead(ORf(ij).name);
        
        % remove outlier fiber
        for k=4:5; % max distance
            cd(fgDir)
            
            maxDist = k;
            maxLen = 4;
            numNodes = 25;
            M = 'mean';
            count = 1;
            show = 1;
            
            [fgclean ,keep] =  AFQ_removeFiberOutliers(fg,maxDist,maxLen,numNodes,M,count,show);
            
            for l =1:length(fgclean.params)
                fgclean.params{1,l}.stat=fgclean.params{1,l}.stat(keep);
            end
            fgclean.pathwayInfo = fgclean.pathwayInfo(keep);
            
            % Align fiber direction from Anterior to posterior
            fgclean = SO_AlignFiberDirection(fgclean,'AP');
            
            % save new fg.pdb file
            fibername       = sprintf('%s_MD%d_rerun.pdb',fgclean.name,maxDist);
            mtrExportFibers(fgclean,fibername,[],[],[],2);
            
            %% to save the pdb file.
            cd(newDir)
            fibername       = sprintf('%s_D%d_L4_rerun.pdb',fgclean.name,maxDist);
            mtrExportFibers(fgclean,fibername,[],[],[],2);
            
        end
    end
end

% %% check fg look
% for i =1:length(subDir)
%     SubDir = fullfile(homeDir,subDir{i});
%     %     fgDir  = fullfile(SubDir,'/dwi_2nd/fibers/conTrack/OR_Top100K_V1_3mm_clipped_LGN4mm');
%     newDir = fullfile(SubDir,'/dwi_2nd/fibers/conTrack/OR_rerun');
%     %     roiDir = fullfile(SubDir,'/dwi_2nd/ROIs');
%     %     dtDir  = fullfile(homeDir,subDir{i},'dwi_2nd');
%     
%     cd(newDir)
%     % get .pdb filename
%     ORf = dir('*_D4_L4.pdb');
%     %      ORf = dir('*_D5_L4.pdb');
%     figure; hold on;
%     for ij = 1:2
%         
%         fg = fgRead(ORf(ij).name);
%         AFQ_RenderFibers(fg,'numfibers',50,'newfig',0);
%     end
%     hold off;
%     camlight 'headlight'
% end


%% Copy generated fg to fiberDirectory for AFQ analysis

for i =1:length(subDir)
    SubDir = fullfile(homeDir,subDir{i});
    fgDir  = fullfile(SubDir,'/dwi_2nd/fibers');
    newDir = fullfile(SubDir,'/dwi_2nd/fibers/conTrack/OR_rerun');
    %     roiDir = fullfile(SubDir,'/dwi_2nd/ROIs');
    %     dtDir  = fullfile(homeDir,subDir{i},'dwi_2nd');
    
    cd(newDir)
    % get .pdb filename
    LORf = dir('*Lt-LGN4*_D4_L4_rerun.pdb');
    RORf = dir('*Rt-LGN4*_D4_L4_rerun.pdb');
    
    %      ORf = dir('*_D5_L4.pdb');
    %     for ij = 1:2
    %         cd(newDir)
    fgL = fgRead(LORf.name);
    fgR = fgRead(RORf.name);
    cd(fgDir)
    fgL.name = 'LOR1206_D4L4_rerun';
    fgR.name = 'ROR1206_D4L4_rerun';
    %         fgWrite(fgL,[fgL.name ,'.pdb'],'.pdb')
    mtrExportFibers(fgL, fgL.name, [], [], [], 2);
    mtrExportFibers(fgR, fgR.name, [], [], [], 2);
    %         fgWrite(fgR,'ROR1206_D4L4.pdb','.pdb')
    %     end
end
return
%% measure diffusion properties
% see runSO_DivideFibersAcordingToFiberLength_3SD

% %% check fascicles shape
% 
% for i =1:length(subDir)
%     SubDir = fullfile(homeDir,subDir{i});
%     fgDir  = fullfile(SubDir,'/dwi_2nd/fibers');
%     newDir = fullfile(SubDir,'/dwi_2nd/fibers/conTrack/OR_rerun');
%     %     roiDir = fullfile(SubDir,'/dwi_2nd/ROIs');
%     %     dtDir  = fullfile(homeDir,subDir{i},'dwi_2nd');
%     
%     cd(newDir)
%     % get .pdb filename
%     LORf = dir('*Lt-LGN4*_D4_L4.pdb');
%     RORf = dir('*Rt-LGN4*_D4_L4.pdb');
%     
%     %      ORf = dir('*_D5_L4.pdb');
%     %     for ij = 1:2
%     %         cd(newDir)
%     fgL = fgRead(LORf.name);
%     fgR = fgRead(RORf.name);
%     
%     % Render fascicles
%     figure; hold on;
%     AFQ_RenderFibers(fgL, 'numfiber',100,'newfig',0)
%     AFQ_RenderFibers(fgR, 'numfiber',100,'newfig',0)
%     camlight 'headlight';
%     axis image
%     axis off;
%     
% end


%% AFQ_removeFiberOutliers
for i =1:length(subDir)
    SubDir = fullfile(homeDir,subDir{i});
    fgDir  = fullfile(SubDir,'/dwi_2nd/fibers/conTrack/OR_rerun');
    newDir = fullfile(SubDir,'/dwi_2nd/fibers/conTrack/OR_rerun');
    %     roiDir = fullfile(SubDir,'/dwi_2nd/ROIs');
    %     dtDir  = fullfile(homeDir,subDir{i},'dwi_2nd');
    
    cd(fgDir)
    % get .pdb filename
    ORf(1) = dir('*Rh_NOT1201.pdb');
    ORf(2) = dir('*Lh_NOT1201.pdb');
    
    for ij = 1:2
        cd(fgDir)
        fg = fgRead(ORf(ij).name);
        
        % remove outlier fiber
        %         for k=4; % max distance
        cd(fgDir)
        
        maxDist =4;
        maxLen = 2;
        numNodes = 50;
        M = 'mean';
        count = 1;
        show = 1;
        
        [fgclean ,keep] =  AFQ_removeFiberOutliers(fg,maxDist,maxLen,numNodes,M,count,show);
        
        for l =1:length(fgclean.params)
            fgclean.params{1,l}.stat=fgclean.params{1,l}.stat(keep);
        end
        fgclean.pathwayInfo = fgclean.pathwayInfo(keep);
        
        % Align fiber direction from Anterior to posterior
        fgclean = SO_AlignFiberDirection(fgclean,'AP');
        
        % save new fg.pdb file
        fibername       = sprintf('%s_D4L2_rerun.pdb',fgclean.name);
        mtrExportFibers(fgclean,fibername,[],[],[],2);
        
        %% to save the pdb file.
        cd(newDir)
        fibername       = sprintf('%s_D4_L2_rerun.pdb',fgclean.name);
        mtrExportFibers(fgclean,fibername,[],[],[],2);
        
        %         end
    end
end
% %% check fg look
% for i =1:length(subDir)
%     SubDir = fullfile(homeDir,subDir{i});
%     %     fgDir  = fullfile(SubDir,'/dwi_2nd/fibers/conTrack/OR_Top100K_V1_3mm_clipped_LGN4mm');
%     newDir = fullfile(SubDir,'/dwi_2nd/fibers/conTrack/OR_rerun');
%     %     roiDir = fullfile(SubDir,'/dwi_2nd/ROIs');
%     %     dtDir  = fullfile(homeDir,subDir{i},'dwi_2nd');
%     
%     cd(newDir)
%     % get .pdb filename
%     ORf = dir('*_D4_L2.pdb');
%     %      ORf = dir('*_D5_L4.pdb');
%     figure; hold on;
%     for ij = 1:2
%         
%         fg = fgRead(ORf(ij).name);
%         AFQ_RenderFibers(fg,'numfibers',50,'newfig',0);
%     end
%     hold off;
%     camlight 'headlight'
% end
