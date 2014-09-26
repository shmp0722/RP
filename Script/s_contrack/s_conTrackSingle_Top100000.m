%% s_conTrackSingle_Top100000.m
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
    'JMD-Ctl-YM-20121025-DWI'
    'JMD-Ctl-SY-20130222DWI'
    'JMD-Ctl-HH-20120907DWI'
    'JMD-Ctl-HT-20120907-DWI'
    };

for inds = 17;

changedir = fullfile(homedir, subnames{inds},'dwi_1st', 'fibers','conTrack','Top100000');
%% Set the fullpath to data directory
cd(changedir)
%%
ins = {...
       './ctrScript_Top100000_Lt-LGN_ctx-lh-pericalcarine_2013-03-11_10.31.22.sh'
%      './ctrScript_Top100000_O-Chsm_Lt-LGN_2013-03-05_17.58.01.sh'
%      './ctrScript_Top100000_O-Chsm_Rt-LGN_2013-03-05_17.58.01.sh'
       './ctrScript_Top100000_Rt-LGN_ctx-rh-pericalcarine_2013-03-11_10.31.22.sh'
                                                                };

%% To save and score a particular number of pathways 

 for ij = 1:length(ins)
        
        ContCommand = ins{ij};
                   
system(ContCommand);
 end
end

