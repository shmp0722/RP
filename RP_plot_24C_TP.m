function RP_plot_24C_TP

%% load afq structure
% see runSO_DivideFibersAcordingToFiberLength_percentile_RP

load /biac4/wandell/biac2/wandell/data/DWI-Tamagawa-Japan2/RP/RP_OTOR_PrCentile.mat

% define subject num
RP  = [1:8];
Ctl = [9:33];

%% Render plot
X = 1:100; %$ number of  nodes
c = lines(100); % line colors

%
Diffusion = {'fa'};
for ii =1:length(Diffusion)
    property = Diffusion{ii};
    
    mrvNewGraphWin; hold on;
    
    fibID = 1; % OR
    pctl = 1;
    % take diffusion values
    for subID = 1:length(TractProfile);
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
    
    %% switch based on property
    switch property
        case {'fa','FA'}
            % raw data
            ValCtl =  fa(Ctl,:);
            ValRP =  fa(RP,:);
            % for axis
            XLIM  = [10,90];
            YLIM  = [0.2 0.8];
            
        case {'md','MD'}
            ValCtl =  md(Ctl,:);
            ValRP =  md(RP,:);
            
            XLIM  = [10,90];
            YLIM  = [0.5 1.1];
            
        case {'ad','AD'}
            ValCtl =  ad(Ctl,:);
            ValRP =  ad(RP,:);
            
            XLIM  = [10,90];
            YLIM  = [1 1.8];
            
        case {'rd','RD'}
            ValCtl =  rd(Ctl,:);
            ValRP =  rd(RP,:);
            
            XLIM  = [10,90];
            YLIM  = [0.3 0.9];
            
    end
    
    XTICK = XLIM;
    YTICK = YLIM;
    XTICKLabel = {'LGN','V1'};
    
    % stats Wilcoxson
    for kk = 1:length(ValRP);
        [p(kk),h(kk)] = ranksum(ValCtl(:,kk),ValRP(:,kk),'alpha',0.01);
        [P(kk),H(kk)] = ranksum(ValCtl(:,kk),ValRP(:,kk),'alpha',0.05);
    end
    
    %% plot
    subplot(2,2,2); hold on;
    
    % put bars based on wilcoxson (p<0.01, 0.05)
    bar(H*5,1.0,'edgecolor','none','facecolor',[0.8 0.7 0.1])
    bar(h*5,1.0,'edgecolor','none','facecolor',[0.5 0.7 0.3])
    
    %% Control
    st = nanstd(ValCtl,1);
    m   = nanmean(ValCtl);
    
    A3 = area(m+2*st);
    A1 = area(m+st);
    A2 = area(m-st);
    A4 = area(m-2*st);
    
    % set color and style
    set(A1,'FaceColor',[0.6 0.6 0.6],'linestyle','none')
    set(A2,'FaceColor',[0.8 0.8 0.8],'linestyle','none')
    set(A3,'FaceColor',[0.8 0.8 0.8],'linestyle','none')
    set(A4,'FaceColor',[1 1 1],'linestyle','none')
    
    % mean plot
    plot(m,'color',[0 0 0], 'linewidth',3 )
    
    % RP individual
    for k = RP
        plot(X,ValRP,'Color',c(5,:),...
            'linewidth',1);
    end
    % mean
    plot(X,nanmean(ValRP),'Color',c(5,:),...
        'linewidth',3);
    % labeling
    ylabel(upper(property),'FontName','Times','FontSize',14);
    xlabel('Location','FontName','Times','FontSize',14);
    set(gca, 'xlim',XLIM,'xtick',XLIM,'xtickLabel',XTICKLabel,...
        'tickDir','out','ylim',YLIM,...
        'ytick',YLIM)
    %     axis('square')
    
    %     Percentile = {'0-20','20-40','40-60','60-80','80-100'};
    title('Optic Radiation','FontSize',18)
    hold off;
    %     end
    
    %% OT FA
    fibID = 3; % OR
    pctl = 1;
    % take diffusion values
    for subID = 1:length(TractProfile);
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
    
    %% switch based on property
    switch property
        case {'fa','FA'}
            % raw data
            ValCtl =  fa(Ctl,:);
            ValRP =  fa(RP,:);
            
            % for axis
            XLIM  = [10,90];
            YLIM  = [0.1 0.6];
            
            
        case {'md','MD'}
            ValCtl =  md(Ctl,:);
            ValRP =  md(RP,:);
            
            XLIM  = [10,90];
            YLIM  = [0.6 1.8];
            
            
        case {'ad','AD'}
            ValCtl =  ad(Ctl,:);
            ValRP =  ad(RP,:);
            
            XLIM  = [10,90];
            YLIM  = [1 2.2];
            
        case {'rd','RD'}
            ValCtl =  rd(Ctl,:);
            ValRP =  rd(RP,:);
            
            XLIM  = [10,90];
            YLIM  = [0.4 1.8];
    end
    % for
    XTICKLabel = {'OC','LGN'};
    
    % stats Wilcoxson
    for kk = 1:length(ValRP);
        [p(kk),h(kk)] = ranksum(ValCtl(:,kk),ValRP(:,kk),'alpha',0.01);
        [P(kk),H(kk)] = ranksum(ValCtl(:,kk),ValRP(:,kk),'alpha',0.05);
    end
    
    %% plot
    subplot(2,2,1); hold on;
    
    % put bars based on wilcoxson (p<0.01, 0.05)
    bar(H*5,1.0,'edgecolor','none','facecolor',[0.8 0.7 0.1])
    bar(h*5,1.0,'edgecolor','none','facecolor',[0.5 0.7 0.3])
    
    %% Control
    st = nanstd(ValCtl,1);
    m   = nanmean(ValCtl);
    
    A3 = area(m+2*st);
    A1 = area(m+st);
    A2 = area(m-st);
    A4 = area(m-2*st);
    
    % set color and style
    set(A1,'FaceColor',[0.6 0.6 0.6],'linestyle','none')
    set(A2,'FaceColor',[0.8 0.8 0.8],'linestyle','none')
    set(A3,'FaceColor',[0.8 0.8 0.8],'linestyle','none')
    set(A4,'FaceColor',[1 1 1],'linestyle','none')
    
    % mean plot
    plot(m,'color',[0 0 0], 'linewidth',3 )
    
    % RP individual
    for k = RP
        plot(X,ValRP,'Color',c(5,:),...
            'linewidth',1);
    end
    % mean
    plot(X,nanmean(ValRP),'Color',c(5,:),...
        'linewidth',3);
    % labeling
    ylabel(upper(property),'FontName','Times','FontSize',14);
    xlabel('Location','FontName','Times','FontSize',14);
    set(gca, 'xlim',XLIM,'xtick',XLIM,'xtickLabel',XTICKLabel,...
        'tickDir','out','ylim',YLIM,...
        'ytick',YLIM)
    %     axis('square')
    
    %     Percentile = {'0-20','20-40','40-60','60-80','80-100'};
    title('Optic Tract','FontSize',18)
    hold off;
end

%% save figures
saveas(gcf,'FA_OTOR.png')
saveas(gcf,'FA_OTOR.eps','psc2')








%% MD AD RD plot
mrvNewGraphWin; hold on;
% OT
fibID = 3; % OT
pctl = 1;
% take diffusion values
for subID = 1:length(TractProfile);
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

% switch based on property
Diffusion = {'md','ad','rd'};
for ii =1:length(Diffusion)
    property  =Diffusion{ii};
    %% switch based on property
    switch property
        case {'fa','FA'}
            % raw data
            ValCtl =  fa(Ctl,:);
            ValRP =  fa(RP,:);
            
            % for axis
            XLIM  = [10,90];
            YLIM  = [0.1 0.6];
            
            
        case {'md','MD'}
            ValCtl =  md(Ctl,:);
            ValRP =  md(RP,:);
            
            XLIM  = [10,90];
            YLIM  = [0.6 1.8];
            
            
        case {'ad','AD'}
            ValCtl =  ad(Ctl,:);
            ValRP =  ad(RP,:);
            
            XLIM  = [10,90];
            YLIM  = [1 2.2];
            
        case {'rd','RD'}
            ValCtl =  rd(Ctl,:);
            ValRP =  rd(RP,:);
            
            XLIM  = [10,90];
            YLIM  = [0.4 1.8];
    end
    
    XTICK = XLIM;
    YTICK = YLIM;
    XTICKLabel = {'OC','LGN'};
    
    % stats Wilcoxson
    for kk = 1:length(ValRP);
        [p(kk),h(kk)] = ranksum(ValCtl(:,kk),ValRP(:,kk),'alpha',0.01);
        [P(kk),H(kk)] = ranksum(ValCtl(:,kk),ValRP(:,kk),'alpha',0.05);
    end
    
    %% plot
    subplot(3,2,2*ii-1); hold on;
    
    % put bars based on wilcoxson (p<0.01, 0.05)
    bar(H*5,1.0,'edgecolor','none','facecolor',[0.8 0.7 0.1])
    bar(h*5,1.0,'edgecolor','none','facecolor',[0.5 0.7 0.3])
    
    %% Control
    st = nanstd(ValCtl,1);
    m   = nanmean(ValCtl);
    
    A3 = area(m+2*st);
    A1 = area(m+st);
    A2 = area(m-st);
    A4 = area(m-2*st);
    
    % set color and style
    set(A1,'FaceColor',[0.6 0.6 0.6],'linestyle','none')
    set(A2,'FaceColor',[0.8 0.8 0.8],'linestyle','none')
    set(A3,'FaceColor',[0.8 0.8 0.8],'linestyle','none')
    set(A4,'FaceColor',[1 1 1],'linestyle','none')
    
    % mean plot
    plot(m,'color',[0 0 0], 'linewidth',3 )
    
    % RP individual
    for k = RP
        plot(X,ValRP,'Color',c(5,:),...
            'linewidth',1);
    end
    % mean
    plot(X,nanmean(ValRP),'Color',c(5,:),...
        'linewidth',3);
    % labeling
    ylabel(upper(property),'FontName','Times','FontSize',14);
    xlabel('Location','FontName','Times','FontSize',14);
    set(gca, 'xlim',XLIM,'xtick',XLIM,'xtickLabel',{'LGN','V1'},...
        'tickDir','out','ylim',YLIM,...
        'ytick',YLIM)
    %     axis('square')
    
    %     Percentile = {'0-20','20-40','40-60','60-80','80-100'};
    title('Optic Tract','FontSize',18)

    hold off;
    
end

% Add OR
fibID = 1; % OR
pctl = 1;
% take diffusion values
for subID = 1:length(TractProfile);
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

% switch based on property
Diffusion = {'md','ad','rd'};
for ii =1:length(Diffusion)
    property  =Diffusion{ii};
    %% switch based on property
    switch property
        case {'fa','FA'}
            % raw data
            ValCtl =  fa(Ctl,:);
            ValRP =  fa(RP,:);
            % for axis
            XLIM  = [10,90];
            YLIM  = [0.2 0.8];
            
        case {'md','MD'}
            ValCtl =  md(Ctl,:);
            ValRP =  md(RP,:);
            
            XLIM  = [10,90];
            YLIM  = [0.5 1.1];
            
        case {'ad','AD'}
            ValCtl =  ad(Ctl,:);
            ValRP =  ad(RP,:);
            
            XLIM  = [10,90];
            YLIM  = [1 1.8];
            
        case {'rd','RD'}
            ValCtl =  rd(Ctl,:);
            ValRP =  rd(RP,:);
            
            XLIM  = [10,90];
            YLIM  = [0.3 0.9];
            
    end
    
    
    XTICKLabel = {'LGN','V1'};
    
    % stats Wilcoxson
    for kk = 1:length(ValRP);
        [p(kk),h(kk)] = ranksum(ValCtl(:,kk),ValRP(:,kk),'alpha',0.01);
        [P(kk),H(kk)] = ranksum(ValCtl(:,kk),ValRP(:,kk),'alpha',0.05);
    end
    
    %% plot
    subplot(3,2,2*ii); hold on;
    
    % put bars based on wilcoxson (p<0.01, 0.05)
    bar(H*5,1.0,'edgecolor','none','facecolor',[0.8 0.7 0.1])
    bar(h*5,1.0,'edgecolor','none','facecolor',[0.5 0.7 0.3])
    
    %% Control
    st = nanstd(ValCtl,1);
    m   = nanmean(ValCtl);
    
    A3 = area(m+2*st);
    A1 = area(m+st);
    A2 = area(m-st);
    A4 = area(m-2*st);
    
    % set color and style
    set(A1,'FaceColor',[0.6 0.6 0.6],'linestyle','none')
    set(A2,'FaceColor',[0.8 0.8 0.8],'linestyle','none')
    set(A3,'FaceColor',[0.8 0.8 0.8],'linestyle','none')
    set(A4,'FaceColor',[1 1 1],'linestyle','none')
    
    % mean plot
    plot(m,'color',[0 0 0], 'linewidth',3 )
    
    % RP individual
    for k = RP
        plot(X,ValRP,'Color',c(5,:),...
            'linewidth',1);
    end
    % mean
    plot(X,nanmean(ValRP),'Color',c(5,:),...
        'linewidth',3);
    % labeling
    ylabel(upper(property),'FontName','Times','FontSize',14);
    xlabel('Location','FontName','Times','FontSize',14);
    set(gca, 'xlim',XLIM,'xtick',XLIM,'xtickLabel',XTICKLabel,...
        'tickDir','out','ylim',YLIM,...
        'ytick',YLIM)
    %     axis('square')
    
    %     Percentile = {'0-20','20-40','40-60','60-80','80-100'};
    title('Optic Radiation','FontSize',18)
    hold off;
    
end

%% save figures
saveas(gcf,'MDADRD_OTOR.png')
saveas(gcf,'MDADRD_OTOR.eps','psc2')





%% AD RD plot
mrvNewGraphWin; hold on;
% OT
fibID = 3; % OT
pctl = 1;
% take diffusion values
for subID = 1:length(TractProfile);
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

% switch based on property
Diffusion = {'ad','rd'};
for ii =1:length(Diffusion)
    property  =Diffusion{ii};
    %% switch based on property
    switch property
        case {'fa','FA'}
            % raw data
            ValCtl =  fa(Ctl,:);
            ValRP =  fa(RP,:);
            
            % for axis
            XLIM  = [10,90];
            YLIM  = [0.1 0.6];
            
            
        case {'md','MD'}
            ValCtl =  md(Ctl,:);
            ValRP =  md(RP,:);
            
            XLIM  = [10,90];
            YLIM  = [0.6 1.8];
            
            
        case {'ad','AD'}
            ValCtl =  ad(Ctl,:);
            ValRP =  ad(RP,:);
            
            XLIM  = [10,90];
            YLIM  = [1 2.2];
            
        case {'rd','RD'}
            ValCtl =  rd(Ctl,:);
            ValRP =  rd(RP,:);
            
            XLIM  = [10,90];
            YLIM  = [0.4 1.8];
    end
    
    XTICK = XLIM;
    YTICK = YLIM;
    XTICKLabel = {'OC','LGN'};
    
    % stats Wilcoxson
    for kk = 1:length(ValRP);
        [p(kk),h(kk)] = ranksum(ValCtl(:,kk),ValRP(:,kk),'alpha',0.01);
        [P(kk),H(kk)] = ranksum(ValCtl(:,kk),ValRP(:,kk),'alpha',0.05);
    end
    
    %% plot
    subplot(2,2,2*ii-1); hold on;
    
    % put bars based on wilcoxson (p<0.01, 0.05)
    bar(H*5,1.0,'edgecolor','none','facecolor',[0.8 0.7 0.1])
    bar(h*5,1.0,'edgecolor','none','facecolor',[0.5 0.7 0.3])
    
    %% Control
    st = nanstd(ValCtl,1);
    m   = nanmean(ValCtl);
    
    A3 = area(m+2*st);
    A1 = area(m+st);
    A2 = area(m-st);
    A4 = area(m-2*st);
    
    % set color and style
    set(A1,'FaceColor',[0.6 0.6 0.6],'linestyle','none')
    set(A2,'FaceColor',[0.8 0.8 0.8],'linestyle','none')
    set(A3,'FaceColor',[0.8 0.8 0.8],'linestyle','none')
    set(A4,'FaceColor',[1 1 1],'linestyle','none')
    
    % mean plot
    plot(m,'color',[0 0 0], 'linewidth',3 )
    
    % RP individual
    for k = RP
        plot(X,ValRP,'Color',c(5,:),...
            'linewidth',1);
    end
    % mean
    plot(X,nanmean(ValRP),'Color',c(5,:),...
        'linewidth',3);
    % labeling
    ylabel(upper(property),'FontName','Times','FontSize',14);
    xlabel('Location','FontName','Times','FontSize',14);
    set(gca, 'xlim',XLIM,'xtick',XLIM,'xtickLabel',{'LGN','V1'},...
        'tickDir','out','ylim',YLIM,...
        'ytick',YLIM)
    %     axis('square')
    
    %     Percentile = {'0-20','20-40','40-60','60-80','80-100'};
    title('Optic Tract','FontSize',18)

    hold off;
    
end

% Add OR
fibID = 1; % OR
pctl = 1;
% take diffusion values
for subID = 1:length(TractProfile);
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

% switch based on property
Diffusion = {'md','ad','rd'};
for ii =1:length(Diffusion)
    property  =Diffusion{ii};
    %% switch based on property
    switch property
        case {'fa','FA'}
            % raw data
            ValCtl =  fa(Ctl,:);
            ValRP =  fa(RP,:);
            % for axis
            XLIM  = [10,90];
            YLIM  = [0.2 0.8];
            
        case {'md','MD'}
            ValCtl =  md(Ctl,:);
            ValRP =  md(RP,:);
            
            XLIM  = [10,90];
            YLIM  = [0.5 1.1];
            
        case {'ad','AD'}
            ValCtl =  ad(Ctl,:);
            ValRP =  ad(RP,:);
            
            XLIM  = [10,90];
            YLIM  = [1 1.8];
            
        case {'rd','RD'}
            ValCtl =  rd(Ctl,:);
            ValRP =  rd(RP,:);
            
            XLIM  = [10,90];
            YLIM  = [0.3 0.9];
            
    end
    
    
    XTICKLabel = {'LGN','V1'};
    
    % stats Wilcoxson
    for kk = 1:length(ValRP);
        [p(kk),h(kk)] = ranksum(ValCtl(:,kk),ValRP(:,kk),'alpha',0.01);
        [P(kk),H(kk)] = ranksum(ValCtl(:,kk),ValRP(:,kk),'alpha',0.05);
    end
    
    %% plot
    subplot(2,2,2*ii); hold on;
    
    % put bars based on wilcoxson (p<0.01, 0.05)
    bar(H*5,1.0,'edgecolor','none','facecolor',[0.8 0.7 0.1])
    bar(h*5,1.0,'edgecolor','none','facecolor',[0.5 0.7 0.3])
    
    %% Control
    st = nanstd(ValCtl,1);
    m   = nanmean(ValCtl);
    
    A3 = area(m+2*st);
    A1 = area(m+st);
    A2 = area(m-st);
    A4 = area(m-2*st);
    
    % set color and style
    set(A1,'FaceColor',[0.6 0.6 0.6],'linestyle','none')
    set(A2,'FaceColor',[0.8 0.8 0.8],'linestyle','none')
    set(A3,'FaceColor',[0.8 0.8 0.8],'linestyle','none')
    set(A4,'FaceColor',[1 1 1],'linestyle','none')
    
    % mean plot
    plot(m,'color',[0 0 0], 'linewidth',3 )
    
    % RP individual
    for k = RP
        plot(X,ValRP,'Color',c(5,:),...
            'linewidth',1);
    end
    % mean
    plot(X,nanmean(ValRP),'Color',c(5,:),...
        'linewidth',3);
    % labeling
    ylabel(upper(property),'FontName','Times','FontSize',14);
    xlabel('Location','FontName','Times','FontSize',14);
    set(gca, 'xlim',XLIM,'xtick',XLIM,'xtickLabel',XTICKLabel,...
        'tickDir','out','ylim',YLIM,...
        'ytick',YLIM)
    %     axis('square')
    
    %     Percentile = {'0-20','20-40','40-60','60-80','80-100'};
    title('Optic Radiation','FontSize',18)
    hold off;
    
end

%% save figures
saveas(gcf,'ADRD_OTOR.png')
saveas(gcf,'ADRD_OTOR.eps','psc2')

