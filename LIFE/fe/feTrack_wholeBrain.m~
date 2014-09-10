%% feTrack_wholeBrain.m
% generate whole brain connectome using mrtrix

  [homeDir,subDir,JMD,CRD,LHON,Ctl,RP] = Tama_subj2;

%% make sure directory organization
  for i = 2:length(subDir);
     % set directory
    SubDir  = fullfile(homeDir,subDir{i});
    fibersFolder   = fullfile(SubDir,'/dwi_2nd/fibers/life_mrtrix');
    dtDir   = fullfile(SubDir,'dwi_2nd');   
    cd(dtDir)

%% Whole brain tractography
 for i = 2:length(subDir);
     % set directory
    SubDir  = fullfile(homeDir,subDir{i});
    fibersFolder   = fullfile(SubDir,'/dwi_2nd/fibers/life_mrtrix');
    dtDir   = fullfile(SubDir,'dwi_2nd');   
    dt      = fullfile(dtDir,'dt6.mat');     
    lmax = [2];
    nSeeds  = 500000;
    %% feTrack
%     [status, results, fg, pathstr] = feTrack('prob', dt,[],lmax,nSeeds,[]);
    
    [status, results, fg, pathstr] = SO_feTrack('prob',dt,fibersFolder,2,500000,[]);
%     cd(fibersFolder)
%     fgWrite(fg,)
 end
 
%  %% Tamagawa1
%  [homeDir,subDir,JMD,CRD,LHON,Ctl,RP] = Tama_subj;
% 
% %% Whole brain tractography
%  parfor i = 24:length(subDir);
%      % set directory
%     SubDir  = fullfile(homeDir,subDir{i});
%     fibersFolder   = fullfile(SubDir,'/dwi_2nd/fibers/life_mrtrix');
%     dtDir   = fullfile(SubDir,'dwi_2nd');   
%     dt      = fullfile(dtDir,'dt6.mat');     
%     lmax = [2];
%     nSeeds  = 500000;    
% %     cd(SubDir)
%     %% feTrack
% %     [status, results, fg, pathstr] = feTrack('prob', dt,[],lmax,nSeeds,[]);
%     
%     [status, results, fg, pathstr] = SO_feTrack('prob',dt,fibersFolder,2,500000,[]);
% %     cd(fibersFolder)
% %     fgWrite(fg,)
%  end