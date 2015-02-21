function RP_OT_plot(save_fig)
% Plot figure 5 showing individual FA value along the core of OR and optic tract.
%
% Repository dependencies
%    VISTASOFT
%    AFQ
%    LHON2
%
% SO Vista lab, 2014
%
% Shumpei Ogawa 2014

%% Identify the directories and subject types in the study
% The full call can be
[~,subDir,~,CRD,~,Ctl,RP] = Tama_subj2;

%% Load TractProfile data
TPdata = fullfile('/biac4/wandell/biac2/wandell/data/DWI-Tamagawa-Japan2/results/Tama2_TP_SD.mat');

if exist(TPdata)
    load(TPdata)
else
    load '/Users/shumpei/Google Drive/RP/Tama2_TP_SD.mat'
end

%% Figure
% indivisual FA value along optic tract

% take values
fibID =3; %
sdID = 1;%:7
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

%% switch based on property
Diffusion = {'fa','md','ad','rd'};

for ii =1:length(Diffusion)
    property = Diffusion{ii};
    
    switch property
        case {'fa','FA'}
            ValCtl =  fa(Ctl,:);
            ValRP =  fa(RP,:);
            
            XLIM  = [10,90];
            YLIM  = [0 0.6];
            XTICK = XLIM;
            YTICK = [0:0.3:0.6];
            XTICKLabel = {'OC','LGN'};
            
        case {'md','MD'}
            ValCtl =  md(Ctl,:);
            ValRP =  md(RP,:);
            
            XLIM  = [10,90];
            YLIM  = [0.6 1.8];
            XTICK = XLIM;
            YTICK = YLIM;
            XTICKLabel = {'OC','LGN'};
            
        case {'ad','AD'}
            ValCtl =  ad(Ctl,:);
            ValRP =  ad(RP,:);
            
            XLIM  = [10,90];
            YLIM  = [1 2.4];
            XTICK = XLIM;
            YTICK = YLIM;
            XTICKLabel = {'OC','LGN'};
        case {'rd','RD'}
            ValCtl =  rd(Ctl,:);
            ValRP =  rd(RP,:);
            
            XLIM  = [10,90];
            YLIM  = [0.4 1.6];
            XTICK = XLIM;
            YTICK = YLIM;
            XTICKLabel = {'OC','LGN'};
    end
    
    %% Wilcoxon
    for ii = 1:length(ValRP);
        [p(ii),h(ii)] = ranksum(ValCtl(:,ii),ValRP(:,ii),'alpha',0.05);
    end
    
    % %% ANOVA
    %
    % for jj= 1: 100
    %     pac = nan(14,3);
    %     pac(:,1)= ValCtl(:,jj);
    %     pac(1:length(RP),2)= ValRP(:,jj);
    %     pac(1:length(CRD),3)= CRD_fa(:,jj);
    %     [p(jj),~,stats(jj)] = anova1(pac,[],'off');
    %     co = multcompare(stats(jj),'display','off');
    %     C{jj}=co;
    % end
    % Portion =  p<0.01; % where is most effected
    
    %% Optic Tract
    % FA
    % figure; hold on;
    mrvNewGraphWin; hold on;
    X = 1:100;
    c = lines(100);
    
    % bars where is significant difference between two groups
    % p<0.05
    bar(1:100,h*5,1,'EdgeColor','none','facecolor',[0.8 0.7 0.3])
    % p,0.01
    % bar(1:100,p,1,'EdgeColor','none','facecolor',[0.6 0.6 0.6])
    
    % Control
    st = nanstd(ValCtl,1);
    m   = nanmean(ValCtl);
    
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
    
    % % add individual FA plot
    % for k = CRD %1:length(subDir)
    %     plot(X,ValRP(k,:),'Color',c(3,:),'linewidth',1);
    % end
    % m   = nanmean(fa(CRD,:));
    % plot(X,m,'Color',c(3,:) ,'linewidth',3)
    
    
    % add individual
    for k =1:length(RP) %1:length(subDir)
        plot(X,ValRP(k,:),'--','Color',c(5,:),'linewidth',1);
    end
    % plot mean value
    m   = nanmean(ValRP);
    plot(X,m,'Color',c(5,:) ,'linewidth',3)
    
    % add label
    xlabel('Location','fontSize',14);
    ylabel(upper(property),'fontSize',14);
    title('Optic tract','fontSize',14)
    
    % adjustment
    set(gca,'xlim',XLIM,'ylim',YLIM, 'xtick',XTICK,'ytick',YTICK,...
        'xtickLabel',XTICKLabel,...
        'tickDir','out','tickLength', [0.01    0.02])
    hold off;
    
    % save
    if save_fig,
        saveas(gcf,sprintf('OT_%s.png',upper(property)))
        saveas(gcf,sprintf('OT_%s.eps',upper(property)),'psc2')
    end
end


end