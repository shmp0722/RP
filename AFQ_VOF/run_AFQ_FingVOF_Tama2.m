%% Run AFQ_FindVOF2
%% difine argument
[homeDir,subDir] = Tama_subj2;

% %% Check who is not done
% 
% id = ones(1,length(subDir));
% 
% for i = 1:length(subDir)
%     %% load files
%     % whole brain connectome
%     wholebrainfgPath =fullfile(homeDir,subDir{i},...
%         '/dwi_2nd/fibers/WBC_mrtrix/dwi2nd_aligned_trilin_csd_lmax2_dwi2nd_aligned_trilin_brainmask_dwi2nd_aligned_trilin_wm_prob-500000.pdb');
%     
%     % transform WB.pdb to WB.mat
%     %         [a,b,c]=fileparts(wholebrainfgPath);
%     %         cd(a)
%     
%     % pick undone subject up
%     if ~exist(wholebrainfgPath);
%         sprintf('Subject-%d %s does not have WBC',i,subDir{i})
%         id(1,i) = 0;
%     end;
%     
% end
% 
% %% Whole brain connectome
% for i =find(id==0);
%     % set directory
%     SubDir = fullfile(homeDir,subDir{i});
%     fgDir  = fullfile(SubDir,'/dwi_2nd/fibers/WBC_mrtrix');
%     dtDir  = fullfile(SubDir,'dwi_2nd');
%     
%     % load dt6 file
%     dt  = fullfile(dtDir,'dt6.mat');
%     
%     % whole brain connectome
%     [status, results, fg, pathstr] = SO_feTrack_Tama2('prob',dt,fgDir,2,500000,[]);
%     fgWrite(fg,fg.name,'mat')
% end
% %% Find VOF using mrTrix connectome
% for i =find(id==0);
%     %% load files
%     % whole brain connectome
%     wholebrainfgPath =fullfile(homeDir,subDir{i},...
%         '/dwi_2nd/fibers/life_mrtrix/dwi2nd_aligned_trilin_csd_lmax2_dwi2nd_aligned_trilin_brainmask_dwi2nd_aligned_trilin_wm_prob-500000.pdb');
%     
%     if ~exist(wholebrainfgPath);
%         display([subDir{i},'-- Has No Whole brain connectome']);
%     else
%         
%         
%         % transform WB.pdb to WB.mat
%         [a,b,c]=fileparts(wholebrainfgPath);
%         cd(a)
%         Pdb2mat(wholebrainfgPath);
%         wholebrainfgPath = [a,'/', b, '.mat'];
%         % dt and T1
%         dt = fullfile(homeDir,subDir{i},'/dwi_2nd/dt6.mat');
%         dt = dtiLoadDt6(dt);
%         t1 = niftiRead(dt.files.t1);
%         %% take several ROI from fs segmentation file
%         fsROIdir = fullfile(homeDir,subDir{i},'/dwi_2nd/fsROIs');
%         fsROIdir = fsROIdir;
%         
%         if ~exist(fsROIdir); mkdir(fsROIdir)
%             fsIn = fullfile(homeDir,'/freesurfer',subDir{i},'/mri/aparc+aseg.nii.gz');
%             type = 'mat';
%             fs_roisFromAllLabels(fsIn,fsROIdir,type,[])
%         end
%         
%         %% get L,R-arcuate from WB
%         WB = fgRead(wholebrainfgPath);
%         
%         Atlas=[];
%         antsInvWarp = 0;
%         useRoiBasedApproach=[4 0];
%         useInterhemisphericSplit=true;
%         
%         [fg_classified,fg_unclassified,classification,fg] = ...
%             AFQ_SegmentFiberGroups(dt, WB, Atlas, ...
%             useRoiBasedApproach, useInterhemisphericSplit, antsInvWarp);
%         
%         L_arcuate =fg_classified(1,19);
%         R_arcuate =fg_classified(1,20);
%         
%         % clean up arcuates
%         L_arcuate = AFQ_removeFiberOutliers(L_arcuate,3,3,25);
%         R_arcuate = AFQ_removeFiberOutliers(R_arcuate,3,3,25);
%         
%         %% AFQ_FindVOF
%         %
%         outdir  =   fullfile(homeDir,subDir{i},'/dwi_2nd/fibers/WBC_mrtrix');
%         thresh = [.95 .6];
%         v_crit = 1.3;
%         
%         [L_VOF, R_VOF, L_pArc, R_pArc, L_pArc_vot, R_pArc_vot] = AFQ_FindVOF(wholebrainfgPath,L_arcuate,R_arcuate,fsROIdir,outdir,thresh,v_crit, dt);
%         
%         % %% fiber check
%         % % VOF
%         % c=jet(8);
%         %
%         % AFQ_RenderFibers(L_VOF,'color', c(5,:))
%         % AFQ_RenderFibers(R_VOF,'newfig',0,'color', c(6,:))
%         %
%         % AFQ_AddImageTo3dPlot(t1, [0, 0, -30]);
%         % AFQ_AddImageTo3dPlot(t1, [1, 0, 0]);
%         % view(-11,32)
%         %
%         % %%
%         % AFQ_RenderFibers(L_arcuate,'color', c(5,:),'numfibers',100)
%         % AFQ_RenderFibers(R_arcuate,'newfig',0,'color', c(6,:),'numfibers',100)
%         %
%         % AFQ_AddImageTo3dPlot(t1, [0, 0, -30]);
%         % AFQ_AddImageTo3dPlot(t1, [1, 0, 0]);
%         % view(-11,32)
%         %
%         %
%         % %% Vert
%         % AFQ_RenderFibers(L_fg_vert,'color', c(1,:))
%         % AFQ_RenderFibers(R_fg_vert,'newfig',0,'color', c(2,:))
%         %
%         % AFQ_AddImageTo3dPlot(t1, [0, 0, -30]);
%         % AFQ_AddImageTo3dPlot(t1, [1, 0, 0]);
%         % view(-11,32)
%         % %% pArc
%         % AFQ_RenderFibers(L_pArc,'color', c(3,:))
%         % AFQ_RenderFibers(R_pArc,'newfig',0,'color', c(4,:))
%         %
%         % AFQ_AddImageTo3dPlot(t1, [0, 0, -30]);
%         % AFQ_AddImageTo3dPlot(t1, [1, 0, 0]);
%         % view(-11,32)
%         %% Save 6 tracts
%         cd(a)
%         if ~exist('VOF');mkdir('VOF');end;
%         cd('VOF')
%         FG = {L_VOF, R_VOF, L_pArc, R_pArc, L_pArc_vot, R_pArc_vot};
%         % save all tracts
%         for k = 1: length(FG)
%             fgWrite(FG{k})
%         end
%     end
% end

%% Whole brain tractography using AFQ code
% %% Make directory structure for each subject
% for ii = 1:length(subDir)
%     sub_dirs{ii} = fullfile(homeDir, subDir{ii},'dwi_2nd');
% end
% 
% % Subject grouping is a little bit funny because afq only takes two groups
% % but we have 3. For now we will divide it up this way but we can do more
% % later
% a = ones(1,39);
% b = [16:23,31:33,35:37];
% a(1,b) = 0;
% sub_group = a;
% % sub_group = [1,0];
% 
% % Now create and afq structure
% afq = AFQ_Create('sub_dirs', sub_dirs, 'sub_group', sub_group, 'clip2rois', 0);
% afq.params.run_mode = 'mrtrix';
% 
% %% Run AFQ on these subjects
% afq = AFQ_run(sub_dirs, sub_group, afq);
%%
% fg = AFQ_WholebrainTractography(dt,run_mode,params);

%% Find VOF using WBFG
[homeDir, subDir] = Tama_subj2;

for i =8:length(subDir);%7
    %% load files
    % whole brain connectome
    wholebrainfgPath =fullfile(homeDir,subDir{i},...
        '/dwi_2nd/fibers/WholeBrainFG.mat');
    
    if ~exist(wholebrainfgPath);
        display([subDir{i},'-- Has No Whole brain connectome']);
    else    
        % dt and T1
        dt = fullfile(homeDir,subDir{i},'/dwi_2nd/dt6.mat');
        dt = dtiLoadDt6(dt);
        t1 = niftiRead(dt.files.t1);
        %% ROIs from fs segmentation file
        fsROIdir = fullfile(homeDir,subDir{i},'/dwi_2nd/fsROIs');
        if ~exist(fsROIdir); mkdir(fsROIdir);
            %
            [homeDir2] = Tama_subj; fsDir = fullfile(homeDir2, 'freesurfer');
            fsIn = fullfile(fsDir,subDir{i},'/mri/aparc+aseg.nii.gz');
            type = 'mat';
            fs_roisFromAllLabels(fsIn,fsROIdir,type,[])
        end
        
        %% get L,R-arcuate from WB
        WB = fgRead(wholebrainfgPath);
        
        Atlas=[];
        antsInvWarp = 0;
        useRoiBasedApproach=[4 0];
        useInterhemisphericSplit=true;
        
        % 
        [fg_classified,fg_unclassified,classification,fg] = ...
            AFQ_SegmentFiberGroups(dt, WB, Atlas, ...
            useRoiBasedApproach, useInterhemisphericSplit, antsInvWarp);
        
        % save classfied WB
        outDir = fullfile(homeDir,subDir{i},'/dwi_2nd/VOF_AFQ');
        if ~exist(outDir);mkdir(outDir);end;        

        dtiWriteFiberGroup(fg_classified, fullfile(outDir,'WholeBrainFG_classfied'));
        
        L_arcuate =fg_classified(1,19);
        R_arcuate =fg_classified(1,20);
        
        % clean up arcuates
        L_arcuate = AFQ_removeFiberOutliers(L_arcuate,3,3,100);       
        L_arcuate.name = [L_arcuate.name,'_D3_L3'];
        
        R_arcuate = AFQ_removeFiberOutliers(R_arcuate,3,3,100);
        R_arcuate.name = [R_arcuate.name,'_D3_L3'];

        %% AFQ_FindVOF
        thresh = [.95 .6];
        v_crit = 1.3;
        
        [L_VOF, R_VOF, L_pArc, R_pArc, L_pArc_vot, R_pArc_vot] = AFQ_FindVOF(wholebrainfgPath,L_arcuate,R_arcuate,fsROIdir,outDir,thresh,v_crit, dt);
        
%         %% fiber check
%         % VOF
%         c=jet(8);
%         
%         AFQ_RenderFibers(L_VOF,'color', c(5,:))
%         AFQ_RenderFibers(R_VOF,'newfig',0,'color', c(6,:))
%         
%         AFQ_AddImageTo3dPlot(t1, [0, 0, -30]);
%         AFQ_AddImageTo3dPlot(t1, [1, 0, 0]);
%         view(-11,32)
%         
%         %%
%         AFQ_RenderFibers(L_arcuate,'color', c(5,:),'numfibers',100)
%         AFQ_RenderFibers(R_arcuate,'newfig',0,'color', c(6,:),'numfibers',100)
%         
%         AFQ_AddImageTo3dPlot(t1, [0, 0, -30]);
%         AFQ_AddImageTo3dPlot(t1, [1, 0, 0]);
%         view(-11,32)
%      
%         %% pArc
%         AFQ_RenderFibers(L_pArc,'color', c(3,:))
%         AFQ_RenderFibers(R_pArc,'newfig',0,'color', c(4,:))
%         
%         AFQ_AddImageTo3dPlot(t1, [0, 0, -30]);
%         AFQ_AddImageTo3dPlot(t1, [1, 0, 0]);
%         view(-11,32)
        
        %% Save 6 tracts
        outDir2 = fullfile(homeDir,subDir{i},'/dwi_2nd/fibers');
        if ~exist(outDir);mkdir(outDir);end;
        
        FG = {L_VOF, R_VOF, L_pArc, R_pArc, L_pArc_vot, R_pArc_vot};
        % save all tracts
        for k = 1: length(FG)
            if k <= 2
                    fgWrite(FG{k},fullfile(outDir,FG{k}.name),'pdb')
                    fgWrite(FG{k},fullfile(outDir2,FG{k}.name),'mat')
            else 
                    fgWrite(FG{k},fullfile(outDir,FG{k}.name),'pdb')
            end
        end
        
        
    end
end

%% Load afq structure
resultDir = '/biac4/wandell/biac2/wandell/data/DWI-Tamagawa-Japan2/results';
load(fullfile(resultDir,'afq_39subjects.mat'));

% %% add VOF to afq atructure
% %% L_VOF
% fgName = 'L_VOF.pdb';
% roi1Name = afq.roi1names{1,19};
% roi2Name = afq.roi2names{1,19};
% afq = AFQ_AddNewFiberGroup(afq, fgName, roi1Name, roi2Name, 0, 1);
% 
% %% R_VOF
% fgName = 'R_VOF.pdb';
% roi1Name = afq.roi1names{1,20};
% roi2Name = afq.roi2names{1,20};
% afq = AFQ_AddNewFiberGroup(afq, fgName, roi1Name, roi2Name, 0, 1);



%%
%% Figure 5A
% indivisual FA value along optic tract

% take values
fibID =3; %
sdID = 1;%:7
% make one sheet diffusivity
% merge both hemisphere
for subID = 1:length(subDir);
    if isempty(afq.TractProfile{subID,fibID}{sdID}.nfibers);
        fa(subID,:) =nan(1,100);
    else
        fa(subID,:) =  mean([afq.TractProfile{subID,fibID}{sdID}.vals.fa;...
            afq.TractProfile{subID,fibID+1}{sdID}.vals.fa]);
    end;
    
    if isempty(afq.TractProfile{subID,fibID}{sdID}.nfibers);
        md(subID,:) =nan(1,100);
    else
        md(subID,:) = mean([ afq.TractProfile{subID,fibID}{sdID}.vals.md;...
            afq.TractProfile{subID,fibID+1}{sdID}.vals.md]);
    end;
    
    if isempty(afq.TractProfile{subID,fibID}{sdID}.nfibers);
        rd(subID,:) =nan(1,100);
    else
        rd(subID,:) = mean([ afq.TractProfile{subID,fibID}{sdID}.vals.rd;...
            afq.TractProfile{subID,fibID+1}{sdID}.vals.rd]);
    end;
    
    if isempty(afq.TractProfile{subID,fibID}{sdID}.nfibers);
        ad(subID,:) =nan(1,100);
    else
        ad(subID,:) = mean([ afq.TractProfile{subID,fibID}{sdID}.vals.ad;...
            afq.TractProfile{subID,fibID+1}{sdID}.vals.ad]);
    end;
end

%% ANOVA
Ctl_fa =  fa(Ctl,:);
LHON_fa =  fa(LHON,:);
CRD_fa =  fa(CRD,:);

for jj= 1: 100
    pac = nan(14,3);
    pac(:,1)= Ctl_fa(:,jj);
    pac(1:6,2)= LHON_fa(:,jj);
    pac(1:5,3)= CRD_fa(:,jj);
    [p(jj),~,stats(jj)] = anova1(pac,[],'off');
    co = multcompare(stats(jj),'display','off');
    C{jj}=co;
end
Portion =  p<0.01; % where is most effected

%% OT
figure; hold on;
X = 1:100;
c = lines(100);

% put bars based on ANOVA (p<0.01)
bar(1:100,Portion,1.0)

% Control
st = nanstd(fa(Ctl,:),1);
m   = nanmean(fa(Ctl,:));

% render control subjects range
A3 = area(m+2*st);
A1 = area(m+st);
A2 = area(m-st);
A4 = area(m-2*st);

% set color and style
set(A1,'FaceColor',[0.6 0.6 0.6],'linestyle','none')
set(A2,'FaceColor',[0.8 0.8 0.8],'linestyle','none')
set(A3,'FaceColor',[0.8 0.8 0.8],'linestyle','none')
set(A4,'FaceColor',[1 1 1],'linestyle','none')

plot(m,'color',[0 0 0], 'linewidth',3 )

% add individual FA plot
for k = CRD %1:length(subDir)
    plot(X,fa(k,:),'Color',c(3,:),...
        'linewidth',1);
end
m   = nanmean(fa(CRD,:));
plot(X,m,'Color',c(3,:) ,'linewidth',3)


% add individual
for k = LHON %1:length(subDir)
    plot(X,fa(k,:),'Color',c(4,:),'linewidth',1);
end
% plot mean value
m   = nanmean(fa(LHON,:));
plot(X,m,'Color',c(4,:) ,'linewidth',3)

% add label
xlabel('Location','fontName','Times','fontSize',14);
ylabel('Fractional anisotropy','fontName','Times','fontSize',14);
title('Optic tract','fontName','Times','fontSize',14)
axis([10, 90 ,0.0, 0.600001])

%% OR
fibID = 1;
for subID = 1:length(subDir);
    if isempty(afq.TractProfile{subID,fibID}{sdID}.nfibers);
        fa(subID,:) =nan(1,100);
    else
        fa(subID,:) =  mean([afq.TractProfile{subID,fibID}{sdID}.vals.fa;...
            afq.TractProfile{subID,fibID+1}{sdID}.vals.fa]);
    end;
    
    if isempty(afq.TractProfile{subID,fibID}{sdID}.nfibers);
        md(subID,:) =nan(1,100);
    else
        md(subID,:) = mean([ afq.TractProfile{subID,fibID}{sdID}.vals.md;...
            afq.TractProfile{subID,fibID+1}{sdID}.vals.md]);
    end;
    
    if isempty(afq.TractProfile{subID,fibID}{sdID}.nfibers);
        rd(subID,:) =nan(1,100);
    else
        rd(subID,:) = mean([ afq.TractProfile{subID,fibID}{sdID}.vals.rd;...
            afq.TractProfile{subID,fibID+1}{sdID}.vals.rd]);
    end;
    
    if isempty(afq.TractProfile{subID,fibID}{sdID}.nfibers);
        ad(subID,:) =nan(1,100);
    else
        ad(subID,:) = mean([ afq.TractProfile{subID,fibID}{sdID}.vals.ad;...
            afq.TractProfile{subID,fibID+1}{sdID}.vals.ad]);
    end;
end

%% ANOVA
Ctl_fa =  fa(Ctl,:);
LHON_fa =  fa(LHON,:);
CRD_fa =  fa(CRD,:);

for jj= 1: 100
    pac = nan(14,3);
    pac(:,1)= Ctl_fa(:,jj);
    pac(1:6,2)= LHON_fa(:,jj);
    pac(1:5,3)= CRD_fa(:,jj);
    [p(jj),~,stats(jj)] = anova1(pac,[],'off');
    co = multcompare(stats(jj),'display','off');
    C{jj}=co;
end

Portion =  p<0.01;
%% OR
figure; hold on;

% put bars based on ANOVA (p<0.01)
bar(1:100,Portion,1.0)

% Control subjects data
st = nanstd(fa(Ctl,:),1);
m   = nanmean(fa(Ctl,:));

% render control subjects range
A3 = area(m+2*st);
A1 = area(m+st);
A2 = area(m-st);
A4 = area(m-2*st);

% set color and style
set(A1,'FaceColor',[0.6 0.6 0.6],'linestyle','none')
set(A2,'FaceColor',[0.8 0.8 0.8],'linestyle','none')
set(A3,'FaceColor',[0.8 0.8 0.8],'linestyle','none')
set(A4,'FaceColor',[1 1 1],'linestyle','none')

% plot mean value
plot(m,'color',[0 0 0], 'linewidth',3)

% individual FA
for k = CRD %1:length(subDir)
    plot(X,fa(k,:),'Color',c(3,:),...
        'linewidth',1);
end
m   = nanmean(fa(CRD,:));
plot(X,m,'Color',c(3,:) ,'linewidth',2)


% add individual plot
for k = LHON %1:length(subDir)
    plot(X,fa(k,:),'Color',c(4,:),'linewidth',1);
end
% plot mean value
m   = nanmean(fa(LHON,:));
plot(X,m,'Color',c(4,:) ,'linewidth',2)

% add labels
xlabel('Location','fontName','Times','fontSize',14);
ylabel('Fractional anisotropy','fontName','Times','fontSize',14);
axis([10, 90 ,0.2, 0.750001])
title('Optic radiation','fontName','Times','fontSize',14)



