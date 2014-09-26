function runAFQonMySubjects_8RP_8ctl
% Run AFQ_run for these subjects
%
%% set directory
[homeDir,subDir,JMD,CRD,LHON,Ctl,RP] = Tama_subj2;

AFQdata = homeDir;

%% Make directory structure for each subject
for ii = 1:length(RP)
    sub_dirs{ii} = fullfile(AFQdata, subDir{RP(ii)},'dwi_2nd');
end

for ii = length(RP)+1:length(RP)+length(Ctl)
    sub_dirs{ii} = fullfile(AFQdata, subDir{Ctl(ii-length(RP))},'dwi_2nd');
end

% Subject grouping is a little bit funny because afq only takes two groups
% but we have 3. For now we will divide it up this way but we can do more
% later

sub_group = zeros(1,22);
sub_group(1,1:8) = ones(1,8); 
% sub_group = [1,0];

% Now create and afq structure
afq = AFQ_Create('sub_dirs', sub_dirs, 'sub_group', sub_group, 'clip2rois', 0);

%
% if you would like to use ants for normalization
% afq = AFQ_Create('sub_dirs', sub_dirs, 'sub_group', sub_group, 'clip2rois', 0,'normalization','ants');
afq.params.cutoff = [5 95];

% % To have afq overwrite the old fibers
afq = AFQ_set(afq,'overwritesegmentation');
afq = AFQ_set(afq,'overwritecleaning');

% % afq.params.cutoff=[5 95];
afq.params.outdir = ...
    fullfile(AFQdata,'RP');
afq.params.outname = 'AFQ_8RP_14Ctl_0820.mat';

%
afq.params.maxDist = 4;
afq.params.maxLen = 3;
afq.params.clip2rois = 1;

% mrtrixs
afq.params.track.lengthThreshMm = [25 250];
afq.params.track.faMaskThresh = 0.2;


% %% Run AFQ on these subjects
afq = AFQ_run(sub_dirs, sub_group, afq);
return