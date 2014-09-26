%% This script will load up an optic radiations fiber group and an 

cd /biac4/wandell/biac2/wandell/data/DWI-Tamagawa-Japan/LHON1-TK-20121130-DWI/dwi_2nd

% Load up optic radiations
fg = dtiLoadFiberGroup(fullfile('fibers','conTrack','T3Top100kNotWmHippo','TamagawaDWI3_Rt-LGN_ctx-rh-pericalcarineMD2.pdb'));

% Load up the dt6
dt = dtiLoadDt6('dt6.mat');

% Now let's get all of the coordinates that the fibers go through
coords = horzcat(fg.fibers{:});

% get the unique coordinates
coords_unique = unique(floor(coords'),'rows');

% These coordsinates are in ac-pc (millimeter) space. We want to transform
% them to image indices.
img_coords = unique(floor(mrAnatXformCoords(inv(dt.xformToAcpc), coords_unique)), 'rows');

% Now we can calculate FA
fa = dtiComputeFA(dt.dt6);

% Now lets take these coordinates and turn them into an image. First we
% will create an image of zeros
OR_img = zeros(size(fa));
% Convert these coordinates to image indices
ind = sub2ind(size(fa), img_coords(:,1), img_coords(:,2),img_coords(:,3));
% Now replace every coordinate that has the optic radiations with a 1
OR_img(ind) = 1;

% Now you have an image. Just for your own interest if you want to make a
% 3d rendering
isosurface(OR_img,.5);

% For each voxel that does not contain the optic radiations we will zero
% out its value
fa(~OR_img) = 0;

% Now we want to save this as a nifti image; The easiest way to do this is
% just to steal all the information from another image. For example the b0
% image
dtiWriteNiftiWrapper(fa, dt.xformToAcpc, 'OpticRadiationsFA.nii.gz');
