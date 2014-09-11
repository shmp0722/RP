function DegreeV1ROI

cd /biac4/wandell/biac2/wandell/data/DWI-Tamagawa-Japan/JMD1-MM-20121025-DWI/fs_Retinotopy2

%% Load ecc or pol nii.gz
ni =niftiRead('JMD1-MM-20121025-DWI_lh_ecc.nii.gz');

%% select voxels has less than 20degree
newNi = ni;
newNi.data(newNi.data > 15)=0;
newNi.data(newNi.data > 0)=1;
%% if you want to save it as ROI. The values should be binary (0 or 1)
%  ni.data(ni.data<20) = 0;
% 
%  ni.data(ni.data >= 20)=1;

 %% give new mname to the ROI  
 newNi.fname = 'JMD1-MM-20121025-DWI_lh_ecc_15degree.nii.gz';
 
 %% save the ROI
 niftiWrite(newNi)