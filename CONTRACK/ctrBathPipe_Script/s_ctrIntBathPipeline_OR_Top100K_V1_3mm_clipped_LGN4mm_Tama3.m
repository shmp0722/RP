function s_ctrIntBathPipeline_OR_Top100K_V1_3mm_clipped_LGN4mm_Tama3
% Multi-Subject Tractography for Tamagawa_subjects using conTrack
%
%

%%
[homeDir,subDir] = Tama_subj3;
%% Set ctrInitBatchParams
%
%
ctrParams = ctrInitBatchParams;

ctrParams.projectName = 'OR_Top100K_V1_3mm_clipped_LGN4mm';
ctrParams.logName = 'myConTrackLog';
ctrParams.baseDir = homeDir;
ctrParams.dtDir = 'dwi_2nd';
ctrParams.roiDir = '/dwi_2nd/ROIs';
ctrParams.subs = { ...
    'AMD-Ctl01-HM-dMRI-Anatomy-2014-09-09'
%     'AMD-Ctl02-YM-dMRI-Anatomy-2014-09-09'
%     'AMD-Ctl03-TS-dMRI-Anatomy-2014-10-28'
%     'AMD-Ctl04-AO-61yo-dMRI-Anatomy'
%     'AMD-Ctl05-TM-71yo-dMRI-Anatomy'
%     'AMD-Ctl06-YM-66yo-dMRI-Anatomy'
%     'AMD-Ctl07-MS-61yo-dMRI-Anatomy'
%     'AMD-Ctl08-HO-62yo-dMRI-Anatomy'
%     'AMD-Ctl09-KH-70yo-dMRI-Anatomy-dMRI'
    'AMD-Ctl10-TH-65yo-dMRI-Anatomy-dMRI'};

% set parameter
ctrParams.roi1 = {'Lt-LGN4','Rt-LGN4'};
ctrParams.roi2 = {'lh_V1_smooth3mm_NOT','rh_V1_smooth3mm_NOT'};
ctrParams.nSamples = 100000;
ctrParams.maxNodes = 240;
ctrParams.minNodes = 10; % defalt: 10
ctrParams.stepSize = 1;
ctrParams.pddpdfFlag = 0;
ctrParams.wmFlag = 0;
ctrParams.oi1SeedFlag = 'true';
ctrParams.oi2SeedFlag = 'true';
ctrParams.multiThread = 0;
ctrParams.xecuteSh = 0;


%% Run ctrInitBatchTrack
%
[cmd, ~] = ctrInitBatchTrack(ctrParams);


%% run conTrack
system(cmd);




