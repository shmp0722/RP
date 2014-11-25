function IndividualPlot_Tama2


%%
[homeDir,subDir,JMD,CRD,Ctl,RP] = Tama_subj2;

% %% Load TractProfile data
% TPdata = fullfile('/biac4/wandell/biac2/wandell/data/DWI-Tamagawa-Japan2/results/Tama2_TP_SD.mat');
% load(TPdata)

%% Load TractProfile

cd /biac4/wandell/biac3/wandell7/shumpei/matlab/git/LHON/3RP
load 3RP_3SD_TractProfile.mat
%%
fgN ={'ROR1206_D4L4.pdb','LOR1206_D4L4.pdb','ROTD4L4_1206.pdb','LOTD4L4_1206.pdb'};%,...
%     'ROTD3L2_1206.pdb','LOTD3L2_1206.pdb'};

% Render plots which comparing CRD ,LHON, Ctl
% Y=nan(length(subDir),100);
X = 1:100;
c = lines(100);
%%
fibID =3;%4:6 %ROR
sdID = 1;%:7
%%% make one sheet diffusivities
% for subID = 1:length(subDir);
%     if isempty(TractProfile{subID,fibID}{sdID}.nfibers);
%         fa(subID,:) =nan(1,100);
%     else
%         fa(subID,:) =  TractProfile{subID,fibID}{sdID}.vals.fa;
%     end;
%     
%     if isempty(TractProfile{subID,fibID}{sdID}.nfibers);
%         md(subID,:) =nan(1,100);
%     else
%         md(subID,:) =  TractProfile{subID,fibID}{sdID}.vals.md;
%     end;
%     
%     if isempty(TractProfile{subID,fibID}{sdID}.nfibers);
%         rd(subID,:) =nan(1,100);
%     else
%         rd(subID,:) =  TractProfile{subID,fibID}{sdID}.vals.rd;
%     end;
%     
%     if isempty(TractProfile{subID,fibID}{sdID}.nfibers);
%         ad(subID,:) =nan(1,100);
%     else
%         ad(subID,:) =  TractProfile{subID,fibID}{sdID}.vals.ad;
%     end;
% end
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
%% Individual plot

for k = 1:length(subDir)
    figure; 
    % FA
    subplot(2,2,1)
    hold on;
    % Control
    st = nanstd(fa(Ctl,:),1);
    m   = nanmean(fa(Ctl,:));
    
    A3 = area(m+2*st);
    A1 = area(m+st);
    A2 = area(m-st);
    A4 = area(m-2*st);
    
    set(A1,'FaceColor',[0.8 0.8 0.8],'linestyle','none')
    set(A2,'FaceColor',[0.9 0.9 0.9],'linestyle','none')
    set(A3,'FaceColor',[0.9 0.9 0.9],'linestyle','none')
    set(A4,'FaceColor',[1 1 1],'linestyle','none')
    
    % add individual plot
    
    plot(X,fa(k,:),'Color',c(k,:),...
        'linewidth',2);
    % add label
    xlabel('Location','fontName','Times','fontSize',14);
    ylabel('Fractional anisotropy','fontName','Times','fontSize',14);
    
    title(sprintf('%s-%s',subDir{k}(1:6),fgN{fibID}(2:3)),'fontName','Times','fontSize',14)

    
%     switch k
%         case {1,2,3,4}
%             title(sprintf('JMD%d-%s',k,fgN{fibID}(2:3)),'fontName','Times','fontSize',14)
%         case {5,6,7,8,9}
%             title(sprintf('CRD%d-%s',k-4,fgN{fibID}(2:3)),'fontName','Times','fontSize',14)
%         case {10,11,12,13,14,15}
%             title(sprintf('LHON%d-%s',k-9,fgN{fibID}(2:3)),'fontName','Times','fontSize',14)
%         case {16,17,18,19,20,21,22,23,31,32,33,35,36,37}
%             if k <30
%                 title(sprintf('Ctl%d-%s',k-15,fgN{fibID}(2:3)),'fontName','Times','fontSize',14)
%             elseif 30<k<34
%                 title(sprintf('Ctl%d-%s',k-22,fgN{fibID}(2:3)),'fontName','Times','fontSize',14)
%             else k>34
%                 title(sprintf('Ctl%d-%s',k-22,fgN{fibID}(2:3)),'fontName','Times','fontSize',14)
%             end
% 
%         case {24,25,26,28,29,34,38,39}
%             title(sprintf('RP%d-%s',k,fgN{fibID}(2:3)),'fontName','Times','fontSize',14)
% 
%     end

    % MD
    subplot(2,2,2)
    hold on;
    st = nanstd(md(Ctl,:),1);
    m   = nanmean(md(Ctl,:));
    
    A3 = area(m+2*st);
    A1 = area(m+st);
    A2 = area(m-st);
    A4 = area(m-2*st);
    
    set(A1,'FaceColor',[0.8 0.8 0.8],'linestyle','none')
    set(A2,'FaceColor',[0.9 0.9 0.9],'linestyle','none')
    set(A3,'FaceColor',[0.9 0.9 0.9],'linestyle','none')
    set(A4,'FaceColor',[1 1 1],'linestyle','none')
    
    % add individual plot
    
    plot(X,md(k,:),'Color',c(k,:),...
        'linewidth',2);
    % add label
    xlabel('Location','fontName','Times','fontSize',14);
    ylabel('Mean diffusivity','fontName','Times','fontSize',14);
    title(sprintf('%s-%s',subDir{k}(1:6),fgN{fibID}(2:3)),'fontName','Times','fontSize',14)
    %     axis([0 100 0.5 1.2])
    
    % AD
    subplot(2,2,3)
    hold on;
    st = nanstd(ad(Ctl,:),1);
    m   = nanmean(ad(Ctl,:));
    
    A3 = area(m+2*st);
    A1 = area(m+st);
    A2 = area(m-st);
    A4 = area(m-2*st);
    
    set(A1,'FaceColor',[0.8 0.8 0.8],'linestyle','none')
    set(A2,'FaceColor',[0.9 0.9 0.9],'linestyle','none')
    set(A3,'FaceColor',[0.9 0.9 0.9],'linestyle','none')
    set(A4,'FaceColor',[1 1 1],'linestyle','none')
    
    % add individual plot
    
    plot(X,ad(k,:),'Color',c(k,:),...
        'linewidth',2);
    % add label
    xlabel('Location','fontName','Times','fontSize',14);
    ylabel('Axial diffusivity','fontName','Times','fontSize',14);
    title(sprintf('%s-%s',subDir{k}(1:6),fgN{fibID}(2:3)),'fontName','Times','fontSize',14)
    %     axis([0 100 0.5 2])
    
    % RD
    subplot(2,2,4)
    hold on;
    st = nanstd(rd(Ctl,:),1);
    m   = nanmean(rd(Ctl,:));
    
    A3 = area(m+2*st);
    A1 = area(m+st);
    A2 = area(m-st);
    A4 = area(m-2*st);
    
    set(A1,'FaceColor',[0.8 0.8 0.8],'linestyle','none')
    set(A2,'FaceColor',[0.9 0.9 0.9],'linestyle','none')
    set(A3,'FaceColor',[0.9 0.9 0.9],'linestyle','none')
    set(A4,'FaceColor',[1 1 1],'linestyle','none')
    
    % add individual plot
    
    plot(X,rd(k,:),'Color',c(k,:),...
        'linewidth',2);
    % add label
    xlabel('Location','fontName','Times','fontSize',14);
    ylabel('Radial diffusivity','fontName','Times','fontSize',14);
    title(sprintf('%s-%s',subDir{k}(1:6),fgN{fibID}(2:3)),'fontName','Times','fontSize',14)
    %     axis([0 100 0.2 1])
    
    hold off
    
        %% save the figures
        cd '/biac4/wandell/biac3/wandell7/shumpei/matlab/git/LHON/3RP/Tama2'
        print(gcf,'-dpng',sprintf('%s_%s_diffusion.png',subDir{k}(1:6),fgN{fibID}(2:3)));
        print(gcf,'-depsc',sprintf('%s_%s_diffusion',subDir{k}(1:6),fgN{fibID}(2:3)));
%         close gcf
end

%% CRD group plots
figure;
subplot(2,2,1)
hold on;

% Control
st = nanstd(fa(Ctl,:),1);

m   = nanmean(fa(Ctl,:));

A3 = area(m+2*st);
A1 = area(m+st);
A2 = area(m-st);
A4 = area(m-2*st);

% %%
% subplot(2,2,2)
% hold on;
% sem= st/sqrt(14);
% A3 = area(m+2*sem);
% A1 = area(m+sem);
% A2 = area(m-sem);
% A4 = area(m-2*sem);
%
set(A1,'FaceColor',[0.8 0.8 0.8],'linestyle','none')
set(A2,'FaceColor',[0.9 0.9 0.9],'linestyle','none')
set(A3,'FaceColor',[0.9 0.9 0.9],'linestyle','none')
set(A4,'FaceColor',[1 1 1],'linestyle','none')

% plot(X,m,'Color',[0 0 0] ,'linewidth',2)

% add individual FA plot
for k = CRD %1:length(subDir)
    plot(X,fa(k,:),'Color',c(k,:),...
        'linewidth',1);
end
m   = nanmean(fa(CRD,:));
plot(X,m,'Color',c(3,:) ,'linewidth',2)
%     % add label
xlabel('Location','fontName','Times','fontSize',14);
ylabel('Fractional anisotropy','fontName','Times','fontSize',14);
%     title(sprintf('%s-%s',subDir{k}(1:6),fgN{fibID}(2:3)),'fontName','Times','fontSize',14)

% MD
subplot(2,2,2)
hold on;
st = nanstd(md(Ctl,:),1);
m   = nanmean(md(Ctl,:));

A3 = area(m+2*st);
A1 = area(m+st);
A2 = area(m-st);
A4 = area(m-2*st);

set(A1,'FaceColor',[0.8 0.8 0.8],'linestyle','none')
set(A2,'FaceColor',[0.9 0.9 0.9],'linestyle','none')
set(A3,'FaceColor',[0.9 0.9 0.9],'linestyle','none')
set(A4,'FaceColor',[1 1 1],'linestyle','none')

% plot(X,m,'Color',[0 0 0], 'linewidth',2)

% add individual plot
for k = CRD
    plot(X,md(k,:),'Color',c(k,:),...
        'linewidth',1);
end

m   = nanmean(md(CRD,:));
plot(X,m,'Color',c(3,:) ,'linewidth',2)
% add label
xlabel('Location','fontName','Times','fontSize',14);
ylabel('Mean diffusivity','fontName','Times','fontSize',14);
%     title(sprintf('%s-%s',subDir{k}(1:6),fgN{fibID}(2:3)),'fontName','Times','fontSize',14)
%     axis([0 100 0.5 1.2])

% AD
subplot(2,2,3)
hold on;
st = nanstd(ad(Ctl,:),1);
m   = nanmean(ad(Ctl,:));

A3 = area(m+2*st);
A1 = area(m+st);
A2 = area(m-st);
A4 = area(m-2*st);

set(A1,'FaceColor',[0.8 0.8 0.8],'linestyle','none')
set(A2,'FaceColor',[0.9 0.9 0.9],'linestyle','none')
set(A3,'FaceColor',[0.9 0.9 0.9],'linestyle','none')
set(A4,'FaceColor',[1 1 1],'linestyle','none')

% plot(X,m,'Color',[0 0 0], 'linewidth',2)

% add individual AD plot
for k = CRD
    plot(X,ad(k,:),'Color',c(k,:),...
        'linewidth',1);
end

m   = nanmean(ad(CRD,:));
plot(X,m,'Color',c(3,:) ,'linewidth',2)

% add label
xlabel('Location','fontName','Times','fontSize',14);
ylabel('Axial diffusivity','fontName','Times','fontSize',14);
%     title(sprintf('%s-%s',subDir{k}(1:6),fgN{fibID}(2:3)),'fontName','Times','fontSize',14)
%     axis([0 100 0.5 2])

% RD
subplot(2,2,4)
hold on;
st = nanstd(rd(Ctl,:),1);
m   = nanmean(rd(Ctl,:));

A3 = area(m+2*st);
A1 = area(m+st);
A2 = area(m-st);
A4 = area(m-2*st);

set(A1,'FaceColor',[0.8 0.8 0.8],'linestyle','none')
set(A2,'FaceColor',[0.9 0.9 0.9],'linestyle','none')
set(A3,'FaceColor',[0.9 0.9 0.9],'linestyle','none')
set(A4,'FaceColor',[1 1 1],'linestyle','none')

% add LHON individual plot
for k = CRD
    plot(X,rd(k,:),'Color',c(k,:),...
        'linewidth',1);
end
% plot mean 
m   = nanmean(rd(CRD,:));
plot(X,m,'Color',c(3,:) ,'linewidth',2)
% add label
xlabel('Location','fontName','Times','fontSize',14);
ylabel('Radial diffusivity','fontName','Times','fontSize',14);
% title(sprintf('%s-%s',subDir{k}(1:6),fgN{fibID}(2:3)),'fontName','Times','fontSize',14)
%     axis([0 100 0.2 1])
% legend('2SD','1SD','LHON')
% legend off
hold off

    %% save the figures
%      cd 'Supplement'
    print(gcf,'-dpng',sprintf('%s_%s_diffusion.png',subDir{k}(1:3),fgN{fibID}(2:3)));
    print(gcf,'-depsc',sprintf('%s_%s_diffusion.eps',subDir{k}(1:3),fgN{fibID}(2:3)));
     close gcf

%% LHON group FA plot
figure;
subplot(2,2,1)
hold on;

% Control
st = nanstd(fa(Ctl,:),1);
m   = nanmean(fa(Ctl,:));

A3 = area(m+2*st);
A1 = area(m+st);
A2 = area(m-st);
A4 = area(m-2*st);

set(A1,'FaceColor',[0.8 0.8 0.8],'linestyle','none')
set(A2,'FaceColor',[0.9 0.9 0.9],'linestyle','none')
set(A3,'FaceColor',[0.9 0.9 0.9],'linestyle','none')
set(A4,'FaceColor',[1 1 1],'linestyle','none')

% add individual 
for k = LHON %1:length(subDir)
    plot(X,fa(k,:),'Color',c(k,:),'linewidth',1);
end
% plot mean value
m   = nanmean(fa(LHON,:));
plot(X,m,'Color',c(4,:) ,'linewidth',2)
%     % add label
xlabel('Location','fontName','Times','fontSize',14);
ylabel('Fractional anisotropy','fontName','Times','fontSize',14);
%     title(sprintf('%s-%s',subDir{k}(1:6),fgN{fibID}(2:3)),'fontName','Times','fontSize',14)

% MD
subplot(2,2,2)
hold on;
st = nanstd(md(Ctl,:),1);
m   = nanmean(md(Ctl,:));

A3 = area(m+2*st);
A1 = area(m+st);
A2 = area(m-st);
A4 = area(m-2*st);

set(A1,'FaceColor',[0.8 0.8 0.8],'linestyle','none')
set(A2,'FaceColor',[0.9 0.9 0.9],'linestyle','none')
set(A3,'FaceColor',[0.9 0.9 0.9],'linestyle','none')
set(A4,'FaceColor',[1 1 1],'linestyle','none')

% add individual plot    
for k = LHON
    plot(X,md(k,:),'Color',c(k,:),...
        'linewidth',1);
end
% plot mean
m   = nanmean(md(LHON,:));
plot(X,m,'Color',c(4,:) ,'linewidth',2)
% add label
xlabel('Location','fontName','Times','fontSize',14);
ylabel('Mean diffusivity','fontName','Times','fontSize',14);
%     title(sprintf('%s-%s',subDir{k}(1:6),fgN{fibID}(2:3)),'fontName','Times','fontSize',14)
%     axis([0 100 0.5 1.2])

% AD
subplot(2,2,3)
hold on;
st = nanstd(ad(Ctl,:),1);
m   = nanmean(ad(Ctl,:));

A3 = area(m+2*st);
A1 = area(m+st);
A2 = area(m-st);
A4 = area(m-2*st);

set(A1,'FaceColor',[0.8 0.8 0.8],'linestyle','none')
set(A2,'FaceColor',[0.9 0.9 0.9],'linestyle','none')
set(A3,'FaceColor',[0.9 0.9 0.9],'linestyle','none')
set(A4,'FaceColor',[1 1 1],'linestyle','none')

% add individual plot
for k = LHON
    plot(X,ad(k,:),'Color',c(k,:),...
        'linewidth',1);
end
m   = nanmean(ad(LHON,:));
plot(X,m,'Color',c(4,:) ,'linewidth',2)
% add label
xlabel('Location','fontName','Times','fontSize',14);
ylabel('Axial diffusivity','fontName','Times','fontSize',14);
%     title(sprintf('%s-%s',subDir{k}(1:6),fgN{fibID}(2:3)),'fontName','Times','fontSize',14)
%     axis([0 100 0.5 2])

% RD
subplot(2,2,4)
hold on;
st = nanstd(rd(Ctl,:),1);
m   = nanmean(rd(Ctl,:));

A3 = area(m+2*st);
A1 = area(m+st);
A2 = area(m-st);
A4 = area(m-2*st);

set(A1,'FaceColor',[0.8 0.8 0.8],'linestyle','none')
set(A2,'FaceColor',[0.9 0.9 0.9],'linestyle','none')
set(A3,'FaceColor',[0.9 0.9 0.9],'linestyle','none')
set(A4,'FaceColor',[1 1 1],'linestyle','none')

% add individual plot
for k = LHON
    plot(X,rd(k,:),'Color',c(k,:),...
        'linewidth',1);
end
m   = nanmean(rd(LHON,:));
plot(X,m,'Color',c(4,:) ,'linewidth',2)
% add label
xlabel('Location','fontName','Times','fontSize',14);
ylabel('Radial diffusivity','fontName','Times','fontSize',14);
% title(sprintf('%s-%s',subDir{k}(1:6),fgN{fibID}(2:3)),'fontName','Times','fontSize',14)
%     axis([0 100 0.2 1])
% legend('2SD','1SD','LHON')
% legend off
hold off

    %% save the figures
%     cd 'RP_individual'
    print(gcf,'-dpng',sprintf('%s_%s_diffusion.png',subDir{k}(1:4),fgN{fibID}(2:3)));
    print(gcf,'-depsc',sprintf('%s_%s_diffusion.eps',subDir{k}(1:4),fgN{fibID}(2:3)));

    close gcf

