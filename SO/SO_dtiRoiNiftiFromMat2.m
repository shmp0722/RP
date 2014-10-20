%% SO_dtiRoiNiftiFromMat.m
%
% function dtiRoiNiftiFromMat([matRoi = mrvSelectFile],[refImg],[roiName], ...
%                             [saveFlag=1])
%
% This function will read in a matlab roi file (as used in mrDiffusion) and
% convert it to a nifti file that can be loaded in Quench.
%
% INPUTS:
%   matRoi   - the .mat roi file you want converted to nifti
%   refImg   - the nifti reference image.
%   roiName  - the name for the new nifti roi defaults to
%              [matRoi.name '.nii.gz']
%   saveFlag - 1 = save the ROI, 0 = don't save, just return the struct.
%
% OUTPUTS:
%   ni       - nifti structure cointaining roi data
%   roiName  - path to the saved nifti file
%
%   Saves your roi in the same directory as matRoi with the same
%   name (if you set saveFlag to 1 - which is the default).
%
% WEB:
%   mrvBrowseSVN('dtiRoiNiftiFromMat');
%
% EXAMPLE:
%   matRoi = 'leftLGN.mat';
%   refImg = 't1.nii.gz';
%   ni     = dtiRoiNiftiFromMat(matRoi,refImg);
%
%
% (C) Stanford VISTA, 8/2011 [lmp]
%
%%
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
    'JMD-Ctl-FN-20130621-DWI'
    'JMD-Ctl-AM-20130726-DWI'
    'JMD-Ctl-SO-20130726-DWI'};

%%
for i = 1:length(subDir)
    % INPUTS
    SubDir = fullfile(homeDir,subDir{i});
    fgDir  = (fullfile(SubDir,'/dwi_2nd/fibers/conTrack/OCF_Top50K_fsV1V2_3mm'));
    roidir = fullfile(SubDir,'/dwi_2nd/ROIs');
    % load roi
    
%     roif = {'lh_V1_smooth3mm_NOT.mat','rh_V1_smooth3mm_NOT.mat','Rt-LGN4','Lt-LGN4'};
    roif = 'Optic-Chiasm.mat';%,'Optic-Chiasm.nii_1.mat','Optic-Chiasm_clean1111.mat'};
        matRoi  = fullfile(roidir,roif);
        refImg  = fullfile(SubDir,'t1.nii.gz');
        cd(roidir)
        % run main
%         for j = 1:length(roif)
            dtiRoiNiftiFromMat(matRoi,refImg);
%         end
end


