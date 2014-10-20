%% change Roi nifti to mat
% dtiRoiFromNifti for 30 normal subjs

% set path
baseDir =  '/biac4/wandell/biac2/wandell/data/DWI-Tamagawa-Japan';

subjDirs =  {...
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
    'JMD-Ctl-FN-20130621-DWI'
    'JMD-Ctl-AM-20130726-DWI'
    'JMD-Ctl-SO-20130726-DWI'};

%%
for ii = 23:length(subjDirs)
    niftiDir = fullfile(baseDir,'freesurfer',subjDirs{ii},'label');
    cd(niftiDir)
    niftiROI = dir('*.nii.gz');
    
    for ij = 1:size(niftiROI,1)
        cd(niftiDir)
        maskValue   =  0;       % All nonZero values are used for the mask
        outFname = sprintf('%s.mat', niftiROI(ij).name(1:end-7));
        outType     = 'mat';
        binary      = true;
        save        = true;
        
        % dtiRoiFromNifti
        roi= dtiRoiFromNifti(niftiROI(ij).name, maskValue, outFname, outType, 0);
        
        % copy nii.gz to ROIs Directory
        post =fullfile(baseDir,subjDirs{ii},'dwi_2nd','ROIs');
        cd(post)
        dtiWriteRoi(roi,roi.name);
    end
end
