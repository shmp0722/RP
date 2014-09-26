function RegionWhereisDamaged_compareTstats_Tama2(subject,diffusivity,disease,save)
% To make pictures of the region where we find diffusivities (AD,RD) difference
% diffusivity = 'fa', 'md', 'ad', 'rd'
% test = 'minus', 'effect size'
% radius = radius of tube
% pathway = 'OT', 'OR' or 'OCF'
% disease = 'JMD','LHON', 'individual'
% save = 'png','eps', '0'
%   'JMD'  compare between JMD and control
%   'LHON' cpmpare between LHON adn control


% Set the path to data directory
[homeDir,subDir,JMD,CRD,Ctl,RP] = Tama_subj2;

%% Load afq structure
cd /biac4/wandell/biac3/wandell7/shumpei/matlab/git/LHON/6LHON_9JMD_8Ctl
% cd /Users/shumpei/Documents/MATLAB/git/LHON/6LHON_9JMD_8Ctl
load AFQ_6L_9J_8C_1017.mat

%% Left and Right hemi sphere stats

switch diffusivity % diffusivity = 'fa';
    case 'fa'
        ROR = afq.vals.fa{21}';
        LOR = afq.vals.fa{22}';
        ROT = afq_2_OT.vals.fa{21}';
        LOT = afq_2_OT.vals.fa{22}';
        OCF = afq.vals.fa{26}';
        OCF_L= afq.vals.fa{27}';
        OCF_R= afq.vals.fa{28}';
        
        
    case 'md'
        ROR = afq.vals.md{21}';
        LOR = afq.vals.md{22}';
        ROT = afq_2_OT.vals.md{21}';
        LOT = afq_2_OT.vals.md{22}';
        OCF = afq.vals.md{26}';
        OCF_L= afq.vals.md{27}';
        OCF_R= afq.vals.md{28}';
        
        
    case 'ad'
        ROR = afq.vals.ad{21}';
        LOR = afq.vals.ad{22}';
        ROT = afq_2_OT.vals.ad{21}';
        LOT = afq_2_OT.vals.ad{22}';
        OCF = afq.vals.ad{26}';
        OCF_L= afq.vals.ad{27}';
        OCF_R= afq.vals.ad{28}';
        
        
    case 'rd'
        
        ROR = afq.vals.rd{21}';
        LOR = afq.vals.rd{22}';
        ROT = afq_2_OT.vals.rd{21}';
        LOT = afq_2_OT.vals.rd{22}';
        OCF = afq.vals.rd{26}';
        OCF_L= afq.vals.rd{27}';
        OCF_R= afq.vals.rd{28}';
        
end;


% % volume
% OT_V    = ((afq_2_OT.vals.volume{21}+afq_2_OT.vals.volume{22})/2)';
% OR_V    = ((afq.vals.volume{21}+afq.vals.volume{22})/2)';
% OCF_V   = afq.vals.volume{26}';
% OCF_B_V = ((afq.vals.volume{27}+afq.vals.volume{28})/2)';


%%
for ii = subject;  %1: size(afq.sub_dirs,2) % Subjects loop
    for pathway =1:3
        switch pathway % pathway ='OR'
            case 1 % pathway = 'OR'
                jj1 = 22;
                jj2 = 21;
                
                Normal_dist_LOR = LOR(:,16:23)';
                JMD_dist_LOR = LOR(:,1:4)';
                CRD_dist_LOR  = LOR(:,5:9)';
                LHON_dist_LOR = LOR(:,10:15)';
                
                Normal_dist_ROR = ROR(:,16:23)';
                JMD_dist_ROR = ROR(:,1:4)';
                CRD_dist_ROR  = ROR(:,5:9)';
                LHON_dist_ROR = ROR(:,10:15)';
                
                [h1(ii,:),p1(ii,:),~,Tstats1(ii)] = ttest2(Normal_dist_LOR,JMD_dist_LOR);
                [h2(ii,:),p2(ii,:),~,Tstats2(ii)] = ttest2(Normal_dist_ROR,JMD_dist_ROR);
                [h3(ii,:),p3(ii,:),~,Tstats3(ii)] = ttest2(Normal_dist_LOR,LHON_dist_LOR);
                [h4(ii,:),p4(ii,:),~,Tstats4(ii)] = ttest2(Normal_dist_ROR,LHON_dist_ROR);
                [h5(ii,:),p5(ii,:),~,Tstats5(ii)] = ttest2(Normal_dist_LOR,CRD_dist_LOR);
                [h6(ii,:),p6(ii,:),~,Tstats6(ii)] = ttest2(Normal_dist_ROR,CRD_dist_ROR);
                [h7(ii,:),p7(ii,:),~,Tstats7(ii)] = ttest2(Normal_dist_LOR,LOR(:,ii)');
                [h8(ii,:),p8(ii,:),~,Tstats8(ii)] = ttest2(Normal_dist_ROR,ROR(:,ii)');
                
                % get superfiber coords
                coords1 = afq.TractProfiles(ii,jj1).coords.acpc;
                coords2 = afq.TractProfiles(ii,jj2).coords.acpc;
                
                % correct fiber direction from anterior to posteror
                
                if coords1(2,1)<coords1(2,end); coords1 = fliplr(coords1{1});end
                if coords2(2,1)<coords2(2,end); coords2 = fliplr(coords2{1});end
                
            case 2 % pathway = 'OT'
                jj1 =22; %L
                jj2 = 21; %R
                
                Normal_dist_LOT = LOT(:,16:23)';
                JMD_dist_LOT = LOT(:,1:4)';
                CRD_dist_LOT  = LOT(:,5:9)';
                LHON_dist_LOT = LOT(:,10:15)';
                
                Normal_dist_ROT = ROT(:,16:23)';
                JMD_dist_ROT = ROT(:,1:4)';
                CRD_dist_ROT  = ROT(:,5:9)';
                LHON_dist_ROT = ROT(:,10:15)';
                
                [h1(ii,:),p1(ii,:),~,Tstats1(ii)] = ttest2(Normal_dist_LOT,JMD_dist_LOT);
                [h2(ii,:),p2(ii,:),~,Tstats2(ii)] = ttest2(Normal_dist_ROT,JMD_dist_ROT);
                [h3(ii,:),p3(ii,:),~,Tstats3(ii)] = ttest2(Normal_dist_LOT,LHON_dist_LOT);
                [h4(ii,:),p4(ii,:),~,Tstats4(ii)] = ttest2(Normal_dist_ROT,LHON_dist_ROT);
                [h5(ii,:),p5(ii,:),~,Tstats5(ii)] = ttest2(Normal_dist_LOT,CRD_dist_LOT);
                [h6(ii,:),p6(ii,:),~,Tstats6(ii)] = ttest2(Normal_dist_ROT,CRD_dist_ROT);
                [h7(ii,:),p7(ii,:),~,Tstats7(ii)] = ttest2(Normal_dist_LOT,LOT(:,ii)');
                [h8(ii,:),p8(ii,:),~,Tstats8(ii)] = ttest2(Normal_dist_ROT,ROT(:,ii)');
                
                % get superfiber coords
                coords1 = afq_2_OT.TractProfiles(ii,jj1).coords.acpc;
                coords2 = afq_2_OT.TractProfiles(ii,jj2).coords.acpc;
                
                % correct fiber direction from anterior to posteror
                
                if coords1(2,1)<coords1(2,end); coords1 = fliplr(coords1{1});end
                if coords2(2,1)<coords2(2,end); coords2 = fliplr(coords2{1});end
                
            case 3 % pathway = 'OCF_B'
                jj1 = 27;jj2 = 28;
                
                Normal_dist_OCF_L = OCF_L(:,16:23)';
                JMD_dist_OCF_L = OCF_L(:,1:4)';
                CRD_dist_OCF_L  = OCF_L(:,5:9)';
                LHON_dist_OCF_L = OCF_L(:,10:15)';
                
                Normal_dist_OCF_R = OCF_R(:,16:23)';
                JMD_dist_OCF_R = OCF_R(:,1:4)';
                CRD_dist_OCF_R  = OCF_R(:,5:9)';
                LHON_dist_OCF_R = OCF_R(:,10:15)';
                
                [h1(ii,:),p1(ii,:),~,Tstats1(ii)] = ttest2(Normal_dist_OCF_L,JMD_dist_OCF_L);
                [h2(ii,:),p2(ii,:),~,Tstats2(ii)] = ttest2(Normal_dist_OCF_R,JMD_dist_OCF_R);
                [h3(ii,:),p3(ii,:),~,Tstats3(ii)] = ttest2(Normal_dist_OCF_L,LHON_dist_OCF_L);
                [h4(ii,:),p4(ii,:),~,Tstats4(ii)] = ttest2(Normal_dist_OCF_R,LHON_dist_OCF_R);
                [h5(ii,:),p5(ii,:),~,Tstats5(ii)] = ttest2(Normal_dist_OCF_L,CRD_dist_OCF_L);
                [h6(ii,:),p6(ii,:),~,Tstats6(ii)] = ttest2(Normal_dist_OCF_R,CRD_dist_OCF_R);
                [h7(ii,:),p7(ii,:),~,Tstats7(ii)] = ttest2(Normal_dist_OCF_L,OCF_L(:,ii)');
                [h8(ii,:),p8(ii,:),~,Tstats8(ii)] = ttest2(Normal_dist_OCF_R,OCF_R(:,ii)');
                
                % get superfiber coords
                coords1 = afq.TractProfiles(ii,jj1).coords.acpc;
                coords2 = afq.TractProfiles(ii,jj2).coords.acpc;
                
                % correct fiber direction from anterior to posteror
                
                if coords1(2,1)<coords1(2,end); coords1 = fliplr(coords1{1});end
                if coords2(2,1)<coords2(2,end); coords2 = fliplr(coords2{1});end
                
        end;
        %% switch 'disease'
        switch disease % disease = 'individual'
            case 'JMD'
                Color1 = Tstats1(ii).tstat;
                Color2 = Tstats2(ii).tstat;
            case 'LHON'
                Color1 = Tstats3(ii).tstat;
                Color2 = Tstats4(ii).tstat;
            case 'CRD'
                Color1 = Tstats5(ii).tstat;
                Color2 = Tstats6(ii).tstat;
            case 'individual'
                Color1 = Tstats7(ii).tstat;
                Color2 = Tstats8(ii).tstat;
        end;
        %
        %         % get superfiber coords
        %         coords1 = afq.TractProfiles(ii,jj1).coords.acpc;
        %         coords2 = afq.TractProfiles(ii,jj2).coords.acpc;
        %
        %         % correct fiber direction from anterior to posteror
        %
        %         if coords1(2,1)<coords1(2,end); coords1 = fliplr(coords1{1});end
        %         if coords2(2,1)<coords2(2,end); coords2 = fliplr(coords2{1});end
        
        % Render the fibers with test value
        switch pathway % pathway ='OT'
            case 1
                radius = 2;
                subdivs = 20;
                cmap    = 'jet';
                crange = [1 4];
                %                 newfig = 1;
            case 2
                radius = 1.2;
                subdivs = 20;
                cmap    = 'jet';
                %                 newfig = 1;
                
            case 3
                radius = 1.5;
                subdivs = 20;
                cmap    = 'jet';
                %                 newfig = 1;
        end;
        if pathway == 1
            AFQ_RenderTractProfile(coords1, radius, Color1, subdivs, cmap, crange, 1);
        else
            AFQ_RenderTractProfile(coords1, radius, Color1, subdivs, cmap, crange, 0);
        end
        hold('on')
        
        axis off
        axis image
        AFQ_RenderTractProfile(coords2, radius, Color2, subdivs, cmap, crange, 0);
        axis off
        axis image
        % Load dt6
    end
    %% Add axial T1w image
    dt =  dtiLoadDt6(afq.files.dt6{ii});
    t1 = niftiRead(dt.files.t1);
    
    AFQ_AddImageTo3dPlot(t1, [0, 0, -30]);
    axis image
    
    title(sprintf('%s %s  vs Control %s %s',subDir{ii} ,disease,'Tstats',diffusivity))
    view(0,89)
    %     view(-38,30)
    camlight('headlight')
    
    %% save the figure in
    
    switch save
        case 'png'
            cd /biac4/wandell/biac3/wandell7/shumpei/matlab/git/LHON/RegionWhereisDamaged(.png)
            print(gcf, '-dpng',sprintf('%s_%s_Control_%s_%s.png',subDir{ii},disease,'Tstats',diffusivity))
            close all;
        case 'eps'
            cd /biac4/wandell/biac3/wandell7/shumpei/matlab/git/LHON/RegionWhereisDamaged(.eps)
            print(gcf, '-depsc',sprintf('%s_%s_Control_%s_%s.eps',subDir{ii},disease,'Tstats',diffusivity))
            close all;
        case '0'
    end;
    
    
end





