function RP_DiffsivityPlot
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
if ~exist(TPdata)
    load '/Users/shumpei/Google Drive/RP/Tama2_TP_SD.mat'
end

%% Figure
% indivisual FA value along optic tract

% take values
fibID =3; %
sdID = 1;%:7
% make one sheet diffusivity.The value is merged both hemisphere.
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



%% ANOVA
Ctl_fa =  fa(Ctl,:);
RP_fa =  fa(RP,:);
CRD_fa =  fa(CRD,:);

for jj= 1: 100
    pac = nan(14,3);
    pac(:,1)= Ctl_fa(:,jj);
    pac(1:length(RP),2)= RP_fa(:,jj);
    pac(1:length(CRD),3)= CRD_fa(:,jj);
    [p(jj),~,stats(jj)] = anova1(pac,[],'off');
    co = multcompare(stats(jj),'display','off');
    C{jj}=co;
end
% % Portion =  p<0.01; % where is most effected
% Portion(p(p<=0.01));
%% t-test


%% Optic Tract
% FA
figure; hold on;
X = 1:100;
c = lines(100);

% put bars based on ANOVA (p<0.01)
bar(p(p<0.01)*500000,1.0)

% Control
st = nanstd(fa(Ctl,:),1);
m   = nanmean(fa(Ctl,:));

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

% add individual FA plot
for k = CRD %1:length(subDir)
    plot(X,fa(k,:),'Color',c(3,:),'linewidth',1);
end
m   = nanmean(fa(CRD,:));
plot(X,m,'Color',c(3,:) ,'linewidth',3)


% add individual
for k = RP %1:length(subDir)
    plot(X,fa(k,:),'Color',c(1,:),'linewidth',1);
end
% plot mean value
m   = nanmean(fa(RP,:));
plot(X,m,'Color',c(1,:) ,'linewidth',3)

% add label
xlabel('Location','fontName','Times','fontSize',14);
ylabel('Fractional anisotropy','fontName','Times','fontSize',14);
title('Optic tract','fontName','Times','fontSize',14)
axis([10, 90 ,0.0, 0.600001])

%% Optic tracrt
% AD
figure; hold on;
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

% add individual FA plot
for k = CRD %1:length(subDir)
    plot(X,ad(k,:),'Color',c(3,:),'linewidth',1);
end
m   = nanmean(ad(CRD,:));
plot(X,m,'Color',c(3,:) ,'linewidth',3)


% add individual
for k = RP %1:length(subDir)
    plot(X,ad(k,:),'Color',c(1,:),'linewidth',1);
end
% plot mean value
m   = nanmean(ad(RP,:));
plot(X,m,'Color',c(1,:) ,'linewidth',3)

% add label
xlabel('Location','fontName','Times','fontSize',14);
ylabel('Axial diffusivity','fontName','Times','fontSize',14);
title('Optic tract','fontName','Times','fontSize',14);
axis([10, 90 ,0.799999, 2.400001])

%% RD
figure; hold on;
% bar(1:100,Portion.*2.5, 1.0)

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
% add individual FA plot
for k = CRD %1:length(subDir)
    plot(X,rd(k,:),'Color',c(3,:),...
        'linewidth',1);
end
m   = nanmean(rd(CRD,:));
plot(X,m,'Color',c(3,:) ,'linewidth',3)


% rdd individual
for k = RP %1:length(subDir)
    plot(X,rd(k,:),'Color',c(1,:),'linewidth',1);
end
% plot mean value
m   = nanmean(rd(RP,:));
plot(X,m,'Color',c(1,:) ,'linewidth',3)

% add label
xlabel('Location','fontName','Times','fontSize',14);
ylabel('Radial diffusivity','fontName','Times','fontSize',14);
title('Optic tract','fontName','Times','fontSize',14);
% legend('CRD','RP')
axis([10, 90 ,0.399999, 1.600001])
%% OR
fibID = 1;
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

%% ANOVA
Ctl_fa =  fa(Ctl,:);
RP_fa =  fa(RP,:);
CRD_fa =  fa(CRD,:);

for jj= 1: 100
    pac = nan(14,3);
    pac(:,1)= Ctl_fa(:,jj);
    pac(1:length(RP),2)= RP_fa(:,jj);
    pac(1:length(CRD),3)= CRD_fa(:,jj);
    [p(jj),~,stats(jj)] = anova1(pac,[],'off');
    co = multcompare(stats(jj),'display','off');
    C{jj}=co;
end
Portion =  p<0.01; % where is most effected
%% OR FA
figure; hold on;

% put bars based on ANOVA (p<0.01)
bar(1:100,Portion,1.0)

% Control subjects data
st = nanstd(fa(Ctl,:),1);
m   = nanmean(fa(Ctl,:));

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

% plot mean value
plot(m,'color',[0 0 0], 'linewidth',3)

% individual FA
for k = CRD %1:length(subDir)
    plot(X,fa(k,:),'Color',c(3,:),'linewidth',1);
end
m   = nanmean(fa(CRD,:));
plot(X,m,'Color',c(3,:) ,'linewidth',2)


% add individual plot
for k = RP %1:length(subDir)
    plot(X,fa(k,:),'Color',c(1,:),'linewidth',1);
end
% plot mean value
m   = nanmean(fa(RP,:));
plot(X,m,'Color',c(1,:) ,'linewidth',2)

% add labels
xlabel('Location','fontName','Times','fontSize',14);
ylabel('Fractional anisotropy','fontName','Times','fontSize',14);
axis([10, 90 ,0.1999, 0.750001])
title('Optic radiation','fontName','Times','fontSize',14)


%% Optic Radiation AD
X = 1:100;      % noumber of nodes
c = lines(100); % line colors

% AD
figure; hold on;
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

% add individual FA plot
for k = CRD %1:length(subDir)
    plot(X,ad(k,:),'Color',c(3,:),...
        'linewidth',1);
end
m   = nanmean(ad(CRD,:));
plot(X,m,'Color',c(3,:) ,'linewidth',3)


% add individual
for k = RP %1:length(subDir)
    plot(X,ad(k,:),'Color',c(1,:),'linewidth',1);
end
% plot mean value
m   = nanmean(ad(RP,:));
plot(X,m,'Color',c(1,:) ,'linewidth',3)

% add label
xlabel('Location','fontName','Times','fontSize',14);
ylabel('Axial diffusivity','fontName','Times','fontSize',14);
title('Optic radiation','fontName','Times','fontSize',14);
axis([10, 90 ,0.899999, 1.700001])

%% RD
figure; hold on;
% bar(1:100,Portion.*2.5, 1.0)

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
% add individual FA plot
for k = CRD %1:length(subDir)
    plot(X,rd(k,:),'Color',c(3,:),...
        'linewidth',1);
end
m   = nanmean(rd(CRD,:));
plot(X,m,'Color',c(3,:) ,'linewidth',3)


% rdd individual
for k = RP %1:length(subDir)
    plot(X,rd(k,:),'Color',c(1,:),'linewidth',1);
end
% plot mean value
m   = nanmean(rd(RP,:));
plot(X,m,'Color',c(1,:) ,'linewidth',3)

% add label
xlabel('Location','fontName','Times','fontSize',14);
ylabel('Radial diffusivity','fontName','Times','fontSize',14);
title('Optic Radiation','fontName','Times','fontSize',14);
axis([10, 90 ,0.3499999, 0.800001])

%% End


