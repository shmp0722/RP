function [TractProfile] = runSO_DivideFibersAcordingToFiberLength_percentile
%%
homeDir = '/biac4/wandell/biac2/wandell/data/DWI-Tamagawa-Japan';

subDir = {...
    'JMD1-MM-20121025-DWI'
    'JMD3-AK-20121026-DWI'
    'JMD5-KK-20121220-DWI'
    'JMD6-NO-20121220-DWI'
    'JMD2-KK-20121025-DWI'
    'JMD4-AM-20121026-DWI'
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
    'JMD-Ctl-YM-20121025-DWI'
    'JMD-Ctl-SY-20130222DWI'
    'JMD-Ctl-HH-20120907DWI'
    'JMD-Ctl-HT-20120907-DWI'
    'JMD-Ctl-FN-20130621-DWI'
    'JMD-Ctl-AM-20130726-DWI'
    'JMD-Ctl-SO-20130726-DWI'
    'RP1-TT-2013-11-01'
    'RP2-KI-2013-11-01'
    'RP3-TO-13120611-DWI'
    'LHON6-SS-20131206-DWI'
    'RP4-AK-2014-01-31'
    'RP5-KS-2014-01-31'
    'JMD3-AK-20140228-dMRI'
    'JMD-Ctl-09-RN-20130909'
    'JMD-Ctl-10-JN-20140205'
    'JMD-Ctl-11-MT-20140217'
    'RP6-SY-2014-02-28-dMRI'
    'Ctl-12-SA-20140307'
    'Ctl-13-MW-20140313-dMRI-Anatomy'
    'Ctl-14-YM-20140314-dMRI-Anatomy'
    'RP7-EU-2014-03-14-dMRI-Anatomy'
    'RP8-YT-2014-03-14-dMRI-Anatomy'};

%% Calculate vals along the fibers and return TP structure

fgN ={'ROR1206_D4L4.pdb','LOR1206_D4L4.pdb'};%,'ROTD4L4_1206.pdb','LOTD4L4_1206.pdb'};%,...
% 'ROTD3L2_1206.pdb','LOTD3L2_1206.pdb'};

% make structure
for i =1:length(subDir)
    for j =1:length(fgN)
        TractProfile{i,j} = SO_CreateTractProfile;
    end
end


%%
matlabpool;
%%
for i =1:length(subDir)
    % define directory
    SubDir = fullfile(homeDir,subDir{i});
    fgDir  = fullfile(SubDir,'/dwi_2nd/fibers');
    %     newDir = fullfile(SubDir,'/dwi_2nd/fibers/conTrack/OR_1130');
    %     roiDir = fullfile(SubDir,'/dwi_2nd/ROIs');
    dt  = fullfile(homeDir,subDir{i},'dwi_2nd','dt6.mat');
    dt  = dtiLoadDt6(dt);
    %     cd(fgDir_contrack)
    cd /biac4/wandell/biac3/wandell7/shumpei/matlab/git/LHON/3RP
    
    
    parfor j =1:length(fgN)
        fg = fgRead(fullfile(fgDir,fgN{j}));
        
        [TractProfile{i,j}, ~,~,~,~,~]...
            = SO_DivideFibersAcordingToFiberLength_percentile(fg,dt,0,'AP',100);
    end
end
matlabpool close
%%
% save 3RP_percentile_TractProfile_2 TractProfile
% return

%% Load TractProfile

cd /biac4/wandell/biac3/wandell7/shumpei/matlab/git/LHON/3RP
load 3RP_percentile_TractProfile.mat

%% classify all subjects intogroups
JMD = 1:4;
CRD = 5:9;
% LHON = 10:15;
LHON = [10:14,27];

Ctl = [16:23,31:33,35:37];
RP = [24:26,28,29,34,38,39];

fgN ={'ROR1206_D4L4.pdb','LOR1206_D4L4.pdb'};%,'ROTD4L4_1206.pdb','LOTD4L4_1206.pdb',...
%     'ROTD3L2_1206.pdb','LOTD3L2_1206.pdb'};

% Render plots which comparing CRD ,LHON, Ctl
% Y=nan(length(subDir),100);
X = 1:100;
c = lines(100);
gray = [0.5 0.5 0.5];
%% Render plots
for fibID = 1:length(fgN)
    for pctl = 1:6
        % make one sheet diffusivities
        for subID = 1:length(subDir);
            if isempty(TractProfile{subID,fibID}{pctl}.nfibers);
                fa(subID,:) =nan(1,100);
            else
                fa(subID,:) =  TractProfile{subID,fibID}{pctl}.vals.fa;
            end;
            
            if isempty(TractProfile{subID,fibID}{pctl}.nfibers);
                md(subID,:) =nan(1,100);
            else
                md(subID,:) =  TractProfile{subID,fibID}{pctl}.vals.md;
            end;
            
            if isempty(TractProfile{subID,fibID}{pctl}.nfibers);
                rd(subID,:) =nan(1,100);
            else
                rd(subID,:) =  TractProfile{subID,fibID}{pctl}.vals.rd;
            end;
            
            if isempty(TractProfile{subID,fibID}{pctl}.nfibers);
                ad(subID,:) =nan(1,100);homeDir = '/biac4/wandell/biac2/wandell/data/DWI-Tamagawa-Japan';

subDir = {...
    'JMD1-MM-20121025-DWI'
    'JMD3-AK-20121026-DWI'
    'JMD5-KK-20121220-DWI'
    'JMD6-NO-20121220-DWI'
    'JMD2-KK-20121025-DWI'
    'JMD4-AM-20121026-DWI'
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
    'JMD-Ctl-YM-20121025-DWI'
    'JMD-Ctl-SY-20130222DWI'
    'JMD-Ctl-HH-20120907DWI'
    'JMD-Ctl-HT-20120907-DWI'
    'JMD-Ctl-FN-20130621-DWI'
    'JMD-Ctl-AM-20130726-DWI'
    'JMD-Ctl-SO-20130726-DWI'
    'RP1-TT-2013-11-01'
    'RP2-KI-2013-11-01'
    'RP3-TO-13120611-DWI'
    'LHON6-SS-20131206-DWI'
    'RP4-AK-2014-01-31'
    'RP5-KS-2014-01-31'
    'JMD3-AK-20140228-dMRI'
    'JMD-Ctl-09-RN-20130909'
    'JMD-Ctl-10-JN-20140205'
    'JMD-Ctl-11-MT-20140217'
    'RP6-SY-2014-02-28-dMRI'
    'Ctl-12-SA-20140307'
    'Ctl-13-MW-20140313-dMRI-Anatomy'
    'Ctl-14-YM-20140314-dMRI-Anatomy'
    'RP7-EU-2014-03-14-dMRI-Anatomy'
    'RP8-YT-2014-03-14-dMRI-Anatomy'};
            else
                ad(subID,:) =  TractProfile{subID,fibID}{pctl}.vals.ad;
            end;
        end
        
        %% fa comparison
        figure; hold on;
        
        % CRD
        plot(X,nanmean(fa(CRD,:)),'Color',c(3,:),'linewidth',2);
        % LHON
        plot(X,nanmean(fa(LHON,:)),'Color',c(4,:),'linewidth',2);
        % Ctl
        plot(X,nanmean(fa(Ctl,:)),'Color',gray,'linewidth',2);
        % RP
        %         plot(X,nanmean(fa(RP,:)),'Color',c(3,:),'linewidth',2);
        %         legend('CRD','LHON','Ctl','RP');
        %         legend('CRD','LHON','Ctl');
        
        title(sprintf('%s %s',fgN{fibID}(1:end-4),TractProfile{1,fibID}{pctl}.name));
        ylabel('fa');
        xlabel('location');
        hold off;
        %         %% save fig
        %         cd /biac4/wandell/biac3/wandell7/shumpei/matlab/git/LHON/3RP/divideByLength_Plot
        %
        %         print(gcf,'-dpng',sprintf('%s_%s_%s','FA',fgN{fibID}(1:end-4),TractProfile{1,fibID}{pctl}.name))
        %
        %% md comparison
        figure; hold on;
        
        % CRD
        plot(X,nanmean(md(CRD,:)),'Color',c(3,:),'linewidth',2);
        % LHON
        plot(X,nanmean(md(LHON,:)),'Color',c(4,:),'linewidth',2);
        % Ctl
        plot(X,nanmean(md(Ctl,:)),'Color',gray,'linewidth',2);
        % RP
        %         plot(X,nanmean(ad(RP,:)),'Color',c(3,:),'linewidth',2);
        %         legend('CRD','LHON','Ctl','RP');
        %         legend('CRD','LHON','Ctl');
        
        title(sprintf('%s %s',fgN{fibID}(1:end-4),TractProfile{1,fibID}{pctl}.name));
        ylabel('ad');
        xlabel('location');
        hold off;
        %         %% save fig
        %
        %         print(gcf,'-dpng',sprintf('%s_%s_%s','AD',fgN{fibID}(1:end-4),TractProfile{1,fibID}{pctl}.name))
        
        %% ad comparison
        figure; hold on;
        
        % CRD
        plot(X,nanmean(ad(CRD,:)),'Color',c(3,:),'linewidth',2);
        % LHON
        plot(X,nanmean(ad(LHON,:)),'Color',c(4,:),'linewidth',2);
        % Ctl
        plot(X,nanmean(ad(Ctl,:)),'Color',gray,'linewidth',2);
        % RP
        %         plot(X,nanmean(ad(RP,:)),'Color',c(3,:),'linewidth',2);
        %         legend('CRD','LHON','Ctl','RP');
        %         legend('CRD','LHON','Ctl');
        
        title(sprintf('%s %s',fgN{fibID}(1:end-4),TractProfile{1,fibID}{pctl}.name));
        ylabel('ad');
        xlabel('location');
        hold off;
        %         %% save fig
        %
        %         print(gcf,'-dpng',sprintf('%s_%s_%s','AD',fgN{fibID}(1:end-4),TractProfile{1,fibID}{pctl}.name))
        
        %% rd comparison
        figure; hold on;
        
        % CRD
        plot(X,nanmean(rd(CRD,:)),'Color',c(3,:),'linewidth',2);
        % LHON
        plot(X,nanmean(rd(LHON,:)),'Color',c(4,:),'linewidth',2);
        % Ctl
        plot(X,nanmean(rd(Ctl,:)),'Color',gray,'linewidth',2);
        % RP
        %         plot(X,nanmean(rd(RP,:)),'Color',c(3,:),'linewidth',2);
        %         legend('CRD','LHON','Ctl','RP');
        %         legend('CRD','LHON','Ctl');
        
        title(sprintf('%s %s',fgN{fibID}(1:end-4),TractProfile{1,fibID}{pctl}.name));
        ylabel('rd');
        xlabel('location');
        hold off;
        %          %% save fig
        %
        %         print(gcf,'-dpng',sprintf('%s_%s_%s','RD',fgN{fibID}(1:end-4),TractProfile{1,fibID}{pctl}.name))
        
    end
    %     close all
end


%% drow errorbar plots merge both L and R tract
for fibID = 1 %ROR
    for pctl = 1:6
        % make one sheet diffusivities
        for subID = 1:length(subDir);
            if isempty(TractProfile{subID,fibID}{pctl}.nfibers);
                fa(subID,:) =nan(1,100);
            else
                fa(subID,:) =  mean([TractProfile{subID,fibID}{pctl}.vals.fa;...
                    TractProfile{subID,fibID+1}{pctl}.vals.fa]);
            end;
            
            if isempty(TractProfile{subID,fibID}{pctl}.nfibers);
                md(subID,:) =nan(1,100);
            else
                md(subID,:) = mean([ TractProfile{subID,fibID}{pctl}.vals.md;...
                    TractProfile{subID,fibID+1}{pctl}.vals.md]);
            end;
            
            if isempty(TractProfile{subID,fibID}{pctl}.nfibers);
                rd(subID,:) =nan(1,100);
            else
                rd(subID,:) = mean([ TractProfile{subID,fibID}{pctl}.vals.rd;...
                    TractProfile{subID,fibID+1}{pctl}.vals.rd]);
            end;
            
            if isempty(TractProfile{subID,fibID}{pctl}.nfibers);
                ad(subID,:) =nan(1,100);
            else
                ad(subID,:) = mean([ TractProfile{subID,fibID}{pctl}.vals.ad;...
                    TractProfile{subID,fibID+1}{pctl}.vals.ad]);
            end;
        end
        
        %% fa comparison
        %         figure; hold on;
        % Create axes
        axes1 = axes('Parent',figure,'YTick',[0.15 0.65],...
            'XTick',[0 50 100]);
        xlim(axes1,[0 100]);
        hold(axes1,'all');
        
        % Render errorbar(S.E.M) of three groups
        % CRD
        sem = nanstd(fa(CRD,:))/sqrt(size(fa(CRD,:),1));
        errorbar(X,nanmean(fa(CRD,:)),sem,'Color',c(3,:),...
            'linewidth',2);
        % LHON
        sem = nanstd(fa(LHON,:))/sqrt(size(fa(LHON,:),1));
        errorbar(X,nanmean(fa(LHON,:)),sem,'Color',c(4,:),...
            'linewidth',2);
        % Control
        sem = nanstd(fa(Ctl,:))/sqrt(size(fa(Ctl,:),1));
        errorbar(X,nanmean(fa(Ctl,:)),sem,'Color',gray,...
            'linewidth',2);
        
        %         title(sprintf('%s %s',fgN{fibID}(1:end-4),TractProfile{1,fibID}{pctl}.name)...
        %             ,'FontName','Times','FontSize',16);
        ylabel('Fractional anisotropy','FontName','Times','FontSize',16);
        xlabel('Location','FontName','Times','FontSize',16);
        hold off;
        %% save fig
        cd /biac4/wandell/biac3/wandell7/shumpei/matlab/git/LHON/3RP/Figure7
        
        print(gcf,'-depsc2',sprintf('%s_%s_%s','FA',fgN{fibID}(1:end-4),TractProfile{1,fibID}{pctl}.name))
        
        %% md comparison
        %         figure; hold on;
        % Create axes
        axes1 = axes('Parent',figure,'YTick',[0.65 1],...
            'XTick',[0 50 100]);
        xlim(axes1,[0 100]);
        hold(axes1,'all');
        
        %% Render errorbar(S.E.M) of three groups
        % CRD
        sem = nanstd(md(CRD,:))/sqrt(size(md(CRD,:),1));
        errorbar(X,nanmean(md(CRD,:)),sem,'Color',c(3,:),...
            'linewidth',2);
        % LHON
        sem = nanstd(md(LHON,:))/sqrt(size(md(LHON,:),1));
        errorbar(X,nanmean(md(LHON,:)),sem,'Color',c(4,:),...
            'linewidth',2);
        % Control
        sem = nanstd(md(Ctl,:))/sqrt(size(md(Ctl,:),1));
        errorbar(X,nanmean(md(Ctl,:)),sem,'Color',gray,...
            'linewidth',2);
        
        %         title(sprintf('%s %s',fgN{fibID}(1:end-4),TractProfile{1,fibID}{pctl}.name)...
        %             ,'FontName','Times','FontSize',16);
        ylabel('Mean diffusivity','FontName','Times','FontSize',16);
        xlabel('Location','FontName','Times','FontSize',16);
        hold off;
        
        %% save fig
        print(gcf,'-depsc2',sprintf('%s_%s_%s','MD',fgN{fibID}(1:end-4),TractProfile{1,fibID+1}{pctl}.name))
        
        
        
        %% ad comparison
        %         figure; hold on;
        % Create axes
        axes1 = axes('Parent',figure,'YTick',[0.9 1.6],...
            'XTick',[0 50 100]);
        xlim(axes1,[0 100]);
        hold(axes1,'all');
        
        %% Render errorbar(S.E.M) of three groups
        % CRD
        sem = nanstd(ad(CRD,:))/sqrt(size(ad(CRD,:),1));
        errorbar(X,nanmean(ad(CRD,:)),sem,'Color',c(3,:),...
            'linewidth',2);
        % LHON
        sem = nanstd(ad(LHON,:))/sqrt(size(ad(LHON,:),1));
        errorbar(X,nanmean(ad(LHON,:)),sem,'Color',c(4,:),...
            'linewidth',2);
        % Control
        sem = nanstd(ad(Ctl,:))/sqrt(size(ad(Ctl,:),1));
        errorbar(X,nanmean(ad(Ctl,:)),sem,'Color',gray,...
            'linewidth',2);
        
        %         title(sprintf('%s %s',fgN{fibID}(1:end-4),TractProfile{1,fibID}{pctl}.name)...
        %             ,'FontName','Times','FontSize',16);
        ylabel('Axial diffusivity','FontName','Times','FontSize',16);
        xlabel('Location','FontName','Times','FontSize',16);
        hold off;
        %% save fig
        print(gcf,'-depsc2',sprintf('%s_%s_%s','AD',fgN{fibID}(1:end-4),TractProfile{1,fibID+1}{pctl}.name))
        
        
        %% rd comparison
        %         figure; hold on;
        % Create axes
        axes1 = axes('Parent',figure,'YTick',[0.2 0.4 0.6],...
            'XTick',[0 50 100]);
        set(axes1,'YTick',[0.4 0.9])
        
        xlim(axes1,[0 100]);
        hold(axes1,'all');
        
        %% Render errorbar(S.E.M) of three groups
        % CRD
        sem = nanstd(rd(CRD,:))/sqrt(size(rd(CRD,:),1));
        errorbar(X,nanmean(rd(CRD,:)),sem,'Color',c(3,:),...
            'linewidth',2);
        % LHON
        sem = nanstd(rd(LHON,:))/sqrt(size(rd(LHON,:),1));
        errorbar(X,nanmean(rd(LHON,:)),sem,'Color',c(4,:),...
            'linewidth',2);
        % Control
        sem = nanstd(rd(Ctl,:))/sqrt(size(rd(Ctl,:),1));
        errorbar(X,nanmean(rd(Ctl,:)),sem,'Color',gray,...
            'linewidth',2);
        
        %         title(sprintf('%s %s',fgN{fibID}(1:end-4),TractProfile{1,fibID}{pctl}.name)...
        %             ,'FontName','Times','FontSize',16);
        ylabel('Radial diffusivity','FontName','Times','FontSize',16);
        xlabel('Location','FontName','Times','FontSize',16);
        hold off;
        
        %% save fig
        print(gcf,'-depsc2',sprintf('%s_%s_%s','RD',fgN{fibID}(1:end-4),TractProfile{1,fibID+1}{pctl}.name))
        
    end
end
cd /biac4/wandell/biac3/wandell7/shumpei/matlab/git/LHON/3RP
return



%% Standard Diviation drow errorbar plots merge both L and R tract
for fibID = 1 %ROR
    for pctl = 1:6
        % make one sheet diffusivities
        for subID = 1:length(subDir);
            if isempty(TractProfile{subID,fibID}{pctl}.nfibers);
                fa(subID,:) =nan(1,100);
            else
                fa(subID,:) =  mean([TractProfile{subID,fibID}{pctl}.vals.fa;...
                    TractProfile{subID,fibID+1}{pctl}.vals.fa]);
            end;
            
            if isempty(TractProfile{subID,fibID}{pctl}.nfibers);
                md(subID,:) =nan(1,100);
            else
                md(subID,:) = mean([ TractProfile{subID,fibID}{pctl}.vals.md;...
                    TractProfile{subID,fibID+1}{pctl}.vals.md]);
            end;
            
            if isempty(TractProfile{subID,fibID}{pctl}.nfibers);
                rd(subID,:) =nan(1,100);
            else
                rd(subID,:) = mean([ TractProfile{subID,fibID}{pctl}.vals.rd;...
                    TractProfile{subID,fibID+1}{pctl}.vals.rd]);
            end;
            
            if isempty(TractProfile{subID,fibID}{pctl}.nfibers);
                ad(subID,:) =nan(1,100);
            else
                ad(subID,:) = mean([ TractProfile{subID,fibID}{pctl}.vals.ad;...
                    TractProfile{subID,fibID+1}{pctl}.vals.ad]);
            end;
        end
        
        %% fa comparison
        %         figure; hold on;
        % Create axes
        axes1 = axes('Parent',figure,'YTick',[0.15 0.65],...
            'XTick',[0 50 100]);
        xlim(axes1,[0 100]);
        hold(axes1,'all');
        
        %%
        sem = nanstd(fa(Ctl,:))/sqrt(size(fa(Ctl,:),1));
        m = nanmean(fa(Ctl,:));
        mp = sem+m;
        mm = m - sem;
        mp2 = 2*sem+m;
        mm2 = m - 2*sem;
        
        h(1) =area(mp2);
        h(2) =area(mp);
        h(3) =area(mm);
        h(4) =area(mm2);
        [0.2 0.2 0.2]
        
        set(h(2),'FaceColor',[0.8 0.8 0.8]);
        
        set(h(1),'FaceColor',[0.9 0.9 0.9]);
        set(h(3),'FaceColor',[0.9 0.9 0.9]);
        set(h(4),'FaceColor',[1 1 1]);
        
        
        
        set(h(1),'EdgeColor',[1 1 1]);
        set(h(2),'EdgeColor',[1 1 1]);
        set(h(3),'EdgeColor',[1 1 1]);
        set(h(4),'EdgeColor',[1 1 1]);
        
        
        % Render errorbar(S.E.M) of three groups
        % CRD
        %         sem = nanstd(fa(CRD,:))/sqrt(size(fa(CRD,:),1));
        errorbar2(X,nanmean(fa(CRD,:)),nanstd(fa(CRD,:)),1,'Color',c(3,:),...
            'linewidth',1);
        scatter(X,nanmean(fa(CRD,:)),40,c(3,:),'fill')
        % LHON
        %         sem = nanstd(fa(LHON,:))/sqrt(size(fa(LHON,:),1));
        errorbar2(X,nanmean(fa(LHON,:)),nanstd(fa(LHON,:)),1,'Color',c(4,:),...
            'linewidth',1);
        scatter(X,nanmean(fa(LHON,:)),40,c(4,:),'fill')
        
        
        % Control
        %         sem = nanstd(fa(Ctl,:))/sqrt(size(fa(Ctl,:),1));
        errorbar(X,nanmean(fa(Ctl,:)),nanstd(fa(Ctl,:)),'Color',gray,...
            'linewidth',2);
        
        %         title(sprintf('%s %s',fgN{fibID}(1:end-4),TractProfile{1,fibID}{pctl}.name)...
        %             ,'FontName','Times','FontSize',16);
        ylabel('Fractional anisotropy','FontName','Times','FontSize',16);
        xlabel('Location','FontName','Times','FontSize',16);
        hold off;
        %% save fig
        cd /biac4/wandell/biac3/wandell7/shumpei/matlab/git/LHON/3RP/Figure3/Percentile_SD
        
        print(gcf,'-depsc2',sprintf('%s_%s_%s','FA',fgN{fibID}(1:end-4),TractProfile{1,fibID}{pctl}.name))
        
        %% md comparison
        %         figure; hold on;
        % Create axes
        axes1 = axes('Parent',figure,'YTick',[0.65 1],...
            'XTick',[0 50 100]);
        xlim(axes1,[0 100]);
        hold(axes1,'all');
        
        %% Render errorbar(S.E.M) of three groups
        % CRD
        %         sem = nanstd(md(CRD,:))/sqrt(size(md(CRD,:),1));
        errorbar(X,nanmean(md(CRD,:)),nanstd(md(CRD,:)),'Color',c(3,:),...
            'linewidth',2);
        % LHON
        %         sem = nanstd(md(LHON,:))/sqrt(size(md(LHON,:),1));
        errorbar(X,nanmean(md(LHON,:)),nanstd(md(LHON,:)),'Color',c(4,:),...
            'linewidth',2);
        % Control
        %         sem = nanstd(md(Ctl,:))/sqrt(size(md(Ctl,:),1));
        errorbar(X,nanmean(md(Ctl,:)),nanstd(md(Ctl,:)),'Color',gray,...
            'linewidth',2);
        
        %         title(sprintf('%s %s',fgN{fibID}(1:end-4),TractProfile{1,fibID}{pctl}.name)...
        %             ,'FontName','Times','FontSize',16);
        ylabel('Mean diffusivity','FontName','Times','FontSize',16);
        xlabel('Location','FontName','Times','FontSize',16);
        hold off;
        
        %% save fig
        print(gcf,'-depsc2',sprintf('%s_%s_%s','MD',fgN{fibID}(1:end-4),TractProfile{1,fibID}{pctl}.name))
        
        
        
        %% ad comparison
        %         figure; hold on;
        % Create axes
        axes1 = axes('Parent',figure,'YTick',[0.9 1.6],...
            'XTick',[0 50 100]);
        xlim(axes1,[0 100]);
        hold(axes1,'all');
        
        %% Render errorbar(S.E.M) of three groups
        % CRD
        %         sem = nanstd(ad(CRD,:))/sqrt(size(ad(CRD,:),1));
        errorbar(X,nanmean(ad(CRD,:)),nanstd(ad(CRD,:)),'Color',c(3,:),...
            'linewidth',2);
        % LHON
        %         sem = nanstd(ad(LHON,:))/sqrt(size(ad(LHON,:),1));
        errorbar(X,nanmean(ad(LHON,:)),nanstd(ad(LHON,:)),'Color',c(4,:),...
            'linewidth',2);
        % Control
        %         sem = nanstd(ad(Ctl,:))/sqrt(size(ad(Ctl,:),1));
        errorbar(X,nanmean(ad(Ctl,:)),nanstd(ad(Ctl,:)),'Color',gray,...
            'linewidth',2);
        
        %         title(sprintf('%s %s',fgN{fibID}(1:end-4),TractProfile{1,fibID}{pctl}.name)...
        %             ,'FontName','Times','FontSize',16);
        ylabel('Axial diffusivity','FontName','Times','FontSize',16);
        xlabel('Location','FontName','Times','FontSize',16);
        hold off;
        %% save fig
        print(gcf,'-depsc2',sprintf('%s_%s_%s','AD',fgN{fibID}(1:end-4),TractProfile{1,fibID}{pctl}.name))
        
        
        %% rd comparison
        %         figure; hold on;
        % Create axes
        axes1 = axes('Parent',figure,'YTick',[0.2 0.4 0.6],...
            'XTick',[0 50 100]);
        set(axes1,'YTick',[0.4 0.9])
        
        xlim(axes1,[0 100]);
        hold(axes1,'all');
        
        %% Render errorbar(S.E.M) of three groups
        % CRD
        sem = nanstd(rd(CRD,:))/sqrt(size(rd(CRD,:),1));
        errorbar(X,nanmean(rd(CRD,:)),nanstd(rd(CRD,:)),'Color',c(3,:),...
            'linewidth',2);
        % LHON
        %         sem = nanstd(rd(LHON,:))/sqrt(size(rd(LHON,:),1));
        errorbar(X,nanmean(rd(LHON,:)),nanstd(rd(LHON,:)),'Color',c(4,:),...
            'linewidth',2);
        % Control
        %         sem = nanstd(rd(Ctl,:))/sqrt(size(rd(Ctl,:),1));
        errorbar(X,nanmean(rd(Ctl,:)),nanstd(rd(Ctl,:)),'Color',gray,...
            'linewidth',2);
        
        %         title(sprintf('%s %s',fgN{fibID}(1:end-4),TractProfile{1,fibID}{pctl}.name)...
        %             ,'FontName','Times','FontSize',16);
        ylabel('Radial diffusivity','FontName','Times','FontSize',16);
        xlabel('Location','FontName','Times','FontSize',16);
        hold off;
        
        %% save fig
        print(gcf,'-depsc2',sprintf('%s_%s_%s','RD',fgN{fibID}(1:end-4),TractProfile{1,fibID}{pctl}.name))
        
    end
end
cd /biac4/wandell/biac3/wandell7/shumpei/matlab/git/LHON/3RP
return




%% render CRD, LHON ,Ctl, RP
% Y=nan(length(subDir),100);
X = 1:100;
c = lines(100);
gray = [0.5 0.5 0.5];

for fibID =1%:6 %ROR
    for pctl = 2
        
        for subID = 1:length(subDir);
            if isempty(TractProfile{subID,fibID}{pctl}.nfibers);
                fa(subID,:) =nan(1,100);
            else
                fa(subID,:) =  TractProfile{subID,fibID}{pctl}.vals.fa;
            end;
            
            if isempty(TractProfile{subID,fibID}{pctl}.nfibers);
                md(subID,:) =nan(1,100);
            else
                md(subID,:) =  TractProfile{subID,fibID}{pctl}.vals.md;
            end;
            
            if isempty(TractProfile{subID,fibID}{pctl}.nfibers);
                rd(subID,:) =nan(1,100);
            else
                rd(subID,:) =  TractProfile{subID,fibID}{pctl}.vals.rd;
            end;
            
            if isempty(TractProfile{subID,fibID}{pctl}.nfibers);
                ad(subID,:) =nan(1,100);
            else
                ad(subID,:) =  TractProfile{subID,fibID}{pctl}.vals.ad;
            end;
        end
        
        %% fa comparison
        figure; hold on;
        
        % CRD
        plot(X,nanmean(fa(CRD,:)),'Color',c(1,:),'linewidth',2);
        % LHON
        plot(X,nanmean(fa(LHON,:)),'Color',c(2,:),'linewidth',2);
        % Ctl
        plot(X,nanmean(fa(Ctl,:)),'Color',gray,'linewidth',2);
        % RP
        plot(X,nanmean(fa(RP,:)),'Color',c(3,:),'linewidth',2);
        legend('CRD','LHON','Ctl','RP');
        
        %         title(sprintf('%s %s',fgN{fibID}(1:end-4),TractProfile{1,fibID}{pctl}.name));
        ylabel('fa');
        xlabel('location');
        hold off;
        %         %% save fig
        %         cd /biac4/wandell/biac3/wandell7/shumpei/matlab/git/LHON/3RP/divideByLength_Plot
        %
        %         print(gcf,'-dpng',sprintf('%s_%s_%s','FA',fgN{fibID}(1:end-4),TractProfile{1,fibID}{pctl}.name))
        %
        %% ad comparison
        figure; hold on;
        
        % CRD
        plot(X,nanmean(ad(CRD,:)),'Color',c(1,:),'linewidth',2);
        % LHON
        plot(X,nanmean(ad(LHON,:)),'Color',c(2,:),'linewidth',2);
        % Ctl
        plot(X,nanmean(ad(Ctl,:)),'Color',gray,'linewidth',2);
        % RP
        plot(X,nanmean(ad(RP,:)),'Color',c(3,:),'linewidth',2);
        legend('CRD','LHON','Ctl','RP');
        
        %         title(sprintf('%s %s',fgN{fibID}(1:end-4),TractProfile{1,fibID}{pctl}.name));
        ylabel('ad');
        xlabel('location');
        hold off;
        %         %% save fig
        %
        %         print(gcf,'-dpng',sprintf('%s_%s_%s','AD',fgN{fibID}(1:end-4),TractProfile{1,fibID}{pctl}.name))
        
        %% rd comparison
        figure; hold on;
        
        % CRD
        plot(X,nanmean(rd(CRD,:)),'Color',c(1,:),'linewidth',2);
        % LHON
        plot(X,nanmean(rd(LHON,:)),'Color',c(2,:),'linewidth',2);
        % Ctl
        plot(X,nanmean(rd(Ctl,:)),'Color',gray,'linewidth',2);
        % RP
        plot(X,nanmean(rd(RP,:)),'Color',c(3,:),'linewidth',2);
        legend('CRD','LHON','Ctl','RP');
        
        %         title(sprintf('%s %s',fgN{fibID}(1:end-4),TractProfile{1,fibID}{pctl}.name));
        ylabel('rd');
        xlabel('location');
        hold off;
        %          %% save fig
        %
        %         print(gcf,'-dpng',sprintf('%s_%s_%s','RD',fgN{fibID}(1:end-4),TractProfile{1,fibID}{pctl}.name))
        
    end
end



%% boxplots merge both L and R tract
for fibID = 1%4:6 %ROR
    for pctl = 2:6
        % make one sheet diffusivities
        for subID = 1:length(subDir);
            if isempty(TractProfile{subID,fibID}{pctl}.nfibers);
                fa(subID,:) =nan(1,100);
            else
                fa(subID,:) =  mean([TractProfile{subID,fibID}{pctl}.vals.fa;...
                    TractProfile{subID,fibID+1}{pctl}.vals.fa]);
            end;
            
            if isempty(TractProfile{subID,fibID}{pctl}.nfibers);
                md(subID,:) =nan(1,100);
            else
                md(subID,:) = mean([ TractProfile{subID,fibID}{pctl}.vals.md;...
                    TractProfile{subID,fibID+1}{pctl}.vals.md]);
            end;
            
            if isempty(TractProfile{subID,fibID}{pctl}.nfibers);
                rd(subID,:) =nan(1,100);
            else
                rd(subID,:) = mean([ TractProfile{subID,fibID}{pctl}.vals.rd;...
                    TractProfile{subID,fibID+1}{pctl}.vals.rd]);
            end;
            
            if isempty(TractProfile{subID,fibID}{pctl}.nfibers);
                ad(subID,:) =nan(1,100);
            else
                ad(subID,:) = mean([ TractProfile{subID,fibID}{pctl}.vals.ad;...
                    TractProfile{subID,fibID+1}{pctl}.vals.ad]);
            end;
        end
        
        
        %% box
        figure; hold on;
        boxplot([nanmean(fa(LHON,:))',nanmean(fa(CRD,:))',nanmean(fa(Ctl,:))'],'notch','on')
        
        
        ylabel('Fractional anisotropy','FontName','Times','FontSize',16);
        xlabel('group','FontName','Times','FontSize',16);
        %                 %% save fig
        %                 cd /biac4/wandell/biac3/wandell7/shumpei/matlab/git/LHON/3RP/Figure3/
        %
        %                 print(gcf,'-depsc2',sprintf('%s_%s_%s','FA',fgN{fibID}(1:end-4),TractProfile{1,fibID}{pctl}.name))
        hold off;
        
    end
end

return




% close all

%% LHON6 longtudinal
% Y=nan(length(subDir),100);
X = 1:100;
c = lines(100);
gray = [0.5 0.5 0.5];

for fibID =1%:6 %ROR
    for pctl = 1:7
        
        for subID =1:length(subDir);
            if isempty(TractProfile{subID,fibID}{pctl}.nfibers);
                fa(subID,:) =nan(1,100);
            else
                fa(subID,:) =  TractProfile{subID,fibID}{pctl}.vals.fa;
            end;
            
            if isempty(TractProfile{subID,fibID}{pctl}.nfibers);
                md(subID,:) =nan(1,100);
            else
                md(subID,:) =  TractProfile{subID,fibID}{pctl}.vals.md;
            end;
            
            if isempty(TractProfile{subID,fibID}{pctl}.nfibers);
                rd(subID,:) =nan(1,100);
            else
                rd(subID,:) =  TractProfile{subID,fibID}{pctl}.vals.rd;
            end;
            
            if isempty(TractProfile{subID,fibID}{pctl}.nfibers);
                ad(subID,:) =nan(1,100);
            else
                ad(subID,:) =  TractProfile{subID,fibID}{pctl}.vals.ad;
            end;
        end
        
        %% fa comparison
        figure; hold on;
        
        % LHON6 longtudinal
        plot(X,fa(15,:),'Color',c(3,:),'linewidth',2);
        plot(X,fa(27,:),'Color',c(4,:),'linewidth',2);
        
        legend('LHON6 previous','LHON6 present');
        
        title(sprintf('%s %s',fgN{fibID}(1:end-4),TractProfile{1,fibID}{pctl}.name));
        ylabel('fa');
        xlabel('location');
        hold off;
        %% save fig
        cd '/biac4/wandell/biac3/wandell7/shumpei/matlab/git/LHON/3RP/LHON6 longtudinal'
        
        print(gcf,'-dpng',sprintf('LHON6_logntudinal%s_%s_%s','FA',fgN{fibID}(1:end-4),TractProfile{1,fibID}{pctl}.name))
        %
        %% ad comparison
        figure; hold on;
        
        % LHON6 longtudinal
        plot(X,ad(15,:),'Color',c(3,:),'linewidth',2);
        plot(X,ad(27,:),'Color',c(4,:),'linewidth',2);
        
        legend('LHON6 previous','LHON6 present');
        
        title(sprintf('%s %s',fgN{fibID}(1:end-4),TractProfile{1,fibID}{pctl}.name));
        ylabel('ad');
        xlabel('location');
        hold off;
        %% save fig
        
        print(gcf,'-dpng',sprintf('LHON6_logntudinal%s_%s_%s','AD',fgN{fibID}(1:end-4),TractProfile{1,fibID}{pctl}.name))
        
        %% rd comparison
        figure; hold on;
        
        % LHON6 longtudinal
        plot(X,rd(15,:),'Color',c(3,:),'linewidth',2);
        plot(X,rd(27,:),'Color',c(4,:),'linewidth',2);
        
        legend('LHON6 previous','LHON6 present');
        
        title(sprintf('%s %s',fgN{fibID}(1:end-4),TractProfile{1,fibID}{pctl}.name));
        ylabel('rd');
        xlabel('location');
        hold off;
        %% save fig
        
        print(gcf,'-dpng',sprintf('LHON6_logntudinal%s_%s_%s','RD',fgN{fibID}(1:end-4),TractProfile{1,fibID}{pctl}.name))
        
        %% md comparison
        figure; hold on;
        
        % LHON6 longtudinal
        plot(X,md(15,:),'Color',c(3,:),'linewidth',2);
        plot(X,md(27,:),'Color',c(4,:),'linewidth',2);
        
        legend('LHON6 previous','LHON6 present');
        
        title(sprintf('%s %s',fgN{fibID}(1:end-4),TractProfile{1,fibID}{pctl}.name));
        ylabel('md');%% add S.E.M
        sem = nanstd(fa(CRD,:))/sqrt(size(fa(CRD,:),1));
        % render S.E.M.
        figure; hold on;
        
        plot(X,nanmean(fa(CRD,:))+sem,'Color',c(1,:),...
            'linewidth',1, 'linestyle','--');
        plot(X,nanmean(fa(CRD,:))-sem,'Color',c(1,:),...
            'linewidth',1, 'linestyle','--');
        
        sem = nanstd(fa(LHON,:))/sqrt(size(fa(LHON,:),1));
        % SEM
        plot(X,nanmean(fa(LHON,:))+sem,'Color',c(1,:),...
            'linewidth',1, 'linestyle','--');
        plot(X,nanmean(fa(LHON,:))-sem,'Color',c(1,:),...
            'linewidth',1, 'linestyle','--');
        
        sem = nanstd(fa(Ctl,:))/sqrt(size(fa(Ctl,:),1));
        % SEM
        plot(X,nanmean(fa(Ctl,:))+sem,'Color',c(1,:),...
            'linewidth',1, 'linestyle','--');%% add S.E.M
        sem = nanstd(fa(CRD,:))/sqrt(size(fa(CRD,:),1));
        % render S.E.M.
        figure; hold on;
        
        plot(X,nanmean(fa(CRD,:))+sem,'Color',c(1,:),...
            'linewidth',1, 'linestyle','--');
        plot(X,nanmean(fa(CRD,:))-sem,'Color',c(1,:),...
            'linewidth',1, 'linestyle','--');
        
        sem = nanstd(fa(LHON,:))/sqrt(size(fa(LHON,:),1));
        % SEM
        plot(X,nanmean(fa(LHON,:))+sem,'Color',c(1,:),...
            'linewidth',1, 'linestyle','--');
        plot(X,nanmean(fa(LHON,:))-sem,'Color',c(1,:),...
            'linewidth',1, 'linestyle','--');
        
        sem = nanstd(fa(Ctl,:))/sqrt(size(fa(Ctl,:),1));
        % SEM
        plot(X,nanmean(fa(Ctl,:))+sem,'Color',c(1,:),...
            'linewidth',1, 'linestyle','--');
        plot(X,nanmean(fa(Ctl,:))-sem,'Color',c(1,:),...
            'linewidth',1, 'linestyle','--');
        
        sem = nanstd(fa(RP,:))/sqrt(size(fa(RP,:),1));
        % SEM
        plot(X,nanmean(fa(RP,:))+sem,'Color',c(1,:),...
            'linewidth',1, 'linestyle','--');
        plot(X,nanmean(fa(RP,:))-sem,'Color',c(1,:),...
            'linewidth',1, 'linestyle','--');
        
        plot(X,nanmean(fa(Ctl,:))-sem,'Color',c(1,:),...
            'linewidth',1, 'linestyle','--');
        
        sem = nanstd(fa(RP,:))/sqrt(size(fa(RP,:),1));
        % SEM
        plot(X,nanmean(fa(RP,:))+sem,'Color',c(1,:),...
            'linewidth',1, 'linestyle','--');
        plot(X,nanmean(fa(RP,:))-sem,'Color',c(1,:),...
            'linewidth',1, 'linestyle','--');
        
        xlabel('location');
        hold off;
        %% save fig
        
        print(gcf,'-dpng',sprintf('LHON6_logntudinal%s_%s_%s','MD',fgN{fibID}(1:end-4),TractProfile{1,fibID}{pctl}.name))
        
    end
end

close all
return

%% add S.E.M
sem = nanstd(fa(CRD,:))/sqrt(size(fa(CRD,:),1));
% render S.E.M.
figure; hold on;

plot(X,nanmean(fa(CRD,:))+sem,'Color',c(1,:),...
    'linewidth',1, 'linestyle','--');
plot(X,nanmean(fa(CRD,:))-sem,'Color',c(1,:),...
    'linewidth',1, 'linestyle','--');

sem = nanstd(fa(LHON,:))/sqrt(size(fa(LHON,:),1));
% SEM
plot(X,nanmean(fa(LHON,:))+sem,'Color',c(1,:),...
    'linewidth',1, 'linestyle','--');
plot(X,nanmean(fa(LHON,:))-sem,'Color',c(1,:),...
    'linewidth',1, 'linestyle','--');

sem = nanstd(fa(Ctl,:))/sqrt(size(fa(Ctl,:),1));
% SEM
plot(X,nanmean(fa(Ctl,:))+sem,'Color',c(1,:),...
    'linewidth',1, 'linestyle','--');
plot(X,nanmean(fa(Ctl,:))-sem,'Color',c(1,:),...
    'linewidth',1, 'linestyle','--');

sem = nanstd(fa(RP,:))/sqrt(size(fa(RP,:),1));
% SEM
plot(X,nanmean(fa(RP,:))+sem,'Color',c(1,:),...
    'linewidth',1, 'linestyle','--');
plot(X,nanmean(fa(RP,:))-sem,'Color',c(1,:),...
    'linewidth',1, 'linestyle','--');

%% scatter plot
figure; hold on;
c= lines(100);
% JMD1
scatter(TractProfile{1,1}{1,1}.vals.ad(1,50:90),TractProfile{1,1}{1,1}.vals.rd(1,50:90),50,c(3,:));
scatter(TractProfile{10,1}{1,1}.vals.ad(1,50:90),TractProfile{1,1}{1,1}.vals.rd(1,50:90),50,c(1,:));
scatter(TractProfile{23,1}{1,1}.vals.ad(1,50:90),TractProfile{1,1}{1,1}.vals.rd(1,50:90),50,[0.5,0.5,0.5]);

xlabel('AD','fontName','Times','fontSize',14);
ylabel('RD','fontName','Times','fontSize',14);
title('ROR cont','fontName','Times','fontSize',14)

%% scatter plot
figure; hold on;
c= lines(100);
% JMD1
scatter(TractProfile{1,2}{1,1}.vals.ad,TractProfile{1,2}{1,1}.vals.rd,50,c(3,:));
scatter(TractProfile{10,2}{1,1}.vals.ad,TractProfile{1,2}{1,1}.vals.rd,50,c(1,:));
scatter(TractProfile{23,2}{1,1}.vals.ad,TractProfile{1,2}{1,1}.vals.rd,50,[0.5,0.5,0.5]);

xlabel('AD','fontName','Times','fontSize',14);
ylabel('RD','fontName','Times','fontSize',14);
title('ROR MRT','fontName','Times','fontSize',14)



%% one way anova

fibID =1%, 3]%ROR
for pctl = 2:6
    %% make one sheet diffusivities
    for subID = 1:length(subDir);
        if isempty(TractProfile{subID,fibID}{pctl}.nfibers);
            fa(subID,:) =nan(1,100);
        else
            fa(subID,:) =  mean([TractProfile{subID,fibID}{pctl}.vals.fa;...
                TractProfile{subID,fibID+1}{pctl}.vals.fa]);
        end;
        
        if isempty(TractProfile{subID,fibID}{pctl}.nfibers);
            md(subID,:) =nan(1,100);
        else
            md(subID,:) = mean([ TractProfile{subID,fibID}{pctl}.vals.md;...
                TractProfile{subID,fibID+1}{pctl}.vals.md]);
        end;
        
        if isempty(TractProfile{subID,fibID}{pctl}.nfibers);
            rd(subID,:) =nan(1,100);
        else
            rd(subID,:) = mean([ TractProfile{subID,fibID}{pctl}.vals.rd;...
                TractProfile{subID,fibID+1}{pctl}.vals.rd]);
        end;
        
        if isempty(TractProfile{subID,fibID}{pctl}.nfibers);
            ad(subID,:) =nan(1,100);
        else
            ad(subID,:) = mean([ TractProfile{subID,fibID}{pctl}.vals.ad;...
                TractProfile{subID,fibID+1}{pctl}.vals.ad]);
        end;
        % end
        %% S.E.M
        sem = nanstd(fa(Ctl,:))/sqrt(size(fa(Ctl,:),1));
        hms_CRD=(mean(fa(Ctl,:))-mean(fa(CRD,:)))./sem;
        hms_LHON=(mean(fa(Ctl,:))-mean(fa(LHON,:)))./sem;
        
        minmax(hms_CRD)
        find(hms_CRD>=max(hms_CRD))
        
        minmax(hms_LHON)
        find(hms_LHON>=max(hms_LHON))
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
        c = multcompare(stats(jj),'display','off')
        C{jj}=c;
    end
    
    Portion =  p<0.01;
    k =  find(p<0.01)
    
    %% render
    figure; hold on;
    for k= find(p<0.01)
        bar(k,1,1)
    end
    %
    % % return the node differ significantly between CRD and Ctl
    % for k =  find(p<0.01)
    %     m = C{k}(:,3);
    %     if m(2)>0
    %         k
    %     end
    % end
    
    
    
    % OT figure
    %         figure; hold on;
    % Create axes
    
    c=lines(4)
    
%     figure; hold on;
    % Render errorbar(S.E.M) of three groups
    % CRD
    sem = nanstd(fa(CRD,:))/sqrt(size(fa(CRD,:),1));
    errorbar(X,nanmean(fa(CRD,:)),sem,'Color',c(3,:),...
        'linewidth',1);
    % LHON
    sem = nanstd(fa(LHON,:))/sqrt(size(fa(LHON,:),1));
    errorbar(X,nanmean(fa(LHON,:)),sem,'Color',c(4,:),...
        'linewidth',1);
    % Control
    sem = nanstd(fa(Ctl,:))/sqrt(size(fa(Ctl,:),1));
    errorbar(X,nanmean(fa(Ctl,:)),sem,'Color',gray,...
        'linewidth',1);
    axis([0 100 0.1 0.6])
    %         title(sprintf('%s %s',fgN{fibID}(1:end-4),TractProfile{1,fibID}{sdID}.name)...
    %             ,'FontName','Times','FontSize',16);
    ylabel('Fractional anisotropy','FontName','Times','FontSize',16);
    xlabel('Location','FontName','Times','FontSize',16);
    %         line([17,17],[0.1,0.6] )
    %         line([23,23],[0.1,0.6] )
    %         line([41,41],[0.1,0.6] )
    %         line([92,92],[0.1,0.6] )
    %
    %         line([45,45],[0.1,0.65] )
    %         line([89,89],[0.1,0.65] )
    hold off;
end


%% 
