function [TractProfile, fg_SDm4,fg_SDm3,fg_SDm2,fg_SDm1,fg_SD1,fg_SD2,fg_SD3,fg_SD4] = ...
    runSO_DivideFibersAcordingToFiberLength

homeDir = '/biac4/wandell/biac2/wandell/data/DWI-Tamagawa-Japan';

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
     'RP3-TO-13120611-DWI'};
 
%% Calculate vals along the fibers and return TP structure
for i =1:length(subDir)
    % define directory
    SubDir = fullfile(homeDir,subDir{i});
    fgDir  = fullfile(SubDir,'/dwi_2nd/fibers');
    %     newDir = fullfile(SubDir,'/dwi_2nd/fibers/conTrack/OR_1130');
    %     roiDir = fullfile(SubDir,'/dwi_2nd/ROIs');
    dt  = fullfile(homeDir,subDir{i},'dwi_2nd','dt6.mat');
    dt  = dtiLoadDt6(dt);
%     cd(fgDir_contrack)
    cd /biac4/wandell/biac3/wandell7/shumpei/matlab/git/LHON/3RP
    
%     'OCFV1V2Not3mm_MD4Al.pdb'
    fgN ={'ROR1206_D4L4.pdb','LOR1206_D4L4.pdb','ROTD4L4_1206.pdb','LOTD4L4_1206.pdb',...
        'ROCF_D4L4.pdb','LOCF_D4L4.pdb'}; 
 
    for jj =1:length(fgN) 
    fgF{jj} = {fullfile(SubDir,fgN{jj})};
    end
    
    for j =  1:length(fgF)
    [TractProfile{i,j}, fg_SDm3{i,j},fg_SDm2{i,j},fg_SDm1{i,j},fg_SD1{i,j},fg_SD2{i,j},fg_SD3{i,j}]...
        = SO_DivideFibersAcordingToFiberLength_SD3(fgF{j},dt,0,'AP',100);
    end
end
save 3RP_cont_MRT_TractProfile TractProfile
return
%%
for i =[19,22]%:length(subDir)
    % define directory
    SubDir = fullfile(homeDir,subDir{i});
%     fgDir_contrack  = fullfile(SubDir,'/dwi_2nd/fibers/conTrack/OR_1130');
    %     newDir = fullfile(SubDir,'/dwi_2nd/fibers/conTrack/OR_1130');
    %     roiDir = fullfile(SubDir,'/dwi_2nd/ROIs');
    dt  = fullfile(homeDir,subDir{i},'dwi_2nd','dt6.mat');
    dt  = dtiLoadDt6(dt);
%     cd(fgDir_contrack)
    cd /biac4/wandell/biac3/wandell7/shumpei/matlab/git/LHON/3RP

    fgF = {fullfile(SubDir,'/dwi_2nd/fibers/conTrack/OR_1130/LOR_1201.pdb'),...
        fullfile(SubDir,'/dwi_2nd/fibers/mrtrix2/dwi2nd_aligned_trilin_csd_lmax2_Rt-LGN4_rh_V1_smooth3mm_NOT_Rt-LGN4_rh_V1_smooth3mm_NOT_Right-Cerebral-White-Matter_Rt-LGN4_prob_MD4.pdb')};
    
    for j =  1
    [TractProfile{i,j}, fg_SDm4{i,j},fg_SDm3{i,j},fg_SDm2{i,j},fg_SDm1{i,j},fg_SD1{i,j},fg_SD2{i,j},fg_SD3{i,j},fg_SD4{i,j}]...
        = SO_DivideFibersAcordingToFiberLength(fgF{j},dt,0,'AP',100);
    end
end
return

%%
cd /biac4/wandell/biac3/wandell7/shumpei/matlab/git/LHON/3RP

load ROR_cont_MRT_TractProfile

%%
% JMD = 1,3,5,6;
CRD = 2,4,7,8,9;
LHON = 10:15;
Ctl = 16:23;

%%

% TractProfile{}

%% compare conTrack and mrTrix optic radiation
figure; hold on;
X = 1:100;
c = jet(2);
Yc = TractProfile{1,1}{1,1}.vals.fa;
Ym = TractProfile{1,2}{1,1}.vals.fa;
plot(X,Yc,'color',c(1,:),'LineWidth',2);
plot(X,Ym,'color',c(2,:),'LineWidth',2);
legend('Contrack','MrTrix')
title('FA in ROR')
% axis('FA')
hold  off;


%% contrack
for i = [1:18,20,21,23]
figure; hold on;
X = 1:100;
c = jet(8);

    for j = 1: length(TractProfile{1,1})
        Yc = TractProfile{i,1}{1,j}.vals.fa;
        if j==1;
            % Ym = TractProfile{1,2}{1,1}.vals.fa;
            plot(X,Yc,'color',[0.5 0.5 0.5],'LineWidth',4);
        else
            plot(X,Yc,'color',c(j-1,:),'LineWidth',2);
        end
    end

% plot(X,Ym,'color',c(2,:),'LineWidth',2);
% legend('Contrack','MrTrix')
title(sprintf('%s %s',subDir{i},'ROR FA Variation with Contrack'));
% axis('FA')
hold  off;

%% save figure
cd /biac4/wandell/biac3/wandell7/shumpei/matlab/git/LHON/3RP/CompareMRTandContrack

print(gcf,'-dpng',sprintf('%s_%s',subDir{i},'ROR_FA_Variation_Contrack.png'))
close all;
end

%% Mrtrix
figure; hold on;
X = 1:100;
c = jet(8);
for i = 1: length(TractProfile{1,1})
%     Yc = TractProfile{1,2}{1,i}.vals.fa;
    if i==1;
         Yc = TractProfile{1,2}{1,i}.vals.fa;
% Ym = TractProfile{1,2}{1,1}.vals.fa;
plot(X,Yc,'color',[0.5 0.5 0.5],'LineWidth',4);
    elseif i==2;
    else
         Yc = TractProfile{1,2}{1,i}.vals.fa;
plot(X,Yc,'color',c(i-1,:),'LineWidth',2);
    end
end
% plot(X,Ym,'color',c(2,:),'LineWidth',2);
title('Variation according to fiber length FA of ROR with Mrtrix')
colorbar('peer',axes1);
% legend('Contrack','MrTrix')
title('FA in ROR')
% axis('FA')
hold  off;

%% render fibers
% AFQ_RenderFibers(fg_SDm3{2},'dt',dt,'radius', [.1 3],'numfibers',10,'newfig',1,'camera','axial','tubes', 0);
% 
% AFQ_RenderFibers(fg_SDm2{2},'dt',dt,'radius', [.1 3],'numfibers',100,'newfig',1,'camera','axial','tubes', 0);
% AFQ_RenderFibers(fg_SDm1{2},'dt',dt,'radius', [.1 3],'numfibers',100,'newfig',1,'camera','axial','tubes', 0);
% % AFQ_RenderFibers(fg_SDm4{2},'dt',dt,'radius', [.1 3],'numfibers',100,'newfig',0,'camera','axial','tubes', 0);
% AFQ_RenderFibers(fg_SD1{2},'dt',dt,'radius', [.1 3],'numfibers',100,'newfig',1,'camera','axial','tubes', 0);
% AFQ_RenderFibers(fg_SD2{2},'dt',dt,'radius', [.1 3],'numfibers',100,'newfig',1,'camera','axial','tubes', 0);
% AFQ_RenderFibers(fg_SD3{2},'dt',dt,'radius', [.1 3],'numfibers',100,'newfig',1,'camera','axial','tubes', 0);
% AFQ_RenderFibers(fg_SD4{2},'dt',dt,'radius', [.1 3],'numfibers',100,'newfig',1,'camera','axial','tubes', 0);
% 
% 



 %% render fibers
%    AFQ_RenderFibers(fgF{1},'dt',dt,'numfibers',10,'camera','axial','tubes', 0,'radius', [.2 2],'newfig',1)
   t1 = niftiRead(dt.files.t1);
   fgF={fg_SDm3{2},fg_SDm2{2},fg_SDm1{2},fg_SD1{2},fg_SD2{2},fg_SD3{2},fg_SD4{2}};
   
   for jj = 1:length(fgF)
       AFQ_RenderFibers(fgF{jj},'dt',dt,'numfibers',10,'camera','axial','tubes', 0,'radius', [.2 2],'newfig',1)
       %    
       
%        a =  -64.0872
%        b =   69.4895
       %        % if you want to show T1 image togather
               AFQ_AddImageTo3dPlot(t1, [0, 0, -5]);
               AFQ_AddImageTo3dPlot(t1, [5, 0, 0]);
       %        view(0,89) % axial view
       %        %     view(-38,30)
       %        camlight('headlight')
       %        axis image
%        view(70,31) % view form back right
view(84,67.5)
       axis off
       axis([10 50 -110 0 -10 40])
       %% if you want to save the image
       cd /biac4/wandell/biac3/wandell7/shumpei/matlab/git/LHON/3RP/CompareMRTandContrack

       %        print(gcf,'-dpng',sprintf('%s_FA.png',fgF{jj}.name))
       %if you like the image with T1w
              print(gcf,'-dpng',sprintf('%s_%s_FA_onT1w_3.png',subDir{i},fgF{jj}.name))
   end
   %% figure
   figure; hold on;
       AFQ_RenderFibers(fgF{1},'numfibers',1,'camera','axial','tubes', 1,'radius', [.5 5],'newfig',1,'color',c(jj,:))

   for jj = 1:length(fgF)
       AFQ_RenderFibers(fgF{jj},'numfibers',1,'camera','axial','tubes', 1,'radius', [.5 5],'newfig',0,'color',c(jj,:))
   end
   axis image
   axis off
%    color = rand(size(TractProfile{1}.coords.acpc,1),3);
%      figure
%   [X, Y, Z, C] =  AFQ_TubeFromCoords(TractProfile{1}.coords.acpc,2,c(jj,:),20);
%     surf(X, Y, Z, C);
  
 
%% figure
   figure; hold on;
       AFQ_RenderFibers(fg_SDm3{2},'numfibers',1,'camera','axial','tubes', 1,'radius', [.5 5],'newfig',1,'color',c(1,:))

   for jj = 1:length(fgF)
       AFQ_RenderFibers(fgF{jj},'numfibers',1,'camera','axial','tubes', 1,'radius', [.5 5],'newfig',0,'color',c(jj,:))
   end
   axis image
   axis off
%    color = rand(size(TractProfile{1}.coords.acpc,1),3);
%      figure
%   [X, Y, Z, C] =  AFQ_TubeFromCoords(TractProfile{1}.coords.acpc,2,c(jj,:),20);
%     surf(X, Y, Z, C);

%% scatter plot
figure; hold on;
c= lines(100);
% JMD1
scatter(TractProfile{1,1}{1,1}.vals.ad(1,50:90),TractProfile{1,1}{1,1}.vals.rd(1,50:90),50,c(3,:));
scatter(TractProfile{10,1}{1,1}.vals.ad(1,50:90),TractProfile{1,1}{1,1}.vals.rd(1,50:90),50,c(1,:));
scatter(TractProfile{23,1}{1,1}.vals.ad(1,50:90),TractProfile{1,1}{1,1}.vals.rd(1,50:90),50,[0.5,0.5,0.5]);

xlabel('AD','fontName','Times','fontSize',14);
ylabel('RD','fontName','Times','fontSize',14);
title('ROR cont','fontName','Times','fontSize',14)

%% scatter plot
figure; hold on;
c= lines(100);
% JMD1
scatter(TractProfile{1,2}{1,1}.vals.ad,TractProfile{1,2}{1,1}.vals.rd,50,c(3,:));
scatter(TractProfile{10,2}{1,1}.vals.ad,TractProfile{1,2}{1,1}.vals.rd,50,c(1,:));
scatter(TractProfile{23,2}{1,1}.vals.ad,TractProfile{1,2}{1,1}.vals.rd,50,[0.5,0.5,0.5]);

xlabel('AD','fontName','Times','fontSize',14);
ylabel('RD','fontName','Times','fontSize',14);
title('ROR MRT','fontName','Times','fontSize',14)


