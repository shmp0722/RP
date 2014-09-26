%% s_conTrackss.m
% To save and score a particular number of pathways

homedir = '/biac4/wandell/biac2/wandell/data/DWI-Tamagawa-Japan';

subDir = {...
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

for subinds = 14:length(subDir);
    % Set the fullpath to data directory
    saveDir = fullfile(homedir, subDir{subinds},'/dwi_2nd/fibers/conTrack/OR_Top100K_fs2ROIV1_3mm');
    cd(saveDir)
    %% shell
    ins = {...
        './ctrScript_OR_Top100K_fs2ROIV1_3mm_Rt-LGN_rh_V1_smooth3mm_2013-06-05_01.07.38.sh'
        './ctrScript_OR_Top100K_fs2ROIV1_3mm_Lt-LGN_lh_V1_smooth3mm_2013-06-05_01.07.38.sh'
            };

    %% To save and score a particular number of pathways 

     for ij = 1:length(ins)
         cmd = ins{ij};
         system(cmd);
     end
end