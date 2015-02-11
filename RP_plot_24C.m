function RP_plot_24C(property,tract)

%% load afq structure

load '/sni-storage/wandell/biac2/wandell/data/DWI-Tamagawa-Japan2/RP/afq_8RP_25Normal_02102015.mat'

%% Argumenty check


%% retrieve vals
ii = 1:size(afq.patient_data(1).FA,1); % numbers of patient group

tract = upper(tract);

switch tract
    case {'LOT'}
        jj = 21;
    case {'ROT'}
        jj =22;
    case {'LOR'}
        jj = 23;
    case {'ROR'}
        jj =24;
end

sprintf('** Render %s values of %s **',property ,afq.fgnames{jj})
%     for jj=1:length(afq.patient_data)
% Collect the property of interest and the relevant norms
switch(property)
    case {'FA' 'fa' 'fractional anisotropy'}
        vals     = afq.patient_data(jj).FA(ii,:)';
        val_mean = afq.norms.meanFA(:,jj);
        val_sd   = afq.norms.sdFA(:,jj);
        
        XLIM  = [10,90];
        YLIM  = [0 0.7];
        XTICK = XLIM;
        YTICK = YLIM;
        XTICKLabel = {'OC','LGN'};
    case {'MD' 'md' 'mean diffusivity'}
        vals     = afq.patient_data(jj).MD(ii,:)';
        val_mean = afq.norms.meanMD(:,jj);
        val_sd   = afq.norms.sdMD(:,jj);
        XLIM  = [10,90];
        YLIM  = [0.6 1.8];
        XTICK = XLIM;
        YTICK = YLIM;
        XTICKLabel = {'OC','LGN'};
    case {'RD' 'rd' 'radial diffusivity'}
        vals     = afq.patient_data(jj).RD(ii,:)';
        val_mean = afq.norms.meanRD(:,jj);
        val_sd   = afq.norms.sdRD(:,jj);
        XLIM  = [10,90];
        YLIM  = [0.4 1.6];
        XTICK = XLIM;
        YTICK = YLIM;
        XTICKLabel = {'OC','LGN'};
    case {'AD' 'ad' 'axial diffusivity'}
        vals     = afq.patient_data(jj).AD(ii,:)';
        val_mean = afq.norms.meanAD(:,jj);
        val_sd   = afq.norms.sdAD(:,jj);
        XLIM  = [10,90];
        YLIM  = [1 2.4];
        XTICK = XLIM;
        YTICK = YLIM;
        XTICKLabel = {'OC','LGN'};
end

%% Stats





%% Optic Tract
mrvNewGraphWin; hold on;
X = 1:100;
c = lines(100);

% % put bars based on ANOVA (p<0.01)
% bar(1:100,Portion,1.0)

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
    plot(X,vals(:,k),'Color',c(5,:),'linewidth',1);
end
% plot mean value
m   = nanmean(vals,2);
plot(X,m,'Color',c(5,:) ,'linewidth',3)

% add label
xlabel('Location','fontName','Times','fontSize',14);
ylabel(upper(property),'fontName','Times','fontSize',14);
set(gca,'xlim',XLIM,'xtick',XTICK,'xtickLabel',XTICKLabel,...
    'ylim',YLIM,'ytick',YTICK,'ytickLabel',YTICK)

title( afq.fgnames{jj}(1:3),'fontSize',20)
% axis([10, 90 ,0.0, 0.600001])

