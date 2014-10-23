function run_V1RoiCutEccentricity(MakeEccROI,contrackgen,cleanfiber)
%
%
%
%% idnetify ID
[homeDir,subDir] = Tama_subj;

%% eccentricity ROI
% requirements fs_retinotopicmap
if istrue(MakeEccROI);
    MinDegree = [1,6,11,16,21,31];
    MaxDegree = [5,10,15,20,30,90];
    
    for i =1:length(MaxDegree)
        V1RoiCutEccentricity(MinDegree(i), MaxDegree(i))
    end
    
    %% copy ROI for generating fibers
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
else
end

%% contrack OR generation
% S_CtrInitBatchPipeline
% Multi-Subject Tractography

% Set ctrInitBatchParams
% Creatre params structure
ctrParams = ctrInitBatchParams;

ctrParams.projectName = 'V1eccentricity2';
ctrParams.logName = 'myConTrackLog';
ctrParams.baseDir = homeDir;
ctrParams.dtDir = 'dwi_2nd';
ctrParams.roiDir = '/dwi_2nd/Eccentricity';
ctrParams.subs =subDir;

ctrParams.roi1 = {'Rt-LGN4','Rt-LGN4','Rt-LGN4','Rt-LGN4','Rt-LGN4','Rt-LGN4',...
    'Lt-LGN4','Lt-LGN4','Lt-LGN4','Lt-LGN4','Lt-LGN4','Lt-LGN4'};
ctrParams.roi2 = {'rh_Ecc1to5','rh_Ecc6to10','rh_Ecc11to15','rh_Ecc16to20','rh_Ecc21to30','rh_Ecc31to90'...
    'lh_Ecc1to5','lh_Ecc6to10','lh_Ecc11to15','lh_Ecc16to20','lh_Ecc21to30','lh_Ecc31to90'};

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


%% run contrack gen
if istrue(contrackgen);
    [cmd] = ctrInitBatchTrack(ctrParams);
    system(cmd);
else
end

%% Check to see who is done
id_R = zeros(1,length(subDir)); id_L = zeros(1,length(subDir));

for i = 1:length(subDir) % 22
    fgDir  = fullfile(homeDir,subDir{i},'/dwi_2nd/fibers/conTrack/V1eccentricity2');
    %         roiDir = fullfile(homeDir,subDir{i},'/dwi_2nd/ROIs');% should change
    %         dt6    = fullfile(homeDir,subDir{i},'/dwi_2nd/dt6.mat');
    %         dt6     = dtiLoadDt6(dt6);
    FG_R = dir(fullfile(fgDir,'*Rt-LGN4*.pdb'));
    FG_L = dir(fullfile(fgDir,'*Lt-LGN4*.pdb'));
    
    if length(FG_R)>=5,
        id_R(1,i)=1;end
    if length(FG_L)>=5,id_L(1,i)=1;end
end

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


%% Clean fibers
if istrue(cleanfiber);
    for i = 1:length(subDir) % 22
        fgDir  = fullfile(homeDir,subDir{i},'/dwi_2nd/fibers/conTrack',ctrParams.projectName);
        roiDir = fullfile(homeDir,subDir{i},'/dwi_2nd/ROIs');% should change
%         dt6    = fullfile(homeDir,subDir{i},'/dwi_2nd/dt6.mat');
%         dt6     = dtiLoadDt6(dt6);
        
        % ROI file names you want to merge
        %         for hemisphere = 1:2
        for r =1:length(ctrParams.roi2)
            % Intersect raw OR with Not ROIs
            fgF = ['*',ctrParams.roi2{r},'*.pdb'];            
            % load fg
            fg     = dir(fullfile(fgDir,fgF));
            [~,ik] = sort(cat(2,fg.datenum),2,'ascend');
            fg     = fg(ik);
            fg     = fgRead(fullfile(fgDir,fg(1).name));
            
            %                 % Cut the fibers below the acpc plane, to disentangle CST & ATL crossing
            %                 % at the level of the pons
            %                 fgname  = fg.name;
            %                 fg      = dtiSplitInterhemisphericFibers(fg, dt6, -15);
            %                 fg.name = fgname;
            
            % exculde fibers based on wayppoint ROI
            ROIname = {'Lh_NOT1201.mat','Rh_NOT1201.mat'};
            if r <=6,
                ROIf = fullfile(roiDir, ROIname{1});
            else
                ROIf = fullfile(roiDir, ROIname{2});
            end
            ROI = dtiReadRoi(ROIf);
            [fgOut1,~, ~, ~] = dtiIntersectFibersWithRoi([], 'not', [], ROI, fg);
            size(fgOut1.fibers)
            % Remove outlier fibers
            maxDist = 3;  maxLen = 3;   numNodes = 100;
            M = 'mean';
            count = 1;  show = 1;
            [fgclean ,~] =  AFQ_removeFiberOutliers(fgOut1,maxDist,maxLen,numNodes,M,count,show);
            
            %                 % get diffusivities along the fiber
            %                 direction = 'AP'; Nodes = 100;
            %                 TractProfile{i,hemisphere,r} = SO_FiberValsInTractProfiles(fgclean,dt6,direction,Nodes,1);
            %                 % save new fg.pdb file
            savefilename = sprintf('%s/%s_D%dL%d.pdb',fgDir,fgclean.name,maxDist,maxLen);
            fgWrite(fgclean,savefilename,'pdb');
        end
    end
    %     end
else
end
return

%% measure diffusion properties
for i = 1:length(subDir)
    fgDir  = fullfile(homeDir,subDir{i},'/dwi_2nd/fibers/conTrack',ctrParams.projectName);
    %     roiDir = fullfile(homeDir,sufor l = 1:5;%:length(ctrParams.roi2)
    dt6    = fullfile(homeDir,subDir{i},'/dwi_2nd/dt6.mat');
    dt6    = dtiLoadDt6(dt6);
    direction ='AP';
    Nodes  = 100;
    %
    for l = 1:length(ctrParams.roi2)
        if l<= 6,
            fgF = ['*',ctrParams.roi2{l},'*Lh_NOT1201*_D3L3.pdb'];
        else
            fgF = ['*',ctrParams.roi2{l},'*Rh_NOT1201*_D3L3.pdb'];
        end
        FG     = dir(fullfile(fgDir,fgF));
        [~,ik] = sort(cat(2,FG.datenum),2,'ascend');
        FG     = FG(ik);
        fg     = fgRead(fullfile(fgDir,FG(1).name));
                
        sprintf('Calcurating %s',FG.name)
        TractProfile{i,l} = SO_FiberValsInTractProfiles(fg,dt6,direction,Nodes,1);
    end
end
save TP_39_Eccecntricity TractProfile


%% plot
[homeDir,subDir] = Tama_subj;


figure; hold on;
X = 1:100;
c = jet(5);
%
for l = 1:5;%:length(ctrParams.roi2)
    plot(X, TractProfile{1,l,1}.vals.fa,'color',c(l,:),'linewidth',2)
end

legend(ctrParams.roi2{1:5})


