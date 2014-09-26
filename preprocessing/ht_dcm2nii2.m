function ht_dcm2nii2(subnames)
%% Tamagawa preprocessing dcm2nii *
homedir = '/biac4/wandell/biac2/wandell/data/DWI-Tamagawa-Japan';
cd(homedir);
%%
subnames = {...
    'JMD-Ctl-SY-20130222DWI/Yoshimine-anatomy/17100000'
    'JMD-Ctl-SY-20130222DWI/Yoshimine-DWI/25410000'
    'JMD-Ctl-SY-20130222DWI/Yoshimine-DWI/29490000'
    'JMD-Ctl-SY-20130222DWI/Yoshimine-DWI/33300000'
    'JMD-Ctl-SY-20130222DWI/Yoshimine-DWI/38150000'};

% subinds = 5;


%% Run dcm2nii from MATLAB command line
% For Tamagawa data analysis.

for subinds = 1:length(subnames)

 dcmdir = fullfile(homedir,subnames{subinds});
        
 cd(dcmdir)

%Run dcm2nii
 system('dcm2nii *');
end