function Plot_GCA(save_fg)
%
% Make plots representing RP patients GCA compare to normal distribution
% taken from (Koh et al,. IOVS 2012).
%
% SO@Stanford Vista team 2015

%% Load patients' GCA 
% if you are air
% cd /Users/shumpei/Google Drive/RP
[NUM,TXT,RAW]=xlsread('Profiles_full.xlsx',8);

%% Load normal data

[num,txt,raw]=xlsread('normal data  Christopher. Kotowski.xlsx',3);

%% retieave data and give names  

PatientID = RAW(2:end,1);
Eye = RAW(2:end,2);
Label = TXT(1,:);
OCT_Label = Label(5:end); 

%% Sort OCT data

for ii = 1:length(Eye)/2;
    OD(ii,:) = NUM((2*ii-1),3:end);
    OS(ii,:) = NUM((2*ii),3:end);
end

%% retrieve normal distribution

Nmean = num(6:end,1)';
Nsd   = num(6:end,2)';
% Nlabel = txt(7:end,1);
Nlabel = {'Ave','Min','ST','S','SN','IN','I','IN'};
%% OD GCA plot 
% Normal ditribution with Errorbar2 

mrvNewGraphWin; hold on;
% normal
errorbar2(1:length(Nmean),Nmean,Nsd*2,1,'color',[0.9 0.9 0.9],...
    'linewidth',10);

errorbar2(1:length(Nmean),Nmean,Nsd,1,'color',[0.8 0.80 0.8],...
    'linewidth',10);
xlim([0, 9]);
h = gca;
h.XTick = [1:8];
h.YTick = [10,60,110];
h.XTickLabel = Nlabel;
% h.XTickLabelRotation = -90;

% add individual plot
SU  = plot(4, OD(:,4),'o','linewidth',2);
Inf = plot(7, OD(:,7),'o','linewidth',2);
SN  = plot(5, OD(:,5),'o','linewidth',2);
IN  = plot(8, OD(:,6),'o','linewidth',2);
ST  = plot(3, OD(:,3),'o','linewidth',2);
IN  = plot(6, OD(:,8),'o','linewidth',2);
MIN = plot(2, OD(:,2),'o','linewidth',2);
AVE = plot(1, OD(:,1),'o','linewidth',2);

% add title
title('R GCIPL thinckness','fontsize',14);
set(gca, 'tickdir','out','box','off')
% save the fig
if save_fg,
saveas(gcf,'R_Mac_oct.png')
saveas(gcf,'R_Mac_oct.eps','psc2')
end
%% OS GCA plot 
% Normal ditribution with Errorbar2 

mrvNewGraphWin; hold on;
% normal
errorbar2(1:length(Nmean),Nmean,Nsd*2,1,'color',[0.9 0.9 0.9],...
    'linewidth',10);

errorbar2(1:length(Nmean),Nmean,Nsd,1,'color',[0.8 0.80 0.8],...
    'linewidth',10);

% h.XTickLabelRotation = -90;

% add individual plot
SU  = plot(4, OS(:,4),'o','linewidth',2);
Inf = plot(7, OS(:,7),'o','linewidth',2);
SN  = plot(5, OS(:,5),'o','linewidth',2);
IN  = plot(8, OS(:,6),'o','linewidth',2);
ST  = plot(3, OS(:,3),'o','linewidth',2);
IT  = plot(6, OS(:,8),'o','linewidth',2);
MIN = plot(2, OS(:,2),'o','linewidth',2);
AVE = plot(1, OS(:,1),'o','linewidth',2);

% add title
title('L-GCIPL thinckness','fontsize',14);
set(gca, 'tickdir','out','box','off')
% make the fig up
xlim([0, 9]);
h = gca;
h.XTick = [1:8];
h.YLim  = [10, 110];
h.YTick = [10,60,110];
h.XTickLabel = Nlabel;
% save 
if save_fg,
saveas(gcf,'L_mac_oct.png')
saveas(gcf,'L_mac_oct.eps','psc2')
end

%% Both GCA plot 
% Normal ditribution with Errorbar2 

mrvNewGraphWin; hold on;
% normal
a =  errorbar2(1:length(Nmean),Nmean,Nsd*2,1,'color',[0.9 0.9 0.9],...
    'linewidth',10);

b = errorbar2(1:length(Nmean),Nmean,Nsd,1,'color',[0.8 0.80 0.8],...
    'linewidth',10);
% l = legend('1sd','2sd')
% L = get(l);

% make the fig up
xlim([0, 9]);
h = gca;
h.XTick = [1:8];
h.YTick = [10,60,110];
h.XTickLabel = Nlabel;
% h.XTickLabelRotation = -90;

% add individual plot
id = [1:5,8,7,6];
for jj =1 : 8;
    plot(jj,mean([OD(:,id(jj)), OS(:,id(jj))],2),'o','linewidth',2);
end

% add title
title('GCIPL thinckness','fontsize',14);
set(gca,'ytick',[10,110], 'tickdir','out','box','off')
% legend('2SD','1SD')
% legend('boxoff')
% save
if save_fg,
saveas(gcf,'B_mac_oct.png')
saveas(gcf,'B_mac_oct.eps','psc2')
end

return