function RenderROC_Tama2(p_value,Pathway)
% Render ROC curve by four type of diffusivity and ANOVA p value
% Example
% p_value = 0.01;
% Pathway = 'OR';
% RenderROC_Tama1(p_value,Pathway)

%%
% homeDir = '/biac4/wandell/biac2/wandell/data/DWI-Tamagawa-Japan';
subDir = {...
    'JMD1-MM-20121025-DWI'
    'JMD3-AK-20121026-DWI'
    'JMD5-KK-20121220-DWI'
    'JMD6-NO-20121220-DWI'
    'JMD2-KK-20121025-DWI'
    'JMD4-AM-20121026-DWI'
    'JMD7-YN-20130621-DWI'
    'JMD8-HT-20130621-DWI'
    'JMD9-TY-20130621-DWI'
    'LHON1-TK-20121130-DWI'
    'LHON2-SO-20121130-DWI'
    'LHON3-TO-20121130-DWI'
    'LHON4-GK-20121130-DWI'
    'LHON5-HS-20121220-DWI'
    'LHON6-SS-20121221-DWI'
    'JMD-Ctl-MT-20121025-DWI'
    'JMD-Ctl-YM-20121025-DWI'
    'JMD-Ctl-SY-20130222DWI'
    'JMD-Ctl-HH-20120907DWI'
    'JMD-Ctl-HT-20120907-DWI'
    'JMD-Ctl-FN-20130621-DWI'
    'JMD-Ctl-AM-20130726-DWI'
    'JMD-Ctl-SO-20130726-DWI'
    'RP1-TT-2013-11-01'
    'RP2-KI-2013-11-01'
    'RP3-TO-13120611-DWI'
    'LHON6-SS-20131206-DWI'
    'RP4-AK-2014-01-31'
    'RP5-KS-2014-01-31'
    'JMD3-AK-20140228-dMRI'
    'JMD-Ctl-09-RN-20130909'
    'JMD-Ctl-10-JN-20140205'
    'JMD-Ctl-11-MT-20140217'
    'RP6-SY-2014-02-28-dMRI'
    'Ctl-12-SA-20140307'
    'Ctl-13-MW-20140313-dMRI-Anatomy'
    'Ctl-14-YM-20140314-dMRI-Anatomy'
    'RP7-EU-2014-03-14-dMRI-Anatomy'
    'RP8-YT-2014-03-14-dMRI-Anatomy'};

%% Load TractProfile
cd /biac4/wandell/biac2/wandell/data/DWI-Tamagawa-Japan2/results

load Tama2_Percentile.mat
%% classify all subjects intogroups
JMD = 1:4;
CRD = 5:9;
% LHON = 10:15;
LHON = [10:14,27];

Ctl = [16:23,31:33,35:37];
RP = [24:26,28,29,34,38,39];
fgN ={'ROR1206_D4L4.pdb','LOR1206_D4L4.pdb','ROTD4L4_1206.pdb','LOTD4L4_1206.pdb'};
c = lines(100);

%%  specific part (ANOVA, p,0.01)
P = [1.0 0.05 0.03 0.01 0.001];

% labels
labels = {};
% labels{1:length(M_Ctl.fa)} = 'Ctl';
for ii = 1:length(Ctl)
    labels{ii} = 'Ctl';
end
for ii = 1:length(LHON)
    labels{length(Ctl)+ii} = 'LHON';
end
%% choose pathway
Pathway = 'OR';
% Pathway = 'OT';

%% make diffusivity sheet
switch Pathway
    case 'OR'
        fibID = 1;
        fibN = 'OR';
    case 'OT'
        fibID = 3;
        fibN = 'OT';
end %OR = 1, OT =3

sdID = 1;%:7

% make one sheet diffusivities
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

%% diffusivitis in each group
Ctl_fa =  fa(Ctl,:);
LHON_fa =  fa(LHON,:);
CRD_fa =  fa(CRD,:);

Ctl_md =  md(Ctl,:);
LHON_md =  md(LHON,:);
CRD_md =  md(CRD,:);

Ctl_ad  =  ad(Ctl,:);
LHON_ad =  ad(LHON,:);
CRD_ad  =  ad(CRD,:);

Ctl_rd  =  rd(Ctl,:);
LHON_rd =  rd(LHON,:);
CRD_rd  =  rd(CRD,:);

% ANOVA the nodes significant different across 3 groups
for jj= 1: 100
    %fa
    pac = nan(14,3);
    pac(:,1)= Ctl_fa(:,jj);
    pac(1:6,2)= LHON_fa(:,jj);
    pac(1:5,3)= CRD_fa(:,jj);
    p_fa(jj) = anova1(pac,[],'off');
    
    %md
    pac = nan(14,3);
    pac(:,1)= Ctl_md(:,jj);
    pac(1:6,2)= LHON_md(:,jj);
    pac(1:5,3)= CRD_md(:,jj);
    p_md(jj) = anova1(pac,[],'off');
    
    %ad
    pac = nan(14,3);
    pac(:,1)= Ctl_ad(:,jj);
    pac(1:6,2)= LHON_ad(:,jj);
    pac(1:5,3)= CRD_ad(:,jj);
    p_ad(jj) = anova1(pac,[],'off');
    
    %rd
    pac = nan(14,3);
    pac(:,1)= Ctl_rd(:,jj);
    pac(1:6,2)= LHON_rd(:,jj);
    pac(1:5,3)= CRD_rd(:,jj);
    p_rd(jj) = anova1(pac,[],'off');
end

%% Compare ROC across diffusivities
c=lines(5);
for k=1:length(P)
    figure;hold on;
    p_value = P(k);
    % pick up the node by ANOVA p_palue
    Portion_fa =  p_fa <= p_value;
    Portion_md =  p_md <= p_value;
    Portion_ad =  p_ad <= p_value;
    Portion_rd =  p_rd <= p_value;
    
    % Ctl
    M_Ctl = struct;
    M_Ctl.fa = nanmean(fa(Ctl,Portion_fa),2);
    M_Ctl.md = nanmean(md(Ctl,Portion_md),2);
    M_Ctl.ad = nanmean(ad(Ctl,Portion_ad),2);
    M_Ctl.rd = nanmean(rd(Ctl,Portion_rd),2);
    
    %
    M_LHON = struct;
    M_LHON.fa = nanmean(fa(LHON,Portion_fa),2);
    M_LHON.md = nanmean(md(LHON,Portion_md),2);
    M_LHON.ad = nanmean(ad(LHON,Portion_ad),2);
    M_LHON.rd = nanmean(rd(LHON,Portion_rd),2);
    
    %% ROC using FUNCTION perfcurve
    % diagnosis; 0 = Ctl, 1 = LHON
    % labels = zeros(1,length(M_Ctl.fa)+length(M_LHON.fa));
    % labels(1,length(M_Ctl.fa)+1:length(M_Ctl.fa)+length(M_LHON.fa))=1;
    
    % scores
    scores = {vertcat(M_Ctl.fa,M_LHON.fa),vertcat(M_Ctl.md,M_LHON.md),...
        vertcat(M_Ctl.ad,M_LHON.ad),vertcat(M_Ctl.rd,M_LHON.rd)};
    
    % Render ROC
    if fibID==1;
        for ii = 1:4;% "fa,md,ad,rd"
            switch ii
                case {2,3,4}
                    [FPR,TPR,~,AUC(k,ii),~,~,~] = perfcurve(labels',scores{ii},'LHON');
                    h(ii)=   plot(FPR,TPR,'color',c(ii,:),'linewidth',2);
                case {1}
                    [FPR,TPR,T,AUC(k,ii),OPTROCPT,~,~] = perfcurve(labels',scores{ii},'Ctl');
                    h(ii)= plot(FPR,TPR,'color',c(ii,:));
            end
        end
    else
        for ii = 1:4;% "fa,md,ad,rd"
            switch ii
                case 3
                    if k==1
                        [FPR,TPR,~,AUC(ii),~,~,~] = perfcurve(labels',scores{ii},'Ctl');
                        h(ii)=   plot(FPR,TPR,'color',c(ii,:),'linewidth',2);
                    else
                        [FPR,TPR,~,AUC(ii),~,~,~] = perfcurve(labels',scores{ii},'LHON');
                        h(ii)=   plot(FPR,TPR,'color',c(ii,:),'linewidth',2);
                    end
                case {2,4}
                    [FPR,TPR,~,AUC(ii),~,~,~] = perfcurve(labels',scores{ii},'LHON');
                    h(ii)=   plot(FPR,TPR,'color',c(ii,:),'linewidth',2);
                case {1}
                    [FPR,TPR,T,AUC(k,ii),OPTROCPT,~,~] = perfcurve(labels',scores{ii},'Ctl');
                    h(ii)= plot(FPR,TPR,'color',c(ii,:),'linewidth',2);
            end
        end
    end
    
    
    legend('fa', 'md', 'ad', 'rd');
    plot([0 1],[0 1],'k','linewidth',1)
    
    
    title(sprintf('ROC %s %s %d', fibN,'P =',p_value))
    axis('square')
    set(gca,'tickdir','out','color','w')
    
    %% save figure
    cd /biac4/wandell/biac2/wandell/data/DWI-Tamagawa-Japan2/results/ROC_plot
    print(gcf,'-depsc',sprintf('ROC%s%s%d', fibN,'P',p_value))
    
    if fibID==1;
        save AUC_OR AUC
    else
        save AUC_OT AUC
    end
    clear AUC
end
% return
% % 
% %% sample
% fh = figure('name','RoC','color','w');
% plot(TPF,FPF,'color',c(2,:),'linewidth',2);
% hold on
% plot([0 1],[0 1],'k','linewidth',1)
% title(sprintf('ROC %s %s %s', fibN,'MD',p_value))
% axis('square')
% set(gca,'tickdir','out')
% %print(fh,figname)
% 
% %%

%% Compare ROC across P_value
c=lines(5);
for ii = 1:4
    figure;hold on;

    for  k=1:length(P)
        p_value = P(k);
        % pick up the node by ANOVA p_palue
        Portion_fa =  p_fa <= p_value;
        Portion_md =  p_md <= p_value;
        Portion_ad =  p_ad <= p_value;
        Portion_rd =  p_rd <= p_value;
        
        % Ctl
        M_Ctl = struct;
        M_Ctl.fa = nanmean(fa(Ctl,Portion_fa),2);
        M_Ctl.md = nanmean(md(Ctl,Portion_md),2);
        M_Ctl.ad = nanmean(ad(Ctl,Portion_ad),2);
        M_Ctl.rd = nanmean(rd(Ctl,Portion_rd),2);
        
        %
        M_LHON = struct;
        M_LHON.fa = nanmean(fa(LHON,Portion_fa),2);
        M_LHON.md = nanmean(md(LHON,Portion_md),2);
        M_LHON.ad = nanmean(ad(LHON,Portion_ad),2);
        M_LHON.rd = nanmean(rd(LHON,Portion_rd),2);
        
        %% ROC using FUNCTION perfcurve
        % scores
        scores = {vertcat(M_Ctl.fa,M_LHON.fa),vertcat(M_Ctl.md,M_LHON.md),...
            vertcat(M_Ctl.ad,M_LHON.ad),vertcat(M_Ctl.rd,M_LHON.rd)};
        
        % Render ROC        
        %     for ii = 1:4;% "fa,md,ad,rd"
        if fibID==1;
            switch ii
                case 3
                    if k==1
                        [FPR,TPR,~,AUC(k,ii),~,~,~] = perfcurve(labels',scores{ii},'Ctl');
                        h(ii)=   plot(FPR,TPR,'color',c(k,:),'linewidth',2);
                    else
                        [FPR,TPR,~,AUC(k,ii),~,~,~] = perfcurve(labels',scores{ii},'LHON');
                        h(ii)=   plot(FPR,TPR,'color',c(k,:),'linewidth',2);
                    end
                case {2,4}
                    [FPR,TPR,~,AUC(k,ii),~,~,~] = perfcurve(labels',scores{ii},'LHON');
                    h(ii)=   plot(FPR,TPR,'color',c(k,:),'linewidth',2);
                case {1}
                    [FPR,TPR,T,AUC(k,ii),OPTROCPT,~,~] = perfcurve(labels',scores{ii},'Ctl');
                    h(ii)= plot(FPR,TPR,'color',c(k,:),'linewidth',2);
            end
            
        else
            switch ii
                case 1
                    [FPR,TPR,T,AUC(k,ii),OPTROCPT,~,~] = perfcurve(labels',scores{ii},'Ctl');
                    h(ii)= plot(FPR,TPR,'color',c(k,:),'linewidth',2);
                case {2,4}
                    [FPR,TPR,~,AUC(k,ii),~,~,~] = perfcurve(labels',scores{ii},'LHON');
                    h(ii)=   plot(FPR,TPR,'color',c(k,:),'linewidth',2);
                case 3
                    if k==1
                        [FPR,TPR,~,AUC(k,ii),~,~,~] = perfcurve(labels',scores{ii},'Ctl');
                        h(ii)=   plot(FPR,TPR,'color',c(k,:),'linewidth',2);
                    else
                        [FPR,TPR,~,AUC(k,ii),~,~,~] = perfcurve(labels',scores{ii},'LHON');
                        h(ii)=   plot(FPR,TPR,'color',c(k,:),'linewidth',2);
                    end
            end
        end        
    end
    
    % legend('fa', 'md', 'ad', 'rd');
    legend('1.0','0.05','0.03','0.01','0.001');
    plot([0 1],[0 1],'k','linewidth',1)
    
    Dif = {'fa', 'md', 'ad', 'rd'};
    title(sprintf('ROC %s %s %s', fibN,Dif{ii}))
    axis('square')
    set(gca,'tickdir','out','color','w')
    hold off;
    
     %% save figure
    cd /biac4/wandell/biac2/wandell/data/DWI-Tamagawa-Japan2/results/ROC_plot
    print(gcf,'-depsc',sprintf('ROC_%s_%s_%s', fibN,Dif{ii}))
end

return




%%
% % Let's calculate d'
%
% [zCtl,muCtl,sigmaCtl] = zscore(nanmean(Ctl_fa));
% [zCtl2,muCtl2,sigmaCtl2] = zscore(Ctl_fa);
%
%
% [zCRD,muCRD,sigmaCRD] = zscore(nanmean(CRD_fa));
% [zCRD2,muCRD2,sigmaCRD2] = zscore(CRD_fa);
%
%
% [zLHON,muLHON,sigmaLHON] = zscore(nanmean(LHON_fa));
% [zLHON2,muLHON2,sigmaLHON2] = zscore(LHON_fa);
%
% % z-score in OR
% figure; hold on;
% plot(zCtl,'Color',[0.6 0.6 0.6],'linewidth',2)
% plot(zCRD,'Color',c(3,:),'linewidth',2)
% plot(zLHON,'Color',c(4,:),'linewidth',2)
%
% title('FA z-score in OR across groups')
%
% % z-score
% figure; hold on;
% plot(zCtl2','Color',[0.6 0.6 0.6])
% plot(zCRD2','Color',c(3,:))
% plot(zLHON2','Color',c(4,:))
%
% title('FA z-score in OR across groups')
%
% % d prime
% dprime_CRD  = (muCtl-muCRD)/(sqrt(abs(sigmaCtl^2-sigmaCRD^2)*0.5));
% dprime_LHON = (muCtl-muLHON)/(sqrt((sigmaLHON^2-sigmaCtl^2)*0.5));
%
% % d prime2
% dprime_CRD2  = (muCtl2-muCRD2)./(sqrt(abs(sigmaCtl2.^2-sigmaCRD2.^2)*0.5));
% dprime_LHON2 = (muCtl2-muLHON2)./(sqrt(abs(sigmaLHON2.^2-sigmaCtl2.^2)*0.5));

%
% figure; hold on;
% % plot(zCtl2','Color',[0.6 0.6 0.6])
% plot(dprime_CRD2','Color',c(3,:))
% plot(dprime_LHON2','Color',c(4,:))
% title('d-prime in OR across groups')
% xlabel('location')
%
%
% figure; hold on;
% % plot(zCtl2','Color',[0.6 0.6 0.6])
% plot(dprime_CRD2(Portion)','Color',c(3,:))
% plot(dprime_LHON2(Portion)','Color',c(4,:))
% title('d-prime in OR across groups')
% xlabel('location')

% %% diffusivitis in each group
% Ctl_rd =  rd(Ctl,:);
% LHON_rd =  rd(LHON,:);
% CRD_rd =  rd(CRD,:);
%
% % ANOVA the nodes significant different across 3 groups
% for jj= 1: 100
%     pac = nan(14,3);
%     pac(:,1)= Ctl_rd(:,jj);
%     pac(1:6,2)= LHON_rd(:,jj);
%     pac(1:5,3)= CRD_rd(:,jj);
%     p_fa(jj) = anova1(pac,[],'off');
% end
% % significantly different across three groups
% Portion =  p_fa<0.01; % OR rd 47-100
% %% Let's calculate d'
%
% [zCtl,muCtl,sigmaCtl] = zscore(nanmean(Ctl_fa));
% [zCtl2,muCtl2,sigmaCtl2] = zscore(Ctl_fa);
%
%
% [zCRD,muCRD,sigmaCRD] = zscore(nanmean(CRD_fa));
% [zCRD2,muCRD2,sigmaCRD2] = zscore(CRD_fa);
%
%
% [zLHON,muLHON,sigmaLHON] = zscore(nanmean(LHON_fa));
% [zLHON2,muLHON2,sigmaLHON2] = zscore(LHON_fa);
%
% % z-score in OR
% figure; hold on;
% plot(zCtl,'Color',[0.6 0.6 0.6],'linewidth',2)
% plot(zCRD,'Color',c(3,:),'linewidth',2)
% plot(zLHON,'Color',c(4,:),'linewidth',2)
%
% title('FA z-score in OR across groups')
%
% % z-score
% figure; hold on;
% plot(zCtl2','Color',[0.6 0.6 0.6])
% plot(zCRD2','Color',c(3,:))
% plot(zLHON2','Color',c(4,:))
%
% title('FA z-score in OR across groups')
%
% % d prime
% dprime_CRD  = (muCtl-muCRD)/(sqrt(abs(sigmaCtl^2-sigmaCRD^2)*0.5));
% dprime_LHON = (muCtl-muLHON)/(sqrt((sigmaLHON^2-sigmaCtl^2)*0.5));
%
% % d prime2
% dprime_CRD2  = (muCtl2-muCRD2)./(sqrt(abs(sigmaCtl2.^2-sigmaCRD2.^2)*0.5));
% dprime_LHON2 = (muCtl2-muLHON2)./(sqrt(abs(sigmaLHON2.^2-sigmaCtl2.^2)*0.5));
%
% %
% figure; hold on;
% % plot(zCtl2','Color',[0.6 0.6 0.6])
% plot(dprime_CRD2','Color',c(3,:))
% plot(dprime_LHON2','Color',c(4,:))
% title('d-prime in OR across groups')
% xlabel('location')
%
%
% figure; hold on;
% % plot(zCtl2','Color',[0.6 0.6 0.6])
% plot(dprime_CRD2(Portion)','Color',c(3,:))
% plot(dprime_LHON2(Portion)','Color',c(4,:))
% title('d-prime in OR across groups')
% xlabel('location')
%
% %%
% zCtl(Portion)
% zLHON(Portion)
% X =1:sum(Portion);
% figure; hold on;
% plot(X,zCtl(Portion),'Color',[0.8 0.8 0.8])
% plot(X,zLHON(Portion),'Color',c(4,:))
% plot(X,zCRD(Portion),'Color',c(3,:))
%
% title('z-score in OR (ANOVA, p,0.01) across groups')
%
% %% ROC
% scores = horzcat(zCtl(Portion),zLHON(Portion));
% y = zeros(1,length(X)*2);
% y(length(X)+1:2*length(X))=1;
% labels = y;
% ROC(scores,labels);
% title('fa z-score')
%
% [X,Y,T,AUC,OPTROCPT,SUBY,SUBYNAMES] = perfcurve(labels,scores,1);
% plot(X,Y)
% xlabel('False positive rate'); ylabel('True positive rate')
% title('ROC for classification by FA')
%
% %% ROC curve
%
% % delta
% delta_LHON = abs(zLHON(Portion)-zCtl(Portion));
% delta_CRD  = abs(zCRD(Portion)-zCtl(Portion));
%
% figure; hold on;
% plot(X,delta_LHON,'Color',c(4,:),'linewidth',2)
% plot(X,delta_CRD,'Color',c(3,:),'Linewidth',2)
%
% %%
% scores = zLHON;
% labels = round(rand(1,47));
%
% ROC(scores,labels);
% %% ROC by FA in specific part
% % P = [1.0 0.05 0.03 0.01 0.001];
% % for k = 1:length(P)
% %     p_value = P(k);
% scores = vertcat(M_Ctl.fCutoffa,M_LHON.fa);
% M = sort(scores);
%
% for ii=1:length(M)
%     Cutoff = M(ii);
%     TP(ii)= sum(M_LHON.fa<=Cutoff);
%     TN(ii) = sum(M_Ctl.fa>=Cutoff);
%
%     TPF(ii) = TP(ii)/length(M_LHON.fa);
%     FPF(ii) = 1-TN(ii)/length(M_Ctl.fa);
%
% end
% figure; hold on;
% plot(TPF,FPF,'color',c(1,:))
% title(sprintf('ROC %s %s %s', fibN,'FA',p_value))
% % end
%
%
% % ROC by MD in specific part
% scores = vertcat(M_Ctl.md,M_LHON.md);
% M = sort(scores);
%
% for ii=1:length(M)
%     Cutoff = M(ii);
%     TP = M_LHON.md <= Cutoff;
%     TN = M_Ctl.md >= Cutoff;
%
%     TPF(ii) = sum(TP)/length(M_LHON.md);
%     FPF(ii) = 1-sum(TN)/length(M_Ctl.md);
% end
% fh = figure('name','RoC','color','w');
% plot(TPF,FPF,'color',c(2,:),'linewidth',2);
% hold on
% plot([0 1],[0 1],'k','linewidth',1)
% title(sprintf('ROC %s %s %s', fibN,'MD',p_value))
% axis('square')
% set(gca,'tickdir','out')
% %print(fh,figname)
%
% % ROC by AD in specific part
% scores = vertcat(M_Ctl.ad,M_LHON.ad);
% M = sort(scores);
%
% for ii=1:length(M)
%     Cutoff = M(ii);
%     TP = M_LHON.ad >= Cutoff;
%     TN = M_Ctl.ad <= Cutoff;
%
%     TPF(ii) = sum(TP)/length(M_LHON.ad);
%     FPF(ii) = 1-sum(TN)/length(M_Ctl.ad);
%
% end
%
% figure;
% plot(TPF,FPF,'color',c(3,:))
% title(sprintf('ROC %s %s %s', fibN,'AD',p_value))
%
%
% % ROC by RD in specific part
% scores = vertcat(M_Ctl.rd,M_LHON.rd);
% M = sort(scores);
%
% for ii=1:length(M)
%     Cutoff = M(ii);
%     TP = M_LHON.rd<=Cutoff;
%     TN = M_Ctl.rd>=Cutoff;
%     TPF(ii) = sum(TP)/length(M_LHON.rd);
%     FPF(ii) = 1-sum(TN)/length(M_Ctl.rd);
% end
% % figure;
% plot(TPF,FPF,'color',c(4,:))
% title(sprintf('ROC %s %s %s', fibN,'RD',p_value))
%
%
% % % add
% % title('ROC by different diffusivity')
% % legend('FA','MD','AD','RD')
% %
% % hold off;
