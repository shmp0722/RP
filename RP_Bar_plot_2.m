function RP_Bar_plot_2(save_fig)
% Plot figure 5 showing individual FA value along the core of OR and optic tract.
%
% %% MATLAB 2014b %%
%
% Repository dependencies
%    VISTASOFT
%    AFQ
%    LHON2
%
% SO@ Stanford Vista team

%% argument check
if isempty(save_fig),
    save_fig = 0;
end

%% Identify the directories and subject types in the study
% The full call can be
[~,subDir,~,CRD,~,Ctl,RP] = Tama_subj2;

%% Load TractProfile data
TPdata = fullfile('/biac4/wandell/biac2/wandell/data/DWI-Tamagawa-Japan2/results/Tama2_TP_SD.mat');
load(TPdata)

% If you are working at home and using your local maschine (MAC air)

% load '/Users/shumpei/Google Drive/RP/Tama2_TP_SD.mat'

%% Figure
% indivisual FA value along "optic tract"

% take values
ID = [3,1]; %
for jj=1:2;
    fibID = ID(jj);
    sdID  = 1;%:7
    % make one sheet diffusivity
    % merge both hemisphere
    for subID = 1:length(TractProfile);
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
    
    %% group plot plus error bar.
    % this looks better than previous one.
    
    %     mrvNewGraphWin; hold on;
    Diffusion = {'fa','md','ad','rd'};
    
    cFA(:,jj) = reshape(fa(Ctl,:),length(Ctl)*100,1);
    pFA(:,jj) = reshape(fa(RP,:),length(RP)*100,1);
    cMD(:,jj) = reshape(md(Ctl,:),length(Ctl)*100,1);
    pMD(:,jj) = reshape(md(RP,:),length(RP)*100,1);
    cAD(:,jj) = reshape(ad(Ctl,:),length(Ctl)*100,1);
    pAD(:,jj) = reshape(ad(RP,:),length(RP)*100,1);
    cRD(:,jj) = reshape(rd(Ctl,:),length(Ctl)*100,1);
    pRD(:,jj) = reshape(rd(RP,:),length(RP)*100,1);
end

% %%
% mrvNewGraphWin;
% boxplot([cFA(:,1);pFA(:,1)])

%% Render bar plot
mrvNewGraphWin; hold on;
% Value
Y = [mean(cFA(:,1)),mean(pFA(:,1)),mean(cFA(:,2)),mean(pFA(:,2));...
    mean(cMD(:,1)),mean(pMD(:,1)),mean(cMD(:,2)),mean(pMD(:,2));...
    mean(cAD(:,1)),mean(pAD(:,1)),mean(cAD(:,2)),mean(pAD(:,2));...
    mean(cRD(:,1)),mean(pRD(:,1)),mean(cRD(:,2)),mean(pRD(:,2))];
% Error
E = [std(cFA(:,1)),std(pFA(:,1)),std(cFA(:,2)),std(pFA(:,2));...
    std(cMD(:,1)),std(pMD(:,1)),std(cMD(:,2)),std(pMD(:,2));...
    std(cAD(:,1)),std(pAD(:,1)),std(cAD(:,2)),std(pAD(:,2));...
    std(cRD(:,1)),std(pRD(:,1)),std(cRD(:,2)),std(pRD(:,2))];
% Plot bars
hBar = bar(Y,1,'grouped');

% set(h,'BarWidth',1);    % The bars will now touch each other
set(gca,'XTick',[1:4],'XTicklabel',upper(Diffusion),...
    'tickdir','out', 'box','off')

% add legend
lh = legend('Ctl OT','RP OT','Ctl OR','RP OR');
set(lh,'box','off','EdgeColor','none')
%     lh.Position =  [0.7031 0.8318 0.1799 0.0633];

% add error bars
numgroups = size(Y, 1);
numbars = size(Y, 2);
groupwidth = min(0.8, numbars/(numbars+1.5));

for i = 1:numbars
    % Based on barweb.m by Bolu Ajiboye from MATLAB File Exchange
    x = (1:numgroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*numbars);  % Aligning error bar with individual bar
    % put error bar on only upper side
    errorbar(x, Y(:,i), zeros(size(E(:,i))) ,E(:,i), 'k', 'linestyle', 'none');
end

% Add t stats
% t-test
H = zeros(4,2);
P = zeros(4,2);
%
[H(1,:), P(1,:)] =ttest2(cFA,pFA);
[H(2,:), P(2,:)] =ttest2(cMD,pMD);
[H(3,:), P(3,:)] =ttest2(cAD,pAD);
[H(4,:), P(4,:)] =ttest2(cRD,pRD);

%% put stars
% OR
x = (1:numgroups) - groupwidth/2 + 2*(2-1) * groupwidth / (2*numbars);
for i =1:length(Diffusion)
    % put '*' if there is significant difference,
    if H(i,1),
        plot(x(i), max(Y(i,:))+0.3 , '*','color',[0 0 0]);
        if P(i,1)<0.01,
            plot(x(i), max(Y(i,:))+0.35 , '*','color',[0 0 0]);
        end
    end
end
% OT
x = (1:numgroups) - groupwidth/2 + 6*(2-1) * groupwidth / (2*numbars);
for i =1:length(Diffusion)
    if H(i,2),
        
        plot(x(i), max(Y(i,:))+0.3 , '*','color',[0 0 0]);
        if P(i,1)<0.01,
            plot(x(i), max(Y(i,:))+0.35 , '*','color',[0 0 0]);
        end
    end
end

%% make up and save

xlabel('Diffusivities')
set(gca, 'ylim',[0,2],'ytick',[0,1,2])
hold off;

% save the figure
if save_fig
    saveas(gcf, 'RP_barPlot.eps','psc2')
end

end
