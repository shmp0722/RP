function Dividedin3Part_OR
%
AFQdata = '/biac4/wandell/biac2/wandell/data/DWI-Tamagawa-Japan';

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
    'RP3-TO-13120611-DWI'};
%% cd and load afq structure

% cd /biac4/wandell/biac3/wandell7/shumpei/matlab/git/LHON/3RP
% load 3RP_1210.mat

% %%
% for ii = [1 10 23];
%     R_Dir = fullfile(AFQdata,subs{ii},'dwi_2nd','FiberLength','ROR1206_D4L4');
%     L_Dir = fullfile(AFQdata,subs{ii},'dwi_2nd','FiberLength','LOR1206_D4L4');
%
%     %%
%     % set fiber names
%     fgF = {'ROR_C.pdb','ROR_V.pdb','ROR_D.pdb','LOR_C.pdb','LOR_V.pdb','LOR_D.pdb'} ;
%     % Load dt structure
%     dt = dtiLoadDt6(AFQ_get(afq,'dt6path',ii));
%
%     % fg file loop
%     for jj = 1:length(fgF);
%         numNodes = 100;
%         %  [fa, md, rd, ad, cl, TractProfile] = AFQ_ComputeTractProperties(fg_D,dt,numNodes);
%         if jj<=3;
%             fgtmp  = fgRead(fullfile(R_Dir,fgF{jj}));
%         else
%             fgtmp  = fgRead(fullfile(L_Dir,fgF{jj}));
%         end;
%
%         fgtmp = SO_AlignFiberDirection(fgtmp,'AP');
%
%
%         % Create Tract Profile structure
%         %         TractProfile = AFQ_CreateTractProfile;
%         % Pre allocate data arrays
%         fa=nan(100,1);
%         md=nan(100,1);
%         rd=nan(100,1);
%         ad=nan(100,1);
%         cl=nan(100,1);
%         cs=nan(100,1);
%         cp=nan(100,1);
%         volume=nan(100,1);
%
%
%
%         [fa(:, jj),md(:, jj),rd(:, jj),ad(:, jj),cl(:, jj),...
%             SuperFibersGroup(jj),~,cp(:,jj),cs(:,jj),fgResampled]=...
%             dtiComputeDiffusionPropertiesAlongFG(fgtmp, dt, [], [], numNodes,1);
%         % Compute tract volume at each node
%         volume(:,jj) = AFQ_TractProfileVolume(fgResampled);
%         % Put mean fiber into Tract Profile structure
%         TractProfile(jj) = AFQ_CreateTractProfile('name',fgtmp.name,'superfiber',SuperFibersGroup(jj));
%         % Add the volume measurement
%         TractProfile(jj).fiberVolume = volume(:,jj)';
%         % Add planarity and sphericity measures to the tract profile. We
%         % could return them as outputs from the main function but the list
%         % of outputs keeps growing...
%         TractProfile(jj) = AFQ_TractProfileSet(TractProfile(jj),'vals','fa',fa(:,jj)');
%         TractProfile(jj) = AFQ_TractProfileSet(TractProfile(jj),'vals','md',md(:,jj)');
%         TractProfile(jj) = AFQ_TractProfileSet(TractProfile(jj),'vals','ad',ad(:,jj)');
%         TractProfile(jj) = AFQ_TractProfileSet(TractProfile(jj),'vals','rd',rd(:,jj)');
%
%         TractProfile(jj) = AFQ_TractProfileSet(TractProfile(jj),'vals','planarity',cp(:,jj)');
%         TractProfile(jj) = AFQ_TractProfileSet(TractProfile(jj),'vals','sphericity',cs(:,jj)');
%     end
%     Val{ii}.TractProfile = TractProfile;
%     clear TractProfile;
% end
% %% save TP structure
% cd /biac4/wandell/biac3/wandell7/shumpei/matlab/git/LHON/3RP
% save TP_ROR_3divided_2 Val

%% Load Val structure
cd /biac4/wandell/biac3/wandell7/shumpei/matlab/git/LHON/3RP
load TP_ROR_3divided_2

%% let's evaluate value of fiber
for id = [1,10,23];
    %% ROR plot
    c = lines(100);
    X = 1:100;
    
    % selectt diffusion parameter
    
    vals = {'fa','md','ad','rd'};
    portions = {'Center','ventral','Dorsal'};   
    
    
    for val = 1:length(vals)
        
        figure; hold on ;
        vals = {'fa','md','ad','rd'};
        for  portion = 1:3; % 1 = core, 2 = ventral, 3 = dorsal;
            X = 1:100;
            switch val
                case 1
                    Y  = Val{id}.TractProfile(portion).vals.fa;
                    yaxis = 'Fractional Anisotropy';
                case 2
                    Y  = Val{id}.TractProfile(portion).vals.md;
                    yaxis = 'Mean Diffusivity';
                    
                case 3
                    Y  = Val{id}.TractProfile(portion).vals.ad;
                    yaxis = 'Axial Diffusivity';
                    
                case 4
                    Y  = Val{id}.TractProfile(portion).vals.rd;
                    yaxis = 'Radial Diffusivity';
            end
            plot(X,Y,'color',c(portion,:));
            legend('Core','Ventral','Dorsal')
            ylabel(yaxis,'fontName','Times','fontSize',14);
            title(sprintf('%s_%s_ROR',vals{val},subs{id}));
        end
        
        hold off;
        
        %% save
        cd /biac4/wandell/biac3/wandell7/shumpei/matlab/git/LHON/3RP/Manualy_divided3portion(Core_Vent_Dor)_plot
        print(gcf, '-dpng',sprintf('%s_%s_ROR_3Portion.png',vals{val},subs{id}))
        close all
    end
    %% LOR plot
    for val = 1:length(vals)
        figure; hold on ;
        
        for  portion = 4:6; % 1 = core, 2 = ventral, 3 = dorsal;
            X = 1:100;
            
            switch val
                case 1
                    Y  = Val{id}.TractProfile(portion).vals.fa;
                    yaxis = 'Fractional Anisotropy';
                case 2
                    Y  = Val{id}.TractProfile(portion).vals.md;
                    yaxis = 'Mean Diffusivity';
                    
                case 3
                    Y  = Val{id}.TractProfile(portion).vals.ad;
                    yaxis = 'Axial Diffusivity';
                    
                case 4
                    Y  = Val{id}.TractProfile(portion).vals.rd;
                    yaxis = 'Radial Diffusivity';
            end
            plot(X,Y,'color',c(portion-3,:));
            title(sprintf('%s_%s_LOR',vals{val},subs{id}));
            legend('Core','Ventral','Dorsal')
            ylabel(yaxis,'fontName','Times','fontSize',14);
            
        end
        print(gcf, '-dpng',sprintf('%s_%s_LOR_3Portion.png',vals{val},subs{id}))
        hold off;
    end
end



%% let's compare diffusivities across disease
c = lines(100);
X = 1:100;

% selectt diffusion parameter

vals = {'fa','md','ad','rd'};
portions = {'Center','ventral','Dorsal'};

%% ROR
for val = 1:length(vals)
    %  portion loop
    for  portion = 1:length(portions); % 1 = core, 2 = ventral, 3 = dorsal;
        figure; hold on ;
        
        % patients loop
        for id = [1,10,23];
            
            switch val
                case 1
                    Y  = Val{id}.TractProfile(portion).vals.fa;
                    yaxis = 'Fractional Anisotropy';
                case 2
                    Y  = Val{id}.TractProfile(portion).vals.md;
                    yaxis = 'Mean Diffusivity';
                    
                case 3
                    Y  = Val{id}.TractProfile(portion).vals.ad;
                    yaxis = 'Axial Diffusivity';
                    
                case 4
                    Y  = Val{id}.TractProfile(portion).vals.rd;
                    yaxis = 'Radial Diffusivity';
            end
            plot(X,Y,'color',c(id,:));
        end
        legend('JMD','LHON','Ctl')
        ylabel(yaxis,'fontName','Times','fontSize',14);
        title(sprintf('%s %s ROR',vals{val},portions{portion}));
        hold off;
        
        %% save
        cd /biac4/wandell/biac3/wandell7/shumpei/matlab/git/LHON/3RP/Manualy_divided3portion(Core_Vent_Dor)_plot
        print(gcf, '-dpng',sprintf('%s_%s_ROR_3Portion.png',vals{val},portions{portion}))
        close all
    end
    
    
    %% LOR
    %  portion loop
    for  portion = 4:length(portions)+3; % 1 = core, 2 = ventral, 3 = dorsal;
        figure; hold on ;
        
        % patients loop
        for id = [1,10,23];
            
            switch val
                case 1
                    Y  = Val{id}.TractProfile(portion).vals.fa;
                    yaxis = 'Fractional Anisotropy';
                case 2
                    Y  = Val{id}.TractProfile(portion).vals.md;
                    yaxis = 'Mean Diffusivity';
                    
                case 3
                    Y  = Val{id}.TractProfile(portion).vals.ad;
                    yaxis = 'Axial Diffusivity';
                    
                case 4
                    Y  = Val{id}.TractProfile(portion).vals.rd;
                    yaxis = 'Radial Diffusivity';
            end
            plot(X,Y,'color',c(id,:));
        end
        legend('JMD','LHON','Ctl')
        ylabel(yaxis,'fontName','Times','fontSize',14);
        title(sprintf('%s %s ROR',vals{val},portions{portion-3}));
        
        hold off;
        
        %% save
        cd /biac4/wandell/biac3/wandell7/shumpei/matlab/git/LHON/3RP/Manualy_divided3portion(Core_Vent_Dor)_plot
        print(gcf, '-dpng',sprintf('%s_%s_ROR_3Portion.png',vals{val},portions{portion-3}))
        close all
    end
end