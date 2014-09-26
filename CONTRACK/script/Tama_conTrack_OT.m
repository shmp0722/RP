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

for subinds = 11:length(subDir);
    % Set the fullpath to data directory
    saveDir = fullfile(homedir, subDir{subinds},'/dwi_2nd/fibers/conTrack/OpticTract5000');
    cd(saveDir)
    %% shell
    ins = {...
        './ctrScript_OpticTract5000_Optic-Chiasm_clean1111_Lt-LGN_2013-04-18_12.58.43.sh'
        './ctrScript_OpticTract5000_Optic-Chiasm_clean1111_Rt-LGN_2013-04-18_12.58.43.sh'
            };

    %% To save and score a particular number of pathways 

     for ij = 1:length(ins)
         cmd = ins{ij};
         system(cmd);
     end
end