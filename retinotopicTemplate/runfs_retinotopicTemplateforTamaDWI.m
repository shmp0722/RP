function runfs_retinotopicTemplateforTamaDWI
% create retiontopic map based on anatomical information. This function
% returns 'eccentricitymap.nii.gz' and 'polaranglemap.nii.gz'. 
%
% See; fs_retinotopicTemplate
%

[homeDir,subDir,JMD,CRD,LHON,Ctl,RP] = Tama_subj2;


%
% %% Initializing the parallel toolbox
% poolwasopen=1; % if a matlabpool was open already we do not open nor close one
% if (matlabpool('size') == 0),
%     c = parcluster;
%     c.NumWorkers = 8;
%     matlabpool(c);
%     poolwasopen=0;
% end

%% make directory
for i = 1:length(subDir)
    subject = subDir{i};
    out_path = fullfile(homeDir,subDir{i},'fs_Retinotopy2');
    if ~exist(out_path); mkdir(out_path);end
end

%% run main function fs_retinotopicTemplate
parfor i =1:length(subDir)
    subject = subDir{i};
    out_path = fullfile(homeDir,subDir{i},'fs_Retinotopy2');
    
    fs_retinotopicTemplate(subject, out_path, [])
end

% matlabpool close