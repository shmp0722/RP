function CompareDamagedRegion
% To make pictures of the region where we find diffusivities (AD,RD) difference
% diffusivity = 'fa', 'md', 'ad', 'rd'
% test    = 'minus', 'effect_size'
% radius  = radius of tube
% pathway = 'OT', 'OR' or 'OCF'
% crange = [- 0.3 0.3];
% Save    = 1 or 0;

% Set the path to data directory
%% set directory
homeDir = '/biac4/wandell/biac2/wandell/data/DWI-Tamagawa-Japan';

subs = {...
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
    'RP5-KS-2014-01-31'};        

%% Load afq structure
cd /biac4/wandell/biac3/wandell7/shumpei/matlab/git/LHON/3RP
load 3RP_3SD_TractProfile.mat

%% classify all subjects intogroups
JMD = 1:4;
CRD = 5:9;
% LHON = 10:15;
LHON = [10:14,27];

Ctl = 16:23;
RP = [24:26,28,29];

% disease = {'JMD','CRD',' LHON','Ctl','RP'};
% Disease = {JMD, CRD, LHON, Ctl, RP};

disease = {'JMD','CRD',' LHON','Ctl','RP'};
Disease = {JMD, CRD, LHON, Ctl, RP};

fgN ={'ROR1206_D4L4.pdb','LOR1206_D4L4.pdb','ROTD4L4_1206.pdb','LOTD4L4_1206.pdb',...
    'ROTD3L2_1206.pdb','LOTD3L2_1206.pdb'};

% diffusivity = 'fa';
% diffusivity = 'ad';
% diffusivity = 'rd';
% diffusivity = 'md';
Dif = {'fa','md','ad','rd'};
return
%% render each fiber
% mandara
for d= 1:4
    diffusivity = Dif{d};
    for fibID =[1];%5 %[1,3,5]; % {'Optic Radiation', 'Optic Tract'}
        for sdID = 1; %;[1,4,5]; % {mean, -sd1, sd1}
            figure; hold('on')
            for j = 2:4 ;% exclude JMD and RP group
                for ii =1: Disease{j};
                    
                    % get superfiber coords
                    coords1 = TractProfile{ii,fibID}{sdID}.coords.acpc;
                    coords2 = TractProfile{ii,fibID+1}{sdID}.coords.acpc;
                    
                    % slide x axis of figure
                    addX =  zeros(3,100);
                    addY =  zeros(3,100);
                    if fibID ==1;  %OR
                        switch j
                            case 1 % JMD
                                addX(1,:)=100*(ii-1);
                            case 2 % CRD
                                addX(1,:)=100*(ii-5)+140;
                                addY(2,:)= -90*(j-1)-coords2(2,1,1) ;
                            case 3 % LHON
                                if ii==27;
                                    addX(1,:)=100*(ii-22)+100;
                                    addY(2,:)= -90*(j-1)-coords2(2,1,1) ;
                                else
                                    addX(1,:)=100*(ii-10)+100;
                                    addY(2,:)= -90*(j-1)-coords2(2,1,1) ;
                                end
                            case 4 % Control
                                addX(1,:)=100*(ii-16);
                                addY(2,:)= -90*(j-1)-coords2(2,1,1) ;
                            case 5 % RP
                                addX(1,:)=100*(ii-24);
                                addY(2,:)= -90*(j-1)-coords2(2,1,1) ;
                        end
                    else % OT
                        switch j
                            case 1 % JMD
                                addX(1,:)=70*(ii-1);
                            case 2 % CRD
                                addX(1,:)=70*(ii-5)+100;
                                addY(2,:)= -50*(j-1)-coords2(2,1,1) ;
                            case 3 % LHON
                                if ii==27;
                                    addX(1,:)=70*(ii-22)+70;
                                    addY(2,:)= -50*(j-1)-coords2(2,1,1) ;
                                else
                                    addX(1,:)=70*(ii-10)+70;
                                    addY(2,:)= -50*(j-1)-coords2(2,1,1) ;
                                end
                            case 4 % Control
                                addX(1,:)=70*(ii-16);
                                addY(2,:)= -50*(j-1)-coords2(2,1,1) ;
                                
                            case 5 % RP
                                addX(1,:)=70*(ii-24);
                                addY(2,:)= -50*(j-1) ;
                                
                        end
                    end
                    
                    coords1 = coords1 + addX +addY;
                    coords2 = coords2 + addX +addY;
                    
                    % make sure whether the fiber direction is anterior to posteror or
                    % not
                    if coords1(2,1)<coords1(2,end); coords1 = fliplr(coords1{1});end
                    if coords2(2,1)<coords2(2,end); coords2 = fliplr(coords2{1});end
                    
                    %% switch diffusivity
                    switch diffusivity % diffusivity = 'rd'
                        case 'fa'
                            val1 =  TractProfile{ii,fibID}{sdID}.vals.fa;
                            val2 =  TractProfile{ii,fibID+1}{sdID}.vals.fa;
                            cmin = 0.3; cmax = 0.7;
                        case 'md'
                            val1 =  TractProfile{ii,fibID}{sdID}.vals.md;
                            val2 =  TractProfile{ii,fibID+1}{sdID}.vals.md;
                            if fibID ==1; cmin = 0.75; cmax = 1.0;
                            else
                                cmin = 0.9; cmax = 1.1;
                            end;
                        case 'ad'
                            val1 =  TractProfile{ii,fibID}{sdID}.vals.ad;
                            val2 =  TractProfile{ii,fibID+1}{sdID}.vals.ad;
                            if fibID ==1; cmin = 1; cmax = 1.7;
                            else cmin = 1.2; cmax = 1.8; end;
                            
                        case 'rd'
                            val1 =  TractProfile{ii,fibID}{sdID}.vals.rd;
                            val2 =  TractProfile{ii,fibID+1}{sdID}.vals.rd;
                            if fibID ==1; cmin = 0.5; cmax = 0.85;
                            else
                                cmin = 0.6; cmax = 1;
                            end;
                    end
                    % inputs
                    crange = [cmin cmax];
                    radius = 3;
                    subdivs = 20;
                    cmap    = 'jet';
                    % render super fibers with value
                    AFQ_RenderTractProfile(coords1, radius, val1, subdivs, cmap, crange, 0);
                    AFQ_RenderTractProfile(coords2, radius, val2, subdivs, cmap, crange, 0);
                    %                 axis([-60 60 -90 0 -15 10 cmin cmax])
                    %                 axis on;
                    
                end
            end
            camlight('headlight');
            %         lighting gouraud
            axis image
            if fibID==1;
                line([726,746], [-372 -372], 'LineWidth',2 , 'Color', 'black' )
                axis on
                axis([-45 745 -375 -70 -25 30 cmin cmax]) % OR
                
            else
                axis([-30 520 -200 -20 -19 1 cmin cmax]) % OT
                % Render scale bar 20mm
                line([500,520], [-200 -200], 'LineWidth',2 , 'Color', 'black' )
                %         line([-20,0], [-50 -50], 'LineWidth',2 , 'Color', 'black' )
            end
            axis off
            colorbar off;
            hold('off')
            
            %% save figure
            %             cd /biac4/wandell/biac3/wandell7/shumpei/matlab/git/LHON/3RP/Figure3
            cd /biac4/wandell/biac3/wandell7/shumpei/matlab/git/LHON/3RP/Figure3/Deleted_colorbar
            switch fibID
                case 1 % OR
                    %                     print(gcf, '-dpng',sprintf('OR_mandara_%s_%s.png',diffusivity,TractProfile{ii,j}{sdID}.name));
                    print(gcf, '-depsc2',sprintf('OR_mandara_%s_%s.eps',diffusivity,TractProfile{ii,j}{sdID}.name),'-r400');
                    
                    %                 case 3 % OT
                    %                     print(gcf, '-dpng',sprintf('OT_mandara_%s_%s.png',diffusivity,TractProfile{ii,j}{sdID}.name));
                case 5 % OT
                    %                     print(gcf, '-dpng',sprintf('OT_mandara_%s_%s.png',diffusivity,TractProfile{ii,j}{sdID}.name));
                    print(gcf, '-depsc2',sprintf('OT_mandara_%s_%s.eps',diffusivity,TractProfile{ii,j}{sdID}.name),'-r400');
            end
            
        end
    end
end

cd /biac4/wandell/biac3/wandell7/shumpei/matlab/git/LHON/3RP
%        close all;
return


%% Group comparison
for d = 1:4
    diffusivity = Dif{d};
    for sdID = [1]; % {mean, -sd1, sd1}
        for fibID =1 ;%[1,3]; % {'Optic Radiation', 'Optic Tract'}
            figure; hold('on')
            for j = 1:5 ;% exclude RP group
                for ii = Disease{j};
                    
                    % get superfiber coords
                    coords1 = TractProfile{ii,fibID}{sdID}.coords.acpc;
                    coords2 = TractProfile{ii,fibID+1}{sdID}.coords.acpc;
                    
                    % slide x axis of figure
                    addX =  zeros(3,100);
                    addY =  zeros(3,100);
                    if fibID ==1;  %OR
                        switch j
                            case 1 % JMD
                                addX(1,:)=100*(ii-1);
                            case 2 % CRD
                                addX(1,:)=100*(ii-5);
                                %                                 addX(1,:)=100*(ii-5)+140;
                                
                                addY(2,:)= -100*(j-1)-coords2(2,1,1) ;
                            case 3 % LHON
                                if ii==27;
                                    %                                     addX(1,:)=100*(ii-22)+100;
                                    addX(1,:)=100*(ii-22);
                                    
                                    addY(2,:)= -100*(j-1)-coords2(2,1,1) ;
                                else
                                    addX(1,:)=100*(ii-10);
                                    %                                                                         addX(1,:)=100*(ii-10)+100;
                                    
                                    addY(2,:)= -100*(j-1)-coords2(2,1,1) ;
                                end
                            case 4 % Control
                                addX(1,:)=100*(ii-16);
                                addY(2,:)= -100*(j-1)-coords2(2,1,1) ;
                            case 5 % RP
                                if ii <27;
                                    addX(1,:)=100*(ii-24);
                                else
                                    addX(1,:)=100*(ii-25);
                                end
                                addY(2,:)= -100*(j-1)-coords2(2,1,1) ;
                        end
                    else % OT
                        switch j
                            case 1 % JMD
                                addX(1,:)=70*(ii-1);
                            case 2 % CRD
                                addX(1,:)=70*(ii-5)+100;
                                addY(2,:)= -50*(j-1)-coords2(2,1,1) ;
                            case 3 % LHON
                                if ii==27;
                                    addX(1,:)=70*(ii-22)+70;
                                    addY(2,:)= -50*(j-1)-coords2(2,1,1) ;
                                else
                                    addX(1,:)=70*(ii-10)+70;
                                    addY(2,:)= -50*(j-1)-coords2(2,1,1) ;
                                end
                            case 4 % Control
                                addX(1,:)=70*(ii-16);
                                addY(2,:)= -50*(j-1)-coords2(2,1,1) ;
                                
                            case 5 % RP
                                if ii <27;
                                    addX(1,:)=70*(ii-24);
                                else
                                    addX(1,:)=70*(ii-25);
                                end
                                addY(2,:)= -50*(j-1) ;
                                
                        end
                    end
                    
                    coords1 = coords1 + addX +addY;
                    coords2 = coords2 + addX +addY;
                    
                    % make sure whether the fiber direction is anterior to posteror or
                    % not
                    if coords1(2,1)<coords1(2,end); coords1 = fliplr(coords1{1});end
                    if coords2(2,1)<coords2(2,end); coords2 = fliplr(coords2{1});end
                    
                    %% switch diffusivity
                    switch diffusivity % diffusivity = 'rd'
                        case 'fa'
                            val1 =  TractProfile{ii,fibID}{sdID}.vals.fa;
                            val2 =  TractProfile{ii,fibID+1}{sdID}.vals.fa;
                            cmin = 0.3; cmax = 0.7;
                        case 'md'
                            val1 =  TractProfile{ii,fibID}{sdID}.vals.md;
                            val2 =  TractProfile{ii,fibID+1}{sdID}.vals.md;
                            if fibID ==1; cmin = 0.75; cmax = 1.0;
                            else
                                cmin = 0.9; cmax = 1.1;
                            end;
                        case 'ad'
                            val1 =  TractProfile{ii,fibID}{sdID}.vals.ad;
                            val2 =  TractProfile{ii,fibID+1}{sdID}.vals.ad;
                            if fibID ==1; cmin = 1; cmax = 1.7;
                            else cmin = 1.2; cmax = 1.8; end;
                            
                        case 'rd'
                            val1 =  TractProfile{ii,fibID}{sdID}.vals.rd;
                            val2 =  TractProfile{ii,fibID+1}{sdID}.vals.rd;
                            if fibID ==1; cmin = 0.5; cmax = 0.85;
                            else
                                cmin = 0.6; cmax = 1;
                            end;
                    end
                    % inputs
                    crange = [cmin cmax];
                    radius = 3;
                    subdivs = 20;
                    cmap    = 'jet';
                    % render super fibers with value
                    AFQ_RenderTractProfile(coords1, radius, val1, subdivs, cmap, crange, 0);
                    AFQ_RenderTractProfile(coords2, radius, val2, subdivs, cmap, crange, 0);
                    %                 axis([-60 60 -90 0 -15 10 cmin cmax])
                    %                 axis on;
                    
                end
            end
            camlight('headlight');
            lighting gouraud
            axis image
            hold('off')
            axis off
            colorbar off
            
            % put scale bar
            line([710,730], [-470 -470], 'LineWidth',2 , 'Color', 'black' )
            
            %% save figure
            cd /biac4/wandell/biac3/wandell7/shumpei/matlab/git/LHON/3RP/Figure5/OR_both_5groups
            
            print(gcf, '-depsc2',sprintf('OR_mandara_%s_%s_wocbar.eps',diffusivity,'both'),'-r400');
            
            
        end
    end
end

cd /biac4/wandell/biac3/wandell7/shumpei/matlab/git/LHON/3RP
%        close all;
return

%% According to fiber length
% each subject
for fibID =2 ;%[1,3]; % {'Optic Radiation', 'Optic Tract'}
    diffusivity = 'fa';% Dif{d};
    %         for j = 2:4 ;% exclude RP group
    for ii =23%CRD; %[6,8,9,14,22,23];%14;[6,8,9];%1:length(subs)%CRD;%Disease{j};
        figure; hold('on')
        
        for sdID = 2:7; % {-3sd:3sd};
            
            % get superfiber coords
            if ~isempty(TractProfile{ii,fibID}{sdID}.coords.acpc)
                coords1 = TractProfile{ii,fibID}{sdID}.coords.acpc;
                
                % slide x axis of figure
                addX =  zeros(3,100);
                addX(1,:)=45*(sdID-2);
                coords1 = coords1 + addX +addY;
                
                % make sure fiber direction
                if coords1(2,1)<coords1(2,end); coords1 = fliplr(coords1{1});end
                
                %% get diffusivity values
                switch diffusivity % diffusivity = 'rd'
                    case 'fa'
                        val1 =  TractProfile{ii,fibID}{sdID}.vals.fa;
                        %                             val2 =  TractProfile{ii,fibID+1}{sdID}.vals.fa;
                        cmin = 0.3; cmax = 0.7;
                    case 'md'
                        val1 =  TractProfile{ii,fibID}{sdID}.vals.md;
                        %                             val2 =  TractProfile{ii,fibID+1}{sdID}.vals.md;
                        if fibID ==1; cmin = 0.75; cmax = 1.0;
                        else
                            cmin = 0.9; cmax = 1.1;
                        end;
                    case 'ad'
                        val1 =  TractProfile{ii,fibID}{sdID}.vals.ad;
                        %                             val2 =  TractProfile{ii,fibID+1}{sdID}.vals.ad;
                        if fibID ==1; cmin = 1; cmax = 1.7;
                        else cmin = 1.2; cmax = 1.8; end;
                        
                    case 'rd'
                        val1 =  TractProfile{ii,fibID}{sdID}.vals.rd;
                        %                             val2 =  TractProfile{ii,fibID+1}{sdID}.vals.rd;
                        if fibID ==1; cmin = 0.5; cmax = 0.85;
                        else
                            cmin = 0.6; cmax = 1;
                        end;
                end
                % inputs
                crange = [cmin cmax];
                radius = 3;
                subdivs = 20;
                cmap    = 'jet';
                % render super fibers with value
                AFQ_RenderTractProfile(coords1, radius, val1, subdivs, cmap, crange, 0);
                %                     AFQ_RenderTractProfile(coords2, radius, val2, subdivs, cmap, crange, 0);
                %                 axis([-60 60 -90 0 -15 10 cmin cmax])
                %                 axis on;
            else
            end
        end
        
        % put scale bar
        line([230,230], [-200 -220], 'LineWidth',2 , 'Color', 'black' )
        
        %         end
        camlight('headlight');
        %             lighting gouraud
        axis image
        hold('off')
        axis([-45,235, -230,-140])
        axis off
        colorbar off
        
        
        
        %          %% save figure
        %             cd /biac4/wandell/biac3/wandell7/shumpei/matlab/git/LHON/3RP/Figure5
        %
        %             print(gcf, '-depsc2',sprintf('OR_mandara_%s_%s_wocbar.eps',diffusivity,subs{ii}),'-r400');
        
    end
end


cd /biac4/wandell/biac3/wandell7/shumpei/matlab/git/LHON/3RP
%        close all;
return

 
%% According to fiber length
% Render both hemisphere fasicles together
for d = 1%:4
    for fibID =2 ;%[1,3]; % {'Optic Radiation', 'Optic Tract'}
        diffusivity = 'fa';% Dif{d};
        %
        
        for j =2% 2:4 ;% exclude RP group
            for ii = Disease{j};
                figure; hold('on')
                for sdID = 2:7; % {-3sd:3sd};
                    
                    % get superfiber coords
                    if ~isempty(TractProfile{ii,fibID}{sdID}.coords.acpc)
                        coords1 = TractProfile{ii,fibID}{sdID}.coords.acpc;
                        
                        % slide x axis of figure
                        addX =  zeros(3,100);
                        addY =  zeros(3,100);
                        
                        addX(1,:)=45*(sdID-2);
%                         if ii==27;
%                             addY(2,:)= -100*(ii-13);
%                         else
%                             addY(2,:)= -100*(ii-1);
%                             
%                         end
                        
%                         coords1 = coords1 + addX +addY;
                        coords1 = coords1 + addX;

                        % make sure whether the fiber direction is anterior to posteror or
                        % not
                        if coords1(2,1)<coords1(2,end); coords1 = fliplr(coords1{1});end
                        
                        %% switch diffusivity
                        switch diffusivity % diffusivity = 'rd'
                            case 'fa'
                                val1 =  TractProfile{ii,fibID}{sdID}.vals.fa;
                                %                             val2 =  TractProfile{ii,fibID+1}{sdID}.vals.fa;
                                cmin = 0.3; cmax = 0.7;
                            case 'md'
                                val1 =  TractProfile{ii,fibID}{sdID}.vals.md;
                                %                             val2 =  TractProfile{ii,fibID+1}{sdID}.vals.md;
                                if fibID ==1; cmin = 0.75; cmax = 1.0;
                                else
                                    cmin = 0.9; cmax = 1.1;
                                end;
                            case 'ad'
                                val1 =  TractProfile{ii,fibID}{sdID}.vals.ad;
                                %                             val2 =  TractProfile{ii,fibID+1}{sdID}.vals.ad;
                                if fibID ==1; cmin = 1; cmax = 1.7;
                                else cmin = 1.2; cmax = 1.8; end;
                                
                            case 'rd'
                                val1 =  TractProfile{ii,fibID}{sdID}.vals.rd;
                                %                             val2 =  TractProfile{ii,fibID+1}{sdID}.vals.rd;
                                if fibID ==1; cmin = 0.5; cmax = 0.85;
                                else
                                    cmin = 0.6; cmax = 1;
                                end;
                        end
                        % inputs
                        crange = [cmin cmax];
                        radius = 3;
                        subdivs = 20;
                        cmap    = 'jet';
                        % render super fibers with value
                        AFQ_RenderTractProfile(coords1, radius, val1, subdivs, cmap, crange, 0);
                        % add ROI
                        roi = dtiReadRoi(fullfile(AFQdata,subs{ii},'dwi_2nd/ROIs/Lt-LGN4'));
                        % adjust x position
                        addX = zeros(size(roi.coords));
                        addX(:,1,1)=45*(sdID-2);
                        roi.coords = roi.coords + addX;
                        
                        % render ROI
                        AFQ_RenderRoi(roi,[1 .5 0]);
                    else
                    end
                end
                
               
                
                camlight('headlight');
                %             lighting gouraud
                axis image
                hold('off')
                axis off
                colorbar off
%                 %% save figure
%                 cd /biac4/wandell/biac3/wandell7/shumpei/matlab/git/LHON/3RP/Figure5
%                 switch fibID
%                     case 1
%                         print(gcf, '-depsc2','-r400',sprintf('R-OR_%s_%s_wocbar.eps',subs{ii},diffusivity));
%                     case 2
%                         print(gcf, '-depsc2','-r400',sprintf('L-OR_%s_%s_wocbar.eps',subs{ii},diffusivity));
%                 end
            end
        end
        
    end
end

cd /biac4/wandell/biac3/wandell7/shumpei/matlab/git/LHON/3RP
%        close all;
return

%% Render SO with t1
% Render both hemisphere fasicles together
figure; hold on;
for fibID =1:4;%[1,3]; % {'Optic Radiation', 'Optic Tract'}
    diffusivity = 'fa';% Dif{d};
    sdID = 1;
    
    %         for j = 2:4 ;% exclude RP group
    %             for ii = Disease{j};
    %                 figure; hold('on')
    %                 for sdID = 2:7; % {-3sd:3sd};
    ii =23;
    % get superfiber coords
    if ~isempty(TractProfile{ii,fibID}{sdID}.coords.acpc)
        coords1 = TractProfile{ii,fibID}{sdID}.coords.acpc;
        
        
        % make sure whether the fiber direction is anterior to posteror or
        % not
        if coords1(2,1)<coords1(2,end); coords1 = fliplr(coords1{1});end
        
        %% switch diffusivity
        switch diffusivity % diffusivity = 'rd'
            case 'fa'
                val1 =  TractProfile{ii,fibID}{sdID}.vals.fa;
                %                             val2 =  TractProfile{ii,fibID+1}{sdID}.vals.fa;
                cmin = 0.3; cmax = 0.7;
            case 'md'
                val1 =  TractProfile{ii,fibID}{sdID}.vals.md;
                %                             val2 =  TractProfile{ii,fibID+1}{sdID}.vals.md;
                if fibID ==1; cmin = 0.75; cmax = 1.0;
                else
                    cmin = 0.9; cmax = 1.1;
                end;
            case 'ad'
                val1 =  TractProfile{ii,fibID}{sdID}.vals.ad;
                %                             val2 =  TractProfile{ii,fibID+1}{sdID}.vals.ad;
                if fibID ==1; cmin = 1; cmax = 1.7;
                else cmin = 1.2; cmax = 1.8; end;
                
            case 'rd'
                val1 =  TractProfile{ii,fibID}{sdID}.vals.rd;
                %                             val2 =  TractProfile{ii,fibID+1}{sdID}.vals.rd;
                if fibID ==1; cmin = 0.5; cmax = 0.85;
                else
                    cmin = 0.6; cmax = 1;
                end;
        end
        % inputs
        crange = [cmin cmax];
        radius = 3;
        subdivs = 20;
        cmap    = 'jet';
        % render super fibers with value
        AFQ_RenderTractProfile(coords1, radius, val1, subdivs, cmap, crange, 0);
        %                     AFQ_RenderTractProfile(coords2, radius, val2, subdivs, cmap, crange, 0);
        %                 axis([-60 60 -90 0 -15 10 cmin cmax])
        %                 axis on;
    else
    end
end
% add T1 axial image
t1f = fullfile(AFQdata, subs{ii}, 't1.nii.gz');
t1 = niftiRead(t1f);
AFQ_AddImageTo3dPlot(t1, [0, 0, -30]);

% % scalebar
% line([55,75], [-110 -110], 'LineWidth',2 , 'Color', 'white' )
% line([65,65], [-100 -120], 'LineWidth',2 , 'Color', 'white' )


camlight('headlight');
%             lighting gouraud
axis image
hold('off')
axis off
colorbar off


%% save figure
cd /biac4/wandell/biac3/wandell7/shumpei/matlab/git/LHON/3RP/Figure2
switch fibID
    case 1
        print(gcf, '-depsc2','-r400',sprintf('SO_fatract_2.eps',subs{ii},diffusivity));
        print(gcf, '-dpng','-r400',sprintf('SO_fatract_2.png',subs{ii},diffusivity));
        
    case 2
        print(gcf, '-depsc2','-r400',sprintf('L-OR_%s_%s_wocbar.eps',subs{ii},diffusivity));
end



cd /biac4/wandell/biac3/wandell7/shumpei/matlab/git/LHON/3RP
%        close all;
return


%% Render SO with t1
% Render both hemisphere fasicles together
figure; hold on;
for fibID =1:4%[1,3]; % {'Optic Radiation', 'Optic Tract'}
    diffusivity = 'fa';% Dif{d};
    sdID = 1;
    
    ii =23;
    % get superfiber coords
    coords1 = TractProfile{ii,fibID}{sdID}.coords.acpc;
    %%
    if fibID <=2;
        val1 =  zeros(1,100);
    else
        val1 = ones(1,100);
    end
    %                             val2 =  TractProfile{ii,fibID+1}{sdID}.vals.fa;
    cmin = 0.3; cmax = 0.7;
    
    % inputs
    crange = [cmin cmax];
    radius = 3;
    subdivs = 20;
    cmap    = 'jet';
    % render super fibers with value
    AFQ_RenderTractProfile(coords1, radius, val1, subdivs, cmap, crange, 0);
    %                     AFQ_RenderTractProfile(coords2, radius, val2, subdivs, cmap, crange, 0);
    %                 axis([-60 60 -90 0 -15 10 cmin cmax])
    %                 axis on;
end
% add T1 axial image
t1f = fullfile(AFQdata, subs{ii}, 't1.nii.gz');
t1 = niftiRead(t1f);
AFQ_AddImageTo3dPlot(t1, [0, 0, -30]);

% scalebar
line([55,75], [-110 -110], 'LineWidth',2 , 'Color', 'white' )
line([65,65], [-100 -120], 'LineWidth',2 , 'Color', 'white' )


camlight('headlight');
%             lighting gouraud
axis image
hold('off')
axis off
colorbar off


%% save figure
cd /biac4/wandell/biac3/wandell7/shumpei/matlab/git/LHON/3RP/Figure2
switch fibID
    case 1
        print(gcf, '-depsc2','-r400',sprintf('SO_fatract_2.eps',subs{ii},diffusivity));
        print(gcf, '-dpng','-r400',sprintf('SO_fatract_2.png',subs{ii},diffusivity));
        
    case 2
        print(gcf, '-depsc2','-r400',sprintf('L-OR_%s_%s_wocbar.eps',subs{ii},diffusivity));
end




cd /biac4/wandell/biac3/wandell7/shumpei/matlab/git/LHON/3RP
%        close all;
return


