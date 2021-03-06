function RP_FiberLengthPlot2
% Plot figure 7 showing individual ad and rd value along the core of OR and
% optic tract.
%
% Repository dependencies
%    VISTASOFT
%    AFQ
%    RP2
%
% SO Vista lab, 2014

%% Load TractProfile

load /biac4/wandell/biac2/wandell/data/DWI-Tamagawa-Japan2/RP/RP_FL_PrCentile2.mat

% define subject num
RP  = [1:8];
Ctl = [9:33];


%% Render plot
X = 1:100; %$ number of  nodes
c = lines(100); % line colors

%
Diffusion = {'fa','md','ad','rd'};
for ii =1:length(Diffusion)
    property = Diffusion{ii};
    
    mrvNewGraphWin; hold on;
    % for fibID = 1
    for pctl = 2:6
        % take diffusion values
        for subID = 1:length(TractProfile);
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
                % raw data
                ValCtl =  fa(Ctl,:);
                ValRP =  fa(RP,:);   
                
                % for axis
                XLIM  = [10,90];
                YLIM  = [0.2 0.8];
                XTICK = XLIM;
                YTICK = YLIM;
                XTICKLabel = {'LGN','V1'};
                
            case {'md','MD'}
                ValCtl =  md(Ctl,:);
                ValRP =  md(RP,:);
                
                XLIM  = [10,90];
                YLIM  = [0.5 1.1];
                XTICK = XLIM;
                YTICK = YLIM;
                XTICKLabel = {'LGN','V1'};
                
            case {'ad','AD'}
                ValCtl =  ad(Ctl,:);
                ValRP =  ad(RP,:);
                
                XLIM  = [10,90];
                YLIM  = [1 1.8];
                XTICK = XLIM;
                YTICK = YLIM;
                XTICKLabel = {'LGN','V1'};
            case {'rd','RD'}
                ValCtl =  rd(Ctl,:);
                ValRP =  rd(RP,:);
                
                XLIM  = [10,90];
                YLIM  = [0.3 0.9];
                XTICK = XLIM;
                YTICK = YLIM;
                XTICKLabel = {'LGN','V1'};
        end
        
        
        % stats Wilcoxson 
        for kk = 1:length(ValRP);
            [p(kk),h(kk)] = ranksum(ValCtl(:,kk),ValRP(:,kk),'alpha',0.01);
            [P(kk),H(kk)] = ranksum(ValCtl(:,kk),ValRP(:,kk),'alpha',0.05);
        end        
        
        %% plot
        subplot(2,3,pctl-1); hold on;
        
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
     saveas(gcf, sprintf('%s_FiberLength.png',property))
     saveas(gcf, sprintf('%s_FiberLength.eps',property),'psc2')
end
