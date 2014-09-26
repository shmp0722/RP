%% MergeROIs_NOT0712.m

homeDir = '/biac4/wandell/biac2/wandell/data/DWI-Tamagawa-Japan';

subDir ={
    'JMD1-MM-20121025-DWI'
    'JMD2-KK-20121025-DWI'
    'JMD3-AK-20121026-DWI'
    'JMD4-AM-20121026-DWI'
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
    'JMD-Ctl-FN-20130621-DWI'};

for i = 2;%1:length(subDir)
    for k=1:2;
        % INPUTS
        SubDir =fullfile(homeDir,subDir{i});
        roiDir =fullfile(homeDir,subDir{i},'/dwi_2nd/ROIs');
        % JMD2 doesnt have Brain-Stem segmentation
        if i == 2; 
            roiname1 = {'Left-Cerebral-Cortex_V13mm_setdiff.mat','Right-Cerebral-Cortex_V13mm_setdiff.mat'};
            roiname2 = {'Rh_NOT0711','Lh_NOT0711'}; 
        else
            roiname1 = {'Left-Cerebral-Cortex_V13mm_setdiff.mat','Right-Cerebral-Cortex_V13mm_setdiff.mat'};
            roiname2 = {'Rh_NOT0712','Lh_NOT0712'};
        end;
        cd(roiDir)
        roi1 = dtiReadRoi(roiname1{k});
        roi2 = dtiReadRoi(roiname2{k});
        
        newROI=dtiMergeROIs(roi1,roi2);
        newROI.name = [roiname2{k}(1:end-4) '0712_setdiffV13mm'];
        dtiWriteRoi(newROI,newROI.name,1);
    end
end