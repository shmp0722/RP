function RP_FiberLengthPlot
% Plot figure 7 showing individual ad and rd value along the core of OR and
% optic tract. 
%
% Repository dependencies
%    VISTASOFT
%    AFQ
%    RP2
%
% SO Vista lab, 2014
%% Identify the directories and subject types in the study
% The full call can be
[~,subDir,~,CRD,~,Ctl,RP] = Tama_subj2;

%% Load TractProfile
load(fullfile(Tama_subj2,'results','Tama2_Percentile.mat'))

%% plot
X = 1:100; %$ number of  nodes
c = lines(100); % line colors

figure; hold on;
for fibID = 1
    for pctl = 2:6
        % take diffusion values
        for subID = 1:length(subDir);
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
        
        %% plot
        subplot(2,3,pctl-1); hold on;
        
        %% Control
        st = nanstd(fa(Ctl,:),1);
        m   = nanmean(fa(Ctl,:));
        
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
        
        %% CRD
        % individual
        for k = CRD %1:length(subDir)
            plot(X,fa(k,:),'Color',c(1,:),...
                'linewidth',1);
        end
        % mean 
        m=nanmean(fa(CRD,:));
        plot(X,m,'Color',c(1,:),...
            'linewidth',3)
        
        %% RP       
        % individual
        for k = RP 
            plot(X,fa(k,:),'Color',c(3,:),...
                'linewidth',1);
        end
        % mean
        plot(X,nanmean(fa(RP,:)),'Color',c(3,:),...
            'linewidth',3);
        % labeling
        ylabel('Fractional anisotropy','FontName','Times','FontSize',14);
        xlabel('Location','FontName','Times','FontSize',14);       
        axis([11, 90 ,0.15, 0.750001])
        
        axis('square')
        hold off;
    end
end
