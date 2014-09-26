function RegionWhereisDamaged(subject,diffusivity,pathway,test)
% To make pictures of the region where we find diffusivities (AD,RD) difference
% diffusivity = 'fa', 'md', 'ad', 'rd'
% test = 'minus', 'effect size'
% radius = radius of tube
% pathway = 'OT', 'OR' or 'OCF'



% Set the path to data directory
homeDir = '/biac4/wandell/biac2/wandell/data/DWI-Tamagawa-Japan';
subDir = {...
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
%     'RP1-TT-2013-11-01'
%     'RP2-KI-2013-11-01'};
%%
% %% generate super fibers (core fibers)
%
% for i = 1:length(subDir);
%
%     SubDir = fullfile(homeDir,subDir{i});
%     fgDir  = fullfile(SubDir,'/dwi_2nd/fibers');
%     savefgDir  = fullfile(fgDir,'Superfiber1127');
%
%     %     roiDir = fullfile(SubDir,'/dwi_2nd/ROIs');
%     %     dtDir  = fullfile(homeDir,subDir{i},'dwi_2nd');
%
%     % select fg for Superfiber generation
%     fgname = {'OCFV1V2Not3mm_MD4.pdb','ROT100_clean.pdb','LOT100_clean.pdb',...
%         'LOCF_D4L4.pdb','ROCF_D4L4.pdb','RORV13mmClipBigNotROI5_clean.pdb',...
%         'LORV13mmClipBigNotROI5_clean.pdb'};
%     % fgname loop
%     for j = 1:length(fgname)
%         cd(fgDir)
%         fg  = fgRead(fgname{j});
%
%         % Superfiber generation using mba
%         numberOfNodes = 100; M = 'median';
%
%         [SuperFiber, weights] = mbaComputeFibersCoordsDistribution(fg, numberOfNodes, M);
%
%         if ~exist(savefgDir);
%             mkdir(savefgDir);
%         end;
%         cd(savefgDir)
%         savefgname =[SuperFiber.name '_SF'];
%         fgWrite(SuperFiber,savefgname,'mat');
%
%     end
% end

%% Load afq structure
cd /biac4/wandell/biac3/wandell7/shumpei/matlab/git/LHON/6LHON_9JMD_8Ctl
cd /Users/shumpei/Documents/MATLAB/git/LHON/6LHON_9JMD_8Ctl
load AFQ_6L_9J_8C_1017.mat

%%
for ii = subject;  %1: size(afq.sub_dirs,2) % Subjects loop

switch pathway
    case 'OR'
        jj1 = 22;
        jj2 = 21;
        
        %             fgL = fgRead(afq.files.fibers.LORV13mmClipBigNotROI5_clean{ii});
        %             fgR = fgRead(afq.files.fibers.RORV13mmClipBigNotROI5_clean{ii});
        coords1 = afq.TractProfiles(ii,jj1).coords.acpc;
        coords2 = afq.TractProfiles(ii,jj2).coords.acpc;
        
    case 'OT'
        jj1 =22; %L
        jj2 = 21; %R
        coords1 = afq_2_OT.TractProfiles(ii,jj1).coords.acpc;
        coords2 = afq_2_OT.TractProfiles(ii,jj2).coords.acpc;
        
        %             fgL = fgRead(afq.files.fibers.LOT100_clean{ii});
        %             fgR = fgRead(afq.files.fibers.ROT100_clean{ii});
        %
        
    case 'OCF_B'
        jj1 = 27;jj2 = 28;
        %             fgL = fgRead(afq.files.fibers.LOCF_D4L4{ii});
        %             fgR = fgRead(afq.files.fibers.ROCF_D4L4{ii});
        coords1 = afq.TractProfiles(ii,jj1).coords.acpc;
        coords2 = afq.TractProfiles(ii,jj2).coords.acpc;
        %
end

 %1: size(afq.sub_dirs,2) % Subjects loop
    
  
    
    % make sure whether the fiber direction is anterior to posteror or
    % not
    if coords1(2,1)<coords1(2,end);
        coords1 = fliplr(coords1{1});end
    if coords2(2,1)<coords2(2,end);
        coords2 = fliplr(coords2{1});end
    
    switch pathway % pathway ='OR'
        case 'OR'
            jj1 = 22;
            jj2 = 21;
            
            fgL = fgRead(afq.files.fibers.LORV13mmClipBigNotROI5_cleanclean{ii});
            fgR = fgRead(afq.files.fibers.RORV13mmClipBigNotROI5_cleanclean{ii});
            
        case 'OT'
            jj1 =30; %L
            jj2 = 29; %R
            
            
            fgL = fgRead(afq.files.fibers.LOT100_clean{ii});
            fgR = fgRead(afq.files.fibers.ROT100_clean{ii});
            
            
        case 'OCF_B'
            jj1 = 27;jj2 = 28;
            fgL = fgRead(afq.files.fibers.LOCF_D4L4{ii});
            fgR = fgRead(afq.files.fibers.ROCF_D4L4{ii});
            
    end
    
            % get superfiber coords
            coords1 = afq.TractProfiles(ii,jj1).coords.acpc;
            coords2 = afq.TractProfiles(ii,jj2).coords.acpc;
    
            % make sure whether the fiber direction is anterior to posteror or
            % not
            
            if coords1(2,1)<coords1(2,end); coords1 = fliplr(coords1{1});end
            if coords2(2,1)<coords2(2,end); coords2 = fliplr(coords2{1});end
            
            % 
            for kk =1:length(fgL.fibers)
                if fgL.fibers{kk}(2,1)<fgL.fibers{kk}(2,end);
                    fgL.fibers(kk) = fliplr(fgL.fibers(kk));end
            end
            for kk =1:length(fgR.fibers)
                if fgR.fibers{kk}(2,1)<fgR.fibers{kk}(2,end);
                    fgR.fibers{kk} = fliplr(fgR.fibers{kk});end
            end

    %% switch diffusivity
    switch diffusivity % diffusivity = 'rd'
        case 'fa'
            Normal_dist1 = afq.vals.fa{1,jj1}(16:23,:);
            Normal_average1 = mean(Normal_dist1);
            val1 = afq.vals.fa{1,jj1}(ii,:);
            
            Normal_dist2 = afq.vals.fa{1,jj2}(16:23,:);
            Normal_average2 = mean(Normal_dist2);
            val2 = afq.vals.fa{1,jj2}(ii,:);
            

                      
        case 'md'
            Normal_dist1 = afq.vals.md{1,jj1}(16:23,:);
            Normal_average1 = mean(Normal_dist1);
            val1 = afq.vals.md{1,jj1}(ii,:);
            
            Normal_dist2 = afq.vals.md{1,jj2}(16:23,:);
            Normal_average2 = mean(Normal_dist2);
            val2 = afq.vals.fa{1,jj2}(ii,:);
        case 'ad'
            Normal_dist1 = afq.vals.ad{1,jj1}(16:23,:);
            Normal_average1 = mean(Normal_dist1);
            val1 = afq.vals.ad{1,jj1}(ii,:);
            
            Normal_dist2 = afq.vals.ad{1,jj2}(16:23,:);
            Normal_average2 = mean(Normal_dist2);
            val2 = afq.vals.fa{1,jj2}(ii,:);
            

        case 'rd'
            Normal_dist1 = afq.vals.ad{1,jj1}(16:23,:);
            Normal_average1 = mean(Normal_dist1);
            val1 = afq.vals.rd{1,jj1}(ii,:);
            
            Normal_dist2 = afq.vals.rd{1,jj2}(16:23,:);
            Normal_average2 = mean(Normal_dist2);
            val2 = afq.vals.fa{1,jj2}(ii,:);
    end
    
    
    switch test
        case 'minus'
            color1 = Normal_average1 - val1;
            color2 = Normal_average2 - val2;
        case 'effect size'
            color1 = (Normal_average1 - val1)./std(Normal_dist1);
            color2 = (Normal_average2 - val2)./std(Normal_dist2);
    end
    
    
    
    %     rgbL = vals2colormap(color1);
    %     rgbR = vals2colormap(color2);
    
%%
switch test % test = 'size_effct'
    case 'minus'
        color1 = Normal_average1 - val1;
        color2 = Normal_average2 - val2;
        crange = [-0.3 0.3];
    case 'effect_size'
        color1 = (Normal_average1 - val1)./std(Normal_dist1);
        color2 = (Normal_average2 - val2)./std(Normal_dist2);
        crange = [-10 10];

    case 'Tstat'
        [h1(jj1,:),p1(jj1,:),~,Tstats1(jj1)] = ttest2(val1 ,Normal_average1);
        [h2(jj2,:),p2(jj2,:),~,Tstats2(jj2)] = ttest2(val2 ,Normal_average2);
end
    %     % Now let's render the tract profile meaning the values along the fiber
    %     % core. Let's dop it for a new tract.
    %     AFQ_RenderFibers(fgL, 'numfibers',10 ,'dt', dt, 'radius', [.4 3],'camera','axial','val','fa','crange',[0.2 0.7]);
    %     AFQ_RenderFibers(fgR,'newfig', [0], 'numfibers',10 ,'dt', dt, 'radius', [.4 3],'camera','axial','val','fa','crange',[0.2 0.7]);
    %
    %     AFQ_RenderFibers(coords1, 'numfibers', 10 ,'color', rgbL);
    %     AFQ_RenderFibers(fgL, 'numfibers',10 ,'dt', dt, 'radius', [.5 3]);
    
    
    %%
    % Render
    radius = 1;
    subdivs = 20;
    cmap    = 'jet';
    crange  = [-2 3];
    newfig = 1;
    
    AFQ_RenderTractProfile(coords1, radius, color1, subdivs, cmap, crange, 1);
    AFQ_RenderTractProfile(coords2, radius, color2, subdivs, cmap, crange, 1);
    
    
    %             % Load dt6 and T1 file
    %             dt = dtiLoadDt6(afq.files.dt6{ii});
    %             t1 = niftiRead(dt.files.t1);
    %             AFQ_AddImageTo3dPlot(t1, [0, 0, -30]);
    
    
    %         % Now lets render a fiber group heatmapped for fa values.
    %         % First get FA for each point of each fiber
    %
    %         % Then convert each fa value to a color
    %         rgb = vals2colormap(color1);
    %         % Now render the fibers colored based on fa
    %         AFQ_RenderFibers(fg(13) ,'color', rgb);
    %         AFQ_AddImageTo3dPlot(t1, [-10 0 0]);
    
%%  Make Tract Profiles of T statistics

% Load the cleaned segmented fibers for the first control subject

% Compute Tract Profiles with 100 nodes
% [fa, md, rd, ad, cl, TractProfile1] = AFQ_ComputeTractProperties(fgL,dt,100);
% [fa, md, rd, ad, cl, TractProfile2] = AFQ_ComputeTractProperties(fgR,dt,100);
TractProfile = AFQ_CreateTractProfile;

% Add the pvalues and T statistics from the group comparison to the tract
% profile. This same code could be used to add correlation coeficients or
% other statistics

    TractProfile(1) = AFQ_TractProfileSet(TractProfile(1),'vals',test, color1);
%     TractProfile(1) = AFQ_TractProfileSet(TractProfile1,'vals','Tstat',Tstats1(jj).tstat);

%     TractProfile1 = AFQ_TractProfileSet(TractProfile1,'vals','pval',p2(jj1,:));
    TractProfile(2) = AFQ_TractProfileSet(TractProfile(1),'vals', test ,color2);

%     
%% Render The tract Profiles of T statistics

% The hot colormap is a good one because it will allow us to make regions
% of the profile where p>0.05 black.
% cmap = 'hot';
% Set the color range to black out non significant regions of the tract. We
% will render the T-stat profile such that T statistics greater than 5 will
% be white and T statistics less than 1 will be black. Obviously a T value
% of 1 is not considered significant however in this example we only have 3
% subjects in each group hence we use a low value just to demonstrate the
% proceedure.
% crange = [-2 4];
% Set the number of fibers to render. More fibers takes longer
numfibers = 1;
% Render the left corticospinal tract (fibers colored light blue) with a
% Tract Profile of T statistics. Each fiber will have a 1mm radius and the
% tract profile will have a 6mm radius.

% AFQ_RenderFibers(fgL,'color',[.8 .8 1],'tractprofile',TractProfile(1),...
%     'val',test,'numfibers',numfibers,'cmap',cmap,'crange',crange,...
%     'radius',[0.5 0.5],'newfig', [1]);
% % 
% AFQ_RenderFibers(fgR,'color',[.8 .8 1],'tractprofile',TractProfile(2),...
%     'val',test,'numfibers',numfibers,'cmap',cmap,'crange',crange,...
%     'radius',[0.2 0.5], 'newfig', [0]);

AFQ_RenderFibers_SO(fgL, 'numfibers',numfibers,'camera','axial','newfig', [1]);
AFQ_RenderFibers_SO(fgR, 'numfibers',numfibers,'camera','axial','newfig', [0]);
% 
% Add the defining ROIs to the rendering.
% [roi1, roi2] = AFQ_LoadROIs(jj1,afq.sub_dirs{ii},afq);
% % The rois will be rendered in dark blue
% AFQ_RenderRoi(roi1,[0 0 .7]);
% AFQ_RenderRoi(roi2,[0 0 .7]);
% % Add the slice x=-15 from the subject's b=0 image
% b0 = readFileNifti(dt.files.b0);
% AFQ_AddImageTo3dPlot(b0,[-15,0,0]);
% 
%  dt =  dtiLoadDt6(afq.files.dt6{ii});
%             t1 = niftiRead(dt.files.t1);
%             AFQ_AddImageTo3dPlot(t1, [0, 0, -30]);
            
  %%  
            % Render the fibers with test value
            switch pathway % pathway ='OT'
                case 'OT'
                    radius = 1.2;
                    subdivs = 20;
                    cmap    = 'jet';
                    newfig = 1;
                case 'OR'
                    radius = 3;
                    subdivs = 20;
                    cmap    = 'jet';
                    newfig = 1;
                    
                case 'OCF_B'
                    radius = 3;
                    subdivs = 20;
                    cmap    = 'jet';
                    newfig = 1;
            end
    
            AFQ_RenderTractProfile(coords1, radius, color1, subdivs, cmap, crange, 0);
            AFQ_RenderTractProfile(coords2, radius, color2, subdivs, cmap, crange, 0);
    
              % Load dt6
            dt =  dtiLoadDt6(afq.files.dt6{ii});
            t1 = niftiRead(dt.files.t1);
            AFQ_AddImageTo3dPlot(t1, [0, 0, -30]);
           % adjust view and give title
            view(0,90)
                camlight('headlight');

           title(sprintf('%s %s %s %s',subDir{ii},pathway,test,diffusivity))
%            view(-108,90)


       %% save the figure in 
       cd /biac4/wandell/biac3/wandell7/shumpei/matlab/git/LHON/RegionWhereisDamaged(.eps)
       print(gcf, '-depsc',sprintf('%s_%s_%s_%s.eps',subDir{ii},pathway,test,diffusivity))
            
       close all;
          
    
end
return



