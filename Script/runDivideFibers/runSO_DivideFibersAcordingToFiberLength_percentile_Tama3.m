function [TractProfile] = runSO_DivideFibersAcordingToFiberLength_percentile_Tama3
%%
[homeDir,subDir,AMDC] = Tama_subj3;

%% Calculate vals along the fibers and return TP structure
fgN ={'ROR_D4L4.pdb','LOR_D4L4.pdb','ROTD4L4_1206.pdb','LOTD4L4_1206.pdb'};

%% get diffusivities based on fiber length (percentile)
for i =1:length(AMDC)
    % define directory
    SubDir = fullfile(homeDir,subDir{i});    
    OR_fgDir    = (fullfile(SubDir,'/dwi_2nd/fibers/conTrack/OR_Top100K_V1_3mm_clipped_LGN4mm'));
    OT_fgDir = fullfile(SubDir,'/dwi_2nd/fibers');
    % dt6 file
    dt  = fullfile(homeDir,subDir{i},'dwi_2nd','dt6.mat');
    dt6  = dtiLoadDt6(dt);    

    for j =1:length(fgN)
        switch j
            case {1,2}
                fg = fgRead(fullfile(OR_fgDir,fgN{j}));
            case {3,4}
                fg = fgRead(fullfile(OT_fgDir,fgN{j}));
        end                
        [TractProfile{i,j}, ~,~,~,~,~]...
            = SO_DivideFibersAcordingToFiberLength_percentile(fg,dt6,0,'AP',100);
    end
end
save TractProfile_10AMDC TractProfile
% %%
% cd /biac4/wandell/biac2/wandell/data/DWI-Tamagawa-Japan2/results
% save Tama2_Percentile TractProfile
% matlabpool close
% return
% %% Load TractProfile
% 
% cd /biac4/wandell/biac2/wandell/data/DWI-Tamagawa-Japan2/results
% 
% load Tama2_Percentile.mat
% 
% %% classify all subjects intogroups
% JMD = 1:4;
% CRD = 5:9;
% % LHON = 10:15;
% LHON = [10:14,27];
% 
% Ctl = [16:23,31:33,35:37];
% RP = [24:26,28,29,34,38,39];
% 
% fgN ={'ROR1206_D4L4.pdb','LOR1206_D4L4.pdb'};%,'ROTD4L4_1206.pdb','LOTD4L4_1206.pdb',...
% %     'ROTD3L2_1206.pdb','LOTD3L2_1206.pdb'};
% 
% % Render plots which comparing CRD ,LHON, Ctl
% % Y=nan(length(subDir),100);
% X = 1:100;
% c = lines(100);
% gray = [0.5 0.5 0.5];
% %% Render plots
% for fibID = 1:length(fgN)
%     for pctl = 1:6
%         % make one sheet diffusivities
%         for subID = 1:length(subDir);
%             if isempty(TractProfile{subID,fibID}{pctl}.nfibers);
%                 fa(subID,:) =nan(1,100);
%             else
%                 fa(subID,:) =  TractProfile{subID,fibID}{pctl}.vals.fa;
%             end;
%             
%             if isempty(TractProfile{subID,fibID}{pctl}.nfibers);
%                 md(subID,:) =nan(1,100);
%             else
%                 md(subID,:) =  TractProfile{subID,fibID}{pctl}.vals.md;
%             end;
%             
%             if isempty(TractProfile{subID,fibID}{pctl}.nfibers);
%                 rd(subID,:) =nan(1,100);
%             else
%                 rd(subID,:) =  TractProfile{subID,fibID}{pctl}.vals.rd;
%             end;
%             
%             if isempty(TractProfile{subID,fibID}{pctl}.nfibers);
%                 ad(subID,:) =nan(1,100);               
%             else
%                 ad(subID,:) =  TractProfile{subID,fibID}{pctl}.vals.ad;
%             end;
%         end
%         
%         %% fa comparison
%         figure; hold on;
%         
%         % CRD
%         plot(X,nanmean(fa(CRD,:)),'Color',c(3,:),'linewidth',2);
%         % LHON
%         plot(X,nanmean(fa(LHON,:)),'Color',rgb2cmyk([1 0 0 0]),'linewidth',2);
%         % Ctl
%         plot(X,nanmean(fa(Ctl,:)),'Color',gray,'linewidth',2);
%         % RP
%         %         plot(X,nanmean(fa(RP,:)),'Color',c(3,:),'linewidth',2);
%         %         legend('CRD','LHON','Ctl','RP');
%         %         legend('CRD','LHON','Ctl');
%         
%         title(sprintf('%s %s',fgN{fibID}(1:end-4),TractProfile{1,fibID}{pctl}.name));
%         ylabel('fa');
%         xlabel('location');
%         hold off;
%         %         %% save fig
%         %         cd /biac4/wandell/biac3/wandell7/shumpei/matlab/git/LHON/3RP/divideByLength_Plot
%         %
%         %         print(gcf,'-dpng',sprintf('%s_%s_%s','FA',fgN{fibID}(1:end-4),TractProfile{1,fibID}{pctl}.name))
%         %
%         %% md comparison
%         figure; hold on;
%         
%         % CRD
%         plot(X,nanmean(md(CRD,:)),'Color',c(3,:),'linewidth',2);
%         % LHON
%         plot(X,nanmean(md(LHON,:)),'Color',rgb2cmyk([1 0 0 0]),'linewidth',2);
%         % Ctl
%         plot(X,nanmean(md(Ctl,:)),'Color',gray,'linewidth',2);
%         % RP
%         %         plot(X,nanmean(ad(RP,:)),'Color',c(3,:),'linewidth',2);
%         %         legend('CRD','LHON','Ctl','RP');
%         %         legend('CRD','LHON','Ctl');
%         
%         title(sprintf('%s %s',fgN{fibID}(1:end-4),TractProfile{1,fibID}{pctl}.name));
%         ylabel('ad');
%         xlabel('location');
%         hold off;
%         %         %% save fig
%         %
%         %         print(gcf,'-dpng',sprintf('%s_%s_%s','AD',fgN{fibID}(1:end-4),TractProfile{1,fibID}{pctl}.name))
%         
%         %% ad comparison
%         figure; hold on;
%         
%         % CRD
%         plot(X,nanmean(ad(CRD,:)),'Color',c(3,:),'linewidth',2);
%         % LHON
%         plot(X,nanmean(ad(LHON,:)),'Color',rgb2cmyk([1 0 0 0]),'linewidth',2);
%         % Ctl
%         plot(X,nanmean(ad(Ctl,:)),'Color',gray,'linewidth',2);
%         % RP
%         %         plot(X,nanmean(ad(RP,:)),'Color',c(3,:),'linewidth',2);
%         %         legend('CRD','LHON','Ctl','RP');
%         %         legend('CRD','LHON','Ctl');
%         
%         title(sprintf('%s %s',fgN{fibID}(1:end-4),TractProfile{1,fibID}{pctl}.name));
%         ylabel('ad');
%         xlabel('location');
%         hold off;
%         %         %% save fig
%         %
%         %         print(gcf,'-dpng',sprintf('%s_%s_%s','AD',fgN{fibID}(1:end-4),TractProfile{1,fibID}{pctl}.name))
%         
%         %% rd comparison
%         figure; hold on;
%         
%         % CRD
%         plot(X,nanmean(rd(CRD,:)),'Color',c(3,:),'linewidth',2);
%         % LHON
%         plot(X,nanmean(rd(LHON,:)),'Color',rgb2cmyk([1 0 0 0]),'linewidth',2);
%         % Ctl
%         plot(X,nanmean(rd(Ctl,:)),'Color',gray,'linewidth',2);
%         % RP
%         %         plot(X,nanmean(rd(RP,:)),'Color',c(3,:),'linewidth',2);
%         %         legend('CRD','LHON','Ctl','RP');
%         %         legend('CRD','LHON','Ctl');
%         
%         title(sprintf('%s %s',fgN{fibID}(1:end-4),TractProfile{1,fibID}{pctl}.name));
%         ylabel('rd');
%         xlabel('location');
%         hold off;
%         %          %% save fig
%         %
%         %         print(gcf,'-dpng',sprintf('%s_%s_%s','RD',fgN{fibID}(1:end-4),TractProfile{1,fibID}{pctl}.name))
%         
%     end
%     %     close all
% end
% 
% 
% %% drow errorbar plots merge both L and R tract
% for fibID = 1 %ROR
%     for pctl = 1:6
%         % make one sheet diffusivities
%         for subID = 1:length(subDir);
%             if isempty(TractProfile{subID,fibID}{pctl}.nfibers);
%                 fa(subID,:) =nan(1,100);
%             else
%                 fa(subID,:) =  mean([TractProfile{subID,fibID}{pctl}.vals.fa;...
%                     TractProfile{subID,fibID+1}{pctl}.vals.fa]);
%             end;
%             
%             if isempty(TractProfile{subID,fibID}{pctl}.nfibers);
%                 md(subID,:) =nan(1,100);
%             else
%                 md(subID,:) = mean([ TractProfile{subID,fibID}{pctl}.vals.md;...
%                     TractProfile{subID,fibID+1}{pctl}.vals.md]);
%             end;
%             
%             if isempty(TractProfile{subID,fibID}{pctl}.nfibers);
%                 rd(subID,:) =nan(1,100);
%             else
%                 rd(subID,:) = mean([ TractProfile{subID,fibID}{pctl}.vals.rd;...
%                     TractProfile{subID,fibID+1}{pctl}.vals.rd]);
%             end;
%             
%             if isempty(TractProfile{subID,fibID}{pctl}.nfibers);
%                 ad(subID,:) =nan(1,100);
%             else
%                 ad(subID,:) = mean([ TractProfile{subID,fibID}{pctl}.vals.ad;...
%                     TractProfile{subID,fibID+1}{pctl}.vals.ad]);
%             end;
%         end
%         
%         %% fa comparison
%         %         figure; hold on;
%         % Create axes
%         axes1 = axes('Parent',figure,'YTick',[0.15 0.65],...
%             'XTick',[0 50 100]);
%         xlim(axes1,[0 100]);
%         hold(axes1,'all');
%         
%         % Render errorbar(S.E.M) of three groups
%         % CRD
%         sem = nanstd(fa(CRD,:))/sqrt(size(fa(CRD,:),1));
%         errorbar(X,nanmean(fa(CRD,:)),sem,'Color',c(3,:),...
%             'linewidth',1);
%         % LHON
%         sem = nanstd(fa(LHON,:))/sqrt(size(fa(LHON,:),1));
%         errorbar(X,nanmean(fa(LHON,:)),sem,'Color',rgb2cmyk([1 0 0 0]),...
%             'linewidth',1);
%         % Control
%         sem = nanstd(fa(Ctl,:))/sqrt(size(fa(Ctl,:),1));
%         errorbar(X,nanmean(fa(Ctl,:)),sem,'Color',gray,...
%             'linewidth',1);
%         
%         %         title(sprintf('%s %s',fgN{fibID}(1:end-4),TractProfile{1,fibID}{pctl}.name)...
%         %             ,'FontName','Times','FontSize',16);
%         ylabel('Fractional anisotropy','FontName','Times','FontSize',16);
%         xlabel('Location','FontName','Times','FontSize',16);
%         hold off;
%         %% save fig
%         cd /biac4/wandell/biac2/wandell/data/DWI-Tamagawa-Japan2/results/Percentile_Tama2
%         
%         print(gcf,'-depsc2',sprintf('%s_%s_%s','FA',fgN{fibID}(1:end-4),TractProfile{1,fibID}{pctl}.name))
%         
%         %% md comparison
%         %         figure; hold on;
%         % Create axes
%         axes1 = axes('Parent',figure,'YTick',[0.65 1],...
%             'XTick',[0 50 100]);
%         xlim(axes1,[0 100]);
%         hold(axes1,'all');
%         
%         %% Render errorbar(S.E.M) of three groups
%         % CRD
%         sem = nanstd(md(CRD,:))/sqrt(size(md(CRD,:),1));
%         errorbar(X,nanmean(md(CRD,:)),sem,'Color',c(3,:),...
%             'linewidth',1);
%         % LHON
%         sem = nanstd(md(LHON,:))/sqrt(size(md(LHON,:),1));
%         errorbar(X,nanmean(md(LHON,:)),sem,'Color',rgb2cmyk([1 0 0 0]),...
%             'linewidth',1);
%         % Control
%         sem = nanstd(md(Ctl,:))/sqrt(size(md(Ctl,:),1));
%         errorbar(X,nanmean(md(Ctl,:)),sem,'Color',gray,...
%             'linewidth',1);
%         
%         %         title(sprintf('%s %s',fgN{fibID}(1:end-4),TractProfile{1,fibID}{pctl}.name)...
%         %             ,'FontName','Times','FontSize',16);
%         ylabel('Mean diffusivity','FontName','Times','FontSize',16);
%         xlabel('Location','FontName','Times','FontSize',16);
%         hold off;
%         
%         %% save fig
%         print(gcf,'-depsc2',sprintf('%s_%s_%s','MD',fgN{fibID}(1:end-4),TractProfile{1,fibID+1}{pctl}.name))
%         
%         
%         
%         %% ad comparison
%         %         figure; hold on;
%         % Create axes
%         axes1 = axes('Parent',figure,'YTick',[0.9 1.6],...
%             'XTick',[0 50 100]);
%         xlim(axes1,[0 100]);
%         hold(axes1,'all');
%         
%         %% Render errorbar(S.E.M) of three groups
%         % CRD
%         sem = nanstd(ad(CRD,:))/sqrt(size(ad(CRD,:),1));
%         errorbar(X,nanmean(ad(CRD,:)),sem,'Color',c(3,:),...
%             'linewidth',1);
%         % LHON
%         sem = nanstd(ad(LHON,:))/sqrt(size(ad(LHON,:),1));
%         errorbar(X,nanmean(ad(LHON,:)),sem,'Color',rgb2cmyk([1 0 0 0]),...
%             'linewidth',1);
%         % Control
%         sem = nanstd(ad(Ctl,:))/sqrt(size(ad(Ctl,:),1));
%         errorbar(X,nanmean(ad(Ctl,:)),sem,'Color',gray,...
%             'linewidth',1);
%         
%         %         title(sprintf('%s %s',fgN{fibID}(1:end-4),TractProfile{1,fibID}{pctl}.name)...
%         %             ,'FontName','Times','FontSize',16);
%         ylabel('Axial diffusivity','FontName','Times','FontSize',16);
%         xlabel('Location','FontName','Times','FontSize',16);
%         hold off;
%         %% save fig
%         print(gcf,'-depsc2',sprintf('%s_%s_%s','AD',fgN{fibID}(1:end-4),TractProfile{1,fibID+1}{pctl}.name))
%         
%         
%         %% rd comparison
%         %         figure; hold on;
%         % Create axes
%         axes1 = axes('Parent',figure,'YTick',[0.2 0.4 0.6],...
%             'XTick',[0 50 100]);
%         set(axes1,'YTick',[0.4 0.9])
%         
%         xlim(axes1,[0 100]);
%         hold(axes1,'all');
%         
%         %% Render errorbar(S.E.M) of three groups
%         % CRD
%         sem = nanstd(rd(CRD,:))/sqrt(size(rd(CRD,:),1));
%         errorbar(X,nanmean(rd(CRD,:)),sem,'Color',c(3,:),...
%             'linewidth',1);
%         % LHON
%         sem = nanstd(rd(LHON,:))/sqrt(size(rd(LHON,:),1));
%         errorbar(X,nanmean(rd(LHON,:)),sem,'Color',rgb2cmyk([1 0 0 0]),...
%             'linewidth',1);
%         % Control
%         sem = nanstd(rd(Ctl,:))/sqrt(size(rd(Ctl,:),1));
%         errorbar(X,nanmean(rd(Ctl,:)),sem,'Color',gray,...
%             'linewidth',1);
%         
%         %         title(sprintf('%s %s',fgN{fibID}(1:end-4),TractProfile{1,fibID}{pctl}.name)...
%         %             ,'FontName','Times','FontSize',16);
%         ylabel('Radial diffusivity','FontName','Times','FontSize',16);
%         xlabel('Location','FontName','Times','FontSize',16);
%         hold off;
%         
%         %% save fig
%         print(gcf,'-depsc2',sprintf('%s_%s_%s','RD',fgN{fibID}(1:end-4),TractProfile{1,fibID+1}{pctl}.name))
%         
%     end
% end
% cd /biac4/wandell/biac2/wandell/data/DWI-Tamagawa-Japan2/results/Percentile_Tama2
% 
% return
% 
% 
% 
% %% Standard Diviation drow errorbar plots merge both L and R tract
% for fibID = 1 %ROR
%     for pctl = 1:6
%         % make one sheet diffusivities
%         for subID = 1:length(subDir);
%             if isempty(TractProfile{subID,fibID}{pctl}.nfibers);
%                 fa(subID,:) =nan(1,100);
%             else
%                 fa(subID,:) =  mean([TractProfile{subID,fibID}{pctl}.vals.fa;...
%                     TractProfile{subID,fibID+1}{pctl}.vals.fa]);
%             end;
%             
%             if isempty(TractProfile{subID,fibID}{pctl}.nfibers);
%                 md(subID,:) =nan(1,100);
%             else
%                 md(subID,:) = mean([ TractProfile{subID,fibID}{pctl}.vals.md;...
%                     TractProfile{subID,fibID+1}{pctl}.vals.md]);
%             end;
%             
%             if isempty(TractProfile{subID,fibID}{pctl}.nfibers);
%                 rd(subID,:) =nan(1,100);
%             else
%                 rd(subID,:) = mean([ TractProfile{subID,fibID}{pctl}.vals.rd;...
%                     TractProfile{subID,fibID+1}{pctl}.vals.rd]);
%             end;
%             
%             if isempty(TractProfile{subID,fibID}{pctl}.nfibers);
%                 ad(subID,:) =nan(1,100);
%             else
%                 ad(subID,:) = mean([ TractProfile{subID,fibID}{pctl}.vals.ad;...
%                     TractProfile{subID,fibID+1}{pctl}.vals.ad]);
%             end;
%         end
%         
%         %% fa comparison
%         %         figure; hold on;
%         % Create axes
%         axes1 = axes('Parent',figure,'YTick',[0.15 0.65],...
%             'XTick',[0 50 100]);
%         xlim(axes1,[0 100]);
%         hold(axes1,'all');
%         
%         %%
%         sem = nanstd(fa(Ctl,:))/sqrt(size(fa(Ctl,:),1));
%         m = nanmean(fa(Ctl,:));
%         mp = sem+m;
%         mm = m - sem;
%         mp2 = 2*sem+m;
%         mm2 = m - 2*sem;
%         
%         h(1) =area(mp2);
%         h(2) =area(mp);
%         h(3) =area(mm);
%         h(4) =area(mm2);
%         [0.2 0.2 0.2]
%         
%         set(h(2),'FaceColor',[0.8 0.8 0.8]);
%         
%         set(h(1),'FaceColor',[0.9 0.9 0.9]);
%         set(h(3),'FaceColor',[0.9 0.9 0.9]);
%         set(h(4),'FaceColor',[1 1 1]);
%         
%         
%         
%         set(h(1),'EdgeColor',[1 1 1]);
%         set(h(2),'EdgeColor',[1 1 1]);
%         set(h(3),'EdgeColor',[1 1 1]);
%         set(h(4),'EdgeColor',[1 1 1]);
%         
%         
%         % Render errorbar(S.E.M) of three groups
%         % CRD
%         %         sem = nanstd(fa(CRD,:))/sqrt(size(fa(CRD,:),1));
%         errorbar2(X,nanmean(fa(CRD,:)),nanstd(fa(CRD,:)),1,'Color',c(3,:),...
%             'linewidth',1);
%         scatter(X,nanmean(fa(CRD,:)),40,c(3,:),'fill')
%         % LHON
%         %         sem = nanstd(fa(LHON,:))/sqrt(size(fa(LHON,:),1));
%         errorbar2(X,nanmean(fa(LHON,:)),nanstd(fa(LHON,:)),1,'Color',rgb2cmyk([1 0 0 0]),...
%             'linewidth',1);
%         scatter(X,nanmean(fa(LHON,:)),40,rgb2cmyk([1 0 0 0]),'fill')
%         
%         
%         % Control
%         %         sem = nanstd(fa(Ctl,:))/sqrt(size(fa(Ctl,:),1));
%         errorbar(X,nanmean(fa(Ctl,:)),nanstd(fa(Ctl,:)),'Color',gray,...
%             'linewidth',2);
%         
%         %         title(sprintf('%s %s',fgN{fibID}(1:end-4),TractProfile{1,fibID}{pctl}.name)...
%         %             ,'FontName','Times','FontSize',16);
%         ylabel('Fractional anisotropy','FontName','Times','FontSize',16);
%         xlabel('Location','FontName','Times','FontSize',16);
%         hold off;
%         %% save fig
%         cd /biac4/wandell/biac3/wandell7/shumpei/matlab/git/LHON/3RP/Figure3/Percentile_SD
%         
%         print(gcf,'-depsc2',sprintf('%s_%s_%s','FA',fgN{fibID}(1:end-4),TractProfile{1,fibID}{pctl}.name))
%         
%         %% md comparison
%         %         figure; hold on;
%         % Create axes
%         axes1 = axes('Parent',figure,'YTick',[0.65 1],...
%             'XTick',[0 50 100]);
%         xlim(axes1,[0 100]);
%         hold(axes1,'all');
%         
%         %% Render errorbar(S.E.M) of three groups
%         % CRD
%         %         sem = nanstd(md(CRD,:))/sqrt(size(md(CRD,:),1));
%         errorbar(X,nanmean(md(CRD,:)),nanstd(md(CRD,:)),'Color',c(3,:),...
%             'linewidth',2);
%         % LHON
%         %         sem = nanstd(md(LHON,:))/sqrt(size(md(LHON,:),1));
%         errorbar(X,nanmean(md(LHON,:)),nanstd(md(LHON,:)),'Color',rgb2cmyk([1 0 0 0]),...
%             'linewidth',2);
%         % Control
%         %         sem = nanstd(md(Ctl,:))/sqrt(size(md(Ctl,:),1));
%         errorbar(X,nanmean(md(Ctl,:)),nanstd(md(Ctl,:)),'Color',gray,...
%             'linewidth',2);
%         
%         %         title(sprintf('%s %s',fgN{fibID}(1:end-4),TractProfile{1,fibID}{pctl}.name)...
%         %             ,'FontName','Times','FontSize',16);
%         ylabel('Mean diffusivity','FontName','Times','FontSize',16);
%         xlabel('Location','FontName','Times','FontSize',16);
%         hold off;
%         
%         %% save fig
%         print(gcf,'-depsc2',sprintf('%s_%s_%s','MD',fgN{fibID}(1:end-4),TractProfile{1,fibID}{pctl}.name))
%         
%         
%         
%         %% ad comparison
%         %         figure; hold on;
%         % Create axes
%         axes1 = axes('Parent',figure,'YTick',[0.9 1.6],...
%             'XTick',[0 50 100]);
%         xlim(axes1,[0 100]);
%         hold(axes1,'all');
%         
%         %% Render errorbar(S.E.M) of three groups
%         % CRD
%         %         sem = nanstd(ad(CRD,:))/sqrt(size(ad(CRD,:),1));
%         errorbar(X,nanmean(ad(CRD,:)),nanstd(ad(CRD,:)),'Color',c(3,:),...
%             'linewidth',2);
%         % LHON
%         %         sem = nanstd(ad(LHON,:))/sqrt(size(ad(LHON,:),1));
%         errorbar(X,nanmean(ad(LHON,:)),nanstd(ad(LHON,:)),'Color',rgb2cmyk([1 0 0 0]),...
%             'linewidth',2);
%         % Control
%         %         sem = nanstd(ad(Ctl,:))/sqrt(size(ad(Ctl,:),1));
%         errorbar(X,nanmean(ad(Ctl,:)),nanstd(ad(Ctl,:)),'Color',gray,...
%             'linewidth',2);
%         
%         %         title(sprintf('%s %s',fgN{fibID}(1:end-4),TractProfile{1,fibID}{pctl}.name)...
%         %             ,'FontName','Times','FontSize',16);
%         ylabel('Axial diffusivity','FontName','Times','FontSize',16);
%         xlabel('Location','FontName','Times','FontSize',16);
%         hold off;
%         %% save fig
%         print(gcf,'-depsc2',sprintf('%s_%s_%s','AD',fgN{fibID}(1:end-4),TractProfile{1,fibID}{pctl}.name))
%         
%         
%         %% rd comparison
%         %         figure; hold on;
%         % Create axes
%         axes1 = axes('Parent',figure,'YTick',[0.2 0.4 0.6],...
%             'XTick',[0 50 100]);
%         set(axes1,'YTick',[0.4 0.9])
%         
%         xlim(axes1,[0 100]);
%         hold(axes1,'all');
%         
%         %% Render errorbar(S.E.M) of three groups
%         % CRD
%         sem = nanstd(rd(CRD,:))/sqrt(size(rd(CRD,:),1));
%         errorbar(X,nanmean(rd(CRD,:)),nanstd(rd(CRD,:)),'Color',c(3,:),...
%             'linewidth',2);
%         % LHON
%         %         sem = nanstd(rd(LHON,:))/sqrt(size(rd(LHON,:),1));
%         errorbar(X,nanmean(rd(LHON,:)),nanstd(rd(LHON,:)),'Color',rgb2cmyk([1 0 0 0]),...
%             'linewidth',2);
%         % Control
%         %         sem = nanstd(rd(Ctl,:))/sqrt(size(rd(Ctl,:),1));
%         errorbar(X,nanmean(rd(Ctl,:)),nanstd(rd(Ctl,:)),'Color',gray,...
%             'linewidth',2);
%         
%         %         title(sprintf('%s %s',fgN{fibID}(1:end-4),TractProfile{1,fibID}{pctl}.name)...
%         %             ,'FontName','Times','FontSize',16);
%         ylabel('Radial diffusivity','FontName','Times','FontSize',16);
%         xlabel('Location','FontName','Times','FontSize',16);
%         hold off;
%         
%         %% save fig
%         print(gcf,'-depsc2',sprintf('%s_%s_%s','RD',fgN{fibID}(1:end-4),TractProfile{1,fibID}{pctl}.name))
%         
%     end
% end
% cd /biac4/wandell/biac3/wandell7/shumpei/matlab/git/LHON/3RP
% return
% 
% 
% 
% 
% %% render CRD, LHON ,Ctl, RP
% % Y=nan(length(subDir),100);
% X = 1:100;
% c = lines(100);
% gray = [0.5 0.5 0.5];
% 
% for fibID =1%:6 %ROR
%     for pctl = 2
%         
%         for subID = 1:length(subDir);
%             if isempty(TractProfile{subID,fibID}{pctl}.nfibers);
%                 fa(subID,:) =nan(1,100);
%             else
%                 fa(subID,:) =  TractProfile{subID,fibID}{pctl}.vals.fa;
%             end;
%             
%             if isempty(TractProfile{subID,fibID}{pctl}.nfibers);
%                 md(subID,:) =nan(1,100);
%             else
%                 md(subID,:) =  TractProfile{subID,fibID}{pctl}.vals.md;
%             end;
%             
%             if isempty(TractProfile{subID,fibID}{pctl}.nfibers);
%                 rd(subID,:) =nan(1,100);
%             else
%                 rd(subID,:) =  TractProfile{subID,fibID}{pctl}.vals.rd;
%             end;
%             
%             if isempty(TractProfile{subID,fibID}{pctl}.nfibers);
%                 ad(subID,:) =nan(1,100);
%             else
%                 ad(subID,:) =  TractProfile{subID,fibID}{pctl}.vals.ad;
%             end;
%         end
%         
%         %% fa comparison
%         figure; hold on;
%         
%         % CRD
%         plot(X,nanmean(fa(CRD,:)),'Color',c(1,:),'linewidth',2);
%         % LHON
%         plot(X,nanmean(fa(LHON,:)),'Color',c(2,:),'linewidth',2);
%         % Ctl
%         plot(X,nanmean(fa(Ctl,:)),'Color',gray,'linewidth',2);
%         % RP
%         plot(X,nanmean(fa(RP,:)),'Color',c(3,:),'linewidth',2);
%         legend('CRD','LHON','Ctl','RP');
%         
%         %         title(sprintf('%s %s',fgN{fibID}(1:end-4),TractProfile{1,fibID}{pctl}.name));
%         ylabel('fa');
%         xlabel('location');
%         hold off;
%         %         %% save fig
%         %         cd /biac4/wandell/biac3/wandell7/shumpei/matlab/git/LHON/3RP/divideByLength_Plot
%         %
%         %         print(gcf,'-dpng',sprintf('%s_%s_%s','FA',fgN{fibID}(1:end-4),TractProfile{1,fibID}{pctl}.name))
%         %
%         %% ad comparison
%         figure; hold on;
%         
%         % CRD
%         plot(X,nanmean(ad(CRD,:)),'Color',c(1,:),'linewidth',2);
%         % LHON
%         plot(X,nanmean(ad(LHON,:)),'Color',c(2,:),'linewidth',2);
%         % Ctl
%         plot(X,nanmean(ad(Ctl,:)),'Color',gray,'linewidth',2);
%         % RP
%         plot(X,nanmean(ad(RP,:)),'Color',c(3,:),'linewidth',2);
%         legend('CRD','LHON','Ctl','RP');
%         
%         %         title(sprintf('%s %s',fgN{fibID}(1:end-4),TractProfile{1,fibID}{pctl}.name));
%         ylabel('ad');
%         xlabel('location');
%         hold off;
%         %         %% save fig
%         %
%         %         print(gcf,'-dpng',sprintf('%s_%s_%s','AD',fgN{fibID}(1:end-4),TractProfile{1,fibID}{pctl}.name))
%         
%         %% rd comparison
%         figure; hold on;
%         
%         % CRD
%         plot(X,nanmean(rd(CRD,:)),'Color',c(1,:),'linewidth',2);
%         % LHON
%         plot(X,nanmean(rd(LHON,:)),'Color',c(2,:),'linewidth',2);
%         % Ctl
%         plot(X,nanmean(rd(Ctl,:)),'Color',gray,'linewidth',2);
%         % RP
%         plot(X,nanmean(rd(RP,:)),'Color',c(3,:),'linewidth',2);
%         legend('CRD','LHON','Ctl','RP');
%         
%         %         title(sprintf('%s %s',fgN{fibID}(1:end-4),TractProfile{1,fibID}{pctl}.name));
%         ylabel('rd');
%         xlabel('location');
%         hold off;
%         %          %% save fig
%         %
%         %         print(gcf,'-dpng',sprintf('%s_%s_%s','RD',fgN{fibID}(1:end-4),TractProfile{1,fibID}{pctl}.name))
%         
%     end
% end
% 
% 
% 
% %% boxplots merge both L and R tract
% for fibID = 1%4:6 %ROR
%     for pctl = 2:6
%         % make one sheet diffusivities
%         for subID = 1:length(subDir);
%             if isempty(TractProfile{subID,fibID}{pctl}.nfibers);
%                 fa(subID,:) =nan(1,100);
%             else
%                 fa(subID,:) =  mean([TractProfile{subID,fibID}{pctl}.vals.fa;...
%                     TractProfile{subID,fibID+1}{pctl}.vals.fa]);
%             end;
%             
%             if isempty(TractProfile{subID,fibID}{pctl}.nfibers);
%                 md(subID,:) =nan(1,100);
%             else
%                 md(subID,:) = mean([ TractProfile{subID,fibID}{pctl}.vals.md;...
%                     TractProfile{subID,fibID+1}{pctl}.vals.md]);
%             end;
%             
%             if isempty(TractProfile{subID,fibID}{pctl}.nfibers);
%                 rd(subID,:) =nan(1,100);
%             else
%                 rd(subID,:) = mean([ TractProfile{subID,fibID}{pctl}.vals.rd;...
%                     TractProfile{subID,fibID+1}{pctl}.vals.rd]);
%             end;
%             
%             if isempty(TractProfile{subID,fibID}{pctl}.nfibers);
%                 ad(subID,:) =nan(1,100);
%             else
%                 ad(subID,:) = mean([ TractProfile{subID,fibID}{pctl}.vals.ad;...
%                     TractProfile{subID,fibID+1}{pctl}.vals.ad]);
%             end;
%         end
%         
%         
%         %% box
%         figure; hold on;
%         boxplot([nanmean(fa(LHON,:))',nanmean(fa(CRD,:))',nanmean(fa(Ctl,:))'],'notch','on')
%         
%         
%         ylabel('Fractional anisotropy','FontName','Times','FontSize',16);
%         xlabel('group','FontName','Times','FontSize',16);
%         %                 %% save fig
%         %                 cd /biac4/wandell/biac3/wandell7/shumpei/matlab/git/LHON/3RP/Figure3/
%         %
%         %                 print(gcf,'-depsc2',sprintf('%s_%s_%s','FA',fgN{fibID}(1:end-4),TractProfile{1,fibID}{pctl}.name))
%         hold off;
%         
%     end
% end
% 
% return
% 
% 
% 
% 
% % close all
% 
% %% LHON6 longtudinal
% % Y=nan(length(subDir),100);
% X = 1:100;
% c = lines(100);
% gray = [0.5 0.5 0.5];
% 
% for fibID =1%:6 %ROR
%     for pctl = 1:7
%         
%         for subID =1:length(subDir);
%             if isempty(TractProfile{subID,fibID}{pctl}.nfibers);
%                 fa(subID,:) =nan(1,100);
%             else
%                 fa(subID,:) =  TractProfile{subID,fibID}{pctl}.vals.fa;
%             end;
%             
%             if isempty(TractProfile{subID,fibID}{pctl}.nfibers);
%                 md(subID,:) =nan(1,100);
%             else
%                 md(subID,:) =  TractProfile{subID,fibID}{pctl}.vals.md;
%             end;
%             
%             if isempty(TractProfile{subID,fibID}{pctl}.nfibers);
%                 rd(subID,:) =nan(1,100);
%             else
%                 rd(subID,:) =  TractProfile{subID,fibID}{pctl}.vals.rd;
%             end;
%             
%             if isempty(TractProfile{subID,fibID}{pctl}.nfibers);
%                 ad(subID,:) =nan(1,100);
%             else
%                 ad(subID,:) =  TractProfile{subID,fibID}{pctl}.vals.ad;
%             end;
%         end
%         
%         %% fa comparison
%         figure; hold on;
%         
%         % LHON6 longtudinal
%         plot(X,fa(15,:),'Color',c(3,:),'linewidth',2);
%         plot(X,fa(27,:),'Color',rgb2cmyk([1 0 0 0]),'linewidth',2);
%         
%         legend('LHON6 previous','LHON6 present');
%         
%         title(sprintf('%s %s',fgN{fibID}(1:end-4),TractProfile{1,fibID}{pctl}.name));
%         ylabel('fa');
%         xlabel('location');
%         hold off;
%         %% save fig
%         cd '/biac4/wandell/biac3/wandell7/shumpei/matlab/git/LHON/3RP/LHON6 longtudinal'
%         
%         print(gcf,'-dpng',sprintf('LHON6_logntudinal%s_%s_%s','FA',fgN{fibID}(1:end-4),TractProfile{1,fibID}{pctl}.name))
%         %
%         %% ad comparison
%         figure; hold on;
%         
%         % LHON6 longtudinal
%         plot(X,ad(15,:),'Color',c(3,:),'linewidth',2);
%         plot(X,ad(27,:),'Color',rgb2cmyk([1 0 0 0]),'linewidth',2);
%         
%         legend('LHON6 previous','LHON6 present');
%         
%         title(sprintf('%s %s',fgN{fibID}(1:end-4),TractProfile{1,fibID}{pctl}.name));
%         ylabel('ad');
%         xlabel('location');
%         hold off;
%         %% save fig
%         
%         print(gcf,'-dpng',sprintf('LHON6_logntudinal%s_%s_%s','AD',fgN{fibID}(1:end-4),TractProfile{1,fibID}{pctl}.name))
%         
%         %% rd comparison
%         figure; hold on;
%         
%         % LHON6 longtudinal
%         plot(X,rd(15,:),'Color',c(3,:),'linewidth',2);
%         plot(X,rd(27,:),'Color',rgb2cmyk([1 0 0 0]),'linewidth',2);
%         
%         legend('LHON6 previous','LHON6 present');
%         
%         title(sprintf('%s %s',fgN{fibID}(1:end-4),TractProfile{1,fibID}{pctl}.name));
%         ylabel('rd');
%         xlabel('location');
%         hold off;
%         %% save fig
%         
%         print(gcf,'-dpng',sprintf('LHON6_logntudinal%s_%s_%s','RD',fgN{fibID}(1:end-4),TractProfile{1,fibID}{pctl}.name))
%         
%         %% md comparison
%         figure; hold on;
%         
%         % LHON6 longtudinal
%         plot(X,md(15,:),'Color',c(3,:),'linewidth',2);
%         plot(X,md(27,:),'Color',rgb2cmyk([1 0 0 0]),'linewidth',2);
%         
%         legend('LHON6 previous','LHON6 present');
%         
%         title(sprintf('%s %s',fgN{fibID}(1:end-4),TractProfile{1,fibID}{pctl}.name));
%         ylabel('md');%% add S.E.M
%         sem = nanstd(fa(CRD,:))/sqrt(size(fa(CRD,:),1));
%         % render S.E.M.
%         figure; hold on;
%         
%         plot(X,nanmean(fa(CRD,:))+sem,'Color',c(1,:),...
%             'linewidth',1, 'linestyle','--');
%         plot(X,nanmean(fa(CRD,:))-sem,'Color',c(1,:),...
%             'linewidth',1, 'linestyle','--');
%         
%         sem = nanstd(fa(LHON,:))/sqrt(size(fa(LHON,:),1));
%         % SEM
%         plot(X,nanmean(fa(LHON,:))+sem,'Color',c(1,:),...
%             'linewidth',1, 'linestyle','--');
%         plot(X,nanmean(fa(LHON,:))-sem,'Color',c(1,:),...
%             'linewidth',1, 'linestyle','--');
%         
%         sem = nanstd(fa(Ctl,:))/sqrt(size(fa(Ctl,:),1));
%         % SEM
%         plot(X,nanmean(fa(Ctl,:))+sem,'Color',c(1,:),...
%             'linewidth',1, 'linestyle','--');%% add S.E.M
%         sem = nanstd(fa(CRD,:))/sqrt(size(fa(CRD,:),1));
%         % render S.E.M.
%         figure; hold on;
%         
%         plot(X,nanmean(fa(CRD,:))+sem,'Color',c(1,:),...
%             'linewidth',1, 'linestyle','--');
%         plot(X,nanmean(fa(CRD,:))-sem,'Color',c(1,:),...
%             'linewidth',1, 'linestyle','--');
%         
%         sem = nanstd(fa(LHON,:))/sqrt(size(fa(LHON,:),1));
%         % SEM
%         plot(X,nanmean(fa(LHON,:))+sem,'Color',c(1,:),...
%             'linewidth',1, 'linestyle','--');
%         plot(X,nanmean(fa(LHON,:))-sem,'Color',c(1,:),...
%             'linewidth',1, 'linestyle','--');
%         
%         sem = nanstd(fa(Ctl,:))/sqrt(size(fa(Ctl,:),1));
%         % SEM
%         plot(X,nanmean(fa(Ctl,:))+sem,'Color',c(1,:),...
%             'linewidth',1, 'linestyle','--');
%         plot(X,nanmean(fa(Ctl,:))-sem,'Color',c(1,:),...
%             'linewidth',1, 'linestyle','--');
%         
%         sem = nanstd(fa(RP,:))/sqrt(size(fa(RP,:),1));
%         % SEM
%         plot(X,nanmean(fa(RP,:))+sem,'Color',c(1,:),...
%             'linewidth',1, 'linestyle','--');
%         plot(X,nanmean(fa(RP,:))-sem,'Color',c(1,:),...
%             'linewidth',1, 'linestyle','--');
%         
%         plot(X,nanmean(fa(Ctl,:))-sem,'Color',c(1,:),...
%             'linewidth',1, 'linestyle','--');
%         
%         sem = nanstd(fa(RP,:))/sqrt(size(fa(RP,:),1));
%         % SEM
%         plot(X,nanmean(fa(RP,:))+sem,'Color',c(1,:),...
%             'linewidth',1, 'linestyle','--');
%         plot(X,nanmean(fa(RP,:))-sem,'Color',c(1,:),...
%             'linewidth',1, 'linestyle','--');
%         
%         xlabel('location');
%         hold off;
%         %% save fig
%         
%         print(gcf,'-dpng',sprintf('LHON6_logntudinal%s_%s_%s','MD',fgN{fibID}(1:end-4),TractProfile{1,fibID}{pctl}.name))
%         
%     end
% end
% 
% close all
% return
% 
% %% add S.E.M
% sem = nanstd(fa(CRD,:))/sqrt(size(fa(CRD,:),1));
% % render S.E.M.
% figure; hold on;
% 
% plot(X,nanmean(fa(CRD,:))+sem,'Color',c(1,:),...
%     'linewidth',1, 'linestyle','--');
% plot(X,nanmean(fa(CRD,:))-sem,'Color',c(1,:),...
%     'linewidth',1, 'linestyle','--');
% 
% sem = nanstd(fa(LHON,:))/sqrt(size(fa(LHON,:),1));
% % SEM
% plot(X,nanmean(fa(LHON,:))+sem,'Color',c(1,:),...
%     'linewidth',1, 'linestyle','--');
% plot(X,nanmean(fa(LHON,:))-sem,'Color',c(1,:),...
%     'linewidth',1, 'linestyle','--');
% 
% sem = nanstd(fa(Ctl,:))/sqrt(size(fa(Ctl,:),1));
% % SEM
% plot(X,nanmean(fa(Ctl,:))+sem,'Color',c(1,:),...
%     'linewidth',1, 'linestyle','--');
% plot(X,nanmean(fa(Ctl,:))-sem,'Color',c(1,:),...
%     'linewidth',1, 'linestyle','--');
% 
% sem = nanstd(fa(RP,:))/sqrt(size(fa(RP,:),1));
% % SEM
% plot(X,nanmean(fa(RP,:))+sem,'Color',c(1,:),...
%     'linewidth',1, 'linestyle','--');
% plot(X,nanmean(fa(RP,:))-sem,'Color',c(1,:),...
%     'linewidth',1, 'linestyle','--');
% 
% %% scatter plot
% figure; hold on;
% c= lines(100);
% % JMD1
% scatter(TractProfile{1,1}{1,1}.vals.ad(1,50:90),TractProfile{1,1}{1,1}.vals.rd(1,50:90),50,c(3,:));
% scatter(TractProfile{10,1}{1,1}.vals.ad(1,50:90),TractProfile{1,1}{1,1}.vals.rd(1,50:90),50,c(1,:));
% scatter(TractProfile{23,1}{1,1}.vals.ad(1,50:90),TractProfile{1,1}{1,1}.vals.rd(1,50:90),50,[0.5,0.5,0.5]);
% 
% xlabel('AD','fontName','Times','fontSize',14);
% ylabel('RD','fontName','Times','fontSize',14);
% title('ROR cont','fontName','Times','fontSize',14)
% 
% %% scatter plot
% figure; hold on;
% c= lines(100);
% % JMD1
% scatter(TractProfile{1,2}{1,1}.vals.ad,TractProfile{1,2}{1,1}.vals.rd,50,c(3,:));
% scatter(TractProfile{10,2}{1,1}.vals.ad,TractProfile{1,2}{1,1}.vals.rd,50,c(1,:));
% scatter(TractProfile{23,2}{1,1}.vals.ad,TractProfile{1,2}{1,1}.vals.rd,50,[0.5,0.5,0.5]);
% 
% xlabel('AD','fontName','Times','fontSize',14);
% ylabel('RD','fontName','Times','fontSize',14);
% title('ROR MRT','fontName','Times','fontSize',14)
% 
% 
% 
% %% one way anova
% 
% fibID =1%, 3]%ROR
% for pctl = 2:6
%     %% make one sheet diffusivities
%     for subID = 1:length(subDir);
%         if isempty(TractProfile{subID,fibID}{pctl}.nfibers);
%             fa(subID,:) =nan(1,100);
%         else
%             fa(subID,:) =  mean([TractProfile{subID,fibID}{pctl}.vals.fa;...
%                 TractProfile{subID,fibID+1}{pctl}.vals.fa]);
%         end;
%         
%         if isempty(TractProfile{subID,fibID}{pctl}.nfibers);
%             md(subID,:) =nan(1,100);
%         else
%             md(subID,:) = mean([ TractProfile{subID,fibID}{pctl}.vals.md;...
%                 TractProfile{subID,fibID+1}{pctl}.vals.md]);
%         end;
%         
%         if isempty(TractProfile{subID,fibID}{pctl}.nfibers);
%             rd(subID,:) =nan(1,100);
%         else
%             rd(subID,:) = mean([ TractProfile{subID,fibID}{pctl}.vals.rd;...
%                 TractProfile{subID,fibID+1}{pctl}.vals.rd]);
%         end;
%         
%         if isempty(TractProfile{subID,fibID}{pctl}.nfibers);
%             ad(subID,:) =nan(1,100);
%         else
%             ad(subID,:) = mean([ TractProfile{subID,fibID}{pctl}.vals.ad;...
%                 TractProfile{subID,fibID+1}{pctl}.vals.ad]);
%         end;
%         % end
%         %% S.E.M
%         sem = nanstd(fa(Ctl,:))/sqrt(size(fa(Ctl,:),1));
%         hms_CRD=(mean(fa(Ctl,:))-mean(fa(CRD,:)))./sem;
%         hms_LHON=(mean(fa(Ctl,:))-mean(fa(LHON,:)))./sem;
%         
%         minmax(hms_CRD)
%         find(hms_CRD>=max(hms_CRD))
%         
%         minmax(hms_LHON)
%         find(hms_LHON>=max(hms_LHON))
%     end
%     %% ANOVA
%     Ctl_fa =  fa(Ctl,:);
%     LHON_fa =  fa(LHON,:);
%     CRD_fa =  fa(CRD,:);
%     
%     for jj= 1: 100
%         pac = nan(14,3);
%         pac(:,1)= Ctl_fa(:,jj);
%         pac(1:6,2)= LHON_fa(:,jj);
%         pac(1:5,3)= CRD_fa(:,jj);
%         [p(jj),~,stats(jj)] = anova1(pac,[],'off');
%         c = multcompare(stats(jj),'display','off')
%         C{jj}=c;
%     end
%     
%     Portion =  p<0.01;
%     k =  find(p<0.01)
%     
%     %% render
%     figure; hold on;
%     for k= find(p<0.01)
%         bar(k,1,1)
%     end
%     %
%     % % return the node differ significantly between CRD and Ctl
%     % for k =  find(p<0.01)
%     %     m = C{k}(:,3);
%     %     if m(2)>0
%     %         k
%     %     end
%     % end
%     
%     
%     
%     % OT figure
%     %         figure; hold on;
%     % Create axes
%     
%     c=lines(4)
%     
% %     figure; hold on;
%     % Render errorbar(S.E.M) of three groups
%     % CRD
%     sem = nanstd(fa(CRD,:))/sqrt(size(fa(CRD,:),1));
%     errorbar(X,nanmean(fa(CRD,:)),sem,'Color',c(3,:),...
%         'linewidth',1);
%     % LHON
%     sem = nanstd(fa(LHON,:))/sqrt(size(fa(LHON,:),1));
%     errorbar(X,nanmean(fa(LHON,:)),sem,'Color',rgb2cmyk([1 0 0 0]),...
%         'linewidth',1);
%     % Control
%     sem = nanstd(fa(Ctl,:))/sqrt(size(fa(Ctl,:),1));
%     errorbar(X,nanmean(fa(Ctl,:)),sem,'Color',gray,...
%         'linewidth',1);
%     axis([0 100 0.1 0.6])
%     %         title(sprintf('%s %s',fgN{fibID}(1:end-4),TractProfile{1,fibID}{sdID}.name)...
%     %             ,'FontName','Times','FontSize',16);
%     ylabel('Fractional anisotropy','FontName','Times','FontSize',16);
%     xlabel('Location','FontName','Times','FontSize',16);
%     %         line([17,17],[0.1,0.6] )
%     %         line([23,23],[0.1,0.6] )
%     %         line([41,41],[0.1,0.6] )
%     %         line([92,92],[0.1,0.6] )
%     %
%     %         line([45,45],[0.1,0.65] )
%     %         line([89,89],[0.1,0.65] )
%     hold off;
% end
% 
% 
% %% 
