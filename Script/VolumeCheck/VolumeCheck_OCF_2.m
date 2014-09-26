function  VolumeCheck_OCF_2
% clarify the relation conTrack score thresh hold and OCF volume and diffusivities
%
% you have to generate fiber groups which have different contrack score
% using s_conTrackScore_OCF_MD4
% SO 9/18/2013

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
%%
% 
% cd /biac4/wandell/biac2/wandell/data/DWI-Tamagawa-Japan/AFQ_results/Volume_OCF_V12_3mm_fsCC
% load 'Subject_OCF.mat';

%% argument checking
if notDefined('subjectnumber'), subjectnumber = 1:length(subjectDir);end
if notDefined('thresh'), thresh = [0.01, 0.1, 0.3, 0.5, 0.7 ,0.9, 1.1, 1.5];end
if notDefined('node'), nodes = 100;end

% % Create Subject structure
% Subject.OCF = struct('Volume',[],'nFiber',[],'length',[]);
% % Subject.LOR = struct('Volume',[],'nFiber',[]);
% Subject.name = {};

%% calculate the volume of fiver groups
for i = subjectnumber %19:23;
    
    fibersFolder = fullfile(baseDir, subjectDir{i}, '/dwi_2nd/fibers/conTrack/OCF_Top50K_fsV1V2_3mm');
    %     dt6Dir   = fullfile(subDir,'dwi_2nd');
    
    % Set the fullpath to data directory
    cd(fibersFolder)
    
    Subject(i).name = subjectDir{i};
    Subject(i).OCF.subject = subjectDir{i};
    
    % Load fiber group
    
    fgF1 = dir('*fg_OCF_Top50K_*+fs_CC.pdb');
    
    fgF = dir('OCF_fsCC_Ctr*.pdb');
    [~,ik] = sort(cat(2,fgF.bytes),2,'descend');
    fgF = fgF(ik);
    
    for k = 1 : size(fgF,1)+1
        % devide fg in same number of nodes
        if k==1;
                fg= fgRead(fgF1(1).name);
        else
        fg = fgRead(fgF(k-1).name);
        end
        fg = dtiResampleFiberGroup(fg,nodes,[]); % default is number of nodes 100
        
        %  check the start point and end point of the fiber group
        for jj = 1:length(fg.fibers)
            if fg.fibers{jj}(1,1) < fg.fibers{jj}(1,nodes);
                fg.fibers{jj}= fliplr(fg.fibers{jj});
            end
        end
        
        % checking fg number is enough or not
        if length(fg.fibers) <3,
            Volume{k} = zeros(100,1);
            nFiber(k) =length(fg.fibers);
        else
            Volume{k} = AFQ_TractProfileVolume(fg);
            nFiber(k) = length(fg.fibers);
        end;
    end
    
    % move data to Subject structure
    Subject(i).OCF.Volume = Volume;
    Subject(i).OCF.nFiber = nFiber;
    
end
return


%% plots OCF volume for each subjects
for i = 1:23; %length(subjectDir);
    
    figure(i); hold on;
    c = lines(8);
    X = [0.01, 0.1, 0.3, 0.5, 0.7 ,0.9, 1.1, 1.5];
    for j = 1:length(X)
        Y = cell2mat(Subject(i).OCF.Volume(j));
        plot(1:100,Y,'linewidth',3,'Color',c(j,:));
    end
    legend('0.01', '0.1', '0.3', '0.5', '0.7' ,'0.9', '1.1', '1.5');
    xlabel('Location','fontName','Times','fontSize',12);
    ylabel('Volume [mm^3]','fontName','Times','fontSize',12);
    title('Occipital callosal fiber Volume','fontName','Times','fontSize',14);
    hold off;
    
end

% %% calculate volume in each group
% X = [ 0.01, 0.1, 0.3, 0.5, 0.7 ,0.9, 1.1, 1.5];
% 
% for j = 1:length(X)
%     
%     for i = 1:length(subjectDir);
%         %         for k = 1:100
%         % whole optic Tract
%         total_volume{j,i} = sum(Subject(i).OCF.Volume{j});
%         
%         total_nFiber{j,i} =  sum(Subject(i).OCF.nFiber(j));
%         
%     end
%     
%     % CRD
%     % Sum
%     CRD.t(j) = sum(horzcat(total_volume{j,[2,4,7,8,9]}))/(5-sum(horzcat(total_volume{j,[2,4,7,8,9]})==0));
% %     CRD.tL{j} = sum(horzcat(total_volumeL{j,[2,4,7,8,9]}))/(5-sum(horzcat(total_volumeL{j,[2,4,7,8,9]})==0));
% %     CRD.B{j} = (CRD.tR{j} + CRD.tL{j})/2;
%     
%     
%     % std
%     CRD.t_sd(j) = nanstd(horzcat(total_volume{j,[2,4,7,8,9]}));
% %     CRD.tL_sd{j} = nanstd(horzcat(total_volumeL{j,[2,4,7,8,9]}));
% %     CRD.B_sd{j} = nanstd(horzcat(total_volumeL{j,[2,4,7,8,9]},total_volume{j,[2,4,7,8,9]}));
%     
%     
%     %S.E.
%     CRD.t_se(j) = CRD.t_sd{j}/sqrt(5-sum(horzcat(total_volume{j,[2,4,7,8,9]})==0));
% %     CRD.tL_se{j} = CRD.tL_sd{j}/sqrt(5-sum(horzcat(total_volumeL{j,[2,4,7,8,9]})==0));
% %     CRD.B_se{j} = CRD.B_sd{j}/sqrt(10-sum(horzcat(total_volumeL{j,[2,4,7,8,9]})==0)-sum(horzcat(total_volume{j,[2,4,7,8,9]})==0));
%     % number of fibers
%     CRD.nFiber(j) = sum(horzcat(total_nFiber{j,[2,4,7,8,9]}))/(4-sum(horzcat(total_nFiber{j,[2,4,7,8,9]})==0));
% %     CRD.nFiberL{j} = sum(horzcat(total_nFiberL{j,[2,4,7,8,9]}))/(4-sum(horzcat(total_nFiberL{j,[2,4,7,8,9]})==0));
%     
%     % JMD
%     JMD.t(j) = sum(horzcat(total_volume{j,[1,3,5,6]}))/(4-sum(horzcat(total_volume{j,[1,3,5,6]})==0));
% %     JMD.tL{j} = sum(horzcat(total_volumeL{j,[1,3,5,6]}))/(4-sum(horzcat(total_volumeL{j,[1,3,5,6]})==0));
% %     JMD.B{j} = (JMD.tR{j} + JMD.tL{j})/2;
%     
%     
%     % std
%     JMD.t_sd(j) = nanstd(horzcat(total_volume{j,[1,3,5,6]}));
% %     JMD.tL_sd{j} = nanstd(horzcat(total_volumeL{j,[1,3,5,6]}));
% %     JMD.B_sd{j} = nanstd(horzcat(total_volumeL{j,[1,3,5,6]},total_volume{j,[1,3,5,6]}));
%     
%     
%     %S.E.
%     JMD.t_se(j) = JMD.t_sd{j}/sqrt(4-sum(horzcat(total_volume{j,[1,3,5,6]})==0));
% %     JMD.tL_se{j} = JMD.tL_sd{j}/sqrt(4-sum(horzcat(total_volumeL{j,[1,3,5,6]})==0));
% %     JMD.B_se{j} = JMD.B_sd{j}/sqrt(8-sum(horzcat(total_volumeL{j,[1,3,5,6]})==0)-sum(horzcat(total_volume{j,[1,3,5,6]})==0));
%     
%     
%     JMD.nFiber(j) = sum(horzcat(total_nFiber{j,[1,3,5,6]}))/(4-sum(horzcat(total_nFiber{j,[1,3,5,6]})==0));
% %     JMD.nFiberL{j} = sum(horzcat(total_nFiberL{j,[1,3,5,6]}))/(4-sum(horzcat(total_nFiberL{j,[1,3,5,6]})==0));
%     
%     % LHON
%     LHON.t(j) = sum(horzcat(total_volume{j,10:15}))/(6-sum(horzcat(total_volume{j,10:15})==0));
% %     LHON.tL{j} = sum(horzcat(total_volumeL{j,10:15}))/(6-sum(horzcat(total_volumeL{j,10:15})==0));
% %     LHON.B{j} = (LHON.tR{j} + LHON.tL{j})/2;
%     
%     
%     % std
%     LHON.t_sd(j) = nanstd(horzcat(total_volume{j,10:15}));
% %     LHON.tL_sd{j} = nanstd(horzcat(total_volumeL{j,10:15}));
% %     LHON.B_sd{j} = nanstd(horzcat(total_volumeL{j,10:15},total_volume{j,10:15}));
%     
%     %S.E.
%     LHON.t_se(j) = LHON.t_sd{j}/sqrt(6-sum(horzcat(total_volume{j,10:15})==0));
% %     LHON.tL_se{j} = LHON.tL_sd{j}/sqrt(6-sum(horzcat(total_volumeL{j,10:15})==0));
% %     LHON.B_se{j} = LHON.B_sd{j}/sqrt(12-sum(horzcat(total_volumeL{j,10:15})==0)-sum(horzcat(total_volume{j,10:15})==0));
%     
%     
%     LHON.nFiber(j) = sum(horzcat(total_nFiber{j,10:15}))/(6-sum(horzcat(total_nFiber{j,10:15})==0));
% %     LHON.nFiberL{j} = sum(horzcat(total_nFiberL{j,10:15}))/(6-sum(horzcat(total_nFiberL{j,10:15})==0));
%     
%     % Ctl
%     Ctl.t(j) = sum(horzcat(total_volume{j,16:23}))/(8-sum(horzcat(total_volume{j,16:23})==0));
% %     Ctl.tL{j} = sum(horzcat(total_volumeL{j,16:23}))/(8-sum(horzcat(total_volumeL{j,16:23})==0));
% %     Ctl.B{j} = (Ctl.tR{j} + Ctl.tL{j})/2;
%     
%     
%     % std
%     Ctl.t_sd(j) = nanstd(horzcat(total_volume{j,16:23}));
% %     Ctl.tL_sd{j} = nanstd(horzcat(total_volumeL{j,16:23}));
% %     Ctl.B_sd{j} = nanstd(horzcat(total_volumeL{j,16:23},total_volume{j,16:23}));
%     
%     
%     % S.E.
%     Ctl.t_se(j) = Ctl.t_sd{j}/sqrt(8-sum(horzcat(total_volume{j,16:23})==0));
% %     Ctl.tL_se{j} = Ctl.tL_sd{j}/sqrt(8-sum(horzcat(total_volumeL{j,16:23})==0));
% %     Ctl.B_se{j} = Ctl.B_sd{j}/sqrt(16-sum(horzcat(total_volumeL{j,16:23})==0)-sum(horzcat(total_volume{j,16:23})==0));
%     
%     
%     
%     Ctl.nFiber(j) = sum(horzcat(total_nFiber{j,16:23}))/(8-sum(horzcat(total_nFiber{j,16:23})==0));
% %     Ctl.nFiberL{j} = sum(horzcat(total_nFiberL{j,16:23}))/(8-sum(horzcat(total_nFiberL{j,16:23})==0));
% end



%% plots mean volume of OCF
% for i = 1:length(subjectDir);

%     figure(i+24); hold on;
c = lines(23);
X = [0, 0.01, 0.1, 0.3, 0.5, 0.7 ,0.9, 1.1, 1.5];

% calculate volume
% total_volume{j,i}=[];

% define
for j = 1:length(X)
    for i = 1:length(subjectDir);
        
        % count number of fibers and volume in whole OCF
        total_volume{j,i} = sum(Subject(i).OCF.Volume{j});
        total_nFiber{j,i} =  sum(Subject(i).OCF.nFiber(j));
        
    end
end

% calculate volume in each group
for j = 1:length(X)
%     % CRD n= 9
%     % Sum
%     CRD.t{j} = sum(horzcat(total_volume{j,1:9}))/(9-sum(horzcat(total_volume{j,1:9})==0));    
%     % std
%     CRD.t_sd{j} = nanstd(horzcat(total_volume{j,1:9}));
%     % S.E.
%     CRD.t_se{j} = CRD.t_sd{j}/sqrt(9);
%     %
%     CRD.nFiber{j} = sum(horzcat(total_nFiber{j,1:9}))/(9-sum(horzcat(total_nFiber{j,1:9})==0));
    
    % CRD n=5
    % Sum
    CRD.t{j} = sum(horzcat(total_volume{j,[2,4,7,8,9]}))/(5-sum(horzcat(total_volume{j,[2,4,7,8,9]})==0));    
    % std
    CRD.t_sd{j} = nanstd(horzcat(total_volume{j,[2,4,7,8,9]}));
    % S.E.
    CRD.t_se{j} = CRD.t_sd{j}/sqrt(5);
    % number of fiber
    CRD.nFiber{j} = sum(horzcat(total_nFiber{j,[2,4,7,8,9]}))/(5-sum(horzcat(total_nFiber{j,[2,4,7,8,9]})==0));
    
    % Sum
    JMD.t{j} = sum(horzcat(total_volume{j,[1,3,5,6]}))/(4-sum(horzcat(total_volume{j,[1,3,5,6]})==0));    
    % std
    JMD.t_sd{j} = nanstd(horzcat(total_volume{j,[1,3,5,6]}));
    % S.E.
    JMD.t_se{j} = JMD.t_sd{j}/sqrt(4);
    % number of fiber
    JMD.nFiber{j} = sum(horzcat(total_nFiber{j,[1,3,5,6]}))/(4-sum(horzcat(total_nFiber{j,[1,3,5,6]})==0));
        
    % LHON
    LHON.t{j} = sum(horzcat(total_volume{j,10:15}))/(6-sum(horzcat(total_volume{j,10:15})==0));
    
    % std
    LHON.t_sd{j} = nanstd(horzcat(total_volume{j,10:15}));
    % S.E.
    LHON.t_se{j} = LHON.t_sd{j}/sqrt(6);
    
    LHON.nFiber{j} = sum(horzcat(total_nFiber{j,10:15}))/(6-sum(horzcat(total_nFiber{j,10:15})==0));
    
    % Ctl
    Ctl.t{j} = sum(horzcat(total_volume{j,16:23}))/(8-sum(horzcat(total_volume{j,16:23})==0)); 
    % std
    Ctl.t_sd{j} = nanstd(horzcat(total_volume{j,16:23}));
    % S.E
    Ctl.t_se{j} = Ctl.t_sd{j}/sqrt(8);

    
    Ctl.nFiber{j} = sum(horzcat(total_nFiber{j,16:23}))/(8-sum(horzcat(total_nFiber{j,16:23})==0));
end


%% Plot
% OCF
c = lines(100);

Y1 = cell2mat(CRD.t);
Y2 = cell2mat(LHON.t);
Y3 = cell2mat(Ctl.t);
Y4 = cell2mat(JMD.t);
% CRD_SE  = cell2mat(CRD.t_se);
% LHON_SE = cell2mat(LHON.t_se);
% Ctl_SE = cell2mat(Ctl.t_se);

% Create figure
figure; hold on;


% plot(X,Y1+CRD_SD,'--rs','LineWidth',2,'Color',c(1,:));
% plot(X,Y1-CRD_SD,'--rs','LineWidth',2,'Color',c(1,:));

CRDplot1 = plot(X,Y1,'MarkerFaceColor',c(3,:),'MarkerEdgeColor',c(3,:),...
    'MarkerSize',10,...
    'Marker','+',...
    'LineWidth',2,...
    'Color',c(3,:));

LHONplot2 =  plot(X,Y2,'MarkerFaceColor',c(4,:),'MarkerEdgeColor',c(4,:),...
    'MarkerSize',7,...coords
    'Marker','^',...
    'LineWidth',2,...
    'Color',c(4,:));

Ctlplot3 =  plot(X,Y3,'MarkerFaceColor',[0.5,0.5,0.5],'MarkerEdgeColor',[0.5,0.5,0.5],...
    'MarkerSize',7,...coords
    'Marker','o',...
    'LineWidth',2,...
    'Color',[0.5,0.5,0.5]);

% JMDplot =  plot(X,Y4,'MarkerFaceColor',c(2,:),'MarkerEdgeColor',c(2,:),...
%     'MarkerSize',7,...coords
%     'Marker','*',...
%     'LineWidth',2,...
%     'Color',c(2,:));

% legend('CRD', 'LHON', 'Ctl');

% add error bar S.E.
errorbar(X,Y1,cell2mat(CRD.t_se),'Color',c(3,:))
errorbar(X,Y2,cell2mat(LHON.t_se),'Color',c(4,:))
errorbar(X,Y3,cell2mat(Ctl.t_se),'Color',[0.5,0.5,0.5])
% errorbar(X,Y4,cell2mat(JMD.t_se(:)),'Color',c(2,:))


xlabel('conTrack score threshold','fontName','Times','fontSize',12);
ylabel('Mean Volume [mm^3]','fontName','Times','fontSize',12);
title('Occipital callosal fiber','fontName','Times','fontSize',14);
% axis([-0.1, 1.6, 0, 300000])

hold off;

%% save the figure in .png
cd /biac4/wandell/biac3/wandell7/shumpei/matlab/git/LHON/6LHON_9JMD_8Ctl/VolumeComparison/OCF_CRD_LHON
print(gcf,'-r0','-dpng','OCF_Volume_6LHON_5CRD_8Ctl_score0.png');
print(gcf,'-r0','-depsc','OCF_Volume_6LHON_5CRD_8Ctl_score0.eps');


%% Plot JMD CRD Ctl
% OCF
c = lines(100);

Y1 = cell2mat(CRD.t);
% Y2 = cell2mat(LHON.t);
Y3 = cell2mat(Ctl.t);
Y4 = cell2mat(JMD.t);

% Create figure
figure; hold on;

CRDplot1 = plot(X,Y1,'MarkerFaceColor',c(3,:),'MarkerEdgeColor',c(3,:),...
    'MarkerSize',10,...
    'Marker','+',...
    'LineWidth',2,...
    'Color',c(3,:));

% LHONplot2 =  plot(X,Y2,'MarkerFaceColor',c(4,:),'MarkerEdgeColor',c(4,:),...
%     'MarkerSize',7,...coords
%     'Marker','^',...
%     'LineWidth',2,...
%     'Color',c(4,:));

Ctlplot3 =  plot(X,Y3,'MarkerFaceColor',[0.5,0.5,0.5],'MarkerEdgeColor',[0.5,0.5,0.5],...
    'MarkerSize',7,...coords
    'Marker','o',...
    'LineWidth',2,...
    'Color',[0.5,0.5,0.5]);

JMDplot =  plot(X,Y4,'MarkerFaceColor',c(2,:),'MarkerEdgeColor',c(2,:),...
    'MarkerSize',7,...coords
    'Marker','*',...
    'LineWidth',2,...
    'Color',c(2,:));

% legend('CRD', 'LHON', 'Ctl');

% add error bar S.E.
errorbar(X,Y1,cell2mat(CRD.t_se),'Color',c(3,:))
% errorbar(X,Y2,cell2mat(LHON.t_se),'Color',c(4,:))
errorbar(X,Y3,cell2mat(Ctl.t_se),'Color',[0.5,0.5,0.5])
errorbar(X,Y4,cell2mat(JMD.t_se(:)),'Color',c(2,:))


xlabel('conTrack score threshold','fontName','Times','fontSize',12);
ylabel('Mean Volume [mm^3]','fontName','Times','fontSize',12);
title('Occipital callosal fiber','fontName','Times','fontSize',14);
% axis([-0.1, 1.6, 0, 300000])

hold off;

%% save the figure in .png
cd /biac4/wandell/biac3/wandell7/shumpei/matlab/git/LHON/6LHON_9JMD_8Ctl/VolumeComparison/OCF_CRD_LHON
print(gcf,'-r0','-dpng','OCF_Volume_scoring_4JMD_5CRD_8Ctl_score0.png');
print(gcf,'-r0','-depsc','OCF_Volume_scoring_4JMD_5CRD_8Ctl_score0.eps');


%% number of fibers
%R-OR nFiber(whole)
y1 = cell2mat(CRD.nFiber(:))/9;
y2 = cell2mat(LHON.nFiber(:))/6;
y3 = cell2mat(Ctl.nFiber(:))/8;

figure;hold on;
plot(X,y1,X,y2,X,y3,'linewidth',3)

legend('CRD', 'LHON', 'Ctl');
xlabel('conTrack score threshold','fontName','Times','fontSize',12);
ylabel('number of fibers','fontName','Times','fontSize',12);
title('Optic Tract','fontName','Times','fontSize',14);
hold off;

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Comparing diffusivities in each contrack thresh hold
%Set directory structure
%% I. Directory and Subject Informatmation
vals.FA = [];
vals.MD = [];
vals.AD = [];
vals.RD = [];
vals.fiberlength = [];

%% Run the fiber properties functions
% subject loop
for i= 1:numel(subjectDir)
    cur_sub = dir(fullfile(baseDir,[subjectDir{i} '*']));
    subDir   = fullfile(baseDir,cur_sub.name);
    dt6Dir   = fullfile(subDir,'dwi_2nd');
    fiberDir = fullfile(dt6Dir,'/fibers/conTrack/OCF_Top50K_fsV1V2_3mm');
    %             roiDir   = fullfile(subDir,'dwi_2nd','ROIs');
    
    dt = dtiLoadDt6(fullfile(dt6Dir,'dt6.mat'));
    
    fprintf('\nProcessing %s\n', subDir);
    cd(fiberDir)
    fgF = dir('OCF_fsCC_Ctr*.pdb');
    [~,ik] = sort(cat(2,fgF.bytes),2,'descend');
    fgF = fgF(ik);
    
    % fiber group loop
    for j= 1 : size(fgF,1)
        fiberGroup = fullfile(fiberDir, fgF(j).name);
        disp(['Computing dtiVals for ' fiberGroup ' ...']);
        fg = fgRead(fiberGroup);
        
        % checking number of fibers
        if isempty(fg.fibers);
            fa = [];
            md = [];
            rd = [];
            ad = [];
        else
            fg = dtiCleanFibers(fg);
            % set up the start point and end point of the fiber group
            % from L to R hemisphere
            for jj = 1:length(fg.fibers)
                if fg.fibers{jj}(2,1) < fg.fibers{jj}(2,end);
                    fg.fibers{jj}= fliplr(fg.fibers{jj});
                end
            end
            
            % Compute the fiber statistics and write them to the text file
%                         coords = horzcat(fg.fibers{:})';
            coords = unique(round(horzcat(fg.fibers{:})),'rows')';
            % Im wondering that it is better to unite voxels using unique
            
            %             numberOfFibers =numel(fg.fibers);
            
            % Measure the step size of the first fiber. They *should* all be the same!
            %             stepSize = mean(sqrt(sum(diff(fg.fibers{1},1,2).^2)));
            fiberLength = cellfun('length',fg.fibers);
            
            % The rest of the computation does not require remembering which node
            % belongd to which fiber.
            [val1,val2,val3,val4,val5,val6] = dtiGetValFromTensors(dt.dt6, coords, inv(dt.xformToAcpc),'dt6','nearest');
            dt6 = [val1,val2,val3,val4,val5,val6];
            
            % Clean the data in two ways.
            % Some fibers extend a little beyond the brain mask. Remove those points by
            % exploiting the fact that the tensor values out there are exactly zero.
            dt6 = dt6(~all(dt6==0,2),:);
            
            % There shouldn't be any nans, but let's make sure:
            dt6Nans = any(isnan(dt6),2);
            if(any(dt6Nans))
                dt6Nans = find(dt6Nans);
                for jj=1:6
                    dt6(dt6Nans,jj) = 0;
                end
                fprintf('\ NOTE: %d fiber points had NaNs. These will be ignored...',length(dt6Nans));
                disp('Nan points (ac-pc coords):');
                for jj=1:length(dt6Nans)
                    fprintf('%0.1f, %0.1f, %0.1f\n',coords(dt6Nans(jj),:));
                end
            end
            
            % We now have the dt6 data from all of the fibers.  We
            % extract the directions into vec and the eigenvalues into
            % val.  The units of val are um^2/sec or um^2/msec
            % mrDiffusion tries to guess the original units and convert
            % them to um^2/msec. In general, if the eigenvalues are
            % values like 0.5 - 3.0 then they are um^2/msec. If they
            % are more like 500 - 3000, then they are um^2/sec.
            %             [vec,val] = dtiEig(dt6);
            [~,val] = dtiEig(dt6);
            
            
            % Some of the ellipsoid fits are wrong and we get negative eigenvalues.
            % These are annoying. If they are just a little less than 0, then clipping
            % to 0 is not an entirely unreasonable thing. Maybe we should check for the
            % magnitude of the error?
            nonPD = find(any(val<0,2));
            if(~isempty(nonPD))
                fprintf('\n NOTE: %d fiber points had negative eigenvalues. These will be clipped to 0...\n', numel(nonPD));
                val(val<0) = 0;
            end
            numel(subjectDir)
            threeZeroVals=find(sum(val,2)==0);
            if ~isempty (threeZeroVals)
                fprintf('\n NOTE: %d of these fiber points had all three negative eigenvalues. These will be excluded from analyses\n', numel(threeZeroVals));
            end
            
            val(threeZeroVals,:)=[];
            
            % Now we have the eigenvalues just from the relevant fiber positions - but
            % all of them.  So we compute for every single node on the fibers, not just
            % the unique nodes.
            [fa,md,rd,ad] = dtiComputeFA(val);
        end
        
        %
        vals.FA{j,i} =fa;
        vals.MD{j,i} =md;
        vals.AD{j,i} =ad;
        vals.RD{j,i} =rd;
        vals.fiberlength{j,i} = fiberLength;
        
        clear fa;
        clear md;
        clear ad;
        clear rd;
    end
end
cd /biac4/wandell/biac2/wandell/data/DWI-Tamagawa-Japan/AFQ_results/Volume_OCF_V12_3mm_fsCC
save Subject_OCF_uniqueVoxel Subject
return

%% Lets draw plots of diffusivities in optoc radiation

cd /biac4/wandell/biac2/wandell/data/DWI-Tamagawa-Japan/AFQ_results/Volume_OCF_V12_3mm_fsCC
load vals_OCF

%%
%Some voxels have all the three eigenvalues equal to zero (some of them
%probably because they were originally negative, and were forced to zero).
%These voxels will produce a NaN FA

for j = 1:8
    for i =1:23
        
        % mean values
        % the value in each subject{i} and Thresh hold{j}
        meanFA(j,i) = mean(vertcat(vals.FA{j,i}));
        meanMD(j,i) = mean(vertcat(vals.MD{j,i}));
        meanAD(j,i) = mean(vertcat(vals.AD{j,i}));
        meanRD(j,i) = mean(vertcat(vals.RD{j,i}));
         
    end
end

%% plots the relationship FA and contrack score thresh hold
% Indivisual comparison
% FA L-OR in each subject
figure(2001); hold on;

for i =1:23
    c= lines(23);
    Y = meanFA(:,i);
    % y2 = cell2mat(LHON.nFiberL(:));
    % y3 = cell2mat(Ctl.nFiberL(:));
    X = [0.01, 0.1, 0.3, 0.5, 0.7 ,0.9, 1.1, 1.5];
    
    plot(X,Y,'linewidth',2,'Color',c(i,:));
    scatter(X,Y,'fill')
    
    % legend('CRD', 'LHON', 'Ctl');
    xlabel('conTrack sore thresh','fontName','Times','fontSize',14);
    ylabel('FA','fontName','Times','fontSize',12);
    title('Occipital callosal fiber','fontName','Times','fontSize',14);
end
hold off;

%% MD in OCF in each subject
figure(2002);hold on;

for i =1:23
    
    c = lines(23);
    Y = meanMD(:,i);
    %     Y = nanreplace(vertcat(LOR.MD.mean{:,i}));
    
    % y2 = cell2mat(LHON.nFiberL(:));
    % y3 = cell2mat(Ctl.nFiberL(:));
    X = [0.01, 0.1, 0.3, 0.5, 0.7 ,0.9, 1.1, 1.5];
    
    plot(X,Y,'linewidth',2,'Color',c(i,:));
    scatter(X,Y,'fill')
    
end
% legend('CRD', 'LHON', 'Ctl');
xlabel('conTrack sore thresh','fontName','Times','fontSize',14);
ylabel('MD','fontName','Times','fontSize',12);
title('Occipital callosal fiber','fontName','Times','fontSize',14);
hold off;



%% OCF group comparison
% group comparison FA
figure(2010+1); hold on;
c= lines(23);

for j =1:8
    % chnge Nan to 0
    % CRD n=9;
%     CRD  =  nanreplace((meanFA(j,1:9)));
%     Y1(j) = sum(CRD)/(length(CRD)-sum(CRD==0));
%     
    % CRD n=5; [2,4,7,8,9];
    CRD  =  nanreplace((meanFA(j,[2,4,7,8,9])));
    Y4(j) = sum(CRD)/(length(CRD)-sum(CRD==0));
    
    
    LHON =  nanreplace((meanFA(j,10:15)));
    Ctl  =  nanreplace((meanFA(j,16:23)));
    
    Y2(j) = sum(LHON)/(length(LHON)-sum(LHON==0));
    Y3(j) = sum(Ctl)/(length(Ctl)-sum(Ctl==0));
end
% y3 = cell2mat(Ctl.nFiberL(:));
X = [0.01, 0.1, 0.3, 0.5, 0.7 ,0.9, 1.1, 1.5];

% plot1 = plot(X,Y1,'MarkerFaceColor',[1 1 1],'MarkerEdgeColor',c(1,:),...
%     'MarkerSize',10,...
%     'Marker','+',...
%     'LineWidth',2,...
%     'Color',c(1,:));

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

plot4 =  plot(X,Y4,'MarkerFaceColor',c(3,:),'MarkerEdgeColor',c(3,:),...
    'MarkerSize',7,...
    'Marker','o',...
    'LineWidth',2,...
    'Color',c(3,:));


% legend('CRD', 'LHON', 'Ctl');
legend( 'LHON', 'Ctl','CRD');
xlabel('conTrack sore thresh','fontName','Times','fontSize',14);
ylabel('Fractional Anisotropy','fontName','Times','fontSize',12);
title('OCF','fontName','Times','fontSize',14);
hold off;

%% OCF MD
% group comparison MD
figure(2010+2); hold on;
c= lines(23);

for j =1:8
    % chnge Nan to 0
    CRD  =  meanMD(j,1:9);     
    LHON =  meanMD(j,10:15);   
    Ctl  =  meanMD(j,16:23);  
    
    Y1(j) = sum(CRD)/(length(CRD)-sum(CRD==0));
    Y2(j) = sum(LHON)/(length(LHON)-sum(LHON==0));
    Y3(j) = sum(Ctl)/(length(Ctl)-sum(Ctl==0));
end
% y3 = cell2mat(Ctl.nFiberL(:));
X = [0.01, 0.1, 0.3, 0.5, 0.7 ,0.9, 1.1, 1.5];

plot1 = plot(X,Y1,'MarkerFaceColor',[1 1 1],'MarkerEdgeColor',c(1,:),...
    'MarkerSize',10,...
    'Marker','+',...
    'LineWidth',2,...
    'Color',c(1,:));

plot2 =  plot(X,Y2,'MarkerFaceColor',[1 1 1],'MarkerEdgeColor',c(2,:),...
    'MarkerSize',7,...
    'Marker','^',...
    'LineWidth',2,...
    'Color',c(2,:));


plot3 =  plot(X,Y3,'MarkerFaceColor',[1 1 1],'MarkerEdgeColor',c(3,:),...
    'MarkerSize',7,...
    'Marker','o',...
    'LineWidth',2,...
    'Color',c(3,:));


legend('CRD', 'LHON', 'Ctl');
xlabel('conTrack sore thresh','fontName','Times','fontSize',14);
ylabel('Mean Diffusivity','fontName','Times','fontSize',12);
title('OCF','fontName','Times','fontSize',14);
hold off;


%% L-OR
% group comparison AD
figure(2010+30); hold on;

for j =1:8
    % 
    CRD  =  meanAD(j,1:9);     
    LHON =  meanAD(j,10:15);   
    Ctl  =  meanAD(j,16:23);  
    
    Y1(j) = sum(CRD)/(length(CRD)-sum(CRD==0));
    Y2(j) = sum(LHON)/(length(LHON)-sum(LHON==0));
    Y3(j) = sum(Ctl)/(length(Ctl)-sum(Ctl==0));
end
% y3 = cell2mat(Ctl.nFiberL(:));
X = [0.01, 0.1, 0.3, 0.5, 0.7 ,0.9, 1.1, 1.5];

plot1 = plot(X,Y1,'MarkerFaceColor',[1 1 1],'MarkerEdgeColor',c(1,:),...
    'MarkerSize',10,...
    'Marker','+',...
    'LineWidth',2,...
    'Color',c(1,:));

plot2 =  plot(X,Y2,'MarkerFaceColor',[1 1 1],'MarkerEdgeColor',c(2,:),...
    'MarkerSize',7,...
    'Marker','^',...
    'LineWidth',2,...
    'Color',c(2,:));


plot3 =  plot(X,Y3,'MarkerFaceColor',[1 1 1],'MarkerEdgeColor',c(3,:),...
    'MarkerSize',7,...
    'Marker','o',...
    'LineWidth',2,...
    'Color',c(3,:));


legend('CRD', 'LHON', 'Ctl');
xlabel('conTrack sore thresh','fontName','Times','fontSize',14);
ylabel('Axial Diffusivity','fontName','Times','fontSize',12);
title('OCF','fontName','Times','fontSize',14);
hold off;


%% group comparison RD
figure(2010+40); hold on;

for j =1:8
    % 
    CRD  =  meanRD(j,1:9);     
    LHON =  meanRD(j,10:15);   
    Ctl  =  meanRD(j,16:23); 
    
    Y1(j) = sum(CRD)/(length(CRD)-sum(CRD==0));
    Y2(j) = sum(LHON)/(length(LHON)-sum(LHON==0));
    Y3(j) = sum(Ctl)/(length(Ctl)-sum(Ctl==0));
end
% y3 = cell2mat(Ctl.nFiberL(:));
X = [0.01, 0.1, 0.3, 0.5, 0.7 ,0.9, 1.1, 1.5];

plot1 = plot(X,Y1,'MarkerFaceColor',[1 1 1],'MarkerEdgeColor',c(1,:),...
    'MarkerSize',10,...
    'Marker','+',...
    'LineWidth',2,...
    'Color',c(1,:));

plot2 =  plot(X,Y2,'MarkerFaceColor',[1 1 1],'MarkerEdgeColor',c(2,:),...
    'MarkerSize',7,...
    'Marker','^',...
    'LineWidth',2,...
    'Color',c(2,:));


plot3 =  plot(X,Y3,'MarkerFaceColor',[1 1 1],'MarkerEdgeColor',c(3,:),...
    'MarkerSize',7,...
    'Marker','o',...
    'LineWidth',2,...
    'Color',c(3,:));


legend('CRD', 'LHON', 'Ctl');
xlabel('conTrack sore thresh','fontName','Times','fontSize',14);
ylabel('Radial Diffusivity','fontName','Times','fontSize',12);
title('OCF','fontName','Times','fontSize',14);
hold off;
%%
