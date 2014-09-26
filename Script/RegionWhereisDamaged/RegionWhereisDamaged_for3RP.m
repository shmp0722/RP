function RegionWhereisDamaged_for3RP(subject,diffusivity,test,crange,Save)
% To make pictures of the region where we find diffusivities (AD,RD) difference
% diffusivity = 'fa', 'md', 'ad', 'rd'
% test    = 'minus', 'effect_size'
% radius  = radius of tube
% pathway = 'OT', 'OR' or 'OCF'
% crange = [- 0.3 0.3];
% Save    = 1 or 0;



% Set the path to data directory
%% set directory
AFQdata = '/biac4/wandell/biac2/wandell/data/DWI-Tamagawa-Japan';

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


%% Load afq structure
cd /biac4/wandell/biac3/wandell7/shumpei/matlab/git/LHON/3RP

% cd /Users/shumpei/Documents/MATLAB/git/LHON/6LHON_9JMD_8Ctl
load 3RP_1210.mat
%% grouping subjects
JMD = 1:4;
CRD = 5:9;
LHON = 10:15;
Ctl = 16:23;
RP = 24:26;

%% Render 
for ii = subject;  %1: size(afq.sub_dirs,2) % Subjects loop
    for pathway =1:2%3
        switch pathway % pathway ='OR'
            case 1 % pathway = 'OR'
                jj1 = 22;
                jj2 = 21;                
                
            case 2 % pathway = 'OT'
                jj1 =25; %L
                jj2 = 24; %R
                               
            case 3 % pathway = 'OCF_B'
                jj1 = 26;
                jj2 = 27;
        end
        
        % get superfiber coords
        coords1 = afq.TractProfiles(ii,jj1).coords.acpc;
        coords2 = afq.TractProfiles(ii,jj2).coords.acpc;
        
        % make sure whether the fiber direction is anterior to posteror or
        % not
        
        if coords1(2,1)<coords1(2,end); coords1 = fliplr(coords1{1});end
        if coords2(2,1)<coords2(2,end); coords2 = fliplr(coords2{1});end
                
        %% switch diffusivity
        switch diffusivity % diffusivity = 'rd'
            case 'fa'
                Normal_dist1 = afq.vals.fa{1,jj1}(Ctl,:);
                Normal_average1 = mean(Normal_dist1);
                val1 = afq.vals.fa{1,jj1}(ii,:);
                
                Normal_dist2 = afq.vals.fa{1,jj2}(Ctl,:);
                Normal_average2 = mean(Normal_dist2);
                val2 = afq.vals.fa{1,jj2}(ii,:);   
                
            case 'md'
                Normal_dist1 = afq.vals.md{1,jj1}(Ctl,:);
                Normal_average1 = mean(Normal_dist1);
                val1 = afq.vals.md{1,jj1}(ii,:);
                
                Normal_dist2 = afq.vals.md{1,jj2}(Ctl,:);
                Normal_average2 = mean(Normal_dist2);
                val2 = afq.vals.md{1,jj2}(ii,:);
            case 'ad'
                Normal_dist1 = afq.vals.ad{1,jj1}(Ctl,:);
                Normal_average1 = mean(Normal_dist1);
                val1 = afq.vals.ad{1,jj1}(ii,:);
                
                Normal_dist2 = afq.vals.ad{1,jj2}(Ctl,:);
                Normal_average2 = mean(Normal_dist2);
                val2 = afq.vals.ad{1,jj2}(ii,:);
                
                
            case 'rd'
                Normal_dist1 = afq.vals.rd{1,jj1}(Ctl,:);
                Normal_average1 = mean(Normal_dist1);
                val1 = afq.vals.rd{1,jj1}(ii,:);
                
                Normal_dist2 = afq.vals.rd{1,jj2}(Ctl,:);
                Normal_average2 = mean(Normal_dist2);
                val2 = afq.vals.rd{1,jj2}(ii,:);
                
            case 'portion'
                
        end
        
        
        
        %%
        switch test % test = 'minus'
            case 'indivi'
                color1 = val1;
                color2 = val2;
%                 if notDefined(crange);
%                 crange = minmax(color1);end;
                
            case 'minus'
                color1 = val1 - Normal_average1;
                color2 = val2 - Normal_average2;
%                 if notDefined(crange);
%                 crange = [-0.3 0.3];end;
            case 'effect_size'
                color1 = (val1 - Normal_average1)./std(Normal_dist1);
                color2 = (val2 - Normal_average2)./std(Normal_dist2);
%                 if notDefined(crange);
%                 crange = [-5 5];end;
                
            case 'Tstat'
                [h1,p1,~,Tstats1] = ttest2(val1 ,Normal_average1);
                [h2(jj2,:),p2(jj2,:),~,Tstats2(jj2)] = ttest2(val2 ,Normal_average2);
        end
        
        %%  Make Tract Profiles of T statistics
        
        % make TP structure
        TractProfile = AFQ_CreateTractProfile;
        
        % Add the values and T statistics from the group comparison to the tract
        % profile. This same code could be used to add correlation coeficients or
        % other statistics
        
        TractProfile(1) = AFQ_TractProfileSet(TractProfile(1),'vals',test, color1);
        %     TractProfile(1) = AFQ_TractProfileSet(TractProfile1,'vals','Tstat',Tstats1(jj).tstat);
        
        %     TractProfile1 = AFQ_TractProfileSet(TractProfile1,'vals','pval',p2(jj1,:));
        TractProfile(2) = AFQ_TractProfileSet(TractProfile(1),'vals', test ,color2);
        
        %
        
        %%
        % Render the fibers with test value
        switch pathway % pathway ='OT'
            case 1
                radius = 3;
                subdivs = 20;
                cmap    = 'jet';
                figure; hold('on')
                
            case 2
                radius = 1.2;
                subdivs = 20;
                cmap    = 'jet';
                
            case 3
                radius = 3;
                subdivs = 20;
                cmap    = 'jet';
        end
        
        AFQ_RenderTractProfile(coords1, radius, color1, subdivs, cmap, crange, 0);
        
%         axis off
%         axis image
        AFQ_RenderTractProfile(coords2, radius, color2, subdivs, cmap, crange, 0);
        axis off
        axis image
    end
    % Load dt6
    dt =  dtiLoadDt6(afq.files.dt6{ii});
    t1 = niftiRead(dt.files.t1);
    
    % add T1w image        crange = [-0.3 0.3];
    
    %             switch pathway
    %                 case 'OT'
    %                     AFQ_AddImageTo3dPlot(t1, [0, 0, -20]);
    %                 case 'OR'
    AFQ_AddImageTo3dPlot(t1, [0, 0, -30]);
    %                 case 'OCF_B'
    %                     AFQ_AddImageTo3dPlot(t1, [0, 0, -30]);
    %             end
    % adjust view and give title
    view(0,89)
    title(sprintf('%s %s %s E-C',subDir{ii},test,diffusivity))
    %            view(-108,90)
    
    axis image
    camlight('headlight');

    hold('off')


% %% save the figure in
% %        cd /biac4/wandell/biac3/wandell7/shumpei/matlab/git/LHON/RegionWhereisDamaged(.eps)
% %        print(gcf, '-depsc',sprintf('%s_%s_%s_%s_E_C.eps',subDir{ii},pathway,test,diffusivity))
% if Save == true;
% cd /biac4/wandell/biac3/wandell7/shumpei/matlab/git/LHON/3RP/RegionWhrereisDamaged(fig)
% print(gcf, '-dpng',sprintf('%s_%s_%s_E_C.png',subs{ii},test,diffusivity))
% end
% %        close all;
% cd /biac4/wandell/biac3/wandell7/shumpei/matlab/git/LHON/3RP

end
return



