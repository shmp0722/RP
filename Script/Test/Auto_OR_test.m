%%
homeDir = '/biac4/wandell/biac3/wandell4/data/reading_longitude/dti_adults';
FsDir = '/biac4/wandell/biac2/wandell/data/DWI-Tamagawa-Japan';

subDir = {'aab050307','ah051003','am090121','ams051015','as050307'...
    'aw040809','bw040922','ct060309','db061209','dla050311'...
    'gd040901','gf050826','gm050308','jl040902','jm061209'...
    'jy060309','ka040923','mbs040503','me050126','mo061209'...
    'mod070307','mz040828','pp050208','rfd040630','rk050524'...
    'sc060523','sd050527','sn040831','sp050303','tl051015'};


%% 2) Just cut calcarine in two.

for i= 1:2%length(subDir);
    %% Get fs ROIs
    fsDir  = fullfile(homeDir,'freesurfer',subDir{i});
    RoiDir = fullfile(homeDir,subDir{i},'dwi_2nd/ROIs');
    cd(fullfile(fsDir, 'mri'))
    
    t1Anatfile = fullfile(homeDir, subDir{i},'t1','t1.nii.gz');
    outfile    = fullfile(fsDir,'mri','aparc+aseg.nii.gz');
    fsIn = fs_mgzSegToNifti('aparc+aseg.mgz', t1Anatfile, outfile);
    
    %% generate pericalcaline ROI from fs label file
    labelVal = {'1021','2021'};
    outfileName = {'ctx-lh-pericalcarine',...
        'ctx-rh-pericalcarine'};
   
    
    % create niftiROIs from label file
    for ii = 1:length(outfileName);
        savefile =fullfile(fsDir,'mri',outfileName{ii});
        fs_aparcAsegLabelToNiftiRoi(fsIn,labelVal{ii},savefile)
    end
    
    
    % load nifti ROI and transform ROIs to mat file
    for jj=1:length(outfileName);
        nifti       = [outfileName{jj}, '.nii.gz'];
        maskValue   =  0;       % All nonZero values are used for the mask
        outName     = [outfileName{jj}, '.mat'];
        outType     = 'mat';
        binary      = true;
        save        = 0;
        cur_matROI(jj)  = dtiRoiFromNifti(nifti,maskValue,outName,outType,binary,save);
    end
    
    % Clip calcarine ROI at the point y1, y2
    
    % just cut half off
    Y1 = minmax(cur_matROI(1).coords(:,2,:));
    Y2 = minmax(cur_matROI(2).coords(:,2,:));
    %     y1 = mean(Y1); y2 =mean(Y1);
    
    % cut roi based on percentile (tentative 70%)
    p = 70;
    y1 = prctile([Y1(1):Y1(2)],p);
    y2 = prctile([Y2(1):Y2(2)],p);
    
    [~, roiNot1] = dtiRoiClip(cur_matROI(1), [], [Y1(1), y1], []);
    [~, roiNot2] = dtiRoiClip(cur_matROI(2), [], [Y2(1), y2], []);
    
    % save ROIs
    cd(RoiDir)
    dtiWriteRoi(roiNot1,roiNot1.name,1);
    dtiWriteRoi(roiNot2,roiNot2.name,1);
    
    %     % render Calcarine rois and t1 image together
    %     figure; hold on;
    %     c= jet(4);
    %
    %     AFQ_RenderRoi(roiNot1, c(1,:));
    %     AFQ_RenderRoi(roiNot2, c(2,:));
    %
    %     t1f  = fullfile(homeDir,subDir{i},'t1/t1.nii.gz');
    %
    %     t1 = niftiRead(t1f);
    %     AFQ_AddImageTo3dPlot(t1,[0 0 -1])
    %
    %     axis image
    %     view(0 ,89);
    %     camlight('headlight')
    %     hold off;
    %     clear cur_matROI
end


%% generate OR fasicles using Sherbondy conTrack

ctrParams = ctrInitBatchParams;

ctrParams.projectName = 'AutoOpticPathway2';
ctrParams.logName = 'myConTrackLog';
ctrParams.baseDir = homeDir;
ctrParams.dtDir = 'dwi_2nd';
ctrParams.roiDir = '/dwi_2nd/ROIs';
ctrParams.subs = {'aab050307','ah051003'};%subDir;

% set parameter

ctrParams.roi1 = {'Lt_LGNrect','Rt_LGNrect'};
ctrParams.roi2 = {'ctx-lh-pericalcarine_NOT','ctx-rh-pericalcarine_NOT'};
ctrParams.nSamples = 100000;
ctrParams.maxNodes = 240;
ctrParams.minNodes = 10;
ctrParams.stepSize = 1;
ctrParams.pddpdfFlag = 0;
ctrParams.wmFlag = 0;
ctrParams.oi1SeedFlag = 'true';
ctrParams.oi2SeedFlag = 'true';
ctrParams.multiThread = 0;
ctrParams.xecuteSh = 0;


%% Run ctrInitBatchTrack
[cmd, ~] = ctrInitBatchTrack(ctrParams);
%%
system(cmd);

%% Make NOT ROI
for i = 1:2%:2;%length(subDir)
    SubDir = fullfile(homeDir,subDir{i});    
    fsDir  = fullfile(FsDir,'freesurfer',subDir{i});
    RoiDir = fullfile(SubDir,'dwi_2nd/ROIs');
    cd(fullfile(fsDir, 'mri'))
    
    % ROI file names you want to merge
    for hemisphere = 1:2
        switch(hemisphere)
            case  1 % Left-WhiteMatter
                roiname = {...
                    'Right-Cerebellum-White-Matter'
                    'Right-Cerebellum-Cortex'
                    'Left-Cerebellum-White-Matter'
                    'Left-Cerebellum-Cortex'
                    'Left-Hippocampus'
                    'Right-Hippocampus'
                    'Left-Lateral-Ventricle'
                    'Right-Lateral-Ventricle'
                    'Left-Cerebral-White-Matter'};
                labels = [46 47 7 8 17 53 75 76 2];
            case 2 % Right-WhiteMatter
                roiname = {...
                    'Right-Cerebellum-White-Matter'
                    'Right-Cerebellum-Cortex'
                    'Left-Cerebellum-White-Matter'
                    'Left-Cerebellum-Cortex'
                    'Left-Hippocampus'
                    'Right-Hippocampus'
                    'Left-Lateral-Ventricle'
                    'Right-Lateral-Ventricle'
                    'Right-Cerebral-White-Matter'};
                labels = [46 47 7 8 17 53 75 76 41];
        end
        
        
        
        %% Get fs ROIs
        %         fsDir  = fullfile(FsDir,subDir{i});
        RoiDir = fullfile(homeDir,subDir{i},'dwi_2nd/ROIs');
        %         cd(fullfile(fsDir, 'mri'))
        t1Anatfile = fullfile(homeDir, subDir{i},'t1','t1.nii.gz');
        outfile    = fullfile(fsDir,'mri','aparc+aseg.nii.gz');
        fsIn = 'aparc+aseg.nii.gz';
        
        %         fsIn    = fullfile(FsDir,'mri','aparc+aseg.nii.gz');
        
        %% exclude freesurfer nifti ROIs        
        % create niftiROI based on label file
        for ii = 1:length(outfileName);
            savefile =fullfile(fsDir,'mri',roiname{ii});
            fs_aparcAsegLabelToNiftiRoi(fsIn,labels(ii),savefile)
        end
        
        %% load nifti ROI
        for jj=1:length(outfileName);
            nifti       = [outfileName{jj}, '.nii.gz'];
            maskValue   =  0;       % All nonZero values are used for the mask
            outName     = [outfileName{jj}, '.mat'];
            outType     = 'mat';
            binary      = true;
            save        = true;
            cur_matROI(jj)  = dtiRoiFromNifti(nifti,maskValue,outName,outType,binary,save);            
        end
        
       
            % make sure ROI
            if 1 == isempty(cur_matROI(jj).coords)
                disp(cur_matROI(jj).name)
                disp('number of coords = 0')
                return
            end
        
        
        % Merge ROI one by one
        newROI = cur_matROI(1,1);
        for kk=2:length(cur_matROI)
            newROI = dtiMergeROIs(newROI,cur_matROI(kk));
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
for i = 1:2%length(subDir)
    SubDir = fullfile(homeDir,subDir{i});
    fgDir  = fullfile(SubDir,'/dwi_2nd/fibers/conTrack/AutoOpticPathway2');
    roiDir = fullfile(SubDir,'/dwi_2nd/ROIs');
%     newDir = fullfile(SubDir,'/dwi_2nd/fibers/conTrack/OR_1130');
    %     dtDir  = fullfile(homeDir,subDir{i},'dwi_2nd');
    
    % ROI file names you want to merge
    for hemisphere = 1:2
        
        % Intersect raw OR with Not ROIs
        cd(fgDir)
        %         if i<25
        %         fgF = {'*_Rt-LGN4_rh_V1_smooth3mm_NOT_2013*.pdb'
        %             '*_Lt-LGN4_lh_V1_smooth3mm_NOT_2013*.pdb'};
        %         else
        fgF = {'*_Rt_LGNrect_ctx-rh*.pdb'
            '*_Lt_LGNrect_ctx-lh*.pdb'};
        %         end;
        
        % load fg and ROI
        fg  = dir(fullfile(fgDir,fgF{hemisphere}));
        [~,ik] = sort(cat(2,fg.datenum),2,'ascend');
        fg = fg(ik);
        fg  = fgRead(fg(1).name);
        
        ROIname = {'Lh_NOT1201.mat','Rh_NOT1201.mat'};
        ROIf = fullfile(roiDir, ROIname{hemisphere});
        ROI = dtiReadRoi(fullfile(roiDir, ROIf));
        
        % dtiIntersectFibers
        [fgOut1,~, keep1, ~] = dtiIntersectFibersWithRoi([], 'not', [], ROI, fg);
        % for contrack scoring, we keep pathwayinfo
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

%% AFQ_removeFiberOutliers
for i =1:2;%length(subDir)
    SubDir = fullfile(homeDir,subDir{i});
    fgDir  = fullfile(SubDir,'/dwi_2nd/fibers/conTrack/OR_Top100K_V1_3mm_clipped_LGN4mm');
    newDir = fullfile(SubDir,'/dwi_2nd/fibers/conTrack/OR_1130');
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
            fibername       = sprintf('%s_MD%d.pdb',fgclean.name,maxDist);
            mtrExportFibers(fgclean,fibername,[],[],[],2);
            
            %% to save the pdb file.
            cd(newDir)
            fibername       = sprintf('%s_D%d_L4.pdb',fgclean.name,maxDist);
            mtrExportFibers(fgclean,fibername,[],[],[],2);
            
        end
    end
end

%% check fg look
for i =1:length(subDir)
    SubDir = fullfile(homeDir,subDir{i});
    %     fgDir  = fullfile(SubDir,'/dwi_2nd/fibers/conTrack/OR_Top100K_V1_3mm_clipped_LGN4mm');
    newDir = fullfile(SubDir,'/dwi_2nd/fibers/conTrack/OR_1130');
    %     roiDir = fullfile(SubDir,'/dwi_2nd/ROIs');
    %     dtDir  = fullfile(homeDir,subDir{i},'dwi_2nd');
    
    cd(newDir)
    % get .pdb filename
    ORf = dir('*_D4_L4.pdb');
    %      ORf = dir('*_D5_L4.pdb');
    figure; hold on;
    for ij = 1:2
        
        fg = fgRead(ORf(ij).name);
        AFQ_RenderFibers(fg,'numfibers',50,'newfig',0);
    end
    hold off;
    camlight 'headlight'
end


%% Copy generated fg to fiberDirectory for AFQ analysis

for i =1:length(subDir)
    SubDir = fullfile(homeDir,subDir{i});
    fgDir  = fullfile(SubDir,'/dwi_2nd/fibers');
    newDir = fullfile(SubDir,'/dwi_2nd/fibers/conTrack/OR_1130');
    %     roiDir = fullfile(SubDir,'/dwi_2nd/ROIs');
    %     dtDir  = fullfile(homeDir,subDir{i},'dwi_2nd');
    
    cd(newDir)
    % get .pdb filename
    LORf = dir('*Lt-LGN4*_D4_L4.pdb');
    RORf = dir('*Rt-LGN4*_D4_L4.pdb');
    
    %      ORf = dir('*_D5_L4.pdb');
    %     for ij = 1:2
    %         cd(newDir)
    fgL = fgRead(LORf.name);
    fgR = fgRead(RORf.name);
    cd(fgDir)
    fgL.name = 'LOR1206_D4L4';
    fgR.name = 'ROR1206_D4L4';
    %         fgWrite(fgL,[fgL.name ,'.pdb'],'.pdb')
    mtrExportFibers(fgL, fgL.name, [], [], [], 2);
    mtrExportFibers(fgR, fgR.name, [], [], [], 2);
    %         fgWrite(fgR,'ROR1206_D4L4.pdb','.pdb')
    %     end
end

%% measure diffusion properties
% see runSO_DivideFibersAcordingToFiberLength_3SD

%% check fascicles shape

for i =1:length(subDir)
    SubDir = fullfile(homeDir,subDir{i});
    fgDir  = fullfile(SubDir,'/dwi_2nd/fibers');
    newDir = fullfile(SubDir,'/dwi_2nd/fibers/conTrack/OR_1130');
    %     roiDir = fullfile(SubDir,'/dwi_2nd/ROIs');
    %     dtDir  = fullfile(homeDir,subDir{i},'dwi_2nd');
    
    cd(newDir)
    % get .pdb filename
    LORf = dir('*Lt-LGN4*_D4_L4.pdb');
    RORf = dir('*Rt-LGN4*_D4_L4.pdb');
    
    %      ORf = dir('*_D5_L4.pdb');
    %     for ij = 1:2
    %         cd(newDir)
    fgL = fgRead(LORf.name);
    fgR = fgRead(RORf.name);
    
    % Render fascicles
    figure; hold on;
    AFQ_RenderFibers(fgL, 'numfiber',100,'newfig',0)
    AFQ_RenderFibers(fgR, 'numfiber',100,'newfig',0)
    camlight 'headlight';
    axis image
    axis off;
    
end


%% AFQ_removeFiberOutliers
for i =1:length(subDir)
    SubDir = fullfile(homeDir,subDir{i});
    fgDir  = fullfile(SubDir,'/dwi_2nd/fibers/conTrack/OR_Top100K_V1_3mm_clipped_LGN4mm');
    newDir = fullfile(SubDir,'/dwi_2nd/fibers/conTrack/OR_1130');
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
        fibername       = sprintf('%s_D4L2.pdb',fgclean.name);
        mtrExportFibers(fgclean,fibername,[],[],[],2);
        
        %% to save the pdb file.
        cd(newDir)
        fibername       = sprintf('%s_D4_L2.pdb',fgclean.name);
        mtrExportFibers(fgclean,fibername,[],[],[],2);
        
        %         end
    end
end
%% check fg look
for i =1:length(subDir)
    SubDir = fullfile(homeDir,subDir{i});
    %     fgDir  = fullfile(SubDir,'/dwi_2nd/fibers/conTrack/OR_Top100K_V1_3mm_clipped_LGN4mm');
    newDir = fullfile(SubDir,'/dwi_2nd/fibers/conTrack/OR_1130');
    %     roiDir = fullfile(SubDir,'/dwi_2nd/ROIs');
    %     dtDir  = fullfile(homeDir,subDir{i},'dwi_2nd');
    
    cd(newDir)
    % get .pdb filename
    ORf = dir('*_D4_L2.pdb');
    %      ORf = dir('*_D5_L4.pdb');
    figure; hold on;
    for ij = 1:2
        
        fg = fgRead(ORf(ij).name);
        AFQ_RenderFibers(fg,'numfibers',50,'newfig',0);
    end
    hold off;
    camlight 'headlight'
end
