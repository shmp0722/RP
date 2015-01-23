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

%% Render  Bar Plot

mrvNewGraphWin;hold on;

% Render
Diffusion = {'fa','md','ad','rd'};
for jj = 1:length(Diffusion)
    % switch based on property
    property = Diffusion{jj};
    
    switch property
        case {'fa','FA'}
            ValCtl =  fa(Ctl,:);
            ValRP  =  fa(RP,:);
        case {'md','MD'}
            ValCtl =  md(Ctl,:);
            ValRP  =  md(RP,:);
        case {'ad','AD'}
            ValCtl =  ad(Ctl,:);
            ValRP  =  ad(RP,:);
        case {'rd','RD'}
            ValCtl =  rd(Ctl,:);
            ValRP  =  rd(RP,:);
    end
    
    %% Stats
    % test for normality in whole nodes
    [H, pValue, SWstatistic] = swtest(ValCtl(:), 0.05);
    if H,
        [H, pValue, SWstatistic] = swtest(ValRP(:), 0.05);
    else
        H = 0;
    end
    if H,
        [h(jj), p(jj)] =ttest2(ValCtl(:),ValRP(:));
        % render bar graph
        bar([2*jj-1,2*jj],[nanmean(ValCtl(:)),nanmean(ValRP(:))],0.5,'facecolor',[.95 .6 .5])
        % add error bar
        errorbar2([2*jj-1,2*jj],[nanmean(ValCtl(:)),nanmean(ValRP(:))],...
            [nanstd(ValCtl(:)), nanstd(ValRP(:))],1,...
            'color',[0 0 0]);
    end
    
end

% make the figure up
B = gca;
B.XTick = 1.5:2:7.5;
B.XTickLabel = upper(Diffusion);
B.YTick = [0,0.9 ,1.8];
B.YLabel.String   = 'Diffusivity'; %sprintf('%s',upper(property));
B.YLabel.FontSize = 16;
B.XLabel.String   = 'Group';
B.XLabel.FontSize = 16; 
set(B, 'tickdir','out', 'box','off')

hleg1 = legend('Healthy','RP');
set(hleg1,'box','off')
return
%% 
mrvNewGraphWin; hold on;
set(gca, 'tickdir','out', 'box','off')

cFA = nanmean(nanmean(fa(Ctl,:)));
pFA = nanmean(nanmean(fa(RP,:)));
cMD = nanmean(nanmean(md(Ctl,:)));
pMD = nanmean(nanmean(md(RP,:)));
cAD = nanmean(nanmean(ad(Ctl,:)));
pAD = nanmean(nanmean(ad(RP,:)));
cRD = nanmean(nanmean(rd(Ctl,:)));
pRD = nanmean(nanmean(rd(RP,:)));

bar([cFA,pFA;cMD,pMD;cAD,pAD;cRD,pRD])

B = gca;
B.XTick = 1:4;
B.XTickLabel = upper(Diffusion);
B.YTick = [0,0.9 ,1.8];
B.YLabel.String   = 'Diffusivity'; %sprintf('%s',upper(property));
B.YLabel.FontSize = 16;
B.XLabel.String   = 'Group';
B.XLabel.FontSize = 16; 
set(B, 'tickdir','out', 'box','off')

hleg1 = legend('Healthy','RP');
set(hleg1,'box','off')

%% add error bar
X = [1,1,2,2,3,3,4,4];
% Y = [
errorbar2([2*jj-1,2*jj],[nanmean(ValCtl(:)),nanmean(ValRP(:))],...
            [nanstd(ValCtl(:)), nanstd(ValRP(:))],1,...
            'color',[0 0 0]);

        
        
%%
% mrvNewGraphWin; hold on;

cFA = reshape(fa(Ctl,:),length(Ctl)*100,1);
pFA = reshape(fa(RP,:),length(RP)*100,1);
cMD = reshape(md(Ctl,:),length(Ctl)*100,1);
pMD = reshape(md(RP,:),length(RP)*100,1);
cAD = reshape(ad(Ctl,:),length(Ctl)*100,1);
pAD = reshape(ad(RP,:),length(RP)*100,1);
cRD = reshape(rd(Ctl,:),length(Ctl)*100,1);
pRD = reshape(rd(RP,:),length(RP)*100,1);

% Basic usage:
  Y = [mean(cFA),mean(pFA);mean(cMD),mean(pMD);mean(cAD),mean(pAD);...
      mean(cRD),mean(pRD)];
  E = [std(cFA),std(pFA);std(cMD),std(pMD);std(cAD),std(pAD);...
      std(cRD),std(pRD)];
  errorbar_groups(Y,E);