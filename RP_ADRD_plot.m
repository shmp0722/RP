function RP_ADRD_plot
% Plot figure 6 showing individual ad and rd value along the core of OR and optic tract.
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

%% Load TractProfile data

TPdata = fullfile('/biac4/wandell/biac2/wandell/data/DWI-Tamagawa-Japan2/results/Tama2_TP_SD.mat');
if exist(TPdata)
    load(TPdata)
else
    load '/Users/shumpei/Google Drive/RP/Tama2_TP_SD.mat'
end

%% Figure 6
% take values from TractProfile structure
fibID =3;%4:6 %ROR
sdID = 1;%:7
% make one diffusivities value sheet
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

%% Wilcoxon

ValCtl = ad(Ctl,:);
ValRP  = ad(RP,:);
% Wilcoxon
for ii = 1:length(ValRP);
    [p(ii),h(ii)] = ranksum(ValCtl(:,ii),ValRP(:,ii),'alpha',0.05);
end

%% Optic Tract
% FA
% figure; hold on;
mrvNewGraphWin;
subplot(2,2,1);hold on;
X = 1:100;
c = lines(100);

% bars where is significant difference between two groups
% p<0.05
bar(1:100,h*5,1,'EdgeColor','none','facecolor',[0.8 0.7 0.3])


% Optic tracrt
X = 1:100;      % noumber of nodes
c = lines(100); % line colors

% AD

% bar(1:100,Portion.*3,1.0)

% Control
st = nanstd(ad(Ctl,:),1);
m   = nanmean(ad(Ctl,:));

% render area plot
A3 = area(m+2*st);
A1 = area(m+st);
A2 = area(m-st);
A4 = area(m-2*st);

% set color and style
set(A1,'FaceColor',[0.6 0.6 0.6],'linestyle','none')
set(A2,'FaceColor',[0.8 0.8 0.8],'linestyle','none')
set(A3,'FaceColor',[0.8 0.8 0.8],'linestyle','none')
set(A4,'FaceColor',[1 1 1],'linestyle','none')
% add avarage
plot(m,'color',[0 0 0], 'linewidth',3 )

% add individual
for k = RP %1:length(subDir)
    plot(X,ad(k,:),'Color',c(5,:),'linewidth',1);
end
% plot mean value
m   = nanmean(ad(RP,:));
plot(X,m,'Color',c(5,:) ,'linewidth',3)

% add label

set(gca,'ylim',[0.8 2.4], 'ytick',[0.8 2.4],'xlim',[10 90],'xtick',[10 90],...
    'xtickLabel',{'OC','LGN'},'tickDir','out')
xlabel('Location','fontName','Times','fontSize',14);
ylabel('Axial diffusivity','fontName','Times','fontSize',14);
title('Optic tract','fontName','Times','fontSize',14);
% axis([10, 90 ,0.799999, 2.400001])

%% RD
subplot(2,2,2); hold on;

% Wilcoxon

ValCtl = rd(Ctl,:);
ValRP  = rd(RP,:);
% Wilcoxon
for ii = 1:length(ValRP);
    [p(ii),h(ii)] = ranksum(ValCtl(:,ii),ValRP(:,ii),'alpha',0.05);
end

% bars where is significant difference between two groups
% p<0.05
bar(1:100,h*5,1,'EdgeColor','none','facecolor',[0.8 0.7 0.3])

% Control
st = nanstd(rd(Ctl,:),1);
m   = nanmean(rd(Ctl,:));

% render area plot
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
%     plot(X,rd(k,:),'Color',c(3,:),...
%         'linewidth',1);
% end
% m   = nanmean(rd(CRD,:));
% plot(X,m,'Color',c(3,:) ,'linewidth',3)


% rdd individual
for k = RP %1:length(subDir)
    plot(X,rd(k,:),'Color',c(5,:),'linewidth',1);
end
% plot mean value
m   = nanmean(rd(RP,:));
plot(X,m,'Color',c(5,:) ,'linewidth',3)

% add label
xlabel('Location','fontName','Times','fontSize',14);
ylabel('Radial diffusivity','fontName','Times','fontSize',14);
title('Optic tract','fontName','Times','fontSize',14);
% axis([10, 90 ,0.299999, 1.700001])
set(gca,'ylim',[0.3 1.7], 'ytick',[0.3 1.7],'xlim',[10 90],'xtick',[10 90],...
    'xtickLabel',{'OC','LGN'},'tickDir','out')
%% OR
fibID = 1;
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


%% OR
subplot(2,2,3); hold on;
% Wilcoxon

ValCtl = ad(Ctl,:);
ValRP  = ad(RP,:);
% Wilcoxon
for ii = 1:length(ValRP);
    [p(ii),h(ii)] = ranksum(ValCtl(:,ii),ValRP(:,ii),'alpha',0.05);
end

% bars where is significant difference between two groups
% p<0.05
bar(1:100,h*5,1,'EdgeColor','none','facecolor',[0.8 0.7 0.3])
% Control
st = nanstd(ad(Ctl,:),1);
m   = nanmean(ad(Ctl,:));

% render area plot
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
%     plot(X,ad(k,:),'Color',c(3,:),...
%         'linewidth',1);
% end
% m   = nanmean(ad(CRD,:));
% plot(X,m,'Color',c(3,:) ,'linewidth',2)

% add individual
for k = RP %1:length(subDir)
    plot(X,ad(k,:),'Color',c(5,:),'linewidth',1);
end
% plot mean value
m   = nanmean(ad(RP,:));
plot(X,m,'Color',c(5,:) ,'linewidth',2)

% add label
xlabel('Location','fontName','Times','fontSize',14);
ylabel('Axial diffusivity','fontName','Times','fontSize',14);
% axis([10, 90, 0.89999, 1.70001])
title('Optic radiation','fontName','Times','fontSize',14);

set(gca,'ylim', [0.9 1.7],'ytick',[0.9 1.7],'xlim',[10 90],'xtick',[10 90],...
    'xtickLabel',{'OC','LGN'},'tickDir','out')

%% RD
subplot(2,2,4); hold on;

% Wilcoxon

ValCtl = rd(Ctl,:);
ValRP  = rd(RP,:);
% Wilcoxon
for ii = 1:length(ValRP);
    [p(ii),h(ii)] = ranksum(ValCtl(:,ii),ValRP(:,ii),'alpha',0.05);
end

% bars where is significant difference between two groups
% p<0.05
bar(1:100,h*5,1,'EdgeColor','none','facecolor',[0.8 0.7 0.3])

% Control
st = nanstd(rd(Ctl,:),1);
m   = nanmean(rd(Ctl,:));

% render area plot
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
%     plot(X,rd(k,:),'Color',c(3,:),...
%         'linewidth',1);
% end
% m   = nanmean(rd(CRD,:));
% plot(X,m,'Color',c(3,:) ,'linewidth',3)


% rdd individual
for k = RP %1:length(subDir)
    plot(X,rd(k,:),'Color',c(5,:),'linewidth',1);
end
% plot mean value
m   = nanmean(rd(RP,:));
plot(X,m,'Color',c(5,:) ,'linewidth',3)

% add label
xlabel('Location','fontName','Times','fontSize',14);
ylabel('Radial diffusivity','fontName','Times','fontSize',14);
% axis([10, 90 ,0.3, 0.8])
title('Optic radiation','fontName','Times','fontSize',14);
set(gca,'ylim', [0.3, 0.8],'ytick',[0.3, 0.8],'xlim',[10 90],'xtick',[10 90],...
    'xtickLabel',{'OC','LGN'},'tickDir','out')
%% End
saveas(gcf,'ADRD.png')
saveas(gcf,'ADRD.eps','psc2')
