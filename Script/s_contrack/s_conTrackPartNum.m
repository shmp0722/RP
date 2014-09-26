%% s_conTrackPartNum
% To save and score a particular number of pathways
% 

homedir = '/biac4/wandell/biac2/wandell/data/DWI-Tamagawa-Japan';

subnames = {...

    'JMD1-MM-20121025-DWI'
    'JMD2-KK-20121025-DWI'
    'JMD3-AK-20121026-DWI'
    'JMD4-AM-20121026-DWI'
    'JMD5-KK-20121220-DWI'
    'JMD6-NO-20121220-DWI'
    'LHON1-TK-20121130-DWI'
    'LHON2-SO-20121130-DWI'
    'LHON3-TO-20121130-DWI'
    'LHON4-GK-20121130-DWI'
    'LHON5-HS-20121220-DWI'
    'LHON6-SS-20121221-DWI'
    'JMD-Ctl-MT-20121025-DWI'
    'JMD-Ctl-SY-20130222DWI'
    'JMD-Ctl-YM-20121025-DWI'
    'JMD-Ctl-HH-20120907DWI'
    'JMD-Ctl-HT-20120907-DWI'};

subinds = 13;

changedir = fullfile(homedir, subnames{subinds}, 'fibers','conTrack');
%% Set the fullpath to data directory

cd(changedir)

%% To save and score a particular number of pathways 
%  you should change fileidentifier = '_20130124T175152' and nFibers.
nFibers = 5000;
txtname = 'ctrSampler.txt';
outputfiberpath = sprintf('scoredFgOut_top%d.pdb',nFibers);
% 
% inputfiberpath = 'fgIn.pdb';
fileidentifier = '_20130205T170951';

dTxt = matchfiles(sprintf('%s/*%s*.txt',changedir,fileidentifier));                
dPdb = matchfiles(sprintf('%s/*%s*.pdb',changedir,fileidentifier));                
[~, tmp] = fileparts(dPdb{1});
inds = strfind(tmp,fileidentifier);
name = tmp(1:inds-1);

outputfibername = fullfile(changedir, sprintf('%s%s-%d.pdb',name,fileidentifier,nFibers));
ContCommand = sprintf('contrack_score.glxa64 -i %s -p %s --thresh %d --sort %s', ...
                        dTxt{1}, outputfibername, nFibers, dPdb{1});
%%                    
system(ContCommand);
