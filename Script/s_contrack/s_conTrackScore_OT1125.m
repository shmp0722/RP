function s_conTrackScore_OT1125(subjectnumber,thresh)
%%
% To save and score a hways
%

baseDir = '/biac4/wandell/biac2/wandell/data/DWI-Tamagawa-Japan';

subjectDir =  {...
    'JMD1-MM-20121025-DWI'
    'JMD2-KK-20121025-DWI'
    'JMD3-AK-20121026-DWI'
    'JMD4-AM-20121026-DWI'
    'JMD5-KK-20121220-DWI'
    'JMD6-NO-20121220-DWI'
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
    'JMD-Ctl-SY-20130222DWI'
    'JMD-Ctl-YM-20121025-DWI'
    'JMD-Ctl-HH-20120907DWI'
    'JMD-Ctl-HT-20120907-DWI'
    'JMD-Ctl-FN-20130621-DWI'
    'JMD-Ctl-AM-20130726-DWI'
    'JMD-Ctl-SO-20130726-DWI'};
%% defibne argment

if notDefined('subjectnumber'), subjectnumber = 1:length(subjectDir);end
if notDefined('thresh'), thresh = [0.01, 0.1, 0.3, 0.5, 0.7 ,0.9, 1.1, 1.5];end

if notDefined('node'), nodes = 100;end

%% fiber scoring using Sherbondy's contrack
for i = 19%subjectnumber;%,22]; %1:length(subjectDir);
    
    fibersFolder = fullfile(baseDir, subjectDir{i}, '/dwi_2nd/fibers/conTrack/OT_5K');
    % Set the fullpath to data directory
    cd(fibersFolder)
    
    %% To save and score a particular number of pathways
    
    Ids = {
        '*_Optic-Chiasm_Rt-LGN4*-Left-Cerebral-White-Matter_Ctrk100_AFQ*'
        '*_Optic-Chiasm_Lt-LGN4*Right-Cerebral-White-Matter_Ctrk100_AFQ*'};
    
    for ij = 1:length(Ids)
        fgF = dir(Ids{ij});
        
        % To save and score only pathways that have a score greater than
        % -thresh
        
        % get oldest files to match the identifier in the folder
        n = strfind([fgF(1).name],'-');
        dTxt = dir(sprintf('%s/*%s*.txt',fibersFolder, fgF(1).name(4:(n(5)-1))));
        %         dPdb = dir(Ids{ij});
        
        for k = 1:length(thresh)
            % give filename to fiber group
            l = {'ROT_AFQ','LOT_AFQ'};
            %         outputfibername = fullfile(fibersFolder, sprintf('%s_Ctr%d.pdb',dPdb.name(1:end-4),thresh*10));
            outputfibername = fullfile(fibersFolder, sprintf('%s_Ctr%d.pdb', l{ij}, thresh(k)*100));
            
            % make command to get fibers for contrack
            ContCommand = sprintf('contrack_score.glxa64 -i %s -p %s --thresh %d %s', ...
                dTxt.name, outputfibername, thresh(k), fgF(1).name);
            
            % run contrack
            system(ContCommand);
        end
    end
end

% %% Create Subject structure
% Subject.ROT = struct('Volume',[],'nFiber',[]);
% Subject.LOT = struct('Volume',[],'nFiber',[]);
% Subject.name = {};

%% caliculate the volume of tract
for i = 19 %19
    
    fibersFolder = fullfile(baseDir, subjectDir{i}, '/dwi_2nd/fibers/conTrack/OT_5K');
    % Set the fullpath to data directory
    cd(fibersFolder)
    Subject(i).name = subjectDir{i};
    Subject(i).ROT.subject = subjectDir{i};
    Subject(i).LOT.subject = subjectDir{i};
    
    
    for j = 1:2;  % RH or LH
        % Load ROIs for Clip fibers
        %         roiF = {'Optic-Chiasm.mat','Rt-LGN4.mat','Lt-LGN4.mat'};
        %         ROI1 = dtiReadRoi(fullfile(baseDir, subjectDir{i}, '/dwi_2nd/ROIs',roiF{1}));
        
        switch j
            case 1
                Ids = {'*_Optic-Chiasm_Rt-LGN4*-Left-Cerebral-White-Matter_Ctrk100_AFQ*',...
                    'ROT_AFQ_Ctr1.pdb','ROT_AFQ_Ctr10.pdb','ROT_AFQ_Ctr30.pdb','ROT_AFQ_Ctr50.pdb',...
                    'ROT_AFQ_Ctr70.pdb','ROT_AFQ_Ctr90.pdb','ROT_AFQ_Ctr1.100000e+02.pdb','ROT_AFQ_Ctr150.pdb'};
            case 2
                Ids = {'*_Optic-Chiasm_Lt-LGN4*Right-Cerebral-White-Matter_Ctrk100_AFQ*',...
                    'LOT_AFQ_Ctr1.pdb','LOT_AFQ_Ctr10.pdb','LOT_AFQ_Ctr30.pdb','LOT_AFQ_Ctr50.pdb',...
                    'LOT_AFQ_Ctr70.pdb','LOT_AFQ_Ctr90.pdb','LOT_AFQ_Ctr1.100000e+02.pdb','LOT_AFQ_Ctr150.pdb'};
        end;
        
        for ij = 1:length(Ids)
            
            if ij==1 ;
                fn= dir(Ids{ij});
                fg_ori = fgRead(fn(1).name);
            else
                % devide fg in same number of nodes
                fg_ori = fgRead(Ids{ij});
            end
            % checking fg number is enough or not
            if length(fg_ori.fibers) <3,
                Volume{ij} = zeros(nodes,1);
                nFiber(ij) =length(fg_ori.fibers);
                %             else
                % %                 % clip fg by 2ROI
                % %                 fgOut = dtiClipFiberGroupToROIs(fg_ori,ROI1,ROI2);
                % %                 fgWrite(fgOut, [fg_ori.name, '_clipped'],'pdb')
                %
                %                 if length(fg_ori.fibers) < 2
                %                     Volume{ij} = zeros(nodes,1);
                %                     nFiber(ij) =length(fg_ori.fibers);
            else
                fg = dtiResampleFiberGroup(fg_ori,nodes,[]); % default is number of nodes 100
                
                %  check the start point and end point of the fiber group
                for jj = 1:length(fg.fibers)
                    if fg.fibers{jj}(2,1) < fg.fibers{jj}(2,nodes);
                        fg.fibers{jj}= fliplr(fg.fibers{jj});end;
                end
                
                Volume{ij} = AFQ_TractProfileVolume(fg);
                nFiber(ij) = length(fg.fibers);
            end
        end
        
        
        % choose Left or Right OR
        switch j
            case 1
                Subject(i).ROT.Volume = Volume;
                Subject(i).ROT.nFiber = nFiber;
            case 2
                Subject(i).LOT.Volume = Volume;
                Subject(i).LOT.nFiber = nFiber;
        end
    end
end

cd /biac4/wandell/biac3/wandell7/shumpei/matlab/git/LHON/6LHON_9JMD_8Ctl/VolumeComparison
save Subject Subject

return


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% plots ROT volume for each subjects
for i = 1:23%length(subjectDir);
    
    figure(i); hold on;
    c = lines(100);
    X = [0 0.01, 0.1, 0.3, 0.5, 0.7 ,0.9, 1.1, 1.5];
    for j = 1:length(X)
        Y = cell2mat(Subject(i).ROT.Volume(j));
        plot(1:100,Y,'linewidth',3,'Color',c(j,:));
    end
    legend('0','0.01', '0.1', '0.3', '0.5', '0.7' ,'0.9', '1.1', '1.5');
    xlabel('Location','fontName','Times','fontSize',12);
    ylabel('Volume [mm^3]','fontName','Times','fontSize',12);
    title('R-Optic Tract Volume','fontName','Times','fontSize',14);
    hold off;
    
end

%% plots LOT volume for each subjects
for i = 1:23%length(subjectDir);
    
    figure(i); hold on;
    c = lines(100);
    X = [0, 0.01, 0.1, 0.3, 0.5, 0.7 ,0.9, 1.1, 1.5];
    for j = 1:length(X)
        Y = cell2mat(Subject(i).LOT.Volume(j));
        plot(1:100,Y,'linewidth',3,'Color',c(j,:));
    end
    legend('0','0.01', '0.1', '0.3', '0.5', '0.7' ,'0.9', '1.1', '1.5');
    xlabel('Location','fontName','Times','fontSize',12);
    ylabel('Volume [mm^3]','fontName','Times','fontSize',12);
    title('L-Optic Tract Volume','fontName','Times','fontSize',14);
    hold off;
end


%% calculate volume in each group
X = [0, 0.01, 0.1, 0.3, 0.5, 0.7 ,0.9, 1.1, 1.5];

for j = 1:length(X)
    
    for i = 1:length(subjectDir);
        %         for k = 1:100
        % whole optic Tract
        total_volumeR{j,i} = sum(Subject(i).ROT.Volume{j});
        total_volumeL{j,i} = sum(Subject(i).LOT.Volume{j});
        
        total_nFiberR{j,i} =  sum(Subject(i).ROT.nFiber(j));
        total_nFiberL{j,i} =  sum(Subject(i).LOT.nFiber(j));
        
    end
    
    % CRD
    % Sum
    CRD.tR{j} = sum(horzcat(total_volumeR{j,[2,4,7,8,9]}))/(5-sum(horzcat(total_volumeR{j,[2,4,7,8,9]})==0));
    CRD.tL{j} = sum(horzcat(total_volumeL{j,[2,4,7,8,9]}))/(5-sum(horzcat(total_volumeL{j,[2,4,7,8,9]})==0));
    CRD.B{j} = (CRD.tR{j} + CRD.tL{j})/2;
    
    
    % std
    CRD.tR_sd{j} = nanstd(horzcat(total_volumeR{j,[2,4,7,8,9]}));
    CRD.tL_sd{j} = nanstd(horzcat(total_volumeL{j,[2,4,7,8,9]}));
    CRD.B_sd{j} = nanstd(horzcat(total_volumeL{j,[2,4,7,8,9]},total_volumeR{j,[2,4,7,8,9]}));
    
    
    %S.E.
    CRD.tR_se{j} = CRD.tR_sd{j}/sqrt(5-sum(horzcat(total_volumeR{j,[2,4,7,8,9]})==0));
    CRD.tL_se{j} = CRD.tL_sd{j}/sqrt(5-sum(horzcat(total_volumeL{j,[2,4,7,8,9]})==0));
    CRD.B_se{j} = CRD.B_sd{j}/sqrt(10-sum(horzcat(total_volumeL{j,[2,4,7,8,9]})==0)-sum(horzcat(total_volumeR{j,[2,4,7,8,9]})==0));
    % number of fibers
    CRD.nFiberR{j} = sum(horzcat(total_nFiberR{j,[2,4,7,8,9]}))/(4-sum(horzcat(total_nFiberR{j,[2,4,7,8,9]})==0));
    CRD.nFiberL{j} = sum(horzcat(total_nFiberL{j,[2,4,7,8,9]}))/(4-sum(horzcat(total_nFiberL{j,[2,4,7,8,9]})==0));
    
    % JMD
    JMD.tR{j} = sum(horzcat(total_volumeR{j,[1,3,5,6]}))/(4-sum(horzcat(total_volumeR{j,[1,3,5,6]})==0));
    JMD.tL{j} = sum(horzcat(total_volumeL{j,[1,3,5,6]}))/(4-sum(horzcat(total_volumeL{j,[1,3,5,6]})==0));
    JMD.B{j} = (JMD.tR{j} + JMD.tL{j})/2;
    
    
    % std
    JMD.tR_sd{j} = nanstd(horzcat(total_volumeR{j,[1,3,5,6]}));
    JMD.tL_sd{j} = nanstd(horzcat(total_volumeL{j,[1,3,5,6]}));
    JMD.B_sd{j} = nanstd(horzcat(total_volumeL{j,[1,3,5,6]},total_volumeR{j,[1,3,5,6]}));
    
    
    %S.E.
    JMD.tR_se{j} = JMD.tR_sd{j}/sqrt(4-sum(horzcat(total_volumeR{j,[1,3,5,6]})==0));
    JMD.tL_se{j} = JMD.tL_sd{j}/sqrt(4-sum(horzcat(total_volumeL{j,[1,3,5,6]})==0));
    JMD.B_se{j} = JMD.B_sd{j}/sqrt(8-sum(horzcat(total_volumeL{j,[1,3,5,6]})==0)-sum(horzcat(total_volumeR{j,[1,3,5,6]})==0));
    
    
    JMD.nFiberR{j} = sum(horzcat(total_nFiberR{j,[1,3,5,6]}))/(4-sum(horzcat(total_nFiberR{j,[1,3,5,6]})==0));
    JMD.nFiberL{j} = sum(horzcat(total_nFiberL{j,[1,3,5,6]}))/(4-sum(horzcat(total_nFiberL{j,[1,3,5,6]})==0));
    
    % LHON
    LHON.tR{j} = sum(horzcat(total_volumeR{j,10:15}))/(6-sum(horzcat(total_volumeR{j,10:15})==0));
    LHON.tL{j} = sum(horzcat(total_volumeL{j,10:15}))/(6-sum(horzcat(total_volumeL{j,10:15})==0));
    LHON.B{j} = (LHON.tR{j} + LHON.tL{j})/2;
    
    
    % std
    LHON.tR_sd{j} = nanstd(horzcat(total_volumeR{j,10:15}));
    LHON.tL_sd{j} = nanstd(horzcat(total_volumeL{j,10:15}));
    LHON.B_sd{j} = nanstd(horzcat(total_volumeL{j,10:15},total_volumeR{j,10:15}));
    
    %S.E.
    LHON.tR_se{j} = LHON.tR_sd{j}/sqrt(6-sum(horzcat(total_volumeR{j,10:15})==0));
    LHON.tL_se{j} = LHON.tL_sd{j}/sqrt(6-sum(horzcat(total_volumeL{j,10:15})==0));
    LHON.B_se{j} = LHON.B_sd{j}/sqrt(12-sum(horzcat(total_volumeL{j,10:15})==0)-sum(horzcat(total_volumeR{j,10:15})==0));
    
    
    LHON.nFiberR{j} = sum(horzcat(total_nFiberR{j,10:15}))/(6-sum(horzcat(total_nFiberR{j,10:15})==0));
    LHON.nFiberL{j} = sum(horzcat(total_nFiberL{j,10:15}))/(6-sum(horzcat(total_nFiberL{j,10:15})==0));
    
    % Ctl
    Ctl.tR{j} = sum(horzcat(total_volumeR{j,16:23}))/(8-sum(horzcat(total_volumeR{j,16:23})==0));
    Ctl.tL{j} = sum(horzcat(total_volumeL{j,16:23}))/(8-sum(horzcat(total_volumeL{j,16:23})==0));
    Ctl.B{j} = (Ctl.tR{j} + Ctl.tL{j})/2;
    
    
    % std
    Ctl.tR_sd{j} = nanstd(horzcat(total_volumeR{j,16:23}));
    Ctl.tL_sd{j} = nanstd(horzcat(total_volumeL{j,16:23}));
    Ctl.B_sd{j} = nanstd(horzcat(total_volumeL{j,16:23},total_volumeR{j,16:23}));
    
    
    % S.E.
    Ctl.tR_se{j} = Ctl.tR_sd{j}/sqrt(8-sum(horzcat(total_volumeR{j,16:23})==0));
    Ctl.tL_se{j} = Ctl.tL_sd{j}/sqrt(8-sum(horzcat(total_volumeL{j,16:23})==0));
    Ctl.B_se{j} = Ctl.B_sd{j}/sqrt(16-sum(horzcat(total_volumeL{j,16:23})==0)-sum(horzcat(total_volumeR{j,16:23})==0));
    
    
    
    Ctl.nFiberR{j} = sum(horzcat(total_nFiberR{j,16:23}))/(8-sum(horzcat(total_nFiberR{j,16:23})==0));
    Ctl.nFiberL{j} = sum(horzcat(total_nFiberL{j,16:23}))/(8-sum(horzcat(total_nFiberL{j,16:23})==0));
end

%% average both hemi
% Plot
% CRD
% B-OT whole
c = lines(24);

Y1 = nanreplace(cell2mat(CRD.B(:)));
Y2 = nanreplace(cell2mat(LHON.B(:)));
Y3 = nanreplace(cell2mat(Ctl.B(:)));
% Y4 = nanreplace(cell2mat(JMD.B(:)));

figure; hold on;

plot1 = plot(X,Y1)
set(plot1,'MarkerFaceColor',c(3,:),'MarkerEdgeColor',c(3,:),...
    'MarkerSize',10,...
    'Marker','+',...
    'LineWidth',2,...
    'Color',c(3,:));

plot2 =  plot(X,Y2,'MarkerFaceColor',c(4,:),'MarkerEdgeColor',c(4,:),...
    'MarkerSize',7,...
    'Marker','^',...
    'LineWidth',2,...
    'Color',c(4,:));

plot3 =  plot(X,Y3,'MarkerFaceColor',[0.5,0.5,0.5],'MarkerEdgeColor',[0.5,0.5,0.5],...
    'MarkerSize',7,...
    'Marker','o',...
    'LineWidth',2,...
    'Color',[0.5,0.5,0.5]);

% plot4 =  plot(X,Y4,'MarkerFaceColor',c(2,:),'MarkerEdgeColor',c(2,:),...
%     'MarkerSize',7,...
%     'Marker','*',...
%     'LineWidth',2,...
%     'Color',c(2,:));


% legend('CRD', 'LHON', 'Ctl');
% legend('CRD', 'LHON', 'Ctl','congenital');


% add error bar(S.E.)
errorbar(X,Y1,cell2mat(CRD.tR_se(:)),'Color',c(3,:),'LineWidth',2)
errorbar(X,Y2,cell2mat(LHON.tR_se(:)),'Color',c(4,:),'LineWidth',2)
errorbar(X,Y3,cell2mat(Ctl.tR_se(:)),'Color',[0.5,0.5,0.5],'LineWidth',2)
% errorbar2(X,Y4,cell2mat(JMD.tR_se(:)),'Color',c(2,:),'LineWidth',2)

% % errobar2
% errorbar2(X,Y1,cell2mat(CRD.tR_se(:)),'y','Color',c(3,:),'LineWidth',2)
% errorbar2(X,Y2,cell2mat(LHON.tR_se(:)),'y','Color',c(4,:),'LineWidth',2)
% errorbar2(X,Y3,cell2mat(Ctl.tR_se(:)),'y','Color',[0.5,0.5,0.5],'LineWidth',2)
% errorbar2(X,Y4,cell2mat(JMD.tR_se(:)),'Color',c(2,:),'LineWidth',2)


xlabel('conTrack score thresh','fontName','Times','fontSize',12);
ylabel('Mean Volume [mm^3]','fontName','Times','fontSize',12);
title('Optic Tract','fontName','Times','fontSize',14);
axis([-0.2, 1.6, 0, 6000]);

hold off;

%% save the figure in .png
% Figure を 512x384 のPNG
% "fig.png"
cd /biac4/wandell/biac3/wandell7/shumpei/matlab/git/LHON/6LHON_9JMD_8Ctl/VolumeComparison/OT_CRD_LHON_Ctl

% width  = 512;
% height =384;
% set(gcf,'PaperPositionMode','auto')
% pos=get(gcf,'Position');
% pos(3)=width-1; %なぜか幅が1px増えるので対処
% pos(4)=height;
% set(gcf,'Position',pos);
print(gcf,'-r0','-dpng','OT_Volume_CRD_LHON_ctl.png');
print(gcf,'-r0','-depsc','OT_Volume_CRD_LHON_ctl.eps');


%% average both hemi
% Plot
% CRD
% B-OT whole
c = lines(24);

Y1 = nanreplace(cell2mat(CRD.B(:)));
% Y2 = nanreplace(cell2mat(LHON.B(:)));
Y3 = nanreplace(cell2mat(Ctl.B(:)));
Y4 = nanreplace(cell2mat(JMD.B(:)));

figure; hold on;

plot1 = plot(X,Y1)
set(plot1,'MarkerFaceColor',c(3,:),'MarkerEdgeColor',c(3,:),...
    'MarkerSize',10,...
    'Marker','+',...
    'LineWidth',2,...
    'Color',c(3,:));

% plot2 =  plot(X,Y2,'MarkerFaceColor',c(4,:),'MarkerEdgeColor',c(4,:),...
%     'MarkerSize',7,...
%     'Marker','^',...
%     'LineWidth',2,...
%     'Color',c(4,:));

plot3 =  plot(X,Y3,'MarkerFaceColor',[0.5,0.5,0.5],'MarkerEdgeColor',[0.5,0.5,0.5],...
    'MarkerSize',7,...
    'Marker','o',...
    'LineWidth',2,...
    'Color',[0.5,0.5,0.5]);

plot4 =  plot(X,Y4,'MarkerFaceColor',c(2,:),'MarkerEdgeColor',c(2,:),...
    'MarkerSize',7,...
    'Marker','*',...
    'LineWidth',2,...
    'Color',c(2,:));


% legend('CRD', 'LHON', 'Ctl');
% legend('CRD', 'LHON', 'Ctl','congenital');


% add error bar(S.E.)
errorbar(X,Y1,cell2mat(CRD.tR_se(:)),'Color',c(3,:),'LineWidth',2)
% errorbar(X,Y2,cell2mat(LHON.tR_se(:)),'Color',c(4,:),'LineWidth',2)
errorbar(X,Y3,cell2mat(Ctl.tR_se(:)),'Color',[0.5,0.5,0.5],'LineWidth',2)
errorbar(X,Y4,cell2mat(JMD.tR_se(:)),'Color',c(2,:),'LineWidth',2)

% % errobar2
% errorbar2(X,Y1,cell2mat(CRD.tR_se(:)),'y','Color',c(3,:),'LineWidth',2)
% errorbar2(X,Y2,cell2mat(LHON.tR_se(:)),'y','Color',c(4,:),'LineWidth',2)
% errorbar2(X,Y3,cell2mat(Ctl.tR_se(:)),'y','Color',[0.5,0.5,0.5],'LineWidth',2)
% errorbar2(X,Y4,cell2mat(JMD.tR_se(:)),'Color',c(2,:),'LineWidth',2)


xlabel('conTrack score thresh','fontName','Times','fontSize',12);
ylabel('Mean Volume [mm^3]','fontName','Times','fontSize',12);
title('Optic Tract','fontName','Times','fontSize',14);
axis([-0.2, 1.6, 0, 6000]);

hold off;
SE
%% save the figure in .png
% Figure を 512x384 のPNG
% "fig.png"
cd /biac4/wandell/biac3/wandell7/shumpei/matlab/git/LHON/6LHON_9JMD_8Ctl/VolumeComparison/OT_JMD_CRD_ctl

print(gcf,'-r0','-dpng','OT_Volume_JMD_CRD.png');
print(gcf,'-r0','-depsc','OT_Volume_JMD_CRD.eps');


%% Plot
% R-OT whole
c = lines(24);

Y1 = nanreplace(cell2mat(CRD.tR(:)));
Y2 = nanreplace(cell2mat(LHON.tR(:)));
% Y2 = nanreplace(cell2mat(JMD.tR(:)));
Y3 = nanreplace(cell2mat(Ctl.tR(:)));
% cell2mat(Ctl.tR_sd(:));

% Create figure
figure; hold on;

plot1 = plot(X,Y1)
set(plot1,'MarkerFaceColor',c(3,:),'MarkerEdgeColor',c(3,:),...
    'MarkerSize',10,...
    'Marker','+',...
    'LineWidth',2,...
    'Color',c(3,:));

plot2 =  plot(X,Y2,'MarkerFaceColor',c(4,:),'MarkerEdgeColor',c(4,:),...
    'MarkerSize',7,...
    'Marker','^',...
    'LineWidth',2,...
    'Color',c(4,:));

plot3 =  plot(X,Y3,'MarkerFaceColor',[0.5,0.5,0.5],'MarkerEdgeColor',[0.5,0.5,0.5],...
    'MarkerSize',7,...
    'Marker','o',...
    'LineWidth',2,...
    'Color',[0.5,0.5,0.5]);

legend('CRD', 'LHON', 'Ctl');
% add error bar(S.E.)
errorbar(X,Y1,cell2mat(CRD.tR_se(:)),'Color',c(3,:))
errorbar(X,Y2,cell2mat(LHON.tR_se(:)),'Color',c(4,:))
errorbar(X,Y3,cell2mat(Ctl.tR_se(:)),'Color',[0.5,0.5,0.5])

xlabel('conTrack score thresh','fontName','Times','fontSize',12);
ylabel('Mean Volume [mm^3]','fontName','Times','fontSize',12);
title('R-Optic Tract','fontName','Times','fontSize',14);
axis([-0.2, 1.6, 0, 6000]);

hold off;

%% save the figure in .png
% Figure を 512x384 のPNG
% "fig.png"
cd /biac4/wandell/biac3/wandell7/shumpei/matlab/git/LHON/6LHON_9JMD_8Ctl/VolumeComparison/CRD_LHON_Ctl

% width  = 512;
% height =384;
% set(gcf,'PaperPositionMode','auto')
% pos=get(gcf,'Position');
% pos(3)=width-1; %なぜか幅が1px増えるので対処
% pos(4)=height;
% set(gcf,'Position',pos);
print(gcf,'-r0','-dpng','ROT_Volume_SE.png');
print(gcf,'-r0','-depsc','ROT_Volume_SE.eps');


%% L-OTS (whole)
Y1 = nanreplace(cell2mat(CRD.tL(:)));
Y2 = nanreplace(cell2mat(LHON.tL(:)));
Y3 = nanreplace(cell2mat(Ctl.tL(:)));

figure;hold on;
plot1 = plot(X,Y1,'MarkerFaceColor',c(3,:),'MarkerEdgeColor',c(3,:),...
    'MarkerSize',10,...
    'Marker','+',...
    'LineWidth',2,...
    'Color',c(3,:));

plot2 =  plot(X,Y2,'MarkerFaceColor',c(4,:),'MarkerEdgeColor',c(4,:),...
    'MarkerSize',7,...
    'Marker','^',...
    'LineWidth',2,...
    'Color',c(4,:));


plot3 =  plot(X,Y3,'MarkerFaceColor',[0.5,0.5,0.5],'MarkerEdgeColor',[0.5,0.5,0.5],...
    'MarkerSize',7,...
    'Marker','o',...
    'LineWidth',2,...
    'Color',[0.5,0.5,0.5]);

legend('CRD', 'LHON', 'Ctl');
xlabel('conTrack score threshold','fontName','Times','fontSize',12);
ylabel('Mean Volume [mm^3]','fontName','Times','fontSize',12);
title('L-Optic Tract','fontName','Times','fontSize',14);

% add error bar
errorbar(X,Y1,cell2mat(CRD.tR_se(:)),'Color',c(3,:))
errorbar(X,Y2,cell2mat(LHON.tR_se(:)),'Color',c(4,:))
errorbar(X,Y3,cell2mat(Ctl.tR_se(:)),'Color',[0.5,0.5,0.5])
axis([-0.2, 1.6, 0, 6000])

hold off;

%% save the figure in .png

print(gcf,'-r0','-dpng','LOT_Volume_SE.png');
print(gcf,'-r0','-depsc','LOT_Volume_SE.eps');

