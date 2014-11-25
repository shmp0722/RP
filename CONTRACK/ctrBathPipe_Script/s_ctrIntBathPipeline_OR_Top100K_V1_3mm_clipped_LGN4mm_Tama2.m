function s_ctrIntBathPipeline_OR_Top100K_V1_3mm_clipped_LGN4mm_Tama2
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
ctrParams.subs = {subDir{4},subDir{5},subDir{6}};

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
[cmd infofile] = ctrInitBatchTrack(ctrParams);


%% run conTrack
system(cmd);




