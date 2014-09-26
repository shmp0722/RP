function [TractProfile] = runSO_DivideFibersAcordingToFiberLength_3SD
%     [TractProfile, fg_SDm3,fg_SDm2,fg_SDm1,fg_SD1,fg_SD2,fg_SD3] = ...

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


% %% Calculate vals along the fibers and return TP structure
% for i =[30,31,35:39];%[30,32:34];%1:length(subDir)
%     % define directory
%     SubDir = fullfile(homeDir,subDir{i});
%     fgDir  = fullfile(SubDir,'/dwi_2nd/fibers');
%     %     newDir = fullfile(SubDir,'/dwi_2nd/fibers/conTrack/OR_1130');
%     %     roiDir = fullfile(SubDir,'/dwi_2nd/ROIs');
%     dt  = fullfile(homeDir,subDir{i},'dwi_2nd','dt6.mat');
%     dt  = dtiLoadDt6(dt);
%     
%     cd /biac4/wandell/biac3/wandell7/shumpei/matlab/git/LHON/3RP
%     
%     
%     fgN ={'ROR1206_D4L4.pdb','LOR1206_D4L4.pdb','ROTD4L4_1206.pdb','LOTD4L4_1206.pdb',...
%         'ROTD3L2_1206.pdb','LOTD3L2_1206.pdb'};
%     
%     for j =3:length(fgN)
%         fgF{j} = fgRead(fullfile(fgDir,fgN{j}));
%         
%         %     [TractProfile{i,j}, fg_SDm3{i,j},fg_SDm2{i,j},fg_SDm1{i,j},fg_SD1{i,j},fg_SD2{i,j},fg_SD3{i,j}]...
%         %         = SO_DivideFibersAcordingToFiberLength_SD3(fgF{j},dt,0,'AP',100);
%         
%         [TractProfile{i,j}, ~,~,~,~,~,~]...
%             = SO_DivideFibersAcordingToFiberLength_SD3(fgF{j},dt,0,'AP',100);
%     end
% end
% 
% %
% save 3RP_3SD_TractProfile TractProfile
% return

%% Load TractProfile

cd /biac4/wandell/biac3/wandell7/shumpei/matlab/git/LHON/3RP
load 3RP_3SD_TractProfile.mat

%% classify all subjects intogroups
JMD = 1:4;
CRD = 5:9;
% LHON = 10:15;
LHON = [10:14,27];

Ctl = [16:23,31:33,35:37];
RP = [24:26,28,29,34,38,39];

fgN ={'ROR1206_D4L4.pdb','LOR1206_D4L4.pdb','ROTD4L4_1206.pdb','LOTD4L4_1206.pdb',...
    'ROTD3L2_1206.pdb','LOTD3L2_1206.pdb'};

% Render plots which comparing CRD ,LHON, Ctl
% Y=nan(length(subDir),100);
X = 1:100;
c = lines(100);
gray = [0.5 0.5 0.5];

%% Render plots
for fibID = 1%4:6 %ROR
    for sdID = 1%:7
        % make one sheet diffusivities
        for subID = 1:length(subDir);
            if isempty(TractProfile{subID,fibID}{sdID}.nfibers);
                fa(subID,:) =nan(1,100);
            else
                fa(subID,:) =  TractProfile{subID,fibID}{sdID}.vals.fa;
            end;
            
            if isempty(TractProfile{subID,fibID}{sdID}.nfibers);
                md(subID,:) =nan(1,100);
            else
                md(subID,:) =  TractProfile{subID,fibID}{sdID}.vals.md;
            end;
            
            if isempty(TractProfile{subID,fibID}{sdID}.nfibers);
                rd(subID,:) =nan(1,100);
            else
                rd(subID,:) =  TractProfile{subID,fibID}{sdID}.vals.rd;
            end;
            
            if isempty(TractProfile{subID,fibID}{sdID}.nfibers);
                ad(subID,:) =nan(1,100);
            else
                ad(subID,:) =  TractProfile{subID,fibID}{sdID}.vals.ad;
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
        
        title(sprintf('%s %s',fgN{fibID}(1:end-4),TractProfile{1,fibID}{sdID}.name));
        ylabel('fa');
        xlabel('location');
        hold off;
        %         %% save fig
        %         cd /biac4/wandell/biac3/wandell7/shumpei/matlab/git/LHON/3RP/divideByLength_Plot
        %
        %         print(gcf,'-dpng',sprintf('%s_%s_%s','FA',fgN{fibID}(1:end-4),TractProfile{1,fibID}{sdID}.name))
        %
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
        
        title(sprintf('%s %s',fgN{fibID}(1:end-4),TractProfile{1,fibID}{sdID}.name));
        ylabel('ad');
        xlabel('location');
        hold off;
        %         %% save fig
        %
        %         print(gcf,'-dpng',sprintf('%s_%s_%s','AD',fgN{fibID}(1:end-4),TractProfile{1,fibID}{sdID}.name))
        
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
        
        title(sprintf('%s %s',fgN{fibID}(1:end-4),TractProfile{1,fibID}{sdID}.name));
        ylabel('rd');
        xlabel('location');
        hold off;
        %          %% save fig
        %
        %         print(gcf,'-dpng',sprintf('%s_%s_%s','RD',fgN{fibID}(1:end-4),TractProfile{1,fibID}{sdID}.name))
        
    end
    %     close all
end


%% drow errorbar plots merge both L and R tract
for fibID = [1,3]%4:6 %ROR
    for sdID = 1%:7
        % make one sheet diffusivities
        for subID = 1:length(subDir);
            if isempty(TractProfile{subID,fibID}{sdID}.nfibers);
                fa(subID,:) =nan(1,100);
            else
                fa(subID,:) =  mean([TractProfile{subID,fibID}{sdID}.vals.fa;...
                    TractProfile{subID,fibID+1}{sdID}.vals.fa]);
            end;
            
            if isempty(TractProfile{subID,fibID}{sdID}.nfibers);
                md(subID,:) =nan(1,100);
            else
                md(subID,:) = mean([ TractProfile{subID,fibID}{sdID}.vals.md;...
                    TractProfile{subID,fibID+1}{sdID}.vals.md]);
            end;
            
            if isempty(TractProfile{subID,fibID}{sdID}.nfibers);
                rd(subID,:) =nan(1,100);
            else
                rd(subID,:) = mean([ TractProfile{subID,fibID}{sdID}.vals.rd;...
                    TractProfile{subID,fibID+1}{sdID}.vals.rd]);
            end;
            
            if isempty(TractProfile{subID,fibID}{sdID}.nfibers);
                ad(subID,:) =nan(1,100);
            else
                ad(subID,:) = mean([ TractProfile{subID,fibID}{sdID}.vals.ad;...
                    TractProfile{subID,fibID+1}{sdID}.vals.ad]);
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
            'linewidth',1);
        % LHON
        sem = nanstd(fa(LHON,:))/sqrt(size(fa(LHON,:),1));
        errorbar(X,nanmean(fa(LHON,:)),sem,'Color',c(4,:),...
            'linewidth',1);
        % Control
        sem = nanstd(fa(Ctl,:))/sqrt(size(fa(Ctl,:),1));
        errorbar(X,nanmean(fa(Ctl,:)),sem,'Color',gray,...
            'linewidth',1);
        
        %         title(sprintf('%s %s',fgN{fibID}(1:end-4),TractProfile{1,fibID}{sdID}.name)...
        %             ,'FontName','Times','FontSize',16);
        ylabel('Fractional anisotropy','FontName','Times','FontSize',16);
        xlabel('Location','FontName','Times','FontSize',16);
        hold off;
        %% save fig
        cd /biac4/wandell/biac3/wandell7/shumpei/matlab/git/LHON/3RP/Figure6/
        
        print(gcf,'-depsc',sprintf('%s_%s_%s','FA',fgN{fibID}(1:end-4),TractProfile{1,fibID+1}{sdID}.name))
        
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
            'linewidth',1);
        % LHON
        sem = nanstd(md(LHON,:))/sqrt(size(md(LHON,:),1));
        errorbar(X,nanmean(md(LHON,:)),sem,'Color',c(4,:),...
            'linewidth',1);
        % Control
        sem = nanstd(md(Ctl,:))/sqrt(size(md(Ctl,:),1));
        errorbar(X,nanmean(md(Ctl,:)),sem,'Color',gray,...
            'linewidth',1);
        
        %         title(sprintf('%s %s',fgN{fibID}(1:end-4),TractProfile{1,fibID}{sdID}.name)...
        %             ,'FontName','Times','FontSize',16);
        ylabel('Mean diffusivity','FontName','Times','FontSize',16);
        xlabel('Location','FontName','Times','FontSize',16);
        hold off;
        
        %% save fig
        cd /biac4/wandell/biac3/wandell7/shumpei/matlab/git/LHON/3RP/Figure6/
        
        print(gcf,'-depsc',sprintf('%s_%s_%s','MD',fgN{fibID}(1:end-4),TractProfile{1,fibID}{sdID}.name))
        
        
        
        %% ad comparison
%                  figure; hold on;
        % Create axes
        axes1 = axes('Parent',figure,'YTick',[1.1 2],...
            'XTick',[0 100]);
        xlim(axes1,[0 100]);
        hold(axes1,'all');
        
        % Render errorbar(S.E.M) of three groups
        % CRD
        sem = nanstd(ad(CRD,:))/sqrt(size(ad(CRD,:),1));
        errorbar(X,nanmean(ad(CRD,:)),sem,'Color',c(3,:),...
            'linewidth',1);
        % LHON
        sem = nanstd(ad(LHON,:))/sqrt(size(ad(LHON,:),1));
        errorbar(X,nanmean(ad(LHON,:)),sem,'Color',c(4,:),...
            'linewidth',1);
        % Control
        sem = nanstd(ad(Ctl,:))/sqrt(size(ad(Ctl,:),1));
        errorbar(X,nanmean(ad(Ctl,:)),sem,'Color',gray,...
            'linewidth',1);
        
        %         title(sprintf('%s %s',fgN{fibID}(1:end-4),TractProfile{1,fibID}{sdID}.name)...
        %             ,'FontName','Times','FontSize',16);
        ylabel('Axial diffusivity','FontName','Times','FontSize',16);
        xlabel('Location','FontName','Times','FontSize',16);
        hold off;
        %% save fig
        cd /biac4/wandell/biac3/wandell7/shumpei/matlab/git/LHON/3RP/Figure6/
        
        print(gcf,'-depsc',sprintf('%s_%s_%s','AD',fgN{fibID}(1:end-4),TractProfile{1,fibID+1}{sdID}.name))
        
        
        %% rd comparison
        %         figure; hold on;
        % Create axes
        axes1 = axes('Parent',figure,'YTick',[0.4 1.8],...
            'XTick',[0 50 100]);
%         set(axes1,'YTick',[0.4 0.9])
        
        xlim(axes1,[0 100]);
        hold(axes1,'all');
        
        % Render errorbar(S.E.M) of three groups
        % CRD
        sem = nanstd(rd(CRD,:))/sqrt(size(rd(CRD,:),1));
        errorbar(X,nanmean(rd(CRD,:)),sem,'Color',c(3,:),...
            'linewidth',1);
        % LHON
        sem = nanstd(rd(LHON,:))/sqrt(size(rd(LHON,:),1));
        errorbar(X,nanmean(rd(LHON,:)),sem,'Color',c(4,:),...
            'linewidth',1);
        % Control
        sem = nanstd(rd(Ctl,:))/sqrt(size(rd(Ctl,:),1));
        errorbar(X,nanmean(rd(Ctl,:)),sem,'Color',gray,...
            'linewidth',1);
        
        %         title(sprintf('%s %s',fgN{fibID}(1:end-4),TractProfile{1,fibID}{sdID}.name)...
        %             ,'FontName','Times','FontSize',16);
        ylabel('Radial diffusivity','FontName','Times','FontSize',16);
        xlabel('Location','FontName','Times','FontSize',16);
        hold off;
        
        %% save fig
        cd /biac4/wandell/biac3/wandell7/shumpei/matlab/git/LHON/3RP/Figure6/
        
        print(gcf,'-depsc',sprintf('%s_%s_%s','RD',fgN{fibID}(1:end-4),TractProfile{1,fibID}{sdID}.name))
        
    end
end

return


%% render CRD, LHON ,Ctl, RP
% Y=nan(length(subDir),100);
X = 1:100;
c = lines(100);
gray = [0.5 0.5 0.5];

for fibID =1%:6 %ROR
    for sdID = 1
        
        for subID = 1:length(subDir);
            if isempty(TractProfile{subID,fibID}{sdID}.nfibers);
                fa(subID,:) =nan(1,100);
            else
                fa(subID,:) =  TractProfile{subID,fibID}{sdID}.vals.fa;
            end;
            
            if isempty(TractProfile{subID,fibID}{sdID}.nfibers);
                md(subID,:) =nan(1,100);
            else
                md(subID,:) =  TractProfile{subID,fibID}{sdID}.vals.md;
            end;
            
            if isempty(TractProfile{subID,fibID}{sdID}.nfibers);
                rd(subID,:) =nan(1,100);
            else
                rd(subID,:) =  TractProfile{subID,fibID}{sdID}.vals.rd;
            end;
            
            if isempty(TractProfile{subID,fibID}{sdID}.nfibers);
                ad(subID,:) =nan(1,100);
            else
                ad(subID,:) =  TractProfile{subID,fibID}{sdID}.vals.ad;
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
        
        %         title(sprintf('%s %s',fgN{fibID}(1:end-4),TractProfile{1,fibID}{sdID}.name));
        ylabel('fa');
        xlabel('location');
        hold off;
        %         %% save fig
        %         cd /biac4/wandell/biac3/wandell7/shumpei/matlab/git/LHON/3RP/divideByLength_Plot
        %
        %         print(gcf,'-dpng',sprintf('%s_%s_%s','FA',fgN{fibID}(1:end-4),TractProfile{1,fibID}{sdID}.name))
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
        
        %         title(sprintf('%s %s',fgN{fibID}(1:end-4),TractProfile{1,fibID}{sdID}.name));
        ylabel('ad');
        xlabel('location');
        hold off;
        %         %% save fig
        %
        %         print(gcf,'-dpng',sprintf('%s_%s_%s','AD',fgN{fibID}(1:end-4),TractProfile{1,fibID}{sdID}.name))
        
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
        
        %         title(sprintf('%s %s',fgN{fibID}(1:end-4),TractProfile{1,fibID}{sdID}.name));
        ylabel('rd');
        xlabel('location');
        hold off;
        %          %% save fig
        %
        %         print(gcf,'-dpng',sprintf('%s_%s_%s','RD',fgN{fibID}(1:end-4),TractProfile{1,fibID}{sdID}.name))
        
    end
end



%% drow boxplots merge both L and R tract
for fibID = [1]%4:6 %ROR
    for sdID = 2:7
        % make one sheet diffusivities
        for subID = 1:length(subDir);
            if isempty(TractProfile{subID,fibID}{sdID}.nfibers);
                fa(subID,:) =nan(1,100);
            else
                fa(subID,:) =  mean([TractProfile{subID,fibID}{sdID}.vals.fa;...
                    TractProfile{subID,fibID+1}{sdID}.vals.fa]);
            end;
            
            if isempty(TractProfile{subID,fibID}{sdID}.nfibers);
                md(subID,:) =nan(1,100);
            else
                md(subID,:) = mean([ TractProfile{subID,fibID}{sdID}.vals.md;...
                    TractProfile{subID,fibID+1}{sdID}.vals.md]);
            end;
            
            if isempty(TractProfile{subID,fibID}{sdID}.nfibers);
                rd(subID,:) =nan(1,100);
            else
                rd(subID,:) = mean([ TractProfile{subID,fibID}{sdID}.vals.rd;...
                    TractProfile{subID,fibID+1}{sdID}.vals.rd]);
            end;
            
            if isempty(TractProfile{subID,fibID}{sdID}.nfibers);
                ad(subID,:) =nan(1,100);
            else
                ad(subID,:) = mean([ TractProfile{subID,fibID}{sdID}.vals.ad;...
                    TractProfile{subID,fibID+1}{sdID}.vals.ad]);
            end;
        end
        
        
        %% box
        figure; hold on;
        boxplot([nanmean(fa(LHON,:))',nanmean(fa(CRD,:))',nanmean(fa(Ctl,:))'],'notch','on')
        
        
        ylabel('Fractional anisotropy','FontName','Times','FontSize',16);
        xlabel('group','FontName','Times','FontSize',16);
%                         % save fig
%                         cd /biac4/wandell/biac3/wandell7/shumpei/matlab/git/LHON/3RP/Figure3/
%         
%                         print(gcf,'-depsc',sprintf('%s_%s_%s','FA',fgN{fibID}(1:end-4),TractProfile{1,fibID}{sdID}.name))
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
    for sdID = 1:7
        
        for subID =1:length(subDir);
            if isempty(TractProfile{subID,fibID}{sdID}.nfibers);
                fa(subID,:) =nan(1,100);
            else
                fa(subID,:) =  TractProfile{subID,fibID}{sdID}.vals.fa;
            end;
            
            if isempty(TractProfile{subID,fibID}{sdID}.nfibers);
                md(subID,:) =nan(1,100);
            else
                md(subID,:) =  TractProfile{subID,fibID}{sdID}.vals.md;
            end;
            
            if isempty(TractProfile{subID,fibID}{sdID}.nfibers);
                rd(subID,:) =nan(1,100);
            else
                rd(subID,:) =  TractProfile{subID,fibID}{sdID}.vals.rd;
            end;
            
            if isempty(TractProfile{subID,fibID}{sdID}.nfibers);
                ad(subID,:) =nan(1,100);
            else
                ad(subID,:) =  TractProfile{subID,fibID}{sdID}.vals.ad;
            end;
        end
        
        %% fa comparison
        figure; hold on;
        
        % LHON6 longtudinal
        plot(X,fa(15,:),'Color',c(3,:),'linewidth',2);
        plot(X,fa(27,:),'Color',c(4,:),'linewidth',2);
        
        legend('LHON6 previous','LHON6 present');
        
        title(sprintf('%s %s',fgN{fibID}(1:end-4),TractProfile{1,fibID}{sdID}.name));
        ylabel('fa');
        xlabel('location');
        hold off;
        %% save fig
        cd '/biac4/wandell/biac3/wandell7/shumpei/matlab/git/LHON/3RP/LHON6 longtudinal'
        
        print(gcf,'-dpng',sprintf('LHON6_logntudinal%s_%s_%s','FA',fgN{fibID}(1:end-4),TractProfile{1,fibID}{sdID}.name))
        %
        %% ad comparison
        figure; hold on;
        
        % LHON6 longtudinal
        plot(X,ad(15,:),'Color',c(3,:),'linewidth',2);
        plot(X,ad(27,:),'Color',c(4,:),'linewidth',2);
        
        legend('LHON6 previous','LHON6 present');
        
        title(sprintf('%s %s',fgN{fibID}(1:end-4),TractProfile{1,fibID}{sdID}.name));
        ylabel('ad');
        xlabel('location');
        hold off;
        %% save fig
        
        print(gcf,'-dpng',sprintf('LHON6_logntudinal%s_%s_%s','AD',fgN{fibID}(1:end-4),TractProfile{1,fibID}{sdID}.name))
        
        %% rd comparison
        figure; hold on;
        
        % LHON6 longtudinal
        plot(X,rd(15,:),'Color',c(3,:),'linewidth',2);
        plot(X,rd(27,:),'Color',c(4,:),'linewidth',2);
        
        legend('LHON6 previous','LHON6 present');
        
        title(sprintf('%s %s',fgN{fibID}(1:end-4),TractProfile{1,fibID}{sdID}.name));
        ylabel('rd');
        xlabel('location');
        hold off;
        %% save fig
        
        print(gcf,'-dpng',sprintf('LHON6_logntudinal%s_%s_%s','RD',fgN{fibID}(1:end-4),TractProfile{1,fibID}{sdID}.name))
        
        %% md comparison
        figure; hold on;
        
        % LHON6 longtudinal
        plot(X,md(15,:),'Color',c(3,:),'linewidth',2);
        plot(X,md(27,:),'Color',c(4,:),'linewidth',2);
        
        legend('LHON6 previous','LHON6 present');
        
        title(sprintf('%s %s',fgN{fibID}(1:end-4),TractProfile{1,fibID}{sdID}.name));
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
        
        print(gcf,'-dpng',sprintf('LHON6_logntudinal%s_%s_%s','MD',fgN{fibID}(1:end-4),TractProfile{1,fibID}{sdID}.name))
        
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


%% e
% figure; hold on;
c = jet(6);
X = 1:100;
for sdID =1:7
    for fibID = 1:6;
        figure; hold on;
        
        Y=nan(length(subDir),100);
        
        for subID = CRD;
            if isempty(TractProfile{subID,fibID}{sdID}.nfibers);
            else
                Y(subID,:) =  TractProfile{subID,fibID}{sdID}.vals.fa;      %SDm1
                % Y2 =TractProfile{subID,fibID}{1,5}.vals.fa      %SD1
                if sdID==1;
                    plot(X,Y(subID,:),'Color',[0.5,0.5,0.5],'linewidth',2);
                else
                    plot(X,Y(subID,:),'Color',c(subID-4,:),'linewidth',2);
                end;
            end
        end
        %     meanY = plot(X,nanmean(Y),'Color',[0.5,0.5,0.5],'linewidth',3);
        sdY   = plot(X,nanmean(Y)+nanstd(Y),'Color',[0.5,0.5,0.5],'linewidth',1,...
            'linestyle','--');
        sdY2   = plot(X,nanmean(Y)-nanstd(Y),'Color',[0.5,0.5,0.5],'linewidth',1,...
            'linestyle','--');
        
        ylabel('fa');
        xlabel('location');
        title(sprintf('%s %s %s',fgN{fibID}(1:end-4),TractProfile{1,fibID}{sdID}.name,subDir{subID}));
        hold off;
    end
end
% close all
%% ROR m3

figure; hold on;
c = jet(6);
X = 1:100;
Y=nan(length(CRD),100);
for subID = CRD; fibID = 1;
    Y(subID,:) =  TractProfile{subID,fibID}{1,2}.vals.fa;      %SDm1
    % Y2 =TractProfile{subID,fibID}{1,5}.vals.fa      %SD1
    plot(X,Y(subID,:),'Color',c(subID-4,:),'linewidth',2)
end
meanY = plot(X,nanmean(Y),'Color',[0.5,0.5,0.5],'linewidth',3);
sdY   = plot(X,nanmean(Y)+nanstd(Y),'Color',[0.5,0.5,0.5],'linewidth',1,...
    'linestyle','--');
sdY2   = plot(X,nanmean(Y)-nanstd(Y),'Color',[0.5,0.5,0.5],'linewidth',1,...
    'linestyle','--');

ylabel('fa');
xlabel('location');
title(sprintf('%s %s',TractProfile{1,fibID}{1,1}.name,subDir{subID}));

%% ROR m2
figure; hold on;
c = jet(6);
X = 1:100;
for subID = CRD; fibID = 1;
    
    Y =  TractProfile{subID,fibID}{1,3}.vals.fa;      %SDm1
    % Y2 =TractProfile{subID,fibID}{1,5}.vals.fa      %SD1
    plot(X,Y,'Color',c(subID-4,:))
    title('ROR sdm2')
end




%% ROR m1
figure; hold on;
c = lines(6);
X = 1:100;
for subID = CRD; fibID = 1;
    
    Y =  TractProfile{subID,fibID}{1,4}.vals.fa ;     %SDm1
    % Y2 =TractProfile{subID,fibID}{1,5}.vals.fa      %SD1
    plot(X,Y,'Color',c(subID-4,:))
    title('ROR sdm1')
end


%% ROR SD1
figure; hold on;
c = jet(6);
X = 1:100;
for subID = CRD; fibID = 1;
    
    %    Y =  TractProfile{subID,fibID}{1,4}.vals.fa      %SDm1
    Y2 =TractProfile{subID,fibID}{1,5}.vals.fa ;     %SD1
    plot(X,Y2,'Color',c(subID-4,:))
    title('ROR sd1')
    
end

%% ROR SD2
figure; hold on;
c = jet(6);
X = 1:100;
for subID = CRD; fibID = 1;
    
    %    Y =  TractProfile{subID,fibID}{1,4}.vals.fa      %SDm1
    Y2 =TractProfile{subID,fibID}{1,6}.vals.fa ;     %SD1
    plot(X,Y2,'Color',c(subID-4,:))
    title('ROR sd2')
    
end

%% ROR SD2
figure; hold on;
c = jet(6);
X = 1:100;
for subID = CRD; fibID = 1;
    %    Y =  TractProfile{subID,fibID}{1,4}.vals.fa %SDm1
    if TractProfile{subID,fibID}{1,7}.vals.fa==[];
    else
        Y2 =TractProfile{subID,fibID}{1,7}.vals.fa ;     %SD1
        plot(X,Y2,'Color',c(subID-4,:))
    end
    
end
title('ROR sd3')

%% compare conTrack and mrTrix optic radiation
figure; hold on;
X = 1:100;
c = jet(2);
Yc = TractProfile{1,1}{1,1}.vals.fa;
Ym = TractProfile{1,2}{1,1}.vals.fa;
plot(X,Yc,'color',c(1,:),'LineWidth',2);
plot(X,Ym,'color',c(2,:),'LineWidth',2);
legend('Contrack','MrTrix')
title('FA in ROR')
% axis('FA')
hold  off;


%% contrack
for i = [1:18,20,21,23]
    figure; hold on;
    X = 1:100;
    c = jet(8);
    
    for j = 1: length(TractProfile{1,1})
        Yc = TractProfile{i,1}{1,j}.vals.fa;
        if j==1;
            % Ym = TractProfile{1,2}{1,1}.vals.fa;
            plot(X,Yc,'color',[0.5 0.5 0.5],'LineWidth',4);
        else
            plot(X,Yc,'color',c(j-1,:),'LineWidth',2);
        end
    end
    
    % plot(X,Ym,'color',c(2,:),'LineWidth',2);
    % legend('Contrack','MrTrix')
    title(sprintf('%s %s',subDir{i},'ROR FA Variation with Contrack'));
    % axis('FA')
    hold  off;
    
    %% save figure
    cd /biac4/wandell/biac3/wandell7/shumpei/matlab/git/LHON/3RP/CompareMRTandContrack
    
    print(gcf,'-dpng',sprintf('%s_%s',subDir{i},'ROR_FA_Variation_Contrack.png'))
    close all;
end

%% Mrtrix
figure; hold on;
X = 1:100;
c = jet(8);
for i = 1: length(TractProfile{1,1})
    %     Yc = TractProfile{1,2}{1,i}.vals.fa;
    if i==1;
        Yc = TractProfile{1,2}{1,i}.vals.fa;
        % Ym = TractProfile{1,2}{1,1}.vals.fa;
        plot(X,Yc,'color',[0.5 0.5 0.5],'LineWidth',4);
    elseif i==2;
    else
        Yc = TractProfile{1,2}{1,i}.vals.fa;
        plot(X,Yc,'color',c(i-1,:),'LineWidth',2);
    end
end
% plot(X,Ym,'color',c(2,:),'LineWidth',2);
title('Variation according to fiber length FA of ROR with Mrtrix')
colorbar('peer',axes1);
% legend('Contrack','MrTrix')
title('FA in ROR')
% axis('FA')
hold  off;

%% render fibers
% AFQ_RenderFibers(fg_SDm3{2},'dt',dt,'radius', [.1 3],'numfibers',10,'newfig',1,'camera','axial','tubes', 0);
%
% AFQ_RenderFibers(fg_SDm2{2},'dt',dt,'radius', [.1 3],'numfibers',100,'newfig',1,'camera','axial','tubes', 0);
% AFQ_RenderFibers(fg_SDm1{2},'dt',dt,'radius', [.1 3],'numfibers',100,'newfig',1,'camera','axial','tubes', 0);
% % AFQ_RenderFibers(fg_SDm4{2},'dt',dt,'radius', [.1 3],'numfibers',100,'newfig',0,'camera','axial','tubes', 0);
% AFQ_RenderFibers(fg_SD1{2},'dt',dt,'radius', [.1 3],'numfibers',100,'newfig',1,'camera','axial','tubes', 0);
% AFQ_RenderFibers(fg_SD2{2},'dt',dt,'radius', [.1 3],'numfibers',100,'newfig',1,'camera','axial','tubes', 0);
% AFQ_RenderFibers(fg_SD3{2},'dt',dt,'radius', [.1 3],'numfibers',100,'newfig',1,'camera','axial','tubes', 0);
% AFQ_RenderFibers(fg_SD4{2},'dt',dt,'radius', [.1 3],'numfibers',100,'newfig',1,'camera','axial','tubes', 0);
%
%



%% render fibers
%    AFQ_RenderFibers(fgF{1},'dt',dt,'numfibers',10,'camera','axial','tubes', 0,'radius', [.2 2],'newfig',1)

SubDir = fullfile(homeDir,subDir{i});
fgDir  = fullfile(SubDir,'/dwi_2nd/fibers');
%     newDir = fullfile(SubDir,'/dwi_2nd/fibers/conTrack/OR_1130');
%     roiDir = fullfile(SubDir,'/dwi_2nd/ROIs');
dt  = fullfile(homeDir,subDir{i},'dwi_2nd','dt6.mat');
dt  = dtiLoadDt6(dt);

t1 = niftiRead(dt.files.t1);

cd /biac4/wandell/biac3/wandell7/shumpei/matlab/git/LHON/3RP

fgN ={'ROR1206_D4L4.pdb','LOR1206_D4L4.pdb','ROTD4L4_1206.pdb','LOTD4L4_1206.pdb',...
    'ROTD3L2_1206.pdb','LOTD3L2_1206.pdb'};


for jj = 1:length(fgF)
    AFQ_RenderFibers(fgF{jj},'dt',dt,'numfibers',10,'camera','axial','tubes', 0,'radius', [.2 2],'newfig',1)
    %
    
    %        a =  -64.0872
    %        b =   69.4895
    %        % if you want to show T1 image togather
    AFQ_AddImageTo3dPlot(t1, [0, 0, -5]);
    AFQ_AddImageTo3dPlot(t1, [5, 0, 0]);
    %        view(0,89) % axial view
    %        %     view(-38,30)
    %        camlight('headlight')
    %        axis image
    %        view(70,31) % view form back right
    view(84,67.5)
    axis off
    axis([10 50 -110 0 -10 40])
    %% if you want to save the image
    cd /biac4/wandell/biac3/wandell7/shumpei/matlab/git/LHON/3RP/CompareMRTandContrack
    
    %        print(gcf,'-dpng',sprintf('%s_FA.png',fgF{jj}.name))
    %if you like the image with T1w
    print(gcf,'-dpng',sprintf('%s_%s_FA_onT1w_3.png',subDir{i},fgF{jj}.name))
end
%% figure
figure; hold on;
AFQ_RenderFibers(fgF{1},'numfibers',1,'camera','axial','tubes', 1,'radius', [.5 5],'newfig',1,'color',c(jj,:))

for jj = 1:length(fgF)
    AFQ_RenderFibers(fgF{jj},'numfibers',1,'camera','axial','tubes', 1,'radius', [.5 5],'newfig',0,'color',c(jj,:))
end
axis image
axis off
%    color = rand(size(TractProfile{1}.coords.acpc,1),3);
%      figure
%   [X, Y, Z, C] =  AFQ_TubeFromCoords(TractProfile{1}.coords.acpc,2,c(jj,:),20);
%     surf(X, Y, Z, C);


%% figure
figure; hold on;
AFQ_RenderFibers(fg_SDm3{2},'numfibers',1,'camera','axial','tubes', 1,'radius', [.5 5],'newfig',1,'color',c(1,:))

for jj = 1:length(fgF)
    AFQ_RenderFibers(fgF{jj},'numfibers',1,'camera','axial','tubes', 1,'radius', [.5 5],'newfig',0,'color',c(jj,:))
end
axis image
axis off
%    color = rand(size(TractProfile{1}.coords.acpc,1),3);
%      figure
%   [X, Y, Z, C] =  AFQ_TubeFromCoords(TractProfile{1}.coords.acpc,2,c(jj,:),20);
%     surf(X, Y, Z, C);

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

%%
%%%%%%%%%%%%%%%%%%%%%
% Anova

fibID = 3;%OR = 1, OT =3
sdID = 1;%:7
% make one sheet diffusivities
for subID = 1:length(subDir);
    if isempty(TractProfile{subID,fibID}{sdID}.nfibers);
        fa(subID,:) =nan(1,100);
    else
        fa(subID,:) =  mean([TractProfile{subID,fibID}{sdID}.vals.fa;...
            TractProfile{subID,fibID+1}{sdID}.vals.fa]);
    end;
    
    if isempty(TractProfile{subID,fibID}{sdID}.nfibers);
        md(subID,:) =nan(1,100);
    else
        md(subID,:) = mean([ TractProfile{subID,fibID}{sdID}.vals.md;...
            TractProfile{subID,fibID+1}{sdID}.vals.md]);
    end;
    
    if isempty(TractProfile{subID,fibID}{sdID}.nfibers);
        rd(subID,:) =nan(1,100);
    else
        rd(subID,:) = mean([ TractProfile{subID,fibID}{sdID}.vals.rd;...
            TractProfile{subID,fibID+1}{sdID}.vals.rd]);
    end;
    
    if isempty(TractProfile{subID,fibID}{sdID}.nfibers);
        ad(subID,:) =nan(1,100);
    else
        ad(subID,:) = mean([ TractProfile{subID,fibID}{sdID}.vals.ad;...
            TractProfile{subID,fibID+1}{sdID}.vals.ad]);
    end;
end
%% S.E.M
diffusivity = 'fa';
p_value = 0.01;
switch diffusivity
    case 'fa'
        sem = nanstd(fa(Ctl,:))/sqrt(size(fa(Ctl,:),1));
        hms_CRD=(mean(fa(Ctl,:))-mean(fa(CRD,:)))./sem;
        hms_LHON=(mean(fa(Ctl,:))-mean(fa(LHON,:)))./sem;
        
        %
        Ctl_fa =  fa(Ctl,:);
        LHON_fa =  fa(LHON,:);
        CRD_fa =  fa(CRD,:);
        
        for jj= 1: 100
            pac = nan(14,3);
            pac(:,1)= Ctl_fa(:,jj);
            pac(1:6,2)= LHON_fa(:,jj);
            pac(1:5,3)= CRD_fa(:,jj);
            p(jj) = anova1(pac,[],'off');
        end
        
        Portion =  p<p_value;
        
        
    case 'md'
        sem = nanstd(md(Ctl,:))/sqrt(size(md(Ctl,:),1));
        hms_CRD=(mean(md(Ctl,:))-mean(md(CRD,:)))./sem;
        hms_LHON=(mean(md(Ctl,:))-mean(md(LHON,:)))./sem;
        
        Ctl_md =  md(Ctl,:);
        LHON_md =  md(LHON,:);
        CRD_md =  md(CRD,:);
        
        for jj= 1: 100
            pac = nan(14,3);
            pac(:,1)= Ctl_md(:,jj);
            pac(1:6,2)= LHON_md(:,jj);
            pac(1:5,3)= CRD_md(:,jj);
            p(jj) = anova1(pac,[],'off');
        end
        
        Portion =  p<p_value;
        
        
    case 'ad'
        sem = nanstd(ad(Ctl,:))/sqrt(size(ad(Ctl,:),1));
        hms_CRD=(mean(ad(Ctl,:))-mean(ad(CRD,:)))./sem;
        hms_LHON=(mean(ad(Ctl,:))-mean(ad(LHON,:)))./sem;
        
        Ctl_ad =  ad(Ctl,:);
        LHON_ad =  ad(LHON,:);
        CRD_ad =  ad(CRD,:);
        
        for jj= 1: 100
            pac = nan(14,3);
            pac(:,1)= Ctl_ad(:,jj);
            pac(1:6,2)= LHON_ad(:,jj);
            pac(1:5,3)= CRD_ad(:,jj);
            p(jj) = anova1(pac,[],'off');
        end
        
        Portion =  p<p_value;
        
    case 'rd'
        sem = nanstd(rd(Ctl,:))/sqrt(size(rd(Ctl,:),1));
        hms_CRD=(mean(rd(Ctl,:))-mean(rd(CRD,:)))./sem;
        hms_LHON=(mean(rd(Ctl,:))-mean(rd(LHON,:)))./sem;
        
        Ctl_rd =  rd(Ctl,:);
        LHON_rd =  rd(LHON,:);
        CRD_rd =  rd(CRD,:);
        
        for jj= 1: 100
            pac = nan(14,3);
            pac(:,1)= Ctl_rd(:,jj);
            pac(1:6,2)= LHON_rd(:,jj);
            pac(1:5,3)= CRD_rd(:,jj);
            p(jj) = anova1(pac,[],'off');
        end
        
        Portion =  p<p_value;
        
        
end

minmax(hms_CRD)
minmax(hms_LHON)



%% OT figure
        %         figure; hold on;
        % Create axes
       
        
        figure; hold on;
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
        axis([0 100 0.1 0.6])
        %         title(sprintf('%s %s',fgN{fibID}(1:end-4),TractProfile{1,fibID}{sdID}.name)...
        %             ,'FontName','Times','FontSize',16);
        ylabel('Fractional anisotropy','FontName','Times','FontSize',16);
        xlabel('Location','FontName','Times','FontSize',16);
        
        area(Portion)
%         line([17,17],[0.1,0.6] )
%         line([23,23],[0.1,0.6] ) 
%         line([41,41],[0.1,0.6] )
%         line([92,92],[0.1,0.6] )
%         
%         line([45,45],[0.1,0.65] )
%         line([89,89],[0.1,0.65] ) 

       %% OR figure
        %         figure; hold on;
        % Create axes
       
        
        figure; hold on;
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
        axis([0 100 0.15 0.65])
        %         title(sprintf('%s %s',fgN{fibID}(1:end-4),TractProfile{1,fibID}{sdID}.name)...
        %             ,'FontName','Times','FontSize',16);
        ylabel('Fractional anisotropy','FontName','Times','FontSize',16);
        xlabel('Location','FontName','Times','FontSize',16);
        line([13,13],[0.1,0.65] )
        line([14,14],[0.1,0.65] ) 
        line([31,31],[0.1,0.65] )
        line([92,92],[0.1,0.65] )

        line([49,49],[0.1,0.65] )
        line([95,95],[0.1,0.65] ) 
        
        
%% individual plot
fibID = 1;%OR = 1, OT =3
sdID = 1;%:7
% make one sheet diffusivities
for subID = 1:length(subDir);
    if isempty(TractProfile{subID,fibID}{sdID}.nfibers);
        fa(subID,:) =nan(1,100);
    else
        fa(subID,:) =  mean([TractProfile{subID,fibID}{sdID}.vals.fa;...
            TractProfile{subID,fibID+1}{sdID}.vals.fa]);
    end;
    
    if isempty(TractProfile{subID,fibID}{sdID}.nfibers);
        md(subID,:) =nan(1,100);
    else
        md(subID,:) = mean([ TractProfile{subID,fibID}{sdID}.vals.md;...
            TractProfile{subID,fibID+1}{sdID}.vals.md]);
    end;
    
    if isempty(TractProfile{subID,fibID}{sdID}.nfibers);
        rd(subID,:) =nan(1,100);
    else
        rd(subID,:) = mean([ TractProfile{subID,fibID}{sdID}.vals.rd;...
            TractProfile{subID,fibID+1}{sdID}.vals.rd]);
    end;
    
    if isempty(TractProfile{subID,fibID}{sdID}.nfibers);
        ad(subID,:) =nan(1,100);
    else
        ad(subID,:) = mean([ TractProfile{subID,fibID}{sdID}.vals.ad;...
            TractProfile{subID,fibID+1}{sdID}.vals.ad]);
    end;
end

