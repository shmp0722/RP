function  OpticChiasm_diffusivities
% Calculate number of voxels in Optic tract for LHON, CRD, and normal
% subjects.
%

% Set directory
baseDir = '/biac4/wandell/biac2/wandell/data/DWI-Tamagawa-Japan';

subjectDir =  {...
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
    'JMD-Ctl-SO-20130726-DWI'};


%% argument checking
% %Set directory structure
%
% cd /biac4/wandell/biac2/wandell/data/DWI-Tamagawa-Japan/AFQ_results/OpticChiasm_diffusivities
% load vals

%% Run the fiber properties functions
% subject loop
for i=1:numel(subjectDir)
    cur_sub = dir(fullfile(baseDir,[subjectDir{i} '*']));
    subDir   = fullfile(baseDir,cur_sub.name);
    dt6Dir   = fullfile(subDir,'dwi_2nd');
    fiberDir = fullfile(dt6Dir,'/fibers/conTrack/OT_5K');
    roiDir   = fullfile(subDir,'dwi_2nd','ROIs');
    cd(roiDir)
    dt = dtiLoadDt6(fullfile(dt6Dir,'dt6.mat'));
    
    fprintf('\nProcessing %s\n', subDir);
    roi = 'Optic-Chiasm.mat';
    
    % load LGN roi
    Roi = dtiReadRoi(roi);
    
    vals(i).volume = size(Roi.coords,1);
    vals(i).name = Roi.name;
    
    % The rest of the computation does not require remembering which node
    % belongd to which fiber.
    [val1,val2,val3,val4,val5,val6] = dtiGetValFromTensors(dt.dt6, Roi.coords, inv(dt.xformToAcpc),'dt6','nearest');
    dt6 = [val1,val2,val3,val4,val5,val6];
    
    % Clean the data in two ways.
    % Some fibers extend a little beyond the brain mask. Remove those points by
    % exploiting the fact that the tensor values out there are exactly zero.
    dt6 = dt6(~all(dt6==0,2),:);
    
    % There shouldn't be any nans, but let's make sure:
    dt6Nans = any(isnan(dt6));
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
    
    vals(i).FA =fa;
    vals(i).MD =md;
    vals(i).AD =ad;
    vals(i).RD =rd;
    
    clear fa;
    clear md;
    clear ad;
    clear rd;
end



% cd('/biac4/wandell/biac2/wandell/data/DWI-Tamagawa-Japan/AFQ_results/OpticChiasm_diffusivities');
% 
% save vals vals

%% calculate stats

% Lt-LGN4
JMD.FA    =   vertcat(vals(1:4).FA);
JMD.MD    =   vertcat(vals(1:4).MD);
JMD.AD    =   vertcat(vals(1:4).AD);
JMD.RD    =   vertcat(vals(1:4).RD);

CRD.FA  =   vertcat( vals(5:9).FA);
CRD.MD  =   vertcat( vals(5:9).MD);
CRD.AD  =   vertcat( vals(5:9).AD);
CRD.RD  =   vertcat( vals(5:9).RD);

LHON.FA  =   vertcat( vals(10:15).FA);
LHON.MD  =   vertcat( vals(10:15).MD);
LHON.AD  =   vertcat( vals(10:15).AD);
LHON.RD  =   vertcat( vals(10:15).RD);

Ctl.FA  =   vertcat( vals(16:23).FA);
Ctl.MD  =   vertcat( vals(16:23).MD);
Ctl.AD  =   vertcat( vals(16:23).AD);
Ctl.RD  =   vertcat( vals(16:23).RD);

% FA
JMDmean.FA =  mean(vertcat(JMD.FA));
JMDmin.FA  =  min(vertcat(JMD.FA));
JMDmax.FA  =  max(vertcat(JMD.FA));
JMDsd.FA   =  std(vertcat(JMD.FA));
JMDse.FA   =  JMDsd.FA/sqrt(length(JMDsd.FA));
JMDquantil.FA = quantile(vertcat(JMD.FA),[0.25, 0.5, 0.75]);

CRDmean.FA =  mean(vertcat( vals(5:9).FA));
CRDmin.FA  =  min(vertcat( vals(5:9).FA));
CRDmax.FA  =  max(vertcat( vals(5:9).FA));
CRDsd.FA   =  std(vertcat( vals(5:9).FA));
CRDse.FA   =  JMDsd.FA/sqrt(length(CRDsd.FA));
CRDquantil.FA = quantile(vertcat( vals(5:9).FA),[0.25, 0.5, 0.75]);

LHONmean.FA =  mean(vertcat( vals(10:15).FA));
LHONmin.FA  =  min(vertcat( vals(10:15).FA));
LHONmax.FA  =  max(vertcat( vals(10:15).FA));
LHONsd.FA   =  std(vertcat( vals(10:15).FA));
LHONse.FA   =  JMDsd.FA/sqrt(length(LHONsd.FA));
LHONquantil.FA = quantile(vertcat( vals(10:15).FA),[0.25, 0.5, 0.75]);

Ctlmean.FA =  mean(vertcat( vals(16:23).FA));
Ctlmin.FA  =  min(vertcat( vals(16:23).FA));
Ctlmax.FA  =  max(vertcat( vals(16:23).FA));
Ctlsd.FA   =  std(vertcat( vals(16:23).FA));
Ctlse.FA   =  JMDsd.FA/sqrt(length(Ctlsd.FA));
Ctlquantil.FA = quantile(vertcat( vals(16:23).FA),[0.25, 0.5, 0.75]);

% MD
JMDmean.MD =  mean(vertcat(JMD.MD));
JMDmin.MD  =  min(vertcat(JMD.MD));
JMDmax.MD  =  max(vertcat(JMD.MD));
JMDsd.MD   =  std(vertcat(JMD.MD));
JMDse.MD   =  JMDsd.MD/sqrt(length(JMDsd.MD));
JMDquantil.MD = quantile(vertcat(JMD.MD),[0.25, 0.5, 0.75]);

CRDmean.MD =  mean(vertcat( vals(5:9).MD));
CRDmin.MD  =  min(vertcat( vals(5:9).MD));
CRDmax.MD  =  max(vertcat( vals(5:9).MD));
CRDsd.MD   =  std(vertcat( vals(5:9).MD));
CRDse.MD   =  JMDsd.MD/sqrt(length(CRDsd.MD));
CRDquantil.MD = quantile(vertcat( vals(5:9).MD),[0.25, 0.5, 0.75]);

LHONmean.MD =  mean(vertcat( vals(10:15).MD));
LHONmin.MD  =  min(vertcat( vals(10:15).MD));
LHONmax.MD  =  max(vertcat( vals(10:15).MD));
LHONsd.MD   =  std(vertcat( vals(10:15).MD));
LHONse.MD   =  JMDsd.MD/sqrt(length(LHONsd.MD));
LHONquantil.MD = quantile(vertcat( vals(10:15).MD),[0.25, 0.5, 0.75]);

Ctlmean.MD =  mean(vertcat( vals(16:23).MD));
Ctlmin.MD  =  min(vertcat( vals(16:23).MD));
Ctlmax.MD  =  max(vertcat( vals(16:23).MD));
Ctlsd.MD   =  std(vertcat( vals(16:23).MD));
Ctlse.MD   =  JMDsd.MD/sqrt(length(Ctlsd.MD));
Ctlquantil.MD = quantile(vertcat( vals(16:23).MD),[0.25, 0.5, 0.75]);

% AD
JMDmean.AD =  mean(vertcat(JMD.AD));
JMDmin.AD  =  min(vertcat(JMD.AD));
JMDmax.AD  =  max(vertcat(JMD.AD));
JMDsd.AD   =  std(vertcat(JMD.AD));
JMDse.AD   =  JMDsd.AD/sqrt(length(JMDsd.AD));
JMDquantil.AD = quantile(vertcat(JMD.AD),[0.25, 0.5, 0.75]);

CRDmean.AD =  mean(vertcat( vals(5:9).AD));
CRDmin.AD  =  min(vertcat( vals(5:9).AD));
CRDmax.AD  =  max(vertcat( vals(5:9).AD));
CRDsd.AD   =  std(vertcat( vals(5:9).AD));
CRDse.AD   =  JMDsd.AD/sqrt(length(CRDsd.AD));
CRDquantil.AD = quantile(vertcat( vals(5:9).AD),[0.25, 0.5, 0.75]);

LHONmean.AD =  mean(vertcat( vals(10:15).AD));
LHONmin.AD  =  min(vertcat( vals(10:15).AD));
LHONmax.AD  =  max(vertcat( vals(10:15).AD));
LHONsd.AD   =  std(vertcat( vals(10:15).AD));
LHONse.AD   =  JMDsd.AD/sqrt(length(LHONsd.AD));
LHONquantil.AD = quantile(vertcat( vals(10:15).AD),[0.25, 0.5, 0.75]);

Ctlmean.AD =  mean(vertcat( vals(16:23).AD));
Ctlmin.AD  =  min(vertcat( vals(16:23).AD));
Ctlmax.AD  =  max(vertcat( vals(16:23).AD));
Ctlsd.AD   =  std(vertcat( vals(16:23).AD));
Ctlse.AD   =  JMDsd.AD/sqrt(length(Ctlsd.AD));
Ctlquantil.AD = quantile(vertcat( vals(16:23).AD),[0.25, 0.5, 0.75]);

% RD
JMDmean.RD =  mean(vertcat(JMD.RD));
JMDmin.RD  =  min(vertcat(JMD.RD));
JMDmax.RD  =  max(vertcat(JMD.RD));
JMDsd.RD   =  std(vertcat(JMD.RD));
JMDse.RD   =  JMDsd.RD/sqrt(length(JMDsd.RD));
JMDquantil.RD = quantile(vertcat(JMD.RD),[0.25, 0.5, 0.75]);

CRDmean.RD =  mean(vertcat( vals(5:9).RD));
CRDmin.RD  =  min(vertcat( vals(5:9).RD));
CRDmax.RD  =  max(vertcat( vals(5:9).RD));
CRDsd.RD   =  std(vertcat( vals(5:9).RD));
CRDse.RD   =  JMDsd.RD/sqrt(length(CRDsd.RD));
CRDquantil.RD = quantile(vertcat( vals(5:9).RD),[0.25, 0.5, 0.75]);

LHONmean.RD =  mean(vertcat( vals(10:15).RD));
LHONmin.RD  =  min(vertcat( vals(10:15).RD));
LHONmax.RD  =  max(vertcat( vals(10:15).RD));
LHONsd.RD   =  std(vertcat( vals(10:15).RD));
LHONse.RD   =  JMDsd.RD/sqrt(length(LHONsd.RD));
LHONquantil.RD = quantile(vertcat( vals(10:15).RD),[0.25, 0.5, 0.75]);

Ctlmean.RD =  mean(vertcat( vals(16:23).RD));
Ctlmin.RD  =  min(vertcat( vals(16:23).RD));
Ctlmax.RD  =  max(vertcat( vals(16:23).RD));
Ctlsd.RD   =  std(vertcat( vals(16:23).RD));
Ctlse.RD   =  JMDsd.RD/sqrt(length(Ctlsd.RD));
Ctlquantil.RD = quantile(vertcat( vals(16:23).RD),[0.25, 0.5, 0.75]);



%% scatter plot FA
figure; hold on; 
% boxplot([CRD.FA],[LHON.FA],2)

scatter(1:3,[CRDmean.FA,LHONmean.FA,Ctlmean.FA]);

errorbar2(1:3,[CRDmean.FA,LHONmean.FA,Ctlmean.FA],[CRDse.FA,LHONse.FA,Ctlse.FA],1)
axis([0,4,0,0.3])

xlabel('Subject groups','fontName','Times','fontSize',12);
ylabel('Fractional Anisotropy','fontName','Times','fontSize',12);
title('Optic Chiasm FA','fontName','Times','fontSize',14);
hold off;

%% save the figure in .eps
% Figure ? 1024x768 ?eps???
% "fig.eps" ??????
% cd '/biac4/wandell/biac2/wandell/data/DWI-Tamagawa-Japan/AFQ_results/OpticChiasm_diffusivities/figures'
cd '/biac4/wandell/biac3/wandell7/shumpei/matlab/git/LHON/OpticChiasm_diffusivities';
width  = 410;
height =307;
set(gcf,'PaperPositionMode','auto')
pos=get(gcf,'Position');
pos(3)=width-1; %?????1px???????
pos(4)=height;
set(gcf,'Position',pos);
print('-r0','-deps','OpticChiasm FA 3groups.eps');
%% scatter plot MD
figure; hold on; 
% boxplot([CRD.FA],[LHON.FA],2)

scatter(1:3,[CRDmean.MD,LHONmean.MD,Ctlmean.MD]);
errorbar2(1:3,[CRDmean.MD,LHONmean.MD,Ctlmean.MD],[CRDse.MD,LHONse.MD,Ctlse.MD],1)
axis([0, 4, 0.7 , 2.6])

xlabel('Subject groups','fontName','Times','fontSize',12);
ylabel('Mean Diffusivity','fontName','Times','fontSize',12);
title('Optic Chiasm MD','fontName','Times','fontSize',14);
hold off;

%% save the figure in .eps
% Figure ? 1024x768 ?eps???
% "fig.eps" ??????
% cd '/biac4/wandell/biac2/wandell/data/DWI-Tamagawa-Japan/AFQ_results/OpticChiasm_diffusivities/figures'

width  = 410;
height =307;
set(gcf,'PaperPositionMode','auto')
pos=get(gcf,'Position');
pos(3)=width-1; %?????1px???????
pos(4)=height;
set(gcf,'Position',pos);
print('-r0','-deps','OpticChiasm MD 3groups.eps');

%% scatter plot AD
figure; hold on; 
% boxplot([CRD.FA],[LHON.FA],2)

scatter(1:3,[CRDmean.AD,LHONmean.AD,Ctlmean.AD]);
errorbar2(1:3,[CRDmean.AD,LHONmean.AD,Ctlmean.AD],[CRDse.AD,LHONse.AD,Ctlse.AD],1)
axis([0, 4, 0.5 ,3])

xlabel('Subject groups','fontName','Times','fontSize',12);
ylabel('Axial Diffusivity','fontName','Times','fontSize',12);
title('Optic Chiasm AD','fontName','Times','fontSize',14);
hold off;

%% save the figure in .eps
% Figure ? 1024x768 ?eps???
% "fig.eps" ??????
% cd '/biac4/wandell/biac2/wandell/data/DWI-Tamagawa-Japan/AFQ_results/OpticChiasm_diffusivities/figures'
width  = 410;
height =307;
set(gcf,'PaperPositionMode','auto')
pos=get(gcf,'Position');
pos(3)=width-1; %?????1px???????
pos(4)=height;
set(gcf,'Position',pos);
print('-r0','-deps','OpticChiasm AD 3groups.eps');
%% scatter plot RD
figure; hold on; 
% boxplot([CRD.FA],[LHON.FA],2)

scatter(1:3,[CRDmean.RD,LHONmean.RD,Ctlmean.RD]);
errorbar2(1:3,[CRDmean.RD,LHONmean.RD,Ctlmean.RD],[CRDse.RD,LHONse.RD,Ctlse.RD],1)
axis([0, 4, 0.5 ,2.4])

xlabel('Subject groups','fontName','Times','fontSize',12);
ylabel('Radial Diffusivity','fontName','Times','fontSize',12);
title('Optic Chiasm RD','fontName','Times','fontSize',14);
hold off;

%% save the figure in .eps
% Figure ? 1024x768 ?eps???
% "fig.eps" ??????
% cd '/biac4/wandell/biac2/wandell/data/DWI-Tamagawa-Japan/AFQ_results/OpticChiasm_diffusivities/figures'
width  = 410;
height =307;
set(gcf,'PaperPositionMode','auto')
pos=get(gcf,'Position');
pos(3)=width-1; %?????1px???????
pos(4)=height;
set(gcf,'Position',pos);
print('-r0','-deps','OpticChiasm RD 3groups.eps');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% L-LGN group comparison 4groups
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% FA
figure ; hold on;
boxplot(JMD.FA,'notch','on');
boxplot(LHON_L.FA)
boxplot([JMDmean.FA,CRDmean.FA,LHONmean.FA,Ctlmean.FA],'notch','on')
% boxplot([JMDmean.FA,CRDmean.FA,LHONmean.FA,Ctlmean.FA],'notch','on')



xlabel('Subject groups','fontName','Times','fontSize',12);
ylabel('Fractional Anisotropy','fontName','Times','fontSize',12);
title('Lt-LGN FA','fontName','Times','fontSize',14);
hold off;

%% save the figure in .eps
% Figure ? 1024x768 ?eps???
% "fig.eps" ??????
width  = 410;
height =307;
set(gcf,'PaperPositionMode','auto')
pos=get(gcf,'Position');
pos(3)=width-1; %?????1px???????
pos(4)=height;
set(gcf,'Position',pos);
print('-r0','-deps','Lt-LGN FA 4groups.eps');

%% MD
figure ; hold on;

boxplot([JMDmean.MD,CRDmean.MD,LHONmean.MD,Ctlmean.MD],'notch','on')

xlabel('Subject groups','fontName','Times','fontSize',12);
ylabel('Mean Diffusivity','fontName','Times','fontSize',12);
title('Lt-LGN MD','fontName','Times','fontSize',14);
hold off;AD

%% save the figure in .eps
% Figure ? 1024x768 ?eps???
% "fig.eps" ??????
width  = 410;
height =307;
set(gcf,'PaperPositionMode','auto')
pos=get(gcf,'Position');
pos(3)=width-1; %?????1px???????
pos(4)=height;
set(gcf,'Position',pos);
print('-r0','-deps','Lt-LGN MD 4groups.eps');

%% AD
figure ; hold on;

boxplot([JMDmean.AD,CRDmean.AD,LHONmean.AD,Ctlmean.AD],'notch','on')

xlabel('Subject groups','fontName','Times','fontSize',12);
ylabel('Axial Diffusivity','fontName','Times','fontSize',12);
title('Lt-LGN AD','fontName','Times','fontSize',14);
hold off;

%% save the figure in .eps
% Figure ? 1024x768 ?eps???
% "fig.eps" ??????
width  = 410;
height =307;
set(gcf,'PaperPositionMode','auto')
pos=get(gcf,'Position');
pos(3)=width-1; %?????1px???????
pos(4)=height;
set(gcf,'Position',pos);
print('-r0','-deps','Lt-LGN AD 4groups.eps');

%% RD
figure ; hold on;

boxplot([JMDmean.RD,CRDmean.RD,LHONmean.RD,Ctlmean.RD],'notch','on')

xlabel('Subject groups','fontName','Times','fontSize',12);
ylabel('Radial Diffusivity','fontName','Times','fontSize',12);
title('Lt-LGN RD','fontName','Times','fontSize',14);
hold off;

%% save the figure in .eps
% Figure ? 1024x768 ?eps???
% "fig.eps" ??????
width  = 410;
height =307;
set(gcf,'PaperPositionMode','auto')
pos=get(gcf,'Position');
pos(3)=width-1; %?????1px???????
pos(4)=height;
set(gcf,'Position',pos);
print('-r0','-deps','Lt-LGN RD 4groups.eps');

%% R-LGN group comparison
%% FA
figure ; hold on;

boxplot([JMDmeanR.FA,CRDmeanR.FA,RHONmeanR.FA,CtlmeanR.FA],'notch','on')
% boxplot([JMDmeanR.FA,CRDmeanR.FA,RHONmeanR.FA,CtlmeanR.FA],'notch','on')



xlabel('Subject groups','fontName','Times','fontSize',12);
ylabel('Fractional Anisotropy','fontName','Times','fontSize',12);
title('Rt-LGN FA','fontName','Times','fontSize',14);
hold off;

%% save the figure in .eps
% Figure ? 1024x768 ?eps???
% "fig.eps" ??????
width  = 410;
height =307;
set(gcf,'PaperPositionMode','auto')
pos=get(gcf,'Position');
pos(3)=width-1; %?????1px???????
pos(4)=height;
set(gcf,'Position',pos);
print('-r0','-deps','Rt-LGN FA 4groups.eps');

%% MD
figure ; hold on;

boxplot([JMDmeanR.MD,CRDmeanR.MD,RHONmeanR.MD,CtlmeanR.MD],'notch','on')

xlabel('Subject groups','fontName','Times','fontSize',12);
ylabel('Mean Diffusivity','fontName','Times','fontSize',12);
title('Rt-LGN MD','fontName','Times','fontSize',14);
hold off;

%% save the figure in .eps
% Figure ? 1024x768 ?eps???
% "fig.eps" ??????
width  = 410;
height =307;
set(gcf,'PaperPositionMode','auto')
pos=get(gcf,'Position');
pos(3)=width-1; %?????1px???????
pos(4)=height;
set(gcf,'Position',pos);
print('-r0','-deps','Rt-LGN MD 4groups.eps');

%% AD
figure ; hold on;

boxplot([JMDmeanR.AD,CRDmeanR.AD,RHONmeanR.AD,CtlmeanR.AD],'notch','on')

xlabel('Subject groups','fontName','Times','fontSize',12);
ylabel('Axial Diffusivity','fontName','Times','fontSize',12);
title('Rt-LGN AD','fontName','Times','fontSize',14);
hold off;

%% save the figure in .eps
% Figure ? 1024x768 ?eps???
% "fig.eps" ??????
width  = 410;
height =307;
set(gcf,'PaperPositionMode','auto')
pos=get(gcf,'Position');
pos(3)=width-1; %?????1px???????
pos(4)=height;
set(gcf,'Position',pos);
print('-r0','-deps','Rt-LGN AD 4groups.eps');

%% RD
figure ; hold on;

boxplot([JMDmeanR.RD,CRDmeanR.RD,RHONmeanR.RD,CtlmeanR.RD],'notch','on')

xlabel('Subject groups','fontName','Times','fontSize',12);
ylabel('Radial Diffusivity','fontName','Times','fontSize',12);
title('Rt-LGN RD','fontName','Times','fontSize',14);
hold off;

%% save the figure in .eps
% Figure ? 1024x768 ?eps???
% "fig.eps" ??????
width  = 410;
height =307;
set(gcf,'PaperPositionMode','auto')
pos=get(gcf,'Position');
pos(3)=width-1; %?????1px???????
pos(4)=height;
set(gcf,'Position',pos);
print('-r0','-deps','Rt-LGN RD 4groups.eps');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 3groups, L-LGN group comparison 3groups
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% FA
figure ; hold on;

boxplot([CRDmean.FA,LHONmean.FA,Ctlmean.FA],'notch','on')
% boxplot([JMDmean.FA,CRDmean.FA,LHONmean.FA,Ctlmean.FA],'notch','on')



xlabel('Subject groups','fontName','Times','fontSize',12);
ylabel('Fractional Anisotropy','fontName','Times','fontSize',12);
title('Lt-LGN FA','fontName','Times','fontSize',14);
hold off;

%% save the figure in .eps
% Figure ? 1024x768 ?eps???
% "fig.eps" ??????
width  = 410;
height =307;
set(gcf,'PaperPositionMode','auto')
pos=get(gcf,'Position');
pos(3)=width-1; %?????1px???????
pos(4)=height;
set(gcf,'Position',pos);
print('-r0','-deps','Lt-LGN FA 3groups.eps');

%% MD
figure ; hold on;

boxplot([CRDmean.MD,LHONmean.MD,Ctlmean.MD],'notch','on')

xlabel('Subject groups','fontName','Times','fontSize',12);
ylabel('Mean Diffusivity','fontName','Times','fontSize',12);
title('Lt-LGN MD','fontName','Times','fontSize',14);
hold off;

%% save the figure in .eps
% Figure ? 1024x768 ?eps???
% "fig.eps" ??????
width  = 410;
height =307;
set(gcf,'PaperPositionMode','auto')
pos=get(gcf,'Position');
pos(3)=width-1; %?????1px???????
pos(4)=height;
set(gcf,'Position',pos);
print('-r0','-deps','Lt-LGN MD 3groups.eps');

%% AD
figure ; hold on;

boxplot([CRDmean.AD,LHONmean.AD,Ctlmean.AD],'notch','on')

xlabel('Subject groups','fontName','Times','fontSize',12);
ylabel('Axial Diffusivity','fontName','Times','fontSize',12);
title('Lt-LGN AD','fontName','Times','fontSize',14);
hold off;

%% save the figure in .eps
% Figure ? 1024x768 ?eps???
% "fig.eps" ??????
width  = 410;
height =307;
set(gcf,'PaperPositionMode','auto')
pos=get(gcf,'Position');
pos(3)=width-1; %?????1px???????
pos(4)=height;
set(gcf,'Position',pos);
print('-r0','-deps','Lt-LGN AD 3groups.eps');

%% RD
figure ; hold on;

boxplot([CRDmean.RD,LHONmean.RD,Ctlmean.RD],'notch','on')

xlabel('Subject groups','fontName','Times','fontSize',12);
ylabel('Radial Diffusivity','fontName','Times','fontSize',12);
title('Lt-LGN RD','fontName','Times','fontSize',14);
hold off;

%% save the figure in .eps
% Figure ? 1024x768 ?eps???
% "fig.eps" ??????
width  = 410;
height =307;
set(gcf,'PaperPositionMode','auto')
pos=get(gcf,'Position');
pos(3)=width-1; %?????1px???????
pos(4)=height;
set(gcf,'Position',pos);
print('-r0','-deps','Lt-LGN RD 3groups.eps');

%% R-LGN 3 group comparison
%% FA
figure ; hold on;

boxplot([CRDmeanR.FA,LHONmeanR.FA,CtlmeanR.FA],'notch','on')
% boxplot([JMDmeanR.FA,CRDmeanR.FA,RHONmeanR.FA,CtlmeanR.FA],'notch','on')



xlabel('Subject groups','fontName','Times','fontSize',12);
ylabel('Fractional Anisotropy','fontName','Times','fontSize',12);
title('Rt-LGN FA','fontName','Times','fontSize',14);
hold off;

%% save the figure in .eps
% Figure ? 1024x768 ?eps???
% "fig.eps" ??????
width  = 410;
height =307;
set(gcf,'PaperPositionMode','auto')
pos=get(gcf,'Position');
pos(3)=width-1; %?????1px???????
pos(4)=height;
set(gcf,'Position',pos);
print('-r0','-deps','Rt-LGN FA 3groups.eps');

%% MD
figure ; hold on;

boxplot([CRDmeanR.MD,LHONmeanR.MD,CtlmeanR.MD],'notch','on')

xlabel('Subject groups','fontName','Times','fontSize',12);
ylabel('Mean Diffusivity','fontName','Times','fontSize',12);
title('Rt-LGN MD','fontName','Times','fontSize',14);
hold off;

%% save the figure in .eps
% Figure ? 1024x768 ?eps???
% "fig.eps" ??????
width  = 410;
height =307;
set(gcf,'PaperPositionMode','auto')
pos=get(gcf,'Position');
pos(3)=width-1; %?????1px???????
pos(4)=height;
set(gcf,'Position',pos);
print('-r0','-deps','Rt-LGN MD 3groups.eps');

%% AD
figure ; hold on;

boxplot([CRDmeanR.AD,LHONmeanR.AD,CtlmeanR.AD],'notch','on')

xlabel('Subject groups','fontName','Times','fontSize',12);
ylabel('Axial Diffusivity','fontName','Times','fontSize',12);
title('Rt-LGN AD','fontName','Times','fontSize',14);
hold off;

%% save the figure in .eps
% Figure ? 1024x768 ?eps???
% "fig.eps" ??????
width  = 410;
height =307;
set(gcf,'PaperPositionMode','auto')
pos=get(gcf,'Position');
pos(3)=width-1; %?????1px???????
pos(4)=height;
set(gcf,'Position',pos);
print('-r0','-deps','Rt-LGN AD 3groups.eps');

%% RD
figure ; hold on;

boxplot([CRDmeanR.RD,LHONmeanR.RD,CtlmeanR.RD],'notch','on')

xlabel('Subject groups','fontName','Times','fontSize',12);
ylabel('Radial Diffusivity','fontName','Times','fontSize',12);
title('Rt-LGN RD','fontName','Times','fontSize',14);
hold off;

%% save the figure in .eps
% Figure ? 1024x768 ?eps???
% "fig.eps" ??????
width  = 410;
height =307;
set(gcf,'PaperPositionMode','auto')
pos=get(gcf,'Position');
pos(3)=width-1; %?????1px???????
pos(4)=height;
set(gcf,'Position',pos);
print('-r0','-deps','Rt-LGN RD 3groups.eps');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% total
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% L-LGN FA
figure; hold on;


JMD =  boxplot(vertcat(vals(1:4).FA));

% legend('JMD', 'LHON', 'Ctl');
xlabel('Subject','fontName','Times','fontSize',12);
ylabel('Fractional Anisotropy','fontName','Times','fontSize',12);
title('Lt-LGN JMD','fontName','Times','fontSize',14);
hold off;


%%
figure; hold on;

CRD =  boxplot(vertcat( vals(5:9).FA));
xlabel('Subject','fontName','Times','fontSize',12);
ylabel('Fractional Anisotropy','fontName','Times','fontSize',12);
title('Lt-LGN CRD','fontName','Times','fontSize',14);
hold off;

%%
figure; hold on;

LHON =  boxplot(vertcat( vals(10:15).FA));
xlabel('Subject','fontName','Times','fontSize',12);
ylabel('Fractional Anisotropy','fontName','Times','fontSize',12);
title('Lt-LGN LHON','fontName','Times','fontSize',14);
hold off;

%%
figure; hold on;

Ctl = boxplot(vertcat( vals(16:23).FA));
xlabel('Subject','fontName','Times','fontSize',12);
ylabel('Fractional Anisotropy','fontName','Times','fontSize',12);
title('Lt-LGN Ctl','fontName','Times','fontSize',14);
hold off;

%% All

% FA
figure; hold on;

All = boxplot(vertcat(vals(:).FA));
xlabel('Subject','fontName','Times','fontSize',12);
ylabel('Fractional Anisotropy','fontName','Times','fontSize',12);
title('Lt-LGN All','fontName','Times','fontSize',14);
hold off;

figure; hold on;

JMD = mean(vertcat(vals(1:5).FA));

%% save the figure in .eps
% Figure ? 1024x768 ?eps???
% "fig.eps" ??????
width  = 410;
height =307;
set(gcf,'PaperPositionMode','auto')
pos=get(gcf,'Position');
pos(3)=width-1; %?????1px???????
pos(4)=height;
set(gcf,'Position',pos);
print('-r0','-deps','Lt-LGN FA All Subject.eps');

%% MD
figure; hold on;
All = boxplot(vertcat(vals(:).MD));
xlabel('Subject','fontName','Times','fontSize',12);
ylabel('MD','fontName','Times','fontSize',12);
title('Lt-LGN All','fontName','Times','fontSize',14);
hold off;

%% save the figure in .eps
% Figure ? 1024x768 ?eps???
% "fig.eps" ??????
width  = 410;
height =307;
set(gcf,'PaperPositionMode','auto')
pos=get(gcf,'Position');
pos(3)=width-1; %?????1px???????
pos(4)=height;
set(gcf,'Position',pos);
print('-r0','-deps','Lt-LGN MD All Subject.eps');

%% AD
figure; hold on;
All = boxplot(vertcat( vals(:).AD));
xlabel('Subject','fontName','Times','fontSize',12);
ylabel('AD','fontName','Times','fontSize',12);
title('Lt-LGN All','fontName','Times','fontSize',14);
hold off;

%% save the figure in .eps
% Figure ? 1024x768 ?eps???
% "fig.eps" ??????
width  = 410;
height =307;
set(gcf,'PaperPositionMode','auto')
pos=get(gcf,'Position');
pos(3)=width-1; %?????1px???????
pos(4)=height;
set(gcf,'Position',pos);
print('-r0','-deps','Lt-LGN AD All Subject.eps');


%% RD
figure; hold on;
All = boxplot(vertcat( vals(:).RD));
xlabel('Subject','fontName','Times','fontSize',12);
ylabel('RD','fontName','Times','fontSize',12);
title('Lt-LGN All','fontName','Times','fontSize',14);
hold off;


%% save the figure in .eps
% Figure ? 1024x768 ?eps???
% "fig.eps" ??????
width  = 410;
height =307;
set(gcf,'PaperPositionMode','auto')
pos=get(gcf,'Position');
pos(3)=width-1; %?????1px???????
pos(4)=height;
set(gcf,'Position',pos);
print('-r0','-deps','Lt-LGN RD All Subject.eps');
% figure; hold on;
% boxplot(vertcat(vertcat(vals(1:4).FA), vertcat( vals(5:9).FA), vertcat(vals(10:15).FA),...
%     vertcat(vals(16:23).FA)));

%% Lt-LGN group comparison

boxplot([JMDmean,CRDmean,LHONmean,Ctlmean]);


%% R-LGN FA
figure; hold on;


JMD =  boxplot(vertcat(vals(1:4,2).FA));

% legend('JMD', 'LHON', 'Ctl');
xlabel('Subject','fontName','Times','fontSize',12);
ylabel('Fractional Anisotropy','fontName','Times','fontSize',12);
title('Rt-LGN JMD','fontName','Times','fontSize',14);
hold off;


%
figure; hold on;

CRD =  boxplot(vertcat( vals(5:9,2).FA));
xlabel('Subject','fontName','Times','fontSize',12);
ylabel('Fractional Anisotropy','fontName','Times','fontSize',12);
title('Rt-LGN CRD','fontName','Times','fontSize',14);
hold off;

% LHON subjects
figure; hold on;

LHON =  boxplot(vertcat( vals(10:15,2).FA));
xlabel('Subject','fontName','Times','fontSize',12);
ylabel('Fractional Anisotropy','fontName','Times','fontSize',12);
title('Rt-LGN LHON','fontName','Times','fontSize',14);
hold off;

% Ctl
figure; hold on;

Ctl = boxplot(vertcat( vals(16:23,2).FA));
xlabel('Subject','fontName','Times','fontSize',12);
ylabel('Fractional Anisotropy','fontName','Times','fontSize',12);
title('Rt-LGN Ctl','fontName','Times','fontSize',14);
hold off;

%%%%%%%%%%%%%%%%%%%
%% All Rt-LGN4
%%%%%%%%%%%%%%%%%%%


figure; hold on;

All = boxplot(vertcat( vals(:,2).FA));%,'plotstyle','compact');
xlabel('Subject','fontName','Times','fontSize',12);
ylabel('Fractional Anisotropy','fontName','Times','fontSize',12);
title('Rt-LGN All','fontName','Times','fontSize',14);
hold off;

%% save the figure in .eps
% Figure ? 1024x768 ?eps???
% "fig.eps" ??????
width  = 410;
height =307;
set(gcf,'PaperPositionMode','auto')
pos=get(gcf,'Position');
pos(3)=width-1; %?????1px???????
pos(4)=height;
set(gcf,'Position',pos);
print('-r0','-deps','Rt-LGN FA All Subject.eps');

%% MD
figure; hold on;

All = boxplot(vertcat( vals(:,2).MD));%,'plotstyle','compact');
xlabel('Subject','fontName','Times','fontSize',12);
ylabel('Mean Diffusivity','fontName','Times','fontSize',12);
title('Rt-LGN All','fontName','Times','fontSize',14);
hold off;

%% save the figure in .eps
% Figure ? 1024x768 ?eps???
% "fig.eps" ??????
width  = 410;
height =307;
set(gcf,'PaperPositionMode','auto')
pos=get(gcf,'Position');
pos(3)=width-1; %?????1px???????
pos(4)=height;
set(gcf,'Position',pos);
print('-r0','-deps','Rt-LGN MD All Subject.eps');

%% AD
figure; hold on;

All = boxplot(vertcat( vals(:,2).AD));%,'plotstyle','compact');
xlabel('Subject','fontName','Times','fontSize',12);
ylabel('Axial Diffusivity','fontName','Times','fontSize',12);
title('Rt-LGN All','fontName','Times','fontSize',14);
hold off;

%% save the figure in .eps
% Figure ? 1024x768 ?eps???
% "fig.eps" ??????
width  = 410;
height =307;
set(gcf,'PaperPositionMode','auto')
pos=get(gcf,'Position');
pos(3)=width-1; %?????1px???????
pos(4)=height;
set(gcf,'Position',pos);
print('-r0','-deps','Rt-LGN AD All Subject.eps');

%% RD
figure; hold on;

All = boxplot(vertcat( vals(:,2).RD));%,'plotstyle','compact');
xlabel('Subject','fontName','Times','fontSize',12);
ylabel('Radial Diffusivity','fontName','Times','fontSize',12);
title('Rt-LGN All','fontName','Times','fontSize',14);
hold off;


%% save the figure in .eps
% Figure ? 1024x768 ?eps???
% "fig.eps" ??????
width  = 410;
height =307;
set(gcf,'PaperPositionMode','auto')
pos=get(gcf,'Position');
pos(3)=width-1; %?????1px???????
pos(4)=height;
set(gcf,'Position',pos);
print('-r0','-deps','Rt-LGN RD All Subject.eps');

