function RP_Bar_plot
% Plot figure 5 showing individual FA value along the core of OR and optic tract.
%
% Repository dependencies
%    VISTASOFT
%    AFQ
%    LHON2
%
% SO@ Stanford Vista team

%% Identify the directories and subject types in the study
% The full call can be
[~,subDir,~,CRD,~,Ctl,RP] = Tama_subj2;

%% Load TractProfile data
TPdata = fullfile('/biac4/wandell/biac2/wandell/data/DWI-Tamagawa-Japan2/results/Tama2_TP_SD.mat');
load(TPdata)

% If you are working at home and using your local maschine (MAC air)

% load '/Users/shumpei/Google Drive/RP/Tama2_TP_SD.mat'

%% Figure
% indivisual FA value along optic tract

% take values
fibID =3; %
sdID = 1;%:7
% make one sheet diffusivity
% merge both hemisphere
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
% 
% %% Render  Bar Plot
% 
% mrvNewGraphWin;hold on;
% 
% % Render
Diffusion = {'fa','md','ad','rd'};
% for jj = 1:length(Diffusion)
%     % switch based on property
%     property = Diffusion{jj};
%     
%     switch property
%         case {'fa','FA'}
%             ValCtl =  fa(Ctl,:);
%             ValRP  =  fa(RP,:);
%         case {'md','MD'}
%             ValCtl =  md(Ctl,:);
%             ValRP  =  md(RP,:);
%         case {'ad','AD'}
%             ValCtl =  ad(Ctl,:);
%             ValRP  =  ad(RP,:);
%         case {'rd','RD'}
%             ValCtl =  rd(Ctl,:);
%             ValRP  =  rd(RP,:);
%     end
%     
%     %% Stats
%     % test for normality in whole nodes
%     [H, pValue, SWstatistic] = swtest(ValCtl(:), 0.05);
%     if H,
%         [H, pValue, SWstatistic] = swtest(ValRP(:), 0.05);
%     else
%         H = 0;
%     end
%     if H,
%         [h(jj), p(jj)] =ttest2(ValCtl(:),ValRP(:));
%         % render bar graph
%         bar([2*jj-1,2*jj],[nanmean(ValCtl(:)),nanmean(ValRP(:))],0.5,'facecolor',[.95 .6 .5])
%         % add error bar
%         errorbar2([2*jj-1,2*jj],[nanmean(ValCtl(:)),nanmean(ValRP(:))],...
%             [nanstd(ValCtl(:)), nanstd(ValRP(:))],1,...
%             'color',[0 0 0]);
%     end
%     
% end
% 
% % make the figure up
% B = gca;
% B.XTick = 1.5:2:7.5;
% B.XTickLabel = upper(Diffusion);
% B.YTick = [0,0.9 ,1.8];
% B.YLabel.String   = 'Diffusivity'; %sprintf('%s',upper(property));
% B.YLabel.FontSize = 16;
% B.XLabel.String   = 'Group';
% B.XLabel.FontSize = 16;
% set(B, 'tickdir','out', 'box','off')
% 
% hleg1 = legend('Healthy','RP');
% set(hleg1,'box','off')
% return

%% group plot plus error bar.
% this looks better than previous one.

mrvNewGraphWin; hold on;

cFA = reshape(fa(Ctl,:),length(Ctl)*100,1);
pFA = reshape(fa(RP,:),length(RP)*100,1);
cMD = reshape(md(Ctl,:),length(Ctl)*100,1);
pMD = reshape(md(RP,:),length(RP)*100,1);
cAD = reshape(ad(Ctl,:),length(Ctl)*100,1);
pAD = reshape(ad(RP,:),length(RP)*100,1);
cRD = reshape(rd(Ctl,:),length(Ctl)*100,1);
pRD = reshape(rd(RP,:),length(RP)*100,1);

% Value
Y = [mean(cFA),mean(pFA);mean(cMD),mean(pMD);mean(cAD),mean(pAD);...
    mean(cRD),mean(pRD)];
% Error
E = [std(cFA),std(pFA);std(cMD),std(pMD);std(cAD),std(pAD);...
    std(cRD),std(pRD)];
%
model_series = Y;
model_error = E;
bar(model_series);

set(h,'BarWidth',1);    % The bars will now touch each other
set(h,'XTick',[1:4],'XTicklabel',upper(Diffusion),'tickdir','out', 'box','off')

lh = legend('Healthy','RP');
% set(lh,'Location','BestOutside','Orientation','horizontal')
set(lh,'box','off')
hold on;
numgroups = size(model_series, 1);
numbars = size(model_series, 2);
groupwidth = min(0.8, numbars/(numbars+1.5));
for i = 1:numbars
    % Based on barweb.m by Bolu Ajiboye from MATLAB File Exchange
    x = (1:numgroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*numbars);  % Aligning error bar with individual bar
    errorbar(x, model_series(:,i), model_error(:,i), 'k', 'linestyle', 'none');
end