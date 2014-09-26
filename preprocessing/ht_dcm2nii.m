function ht_dcm2nii(dcmdir)

% Run dcm2nii from MATLAB command line
% For Tamagawa data analysis.

% INPUT:
% dcmdir: a full path to folder containing dcm file

if notDefined('dcmdir') 
    dcmdir = pwd;
end

cd(dcmdir)

%% Run dcm2nii
system('dcm2nii *');

