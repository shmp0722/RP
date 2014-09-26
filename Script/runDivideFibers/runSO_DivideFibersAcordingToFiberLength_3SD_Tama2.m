function [TractProfile] = runSO_DivideFibersAcordingToFiberLength_3SD_Tama2
%     [TractProfile, fg_SDm3,fg_SDm2,fg_SDm1,fg_SD1,fg_SD2,fg_SD3] = ...

%%
homeDir = '/biac4/wandell/biac2/wandell/data/DWI-Tamagawa-Japan2';

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
    'RP8-YT-2014-03-14-dMRI-Anatomy'
    };
% %%
% matlabpool OPEN 8

% %% Calculate vals along the fibers and return TP structure
% for i =1:length(subDir)
%     % define directory
%     SubDir = fullfile(homeDir,subDir{i});
%     fgDir  = fullfile(SubDir,'/dwi_2nd/fibers');
%     %     newDir = fullfile(SubDir,'/dwi_2nd/fibers/conTrack/OR_1130');
%     %     roiDir = fullfile(SubDir,'/dwi_2nd/ROIs');
%     dt  = fullfile(homeDir,subDir{i},'dwi_2nd','dt6.mat');
%     dt  = dtiLoadDt6(dt);
%
% %     cd /biac4/wandell/biac3/wandell7/shumpei/matlab/git/LHON/3RP
%
%
%     fgN ={'ROR1206_D4L4.pdb','LOR1206_D4L4.pdb'};
%     %,'ROTD4L4_1206.pdb','LOTD4L4_1206.pdb'};
% %     ,...
% %         'ROTD3L2_1206.pdb','LOTD3L2_1206.pdb'};
%
%        parfor j =1:length(fgN)
%         fgF = fgRead(fullfile(fgDir,fgN{j}));
%
%         %     [TractProfile{i,j}, fg_SDm3{i,j},fg_SDm2{i,j},fg_SDm1{i,j},fg_SD1{i,j},fg_SD2{i,j},fg_SD3{i,j}]...
%         %         = SO_DivideFibersAcordingToFiberLength_SD3(fgF{j},dt,0,'AP',100);
%
%         [TractProfile{i,j}, ~,~,~,~,~,~]...
%             = SO_DivideFibersAcordingToFiberLength_SD3(fgF,dt,0,'AP',100);
%     end
% end
% %
% cd('/biac4/wandell/biac3/wandell7/shumpei/matlab/git/LHON/3RP/Tama2');
% save Tama2_TP TractProfile
% %%
% save RerunSD3_TractProfile TractProfile;
% cd '/biac4/wandell/biac2/wandell/data/DWI-Tamagawa-Japan';
%
% return

%% Load TractProfile

cd '/biac4/wandell/biac3/wandell7/shumpei/matlab/git/LHON/3RP/Tama2';
load Tama2_TP.mat

%% classify all subjects intogroups
JMD = 1:4;
CRD = 5:9;
% LHON = 10:15;
LHON = [10:14,27];

Ctl = [16:23,31:33,35:37];
RP = [24:26,28,29,34,38,39];

fgN ={'ROR1206_D4L4.pdb','LOR1206_D4L4.pdb','ROTD4L4_1206.pdb','LOTD4L4_1206.pdb'};
...'ROTD3L2_1206.pdb','LOTD3L2_1206.pdb'};
    
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
    for sdID = 1:7
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
        cd /biac4/wandell/biac3/wandell7/shumpei/matlab/git/LHON/3RP/Tama2/
        
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
for fibID = [1,3]%4:6 %ROR
    for sdID = 1:7
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
        %                 %% save fig
        %                 cd /biac4/wandell/biac3/wandell7/shumpei/matlab/git/LHON/3RP/Figure3/
        %
        %                 print(gcf,'-depsc',sprintf('%s_%s_%s','FA',fgN{fibID}(1:end-4),TractProfile{1,fibID}{sdID}.name))
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
        %         %% save fig
        %
        %         print(gcf,'-dpng',sprintf('LHON6_logntudinal%s_%s_%s','AD',fgN{fibID}(1:end-4),TractProfile{1,fibID}{sdID}.name))
        %
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
        %         %% save fig
        %
        %         print(gcf,'-dpng',sprintf('LHON6_logntudinal%s_%s_%s','RD',fgN{fibID}(1:end-4),TractProfile{1,fibID}{sdID}.name))
        
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
        %         %% save fig
        %
        %         print(gcf,'-dpng',sprintf('LHON6_logntudinal%s_%s_%s','MD',fgN{fibID}(1:end-4),TractProfile{1,fibID}{sdID}.name))
        
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


%%
%%%%%%%%%%%%%%%%%%%%%
% Anova

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
%% S.E.M
sem = nanstd(fa(Ctl,:))/sqrt(size(fa(Ctl,:),1));
hms_CRD=(mean(fa(Ctl,:))-mean(fa(CRD,:)))./sem;
hms_LHON=(mean(fa(Ctl,:))-mean(fa(LHON,:)))./sem;

minmax(hms_CRD)
minmax(hms_LHON)

%%
ds_Ctl  =  dataset(fa(Ctl,:));
ds_LHON =  dataset(fa(LHON,:));
ds_CRD  =  dataset(fa(CRD,:));

%%
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

Portion =  p<0.01;

%% OT figure
%         figure; hold on;
% Create axes


h = figure; hold on;
ah = bar(Portion,1,'EdgeColor','none')

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

%         set(gcf,'YTick',[0.1 0.6]),...
%     'XTickLabel',{'OC','','LGN'},...
%     'XTick',[0 50 100])
%
%         set(ah, 'Layer','bottom')
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
ah = bar(Portion,1,'EdgeColor','none')

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
%         line([13,13],[0.1,0.65] )
%         line([14,14],[0.1,0.65] )
%         line([31,31],[0.1,0.65] )
%         line([92,92],[0.1,0.65] )
%
%         line([49,49],[0.1,0.65] )
%         line([95,95],[0.1,0.65] )


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

%% render fibers
%    AFQ_RenderFibers(fgF{1},'dt',dt,'numfibers',10,'camera','axial','tubes', 0,'radius', [.2 2],'newfig',1)
for i = 1:length(subDir)
    SubDir = fullfile(homeDir,subDir{i});
    fgDir  = fullfile(SubDir,'/dwi_2nd/fibers');
    %     newDir = fullfile(SubDir,'/dwi_2nd/fibers/conTrack/OR_1130');
    %     roiDir = fullfile(SubDir,'/dwi_2nd/ROIs');
    dt  = fullfile(homeDir,subDir{i},'dwi_2nd','dt6.mat');
    dt  = dtiLoadDt6(dt);
    
    t1 = niftiRead(dt.files.t1);
    
    cd /biac4/wandell/biac3/wandell7/shumpei/matlab/git/LHON/3RP
    
    fgN ={'ROR1206_D4L4.pdb','LOR1206_D4L4.pdb','ROTD4L4_1206.pdb','LOTD4L4_1206.pdb'};
    %         'ROTD3L2_1206.pdb','LOTD3L2_1206.pdb'};
    cd(fgDir)
    
    figure; hold on;
    for jj = 1:length(fgN)
        fg = fgRead(fgN{jj});
        %         AFQ_RenderFibers(fg,'dt',dt,'numfibers',10,'camera','axial','tubes', 0,'radius', [.2 2],'newfig',1)
        AFQ_RenderFibers(fg,'color',[0.7 0 0],'numfibers',100,'camera','axial','tubes', 0,'radius', [.2 2],'newfig',0)
    end
    
    % if you want to show T1 image togather
    AFQ_AddImageTo3dPlot(t1, [0, 0, -15]);
    axis off
    axis image
    %         axis([10 50 -110 0 -10 40])
    %         %% if you want to save the image
    %         cd /biac4/wandell/biac3/wandell7/shumpei/matlab/git/LHON/3RP/CompareMRTandContrack
    %
    %         %        print(gcf,'-dpng',sprintf('%s_FA.png',fgF{jj}.name))
    %         %if you like the image with T1w
    %         print(gcf,'-dpng',sprintf('%s_%s_FA_onT1w_3.png',subDir{i},fgF{jj}.name))
    
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
