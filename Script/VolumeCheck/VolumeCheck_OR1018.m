function  VolumeCheck_OR1018
%%
% To save and score a hways

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

% cd /biac4/wandell/biac2/wandell/data/DWI-Tamagawa-Japan/AFQ_results/Volume_ctr_OR
% load 'Subject.mat';

%% argument checking
if notDefined('subjectnumber'), subjectnumber = 1:length(subjectDir);end
if notDefined('thresh'), thresh = [0.01, 0.1, 0.3, 0.5, 0.7 ,0.9, 1.1, 1.5];end
if notDefined('node'), nodes = 100;end

% Create Subject structure
Subject.ROR = struct('Volume',[],'nFiber',[]);
Subject.LOR = struct('Volume',[],'nFiber',[]);
Subject.name = {};

%% calculate the volume of fiver groups
for i = subjectnumber %19:23;
    
    fibersFolder2 = fullfile(baseDir, subjectDir{i}, '/dwi_2nd/fibers/conTrack/OR_Top100K_V1_3mm_clipped_LGN4mm');
    fibersFolder1 = fullfile(baseDir, subjectDir{i}, '/dwi_2nd/fibers');
    
    % Set the fullpath to data directory
    cd(fibersFolder2)
    
    Subject(i).name = subjectDir{i};
    Subject(i).ROR.subject = subjectDir{i};
    Subject(i).LOR.subject = subjectDir{i};
    
    % define file identifier
    Ids = {'LORV13mmClipBigNotROI5_clean_clean_D5_L4.mat',...
        'RORV13mmClipBigNotROI5_clean_clean_D5_L4.mat',...
        '*L-OR_0711*.pdb','*R-OR_0711*.pdb'};
    %%
    % Load fiber group
    for ij = 1:2 % Lh,Rh.
        switch ij
            case 1
                fgF1 = fullfile(fibersFolder1,Ids{1});
                fgF2 = dir(Ids{3});
            case 2
                fgF1 = fullfile(fibersFolder1,Ids{2});
                fgF2 = dir(Ids{4});
        end;
        
        
        [~,ik] = sort(cat(2,fgF2.bytes),2,'descend');
        fgF2 = fgF2(ik);
        
%         fgF = horzcat(fgF1,fgF2.name);
        for k = 1 : size(fgF,1)+1
            % orignal fibers and contrack fibers
            if k == 1;
                fg = fgRead(fgF1);
            else 
                fg = fgRead(fgF2(k-1).name);
            end;
            % devide fg in same number of nodes
            fg = dtiResampleFiberGroup(fg,nodes,[]); % default is number of nodes 100
            
            %  check the fiber direction it should be anterior to posterior
            for jj = 1:length(fg.fibers)
                if fg.fibers{jj}(2,1) < fg.fibers{jj}(2,nodes);
                    fg.fibers{jj}= fliplr(fg.fibers{jj});
                end
            end
            
            % checking fg number is enough or not
            if length(fg.fibers) <3,
                Volume{k+1} = zeros(100,1);
                nFiber(k+1) =length(fg.fibers);
            else
                Volume{k+1} = AFQ_TractProfileVolume(fg);
                nFiber(k+1) = length(fg.fibers);
            end;
        end
        
        choose Left or Right OR
        switch ij
            case 1
                Subject(i).LOR.Volume = Volume;
                Subject(i).LOR.nFiber = nFiber;
            case 2
                Subject(i).ROR.Volume = Volume;
                Subject(i).ROR.nFiber = nFiber;
        end
        
    end
end
return


%% plots ROR volume for each subjects
for i = 1:23%length(subjectDir);
    
    figure(i); hold on;
    c = lines(8);
    X = [0.01, 0.1, 0.3, 0.5, 0.7 ,0.9, 1.1, 1.5];
    for j = 1:length(X)
        Y = cell2mat(Subject(i).ROR.Volume(j));
        plot(1:100,Y,'linewidth',3,'Color',c(j,:));
    end
    legend('0.01', '0.1', '0.3', '0.5', '0.7' ,'0.9', '1.1', '1.5');
    xlabel('Location','fontName','Times','fontSize',12);
    ylabel('Volume [mm^3]','fontName','Times','fontSize',12);
    title('R-Optic Radiation Volume','fontName','Times','fontSize',14);
    hold off;
    
end

%% plots LOR volume for each subjects
for i = 1:23%length(subjectDir);
    
    figure(i); hold on;
    c = lines(8);
    X = [0.01, 0.1, 0.3, 0.5, 0.7 ,0.9, 1.1, 1.5];
    for j = 1:length(X)
        Y = cell2mat(Subject(i).LOR.Volume(j));
        plot(1:100,Y,'linewidth',3,'Color',c(j,:));
    end
    legend('0.01', '0.1', '0.3', '0.5', '0.7' ,'0.9', '1.1', '1.5');
    xlabel('Location','fontName','Times','fontSize',12);
    ylabel('Volume [mm^3]','fontName','Times','fontSize',12);
    title('L-Optic Radiation Volume','fontName','Times','fontSize',14);
    hold off;
end

%% plots mean volume of ROR
% for i = 1:length(subjectDir);

%     figure(i+24); hold on;
c = lines(23);
X = [0.01, 0.1, 0.3, 0.5, 0.7 ,0.9, 1.1, 1.5];

% calculate volume
% total_volumeR{j,i}=[];
% total_volumeL{j,i}=[];
% partial_volumeR{j,i}=[];
% partial_volumeL{j,i} =[];
% residual_volumeR{j,i}=[];
% residual_volumeL{j,i}=[];
% 
% total_nFiberR{j,i}=[];
% total_nFiberL{j,i}=[];
% Volume_varianceR=zeros(23,8,100);
% Volume_varianceL=zeros(23,8,100);


% define
for j = 1:length(X)
    for i = 1:length(subjectDir);
        %         for k = 1:100
        % whole optic radiation
        total_volumeR{j,i} = sum(Subject(i).ROR.Volume{j});
        total_volumeL{j,i} = sum(Subject(i).LOR.Volume{j});
        
        total_nFiberR{j,i} =  sum(Subject(i).ROR.nFiber(j));
        total_nFiberL{j,i} =  sum(Subject(i).LOR.nFiber(j));
        % partial optic radiation where node 50-85 is next to lateral ventricle
        partial_volumeR{j,i} = sum(Subject(i).ROR.Volume{j}(50:85,1));
        partial_volumeL{j,i} = sum(Subject(i).LOR.Volume{j}(50:85,1));
        % residual optic radiation node 1:49,85:100
        residual_volumeR{j,i} = total_volumeR{j,i}-partial_volumeR{j,i};
        residual_volumeL{j,i} = total_volumeL{j,i}-partial_volumeL{j,i};
        
        %         Volume_varianceR(i,j,k) = Subject(i).ROR.Volume{j}(k);
        %         Volume_varianceL(i,j,k) = Subject(i).LOR.Volume{j}(k);
        %         end
    end
end


% %% calculate volume in each group
% for j = 1:length(X)
%     % CRD
%     % Sum
%     sCRD.tR{j} = sum(horzcat(total_volumeR{j,1:9}))/(9-sum(horzcat(total_volumeR{j,1:9})==0));
%     sCRD.tL{j} = sum(horzcat(total_volumeL{j,1:9}))/(9-sum(horzcat(total_volumeL{j,1:9})==0));
%     
%     % std
%     sCRD.tR_sd{j} = nanstd(horzcat(total_volumeR{j,1:9}));
%     sCRD.tL_sd{j} = nanstd(horzcat(total_volumeL{j,1:9}));
%     %S.E.
%     sCRD.tR_se{j} = sCRD.tR_sd{j}/sqrt(9);
%     sCRD.tL_se{j} = sCRD.tL_sd{j}/sqrt(9);   
%     
%     
%     sCRD.pR{j} = sum(horzcat(partial_volumeR{j,1:9}))/(9-sum(horzcat(partial_volumeR{j,1:9})==0));
%     sCRD.pL{j} = sum(horzcat(partial_volumeL{j,1:9}))/(9-sum(horzcat(partial_volumeL{j,1:9})==0));
%     
%     sCRD.rR{j} = sum(horzcat(residual_volumeR{j,1:9}))/(9-sum(horzcat(residual_volumeR{j,1:9})==0));
%     sCRD.rL{j} = sum(horzcat(residual_volumeL{j,1:9}))/(9-sum(horzcat(residual_volumeL{j,1:9})==0));
%     
%     sCRD.nFiberR{j} = sum(horzcat(total_nFiberR{j,1:9}))/(9-sum(horzcat(total_nFiberR{j,1:9})==0));
%     sCRD.nFiberL{j} = sum(horzcat(total_nFiberL{j,1:9}))/(9-sum(horzcat(total_nFiberL{j,1:9})==0));
%     
%     
%     % LHON
%     sLHON.tR{j} = sum(horzcat(total_volumeR{j,10:15}))/(6-sum(horzcat(total_volumeR{j,10:15})==0));
%     sLHON.tL{j} = sum(horzcat(total_volumeL{j,10:15}))/(6-sum(horzcat(total_volumeL{j,10:15})==0));
%     
%     % std
%     sLHON.tR_sd{j} = nanstd(horzcat(total_volumeR{j,10:15}));
%     sLHON.tL_sd{j} = nanstd(horzcat(total_volumeL{j,10:15}));
%      %S.E.
%     sLHON.tR_se{j} = sLHON.tR_sd{j}/sqrt(6);
%     sLHON.tL_se{j} = sLHON.tL_sd{j}/sqrt(6);
%     
%     
%     
%     sLHON.pR{j} = sum(horzcat(partial_volumeR{j,10:15}))/(6-sum(horzcat(partial_volumeR{j,10:15})==0));
%     sLHON.pL{j} = sum(horzcat(partial_volumeL{j,10:15}))/(6-sum(horzcat(partial_volumeL{j,10:15})==0));
%     
%     sLHON.rR{j} = sum(horzcat(residual_volumeR{j,10:15}))/(6-sum(horzcat(residual_volumeR{j,10:15})==0));
%     sLHON.rL{j} = sum(horzcat(residual_volumeL{j,10:15}))/(6-sum(horzcat(residual_volumeL{j,10:15})==0));
%     
%     sLHON.nFiberR{j} = sum(horzcat(total_nFiberR{j,10:15}))/(6-sum(horzcat(total_nFiberR{j,10:15})==0));
%     sLHON.nFiberL{j} = sum(horzcat(total_nFiberL{j,10:15}))/(6-sum(horzcat(total_nFiberL{j,10:15})==0));
%     
%     % Ctl
%     sCtl.tR{j} = sum(horzcat(total_volumeR{j,16:23}))/(8-sum(horzcat(total_volumeR{j,16:23})==0));
%     sCtl.tL{j} = sum(horzcat(total_volumeL{j,16:23}))/(8-sum(horzcat(total_volumeL{j,16:23})==0));
%     
%     % std
%     sCtl.tR_sd{j} = nanstd(horzcat(total_volumeR{j,16:23}));
%     sCtl.tL_sd{j} = nanstd(horzcat(total_volumeL{j,16:23}));
%      % S.E.
%     sCtl.tR_se{j} = sCtl.tR_sd{j}/sqrt(6);
%     sCtl.tL_se{j} = sCtl.tL_sd{j}/sqrt(6);
%     
%     sCtl.pR{j} = sum(horzcat(partial_volumeR{j,16:23}))/(8-sum(horzcat(partial_volumeR{j,16:23})==0));
%     sCtl.pL{j} = sum(horzcat(partial_volumeL{j,16:23}))/(8-sum(horzcat(partial_volumeL{j,16:23})==0));
%     
%     sCtl.rR{j} = sum(horzcat(residual_volumeR{j,16:23}))/(8-sum(horzcat(residual_volumeR{j,16:23})==0));
%     sCtl.rL{j} = sum(horzcat(residual_volumeL{j,16:23}))/(8-sum(horzcat(residual_volumeL{j,16:23})==0));
%     
%     sCtl.nFiberR{j} = sum(horzcat(total_nFiberR{j,16:23}))/(8-sum(horzcat(total_nFiberR{j,16:23})==0));
%     sCtl.nFiberL{j} = sum(horzcat(total_nFiberL{j,16:23}))/(8-sum(horzcat(total_nFiberL{j,16:23})==0));
% end

%% calculate volume in each group
for j = 1:length(X)
    % CRD
    % Sum
    sCRD.tR{j} = sum(horzcat(total_volumeR{j,[2,4,7,8,9]}))/(5-sum(horzcat(total_volumeR{j,[2,4,7,8,9]})==0));
    sCRD.tL{j} = sum(horzcat(total_volumeL{j,[2,4,7,8,9]}))/(5-sum(horzcat(total_volumeL{j,[2,4,7,8,9]})==0));
    sCRD.tB{j} = sum((horzcat(total_volumeL{j,[2,4,7,8,9]},total_volumeR{j,[2,4,7,8,9]}))...
        /(10-sum(horzcat(total_volumeR{j,[2,4,7,8,9]},total_volumeL{j,[2,4,7,8,9]})==0)));
    
    % std
    sCRD.tR_sd{j} = nanstd(horzcat(total_volumeR{j,[2,4,7,8,9]}));
    sCRD.tL_sd{j} = nanstd(horzcat(total_volumeL{j,[2,4,7,8,9]}));
    sCRD.tB_sd{j} = nanstd((horzcat(total_volumeR{j,[2,4,7,8,9]},total_volumeL{j,[2,4,7,8,9]})));
    
    %S.E.
    sCRD.tR_se{j} = sCRD.tR_sd{j}/sqrt(5-sum(horzcat(total_volumeR{j,[2,4,7,8,9]})==0));
    sCRD.tL_se{j} = sCRD.tL_sd{j}/sqrt(5-sum(horzcat(total_volumeL{j,[2,4,7,8,9]})==0));
    sCRD.tB_se{j} = sCRD.tB_sd{j}/sqrt(10-sum(horzcat(total_volumeR{j,[2,4,7,8,9]},total_volumeL{j,[2,4,7,8,9]})==0));
    
    
    sCRD.nFiberR{j} = sum(horzcat(total_nFiberR{j,[2,4,7,8,9]}))/(5-sum(horzcat(total_nFiberR{j,[2,4,7,8,9]})==0));
    sCRD.nFiberL{j} = sum(horzcat(total_nFiberL{j,[2,4,7,8,9]}))/(5-sum(horzcat(total_nFiberL{j,[2,4,7,8,9]})==0));
    
    
    % LHON
    sLHON.tR{j} = sum(horzcat(total_volumeR{j,10:15}))/(6-sum(horzcat(total_volumeR{j,10:15})==0));
    sLHON.tL{j} = sum(horzcat(total_volumeL{j,10:15}))/(6-sum(horzcat(total_volumeL{j,10:15})==0));
    sLHON.tB{j} = sum(horzcat(total_volumeL{j,10:15},total_volumeR{j,10:15}))...
        /(12-sum(horzcat(total_volumeL{j,10:15},total_volumeR{j,10:15})==0));
    
    
    % std
    sLHON.tR_sd{j} = nanstd(horzcat(total_volumeR{j,10:15}));
    sLHON.tL_sd{j} = nanstd(horzcat(total_volumeL{j,10:15}));
    sLHON.tB_sd{j} = nanstd((horzcat(total_volumeR{j,10:15},total_volumeL{j,10:15})));
    
    %S.E.
    sLHON.tR_se{j} = sLHON.tR_sd{j}/sqrt(6-sum(horzcat(total_volumeR{j,10:15})==0));
    sLHON.tL_se{j} = sLHON.tL_sd{j}/sqrt(6-sum(horzcat(total_volumeL{j,10:15})==0));
    sLHON.tB_se{j} = sLHON.tB_sd{j}/sqrt(12-sum(horzcat(total_volumeR{j,10:15},total_volumeL{j,10:15})==0));
    
    
    sLHON.nFiberR{j} = sum(horzcat(total_nFiberR{j,10:15}))/(6-sum(horzcat(total_nFiberR{j,10:15})==0));
    sLHON.nFiberL{j} = sum(horzcat(total_nFiberL{j,10:15}))/(6-sum(horzcat(total_nFiberL{j,10:15})==0));
    
    % Ctl
    sCtl.tR{j} = sum(horzcat(total_volumeR{j,16:23}))/(8-sum(horzcat(total_volumeR{j,16:23})==0));
    sCtl.tL{j} = sum(horzcat(total_volumeL{j,16:23}))/(8-sum(horzcat(total_volumeL{j,16:23})==0));
    sCtl.tB{j} = sum(horzcat(total_volumeL{j,16:23},total_volumeR{j,16:23}))...
        /(16-sum(horzcat(total_volumeL{j,16:23},total_volumeR{j,16:23})==0));
    
    % std
    sCtl.tR_sd{j} = nanstd(horzcat(total_volumeR{j,16:23}));
    sCtl.tL_sd{j} = nanstd(horzcat(total_volumeL{j,16:23}));
    sCtl.tB_sd{j} = nanstd((horzcat(total_volumeR{j,16:23},total_volumeL{j,16:23})));
    
    % S.E.
    sCtl.tR_se{j} = sCtl.tR_sd{j}/sqrt(8-sum(horzcat(total_volumeR{j,16:23})==0));
    sCtl.tL_se{j} = sCtl.tL_sd{j}/sqrt(8-sum(horzcat(total_volumeL{j,16:23})==0));
    sCtl.tB_se{j} = sCtl.tB_sd{j}/sqrt(16-sum(horzcat(total_volumeR{j,16:23},total_volumeL{j,16:23})==0));
    
    
    
    sCtl.nFiberR{j} = sum(horzcat(total_nFiberR{j,16:23}))/(8-sum(horzcat(total_nFiberR{j,16:23})==0));
    sCtl.nFiberL{j} = sum(horzcat(total_nFiberL{j,16:23}))/(8-sum(horzcat(total_nFiberL{j,16:23})==0));
end

%% Plot
% R-OR whole

Y1 = cell2mat(sCRD.tR(:));
Y2 = cell2mat(sLHON.tR(:));
Y3 = cell2mat(sCtl.tR(:));
% cell2mat(sCtl.tR_sd(:));

% Create figure
figure(1001); hold on;

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

% legend('CRD', 'LHON', 'Ctl');
% add error bar
errorbar(X,Y1,cell2mat(sCRD.tR_se(:)),'Color',c(3,:))
errorbar(X,Y2,cell2mat(sLHON.tR_se(:)),'Color',c(4,:))
errorbar(X,Y3,cell2mat(sCtl.tR_se(:)),'Color',[0.5,0.5,0.5])


xlabel('conTrack score thresh','fontName','Times','fontSize',12);
ylabel('Mean Volume [mm^3]','fontName','Times','fontSize',12);
title('R-Optic Radiation','fontName','Times','fontSize',14);
axis([0,1.5,0, 160000])

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
print('-r0','-dpng','R-OR_Volume.png');

%%
print('-r0','-deps','R-OR_Volume.eps');


%% R-OR partial where is outside of lateral ventricle
Y1 = cell2mat(sCRD.pR(:));
Y2 = cell2mat(sLHON.pR(:));
Y3 = cell2mat(sCtl.pR(:));

figure(1002); hold on;
plot(X,Y1,X,Y2,X,Y3,'linewidth',3)

% legend('CRD', 'LHON', 'Ctl');
xlabel('conTrack score thresh','fontName','Times','fontSize',12);
ylabel('Mean Volume [mm^3]','fontName','Times','fontSize',12);
title('partial R-Optic Radiation','fontName','Times','fontSize',14);
hold off;

%% L-OR (whole)
Y1 = cell2mat(sCRD.tL(:));
Y2 = cell2mat(sLHON.tL(:));
Y3 = cell2mat(sCtl.tL(:));

figure(1003);hold on;
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

% legend('CRD', 'LHON', 'Ctl');
xlabel('conTrack score threshold','fontName','Times','fontSize',12);
ylabel('Mean Volume [mm^3]','fontName','Times','fontSize',12);
title('L-Optic Radiation','fontName','Times','fontSize',14);

% add error bar
errorbar(X,Y1,cell2mat(sCRD.tR_se(:)),'Color',c(3,:))
errorbar(X,Y2,cell2mat(sLHON.tR_se(:)),'Color',c(4,:))
errorbar(X,Y3,cell2mat(sCtl.tR_se(:)),'Color',[0.5,0.5,0.5])
axis([0,1.5,0, 180000])
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
print('-r0','-dpng','L-OR_Volume.png');

%%
print('-r0','-deps','L-OR_Volume.eps');



%% L-OR(partial)
y1 = cell2mat(sCRD.pL(:));
y2 = cell2mat(sLHON.pL(:));
y3 = cell2mat(sCtl.pL(:));

figure(1004);hold on;
plot(X,y1,X,y2,X,y3,'linewidth',3)

legend('CRD', 'LHON', 'Ctl');
xlabel('conTrack score thresh','fontName','Times','fontSize',12);
ylabel('Mean Volume [mm^3]','fontName','Times','fontSize',12);
title('Partial L-Optic Radiation','fontName','Times','fontSize',14);
hold off;

% R-OR(residual)
y1 = cell2mat(sCRD.rR(:));
y2 = cell2mat(sLHON.rR(:));
y3 = cell2mat(sCtl.rR(:));

figure(1005);hold on;
plot(X,y1,X,y2,X,y3,'linewidth',3)

legend('CRD', 'LHON', 'Ctl');
xlabel('conTrack score thresh','fontName','Times','fontSize',12);
ylabel('Mean Volume [mm^3]','fontName','Times','fontSize',12);
title('Residual R-Optic Radiation','fontName','Times','fontSize',14);
hold off;

% L-OR(residual)
y1 = cell2mat(sCRD.rL(:));
y2 = cell2mat(sLHON.rL(:));
y3 = cell2mat(sCtl.rL(:));

figure(1006);hold on;
plot(X,y1,X,y2,X,y3,'linewidth',3)

legend('CRD', 'LHON', 'Ctl');
xlabel('conTrack score thresh','fontName','Times','fontSize',12);
ylabel('Mean Volume [mm^3]','fontName','Times','fontSize',12);
title('Residual L-Optic Radiation','fontName','Times','fontSize',14);
hold off;

%% B-OR
Y1 = nanreplace(cell2mat(sCRD.tB(2:8)));
Y2 = nanreplace(cell2mat(sLHON.tB(2:8)));
Y3 = nanreplace(cell2mat(sCtl.tB(2:8)));
X = [0.1,0.3,0.5,0.7,0.9,1.1,1.5];

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

% legend('CRD', 'LHON', 'Ctl');
xlabel('conTrack score threshold','fontName','Times','fontSize',12);
ylabel('Mean Volume [mm^3]','fontName','Times','fontSize',12);
title('Optic Tract','fontName','Times','fontSize',14);

% add error bar
errorbar(X,Y1,cell2mat(sCRD.tB_se(2:8)),...
    'Color',c(3,:))
errorbar(X,Y2,cell2mat(sLHON.tB_se(2:8)),'Color',c(4,:))
errorbar(X,Y3,cell2mat(sCtl.tB_se(2:8)),'Color',[0.5,0.5,0.5])
axis([-0.1, 1.6, 0, 140000])

hold off;

%% B-OT 2
Y1 = nanreplace(cell2mat(sCRD.tB([1,3:9])));
Y2 = nanreplace(cell2mat(sLHON.tB([1,3:9])));
Y3 = nanreplace(cell2mat(sCtl.tB([1,3:9])));
X = [0, 0.1, 0.3, 0.5, 0.7 ,0.9, 1.1, 1.5];

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
title('Optic Tract','fontName','Times','fontSize',14);

% add error bar
errorbar(X,Y1,cell2mat(sCRD.tB_se([1,3:9])),'Color',c(3,:))
errorbar(X,Y2,cell2mat(sLHON.tB_se([1,3:9])),'Color',c(4,:))
errorbar(X,Y3,cell2mat(sCtl.tB_se([1,3:9])),'Color',[0.5,0.5,0.5])
axis([-0.1, 1.6 ,0, 6000])

hold off;

%% number of fibers
%R-OR nFiber(whole)
y1 = cell2mat(sCRD.nFiberR(:))/9;
y2 = cell2mat(sLHON.nFiberR(:))/6;
y3 = cell2mat(sCtl.nFiberR(:))/8;

figure(1007);hold on;
plot(X,y1,X,y2,X,y3,'linewidth',3)

legend('CRD', 'LHON', 'Ctl');
xlabel('conTrack score thresh','fontName','Times','fontSize',12);
ylabel('number of fibers','fontName','Times','fontSize',12);
title('R-Optic Radiation','fontName','Times','fontSize',14);
hold off;

%% L-OR nFiber(whole)
y1 = cell2mat(sCRD.nFiberL(:))/9;
y2 = cell2mat(sLHON.nFiberL(:))/6;
y3 = cell2mat(sCtl.nFiberL(:))/8;

figure(1008);hold on;
plot(X,y1,X,y2,X,y3,'linewidth',3)

legend('CRD', 'LHON', 'Ctl');
xlabel('conTrack score thresh','fontName','Times','fontSize',12);
ylabel('number of fibers','fontName','Times','fontSize',12);
title('L-Optic Radiation','fontName','Times','fontSize',14);
hold off;

%% Calculate diffusivities of fiber group

%Set directory structure
%% I. Directory and Subject Informatmation
vals_ROR.FA = [];
vals_ROR.MD = [];
vals_ROR.AD = [];
vals_ROR.RD = [];
vals_ROR.fiberlength = [];



vals_LOR.FA = [];
vals_LOR.MD = [];
vals_LOR.AD = [];
vals_LOR.RD = [];
vals_LOR.fiberlength = [];

%% Run the fiber properties functions
% subject loop
for i=1:numel(subjectDir)
    cur_sub = dir(fullfile(baseDir,[subjectDir{i} '*']));
    subDir   = fullfile(baseDir,cur_sub.name);
    dt6Dir   = fullfile(subDir,'dwi_2nd');
    fiberDir = fullfile(dt6Dir,'fibers/conTrack/OR_Top100K_V1_3mm_clipped_LGN4mm');
    %             roiDir   = fullfile(subDir,'dwi_2nd','ROIs');

    dt = dtiLoadDt6(fullfile(dt6Dir,'dt6.mat'));

    fprintf('\nProcessing %s\n', subDir);

    Ids = {
        '*L-OR_0711*.pdb'
        '*R-OR_0711*.pdb'};
    %
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
            else
                fg = dtiCleanFibers(fg);
                % set up the start point and end point of the fiber group
                for jj = 1:length(fg.fibers)
                    if fg.fibers{jj}(2,1) < fg.fibers{jj}(2,end);
                        fg.fibers{jj}= fliplr(fg.fibers{jj});
                    end
                end


                % Compute the fiber statistics and write them to the text file
                coords = horzcat(fg.fibers{:})';
                coords = unique(round(coords),'rows');
                % Im wondering that it
                % is better to unite voxels using unique

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


            switch  ij
                case 1
                    vals_LOR.FA{j,i} =fa;
                    vals_LOR.MD{j,i} =md;
                    vals_LOR.AD{j,i} =ad;
                    vals_LOR.RD{j,i} =rd;
                    vals_LOR.fiberlength{j,i} = fiberLength;

                case 2
                    vals_ROR.FA{j,i} =fa;
                    vals_ROR.MD{j,i} =md;
                    vals_ROR.AD{j,i} =ad;
                    vals_ROR.RD{j,i} =rd;
                    vals_ROR.fiberlength{j,i} = fiberLength;
            end
            clear fa;
            clear md;
            clear ad;
            clear rd;
        end
    end
end

return

%% Lets draw plots of diffusivities in optoc radiation

cd /biac4/wandell/biac2/wandell/data/DWI-Tamagawa-Japan/AFQ_results/Volume_ctr_OR
load vals_LOR
load vals_ROR

%%
%Some voxels have all the three eigenvalues equal to zero (some of them
%probably because they were originally negative, and were forced to zero).
%These voxels will produce a NaN FA

for j = 1:8
    % fa value in each voxels
%     LOR.FA.allvoxels{j} =  vertcat(vals_LOR.FA{j,:});
%     LOR.MD.allvoxels{j} =  vertcat(vals_LOR.MD{j,:});
%     LOR.AD.allvoxels{j} =  vertcat(vals_LOR.AD{j,:});
%     LOR.RD.allvoxels{j} =  vertcat(vals_LOR.RD{j,:});
%     
%     ROR.FA.allvoxels{j} =  vertcat(vals_ROR.FA{j,:});
%     ROR.MD.allvoxels{j} =  vertcat(vals_ROR.MD{j,:});
%     ROR.AD.allvoxels{j} =  vertcat(vals_ROR.AD{j,:});
%     ROR.RD.allvoxels{j} =  vertcat(vals_ROR.RD{j,:});
    
    % mean values
    LOR.meanFA{j} = mean(vertcat(vals_LOR.FA{j,:}));
    LOR.meanMD{j} = mean(vertcat(vals_LOR.MD{j,:}));
    LOR.meanAD{j} = mean(vertcat(vals_LOR.AD{j,:}));
    LOR.meanRD{j} = mean(vertcat(vals_LOR.RD{j,:}));
    
    ROR.meanFA{j} = mean(vertcat(vals_ROR.FA{j,:}));
    ROR.meanMD{j} = mean(vertcat(vals_ROR.MD{j,:}));
    ROR.meanAD{j} = mean(vertcat(vals_ROR.AD{j,:}));
    ROR.meanRD{j} = mean(vertcat(vals_ROR.RD{j,:}));
    
    
    
    
    % the value in each subject{i} and Thresh hold{j}
    for i =1:23
        
        LOR.FA.mean{j,i} =  mean(vals_LOR.FA{j,i});
        LOR.MD.mean{j,i} =  mean(vals_LOR.MD{j,i});
        LOR.AD.mean{j,i} =  mean(vals_LOR.AD{j,i});
        LOR.RD.mean{j,i} =  mean(vals_LOR.RD{j,i});
        
        ROR.FA.mean{j,i} =  mean(vals_ROR.FA{j,i});
        ROR.MD.mean{j,i} =  mean(vals_ROR.MD{j,i});
        ROR.AD.mean{j,i} =  mean(vals_ROR.AD{j,i});
        ROR.RD.mean{j,i} =  mean(vals_ROR.RD{j,i});
        
    end
end

%% plots the relationship FA and contrack score thresh hold
% Indivisual comparison
% FA L-OR in each subject
figure(2001); hold on;

for i =1:23
    c= lines(23);
    Y = vertcat(LOR.FA.mean{:,i});
    % y2 = cell2mat(sLHON.nFiberL(:));
    % y3 = cell2mat(sCtl.nFiberL(:));
    X = [0.01, 0.1, 0.3, 0.5, 0.7 ,0.9, 1.1, 1.5];
    
    plot(X,Y,'linewidth',2,'Color',c(i,:));
    scatter(X,Y,'fill')
    
    % legend('CRD', 'LHON', 'Ctl');
    xlabel('conTrack score thresh','fontName','Times','fontSize',14);
    ylabel('FA','fontName','Times','fontSize',12);
    title('L-Optic Radiation','fontName','Times','fontSize',14);
%     axis([0, 1.5 , 0.42 , 0.65])
end
hold off;

%% MD in L-OR in each subject
figure(2002);hold on;

for i =1:23
    
    c= lines(23);
    Y = vertcat(LOR.MD.mean{:,i});
%     Y = nanreplace(vertcat(LOR.MD.mean{:,i}));
    
    % y2 = cell2mat(sLHON.nFiberL(:));
    % y3 = cell2mat(sCtl.nFiberL(:));
    X = [0.01, 0.1, 0.3, 0.5, 0.7 ,0.9, 1.1, 1.5];
    
    plot(X,Y,'linewidth',2,'Color',c(i,:));
    scatter(X,Y,'fill')
    
end
% legend('CRD', 'LHON', 'Ctl');
xlabel('conTrack score thresh','fontName','Times','fontSize',14);
ylabel('MD','fontName','Times','fontSize',12);
title('L-Optic Radiation','fontName','Times','fontSize',14);
hold off;

%% FA in R-OR in each subject
figure(2100+1); hold on;
for i =1:23
    c = lines(23);
    Y = vertcat(ROR.FA.mean{:,i});
    % y2 = cell2mat(sLHON.nFiberL(:));
    % y3 = cell2mat(sCtl.nFiberL(:));
    X = [0.01, 0.1, 0.3, 0.5, 0.7 ,0.9, 1.1, 1.5];
    
    plot(X,Y,'linewidth',2,'Color',c(i,:));
    scatter(X,Y,'fill')
    
    % legend('CRD', 'LHON', 'Ctl');
    xlabel('conTrack score thresh','fontName','Times','fontSize',14);
    ylabel('FA','fontName','Times','fontSize',12);
    title('R-Optic Radiation','fontName','Times','fontSize',14);
    
end
hold off;


%% MD in R-OR in each subject
figure(2100+2); hold on;
for i =1:23
    c = lines(23);
    Y = vertcat(ROR.MD.mean{:,i});
    % y2 = cell2mat(sLHON.nFiberL(:));
    % y3 = cell2mat(sCtl.nFiberL(:));
    X = [0.01, 0.1, 0.3, 0.5, 0.7 ,0.9, 1.1, 1.5];
    
    plot(X,Y,'linewidth',2,'Color',c(i,:));
    scatter(X,Y,'fill')
    
    % legend('CRD', 'LHON', 'Ctl');
    xlabel('conTrack score thresh','fontName','Times','fontSize',14);
    ylabel('Mean Diffusivity','fontName','Times','fontSize',12);
    title('R-Optic Radiation','fontName','Times','fontSize',14);
    axis([0, 1.5 , 0.42 , 0.65])
    
end
hold off;



%% L-OT group comparison
% group comparison FA
figure(2010+1); hold on;
c= lines(23);

for j =1:8
    % chnge Nan to 0
    CRD  =  nanreplace(vertcat(LOR.FA.mean{j,1:9}));
    LHON =  nanreplace(vertcat(LOR.FA.mean{j,10:15}));  
    Ctl  =  nanreplace(vertcat(LOR.FA.mean{j,16:23})); 
    
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

CRD  =  nanreplace(vertcat(vals_LOR.FA{j,1:9}));

errorbar(X,Y3,cell2mat(sCtl.tR_sd(:)),'Color',c(3,:))
errorbar(X,Y2,cell2mat(sLHON.tR_sd(:)),'Color',c(2,:))


hold off;

%% L-OT
% group comparison MD
figure(2010+2); hold on;
c= lines(23);

for j =1:8
    % chnge Nan to 0
    CRD  =  vertcat(LOR.MD.mean{j,1:9});     CRD(isnan(CRD))=0;
    LHON =  vertcat(LOR.MD.mean{j,10:15});   LHON(isnan(LHON))=0;
    Ctl  =  vertcat(LOR.MD.mean{j,16:23});   Ctl(isnan(Ctl))=0;
    
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
title('L-Optic Radiation','fontName','Times','fontSize',14);
hold off;


%% L-OR
% group comparison AD
figure(2010+30); hold on;

for j =1:8
    % chnge Nan to 0
    CRD  =  nanreplace(vertcat(LOR.AD.mean{j,1:9}));     
    LHON =  nanreplace(vertcat(LOR.AD.mean{j,10:15}));  
    Ctl  =  nanreplace(vertcat(LOR.AD.mean{j,16:23}));   
    
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
title('L-Optic Radiation','fontName','Times','fontSize',14);
hold off;


%% group comparison RD
figure(2010+40); hold on;

for j =1:8
    % chnge Nan to 0
    CRD  =  nanreplace(vertcat(LOR.RD.mean{j,1:9}));     
    LHON =  nanreplace(vertcat(LOR.RD.mean{j,10:15}));  
    Ctl  =  nanreplace(vertcat(LOR.RD.mean{j,16:23}));   
    
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
title('R-Optic Radiation','fontName','Times','fontSize',14);
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




