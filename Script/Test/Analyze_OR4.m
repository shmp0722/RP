function Analyze_OR4
%% Set directory
homeDir = '/biac4/wandell/biac2/wandell/data/DWI-Tamagawa-Japan2';

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
%%
JMD = 1:4;
CRD = 5:9;
% LHON = 10:15;
LHON = [10:14,27];

Ctl = [16:23,31:33,35:37];
RP = [24:26,28,29,34,38,39];

%% make TractProfile structure
for i = 1:length(subDir)
    for j = 1:8
        TractProfile{i,j} = AFQ_CreateTractProfile;
    end
end

%% AFQ_tractprofile
for i = 1:length(subDir) %12
    SubDir = fullfile(homeDir,subDir{i});
    fgDir = fullfile(SubDir,'/dwi_2nd/fibers/conTrack/OR_in4');
    roiDir = fullfile(SubDir,'/dwi_2nd/ROIs');
    dtDir  = fullfile(homeDir,subDir{i},'dwi_2nd');
    
    cd(fgDir)
    fgF = {'*Lt-LGN4_lh_3Degree_ecc*Rh_NOT1201_D4L2.pdb'
        '*lh_Peri15Degree_ecc*Rh_NOT1201_D4L2.pdb'
        '*Rt-LGN4_rh_3Degree_ecc*Lh_NOT1201_D4L2.pdb'
        '*rh_Peri15Degree_ecc*Lh_NOT1201_D4L2.pdb'};
    
    SaveFile = {'Lt_3Deg_D4L2.pdb'
        'Lt_Peri15Deg_D4L2.pdb'
        'Rt_LGN4_lh_3Deg_D4L2.pdb'
        'Rt_Peri15Deg_D4L2.pdb'};
    
    for j = 1:length(fgF)
        
        % load fg
        fg  = dir(fullfile(fgDir,fgF{j}));
        %         [~,ik] = sort(cat(2,fg.datenum),2,'ascend');
        %         fg = fg(ik);
        %         % fg
        fg_cur  = fgRead(fg.name);
        
        % load dt6
        dt =dtiLoadDt6(fullfile(dtDir,'dt6.mat'));
        
        % calculate the diffusivities along the tract
        TractProfile{i,j} = SO_FiberValsInTractProfiles(fg_cur,dt,'AP',100,1);
        
        %          % if you want to check the fiber looks like
        %         AFQ_RenderFibers(fgOut1,'numfibers',100)
        %         AFQ_RenderRoi(ROI)
    end
end
%% save
cd /biac4/wandell/biac2/wandell/data/DWI-Tamagawa-Japan2/results/ORin4

save TractProfile_ORin4 TractProfile

return
%% Calculate vals along the fibers and return TP structure

% fgN ={'LOR1206_D4L4.pdb','ROR1206_D4L4.pdb'};
fgN = {'*-Rh_NOT1201_D4L4.pdb*','*-Lh_NOT1201_D4L4.pdb*'};

%% get diffusivities based on fiber length (percentile)
for i =1:length(subDir)
    % define directory
    SubDir = fullfile(homeDir,subDir{i});
    fgDir  = fullfile(SubDir,'/dwi_2nd/fibers/conTrack/Out30degree');
    dt6  = fullfile(homeDir,subDir{i},'dwi_2nd','dt6.mat');
    dt  = dtiLoadDt6(dt6);
    
    %
    for j =1:length(fgN)
        fg = dir(fgN{j})
        fg = fgRead(fullfile(fgDir,fg.name));
        
        TractProfile{i,j+6} = SO_FiberValsInTractProfiles(fg,dt,'AP',100,1);
        
    end
end


%% save
cd /biac4/wandell/biac2/wandell/data/DWI-Tamagawa-Japan2/results/ORin4

save TractProfile_ORin4_4 TractProfile

return

%%
load TractProfile_ORin4_4


%% merge both hemisphere
fibID = 7% [1,2,5,7];


switch fibID
    case {1,2}
        for subID = 1:length(subDir);
            if isempty(TractProfile{subID,fibID}.nfibers);
                fa(subID,:) =nan(1,100);
            else
                fa(subID,:) =  mean([TractProfile{subID,fibID}.vals.fa;...
                    TractProfile{subID,fibID+2}.vals.fa]);
            end;
            
            if isempty(TractProfile{subID,fibID}.nfibers);
                md(subID,:) =nan(1,100);
            else
                md(subID,:) = mean([ TractProfile{subID,fibID}.vals.md;...
                    TractProfile{subID,fibID+2}.vals.md]);
            end;
            
            if isempty(TractProfile{subID,fibID}.nfibers);
                rd(subID,:) =nan(1,100);
            else
                rd(subID,:) = mean([ TractProfile{subID,fibID}.vals.rd;...
                    TractProfile{subID,fibID+2}.vals.rd]);
            end;
            
            if isempty(TractProfile{subID,fibID}.nfibers);
                ad(subID,:) =nan(1,100);
            else
                ad(subID,:) = mean([ TractProfile{subID,fibID}.vals.ad;...
                    TractProfile{subID,fibID+2}.vals.ad]);
            end;
        end
        
    case {5,7}
        for subID = 1:length(subDir);
            if isempty(TractProfile{subID,fibID}.nfibers);
                fa(subID,:) =nan(1,100);
            else
                fa(subID,:) =  mean([TractProfile{subID,fibID}.vals.fa;...
                    TractProfile{subID,fibID+1}.vals.fa]);
            end;
            
            if isempty(TractProfile{subID,fibID}.nfibers);
                md(subID,:) =nan(1,100);
            else
                md(subID,:) = mean([ TractProfile{subID,fibID}.vals.md;...
                    TractProfile{subID,fibID+1}.vals.md]);
            end;
            
            if isempty(TractProfile{subID,fibID}.nfibers);
                rd(subID,:) =nan(1,100);
            else
                rd(subID,:) = mean([ TractProfile{subID,fibID}.vals.rd;...
                    TractProfile{subID,fibID+1}.vals.rd]);
            end;
            
            if isempty(TractProfile{subID,fibID}.nfibers);
                ad(subID,:) =nan(1,100);
            else
                ad(subID,:) = mean([ TractProfile{subID,fibID}.vals.ad;...
                    TractProfile{subID,fibID+1}.vals.ad]);
            end;
        end
end
%%
X = 1:100;
c=lines(40);
%% OR
% FA
figure;
subplot(2,2,1)
hold on;
% bar(1:100,Portion.*3,1.0)

% Control
st = nanstd(fa(Ctl,:),1);
m   = nanmean(fa(Ctl,:));

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
    plot(X,fa(k,:),'Color',c(3,:),...
        'linewidth',1);
end
m   = nanmean(fa(CRD,:));
plot(X,m,'Color',c(3,:) ,'linewidth',3)


% add individual
for k = LHON %1:length(subDir)
    plot(X,fa(k,:),'Color',[0 1 1],'linewidth',1);
end
% plot mean value
m   = nanmean(fa(LHON,:));
plot(X,m,'Color',[0 1 1] ,'linewidth',3)

% add individual
for k = RP %1:length(subDir)
    plot(X,fa(k,:),'Color',c(5,:),'linewidth',1);
end
% plot mean value
m   = nanmean(fa(RP,:));
plot(X,m,'Color',c(5,:) ,'linewidth',3)

% add label
xlabel('Location','fontName','Times','fontSize',14);
ylabel('FA','fontName','Times','fontSize',14);
% axis([0, 100 ,0.7, 1.8])

% MD
subplot(2,2,2)
hold on;
% bar(1:100,Portion.*3,1.0)

% Control
st = nanstd(md(Ctl,:),1);
m   = nanmean(md(Ctl,:));

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
    plot(X,md(k,:),'Color',c(3,:),...
        'linewidth',1);
end
m   = nanmean(md(CRD,:));
plot(X,m,'Color',c(3,:) ,'linewidth',3)


% add individual
for k = LHON %1:length(subDir)
    plot(X,md(k,:),'Color',[0 1 1],'linewidth',1);
end
% plot mean value
m   = nanmean(md(LHON,:));
plot(X,m,'Color',[0 1 1] ,'linewidth',3)

% add individual
for k = RP %1:length(subDir)
    plot(X,md(k,:),'Color',c(5,:),'linewidth',1);
end
% plot mean value
m   = nanmean(md(RP,:));
plot(X,m,'Color',c(5,:) ,'linewidth',3)


% add label
xlabel('Location','fontName','Times','fontSize',14);
ylabel('Axial diffusivity','fontName','Times','fontSize',14);
axis([0, 100 ,0.5, 1.4])

% AD
subplot(2,2,3)
hold on;
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

plot(m,'color',[0 0 0], 'linewidth',3 )

% add individual FA plot
for k = CRD %1:length(subDir)
    plot(X,ad(k,:),'Color',c(3,:),...
        'linewidth',1);
end
m   = nanmean(ad(CRD,:));
plot(X,m,'Color',c(3,:) ,'linewidth',3)


% add individual
for k = LHON %1:length(subDir)
    plot(X,ad(k,:),'Color',[0 1 1],'linewidth',1);
end
% plot mean value
m   = nanmean(ad(LHON,:));
plot(X,m,'Color',[0 1 1] ,'linewidth',3)

% add individual
for k = RP %1:length(subDir)
    plot(X,ad(k,:),'Color',c(5,:),'linewidth',1);
end
% plot mean value
m   = nanmean(ad(RP,:));
plot(X,m,'Color',c(5,:) ,'linewidth',3)


% add label
xlabel('Location','fontName','Times','fontSize',14);
ylabel('Axial diffusivity','fontName','Times','fontSize',14);
axis([0, 100 ,0.7, 1.8])

% RD
subplot(2,2,4)
hold on;
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
for k = LHON %1:length(subDir)
    plot(X,rd(k,:),'Color',[0 1 1],'linewidth',1);
end
% plot mean value
m   = nanmean(rd(LHON,:));
plot(X,m,'Color',[0 1 1] ,'linewidth',3)

% add individual
for k = RP %1:length(subDir)
    plot(X,rd(k,:),'Color',c(5,:),'linewidth',1);
end
% plot mean value
m   = nanmean(rd(RP,:));
plot(X,m,'Color',c(5,:) ,'linewidth',3)

% add label
xlabel('Location','fontName','Times','fontSize',14);
ylabel('Ridial diffusivity','fontName','Times','fontSize',14);
axis([0, 100 ,0.3, 1.2])


%% RP

c=lines(length(RP));

% FA
figure;
subplot(2,2,1)
hold on;
% bar(1:100,Portion.*3,1.0)

% Control
st = nanstd(fa(Ctl,:),1);
m   = nanmean(fa(Ctl,:));

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
%     plot(X,fa(k,:),'Color',c(3,:),...
%         'linewidth',1);
% end
% m   = nanmean(fa(CRD,:));
% plot(X,m,'Color',c(3,:) ,'linewidth',3)
%
%
% % add individual
% for k = LHON %1:length(subDir)
%     plot(X,fa(k,:),'Color',[0 1 1],'linewidth',1);
% end
% % plot mean value
% m   = nanmean(fa(LHON,:));
% plot(X,m,'Color',[0 1 1] ,'linewidth',3)

% add individual
for k = RP %1:length(subDir)
    plot(X,fa(k,:),'Color',c(find(RP==k),:),'linewidth',1);
end
% plot mean value
m   = nanmean(fa(RP,:));
plot(X,m,'Color',c(5,:) ,'linewidth',3)

% add label
xlabel('Location','fontName','Times','fontSize',14);
ylabel('FA','fontName','Times','fontSize',14);
% axis([0, 100 ,0.7, 1.8])

legend

% MD
subplot(2,2,2)
hold on;
% bar(1:100,Portion.*3,1.0)

% Control
st = nanstd(md(Ctl,:),1);
m   = nanmean(md(Ctl,:));

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
%     plot(X,md(k,:),'Color',c(3,:),...
%         'linewidth',1);
% end
% m   = nanmean(md(CRD,:));
% plot(X,m,'Color',c(3,:) ,'linewidth',3)
%
%
% % add individual
% for k = LHON %1:length(subDir)
%     plot(X,md(k,:),'Color',[0 1 1],'linewidth',1);
% end
% % plot mean value
% m   = nanmean(md(LHON,:));
% plot(X,m,'Color',[0 1 1] ,'linewidth',3)

% add individual
for k = RP %1:length(subDir)
    plot(X,md(k,:),'Color',c(find(RP==k),:),'linewidth',1);
end
% plot mean value
m   = nanmean(md(RP,:));
plot(X,m,'Color',c(5,:) ,'linewidth',3)


% add label
xlabel('Location','fontName','Times','fontSize',14);
ylabel('Axial diffusivity','fontName','Times','fontSize',14);
axis([0, 100 ,0.5, 1.4])

% AD
subplot(2,2,3)
hold on;
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

plot(m,'color',[0 0 0], 'linewidth',3 )

% % add individual FA plot
% for k = CRD %1:length(subDir)
%     plot(X,ad(k,:),'Color',c(3,:),...
%         'linewidth',1);
% end
% m   = nanmean(ad(CRD,:));
% plot(X,m,'Color',c(3,:) ,'linewidth',3)
%
%
% % add individual
% for k = LHON %1:length(subDir)
%     plot(X,ad(k,:),'Color',[0 1 1],'linewidth',1);
% end
% % plot mean value
% m   = nanmean(ad(LHON,:));
% plot(X,m,'Color',[0 1 1] ,'linewidth',3)

% add individual
for k = RP %1:length(subDir)
    plot(X,ad(k,:),'Color',c(find(RP==k),:),'linewidth',1);
end
% plot mean value
m   = nanmean(ad(RP,:));
plot(X,m,'Color',c(5,:) ,'linewidth',3)


% add label
xlabel('Location','fontName','Times','fontSize',14);
ylabel('Axial diffusivity','fontName','Times','fontSize',14);
axis([0, 100 ,0.7, 1.8])

% RD
subplot(2,2,4)
hold on;
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

% % add individual FA plot
% for k = CRD %1:length(subDir)
%     plot(X,rd(k,:),'Color',c(3,:),...
%         'linewidth',1);
% end
% m   = nanmean(rd(CRD,:));
% plot(X,m,'Color',c(3,:) ,'linewidth',3)
%
%
% % rdd individual
% for k = LHON %1:length(subDir)
%     plot(X,rd(k,:),'Color',[0 1 1],'linewidth',1);
% end
% % plot mean value
% m   = nanmean(rd(LHON,:));
% plot(X,m,'Color',[0 1 1] ,'linewidth',3)

% add individual
for k = RP %1:length(subDir)
    plot(X,rd(k,:),'Color',c(find(RP==k),:),'linewidth',1);
end
% plot mean value
m   = nanmean(rd(RP,:));
plot(X,m,'Color',c(5,:) ,'linewidth',3)

% add label
xlabel('Location','fontName','Times','fontSize',14);
ylabel('Ridial diffusivity','fontName','Times','fontSize',14);
axis([0, 100 ,0.3, 1.2])

%% RD  ANOVA
%     Ctl_rd  =  rd(Ctl,:);
%     LHON_rd =  rd(LHON,:);
%     CRD_rd  =  rd(CRD,:);
%
%     for jj= 1: 100
%         pac = nan(14,3);
%         pac(:,1)= Ctl_rd(:,jj);
%         pac(1:6,2)= LHON_rd(:,jj);
%         pac(1:5,3)= CRD_rd(:,jj);
%         [p(jj),~,stats(jj)] = anova1(pac,[],'off');
%         co = multcompare(stats(jj),'display','off');
%         C{jj}=co;
%     end
%
%     Portion =  p<0.01;

%% RD
subplot(2,2,2)
hold on;
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

% plot(m,'color',[0 0 0], 'linewidth',3 )
% % add individual FA plot
% for k = CRD %1:length(subDir)
%     plot(X,rd(k,:),'Color',c(3,:),...
%         'linewidth',1);
% end
% m   = nanmean(rd(CRD,:));
% plot(X,m,'Color',c(3,:) ,'linewidth',3)
%
%
% % rdd individual
% for k = LHON %1:length(subDir)
%     plot(X,rd(k,:),'Color',[0 1 1],'linewidth',1);
% end
% % plot mean value
% m   = nanmean(rd(LHON,:));
% plot(X,m,'Color',[0 1 1] ,'linewidth',3)

% add individual
for k = RP %1:length(subDir)
    plot(X,rd(k,:),'Color',c(5,:),'linewidth',1);
end
% plot mean value
m   = nanmean(rd(RP,:));
plot(X,m,'Color',c(5,:) ,'linewidth',3)

% add label
xlabel('Location','fontName','Times','fontSize',14);
ylabel('Ridial diffusivity','fontName','Times','fontSize',14);
axis([0, 100 ,0.3, 1.2])

%% OR
fibID = 1;
for subID = 1:length(subDir);
    if isempty(TractProfile{subID,fibID}{sdID}.nfibers);
        fa(subID,:) =nan(1,100);
    else
        fa(subID,:) =  mean([TractProfile{subID,fibID}{sdID}.vals.fa;...
            TractProfile{subID,fibID+2}{sdID}.vals.fa]);
    end;
    
    if isempty(TractProfile{subID,fibID}{sdID}.nfibers);
        md(subID,:) =nan(1,100);
    else
        md(subID,:) = mean([ TractProfile{subID,fibID}{sdID}.vals.md;...
            TractProfile{subID,fibID+2}{sdID}.vals.md]);
    end;
    
    if isempty(TractProfile{subID,fibID}{sdID}.nfibers);
        rd(subID,:) =nan(1,100);
    else
        rd(subID,:) = mean([ TractProfile{subID,fibID}{sdID}.vals.rd;...
            TractProfile{subID,fibID+2}{sdID}.vals.rd]);
    end;
    
    if isempty(TractProfile{subID,fibID}{sdID}.nfibers);
        ad(subID,:) =nan(1,100);
    else
        ad(subID,:) = mean([ TractProfile{subID,fibID}{sdID}.vals.ad;...
            TractProfile{subID,fibID+2}{sdID}.vals.ad]);
    end;
end

%% AD ANOVA
%     Ctl_ad  =  ad(Ctl,:);
%     LHON_ad =  ad(LHON,:);
%     CRD_ad  =  ad(CRD,:);
%
%     for jj= 1: 100
%         pac = nan(14,3);
%         pac(:,1)= Ctl_ad(:,jj);
%         pac(1:6,2)= LHON_ad(:,jj);
%         pac(1:5,3)= CRD_ad(:,jj);
%         [p(jj),~,stats(jj)] = anova1(pac,[],'off');
%         co = multcompare(stats(jj),'display','off');
%         C{jj}=co;
%     end
%
%     Portion =  p<0.01;

%% OR
subplot(2,2,3)
hold on;
% bar(1:100,Portion*2,1)


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
% add individual FA plot
for k = CRD %1:length(subDir)
    plot(X,ad(k,:),'Color',c(3,:),...
        'linewidth',1);
end
m   = nanmean(ad(CRD,:));
plot(X,m,'Color',c(3,:) ,'linewidth',2)


% add individual
for k = LHON %1:length(subDir)
    plot(X,ad(k,:),'Color',[0 1 1],'linewidth',1);
end
% plot mean value
m   = nanmean(ad(LHON,:));
plot(X,m,'Color',[0 1 1] ,'linewidth',2)

% add label
xlabel('Location','fontName','Times','fontSize',14);
ylabel('Axial diffusivity','fontName','Times','fontSize',14);
axis([0, 100, 0.9, 1.7])

%% RD  ANOVA
%     Ctl_rd  =  rd(Ctl,:);
%     LHON_rd =  rd(LHON,:);
%     CRD_rd  =  rd(CRD,:);
%
%     for jj= 1: 100
%         pac = nan(14,3);
%         pac(:,1)= Ctl_rd(:,jj);
%         pac(1:6,2)= LHON_rd(:,jj);
%         pac(1:5,3)= CRD_rd(:,jj);
%         [p(jj),~,stats(jj)] = anova1(pac,[],'off');
%         co = multcompare(stats(jj),'display','off');
%         C{jj}=co;
%     end
%
%     Portion =  p<0.01;

%% RD
subplot(2,2,4)
hold on;
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
for k = LHON %1:length(subDir)
    plot(X,rd(k,:),'Color',[0 1 1],'linewidth',1);
end
% plot mean value
m   = nanmean(rd(LHON,:));
plot(X,m,'Color',[0 1 1] ,'linewidth',3)

% add label
xlabel('Location','fontName','Times','fontSize',14);
ylabel('Ridial diffusivity','fontName','Times','fontSize',14);
axis([0, 100 ,0.2, 0.9])



% %% save figure
% cd /biac4/wandell/biac3/wandell7/shumpei/matlab/git/LHON/3RP/Figure6
% print(gcf,'-depsc','Figure6(2)')

%% dtiClip
for i = 1:length(subDir)
    SubDir = fullfile(homeDir,subDir{i});
    fgDir  = fullfile(SubDir,'/dwi_2nd/fibers/conTrack/OR_in4');
    roiDir = fullfile(SubDir,'/dwi_2nd/ROIs');
    dtDir  = fullfile(homeDir,subDir{i},'dwi_2nd');
    
    % ROI file names you want to merge
    for hemisphere = 1:2
        % load fg
        cd(fgDir)
        
        fgF = {'*Rt-LGN4*D4L2.pdb'
            '*Lt-LGN4*D4L2.pdb'};
        fg  = dir(fullfile(fgDir,fgF{hemisphere}));
        Fov  = fgRead(fg(1).name);
        Peri = fgRead(fg(3).name);
        
        % choose the voxels
        
        % Load the dt6
        dt = dtiLoadDt6(fullfile(dtDir,'dt6.mat'));
        
        FOV_cliped = dtiClipFiberGroup(Fov, [], [-40 0], [],0);
        FOV_cliped = dtiClipFiberGroup(FOV_cliped, [], [-120 -60], [],1);
        
        TractProfile{i,hemisphere} = SO_FiberValsInTractProfiles(FOV_cliped,dt,'AP',30,1);
    end
end

%% dtiIntersectFibers
for i = 1:length(subDir)
    SubDir = fullfile(homeDir,subDir{i});
    fgDir  = fullfile(SubDir,'/dwi_2nd/fibers/conTrack/OR_in4');
    roiDir = fullfile(SubDir,'/dwi_2nd/ROIs');
    dtDir  = fullfile(homeDir,subDir{i},'dwi_2nd');
    
    % ROI file names you want to merge
    for hemisphere = 1:2
        % load fg
        cd(fgDir)
        
        fgF = {'*Rt-LGN4*D4L2.pdb'
            '*Lt-LGN4*D4L2.pdb'};
        fg  = dir(fullfile(fgDir,fgF{hemisphere}));
        Fov  = fgRead(fg(1).name);
        Peri = fgRead(fg(3).name);
        
        % choose the voxels
        
        % Load the dt6
        dt = dtiLoadDt6(fullfile(dtDir,'dt6.mat'));
        
        % Calculate the length in mm of each fiber in the fiber group
        Lmm=cellfun('length',Fov.fibers);
        [a] = minmax(Lmm);
        % Calculate distribution of lengths
        [Lnorm, Mu, Sigma]= zscore(Lmm);
        
        % divide all fibers in 100 nodes
        %             numNodes = 100;
        %             FG{1} = dtiResampleFiberGroup(Fov, a(1), 'N');
        %             FG{2} = dtiResampleFiberGroup(Fov, a(2), 'N');
        
        %             TractProfile{1} = SO_FiberValsInTractProfiles(Fov,dt,'AP',a(1),1);
        %             TractProfile{2} = SO_FiberValsInTractProfiles(Fov,dt,'AP',a(2),1);
        %             TractProfile{3} = SO_FiberValsInTractProfiles(Fov,dt,'AP',100,1);
        %
        %             c = lines(10);
        %             figure; hold on;
        %             plot(1:a(1),TractProfile{1}.vals.fa,'color',c(1,:));
        %             plot(1:a(2),TractProfile{2}.vals.fa,'color',c(2,:));
        %             plot(1:100,TractProfile{3}.vals.fa,'color',c(3,:));
        
        
        
        for kk = 1: length(fg{1}.fibers)
            %         FG{1}.fibers{kk}= FG{1}.fibers{kk}(:,Portion(1,:)==1);
            FG{1}.fibers{kk}= FG{1}.fibers{kk}(:,50);
        end
        for kk =1:length(fg{2}.fibers)
            FG{2}.fibers{kk}=FG{2}.fibers{kk}(:,Portion(1,:)==1);
        end
        
        
        % Now let's get all of the coordinates that the fibers go through
        % get the unique coordinates
        
        coords_Fov_unique = unique(floor(horzcat(Fov.fibers{:})'),'rows');
        coords_Peri_unique = unique(floor(horzcat(Peri.fibers{:})'),'rows');
        
        Fov_setdiff  =  setdiff(coords_Fov_unique,coords_Peri_unique,'rows');
        Peri_setdiff =  setdiff(coords_Peri_unique,coords_Fov_unique,'rows');
        
        Intersecting = intersect(coords_Fov_unique,coords_Peri_unique,'rows');
        
        % check the rate of remains
        FoV_remains = length(Fov_setdiff)/length(coords_Fov_unique)*100;
        Peri_remains = length(Peri_setdiff)/length(coords_Peri_unique)*100;
        
        figure;
        bar([2,4],[FoV_remains,Peri_remains],0.2)
        set(gca,'XTickLabel',{'Foveal','Peripheral'},'FontSize',12); title('remains rate','FontSize',12);
        xlabel('tract','FontSize',12); ylabel('(Vox(A)-vox(B))/Vox(A)');
        hold off;
        
        % These coordsinates are in ac-pc (millimeter) space. We want to transform
        % them to image indices.
        
        img_coords_Fov = unique(floor(mrAnatXformCoords(inv(dt.xformToAcpc), coords_Fov_unique)), 'rows');
        img_coords_Peri = unique(floor(mrAnatXformCoords(inv(dt.xformToAcpc), coords_Peri_unique)), 'rows');
        
        img_coords_Fov_setdiff = unique(floor(mrAnatXformCoords(inv(dt.xformToAcpc), Fov_setdiff)), 'rows');
        img_coords_Peri_setdiff = unique(floor(mrAnatXformCoords(inv(dt.xformToAcpc), Peri_setdiff)), 'rows');
        
        img_intersect_coords = unique(floor(mrAnatXformCoords(inv(dt.xformToAcpc), Intersecting)), 'rows');
        
        % Now we can calculate FA
        [fa,~,~,~] = dtiComputeFA(dt.dt6);
        
        % Convert these coordinates to image indices
        ind_1 = sub2ind(size(fa), img_coords_Fov(:,1), img_coords_Fov(:,2),img_coords_Fov(:,3));
        ind_2 = sub2ind(size(fa), img_coords_Peri(:,1), img_coords_Peri(:,2),img_coords_Peri(:,3));
        ind_3 = sub2ind(size(fa), img_coords_Fov_setdiff(:,1), img_coords_Fov_setdiff(:,2),img_coords_Fov_setdiff(:,3));
        ind_4 = sub2ind(size(fa), img_coords_Peri_setdiff(:,1), img_coords_Peri_setdiff(:,2),img_coords_Peri_setdiff(:,3));
        ind_5 = sub2ind(size(fa), img_intersect_coords(:,1), img_intersect_coords(:,2),img_intersect_coords(:,3));
        
        
        ind = {ind_1,ind_2,ind_3,ind_4,ind_5};
        for kk = 1:length(ind)
            % Now we can calculate FA
            [fa,md,rd,ad] = dtiComputeFA(dt.dt6);
            % Now lets take these coordinates and turn them into an image. First we
            % will create an image of zeros
            img = zeros(size(fa));
            % Now replace every coordinate that has the optic radiations with a 1
            img(ind{kk}) = 1;
            
            % Now you have an image. Just for your own interest if you want to make a
            % 3d rendering
            figure; hold on;
            isosurface(img,.5);
            axis image
            camlight('headlight')
            hold off;
            % For each voxel that does not contain the optic radiations we will zero
            % out its value
            fa(~img) = 0;
            md(~img) = 0;
            ad(~img) = 0;
            rd(~img) = 0;
            % not sure but sometimes we found FA>1. Lets correct the value.
            fa(fa>1) =1;
            
            FA{i,hemisphere,kk}=fa(fa~=0);
            MD{i,hemisphere,kk}=md(md~=0);
            RD{i,hemisphere,kk}=rd(rd~=0);
            AD{i,hemisphere,kk}=ad(ad~=0);
        end
        
        hold off;
    end
end
disp('finished')

%%
a = length(FA{1,1,1});
b = length(FA{1,1,3});
c = length(FA{1,1,5});
if a>=b; boxsize = a;else boxsize = b;end;
Box = nan(boxsize,1);
A = Box;B = Box; C = Box;
A(1:a,1) = FA{1,1,1};
B(1:b,1) = FA{1,1,3};
C(1:c,1) = FA{1,1,5};
% boxplot([A,B],'notch','on')
[p,table,stats] = kruskalwallis([A,B,C]);
set(gca,'XTickLabel',{'Raw','Subtracted','Intersect'},'FontSize',12);title('Foveal fibers')
% p=ttest2(A,B);

% peripheral fibers
a = length(FA{1,1,2});
b = length(FA{1,1,4});
if a>=b; boxsize = a;else boxsize = b;end;
Box = nan(boxsize,1);
A = Box;B = Box;C = Box;
A(1:a,1) = FA{1,1,2};
B(1:b,1) = FA{1,1,4};
C(1:c,1) = FA{1,1,5};
% boxplot([A,B],'notch','on')
[p,table,stats] = kruskalwallis([A,B,C]);
set(gca,'XTickLabel',{'Raw','Subtracted','Intesect'},'FontSize',12);title('Peripheral fibers')



%% compare
for Prt = 1:4;
    crd = vertcat(FA{CRD,Prt});
    lhon = vertcat(FA{LHON,Prt});
    rp = vertcat(FA{RP,Prt});
    ctl = vertcat(FA{Ctl,Prt});
    
    A = [length(crd),length(lhon),length(rp),length(ctl)];
    B =sort(A);
    %
    Box = nan(B(end),1);
    Box(1:length(crd))=crd; crd=Box;
    Box = nan(B(end),1);
    Box(1:length(lhon))=lhon; lhon=Box;
    Box = nan(B(end),1);
    Box(1:length(rp))=rp; rp=Box;
    Box = nan(B(end),1);
    Box(1:length(ctl))=ctl; ctl=Box;
    
    %
    %     figure; hold on;
    h = boxplot([crd,lhon,rp,ctl],'notch','on');
    %     [p(Prt),table,stats] = kruskalwallis([crd,lhon,rp,ctl]);
    
    %     c = multcompare(stats);
    
    %     [h,p] = ttest(rp,ctl)
    
    %     for kk = 1:length(RP)
    %         [h,p] = ttest2(FA{RP(kk),Prt},ctl)
    %     end
    
end

%%






