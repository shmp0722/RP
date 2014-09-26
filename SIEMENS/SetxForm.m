%% SetxForm.m
% For data collected from Siemens Scanner 
% Set the xForm to work with our software: This has to be done because 
% the qto_xyz transform should be the same as the sto_xyz xForm
%
% In Matlab (in the directory containing yourNiftiFile):
% ni = readFileNifti('yourNiftiFile.nii.gz');
% ni = niftiSetQto(ni,ni.sto_xyz);
% ni.fname = 'newNiftiFileName.nii.gz');
% writeFileNifti(ni);
%

ni = readFileNifti('t1.nii.gz');
ni = niftiSetQto(ni,ni.sto_xyz);
ni.fname = ('t1_postSetxForm.nii.gz');
writeFileNifti(ni);