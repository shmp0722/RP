function RP_Bar_plot
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
ID = [1,3]; %
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
    
    mrvNewGraphWin; hold on;
    Diffusion = {'fa','md','ad','rd'};
    
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
    % Plot bars
    bar(Y);
    h = gca;
    
    % set(h,'BarWidth',1);    % The bars will now touch each other
    set(h,'XTick',[1:4],'XTicklabel',upper(Diffusion),'tickdir','out', 'box','off')
    
    % add legend
    lh = legend('Healthy','RP');
    set(lh,'box','off','EdgeColor','none')
    lh.Position =  [0.7031 0.8318 0.1799 0.0633];
    
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
    
    %% Add t stats
    [H(1), P(1)] =ttest2(cFA,pFA);
    [H(2), P(2)] =ttest2(cMD,pMD);
    [H(3), P(3)] =ttest2(cAD,pAD);
    [H(4), P(4)] =ttest2(cRD,pRD);
    
    for ii =1:length(Diffusion)
        if H(ii),
            plot(ii, max(Y(ii,:))+0.3 , '*','color',[0 0 0]);
            if P(ii)<0.01,
                plot(ii, max(Y(ii,:))+0.4 , '*','color',[0 0 0]);
            end
        end
    end
    
    %%
    switch fibID
        case {3}
            title('Optic tract')
            set(gca, 'ylim',[0,2],'ytick',[0,1,2])
            % save the figure
            saveas(gcf, 'RP_barPlot_OT.png')
            saveas(gcf, 'RP_barPlot_OT.eps','psc2')
            
        case {1}
            title('Optic radiation')
            set(h,'ylim',[0,1.8],'YTick',[0:0.9:1.8]);
            
            
            % save the figure
            saveas(gcf, 'RP_barPlot_OR.png')
            saveas(gcf, 'RP_barPlot_OR.eps','psc2')
            
    end
    hold off;
end
