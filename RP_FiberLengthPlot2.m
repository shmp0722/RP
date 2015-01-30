function RP_FiberLengthPlot2(save_fig)
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

%% argument check
if isempty(save_fig),
    save_fig = 0;
end
%% plot
X = 1:100; %$ number of  nodes
c = lines(100); % line colors

Diffusion = {'fa','md','ad','rd'};
for ii =1:length(Diffusion)
    property = Diffusion{ii};
    
    mrvNewGraphWin; hold on;
    % for fibID = 1
    for pctl = 2:6
        % take diffusion values
        for subID = 1:length(subDir);
            if isempty(TractProfile{subID,1}{pctl}.nfibers);
                fa(subID,:) =nan(1,100);
            else
                fa(subID,:) =  mean([TractProfile{subID,1}{pctl}.vals.fa;...
                    TractProfile{subID,1+1}{pctl}.vals.fa]);
            end;
            
            if isempty(TractProfile{subID,1}{pctl}.nfibers);
                md(subID,:) =nan(1,100);
            else
                md(subID,:) = mean([ TractProfile{subID,1}{pctl}.vals.md;...
                    TractProfile{subID,1+1}{pctl}.vals.md]);
            end;
            
            if isempty(TractProfile{subID,1}{pctl}.nfibers);
                rd(subID,:) =nan(1,100);
            else
                rd(subID,:) = mean([ TractProfile{subID,1}{pctl}.vals.rd;...
                    TractProfile{subID,1+1}{pctl}.vals.rd]);
            end;
            
            if isempty(TractProfile{subID,1}{pctl}.nfibers);
                ad(subID,:) =nan(1,100);
            else
                ad(subID,:) = mean([ TractProfile{subID,1}{pctl}.vals.ad;...
                    TractProfile{subID,1+1}{pctl}.vals.ad]);
            end;
            
        end
        
        %% switch based on property
        
        switch property
            case {'fa','FA'}
                ValCtl =  fa(Ctl,:);
                ValRP =  fa(RP,:);
                
                XLIM  = [10,90];
                YLIM  = [0.2 0.8];
                XTICK = XLIM;
                YTICK = YLIM;
                XTICKLabel = {'LGN','V1'};
                
            case {'md','MD'}
                ValCtl =  md(Ctl,:);
                ValRP =  md(RP,:);
                
                XLIM  = [10,90];
                YLIM  = [0.6 1.1];
                XTICK = XLIM;
                YTICK = YLIM;
                XTICKLabel = {'LGN','V1'};
                
            case {'ad','AD'}
                ValCtl =  ad(Ctl,:);
                ValRP =  ad(RP,:);
                
                XLIM  = [10,90];
                YLIM  = [1 1.7];
                XTICK = XLIM;
                YTICK = YLIM;
                XTICKLabel = {'LGN','V1'};
            case {'rd','RD'}
                ValCtl =  rd(Ctl,:);
                ValRP =  rd(RP,:);
                
                XLIM  = [10,90];
                YLIM  = [0.3 0.8];
                XTICK = XLIM;
                YTICK = YLIM;
                XTICKLabel = {'LGN','V1'};
        end
        
        
        %% plot
        subplot(2,3,pctl-1); hold on;
        
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
        
        %         %% CRD
        %         % individual
        %         for k = CRD %1:length(subDir)
        %             plot(X,ValRP,'Color',c(1,:),...
        %                 'linewidth',1);
        %         end
        %         % mean
        %         m=nanmean(fa(CRD,:));
        %         plot(X,m,'Color',c(1,:),...
        %             'linewidth',3)
        
        %% RP
        % individual
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
        axis('square')
        
        Percentile = {'0-20','20-40','40-60','60-80','80-100'};
        title(sprintf('%s',Percentile{pctl-1}))
        hold off;                    
    end
    % save the fig
    if save_fig,
        saveas(gcf, sprintf('%s_FiberLength.png',property))
        saveas(gcf, sprintf('%s_FiberLength.eps',property),'psc2')
    end
end

