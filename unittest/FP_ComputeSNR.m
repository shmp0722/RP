% FP_ComputeSNR 
% Compute SNR for Shumpei's data
%
%
% This is an example of how to use dwiGet to compute SNR of a diffusion
% image measurements in the set of coordinates identified by a fiber group. 
%
% The calculations are performed on the B0 images
% collected. If you have a sufficient number of B0 images collected (nB0 > 8?) you can
% realiably compute SNR using a voxel-wise calculation without account for
% smal samples. Otherwise you need to account for small sampels and use a
% summary SNR measure across the whole set of coordiantes.
%
% Writeen by franco Pestilli (c) Vista soft stanford university



% Identify the files we will use for computing SNR
bvalsF = '/biac4/wandell/biac2/wandell/data/DWI-Tamagawa-Japan/JMD1-MM-20121025-DWI/raw/dwi1st_aligned_trilin.bvals';
bvecsF = '/biac4/wandell/biac2/wandell/data/DWI-Tamagawa-Japan/JMD1-MM-20121025-DWI/raw/dwi1st_aligned_trilin.bvecs';
dFile = '/biac4/wandell/biac2/wandell/data/DWI-Tamagawa-Japan/JMD1-MM-20121025-DWI/raw/dwi1st_aligned_trilin.nii.gz';

% Load the files into a DWi structure
dNifti = niftiRead(dFile);
bvecs = dlmread(bvecsF); 
bvals = dlmread(bvalsF);
dwi = dwiCreate('nifti',dNifti,'bvecs',bvecs,'bvals',bvals);

% Identify a set of coordinates to comput SNR.
%
% Load a fiber group
fgF = '/biac4/wandell/biac2/wandell/data/DWI-Tamagawa-Japan/JMD1-MM-20121025-DWI/dwi_2nd/fibers/LOR_MD2.pdb';
fg  = fgRead(fgF);

% Get all the coordinates fro the fiber group in the DWi volume (not acpc but img coordinates)
% Get the xform from acpc to img from the dwi nifti file
xform = niftiGet(dNifti,'qto_ijk');
% Transfrom the fg in image coordinates
fg.fibers = fgGet(fg,'image coords',1:length(fg.fibers),xform)';

% Extract the unique coordinates in the fiber group
coords = floor(vertcat(fg.fibers{:})');
coords = unique(coords','rows');

% Compute the snr across the coordinates of the fiber group
totalSNR = dwiGet(dwi,'b0 snr roi',coords);
voxelSNR = dwiGet(dwi,'b0 snr image',coords); % Please notice this calculation does not correct for small samples.

