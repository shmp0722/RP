function CleanMrtOR
%% 
baseDir = '/biac4/wandell/biac2/wandell/data/DWI-Tamagawa-Japan';

subjectDir = {...
    'JMD1-MM-20121025-DWI'
    'JMD2-KK-20121025-DWI'
    'JMD3-AK-20121026-DWI'
%     'JMD4-AM-20121026-DWI' % We could not generate the OR right now. 
    'JMD5-KK-20121220-DWI'
    'JMD6-NO-20121220-DWI'
    'JMD7-YN-20130621-DWI'
    'JMD8-HT-20130621-DWI'
    'JMD9-TY-20130621-DWI'
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
    'JMD-Ctl-HT-20120907-DWI'
    'JMD-Ctl-FN-20130621-DWI'
    'JMD-Ctl-AM-20130726-DWI'
    'JMD-Ctl-SO-20130726-DWI'};
%% 
for i = 1:length(subjectDir);
    % Set directory
    dtFile = fullfile(baseDir, subjectDir{i}, '/dwi_2nd/dt6.mat');
    refImg = fullfile(baseDir, subjectDir{i}, '/t1.nii.gz');
    fibersFolder = fullfile(baseDir, subjectDir{i}, '/dwi_2nd/fibers/mrtrix2');
    roisFolder   = fullfile(baseDir, subjectDir{i}, '/dwi_2nd/ROIs');
    % Load fiber groups
    cd(fibersFolder)
    fgF{1} = dir('*_Lt-LGN4_prob.pdb'); 
    fgF{2} = dir('*_Rt-LGN4_prob.pdb');
    
    fg{1} = fgRead(fgF{1}.name); fg{2} = fgRead(fgF{2}.name); 
    
    
    
    
    