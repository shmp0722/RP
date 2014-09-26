%% Set the fullpath to data directory
basedir = '/biac4/wandell/biac2/wandell/data/DWI-Tamagawa-Japan';
cd(basedir)

%% navigate to direcotry containing new T1s
subnames = {...cd(fullfile(basedir, subnames{subinds})}

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
    'JMD-Ctl-YM-20121025-DWI'};

subinds=1;

%%
Ind = [1:14];
for subinds = Ind
cd(fullfile(basedir, subnames{subinds}, '/fibers/conTrack'))

%%  conTrack
%
%
%

!./ctrScript_20080603T181312.sh

%% To save and score a particular number of pathways (e.g., 5000):

!contrack_score.glxa64 -i ctrSampler.txt -p scoredFgOut_top5000.pdb --thresh 5000 --sort fgIn.pdb 






end

