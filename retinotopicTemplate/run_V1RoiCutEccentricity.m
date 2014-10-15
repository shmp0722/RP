%% run_V1RoiCutEccentricity
[homeDir,subDir] = Tama_subj;

%% eccentricity
MinDegree = [1,6,11,16,21];
MaxDegree = [5,10,15,20,30];

for i =1:length(MaxDegree)
    V1RoiCutEccentricity(MinDegree(i), MaxDegree(i))
end
%% copy ROI for contrac fiber generation
% Eccentricity ROI
for i =1:length(subDir)
    ROIfiles = fullfile(homeDir,subDir{i},'/fs_Retinotopy2/*.mat');
    copyfile(ROIfiles,fullfile(homeDir,subDir{i},'/dwi_2nd/Eccentricity'))
end
% LGN ROI
for i =1:length(subDir)
    ROIfiles = fullfile(homeDir,subDir{i},'/dwi_2nd/ROIs/*LGN4.mat');
    copyfile(ROIfiles,fullfile(homeDir,subDir{i},'/dwi_2nd/Eccentricity'))
end

%% contrack OR generation
% S_CtrInitBatchPipeline
% Multi-Subject Tractography

% Set ctrInitBatchParams
% Creatre params structure
ctrParams = ctrInitBatchParams;

ctrParams.projectName = 'V1eccentricity';
ctrParams.logName = 'myConTrackLog';
ctrParams.baseDir = homeDir;
ctrParams.dtDir = 'dwi_2nd';
ctrParams.roiDir = '/dwi_2nd/Eccentricity';
ctrParams.subs = {subDir{1},subDir{2}};

ctrParams.roi1 = {'Rt-LGN4','Rt-LGN4','Rt-LGN4','Rt-LGN4','Rt-LGN4',...
    'Lt-LGN4','Lt-LGN4','Lt-LGN4','Lt-LGN4','Lt-LGN4'};
ctrParams.roi2 = {'rh_Ecc1to5','rh_Ecc6to10','rh_Ecc11to15','rh_Ecc16to20','rh_Ecc21to30',...
    'lh_Ecc1to5','lh_Ecc6to10','lh_Ecc11to15','lh_Ecc16to20','lh_Ecc21to30'};

ctrParams.nSamples = 10000;
ctrParams.maxNodes = 240;
ctrParams.minNodes = 30;
ctrParams.stepSize = 1;
ctrParams.pddpdfFlag = 0;
ctrParams.wmFlag = 0;
ctrParams.oi1SeedFlag = 'true';
ctrParams.oi2SeedFlag = 'true';
ctrParams.multiThread = 0;
ctrParams.xecuteSh = 0;


% Run ctrInitBatchTrack
[cmd] = ctrInitBatchTrack(ctrParams);
system(cmd);

%% Clean up fibers
% % make NOT ROI
% for i = 1:2;%length(subDir)
%     SubDir = fullfile(homeDir,subDir{i});
%     roiDir = fullfile(SubDir,'/dwi_2nd/ROIs');
%
%     % ROI file names you want to merge
%     for hemisphere = 1:2
%         if i<22
%             switch(hemisphere)
%                 case  1 % Left-WhiteMatter
%                     roiname = {...
%                         'Right-Cerebellum-White-Matter'
%                         'Right-Cerebellum-Cortex'
%                         'Left-Cerebellum-White-Matter'
%                         'Left-Cerebellum-Cortex'
%                         'Left-Hippocampus'
%                         'Right-Hippocampus'
%                         'Left-Lateral-Ventricle'
%                         'Right-Lateral-Ventricle'
%                         'Left-Cerebral-White-Matter'};
%                 case 2 % Right-WhiteMatter
%                     roiname = {...
%                         'Right-Cerebellum-White-Matter'
%                         'Right-Cerebellum-Cortex'
%                         'Left-Cerebellum-White-Matter'
%                         'Left-Cerebellum-Cortex'
%                         'Left-Hippocampus'
%                         'Right-Hippocampus'
%                         'Left-Lateral-Ventricle'
%                         'Right-Lateral-Ventricle'
%                         'Right-Cerebral-White-Matter'};
%             end
%         else
%         end
%
%         % load all ROIs
%         for j = 1:length(roiname)
%             roi{j} = dtiReadRoi(fullfile(roiDir, roiname{j}));
%
%             % make sure ROI
%             if 1 == isempty(roi{j}.coords)
%                 disp(roi{j}.name)
%                 disp('number of corrds = 0')
%                 return
%             end
%         end
%
%         % Merge ROI one by one
%         newROI = roi{1,1};
%         for kk=2:length(roiname)
%             newROI = dtiMergeROIs(newROI,roi{1,kk});
%         end
%
%         % Save the new NOT ROI
%         switch(hemisphere)
%             case 1 % Left-WhiteMatter
%                 newROI.name = 'Lh_NOT1201';
%             case 2 % Right-WhiteMatter
%                 newROI.name = 'Rh_NOT1201';
%         end
%         % Save Roi
%         dtiWriteRoi(newROI,fullfile(roiDir,newROI.name),1)
%     end
% end


%% dtiIntersectFibers
for i = 1:2;% 2:length(subDir) % 22
    fgDir  = fullfile(homeDir,subDir{i},'/dwi_2nd/fibers/conTrack',ctrParams.projectName);
    roiDir = fullfile(homeDir,subDir{i},'/dwi_2nd/ROIs');% should change
    dt6    = fullfile(homeDir,subDir{i},'/dwi_2nd/dt6.mat');
    dt6     = dtiLoadDt6(dt6);
    
    % ROI file names you want to merge
    for hemisphere = 1:2
        for r = 1:length(ctrParams.roi2)
            % Intersect raw OR with Not ROIs
            fgF = ['*',ctrParams.roi2{r},'*.pdb'];
            %             '*_Lt-LGN4_lh_V1_smooth3mm_NOT_*.pdb'};
            
            % load fg and ROI
            fg     = dir(fullfile(fgDir,fgF));
            [~,ik] = sort(cat(2,fg.datenum),2,'ascend');
            fg     = fg(ik);
            fg     = fgRead(fg(1).name);
            
            
            % Cut the fibers below the acpc plane, to disentangle CST & ATL crossing
            % at the level of the pons
            fgname  = fg.name;
            fg      = dtiSplitInterhemisphericFibers(fg, dt6, -15);
            fg.name = fgname;
            
            % exculde fibers based on wayppoint ROI
            ROIname = {'Lh_NOT1201.mat','Rh_NOT1201.mat'};
            ROIf = fullfile(roiDir, ROIname{hemisphere}); 
            ROI = dtiReadRoi(ROIf);
            
            % dtiIntersectFibers using waypoint ROIs
            [fgOut1,~, keep1, ~] = dtiIntersectFibersWithRoi([], 'not', [], ROI, fg);
            
            % Remove outlier fibers
            maxDist = 3;  maxLen = 3;   numNodes = 100;
            M = 'mean';
            count = 1;  show = 1;
            
            [fgclean ,keep] =  AFQ_removeFiberOutliers(fgOut1,maxDist,maxLen,numNodes,M,count,show);
            
            % save new fg.pdb file
            savefilename = sprintf('%s_D%dL%d.pdb',fgOut1.name,maxDist,maxLen);
            fgWrite(fgOut1,savefilename,'pdb');
        end
    end
end

%% measure diffusion properties
% see runSO_DivideFibersAcordingToFiberLength_3SD
