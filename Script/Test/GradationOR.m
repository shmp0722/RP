function GradationOR
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
    'LHON6-SS-20131206-DWI'};


%% Load afq structure
cd /biac4/wandell/biac3/wandell7/shumpei/matlab/git/LHON/3RP
load 3RP_3SD_TractProfile.mat

%% classify all subjects intogroups
JMD = 1:4;
CRD = 5:9;
LHON = 10:15;
Ctl = 16:23;
RP = 24:26;

% disease = {'JMD','CRD',' LHON','Ctl','RP'};
% Disease = {JMD, CRD, LHON, Ctl, RP};

disease = {'JMD','CRD',' LHON','Ctl','RP'};
Disease = {JMD, CRD, LHON, Ctl, RP};

fgN ={'ROR1206_D4L4.pdb','LOR1206_D4L4.pdb','ROTD4L4_1206.pdb','LOTD4L4_1206.pdb'};



%% Calculate vals along the fibers and return TP structure
for i =1:length(subs)
    % define directory
    SubDir = fullfile(AFQdata,subs{i});
    fgDir  = fullfile(SubDir,'/dwi_2nd/fibers');
    %    cd /biac4/wandell/biac3/wandell7/shumpei/matlab/git/LHON/3RP
    
    for j =1:length(fgN)
        fgF{j} = fgRead(fullfile(fgDir,fgN{j}));
        
        fg_orig = fgF{j};
        
        % First classfy fibers according to length
        Lnorm     = AFQ_FiberLengthHist(fg_orig,[]);
        
        %     SD_m4 = Lnorm < -3 ;
        SD_m3 =  Lnorm < -2 ;
        SD_m2 =  Lnorm < -1 & Lnorm >= -2;
        SD_m1 =  Lnorm < 0 & Lnorm >= -1;
        SD_1p  = Lnorm < 1 & Lnorm >= 0;
        SD_2p  = Lnorm < 2 & Lnorm >= 1;
        SD_3p   = Lnorm >= 2;
        
        %% creat new fibers
        if sum(SD_m3) <5;fg_SDm3 =[];
        else
            fg_SDm3 = dtiNewFiberGroup('fg_SDm3','b',[],[],fg_orig.fibers(logical(SD_m3)));
        end;
        
        if sum(SD_m2) <5;fg_SDm2 =[];
        else
            fg_SDm2 = dtiNewFiberGroup('fg_SDm2','b',[],[],fg_orig.fibers(logical(SD_m2)));
        end;
        
        if sum(SD_m1) <5;fg_SDm1 =[];
        else
            fg_SDm1  = dtiNewFiberGroup('fg_SDm1','b',[],[],fg_orig.fibers(logical(SD_m1)));
        end;
        if sum(SD_1p) <5;fg_SD1 =[];
        else
            fg_SD1  = dtiNewFiberGroup('fg_SD1','b',[],[],fg_orig.fibers(logical(SD_1p)));
        end;
        
        if sum(SD_2p) <5;fg_SD2 =[];
        else
            fg_SD2  = dtiNewFiberGroup('fg_SD2','b',[],[],fg_orig.fibers(logical(SD_2p)));
        end;
        
        if sum(SD_3p) <5;fg_SD3 =[];
        else
            fg_SD3  = dtiNewFiberGroup('fg_SD3','b',[],[],fg_orig.fibers(logical(SD_3p)));
        end
        
        
        
        fgF_N = {fg_SDm3,fg_SDm2,fg_SDm1,fg_SD1,fg_SD2,fg_SD3};
        c = jet(6);
        
        figure; hold on;
        %% Render a figure
        
        % render fiber
        for i = 1 : length(fgF_N)
            AFQ_RenderFibers(fgF_N{i},'color',c(i,:),'newfig',0,'numfibers', 100)
        end
        
        % superinpose
        dt =  dtiLoadDt6(fullfile(AFQdata,subs{i},'dwi_2nd/dt6.mat'));
        t1 = niftiRead(dt.files.t1);
        AFQ_AddImageTo3dPlot(t1, [0, 0, -30]);
        % adjust view and give title
        
        camlight('headlight');
        axis image
        view(0,89)
        %% save figure
        cd /biac4/wandell/biac3/wandell7/shumpei/matlab/git/LHON/3RP/Figure3
        
        switch fibID
            case 1
                print(gcf, '-dpng',sprintf('OR_mandara_%s_OR%s.png',diffusivity,TractProfile{ii,j}{sdID}.name));
            case 3
                print(gcf, '-dpng',sprintf('OT_mandara_%s_OT%s.png',diffusivity,TractProfile{ii,j}{sdID}.name));
        end
        
    end
end
cd /biac4/wandell/biac3/wandell7/shumpei/matlab/git/LHON/3RP
%        close all;
return








