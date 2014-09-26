function  ni = dtiRoiNiftiFromMat(matRoi,refImg,roiName,saveFlag)
% 
% function dtiRoiNiftiFromMat([matRoi = mrvSelectFile],[refImg],[roiName], ... 
%                             [saveFlag=1])
% 
% This function will read in a matlab roi file (as used in mrDiffusion) and
% convert it to a nifti file that can be loaded in Quench. 
% 
% INPUTS:
%   matRoi   - the .mat roi file you want converted to nifti
%   refImg   - the nifti reference image. ni = dtiRoiNiftiFromMat(matRoi,refImg,roiName,saveFlag)
%   roiName  - the name for the new nifti roi defaults to
%              [matRoi.name '.nii.gz']
%   saveFlag - 1 = save the ROI, 0 = don't save, just return the struct.
% 
% OUTPUTS:
%   ni       - nifti structure cointaining roi data
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
% ni = dtiRoiNiftiFromMat(matRoi,refImg,roiName,saveFlag)
%% Set the fullpath to data directory
basedir = '/biac4/wandell/biac2/wandell/data/DWI-Tamagawa-Japan';
cd(basedir)


%% navigate to direcotry containing new T1s
subnames = {...cd(fullfile(basedir, subnames{subinds}))

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

%%
Ind = [2];

subinds = Ind
cd(fullfile(basedir, subnames{subinds}))


%% Run dtiRoiNiftiFromMat

 matRoi = '/ROIs/L-LGN.mat';
 refImg = 't1.nii.gz'; 
 
 ni     = dtiRoiNiftiFromMat(matRoi,refImg);

return