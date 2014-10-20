%%
homeDir = '/biac4/wandell/biac2/wandell/data/DWI-Tamagawa-Japan';

subDir = {...
    'JMD1-MM-20121025-DWI','JMD2-KK-20121025-DWI','JMD3-AK-20121026-DWI',...
    'JMD4-AM-20121026-DWI','JMD5-KK-20121220-DWI','JMD6-NO-20121220-DWI',...
    'JMD7-YN-20130621-DWI','JMD8-HT-20130621-DWI','JMD9-TY-20130621-DWI',...
    'LHON1-TK-20121130-DWI','LHON2-SO-20121130-DWI','LHON3-TO-20121130-DWI',...
    'LHON4-GK-20121130-DWI','LHON5-HS-20121220-DWI','LHON6-SS-20121221-DWI',...
    'JMD-Ctl-MT-20121025-DWI','JMD-Ctl-SY-20130222DWI','JMD-Ctl-YM-20121025-DWI',...
    'JMD-Ctl-HH-20120907DWI','JMD-Ctl-FN-20130621-DWI','JMD-Ctl-HT-20120907-DWI'};

for i = 1:length(subDir)
    
    cd(fullfile(homeDir,subDir{i},'/dwi_2nd/ROIs'))
    
    % ROI file names you want to merge
    
    roiname = {...
        'Right-Cerebral-Cortex_rh_V1_smooth3mm_NOT_FA_p15'
        'Left-Cerebral-Cortex_lh_V1_smooth3mm_NOT_FA_p15'};
    
    for j = 1:length(roiname)
        roi = [roiname{j} '.mat'];
        img = fullfile(homeDir,subDir{i},'t1.nii.gz');
        ni = dtiRoiNiftiFromMat(roi,img);
    end
end