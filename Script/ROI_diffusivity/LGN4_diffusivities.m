function  LGN4_diffusivities
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
%Set directory structure

cd /biac4/wandell/biac2/wandell/data/DWI-Tamagawa-Japan/AFQ_results/LGN4_diffusivities
cd /Users/shumpei/Documents/MATLAB/git/LHON/LGN4_diffusivities
load LGN4_diffusivities.mat

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
    
    Ids = {'Lt-LGN4.mat'
        'Rt-LGN4.mat'};
    % Lh and Rh
    for ij = 1:2;
        
        % load LGN roi
       
        Roi = dtiReadRoi(Ids{ij});
        
        vals(i,ij).volume = size(Roi.coords,1);
        vals(i,ij).name = Roi.name;
        
        % The rest of the computation does not require remembering which node
        % belongd to which fiber.
        [val1,val2,val3,val4,val5,val6] = dtiGetValFromTensors(dt.dt6, Roi.coords, inv(dt.xformToAcpc),'dt6','nearest');
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
        
        vals(i,ij).FA =fa;
        vals(i,ij).MD =md;
        vals(i,ij).AD =ad;
        vals(i,ij).RD =rd;
        
        clear fa;
        clear md;
        clear ad;
        clear rd;
    end
end


cd /biac4/wandell/biac2/wandell/data/DWI-Tamagawa-Japan/AFQ_results/LGN4_diffusivities

save vals vals

%% calculate stats

% Lt-LGN4
 JMDmeanL.FA =  mean(horzcat( vals(1:4,1).FA),2);
 JMDminL.FA  =  min(horzcat( vals(1:4,1).FA),2);
 JMDmaxL.FA  =  max(horzcat( vals(1:4,1).FA),2);
 JMDsdL.FA   =  std(horzcat( vals(1:4,1).FA));
 JMDquantilL.FA = quantile(horzcat( vals(1:4,1).FA),[0.25, 0.5, 0.75]); 
 
 CRDmeanL.FA =  mean(horzcat( vals(5:9,1).FA),2);
 CRDminL.FA  =  min(horzcat( vals(5:9,1).FA),2);
 CRDmaxL.FA  =  max(horzcat( vals(5:9,1).FA),2);
 CRDsdL.FA   =  std(horzcat( vals(5:9,1).FA));
 CRDquantilL.FA = quantile(horzcat( vals(5:9,1).FA),[0.25, 0.5, 0.75]); 
 
 LHONmeanL.FA =  mean(horzcat( vals(10:15,1).FA),2);
 LHONminL.FA  =  min(horzcat( vals(10:15,1).FA),2);
 LHONmaxL.FA  =  max(horzcat( vals(10:15,1).FA),2);
 LHONsdL.FA   =  std(horzcat( vals(10:15,1).FA));
 LHONquantilL.FA = quantile(horzcat( vals(10:15,1).FA),[0.25, 0.5, 0.75]); 
 
 CtlmeanL.FA =  mean(horzcat( vals(16:23,1).FA),2);
 CtlminL.FA  =  min(horzcat( vals(16:23,1).FA),2);
 CtlmaxL.FA  =  max(horzcat( vals(16:23,1).FA),2);
 CtlsdL.FA   =  std(horzcat( vals(16:23,1).FA));
 CtlquantilL.FA = quantile(horzcat( vals(16:23,1).FA),[0.25, 0.5, 0.75]); 
 
 JMDmeanL.MD =  mean(horzcat( vals(1:4,1).MD),2);
 JMDminL.MD  =  min(horzcat( vals(1:4,1).MD),2);
 JMDmaxL.MD  =  max(horzcat( vals(1:4,1).MD),2);
 JMDsdL.MD   =  std(horzcat( vals(1:4,1).MD));
 JMDquantilL.MD = quantile(horzcat( vals(1:4,1).MD),[0.25, 0.5, 0.75]); 
 
 CRDmeanL.MD =  mean(horzcat( vals(5:9,1).MD),2);
 CRDminL.MD  =  min(horzcat( vals(5:9,1).MD),2);
 CRDmaxL.MD  =  max(horzcat( vals(5:9,1).MD),2);
 CRDsdL.MD   =  std(horzcat( vals(5:9,1).MD));
 CRDquantilL.MD = quantile(horzcat( vals(5:9,1).MD),[0.25, 0.5, 0.75]); 
 
 LHONmeanL.MD =  mean(horzcat( vals(10:15,1).MD),2);
 LHONminL.MD  =  min(horzcat( vals(10:15,1).MD),2);
 LHONmaxL.MD  =  max(horzcat( vals(10:15,1).MD),2);
 LHONsdL.MD   =  std(horzcat( vals(10:15,1).MD));
 LHONquantilL.MD = quantile(horzcat( vals(10:15,1).MD),[0.25, 0.5, 0.75]); 
 
 CtlmeanL.MD =  mean(horzcat( vals(16:23,1).MD),2);
 CtlminL.MD  =  min(horzcat( vals(16:23,1).MD),2);
 CtlmaxL.MD  =  max(horzcat( vals(16:23,1).MD),2);
 CtlsdL.MD   =  std(horzcat( vals(16:23,1).MD));
 CtlquantilL.MD = quantile(horzcat( vals(16:23,1).MD),[0.25, 0.5, 0.75]); 
 
 JMDmeanL.AD =  mean(horzcat( vals(1:4,1).AD),2);
 JMDminL.AD  =  min(horzcat( vals(1:4,1).AD),2);
 JMDmaxL.AD  =  max(horzcat( vals(1:4,1).AD),2);
 JMDsdL.AD   =  std(horzcat( vals(1:4,1).AD));
 JMDquantilL.AD = quantile(horzcat( vals(1:4,1).AD),[0.25, 0.5, 0.75]); 
 
 CRDmeanL.AD =  mean(horzcat( vals(5:9,1).AD),2);
 CRDminL.AD  =  min(horzcat( vals(5:9,1).AD),2);
 CRDmaxL.AD  =  max(horzcat( vals(5:9,1).AD),2);
 CRDsdL.AD   =  std(horzcat( vals(5:9,1).AD));
 CRDquantilL.AD = quantile(horzcat( vals(5:9,1).AD),[0.25, 0.5, 0.75]); 
 
 LHONmeanL.AD =  mean(horzcat( vals(10:15,1).AD),2);
 LHONminL.AD  =  min(horzcat( vals(10:15,1).AD),2);
 LHONmaxL.AD  =  max(horzcat( vals(10:15,1).AD),2);
 LHONsdL.AD   =  std(horzcat( vals(10:15,1).AD));
 LHONquantilL.AD = quantile(horzcat( vals(10:15,1).AD),[0.25, 0.5, 0.75]); 
 
 CtlmeanL.AD =  mean(horzcat( vals(16:23,1).AD),2);
 CtlminL.AD  =  min(horzcat( vals(16:23,1).AD),2);
 CtlmaxL.AD  =  max(horzcat( vals(16:23,1).AD),2);
 CtlsdL.AD   =  std(horzcat( vals(16:23,1).AD));
 CtlquantilL.AD = quantile(horzcat( vals(16:23,1).AD),[0.25, 0.5, 0.75]); 
 
 JMDmeanL.RD =  mean(horzcat( vals(1:4,1).RD),2);
 JMDminL.RD  =  min(horzcat( vals(1:4,1).RD),2);
 JMDmaxL.RD  =  max(horzcat( vals(1:4,1).RD),2);
 JMDsdL.RD   =  std(horzcat( vals(1:4,1).RD));
 JMDquantilL.RD = quantile(horzcat( vals(1:4,1).RD),[0.25, 0.5, 0.75]); 
 
 CRDmeanL.RD =  mean(horzcat( vals(5:9,1).RD),2);
 CRDminL.RD  =  min(horzcat( vals(5:9,1).RD),2);
 CRDmaxL.RD  =  max(horzcat( vals(5:9,1).RD),2);
 CRDsdL.RD   =  std(horzcat( vals(5:9,1).RD));
 CRDquantilL.RD = quantile(horzcat( vals(5:9,1).RD),[0.25, 0.5, 0.75]); 
 
 LHONmeanL.RD =  mean(horzcat( vals(10:15,1).RD),2);
 LHONminL.RD  =  min(horzcat( vals(10:15,1).RD),2);
 LHONmaxL.RD  =  max(horzcat( vals(10:15,1).RD),2);
 LHONsdL.RD   =  std(horzcat( vals(10:15,1).RD));
 LHONquantilL.RD = quantile(horzcat( vals(10:15,1).RD),[0.25, 0.5, 0.75]); 
 
 CtlmeanL.RD =  mean(horzcat( vals(16:23,1).RD),2);
 CtlminL.RD  =  min(horzcat( vals(16:23,1).RD),2);
 CtlmaxL.RD  =  max(horzcat( vals(16:23,1).RD),2);
 CtlsdL.RD   =  std(horzcat( vals(16:23,1).RD));
 CtlquantilL.RD = quantile(horzcat( vals(16:23,1).RD),[0.25, 0.5, 0.75]); 
 
 
 %% Calculate 
 % Rt-LGN4
 JMDmeanR.FA =  mean(horzcat( vals(1:4,2).FA),2);
 JMDminR.FA  =  min(horzcat( vals(1:4,2).FA),2);
 JMDmaxR.FA  =  max(horzcat( vals(1:4,2).FA),2);
 JMDsdR.FA   =  std(horzcat( vals(1:4,2).FA));
 JMDquantilR.FA = quantile(horzcat( vals(1:4,2).FA),[0.25, 0.5, 0.75]); 
 
 CRDmeanR.FA =  mean(horzcat( vals(5:9,2).FA),2);
 CRDminR.FA  =  min(horzcat( vals(5:9,2).FA),2);
 CRDmaxR.FA  =  max(horzcat( vals(5:9,2).FA),2);
 CRDsdR.FA   =  std(horzcat( vals(5:9,2).FA));
 CRDquantilR.FA = quantile(horzcat( vals(5:9,2).FA),[0.25, 0.5, 0.75]); 

 LHONmeanR.FA =  mean(horzcat( vals(10:15,2).FA),2);
 LHONminR.FA  =  min(horzcat( vals(10:15,2).FA),2);
 LHONmaxR.FA  =  max(horzcat( vals(10:15,2).FA),2);
 LHONsdR.FA   =  std(horzcat( vals(10:15,2).FA));
 LHONquantilR.FA = quantile(horzcat( vals(10:15,2).FA),[0.25, 0.5, 0.75]); 
 
 CtlmeanR.FA =  mean(horzcat( vals(16:23,2).FA),2);
 CtlminR.FA  =  min(horzcat( vals(16:23,2).FA),2);
 CtlmaxR.FA  =  max(horzcat( vals(16:23,2).FA),2);
 CtlsdR.FA   =  std(horzcat( vals(16:23,2).FA));
 CtlquantilR.FA = quantile(horzcat( vals(16:23,2).FA),[0.25, 0.5, 0.75]); 

 JMDmeanR.MD =  mean(horzcat( vals(1:4,2).MD),2);
 JMDminR.MD  =  min(horzcat( vals(1:4,2).MD),2);
 JMDmaxR.MD  =  max(horzcat( vals(1:4,2).MD),2);
 JMDsdR.MD   =  std(horzcat( vals(1:4,2).MD));
 JMDquantilR.MD = quantile(horzcat( vals(1:4,2).MD),[0.25, 0.5, 0.75]); 
 
 CRDmeanR.MD =  mean(horzcat( vals(5:9,2).MD),2);
 CRDminR.MD  =  min(horzcat( vals(5:9,2).MD),2);
 CRDmaxR.MD  =  max(horzcat( vals(5:9,2).MD),2);
 CRDsdR.MD   =  std(horzcat( vals(5:9,2).MD));
 CRDquantilR.MD = quantile(horzcat( vals(5:9,2).MD),[0.25, 0.5, 0.75]); 
 
 LHONmeanR.MD =  mean(horzcat( vals(10:15,2).MD),2);
 LHONminR.MD  =  min(horzcat( vals(10:15,2).MD),2);
 LHONmaxR.MD  =  max(horzcat( vals(10:15,2).MD),2);
 LHONsdR.MD   =  std(horzcat( vals(10:15,2).MD));
 LHONquantilR.MD = quantile(horzcat( vals(10:15,2).MD),[0.25, 0.5, 0.75]); 
 
 CtlmeanR.MD =  mean(horzcat( vals(16:23,2).MD),2);
 CtlminR.MD  =  min(horzcat( vals(16:23,2).MD),2);
 CtlmaxR.MD  =  max(horzcat( vals(16:23,2).MD),2);
 CtlsdR.MD   =  std(horzcat( vals(16:23,2).MD));
 CtlquantilR.MD = quantile(horzcat( vals(16:23,2).MD),[0.25, 0.5, 0.75]); 
 
 JMDmeanR.AD =  mean(horzcat( vals(1:4,2).AD),2);
 JMDminR.AD  =  min(horzcat( vals(1:4,2).AD),2);
 JMDmaxR.AD  =  max(horzcat( vals(1:4,2).AD),2);
 JMDsdR.AD   =  std(horzcat( vals(1:4,2).AD));
 JMDquantilR.AD = quantile(horzcat( vals(1:4,2).AD),[0.25, 0.5, 0.75]); 
 
 CRDmeanR.AD =  mean(horzcat( vals(5:9,2).AD),2);
 CRDminR.AD  =  min(horzcat( vals(5:9,2).AD),2);
 CRDmaxR.AD  =  max(horzcat( vals(5:9,2).AD),2);
 CRDsdR.AD   =  std(horzcat( vals(5:9,2).AD));
 CRDquantilR.AD = quantile(horzcat( vals(5:9,2).AD),[0.25, 0.5, 0.75]); 
 
 LHONmeanR.AD =  mean(horzcat( vals(10:15,2).AD),2);
 LHONminR.AD  =  min(horzcat( vals(10:15,2).AD),2);
 LHONmaxR.AD  =  max(horzcat( vals(10:15,2).AD),2);
 LHONsdR.AD   =  std(horzcat( vals(10:15,2).AD));
 LHONquantilR.AD = quantile(horzcat( vals(10:15,2).AD),[0.25, 0.5, 0.75]); 
 
 CtlmeanR.AD =  mean(horzcat( vals(16:23,2).AD),2);
 CtlminR.AD  =  min(horzcat( vals(16:23,2).AD),2);
 CtlmaxR.AD  =  max(horzcat( vals(16:23,2).AD),2);
 CtlsdR.AD   =  std(horzcat( vals(16:23,2).AD));
 CtlquantilR.AD = quantile(horzcat( vals(16:23,2).AD),[0.25, 0.5, 0.75]); 
 
 JMDmeanR.RD =  mean(horzcat( vals(1:4,2).RD),2);
 JMDminR.RD  =  min(horzcat( vals(1:4,2).RD),2);
 JMDmaxR.RD  =  max(horzcat( vals(1:4,2).RD),2);
 JMDsdR.RD   =  std(horzcat( vals(1:4,2).RD));
 JMDquantilR.RD = quantile(horzcat( vals(1:4,2).RD),[0.25, 0.5, 0.75]); 
 
 CRDmeanR.RD =  mean(horzcat( vals(5:9,2).RD),2);
 CRDminR.RD  =  min(horzcat( vals(5:9,2).RD),2);
 CRDmaxR.RD  =  max(horzcat( vals(5:9,2).RD),2);
 CRDsdR.RD   =  std(horzcat( vals(5:9,2).RD));
 CRDquantilR.RD = quantile(horzcat( vals(5:9,2).RD),[0.25, 0.5, 0.75]); 
 
 LHONmeanR.RD =  mean(horzcat( vals(10:15,2).RD),2);
 LHONminR.RD  =  min(horzcat( vals(10:15,2).RD),2);
 LHONmaxR.RD  =  max(horzcat( vals(10:15,2).RD),2);
 LHONsdR.RD   =  std(horzcat( vals(10:15,2).RD));
 LHONquantilR.RD = quantile(horzcat( vals(10:15,2).RD),[0.25, 0.5, 0.75]); 
 
 CtlmeanR.RD =  mean(horzcat( vals(16:23,2).RD),2);
 CtlminR.RD  =  min(horzcat( vals(16:23,2).RD),2);
 CtlmaxR.RD  =  max(horzcat( vals(16:23,2).RD),2);
 CtlsdR.RD   =  std(horzcat( vals(16:23,2).RD));
 CtlquantilR.RD = quantile(horzcat( vals(16:23,2).RD),[0.25, 0.5, 0.75]); 
 
%% plots boxplot
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% L-LGN group comparison 4groups
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% FA
figure ; hold on;

boxplot([JMDmeanL.FA,CRDmeanL.FA,LHONmeanL.FA,CtlmeanL.FA],'notch','on')
% boxplot([JMDmeanL.FA,CRDmeanL.FA,LHONmeanL.FA,CtlmeanL.FA],'notch','on')



xlabel('Subject groups','fontName','Times','fontSize',12);
ylabel('Fractional Anisotropy','fontName','Times','fontSize',12);
title('Lt-LGN FA','fontName','Times','fontSize',14);
hold off;

%% save the figure in .eps
% Figure ? 1024x768 ?PNG???
% "fig.eps" ??????
cd '/Users/shumpei/Documents/MATLAB/git/LHON/LGN4_diffusivities/figures/'

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

boxplot([JMDmeanL.MD,CRDmeanL.MD,LHONmeanL.MD,CtlmeanL.MD],'notch','on')

xlabel('Subject groups','fontName','Times','fontSize',12);
ylabel('Mean Diffusivity','fontName','Times','fontSize',12);
title('Lt-LGN MD','fontName','Times','fontSize',14);
hold off;

%% save the figure in .eps
% Figure ? 1024x768 ?PNG???
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

boxplot([JMDmeanL.AD,CRDmeanL.AD,LHONmeanL.AD,CtlmeanL.AD],'notch','on')

xlabel('Subject groups','fontName','Times','fontSize',12);
ylabel('Axial Diffusivity','fontName','Times','fontSize',12);
title('Lt-LGN AD','fontName','Times','fontSize',14);
hold off;

%% save the figure in .eps
% Figure ? 1024x768 ?PNG???
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

boxplot([JMDmeanL.RD,CRDmeanL.RD,LHONmeanL.RD,CtlmeanL.RD],'notch','on')

xlabel('Subject groups','fontName','Times','fontSize',12);
ylabel('Radial Diffusivity','fontName','Times','fontSize',12);
title('Lt-LGN RD','fontName','Times','fontSize',14);
hold off;

%% save the figure in .eps
% Figure ? 1024x768 ?PNG???
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
% Figure ? 1024x768 ?PNG???
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
% Figure ? 1024x768 ?PNG???
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
% Figure ? 1024x768 ?PNG???
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

xlabel('Subject groups','fontName','Times','fontSize',12);0.421359217468674

ylabel('Radial Diffusivity','fontName','Times','fontSize',12);
title('Rt-LGN RD','fontName','Times','fontSize',14);
hold off;

%% save the figure in .eps
% Figure ? 1024x768 ?PNG???
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

boxplot([CRDmeanL.FA,LHONmeanL.FA,CtlmeanL.FA],'notch','on')
% boxplot([JMDmeanL.FA,CRDmeanL.FA,LHONmeanL.FA,CtlmeanL.FA],'notch','on')



xlabel('Subject groups','fontName','Times','fontSize',12);
ylabel('Fractional Anisotropy','fontName','Times','fontSize',12);
title('Lt-LGN FA','fontName','Times','fontSize',14);
hold off;

%% save the figure in .eps
% Figure ? 1024x768 ?PNG???
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

boxplot([CRDmeanL.MD,LHONmeanL.MD,CtlmeanL.MD],'notch','on')

xlabel('Subject groups','fontName','Times','fontSize',12);
ylabel('Mean Diffusivity','fontName','Times','fontSize',12);
title('Lt-LGN MD','fontName','Times','fontSize',14);
hold off;

%% save the figure in .eps
% Figure ? 1024x768 ?PNG???
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

boxplot([CRDmeanL.AD,LHONmeanL.AD,CtlmeanL.AD],'notch','on')

xlabel('Subject groups','fontName','Times','fontSize',12);
ylabel('Axial Diffusivity','fontName','Times','fontSize',12);
title('Lt-LGN AD','fontName','Times','fontSize',14);
hold off;

%% save the figure in .eps
% Figure ? 1024x768 ?PNG???
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

boxplot([CRDmeanL.RD,LHONmeanL.RD,CtlmeanL.RD],'notch','on')

xlabel('Subject groups','fontName','Times','fontSize',12);
ylabel('Radial Diffusivity','fontName','Times','fontSize',12);
title('Lt-LGN RD','fontName','Times','fontSize',14);
hold off;

%% save the figure in .eps
% Figure ? 1024x768 ?PNG???
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
% Figure ? 1024x768 ?PNG???
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
% Figure ? 1024x768 ?PNG???
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
% Figure ? 1024x768 ?PNG???
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
% Figure ? 1024x768 ?PNG???
% "fig.eps" ??????
width  = 410;
height =307;
set(gcf,'PaperPositionMode','auto')
pos=get(gcf,'Position');
pos(3)=width-1; %?????1px???????
pos(4)=height;
set(gcf,'Position',pos);
print('-r0','-deps','Rt-LGN RD 3groups.eps');


%% bar FA

BCRD.FA =  mean(vertcat(CRDmeanR.FA,CRDmeanL.FA));
BLHON.FA = mean(vertcat(LHONmeanR.FA,LHONmeanL.FA));
BCtl.FA = mean(vertcat(CtlmeanR.FA,CtlmeanL.FA));

BCRD.RD =  mean(vertcat(CRDmeanR.RD,CRDmeanL.RD));
BLHON.RD = mean(vertcat(LHONmeanR.RD,LHONmeanL.RD));
BCtl.RD = mean(vertcat(CtlmeanR.RD,CtlmeanL.RD));



bar([BCRD.FA,BLHON.FA,BCtl.FA])

bar([BCRD.RD,BLHON.RD,BCtl.RD])
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% total 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% L-LGN FA
figure; hold on;


JMD =  boxplot(horzcat(vals(1:4,1).FA));

% legend('JMD', 'LHON', 'Ctl');
xlabel('Subject','fontName','Times','fontSize',12);
ylabel('Fractional Anisotropy','fontName','Times','fontSize',12);
title('Lt-LGN JMD','fontName','Times','fontSize',14);
hold off;


%%
figure; hold on;

CRD =  boxplot(horzcat( vals(5:9,1).FA));
xlabel('Subject','fontName','Times','fontSize',12);
ylabel('Fractional Anisotropy','fontName','Times','fontSize',12);
title('Lt-LGN CRD','fontName','Times','fontSize',14);
hold off;

%%
figure; hold on;

LHON =  boxplot(horzcat( vals(10:15,1).FA));
xlabel('Subject','fontName','Times','fontSize',12);
ylabel('Fractional Anisotropy','fontName','Times','fontSize',12);
title('Lt-LGN LHON','fontName','Times','fontSize',14);
hold off;

%%
figure; hold on;

Ctl = boxplot(horzcat( vals(16:23,1).FA));
xlabel('Subject','fontName','Times','fontSize',12);
ylabel('Fractional Anisotropy','fontName','Times','fontSize',12);
title('Lt-LGN Ctl','fontName','Times','fontSize',14);
hold off;

%% All

% FA
figure; hold on;

All = boxplot(horzcat(vals(:,1).FA));
xlabel('Subject','fontName','Times','fontSize',12);
ylabel('Fractional Anisotropy','fontName','Times','fontSize',12);
title('Lt-LGN All','fontName','Times','fontSize',14);
hold off;

figure; hold on;

JMD = mean(horzcat(vals(1:5,1).FA),2);

%% save the figure in .eps
% Figure ? 1024x768 ?PNG???
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
All = boxplot(horzcat(vals(:,1).MD));
xlabel('Subject','fontName','Times','fontSize',12);
ylabel('MD','fontName','Times','fontSize',12);
title('Lt-LGN All','fontName','Times','fontSize',14);
hold off;

%% save the figure in .eps
% Figure ? 1024x768 ?PNG???
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
All = boxplot(horzcat( vals(:,1).AD));
xlabel('Subject','fontName','Times','fontSize',12);
ylabel('AD','fontName','Times','fontSize',12);
title('Lt-LGN All','fontName','Times','fontSize',14);
hold off;

%% save the figure in .eps
% Figure ? 1024x768 ?PNG???
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
All = boxplot(horzcat( vals(:,1).RD));
xlabel('Subject','fontName','Times','fontSize',12);
ylabel('RD','fontName','Times','fontSize',12);
title('Lt-LGN All','fontName','Times','fontSize',14);
hold off;


%% save the figure in .eps
% Figure ? 1024x768 ?PNG???
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
% boxplot(horzcat(vertcat(vals(1:4,1).FA), vertcat( vals(5:9,1).FA), vertcat(vals(10:15,1).FA),...
%     vertcat(vals(16:23,1).FA)));

%% Lt-LGN group comparison

boxplot([JMDmeanL,CRDmeanL,LHONmeanL,CtlmeanL]);


%% R-LGN FA
figure; hold on;


JMD =  boxplot(horzcat(vals(1:4,2).FA));

% legend('JMD', 'LHON', 'Ctl');
xlabel('Subject','fontName','Times','fontSize',12);
ylabel('Fractional Anisotropy','fontName','Times','fontSize',12);
title('Rt-LGN JMD','fontName','Times','fontSize',14);
hold off;


%
figure; hold on;

CRD =  boxplot(horzcat( vals(5:9,2).FA));
xlabel('Subject','fontName','Times','fontSize',12);
ylabel('Fractional Anisotropy','fontName','Times','fontSize',12);
title('Rt-LGN CRD','fontName','Times','fontSize',14);
hold off;

% LHON subjects
figure; hold on;

LHON =  boxplot(horzcat( vals(10:15,2).FA));
xlabel('Subject','fontName','Times','fontSize',12);
ylabel('Fractional Anisotropy','fontName','Times','fontSize',12);
title('Rt-LGN LHON','fontName','Times','fontSize',14);
hold off;

% Ctl
figure; hold on;

Ctl = boxplot(horzcat( vals(16:23,2).FA));
xlabel('Subject','fontName','Times','fontSize',12);
ylabel('Fractional Anisotropy','fontName','Times','fontSize',12);
title('Rt-LGN Ctl','fontName','Times','fontSize',14);
hold off;

%%%%%%%%%%%%%%%%%%%
%% All Rt-LGN4
%%%%%%%%%%%%%%%%%%%


figure; hold on;

All = boxplot(horzcat( vals(:,2).FA));%,'plotstyle','compact');
xlabel('Subject','fontName','Times','fontSize',12);
ylabel('Fractional Anisotropy','fontName','Times','fontSize',12);
title('Rt-LGN All','fontName','Times','fontSize',14);
hold off;

%% save the figure in .eps
% Figure ? 1024x768 ?PNG???
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

All = boxplot(horzcat( vals(:,2).MD));%,'plotstyle','compact');
xlabel('Subject','fontName','Times','fontSize',12);
ylabel('Mean Diffusivity','fontName','Times','fontSize',12);
title('Rt-LGN All','fontName','Times','fontSize',14);
hold off; 

%% save the figure in .eps
% Figure ? 1024x768 ?PNG???
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

All = boxplot(horzcat( vals(:,2).AD));%,'plotstyle','compact');
xlabel('Subject','fontName','Times','fontSize',12);
ylabel('Axial Diffusivity','fontName','Times','fontSize',12);
title('Rt-LGN All','fontName','Times','fontSize',14);
hold off; 

%% save the figure in .eps
% Figure ? 1024x768 ?PNG???
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

All = boxplot(horzcat( vals(:,2).RD));%,'plotstyle','compact');
xlabel('Subject','fontName','Times','fontSize',12);
ylabel('Radial Diffusivity','fontName','Times','fontSize',12);
title('Rt-LGN All','fontName','Times','fontSize',14);
hold off; 


%% save the figure in .eps
% Figure ? 1024x768 ?PNG???
% "fig.eps" ??????
width  = 410;
height =307;
set(gcf,'PaperPositionMode','auto')
pos=get(gcf,'Position');
pos(3)=width-1; %?????1px???????
pos(4)=height;
set(gcf,'Position',pos);
print('-r0','-deps','Rt-LGN RD All Subject.eps');



