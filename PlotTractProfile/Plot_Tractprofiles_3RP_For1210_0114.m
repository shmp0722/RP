function Plot_Tractprofiles_3RP_For1210_0114
%% R_OR indivisual

cd /biac4/wandell/biac3/wandell7/shumpei/matlab/git/LHON/3RP


% cd /Users/shumpei/Documents/MATLAB/git/LHON/3RP
load 3RP_1210.mat
%% group comparison
% plot diffusivity  comparison
% set id number
JMD = 1:4;
CRD = 5:9;
LHON =10:15;
Ctl = 16:23;
% RP = jj:26;
RP = [24,26];
% Group_subject = {JMD,CRD,LHON,Ctl,RP,RP2};
Group_subject = {JMD,CRD,LHON,Ctl,RP};

% GroupName = {'JMD','CRD','LHON','Ctl','RP','RP2'};
GroupName = {'JMD','CRD','LHON','Ctl','RP'};

FiberName   = {afq.fgnames{21},afq.fgnames{22},afq.fgnames{24},afq.fgnames{25}};
% = {'ROR1206_D4L4','LOR1206_D4L4','ROTD4L4_1206','LOTD4L4_1206'};
fgId = [21,22,24,25];

diffusivityS = {'fa','md','ad','rd'};


%%
for jj=[21,24];
    
    %%
    JMD.fa = (nansum(afq.vals.fa{jj}(1:9,:),1)+nansum(afq.vals.fa{jj+1}(1:9,:),1))/18;
    JMD.md = (nansum(afq.vals.md{jj}(1:9,:),1)+nansum(afq.vals.md{jj+1}(1:9,:),1))/18;
    JMD.ad = (nansum(afq.vals.ad{jj}(1:9,:),1)+nansum(afq.vals.ad{jj+1}(1:9,:),1))/18;
    JMD.rd = (nansum(afq.vals.rd{jj}(1:9,:),1)+nansum(afq.vals.rd{jj+1}(1:9,:),1))/18;
    
    % se
    JMD.FAse = nanstd(vertcat(afq.vals.fa{jj}(1:9,:),afq.vals.fa{jj+1}(1:9,:)),1)/sqrt(18);
    JMD.MDse = nanstd(vertcat(afq.vals.md{jj}(1:9,:),afq.vals.md{jj+1}(1:9,:)),1)/sqrt(18);
    JMD.ADse = nanstd(vertcat(afq.vals.ad{jj}(1:9,:),afq.vals.ad{jj+1}(1:9,:)),1)/sqrt(18);
    JMD.RDse = nanstd(vertcat(afq.vals.rd{jj}(1:9,:),afq.vals.rd{jj+1}(1:9,:)),1)/sqrt(18);
    
    % congenitalMD 1:4
    congMD.fa = (nansum(afq.vals.fa{jj}(1:4,:),1)+nansum(afq.vals.fa{jj+1}(1:4,:),1))/8;
    congMD.md = (nansum(afq.vals.md{jj}(1:4,:),1)+nansum(afq.vals.md{jj+1}(1:4,:),1))/8;
    congMD.ad = (nansum(afq.vals.ad{jj}(1:4,:),1)+nansum(afq.vals.ad{jj+1}(1:4,:),1))/8;
    congMD.rd = (nansum(afq.vals.rd{jj}(1:4,:),1)+nansum(afq.vals.rd{jj+1}(1:4,:),1))/8;
    % se
    congMD.FAse = nanstd(vertcat(afq.vals.fa{jj}(1:4,:),afq.vals.fa{jj+1}(1:4,:)),1)/sqrt(8);
    congMD.MDse = nanstd(vertcat(afq.vals.md{jj}(1:4,:),afq.vals.md{jj+1}(1:4,:)),1)/sqrt(8);
    congMD.ADse = nanstd(vertcat(afq.vals.ad{jj}(1:4,:),afq.vals.ad{jj+1}(1:4,:)),1)/sqrt(8);
    congMD.RDse = nanstd(vertcat(afq.vals.rd{jj}(1:4,:),afq.vals.rd{jj+1}(1:4,:)),1)/sqrt(8);
    
    % CRD 5:9
    CRD.fa = (nansum(afq.vals.fa{jj}(5:9,:),1)+nansum(afq.vals.fa{jj+1}(5:9,:),1))/9;
    CRD.md = (nansum(afq.vals.md{jj}(5:9,:),1)+nansum(afq.vals.md{jj+1}(5:9,:),1))/9;
    CRD.ad = (nansum(afq.vals.ad{jj}(5:9,:),1)+nansum(afq.vals.ad{jj+1}(5:9,:),1))/9;
    CRD.rd = (nansum(afq.vals.rd{jj}(5:9,:),1)+nansum(afq.vals.rd{jj+1}(5:9,:),1))/9;
    % se
    CRD.FAse = nanstd(vertcat(afq.vals.fa{jj}(5:9,:),afq.vals.fa{jj+1}(5:9,:)),1)/sqrt(9);
    CRD.MDse = nanstd(vertcat(afq.vals.md{jj}(5:9,:),afq.vals.md{jj+1}(5:9,:)),1)/sqrt(9);
    CRD.ADse = nanstd(vertcat(afq.vals.ad{jj}(5:9,:),afq.vals.ad{jj+1}(5:9,:)),1)/sqrt(9);
    CRD.RDse = nanstd(vertcat(afq.vals.rd{jj}(5:9,:),afq.vals.rd{jj+1}(5:9,:)),1)/sqrt(9);
    
    % LHON
    LHON.fa = (nansum(afq.vals.fa{jj}(10:15,:),1)+nansum(afq.vals.fa{jj+1}(10:15,:),1))/12;
    LHON.md = (nansum(afq.vals.md{jj}(10:15,:),1)+nansum(afq.vals.md{jj+1}(10:15,:),1))/12;
    LHON.ad = (nansum(afq.vals.ad{jj}(10:15,:),1)+nansum(afq.vals.ad{jj+1}(10:15,:),1))/12;
    LHON.rd = (nansum(afq.vals.rd{jj}(10:15,:),1)+nansum(afq.vals.rd{jj+1}(10:15,:),1))/12;
    % se
    LHON.FAse = nanstd(vertcat(afq.vals.fa{jj}(10:15,:),afq.vals.fa{jj+1}(10:15,:)),1)/sqrt(12);
    LHON.MDse = nanstd(vertcat(afq.vals.md{jj}(10:15,:),afq.vals.md{jj+1}(10:15,:)),1)/sqrt(12);
    LHON.ADse = nanstd(vertcat(afq.vals.ad{jj}(10:15,:),afq.vals.ad{jj+1}(10:15,:)),1)/sqrt(12);
    LHON.RDse = nanstd(vertcat(afq.vals.rd{jj}(10:15,:),afq.vals.rd{jj+1}(10:15,:)),1)/sqrt(12);
    
    % Control
    Ctl.fa = (nansum(afq.vals.fa{jj}(16:23,:),1)+nansum(afq.vals.fa{jj+1}(16:23,:),1))/16;
    Ctl.md = (nansum(afq.vals.md{jj}(16:23,:),1)+nansum(afq.vals.md{jj+1}(16:23,:),1))/16;
    Ctl.ad = (nansum(afq.vals.ad{jj}(16:23,:),1)+nansum(afq.vals.ad{jj+1}(16:23,:),1))/16;
    Ctl.rd = (nansum(afq.vals.rd{jj}(16:23,:),1)+nansum(afq.vals.rd{jj+1}(16:23,:),1))/16;
    % se
    Ctl.FAse = nanstd(vertcat(afq.vals.fa{jj}(16:23,:),afq.vals.fa{jj+1}(16:23,:)),1)/sqrt(16);
    Ctl.MDse = nanstd(vertcat(afq.vals.fa{jj}(16:23,:),afq.vals.fa{jj+1}(16:23,:)),1)/sqrt(16);
    Ctl.ADse = nanstd(vertcat(afq.vals.fa{jj}(16:23,:),afq.vals.fa{jj+1}(16:23,:)),1)/sqrt(16);
    Ctl.RDse = nanstd(vertcat(afq.vals.fa{jj}(16:23,:),afq.vals.fa{jj+1}(16:23,:)),1)/sqrt(16);
    
    
    %% FA 6LHON_5CRD_8Ctl group comparison across LHON, 5CRD, and Control
    X =1:100;
    c=lines(26);
    figure; hold on;
    
    % JMDmean   = plot(X,JMD.fa,'Color',c(1,:),'Linewidth',2);
    % congMDmean = plot(X,congMD.fa,'Color',c(2,:),'Linewidth',2);
    CRDmean    = plot(X,CRD.fa,'Color',c(3,:),'Linewidth',2);
    LHONmean   = plot(X,LHON.fa,'Color',c(4,:),'Linewidth',2);
    Ctlmean    = plot(X,Ctl.fa,'Color',[0.5,0.5,0.5] ,'Linewidth',2);
    
    % legend('JMD','LHON','Ctl');
    
    % JMDerror    = errorbar(X, JMD.fa,JMD.FAse ,'Color',c(1,:));
    % congMDerror = errorbar(X, congMD.fa,congMD.FAse ,'Color',c(2,:));
    CRDerror    = errorbar(X, CRD.fa, CRD.FAse ,'Color',c(3,:));
    LHONerror   = errorbar(X, LHON.fa, LHON.FAse ,'Color',c(4,:));
    Ctlerror    = errorbar(X, Ctl.fa, Ctl.FAse ,'Color',[0.5,0.5,0.5]);
    
    switch jj
        case 24
            axis([0, 100, 0.1, 0.6]);
            figname = 'B_OT_FA.png';
        case 21
            axis([0, 100, 0.1, 0.65]);
            figname = 'B_OR_FA.png';
    end
    % set(gcf, )
    xlabel('Location','fontName','Times','fontSize',14);
    ylabel('Fractional Anisotropy','fontName','Times','fontSize',14);
    % title('Optic Tract across groups','fontName','Times','fontSize',14);
    
    hold off;
    
    %% save the figure in .eps
    cd /biac4/wandell/biac3/wandell7/shumpei/matlab/git/LHON/3RP/Figure3
    
    
    print(gcf,'-dpng',figname);
    
    
    
    %% RD 6LHON_5CRD_8Ctl group comparison across LHON, 5CRD, and Control
    
    figure; hold on;
    
    % JMDmean   = plot(X,JMD.fa,'Color',c(1,:),'Linewidth',2);
    % congMDmean = plot(X,congMD.fa,'Color',c(2,:),'Linewidth',2);
    CRDmean    = plot(X,CRD.rd,'Color',c(3,:),'Linewidth',2);
    LHONmean   = plot(X,LHON.rd,'Color',c(4,:),'Linewidth',2);
    Ctlmean    = plot(X,Ctl.rd,'Color',[0.5,0.5,0.5],'Linewidth',2);
    % title('Optic Tract across groups','fontName','Times','fontSize',14);
    
    % legend('JMD','LHON','Ctl');
    
    % JMDerror    = errorbar(X, JMD.fa,JMD.FAse ,'Color',c(1,:));
    % congMDerror = errorbar(X, congMD.fa,congMD.FAse ,'Color',c(2,:));
    CRDerror    = errorbar(X, CRD.rd, CRD.RDse ,'Color',c(3,:));
    LHONerror   = errorbar(X, LHON.rd, LHON.RDse ,'Color',c(4,:));
    Ctlerror    = errorbar(X, Ctl.rd, Ctl.RDse ,'Color',[0.5,0.5,0.5]);
    
    switch jj
        case 24
            axis([0, 100, 0.1, 0.6]);
            figname = 'B_OT_RD.png';
        case 21
            axis([0, 100, 0.4, 0.95]);
            figname = 'B_OR_RD.png';
    end
    
    
    
    
    % set(gcf, )
    xlabel('Location','fontName','Times','fontSize',14);
    ylabel('Radial Diffusivity','fontName','Times','fontSize',14);
    % title('Optic Tract across groups','fontName','Times','fontSize',14);
    
    hold off;
    
    %%
    
    print(gcf,'-dpng',figname);
    
    
    %% MD 6LHON_5CRD_8Ctl group comparison across LHON, 5CRD, and Control
    
    figure; hold on;
    
    % JMDmean   = plot(X,JMD.fa,'Color',c(1,:),'Linewidth',2);
    % congMDmean = plot(X,congMD.fa,'Color',c(2,:),'Linewidth',2);
    CRDmean    = plot(X,CRD.md,'Color',c(3,:),'Linewidth',2);
    LHONmean   = plot(X,LHON.md,'Color',c(4,:),'Linewidth',2);
    Ctlmean    = plot(X,Ctl.md,'Color',[0.5,0.5,0.5],'Linewidth',2);
    
    % legend('JMD','LHON','Ctl');
    
    % JMDerror    = errorbar(X, JMD.fa,JMD.FAse ,'Color',c(1,:));
    % congMDerror = errorbar(X, congMD.fa,congMD.FAse ,'Color',c(2,:));
    CRDerror    = errorbar(X, CRD.md, CRD.MDse ,'Color',c(3,:));
    LHONerror   = errorbar(X, LHON.md, LHON.MDse ,'Color',c(4,:));
    Ctlerror    = errorbar(X, Ctl.md, Ctl.MDse ,'Color',[0.5,0.5,0.5]);
    
    
    switch jj
        case 24
            axis([0, 100, 0.8, 1.6]);
            figname = 'B_OT_MD.png';
        case 21
            axis([0, 100, 0.6, 1.21]);
            figname = 'B_OR_MD.png';
    end
    
    
    % set(gcf, )
    xlabel('Location','fontName','Times','fontSize',14);
    ylabel('Mean Diffusivity','fontName','Times','fontSize',14);
    % title('Optic Tract across groups','fontName','Times','fontSize',14);
    
    hold off;
    
    %% save the figure in .eps
    
    print(gcf,'-dpng', figname);
    
    
    %% AD 6LHON_5CRD_8Ctl group comparison across LHON, 5CRD, and Control
    
    figure; hold on;
    X =1:100;
    c=lines(26);
    % JMDmean   = plot(X,JMD.fa,'Color',c(1,:),'Linewidth',2);
    % congMDmean = plot(X,congMD.fa,'Color',c(2,:),'Linewidth',2);
    CRDmean    = plot(X,CRD.ad,'Color',c(3,:),'Linewidth',2);
    LHONmean   = plot(X,LHON.ad,'Color',c(4,:),'Linewidth',2);
    Ctlmean    = plot(X,Ctl.ad,'Color',[0.4,0.4,0.4],'Linewidth',2);
    
    % legend('JMD','LHON','Ctl');
    
    % JMDerror    = errorbar(X, JMD.fa,JMD.FAse ,'Color',c(1,:));
    % congMDerror = errorbar(X, congMD.fa,congMD.FAse ,'Color',c(2,:));
    CRDerror    = errorbar(X, CRD.ad, CRD.ADse ,'Color',c(3,:));
    LHONerror   = errorbar(X, LHON.ad, LHON.ADse ,'Color',c(4,:));
    Ctlerror    = errorbar(X, Ctl.ad, Ctl.ADse ,'Color',[0.5,0.5,0.5]);
    
    switch jj
        case 24
            axis([0, 100, 1.2, 1.9]);
            figname = 'B_OT_AD.png';
        case 21
            axis([0, 100, 0.9, 1.71]);
            figname = 'B_OR_AD.png';
    end
    
    % set(gcf, )
    xlabel('Location','fontName','Times','fontSize',14);
    ylabel('Axial Diffusivity','fontName','Times','fontSize',14);
    % title('Optic tract across groups','fontName','Times','fontSize',14);
    
    hold off;
    
    %% save the figure in .eps
    print(gcf,'-dpng',figname);
    
    % print('-r0','-depsc','B_OR_RD_group_comaprison_6LHON_5CRD_8Ctl.eps');
end
return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% volume
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% check fiber direction
c =lines(jj);
for j = 21:28
    figure ;hold on;
    for i = 1:23
        plot(X,afq.vals.volume{j}(i,1:100),'color',c(i,:));
    end
    hold off;
    
end


%% R-OR
X = 1:100;
CRD_vol  = mean(afq.vals.volume{21}(5:9,1:100));
LHON_vol = mean(afq.vals.volume{21}(10:15,1:100));
Ctl_vol  = mean(afq.vals.volume{21}(16:23,1:100));
c = lines(jj);



figure ;hold on;
crd  = plot(X,CRD_vol,'Color',c(3,:),'Linewidth',2);
lhon = plot(X,LHON_vol,'Color',c(4,:),'Linewidth',2);
ctl  = plot(X,Ctl_vol,'Color',[0.5,0.5,0.5],'Linewidth',2);

legend('CRD','LHON','Ctl');

% plot(X,afq.vals.volume{21}(1,1:100),'Linewidth',3);
% plot(X,afq.vals.volume{21}(2,1:100),'Linewidth',3);
% for i =3:23
% plot(X,afq.vals.volume{21}(i,1:100));
% end


CRDerror    = errorbar(X, CRD_vol, std(afq.vals.volume{21}(5:9,1:100))/sqrt(5) ,...
    'Color',c(3,:));
LHONerror   = errorbar(X, LHON_vol, std(afq.vals.volume{21}(10:15,1:100))/sqrt(6) ,...
    'Color',c(4,:));
Ctlerror    = errorbar(X, Ctl_vol, std(afq.vals.volume{21}(16:23,1:100))/sqrt(8) ,...
    'Color',[0.5,0.5,0.5]);

axis([0, 100, 0, 4000]);


xlabel('Location','fontName','Times','fontSize',14);
ylabel('Volume [mm^3]','fontName','Times','fontSize',14);
title('R-Optic Radiation across groups','fontName','Times','fontSize',14);

%% save the figure in .eps
% Figure を 10jjx768 のeps形式で
% "fig.eps" に保存する例
width  = 410;
height =307;
set(gcf,'PaperPositionMode','auto')
pos=get(gcf,'Position');
pos(3)=width-1; %なぜか幅が1px増えるので対処
pos(4)=height;
set(gcf,'Position',pos);
print('-r0','-depsc','R_OR_Volume_6LHON_5CRD_8Ctl.eps');


%% LOR
X = 1:100;
CRD_vol  = mean(afq.vals.volume{22}(5:9,1:100));
LHON_vol = mean(afq.vals.volume{22}(10:15,1:100));
Ctl_vol  = mean(afq.vals.volume{22}(16:23,1:100));
c = lines(jj);
figure ;hold on;
crd  = plot(X,CRD_vol,'Color',c(3,:),'Linewidth',2);
lhon = plot(X,LHON_vol,'Color',c(4,:),'Linewidth',2);
ctl  = plot(X,Ctl_vol,'Color',[0.5,0.5,0.5],'Linewidth',2);

legend('CRD','LHON','Ctl');

CRDerror    = errorbar(X, CRD_vol, std(afq.vals.volume{21}(5:9,1:100))/sqrt(5) ,...
    'Color',c(3,:));
LHONerror   = errorbar(X, LHON_vol, std(afq.vals.volume{21}(10:15,1:100))/sqrt(6) ,...
    'Color',c(4,:));
Ctlerror    = errorbar(X, Ctl_vol, std(afq.vals.volume{21}(16:23,1:100))/sqrt(8) ,...
    'Color',[0.5,0.5,0.5]);

axis([0, 100, 0, 3000]);
CRDerror    = errorbar(X, CRD_vol, std(afq.vals.volume{21}(5:9,1:100))/sqrt(5) ,...
    'Color',c(3,:));
LHONerror   = errorbar(X, LHON_vol, std(afq.vals.volume{21}(10:15,1:100))/sqrt(6) ,...
    'Color',c(4,:));
Ctlerror    = errorbar(X, Ctl_vol, std(afq.vals.volume{21}(16:23,1:100))/sqrt(8) ,...
    'Color',[0.5,0.5,0.5]);

axis([0, 100, 0, 3000]);


xlabel('Location','fontName','Times','fontSize',14);
ylabel('Volume [mm^3]','fontName','Times','fontSize',14);
title('L-Optic Radiation across groups','fontName','Times','fontSize',14);


% %% check fiber direction
% figure ;hold on;
% for i = 1:23
% plot(X,afq.vals.volume{22}(i,1:100));
% end



%% save the figure in .eps
% Figure を 10jjx768 のeps形式で
% "fig.eps" に保存する例
width  = 410;
height =307;
set(gcf,'PaperPositionMode','auto')
pos=get(gcf,'Position');
pos(3)=width-1; %なぜか幅が1px増えるので対処
pos(4)=height;
set(gcf,'Position',pos);
print('-r0','-depsc','L_OR_Volume_6LHON_5CRD_8Ctl.eps');

%% B-OR
X = 1:100;
CRD_vol  = mean(afq.vals.volume{22}(5:9,1:100)+afq.vals.volume{21}(5:9,1:100))/2;
LHON_vol = mean(afq.vals.volume{22}(10:15,1:100)+afq.vals.volume{21}(10:15,1:100))/2;
Ctl_vol  = mean(afq.vals.volume{22}(16:23,1:100)+afq.vals.volume{21}(16:23,1:100))/2;
c = lines(jj);
figure ;hold on;
crd  = plot(X,CRD_vol,'Color',c(3,:),'Linewidth',2);
lhon = plot(X,LHON_vol,'Color',c(4,:),'Linewidth',2);
ctl  = plot(X,Ctl_vol,'Color',[0.5,0.5,0.5],'Linewidth',2);

% legend('JMD','LHON','Ctl');

CRDerror    = errorbar(X, CRD_vol, std(afq.vals.volume{21}(5:9,1:100))/sqrt(5) ,...
    'Color',c(3,:));
LHONerror   = errorbar(X, LHON_vol, std(afq.vals.volume{21}(10:15,1:100))/sqrt(6) ,...
    'Color',c(4,:));
Ctlerror    = errorbar(X, Ctl_vol, std(afq.vals.volume{21}(16:23,1:100))/sqrt(8) ,...
    'Color',[0.5,0.5,0.5]);

axis([0, 100, 0, 3000]);


xlabel('Location','fontName','Times','fontSize',14);
ylabel('Volume [mm^3]','fontName','Times','fontSize',14);
title('Optic Radiation across groups','fontName','Times','fontSize',14);


% %% check fiber direction
% figure ;hold on;
% for i = 1:23
% plot(X,afq.vals.volume{22}(i,1:100));
% end

%% save the figure in .eps

print(gcf,'-depsc','B_OR_Volume_6LHON_5CRD_8Ctl.eps');

%% R-OT

X = 1:100;

CRD_vol  = nanmean(afq.vals.volume{jj}(5:9,1:100));
LHON_vol = nanmean(afq.vals.volume{jj}(10:15,1:100));
Ctl_vol  = mean(afq.vals.volume{jj}(16:23,1:100));

c = lines(jj);
figure ;hold on;

crd  = plot(X,CRD_vol,'Color',c(3,:),'Linewidth',2);
lhon = plot(X,LHON_vol,'Color',c(4,:),'Linewidth',2);
ctl  = plot(X,Ctl_vol,'Color',[0.5,0.5,0.5],'Linewidth',2);

legend('JMD','LHON','Ctl');

CRDerror    = errorbar(X, CRD_vol, nanstd(afq.vals.volume{jj}(5:9,1:100))/sqrt(4) ,...
    'Color',c(3,:));
LHONerror   = errorbar(X, LHON_vol, std(afq.vals.volume{jj}(10:15,1:100))/sqrt(6) ,...
    'Color',c(4,:));
Ctlerror    = errorbar(X, Ctl_vol, std(afq.vals.volume{jj}(16:23,1:100))/sqrt(8) ,...
    'Color',[0.5,0.5,0.5]);

axis([0, 100, 10, 60]);

xlabel('Location','fontName','Times','fontSize',14);
ylabel('Volume [mm^3]','fontName','Times','fontSize',14);
title('R-Optic Tract across groups','fontName','Times','fontSize',14);

%% save the figure in .eps
% Figure を 10jjx768 のeps形式で
% "fig.eps" に保存する例
width  = 410;
height =307;
set(gcf,'PaperPositionMode','auto')
pos=get(gcf,'Position');
pos(3)=width-1; %なぜか幅が1px増えるので対処
pos(4)=height;
set(gcf,'Position',pos);
print('-r0','-depsc','R_OT_Volume_6LHON_5CRD_8Ctl.eps');

%% L-OT

X = 1:100;

CRD_vol  = nanmean(afq.vals.volume{jj+1}(5:9,1:100));
LHON_vol = nanmean(afq.vals.volume{jj+1}(10:15,1:100));
Ctl_vol  = mean(afq.vals.volume{jj+1}(16:23,1:100));

c = lines(jj);
figure ;hold on;

crd  = plot(X,CRD_vol,'Color',c(3,:),'Linewidth',2);
lhon = plot(X,LHON_vol,'Color',c(4,:),'Linewidth',2);
ctl  = plot(X,Ctl_vol,'Color',[0.5,0.5,0.5],'Linewidth',2);

legend('JMD','LHON','Ctl');

CRDerror    = errorbar(X, CRD_vol, nanstd(afq.vals.volume{jj+1}(5:9,1:100))/sqrt(5) ,...
    'Color',c(3,:));
LHONerror   = errorbar(X, LHON_vol, std(afq.vals.volume{jj+1}(10:15,1:100))/sqrt(6) ,...
    'Color',c(4,:));
Ctlerror    = errorbar(X, Ctl_vol, std(afq.vals.volume{jj+1}(16:23,1:100))/sqrt(8) ,...
    'Color',[0.5,0.5,0.5]);

axis([0, 100, 10, 60]);

xlabel('Location','fontName','Times','fontSize',14);
ylabel('Volume [mm^3]','fontName','Times','fontSize',14);
title('L-Optic Tract across groups','fontName','Times','fontSize',14);

%% save the figure in .eps
% Figure を 10jjx768 のeps形式で
% "fig.eps" に保存する例
width  = 410;
height =307;
set(gcf,'PaperPositionMode','auto')
pos=get(gcf,'Position');
pos(3)=width-1; %なぜか幅が1px増えるので対処
pos(4)=height;
set(gcf,'Position',pos);
print('-r0','-depsc','L_OT_Volume_6LHON_5CRD_8Ctl.eps');

%% B-OT

X = 1:100;

CRD_vol  = nanmean(afq.vals.volume{jj+1}(5:9,1:100)+afq.vals.volume{jj}(5:9,1:100))/2;
LHON_vol = mean(afq.vals.volume{jj+1}(10:15,1:100)+afq.vals.volume{jj}(10:15,1:100))/2;
Ctl_vol  = mean(afq.vals.volume{jj+1}(16:23,1:100)+afq.vals.volume{jj}(16:23,1:100))/2;

c = lines(jj);
figure ;hold on;%% B-OT

X = 1:100;

CRD_vol  = nanmean(afq.vals.volume{jj+1}(5:9,1:100)+afq.vals.volume{jj}(5:9,1:100))/2;
LHON_vol = mean(afq.vals.volume{jj+1}(10:15,1:100)+afq.vals.volume{jj}(10:15,1:100))/2;
Ctl_vol  = mean(afq.vals.volume{jj+1}(16:23,1:100)+afq.vals.volume{jj}(16:23,1:100))/2;

c = lines(jj);
figure ;hold on;

crd  = plot(X,CRD_vol,'Color',c(3,:),'Linewidth',2);
lhon = plot(X,LHON_vol,'Color',c(4,:),'Linewidth',2);
ctl  = plot(X,Ctl_vol,'Color',[0.5,0.5,0.5],'Linewidth',2);

legend('JMD','LHON','Ctl');

CRDerror    = errorbar(X, CRD_vol, nanstd(afq.vals.volume{jj+1}(5:9,1:100))/sqrt(5) ,...
    'Color',c(3,:));
LHONerror   = errorbar(X, LHON_vol, std(afq.vals.volume{jj+1}(10:15,1:100))/sqrt(6) ,...
    'Color',c(4,:));
Ctlerror    = errorbar(X, Ctl_vol, std(afq.vals.volume{jj+1}(16:23,1:100))/sqrt(8) ,...
    'Color',[0.5,0.5,0.5]);

axis([0, 100, 10, 60]);

xlabel('Location','fontName','Times','fontSize',14);
ylabel('Volume [mm^3]','fontName','Times','fontSize',14);
title('Optic Tract across groups','fontName','Times','fontSize',14);

%% save the figure in .eps
print(gcf,'-depsc','B_OT_Volume_6LHON_5CRD_8Ctl.eps');

crd  = plot(X,CRD_vol,'Color',c(3,:),'Linewidth',2);
lhon = plot(X,LHON_vol,'Color',c(4,:),'Linewidth',2);
ctl  = plot(X,Ctl_vol,'Color',[0.5,0.5,0.5],'Linewidth',2);

legend('JMD','LHON','Ctl');

CRDerror    = errorbar(X, CRD_vol, nanstd(afq.vals.volume{jj+1}(5:9,1:100))/sqrt(5) ,...
    'Color',c(3,:));
LHONerror   = errorbar(X, LHON_vol, std(afq.vals.volume{jj+1}(10:15,1:100))/sqrt(6) ,...
    'Color',c(4,:));
Ctlerror    = errorbar(X, Ctl_vol, std(afq.vals.volume{jj+1}(16:23,1:100))/sqrt(8) ,...
    'Color',[0.5,0.5,0.5]);

axis([0, 100, 10, 60]);

xlabel('Location','fontName','Times','fontSize',14);
ylabel('Volume [mm^3]','fontName','Times','fontSize',14);
title('Optic Tract across groups','fontName','Times','fontSize',14);

%% save the figure in .eps
print(gcf,'-depsc','B_OT_Volume_6LHON_5CRD_8Ctl.eps');

%% OCF

X = 1:100;

CRD_vol  = nanmean(afq.vals.volume{26}(5:9,1:100));
LHON_vol = nanmean(afq.vals.volume{26}(10:15,1:100));{23}
Ctl_vol  = mean(afq.vals.volume{26}(16:23,1:100));

c = lines(jj);
figure ;hold on;

crd  = plot(X,CRD_vol,'Color',c(3,:),'Linewidth',2);
lhon = plot(X,LHON_vol,'Color',c(4,:),'Linewidth',2);
ctl  = plot(X,Ctl_vol,'Color',[0.5,0.5,0.5],'Linewidth',2);

legend('JMD','LHON','Ctl');

CRDerror    = errorbar(X, CRD_vol, nanstd(afq.vals.volume{26}(5:9,1:100))/sqrt(5) ,...
    'Color',c(3,:));
LHONerror   = errorbar(X, LHON_vol, std(afq.vals.volume{26}(10:15,1:100))/sqrt(6) ,...
    'Color',c(4,:));
Ctlerror    = errorbar(X, Ctl_vol, std(afq.vals.volume{26}(16:23,1:100))/sqrt(8) ,...
    'Color',[0.5,0.5,0.5]);

axis([0, 100, 0, 7000]);

xlabel('Location','fontName','Times','fontSize',14);{23}
ylabel('Volume [mm^3]','fontName','Times','fontSize',14);
title('OCF across groups','fontName','Times','fontSize',14);

%% save the figure in .eps

print(gcf,'-depsc','OCF_Volume_6LHON_5CRD_8Ctl.eps');


%% R-OCF

X = 1:100;

CRD_vol  = nanmean(afq.vals.volume{27}(5:9,1:100));
LHON_vol = nanmean(afq.vals.volume{27}(10:15,1:100));
Ctl_vol  = mean(afq.vals.volume{27}(16:23,1:100));

c = lines(28);
figure ;hold on;

crd  = plot(X,CRD_vol,'Color',c(3,:),'Linewidth',2);
lhon = plot(X,LHON_vol,'Color',c(4,:),'Linewidth',2);
ctl  = plot(X,Ctl_vol,'Color',[0.5,0.5,0.5],'Linewidth',2);

% legend('JMD','LHON','Ctl');

CRDerror    = errorbar(X, CRD_vol, nanstd(afq.vals.volume{27}(5:9,1:100))/sqrt(4) ,...
    'Color',c(3,:));
LHONerror   = errorbar(X, LHON_vol, std(afq.vals.volume{27}(10:15,1:100))/sqrt(6) ,...
    'Color',c(4,:));
Ctlerror    = errorbar(X, Ctl_vol, std(afq.vals.volume{27}(16:23,1:100))/sqrt(8) ,...
    'Color',[0.5,0.5,0.5]);

axis([0, 100, 0, 12000]);

xlabel('Location','fontName','Times','fontSize',14);
ylabel('Volume [mm^3]','fontName','Times','fontSize',14);
title('R-OCF across groups','fontName','Times','fontSize',14);

%% save the figure in .eps
%
% width  = 410;
% height =307;
% set(gcf,'PaperPositionMode','auto')
% pos=get(gcf,'Position');
% pos(3)=width-1;
% pos(4)=height;
% set(gcf,'Position',pos);
print('-r0','-depsc','R_OCF_Volume_6LHON_5CRD_8Ctl.eps');

%% L-OCF

X = 1:100;

CRD_vol  = nanmean(afq.vals.volume{26}(5:9,1:100));
LHON_vol = nanmean(afq.vals.volume{26}(10:15,1:100));
Ctl_vol  = mean(afq.vals.volume{26}(16:23,1:100));

c = lines(jj);
figure ;hold on;

crd  = plot(X,CRD_vol,'Color',c(3,:),'Linewidth',2);
lhon = plot(X,LHON_vol,'Color',c(4,:),'Linewidth',2);
ctl  = plot(X,Ctl_vol,'Color',[0.5,0.5,0.5],'Linewidth',2);

legend('JMD','LHON','Ctl');

CRDerror    = errorbar(X, CRD_vol, nanstd(afq.vals.volume{26}(5:9,1:100))/sqrt(5) ,...
    'Color',c(3,:));
LHONerror   = errorbar(X, LHON_vol, std(afq.vals.volume{26}(10:15,1:100))/sqrt(6) ,...
    'Color',c(4,:));
Ctlerror    = errorbar(X, Ctl_vol, std(afq.vals.volume{26}(16:23,1:100))/sqrt(8) ,...
    'Color',[0.5,0.5,0.5]);

axis([0, 100, 0, 12000]);

xlabel('Location','fontName','Times','fontSize',14);
ylabel('Volume [mm^3]','fontName','Times','fontSize',14);
title('L-OCF across groups','fontName','Times','fontSize',14);

%% save the figure in .eps
% Figure を 10jjx768 のeps形式で
% "fig.eps" に保存する例
width  = 410;
height =307;
set(gcf,'PaperPositionMode','auto')
pos=get(gcf,'Position');
pos(3)=width-1; %なぜか幅が1px増えるので対処
pos(4)=height;
set(gcf,'Position',pos);
print('-r0','-depsc','L_OCF_Volume_6LHON_5CRD_8Ctl.eps');




xlabel('Location','fontName','Times','fontSize',14);
ylabel('Volume [mm^3]','fontName','Times','fontSize',14);
title('L-Optic Radiation across groups','fontName','Times','fontSize',14);


% %% check fiber direction
% figure ;hold on;
% for i = 1:23
% plot(X,afq.vals.volume{22}(i,1:100));
% end



%% save the figure in .eps
% Figure を 10jjx768 のeps形式で
% "fig.eps" に保存する例
width  = 410;
height =307;
set(gcf,'PaperPositionMode','auto')
pos=get(gcf,'Position');
pos(3)=width-1; %なぜか幅が1px増えるので対処
pos(4)=height;
set(gcf,'Position',pos);
print('-r0','-depsc','L_OR_Volume_6LHON_5CRD_8Ctl.eps');

%% B-OR
X = 1:100;
CRD_vol  = mean(afq.vals.volume{22}(5:9,1:100)+afq.vals.volume{21}(5:9,1:100))/2;
LHON_vol = mean(afq.vals.volume{22}(10:15,1:100)+afq.vals.volume{21}(10:15,1:100))/2;
Ctl_vol  = mean(afq.vals.volume{22}(16:23,1:100)+afq.vals.volume{21}(16:23,1:100))/2;
c = lines(jj);
figure ;hold on;
crd  = plot(X,CRD_vol,'Color',c(3,:),'Linewidth',2);
lhon = plot(X,LHON_vol,'Color',c(4,:),'Linewidth',2);
ctl  = plot(X,Ctl_vol,'Color',[0.5,0.5,0.5],'Linewidth',2);

% legend('JMD','LHON','Ctl');

CRDerror    = errorbar(X, CRD_vol, std(afq.vals.volume{21}(5:9,1:100))/sqrt(5) ,...
    'Color',c(3,:));
LHONerror   = errorbar(X, LHON_vol, std(afq.vals.volume{21}(10:15,1:100))/sqrt(6) ,...
    'Color',c(4,:));
Ctlerror    = errorbar(X, Ctl_vol, std(afq.vals.volume{21}(16:23,1:100))/sqrt(8) ,...
    'Color',[0.5,0.5,0.5]);

axis([0, 100, 0, 3000]);


xlabel('Location','fontName','Times','fontSize',14);
ylabel('Volume [mm^3]','fontName','Times','fontSize',14);
title('Optic Radiation across groups','fontName','Times','fontSize',14);


% %% check fiber direction
% figure ;hold on;
% for i = 1:23
% plot(X,afq.vals.volume{22}(i,1:100));
% end

%% save the figure in .eps

print(gcf,'-depsc','B_OR_Volume_6LHON_5CRD_8Ctl.eps');

%% R-OT

X = 1:100;

CRD_vol  = nanmean(afq.vals.volume{jj}(5:9,1:100));
LHON_vol = nanmean(afq.vals.volume{jj}(10:15,1:100));
Ctl_vol  = mean(afq.vals.volume{jj}(16:23,1:100));

c = lines(jj);
figure ;hold on;

crd  = plot(X,CRD_vol,'Color',c(3,:),'Linewidth',2);
lhon = plot(X,LHON_vol,'Color',c(4,:),'Linewidth',2);
ctl  = plot(X,Ctl_vol,'Color',[0.5,0.5,0.5],'Linewidth',2);

legend('JMD','LHON','Ctl');

CRDerror    = errorbar(X, CRD_vol, nanstd(afq.vals.volume{jj}(5:9,1:100))/sqrt(4) ,...
    'Color',c(3,:));
LHONerror   = errorbar(X, LHON_vol, std(afq.vals.volume{jj}(10:15,1:100))/sqrt(6) ,...
    'Color',c(4,:));
Ctlerror    = errorbar(X, Ctl_vol, std(afq.vals.volume{jj}(16:23,1:100))/sqrt(8) ,...
    'Color',[0.5,0.5,0.5]);

axis([0, 100, 10, 60]);

xlabel('Location','fontName','Times','fontSize',14);
ylabel('Volume [mm^3]','fontName','Times','fontSize',14);
title('R-Optic Tract across groups','fontName','Times','fontSize',14);

%% save the figure in .eps
% Figure を 10jjx768 のeps形式で
% "fig.eps" に保存する例
width  = 410;
height =307;
set(gcf,'PaperPositionMode','auto')
pos=get(gcf,'Position');
pos(3)=width-1; %なぜか幅が1px増えるので対処
pos(4)=height;
set(gcf,'Position',pos);
print('-r0','-depsc','R_OT_Volume_6LHON_5CRD_8Ctl.eps');

%% L-OT

X = 1:100;

CRD_vol  = nanmean(afq.vals.volume{jj+1}(5:9,1:100));
LHON_vol = nanmean(afq.vals.volume{jj+1}(10:15,1:100));
Ctl_vol  = mean(afq.vals.volume{jj+1}(16:23,1:100));

c = lines(jj);
figure ;hold on;

crd  = plot(X,CRD_vol,'Color',c(3,:),'Linewidth',2);
lhon = plot(X,LHON_vol,'Color',c(4,:),'Linewidth',2);
ctl  = plot(X,Ctl_vol,'Color',[0.5,0.5,0.5],'Linewidth',2);

legend('JMD','LHON','Ctl');

CRDerror    = errorbar(X, CRD_vol, nanstd(afq.vals.volume{jj+1}(5:9,1:100))/sqrt(5) ,...
    'Color',c(3,:));
LHONerror   = errorbar(X, LHON_vol, std(afq.vals.volume{jj+1}(10:15,1:100))/sqrt(6) ,...
    'Color',c(4,:));
Ctlerror    = errorbar(X, Ctl_vol, std(afq.vals.volume{jj+1}(16:23,1:100))/sqrt(8) ,...
    'Color',[0.5,0.5,0.5]);

axis([0, 100, 10, 60]);

xlabel('Location','fontName','Times','fontSize',14);
ylabel('Volume [mm^3]','fontName','Times','fontSize',14);
title('L-Optic Tract across groups','fontName','Times','fontSize',14);

%% save the figure in .eps
% Figure を 10jjx768 のeps形式で
% "fig.eps" に保存する例
width  = 410;
height =307;
set(gcf,'PaperPositionMode','auto')
pos=get(gcf,'Position');
pos(3)=width-1; %なぜか幅が1px増えるので対処
pos(4)=height;
set(gcf,'Position',pos);
print('-r0','-depsc','L_OT_Volume_6LHON_5CRD_8Ctl.eps');

%% B-OT

X = 1:100;

CRD_vol  = nanmean(afq.vals.volume{jj+1}(5:9,1:100)+afq.vals.volume{jj}(5:9,1:100))/2;
LHON_vol = mean(afq.vals.volume{jj+1}(10:15,1:100)+afq.vals.volume{jj}(10:15,1:100))/2;
Ctl_vol  = mean(afq.vals.volume{jj+1}(16:23,1:100)+afq.vals.volume{jj}(16:23,1:100))/2;

c = lines(jj);
figure ;hold on;%% B-OT

X = 1:100;

CRD_vol  = nanmean(afq.vals.volume{jj+1}(5:9,1:100)+afq.vals.volume{jj}(5:9,1:100))/2;
LHON_vol = mean(afq.vals.volume{jj+1}(10:15,1:100)+afq.vals.volume{jj}(10:15,1:100))/2;
Ctl_vol  = mean(afq.vals.volume{jj+1}(16:23,1:100)+afq.vals.volume{jj}(16:23,1:100))/2;

c = lines(jj);
figure ;hold on;

crd  = plot(X,CRD_vol,'Color',c(3,:),'Linewidth',2);
lhon = plot(X,LHON_vol,'Color',c(4,:),'Linewidth',2);
ctl  = plot(X,Ctl_vol,'Color',[0.5,0.5,0.5],'Linewidth',2);

legend('JMD','LHON','Ctl');

CRDerror    = errorbar(X, CRD_vol, nanstd(afq.vals.volume{jj+1}(5:9,1:100))/sqrt(5) ,...
    'Color',c(3,:));
LHONerror   = errorbar(X, LHON_vol, std(afq.vals.volume{jj+1}(10:15,1:100))/sqrt(6) ,...
    'Color',c(4,:));
Ctlerror    = errorbar(X, Ctl_vol, std(afq.vals.volume{jj+1}(16:23,1:100))/sqrt(8) ,...
    'Color',[0.5,0.5,0.5]);

axis([0, 100, 10, 60]);

xlabel('Location','fontName','Times','fontSize',14);
ylabel('Volume [mm^3]','fontName','Times','fontSize',14);
title('Optic Tract across groups','fontName','Times','fontSize',14);

%% save the figure in .eps
print(gcf,'-depsc','B_OT_Volume_6LHON_5CRD_8Ctl.eps');

crd  = plot(X,CRD_vol,'Color',c(3,:),'Linewidth',2);
lhon = plot(X,LHON_vol,'Color',c(4,:),'Linewidth',2);
ctl  = plot(X,Ctl_vol,'Color',[0.5,0.5,0.5],'Linewidth',2);

legend('JMD','LHON','Ctl');

CRDerror    = errorbar(X, CRD_vol, nanstd(afq.vals.volume{jj+1}(5:9,1:100))/sqrt(5) ,...
    'Color',c(3,:));
LHONerror   = errorbar(X, LHON_vol, std(afq.vals.volume{jj+1}(10:15,1:100))/sqrt(6) ,...
    'Color',c(4,:));
Ctlerror    = errorbar(X, Ctl_vol, std(afq.vals.volume{jj+1}(16:23,1:100))/sqrt(8) ,...
    'Color',[0.5,0.5,0.5]);

axis([0, 100, 10, 60]);

xlabel('Location','fontName','Times','fontSize',14);
ylabel('Volume [mm^3]','fontName','Times','fontSize',14);
title('Optic Tract across groups','fontName','Times','fontSize',14);

%% save the figure in .eps
print(gcf,'-depsc','B_OT_Volume_6LHON_5CRD_8Ctl.eps');

%% OCF

X = 1:100;

CRD_vol  = nanmean(afq.vals.volume{26}(5:9,1:100));
LHON_vol = nanmean(afq.vals.volume{26}(10:15,1:100));{23}
Ctl_vol  = mean(afq.vals.volume{26}(16:23,1:100));

c = lines(jj);
figure ;hold on;

crd  = plot(X,CRD_vol,'Color',c(3,:),'Linewidth',2);
lhon = plot(X,LHON_vol,'Color',c(4,:),'Linewidth',2);
ctl  = plot(X,Ctl_vol,'Color',[0.5,0.5,0.5],'Linewidth',2);

legend('JMD','LHON','Ctl');

CRDerror    = errorbar(X, CRD_vol, nanstd(afq.vals.volume{26}(5:9,1:100))/sqrt(5) ,...
    'Color',c(3,:));
LHONerror   = errorbar(X, LHON_vol, std(afq.vals.volume{26}(10:15,1:100))/sqrt(6) ,...
    'Color',c(4,:));
Ctlerror    = errorbar(X, Ctl_vol, std(afq.vals.volume{26}(16:23,1:100))/sqrt(8) ,...
    'Color',[0.5,0.5,0.5]);

axis([0, 100, 0, 7000]);

xlabel('Location','fontName','Times','fontSize',14);{23}
ylabel('Volume [mm^3]','fontName','Times','fontSize',14);
title('OCF across groups','fontName','Times','fontSize',14);

%% save the figure in .eps

print(gcf,'-depsc','OCF_Volume_6LHON_5CRD_8Ctl.eps');


%% R-OCF

X = 1:100;

CRD_vol  = nanmean(afq.vals.volume{27}(5:9,1:100));
LHON_vol = nanmean(afq.vals.volume{27}(10:15,1:100));
Ctl_vol  = mean(afq.vals.volume{27}(16:23,1:100));

c = lines(28);
figure ;hold on;

crd  = plot(X,CRD_vol,'Color',c(3,:),'Linewidth',2);
lhon = plot(X,LHON_vol,'Color',c(4,:),'Linewidth',2);
ctl  = plot(X,Ctl_vol,'Color',[0.5,0.5,0.5],'Linewidth',2);

% legend('JMD','LHON','Ctl');

CRDerror    = errorbar(X, CRD_vol, nanstd(afq.vals.volume{27}(5:9,1:100))/sqrt(4) ,...
    'Color',c(3,:));
LHONerror   = errorbar(X, LHON_vol, std(afq.vals.volume{27}(10:15,1:100))/sqrt(6) ,...
    'Color',c(4,:));
Ctlerror    = errorbar(X, Ctl_vol, std(afq.vals.volume{27}(16:23,1:100))/sqrt(8) ,...
    'Color',[0.5,0.5,0.5]);

axis([0, 100, 0, 12000]);

xlabel('Location','fontName','Times','fontSize',14);
ylabel('Volume [mm^3]','fontName','Times','fontSize',14);
title('R-OCF across groups','fontName','Times','fontSize',14);

%% save the figure in .eps
%
% width  = 410;
% height =307;
% set(gcf,'PaperPositionMode','auto')
% pos=get(gcf,'Position');
% pos(3)=width-1;
% pos(4)=height;
% set(gcf,'Position',pos);
print('-r0','-depsc','R_OCF_Volume_6LHON_5CRD_8Ctl.eps');

%% L-OCF

X = 1:100;

CRD_vol  = nanmean(afq.vals.volume{26}(5:9,1:100));
LHON_vol = nanmean(afq.vals.volume{26}(10:15,1:100));
Ctl_vol  = mean(afq.vals.volume{26}(16:23,1:100));

c = lines(jj);
figure ;hold on;

crd  = plot(X,CRD_vol,'Color',c(3,:),'Linewidth',2);
lhon = plot(X,LHON_vol,'Color',c(4,:),'Linewidth',2);
ctl  = plot(X,Ctl_vol,'Color',[0.5,0.5,0.5],'Linewidth',2);

legend('JMD','LHON','Ctl');

CRDerror    = errorbar(X, CRD_vol, nanstd(afq.vals.volume{26}(5:9,1:100))/sqrt(5) ,...
    'Color',c(3,:));
LHONerror   = errorbar(X, LHON_vol, std(afq.vals.volume{26}(10:15,1:100))/sqrt(6) ,...
    'Color',c(4,:));
Ctlerror    = errorbar(X, Ctl_vol, std(afq.vals.volume{26}(16:23,1:100))/sqrt(8) ,...
    'Color',[0.5,0.5,0.5]);

axis([0, 100, 0, 12000]);

xlabel('Location','fontName','Times','fontSize',14);
ylabel('Volume [mm^3]','fontName','Times','fontSize',14);
title('L-OCF across groups','fontName','Times','fontSize',14);

%% save the figure in .eps
% Figure を 10jjx768 のeps形式で
% "fig.eps" に保存する例
width  = 410;
height =307;
set(gcf,'PaperPositionMode','auto')
pos=get(gcf,'Position');
pos(3)=width-1; %なぜか幅が1px増えるので対処
pos(4)=height;
set(gcf,'Position',pos);
print('-r0','-depsc','L_OCF_Volume_6LHON_5CRD_8Ctl.eps');




