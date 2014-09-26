function  Netta30_VolumeCheck_OT
% Calculate number of voxels in Optic tract for LHON, CRD, and normal
% subjects.
%
%
% SO 9/25/2013

% Set directory
baseDir = '/biac4/wandell/biac3/wandell4/data/reading_longitude/dti_adults';
subjectDir =  {'aab050307','ah051003','am090121','ams051015','as050307'...
    'aw040809','bw040922','ct060309','db061209','dla050311'...
    'gd040901','gf050826','gm050308','jl040902','jm061209'...
    'jy060309','ka040923','mbs040503','me050126','mo061209'...
    'mod070307','mz040828','pp050208','rfd040630','rk050524'...
    'sc060523','sd050527','sn040831','sp050303','tl051015'};


%% argument checking
if notDefined('subjectnumber'), subjectnumber = 1:length(subjectDir);end
if notDefined('thresh'), thresh = [0.01, 0.1, 0.3, 0.5, 0.7 ,0.9, 1.1, 1.5];end
if notDefined('node'), nodes = 100;end
% %
% % Create Subject structure
% Subject.ROT = struct('Volume',[],'nFiber',[]);
% Subject.LOT = struct('Volume',[],'nFiber',[]);
% Subject.name = {};

%% calculate the volume of fiver groups
for i =subjectnumber; 
    
    fibersFolder = fullfile(baseDir, subjectDir{i}, '/dwi_2nd/fibers/conTrack/OpticTract5000');
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
                Ids = {'ROT_Ctr1.pdb','ROT_Ctr10.pdb','ROT_Ctr30.pdb','ROT_Ctr50.pdb',...
                    'ROT_Ctr70.pdb','ROT_Ctr90.pdb','ROT_Ctr1.100000e+02.pdb','ROT_Ctr150.pdb'};
            case 2
                Ids = {'LOT_Ctr1.pdb','LOT_Ctr10.pdb','LOT_Ctr30.pdb','LOT_Ctr50.pdb',...
                    'LOT_Ctr70.pdb','LOT_Ctr90.pdb','LOT_Ctr1.100000e+02.pdb','LOT_Ctr150.pdb'};
        end;
        
        for ij = 1:length(Ids)
            % devide fg in same number of nodes
            fg_ori = fgRead(Ids{ij});
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

return


%% plots ROT volume for each subjects
for i = subjectnumber;
    
    figure(i); hold on;
    c = lines(8);
    X = [0.01, 0.1, 0.3, 0.5, 0.7 ,0.9, 1.1, 1.5];
    for j = 1:length(X)
        Y = cell2mat(Subject(i).ROT.Volume(j));
        plot(1:100,Y,'linewidth',3,'Color',c(j,:));
    end
    legend('0.01', '0.1', '0.3', '0.5', '0.7' ,'0.9', '1.1', '1.5');
    xlabel('Location','fontName','Times','fontSize',12);
    ylabel('Volume [mm^3]','fontName','Times','fontSize',12);
    title('R-Optic Tract Volume','fontName','Times','fontSize',14);
    hold off;
    
end

%% plots LOT volume for each subjects
for i = 1:length(subjectDir);
    
    figure(i); hold on;
    c = lines(8);
    X = [0.01, 0.1, 0.3, 0.5, 0.7 ,0.9, 1.1, 1.5];
    for j = 1:length(X)
        Y = cell2mat(Subject(i).LOT.Volume(j));
        plot(1:100,Y,'linewidth',3,'Color',c(j,:));
    end
    legend('0.01', '0.1', '0.3', '0.5', '0.7' ,'0.9', '1.1', '1.5');
    xlabel('Location','fontName','Times','fontSize',12);
    ylabel('Volume [mm^3]','fontName','Times','fontSize',12);
    title('L-Optic Tract Volume','fontName','Times','fontSize',14);
    hold off;
end

%% plots mean volume of OT

X = [0.01, 0.1, 0.3, 0.5, 0.7 ,0.9, 1.1, 1.5];

% define
for j = 1:length(X)
    for i = 1:length(subjectDir);
        %         for k = 1:100
        % whole optic Tract
        total_volumeR{j,i} = sum(Subject(i).ROT.Volume{j});
        total_volumeL{j,i} = sum(Subject(i).LOT.Volume{j});
        
        total_nFiberR{j,i} =  sum(Subject(i).ROT.nFiber(j));
        total_nFiberL{j,i} =  sum(Subject(i).LOT.nFiber(j));
       
    end
end


%% calculate volume in each group
for j = 1:length(X)
    % CRD
    % Sum
    sCRD.tR{j} = sum(horzcat(total_volumeR{j,:}))/(30-sum(horzcat(total_volumeR{j,:})==0));
    sCRD.tL{j} = sum(horzcat(total_volumeL{j,:}))/(30-sum(horzcat(total_volumeL{j,:})==0));
    
    % std
    sCRD.tR_sd{j} = nanstd(horzcat(total_volumeR{j,:}));
    sCRD.tL_sd{j} = nanstd(horzcat(total_volumeL{j,:}));
    
    %S.E.
    sCRD.tR_se{j} = sCRD.tR_sd{j}/sqrt(30-sum(horzcat(total_volumeR{j,:})==0));
    sCRD.tL_se{j} = sCRD.tL_sd{j}/sqrt(30-sum(horzcat(total_volumeL{j,:})==0));
    
    sCRD.nFiberR{j} = sum(horzcat(total_nFiberR{j,:}))/(30-sum(horzcat(total_nFiberR{j,:})==0));
    sCRD.nFiberL{j} = sum(horzcat(total_nFiberL{j,:}))/(30-sum(horzcat(total_nFiberL{j,:})==0));
        
end

%% Plot
% R-OT whole
c = lines(30);

Y1 = nanreplace(cell2mat(sCRD.tR(:)));
% Y2 = nanreplace(cell2mat(sLHON.tR(:)));
% Y3 = nanreplace(cell2mat(sCtl.tR(:)));
% cell2mat(sCtl.tR_sd(:));

% Create figure
figure; hold on;

plot1 = plot(X,Y1)
set(plot1,'MarkerFaceColor',[0.5,0.5,0.5],'MarkerEdgeColor',[0.5,0.5,0.5],...
    'MarkerSize',10,...
    'Marker','+',...
    'LineWidth',2,...
    'Color',[0.5,0.5,0.5]);

% y1 = cell2mat(sCRD.nFiberR(:));
% 
% bar(X,y1,'linewidth',3)


% plot2 =  plot(X,Y2,'MarkerFaceColor',c(4,:),'MarkerEdgeColor',c(4,:),...
%     'MarkerSize',7,...
%     'Marker','^',...
%     'LineWidth',2,...
%     'Color',c(4,:));
% 
% plot3 =  plot(X,Y3,'MarkerFaceColor',[0.5,0.5,0.5],'MarkerEdgeColor',[0.5,0.5,0.5],...
%     'MarkerSize',7,...
%     'Marker','o',...
%     'LineWidth',2,...
%     'Color',[0.5,0.5,0.5]);

legend('GE Ctl n=30');
% add error bar(S.E.)
errorbar2(X,Y1,cell2mat(sCRD.tR_se(:)),1,'Color',[0.5,0.5,0.5])
% errorbar(X,Y2,cell2mat(sLHON.tR_se(:)),'Color',c(4,:))
% errorbar(X,Y3,cell2mat(sCtl.tR_se(:)),'Color',[0.5,0.5,0.5])

xlabel('conTrack score thresh','fontName','Times','fontSize',12);
ylabel('Mean Volume [mm^3]','fontName','Times','fontSize',12);
title('R-Optic Tract','fontName','Times','fontSize',14);
axis([0, 1.5, 0,2000]);

hold off;

%% save the figure in .png
% Figure を 512x384 のPNG
% "fig.png"
cd /biac4/wandell/biac3/wandell7/shumpei/matlab/git/LHON/Netta30/OT5K

width  = 512;
height =384;
set(gcf,'PaperPositionMode','auto')
pos=get(gcf,'Position');
pos(3)=width-1; %なぜか幅が1px増えるので対処
pos(4)=height;
set(gcf,'Position',pos);
print('-r0','-dpng','ROT_Netta30_Volume_SE.eps');


%% L-OT (whole)
Y1 = nanreplace(cell2mat(sCRD.tL(:)));


% Create figure
figure; hold on;

plot1 = plot(X,Y1)
set(plot1,'MarkerFaceColor',[0.5,0.5,0.5],'MarkerEdgeColor',[0.5,0.5,0.5],...
    'MarkerSize',10,...
    'Marker','+',...
    'LineWidth',2,...
    'Color',[0.5,0.5,0.5]);


legend('GE Ctl n=30');
% add error bar(S.E.)
errorbar2(X,Y1,cell2mat(sCRD.tL_se(:)),1,'Color',[0.5,0.5,0.5])


xlabel('conTrack score threshold','fontName','Times','fontSize',14);
ylabel('Mean Volume [mm^3]','fontName','Times','fontSize',14);
title('L-Optic Tract','fontName','Times','fontSize',14);


axis([0, 1.5, 0,2000]);

hold off;

%% save the figure in .png
% Figure を 1024x768 のPNG形式で
% "fig.png" に保存する例
width  = 512;
height =384;
set(gcf,'PaperPositionMode','auto')
pos=get(gcf,'Position');
pos(3)=width-1; %なぜか幅が1px増えるので対処
pos(4)=height;
set(gcf,'Position',pos);
print('-r0','-dpng','LOT_Netta30_Volume_SE.eps');


%% number of fibers
%R-OR nFiber(whole)
y1 = cell2mat(sCRD.nFiberR(:));


figure;hold on;
plot(X,y1,'linewidth',3)


legend('GE Ctl n=30');
xlabel('conTrack score thresh','fontName','Times','fontSize',12);
ylabel('mean number of fibers','fontName','Times','fontSize',12);
title('R-Optic Tract','fontName','Times','fontSize',14);
hold off;

%% L-OT nFiber(whole)
y1 = cell2mat(sCRD.nFiberL(:))/9;


figure;hold on;
plot(X,y1,X,y2,X,y3,'linewidth',3)

legend('CRD', 'LHON', 'Ctl');
xlabel('conTrack score thresh','fontName','Times','fontSize',12);
ylabel('mean number of fibers','fontName','Times','fontSize',12);
title('L-Optic Tract','fontName','Times','fontSize',14);
hold off;

%% Calculate diffusivities of fiber group

%Set directory structure
%% I. Directory and Subject Informatmation
vals_ROT.FA = [];
vals_ROT.MD = [];
vals_ROT.AD = [];
vals_ROT.RD = [];
vals_ROT.fiberlength = [];



vals_LOT.FA = [];
vals_LOT.MD = [];
vals_LOT.AD = [];
vals_LOT.RD = [];
vals_LOT.fiberlength = [];

%% Run the fiber properties functions
% subject loop
for i=1:numel(subjectDir)
    cur_sub = dir(fullfile(baseDir,[subjectDir{i} '*']));
    subDir   = fullfile(baseDir,cur_sub.name);
    dt6Dir   = fullfile(subDir,'dwi_2nd');
    fiberDir = fullfile(dt6Dir,'/fibers/conTrack/OT_5K');
    %             roiDir   = fullfile(subDir,'dwi_2nd','ROIs');
    
    dt = dtiLoadDt6(fullfile(dt6Dir,'dt6.mat'));
    
    fprintf('\nProcessing %s\n', subDir);
    
    Ids = {'*LOT_Ctr*.pdb'
        '*ROT_Ctr*.pdb'};
    %%
    % Load fiber group
    % Left and Right loop
    for ij = 1:length(Ids)
        fgF = dir(fullfile(fiberDir,Ids{ij}));
        [~,ik] = sort(cat(2,fgF.bytes),2,'descend');
        fgF = fgF(ik);
        
        % Read in fiber groups
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
                %                 fiberLength = [];
            else
                fg = dtiCleanFibers(fg);
                % set up the start point and end point of the fiber group
                for jj = 1:length(fg.fibers)
                    if fg.fibers{jj}(2,1) < fg.fibers{jj}(2,end);
                        fg.fibers{jj}= fliplr(fg.fibers{jj});
                    end
                end
                
                
                
                % Compute the fiber statistics and write them to the text file
                coords = horzcat(fg.fibers{:})'; % Im wondering that it is better to unite voxels using unique
                
                %             numberOfFibers =numel(fg.fibers);
                
                % Measure the step size of the first fiber. They *should* all be the same!
                %             stepSize = mean(sqrt(sum(diff(fg.fibers{1},1,2).^2)));
                %                 fiberLength = cellfun('length',fg.fibers);
                
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
            
            
            switch  ij
                case 1
                    vals_LOT.FA{j,i} =fa;
                    vals_LOT.MD{j,i} =md;
                    vals_LOT.AD{j,i} =ad;
                    vals_LOT.RD{j,i} =rd;
                    %                     vals_LOT.fiberlength{j,i} = fiberLength;
                    
                case 2
                    vals_ROT.FA{j,i} =fa;
                    vals_ROT.MD{j,i} =md;
                    vals_ROT.AD{j,i} =ad;
                    vals_ROT.RD{j,i} =rd;
                    %                     vals_ROT.fiberlength{j,i} = fiberLength;
            end
            clear fa;
            clear md;
            clear ad;
            clear rd;
        end
    end
end

return

%% Lets draw plots of diffusivities in optoc Tract

cd /biac4/wandell/biac2/wandell/data/DWI-Tamagawa-Japan/AFQ_results/Volume_ctr_OR
load vals_LOT
load vals_ROT

%%
%Some voxels have all the three eigenvalues equal to zero (some of them
%probably because they were originally negative, and were forced to zero).
%These voxels will produce a NaN FA

for j = 1:8
    % fa value in each voxels
    %     LOT.FA.allvoxels{j} =  vertcat(vals_LOT.FA{j,:});
    %     LOT.MD.allvoxels{j} =  vertcat(vals_LOT.MD{j,:});
    %     LOT.AD.allvoxels{j} =  vertcat(vals_LOT.AD{j,:});
    %     LOT.RD.allvoxels{j} =  vertcat(vals_LOT.RD{j,:});
    %
    %     ROT.FA.allvoxels{j} =  vertcat(vals_ROT.FA{j,:});
    %     ROT.MD.allvoxels{j} =  vertcat(vals_ROT.MD{j,:});
    %     ROT.AD.allvoxels{j} =  vertcat(vals_ROT.AD{j,:});
    %     ROT.RD.allvoxels{j} =  vertcat(vals_ROT.RD{j,:});
    
    % mean values
    LOT.meanFA{j} = mean(vertcat(vals_LOT.FA{j,:}));
    LOT.meanMD{j} = mean(vertcat(vals_LOT.MD{j,:}));
    LOT.meanAD{j} = mean(vertcat(vals_LOT.AD{j,:}));
    LOT.meanRD{j} = mean(vertcat(vals_LOT.RD{j,:}));
    
    ROT.meanFA{j} = mean(vertcat(vals_ROT.FA{j,:}));
    ROT.meanMD{j} = mean(vertcat(vals_ROT.MD{j,:}));
    ROT.meanAD{j} = mean(vertcat(vals_ROT.AD{j,:}));
    ROT.meanRD{j} = mean(vertcat(vals_ROT.RD{j,:}));
    
    
    
    
    % the value in each subject{i} and Thresh hold{j}
    for i =1:23
        
        LOT.FA.mean{j,i} =  mean(vals_LOT.FA{j,i});
        LOT.MD.mean{j,i} =  mean(vals_LOT.MD{j,i});
        LOT.AD.mean{j,i} =  mean(vals_LOT.AD{j,i});
        LOT.RD.mean{j,i} =  mean(vals_LOT.RD{j,i});
        
        ROT.FA.mean{j,i} =  mean(vals_ROT.FA{j,i});
        ROT.MD.mean{j,i} =  mean(vals_ROT.MD{j,i});
        ROT.AD.mean{j,i} =  mean(vals_ROT.AD{j,i});
        ROT.RD.mean{j,i} =  mean(vals_ROT.RD{j,i});
        
    end
end

%% plots the relationship FA and contrack score thresh hold
% Indivisual comparison
% FA L-OR in each subject
figure(2001); hold on;

for i =1:23
    c= lines(23);
    Y = vertcat(LOT.FA.mean{:,i});
    % y2 = cell2mat(sLHON.nFiberL(:));
    % y3 = cell2mat(sCtl.nFiberL(:));
    X = [0.01, 0.1, 0.3, 0.5, 0.7 ,0.9, 1.1, 1.5];
    
    plot(X,Y,'linewidth',2,'Color',c(i,:));
    scatter(X,Y,'fill')
    
    % legend('CRD', 'LHON', 'Ctl');
    xlabel('conTrack score thresh','fontName','Times','fontSize',14);
    ylabel('FA','fontName','Times','fontSize',12);
    title('L-Optic Tract','fontName','Times','fontSize',14);
end
hold off;

%% MD in L-OR in each subject
figure(2002);hold on;

for i =1:23
    
    c= lines(23);
    Y = vertcat(LOT.MD.mean{:,i});
    %     Y = nanreplace(vertcat(LOT.MD.mean{:,i}));
    
    % y2 = cell2mat(sLHON.nFiberL(:));
    % y3 = cell2mat(sCtl.nFiberL(:));
    X = [0.01, 0.1, 0.3, 0.5, 0.7 ,0.9, 1.1, 1.5];
    
    plot(X,Y,'linewidth',2,'Color',c(i,:));
    scatter(X,Y,'fill')
    
end
% legend('CRD', 'LHON', 'Ctl');
xlabel('conTrack score thresh','fontName','Times','fontSize',14);
ylabel('MD','fontName','Times','fontSize',12);
title('L-Optic Tract','fontName','Times','fontSize',14);
hold off;

%% FA in R-OR in each subject
figure(2100+1); hold on;
for i =1:23
    c = lines(23);
    Y = vertcat(ROT.FA.mean{:,i});
    % y2 = cell2mat(sLHON.nFiberL(:));
    % y3 = cell2mat(sCtl.nFiberL(:));
    X = [0.01, 0.1, 0.3, 0.5, 0.7 ,0.9, 1.1, 1.5];
    
    plot(X,Y,'linewidth',2,'Color',c(i,:));
    scatter(X,Y,'fill')
    
    % legend('CRD', 'LHON', 'Ctl');
    xlabel('conTrack score thresh','fontName','Times','fontSize',14);
    ylabel('FA','fontName','Times','fontSize',12);
    title('R-Optic Tract','fontName','Times','fontSize',14);
    
end
hold off;


%% MD in R-OR in each subject
figure(2100+2); hold on;
for i =1:23
    c = lines(23);
    Y = vertcat(ROT.MD.mean{:,i});
    % y2 = cell2mat(sLHON.nFiberL(:));
    % y3 = cell2mat(sCtl.nFiberL(:));
    X = [0.01, 0.1, 0.3, 0.5, 0.7 ,0.9, 1.1, 1.5];
    
    plot(X,Y,'linewidth',2,'Color',c(i,:));
    scatter(X,Y,'fill')
    
    % legend('CRD', 'LHON', 'Ctl');
    xlabel('conTrack score thresh','fontName','Times','fontSize',14);
    ylabel('Mean Diffusivity','fontName','Times','fontSize',12);
    title('R-Optic Tract','fontName','Times','fontSize',14);
    axis([0, 1.5 , 0.42 , 0.65])
    
end
hold off;



%% L-OR group comparison
% group comparison FA
figure(2010+1); hold on;
c= lines(23);

for j =1:8
    % chnge Nan to 0
    CRD  =  nanreplace(vertcat(LOT.FA.mean{j,1:9}));
    LHON =  nanreplace(vertcat(LOT.FA.mean{j,10:15}));
    Ctl  =  nanreplace(vertcat(LOT.FA.mean{j,16:23}));
    
    Y1(j) = sum(CRD)/(length(CRD)-sum(CRD==0));
    Y2(j) = sum(LHON)/(length(LHON)-sum(LHON==0));
    Y3(j) = sum(Ctl)/(length(Ctl)-sum(Ctl==0));
end
% y3 = cell2mat(sCtl.nFiberL(:));
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
xlabel('conTrack score thresh','fontName','Times','fontSize',14);
ylabel('Fractional Anisotropy','fontName','Times','fontSize',12);
title('L-Optic Tract','fontName','Times','fontSize',14);

% add error bar
errorbar(X,Y1,cell2mat(sCRD.tR_sd(:)),'Color',c(1,:))

CRD  =  nanreplace(vertcat(vals_LOT.FA{j,1:9}));

errorbar(X,Y3,cell2mat(sCtl.tR_sd(:)),'Color',c(3,:))
errorbar(X,Y2,cell2mat(sLHON.tR_sd(:)),'Color',c(2,:))


hold off;

%% L-OR
% group comparison MD
figure(2010+2); hold on;
c= lines(23);

for j =1:8
    % chnge Nan to 0
    CRD  =  vertcat(LOT.MD.mean{j,1:9});     CRD(isnan(CRD))=0;
    LHON =  vertcat(LOT.MD.mean{j,10:15});   LHON(isnan(LHON))=0;
    Ctl  =  vertcat(LOT.MD.mean{j,16:23});   Ctl(isnan(Ctl))=0;
    
    Y1(j) = sum(CRD)/(length(CRD)-sum(CRD==0));
    Y2(j) = sum(LHON)/(length(LHON)-sum(LHON==0));
    Y3(j) = sum(Ctl)/(length(Ctl)-sum(Ctl==0));
end
% y3 = cell2mat(sCtl.nFiberL(:));
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
xlabel('conTrack score thresh','fontName','Times','fontSize',14);
ylabel('Mean Diffusivity','fontName','Times','fontSize',12);
title('L-Optic Tract','fontName','Times','fontSize',14);
hold off;


%% L-OR
% group comparison AD
figure(2010+30); hold on;

for j =1:8
    % chnge Nan to 0
    CRD  =  nanreplace(vertcat(LOT.AD.mean{j,1:9}));
    LHON =  nanreplace(vertcat(LOT.AD.mean{j,10:15}));
    Ctl  =  nanreplace(vertcat(LOT.AD.mean{j,16:23}));
    
    Y1(j) = sum(CRD)/(length(CRD)-sum(CRD==0));
    Y2(j) = sum(LHON)/(length(LHON)-sum(LHON==0));
    Y3(j) = sum(Ctl)/(length(Ctl)-sum(Ctl==0));
end
% y3 = cell2mat(sCtl.nFiberL(:));
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
xlabel('conTrack score thresh','fontName','Times','fontSize',14);
ylabel('Axial Diffusivity','fontName','Times','fontSize',12);
title('L-Optic Tract','fontName','Times','fontSize',14);
hold off;


%% group comparison RD
figure(2010+40); hold on;

for j =1:8
    % chnge Nan to 0
    CRD  =  nanreplace(vertcat(LOT.RD.mean{j,1:9}));
    LHON =  nanreplace(vertcat(LOT.RD.mean{j,10:15}));
    Ctl  =  nanreplace(vertcat(LOT.RD.mean{j,16:23}));
    
    Y1(j) = sum(CRD)/(length(CRD)-sum(CRD==0));
    Y2(j) = sum(LHON)/(length(LHON)-sum(LHON==0));
    Y3(j) = sum(Ctl)/(length(Ctl)-sum(Ctl==0));
end
% y3 = cell2mat(sCtl.nFiberL(:));
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
xlabel('conTrack score thresh','fontName','Times','fontSize',14);
ylabel('Radial Diffusivity','fontName','Times','fontSize',12);
title('R-Optic Tract','fontName','Times','fontSize',14);
hold off;
%%






%%
FA.min{j}  = min(Total.FA{j});
meanFA{i} = mean(fa(~isnan(fa)));
maxFA{i}  = max(fa(~isnan(fa))); % isnan is needed because sometimes if all the three eigenvalues are negative, the FA becomes NaN. These voxels are noisy.
MD(1)     = min(md);
MD(2)     = mean(md);
MD(3)     = max(md);numel(subjectDir)
radialADC(1) = min(rd);
radial
ADC(2) = mean(rd);
radialADC(3) = max(rd);
axialADC(1)  = min(ad);
axialADC(2)  = mean(ad);
axialADC(3)  = max(ad);
length(1) = mean(fiberLength)*stepSize;
length(2) = min(fiberLength)*stepSize;
length(3) = max(fiberLength)*stepSize;

avgFA = FA(2);
avgMD = MD(2);
avgRD = radialADC(2);
avgAD = axialADC(2);
avgLength = length(1);
minLength = length(2);
maxLength = length(3);
numFibers = numel(fg.fibers);
meanScore = mean(fg.params{2}.stat);




