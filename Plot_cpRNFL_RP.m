function Plot_cpRNFL_RP(save_fig)

%% move to result folder 
% TamagawaPath('rp');
%% Load OCT normal dstribution file
% normal distribution
DataDir = '/biac4/wandell/biac2/wandell/data/DWI-Tamagawa-Japan2/RP';
if exist(DataDir,'dir')>0, 
    % normal data
    load(fullfile(DataDir,'D.mat'));
    load(fullfile(DataDir,'M.mat'));
    % subjects data
    load(fullfile(DataDir,'RP_DiscOCT.mat'));
else
    % normal data
    load    /Users/shumpei/Documents/MATLAB/git/RP/D.mat
    load    /Users/shumpei/Documents/MATLAB/git/RP/M.mat
    % subjects data
    load    /Users/shumpei/Documents/MATLAB/git/RP/RP_DiscOCT.mat
end

%% Disc plot 
% add normal distribution
m  =  D.val;
sd =  D.sd;

%% L-eye
h =mrvNewGraphWin; hold on;
% left eye
errorbar2(1:5,[m(1),m(4),m(5),m(3),m(2)],...
    [sd(1),sd(4),sd(5),sd(3),sd(2)]*2,1,'color',[0.9 0.9 0.9],...
    'linewidth',10);
errorbar2(1:5,[m(1),m(4),m(5),m(3),m(2)],[sd(1),sd(4),sd(5),sd(3),sd(2)],1,'color',[0.8 0.80 0.8],...
    'linewidth',10);

% add individual plot
plot(1, AveRNFLthicknessL(:),'o','linewidth',2)
plot(2, LRNFLnasal,'o','linewidth',2)
plot(3, LRNFLquadrantsInferior,'o','linewidth',2)
plot(4, LRNFLquadrantsSuperior,'o','linewidth',2)
plot(5, LRNFLTemporal,'o','linewidth',2)
% Right eye
% plot(6, AveRNFLthicknessR(:),'o','linewidth',2)
% h = gca;

% x axis
set(gca,'xlim',[0,6],'xtick',[1:5])
set(gca,'XTickLabel',{'L-ave','Nasal','Inf','Sup','Temp'},'tickdir','out', 'box','off')

% y axis
set(gca,'ytick',[40:70:180])

% % legend
% lh = legend('Healthy','RP');
% set(lh,'box','off','EdgeColor','none')

title('L-peripapillary RNFL thinckness','fontsize',14)
if save_fig,
    saveas(gcf,'L_disk_oct.png')
    saveas(gcf,'L_disk_oct.eps','psc2');
end
%% R-eye

mrvNewGraphWin; hold on;
% left eye
errorbar2(1:5,[m(1),m(4),m(5),m(3),m(2)],...
    [sd(1),sd(4),sd(5),sd(3),sd(2)]*2,1,'color',[0.9 0.9 0.9],...
    'linewidth',10);
errorbar2(1:5,[m(1),m(4),m(5),m(3),m(2)],[sd(1),sd(4),sd(5),sd(3),sd(2)],1,'color',[0.8 0.80 0.8],...
    'linewidth',10);

% add individual plot
plot(1, AveRNFLthicknessR,'o','linewidth',2)
plot(2, RRNFLnasal,'o','linewidth',2)
plot(3, RRNFLquadrantsInferior,'o','linewidth',2)
plot(4, RRNFLquadrantsSuperior,'o','linewidth',2)
plot(5, RRNFLTemporal,'o','linewidth',2)

% x axis
set(gca,'xlim',[0,6],'xtick',[1:5])
set(gca,'XTickLabel',{'L-ave','Nasal','Inf','Sup','Temp'},'tickdir','out', 'box','off')

% y axis
set(gca,'ytick',[40:70:180])

title('R-peripapillary RNFL thinckness','fontsize',14)
if save_fig,
    saveas(gcf,'R_disk_oct.png')
    saveas(gcf,'R_disk_oct.eps','psc2');
end

%% Both-eye

mrvNewGraphWin; hold on;
% left eye
errorbar2(1:5,[m(1),m(4),m(5),m(3),m(2)],...
    [sd(1),sd(4),sd(5),sd(3),sd(2)]*2,1,'color',[0.9 0.9 0.9],...
    'linewidth',10);
errorbar2(1:5,[m(1),m(4),m(5),m(3),m(2)],[sd(1),sd(4),sd(5),sd(3),sd(2)],1,'color',[0.8 0.80 0.8],...
    'linewidth',10);

% add individual plot
plot(1, mean([AveRNFLthicknessR,AveRNFLthicknessL],2),'o','linewidth',2)
plot(2, mean([RRNFLnasal,LRNFLnasal],2),'o','linewidth',2)
plot(3, mean([LRNFLquadrantsInferior,RRNFLquadrantsInferior],2),'o','linewidth',2)
plot(4, mean([RRNFLquadrantsSuperior, LRNFLquadrantsSuperior],2),'o','linewidth',2)
plot(5, mean([RRNFLTemporal,LRNFLTemporal],2),'o','linewidth',2)

% x axis
set(gca,'xlim',[0,6],'xtick',[1:5])
set(gca,'XTickLabel',{'Ave','Nasal','Inf','Sup','Temp'},'tickdir','out', 'box','off')

% y axis
set(gca,'ytick',[40,180],'ylim',[40,180])

title('Peripapillary RNFL thinckness','fontsize',14)

%save 
if save_fig,
    saveas(gcf,'B_disk_oct.png')
    saveas(gcf,'B_disk_oct.eps','psc2');
end
