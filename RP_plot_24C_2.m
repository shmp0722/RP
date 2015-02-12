function RP_plot_24C_2

%% load afq structure

load '/sni-storage/wandell/biac2/wandell/data/DWI-Tamagawa-Japan2/RP/afq_8RP_25Normal_02112015.mat'

%% Argumenty check


%% retrieve vals
ii = 1:size(afq.patient_data(1).FA,1); % numbers of patient group
property = 'fa';
jj =21;
sprintf('** Render %s values of %s **',property ,afq.fgnames{jj})
%     for jj=1:length(afq.patient_data)
% Collect the property of interest and the relevant norms
switch(property)
    case {'FA' 'fa' 'fractional anisotropy'}
        vals     = (afq.patient_data(jj).FA(ii,:)+afq.patient_data(jj+1).FA(ii,:))/2;
        val_mean = afq.norms.meanFA(:,jj);
        val_sd   = afq.norms.sdFA(:,jj);
        ctl = afq.vals.fa{jj}(9:end,:);
        
        XLIM  = [10,90];
        YLIM  = [0 0.7];
        XTICK = XLIM;
        YTICK = YLIM;
        XTICKLabel = {'OC','LGN'};
    case {'MD' 'md' 'mean diffusivity'}
        vals     = (afq.patient_data(jj).MD(ii,:)+afq.patient_data(jj+1).MD(ii,:))/2;
        val_mean = afq.norms.meanMD(:,jj);
        val_sd   = afq.norms.sdMD(:,jj);
        ctl = afq.vals.md{jj}(9:end,:);
        
        XLIM  = [10,90];
        YLIM  = [0.6 1.8];
        XTICK = XLIM;
        YTICK = YLIM;
        XTICKLabel = {'OC','LGN'};
    case {'RD' 'rd' 'radial diffusivity'}
        vals     = (afq.patient_data(jj).RD(ii,:)+afq.patient_data(jj+1).RD(ii,:))/2;
        val_mean = afq.norms.meanRD(:,jj);
        val_sd   = afq.norms.sdRD(:,jj);
        ctl = afq.vals.rd{jj}(9:end,:);
        
        XLIM  = [10,90];
        YLIM  = [0.4 1.6];
        XTICK = XLIM;
        YTICK = YLIM;
        XTICKLabel = {'OC','LGN'};
    case {'AD' 'ad' 'axial diffusivity'}
        vals     = (afq.patient_data(jj).AD(ii,:)+afq.patient_data(jj+1).AD(ii,:))/2;
        val_mean = afq.norms.meanAD(:,jj);
        val_sd   = afq.norms.sdAD(:,jj);
        ctl = afq.vals.ad{jj}(9:end,:);
        
        XLIM  = [10,90];
        YLIM  = [1 2.4];
        XTICK = XLIM;
        YTICK = YLIM;
        XTICKLabel = {'OC','LGN'};
end

%% Stats

for kk = 1:length(vals);
        [p(kk),h(kk)] = ranksum(ctl(:,kk),vals(:,kk),'alpha',0.01);
        [P(kk),H(kk)] = ranksum(ctl(:,kk),vals(:,kk),'alpha',0.05);
end

%% Optic Tract
mrvNewGraphWin; 
subplot(2,2,1); hold on;
X = 1:100;
c = lines(100);

% % put bars based on wilcoxson (p<0.01, 0.05)

bar(H*2,1.0,'edgecolor','none','facecolor',[0.8 0.7 0.1])
bar(h*2,1.0,'edgecolor','none','facecolor',[0.5 0.7 0.3])

% Control
st = val_sd;
m   = val_mean;

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

% add individual
for k = 1:size(afq.patient_data(1).FA,1)
    plot(X,vals(k,:),'Color',c(5,:),'linewidth',1);
end
% plot mean value
m   = nanmean(vals,1);
plot(X,m,'Color',c(5,:) ,'linewidth',3)

% add label
xlabel('Location','fontName','Times','fontSize',14);
ylabel(upper(property),'fontName','Times','fontSize',14);
set(gca,'xlim',XLIM,'xtick',XTICK,'xtickLabel',XTICKLabel,...
    'ylim',YLIM,'ytick',YTICK,'ytickLabel',YTICK)

title( 'B-Optic tract','fontSize',20)
% axis square
hold off;


%% OR
jj = 23;

sprintf('** Render %s values of %s **',property ,afq.fgnames{jj})
%     for jj=1:length(afq.patient_data)
% Collect the property of interest and the relevant norms
switch(property)
    case {'FA' 'fa' 'fractional anisotropy'}
        vals     = (afq.patient_data(jj).FA(ii,:)+afq.patient_data(jj+1).FA(ii,:))/2;
        val_mean = afq.norms.meanFA(:,jj);
        val_sd   = afq.norms.sdFA(:,jj);
        ctl = afq.vals.fa{jj}(9:end,:);
        
        XLIM  = [10,90];
        YLIM  = [0 0.7];
        XTICK = XLIM;
        YTICK = YLIM;
        XTICKLabel = {'OC','LGN'};
    case {'MD' 'md' 'mean diffusivity'}
        vals     = (afq.patient_data(jj).MD(ii,:)+afq.patient_data(jj+1).MD(ii,:))/2;
        val_mean = afq.norms.meanMD(:,jj);
        val_sd   = afq.norms.sdMD(:,jj);
        ctl = afq.vals.md{jj}(9:end,:);
        
        XLIM  = [10,90];
        YLIM  = [0.6 1.8];
        XTICK = XLIM;
        YTICK = YLIM;
        XTICKLabel = {'OC','LGN'};
    case {'RD' 'rd' 'radial diffusivity'}
        vals     = (afq.patient_data(jj).RD(ii,:)+afq.patient_data(jj+1).RD(ii,:))/2;
        val_mean = afq.norms.meanRD(:,jj);
        val_sd   = afq.norms.sdRD(:,jj);
        ctl = afq.vals.rd{jj}(9:end,:);
        
        XLIM  = [10,90];
        YLIM  = [0.4 1.6];
        XTICK = XLIM;
        YTICK = YLIM;
        XTICKLabel = {'OC','LGN'};
    case {'AD' 'ad' 'axial diffusivity'}
        vals     = (afq.patient_data(jj).AD(ii,:)+afq.patient_data(jj+1).AD(ii,:))/2;
        val_mean = afq.norms.meanAD(:,jj);
        val_sd   = afq.norms.sdAD(:,jj);
        ctl = afq.vals.ad{jj}(9:end,:);
        
        XLIM  = [10,90];
        YLIM  = [1 2.4];
        XTICK = XLIM;
        YTICK = YLIM;
        XTICKLabel = {'OC','LGN'};
end

%% Stats

for kk = 1:length(vals);
        [p(kk),h(kk)] = ranksum(ctl(:,kk),vals(:,kk),'alpha',0.01);
        [P(kk),H(kk)] = ranksum(ctl(:,kk),vals(:,kk),'alpha',0.05);
end

%% Optic Tract
subplot(2,2,2); hold on;
X = 1:100;
c = lines(100);

% % put bars based on wilcoxson (p<0.01, 0.05)

bar(H*2,1.0,'edgecolor','none','facecolor',[0.8 0.7 0.1])
bar(h*2,1.0,'edgecolor','none','facecolor',[0.5 0.7 0.3])

% Control
st = val_sd;
m   = val_mean;

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

% add individual
for k = 1:size(afq.patient_data(1).FA,1)
    plot(X,vals(k,:),'Color',c(5,:),'linewidth',1);
end
% plot mean value
m   = nanmean(vals,1);
plot(X,m,'Color',c(5,:) ,'linewidth',3)

%
        XLIM  = [10,90];
        YLIM  = [0.2 0.8];
        XTICK = XLIM;
        YTICK = YLIM;
        XTICKLabel = {'LGN','V1'};


% add label
xlabel('Location','fontName','Times','fontSize',14);
ylabel(upper(property),'fontName','Times','fontSize',14);
set(gca,'xlim',XLIM,'xtick',XTICK,'xtickLabel',XTICKLabel,...
    'ylim',YLIM,'ytick',YTICK,'ytickLabel',YTICK)

title( 'B-Optic radiation','fontSize',20)
% axis square
hold off;


%% Fugure AD RD

%% OT
jj = 21;
property = 'ad';


sprintf('** Render %s values of %s **',property ,afq.fgnames{jj})
%     for jj=1:length(afq.patient_data)
% Collect the property of interest and the relevant norms
switch(property)
    case {'FA' 'fa' 'fractional anisotropy'}
        vals     = (afq.patient_data(jj).FA(ii,:)+afq.patient_data(jj+1).FA(ii,:))/2;
        val_mean = afq.norms.meanFA(:,jj);
        val_sd   = afq.norms.sdFA(:,jj);
        ctl = afq.vals.fa{jj}(9:end,:);
        
        XLIM  = [10,90];
        YLIM  = [0 0.7];
        XTICK = XLIM;
        YTICK = YLIM;
        XTICKLabel = {'OC','LGN'};
    case {'MD' 'md' 'mean diffusivity'}
        vals     = (afq.patient_data(jj).MD(ii,:)+afq.patient_data(jj+1).MD(ii,:))/2;
        val_mean = afq.norms.meanMD(:,jj);
        val_sd   = afq.norms.sdMD(:,jj);
        ctl = afq.vals.md{jj}(9:end,:);
        
        XLIM  = [10,90];
        YLIM  = [0.6 1.8];
        XTICK = XLIM;
        YTICK = YLIM;
        XTICKLabel = {'OC','LGN'};
    case {'RD' 'rd' 'radial diffusivity'}
        vals     = (afq.patient_data(jj).RD(ii,:)+afq.patient_data(jj+1).RD(ii,:))/2;
        val_mean = afq.norms.meanRD(:,jj);
        val_sd   = afq.norms.sdRD(:,jj);
        ctl = afq.vals.rd{jj}(9:end,:);
        
        XLIM  = [10,90];
        YLIM  = [0.4 1.6];
        XTICK = XLIM;
        YTICK = YLIM;
        XTICKLabel = {'OC','LGN'};
    case {'AD' 'ad' 'axial diffusivity'}
        vals     = (afq.patient_data(jj).AD(ii,:)+afq.patient_data(jj+1).AD(ii,:))/2;
        val_mean = afq.norms.meanAD(:,jj);
        val_sd   = afq.norms.sdAD(:,jj);
        ctl = afq.vals.ad{jj}(9:end,:);
        
        XLIM  = [10,90];
        YLIM  = [1 2.4];
        XTICK = XLIM;
        YTICK = YLIM;
        XTICKLabel = {'OC','LGN'};
end

%% Stats

for kk = 1:length(vals);
        [p(kk),h(kk)] = ranksum(ctl(:,kk),vals(:,kk),'alpha',0.01);
        [P(kk),H(kk)] = ranksum(ctl(:,kk),vals(:,kk),'alpha',0.05);
end

%% Optic Tract
mrvNewGraphWin;
subplot(2,2,1); hold on;
X = 1:100;
c = lines(100);

% put bars based on wilcoxson (p<0.01, 0.05)
bar(H*5,1.0,'edgecolor','none','facecolor',[0.8 0.7 0.1])
bar(h*5,1.0,'edgecolor','none','facecolor',[0.5 0.7 0.3])

% Control
st = val_sd;
m   = val_mean;

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

% add individual
for k = 1:size(afq.patient_data(1).FA,1)
    plot(X,vals(k,:),'Color',c(5,:),'linewidth',1);
end
% plot mean value
m   = nanmean(vals,1);
plot(X,m,'Color',c(5,:) ,'linewidth',3)

%
        XLIM  = [10,90];
        YLIM  = [0.7 2.6];
        XTICK = XLIM;
        YTICK = YLIM;
        XTICKLabel = {'OC','LGN'};


% add label
xlabel('Location','fontName','Times','fontSize',14);
ylabel(upper(property),'fontName','Times','fontSize',14);
set(gca,'xlim',XLIM,'xtick',XTICK,'xtickLabel',XTICKLabel,...
    'ylim',YLIM,'ytick',YTICK,'ytickLabel',YTICK)

title( 'B-Optic tract','fontSize',20)
% axis square
hold off;


%% OT RD
jj = 21;
property = 'rd';

sprintf('** Render %s values of %s **',property ,afq.fgnames{jj})
%     for jj=1:length(afq.patient_data)
% Collect the property of interest and the relevant norms
switch(property)
    case {'FA' 'fa' 'fractional anisotropy'}
        vals     = (afq.patient_data(jj).FA(ii,:)+afq.patient_data(jj+1).FA(ii,:))/2;
        val_mean = afq.norms.meanFA(:,jj);
        val_sd   = afq.norms.sdFA(:,jj);
        ctl = afq.vals.fa{jj}(9:end,:);
        
        XLIM  = [10,90];
        YLIM  = [0 0.7];
        XTICK = XLIM;
        YTICK = YLIM;
        XTICKLabel = {'OC','LGN'};
    case {'MD' 'md' 'mean diffusivity'}
        vals     = (afq.patient_data(jj).MD(ii,:)+afq.patient_data(jj+1).MD(ii,:))/2;
        val_mean = afq.norms.meanMD(:,jj);
        val_sd   = afq.norms.sdMD(:,jj);
        ctl = afq.vals.md{jj}(9:end,:);
        
        XLIM  = [10,90];
        YLIM  = [0.6 1.8];
        XTICK = XLIM;
        YTICK = YLIM;
        XTICKLabel = {'OC','LGN'};
    case {'RD' 'rd' 'radial diffusivity'}
        vals     = (afq.patient_data(jj).RD(ii,:)+afq.patient_data(jj+1).RD(ii,:))/2;
        val_mean = afq.norms.meanRD(:,jj);
        val_sd   = afq.norms.sdRD(:,jj);
        ctl = afq.vals.rd{jj}(9:end,:);
        
        XLIM  = [10,90];
        YLIM  = [0.4 1.6];
        XTICK = XLIM;
        YTICK = YLIM;
        XTICKLabel = {'OC','LGN'};
    case {'AD' 'ad' 'axial diffusivity'}
        vals     = (afq.patient_data(jj).AD(ii,:)+afq.patient_data(jj+1).AD(ii,:))/2;
        val_mean = afq.norms.meanAD(:,jj);
        val_sd   = afq.norms.sdAD(:,jj);
        ctl = afq.vals.ad{jj}(9:end,:);
        
        XLIM  = [10,90];
        YLIM  = [1 2.4];
        XTICK = XLIM;
        YTICK = YLIM;
        XTICKLabel = {'OC','LGN'};
end

%% Stats

for kk = 1:length(vals);
        [p(kk),h(kk)] = ranksum(ctl(:,kk),vals(:,kk),'alpha',0.01);
        [P(kk),H(kk)] = ranksum(ctl(:,kk),vals(:,kk),'alpha',0.05);
end

%% Optic Tract
% mrvNewGraphWin;
subplot(2,2,2); hold on;
X = 1:100;
c = lines(100);

% % put bars based on wilcoxson (p<0.01, 0.05)

bar(H*5,1.0,'edgecolor','none','facecolor',[0.8 0.7 0.1])
bar(h*5,1.0,'edgecolor','none','facecolor',[0.5 0.7 0.3])

% Control
st = val_sd;
m   = val_mean;

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

% add individual
for k = 1:size(afq.patient_data(1).FA,1)
    plot(X,vals(k,:),'Color',c(5,:),'linewidth',1);
end
% plot mean value
m   = nanmean(vals,1);
plot(X,m,'Color',c(5,:) ,'linewidth',3)

%
        XLIM  = [10,90];
        YLIM  = [0.3 2];
        XTICK = XLIM;
        YTICK = YLIM;
        XTICKLabel = {'OC','LGN'};


% add label
xlabel('Location','fontName','Times','fontSize',14);
ylabel(upper(property),'fontName','Times','fontSize',14);
set(gca,'xlim',XLIM,'xtick',XTICK,'xtickLabel',XTICKLabel,...
    'ylim',YLIM,'ytick',YTICK,'ytickLabel',YTICK)

title( 'B-Optic tract','fontSize',20)
% axis square
hold off;


%% OR AD
jj = 23;
property = 'ad';

sprintf('** Render %s values of %s **',property ,afq.fgnames{jj})
%     for jj=1:length(afq.patient_data)
% Collect the property of interest and the relevant norms
switch(property)
    case {'FA' 'fa' 'fractional anisotropy'}
        vals     = (afq.patient_data(jj).FA(ii,:)+afq.patient_data(jj+1).FA(ii,:))/2;
        val_mean = afq.norms.meanFA(:,jj);
        val_sd   = afq.norms.sdFA(:,jj);
        ctl = afq.vals.fa{jj}(9:end,:);
        
        XLIM  = [10,90];
        YLIM  = [0 0.7];
        XTICK = XLIM;
        YTICK = YLIM;
        XTICKLabel = {'OC','LGN'};
    case {'MD' 'md' 'mean diffusivity'}
        vals     = (afq.patient_data(jj).MD(ii,:)+afq.patient_data(jj+1).MD(ii,:))/2;
        val_mean = afq.norms.meanMD(:,jj);
        val_sd   = afq.norms.sdMD(:,jj);
        ctl = afq.vals.md{jj}(9:end,:);
        
        XLIM  = [10,90];
        YLIM  = [0.6 1.8];
        XTICK = XLIM;
        YTICK = YLIM;
        XTICKLabel = {'OC','LGN'};
    case {'RD' 'rd' 'radial diffusivity'}
        vals     = (afq.patient_data(jj).RD(ii,:)+afq.patient_data(jj+1).RD(ii,:))/2;
        val_mean = afq.norms.meanRD(:,jj);
        val_sd   = afq.norms.sdRD(:,jj);
        ctl = afq.vals.rd{jj}(9:end,:);
        
        XLIM  = [10,90];
        YLIM  = [0.4 1.6];
        XTICK = XLIM;
        YTICK = YLIM;
        XTICKLabel = {'OC','LGN'};
    case {'AD' 'ad' 'axial diffusivity'}
        vals     = (afq.patient_data(jj).AD(ii,:)+afq.patient_data(jj+1).AD(ii,:))/2;
        val_mean = afq.norms.meanAD(:,jj);
        val_sd   = afq.norms.sdAD(:,jj);
        ctl = afq.vals.ad{jj}(9:end,:);
        
        XLIM  = [10,90];
        YLIM  = [1 2.4];
        XTICK = XLIM;
        YTICK = YLIM;
        XTICKLabel = {'OC','LGN'};
end

%% Stats

for kk = 1:length(vals);
        [p(kk),h(kk)] = ranksum(ctl(:,kk),vals(:,kk),'alpha',0.01);
        [P(kk),H(kk)] = ranksum(ctl(:,kk),vals(:,kk),'alpha',0.05);
end

%% Optic Tract
% mrvNewGraphWin;
subplot(2,2,3); hold on;
X = 1:100;
c = lines(100);

% % put bars based on wilcoxson (p<0.01, 0.05)

bar(H*5,1.0,'edgecolor','none','facecolor',[0.8 0.7 0.1])
bar(h*5,1.0,'edgecolor','none','facecolor',[0.5 0.7 0.3])

% Control
st = val_sd;
m   = val_mean;

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

% add individual
for k = 1:size(afq.patient_data(1).FA,1)
    plot(X,vals(k,:),'Color',c(5,:),'linewidth',1);
end
% plot mean value
m   = nanmean(vals,1);
plot(X,m,'Color',c(5,:) ,'linewidth',3)

%
        XLIM  = [10,90];
        YLIM  = [0.8 1.8];
        XTICK = XLIM;
        YTICK = YLIM;
        XTICKLabel = {'OC','LGN'};


% add label
xlabel('Location','fontName','Times','fontSize',14);
ylabel(upper(property),'fontName','Times','fontSize',14);
set(gca,'xlim',XLIM,'xtick',XTICK,'xtickLabel',XTICKLabel,...
    'ylim',YLIM,'ytick',YTICK,'ytickLabel',YTICK)

title( 'B-Optic radiation','fontSize',20)
% axis square
hold off;

%% OR AD
jj = 23;
property = 'rd';

sprintf('** Render %s values of %s **',property ,afq.fgnames{jj})
%     for jj=1:length(afq.patient_data)
% Collect the property of interest and the relevant norms
switch(property)
    case {'FA' 'fa' 'fractional anisotropy'}
        vals     = (afq.patient_data(jj).FA(ii,:)+afq.patient_data(jj+1).FA(ii,:))/2;
        val_mean = afq.norms.meanFA(:,jj);
        val_sd   = afq.norms.sdFA(:,jj);
        ctl = afq.vals.fa{jj}(9:end,:);
        
        XLIM  = [10,90];
        YLIM  = [0 0.7];
        XTICK = XLIM;
        YTICK = YLIM;
        XTICKLabel = {'OC','LGN'};
    case {'MD' 'md' 'mean diffusivity'}
        vals     = (afq.patient_data(jj).MD(ii,:)+afq.patient_data(jj+1).MD(ii,:))/2;
        val_mean = afq.norms.meanMD(:,jj);
        val_sd   = afq.norms.sdMD(:,jj);
        ctl = afq.vals.md{jj}(9:end,:);
        
        XLIM  = [10,90];
        YLIM  = [0.6 1.8];
        XTICK = XLIM;
        YTICK = YLIM;
        XTICKLabel = {'OC','LGN'};
    case {'RD' 'rd' 'radial diffusivity'}
        vals     = (afq.patient_data(jj).RD(ii,:)+afq.patient_data(jj+1).RD(ii,:))/2;
        val_mean = afq.norms.meanRD(:,jj);
        val_sd   = afq.norms.sdRD(:,jj);
        ctl = afq.vals.rd{jj}(9:end,:);
        
        XLIM  = [10,90];
        YLIM  = [0.4 1.6];
        XTICK = XLIM;
        YTICK = YLIM;
        XTICKLabel = {'OC','LGN'};
    case {'AD' 'ad' 'axial diffusivity'}
        vals     = (afq.patient_data(jj).AD(ii,:)+afq.patient_data(jj+1).AD(ii,:))/2;
        val_mean = afq.norms.meanAD(:,jj);
        val_sd   = afq.norms.sdAD(:,jj);
        ctl = afq.vals.ad{jj}(9:end,:);
        
        XLIM  = [10,90];
        YLIM  = [1 2.4];
        XTICK = XLIM;
        YTICK = YLIM;
        XTICKLabel = {'OC','LGN'};
end

%% Stats

for kk = 1:length(vals);
        [p(kk),h(kk)] = ranksum(ctl(:,kk),vals(:,kk),'alpha',0.01);
        [P(kk),H(kk)] = ranksum(ctl(:,kk),vals(:,kk),'alpha',0.05);
end

%% Optic radiation
% mrvNewGraphWin;
subplot(2,2,4); hold on;
X = 1:100;
c = lines(100);

% % put bars based on wilcoxson (p<0.01, 0.05)

bar(H*5,1.0,'edgecolor','none','facecolor',[0.8 0.7 0.1])
bar(h*5,1.0,'edgecolor','none','facecolor',[0.5 0.7 0.3])

% Control
st = val_sd;
m   = val_mean;

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

% add individual
for k = 1:size(afq.patient_data(1).FA,1)
    plot(X,vals(k,:),'Color',c(5,:),'linewidth',1);
end
% plot mean value
m   = nanmean(vals,1);
plot(X,m,'Color',c(5,:) ,'linewidth',3)

%
        XLIM  = [10,90];
        YLIM  = [0.3 0.8];
        XTICK = XLIM;
        YTICK = YLIM;
        XTICKLabel = {'OC','LGN'};


% add label
xlabel('Location','fontName','Times','fontSize',14);
ylabel(upper(property),'fontName','Times','fontSize',14);
set(gca,'xlim',XLIM,'xtick',XTICK,'xtickLabel',XTICKLabel,...
    'ylim',YLIM,'ytick',YTICK,'ytickLabel',YTICK)

title( 'B-Optic radiation','fontSize',20)
% axis square
hold off;
end

% % add individual
% for k = 1:size(afq.control_data(1).FA,1)
%     plot(X,ctl(:,k),':','Color',[0.3 0.3 0.3],'linewidth',1);
% end
