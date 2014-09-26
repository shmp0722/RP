function [roi]=fiberROI(fg, dt, outname)
% This function returns fa values of fg ROI. 
% 
% EXAMPLE
%
% fg = fgRead('FG');
% dt = 'dt6.mat' or dt = dtiLoad Dt6(dt);
% outname = 'fg_FA';
% [roi]=fiberROI(fg, dt, outname)
% 
% Shumpei Ogawa 2014

%% argumenty check
if isstr(fg);
fg = dtiLoadFiberGroup(fg);
end
% Load up the dt6
if isstr(dt);
dt = dtiLoadDt6(dt);
end

%% get coords ac-pc space
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
 
%% Convert these coordinates to image indices
ind = sub2ind(size(fa), img_coords(:,1), img_coords(:,2),img_coords(:,3));
% Now replace every coordinate that has the optic radiations with a 1
OR_img(ind) = 1;
% 
% % Now you have an image. Just for your own interest if you want to make a
% % 3d rendering
% isosurface(OR_img,.5);

% For each voxel that does not contain the optic radiations we will zero
% out its value
fa(~OR_img) = 0;

% Now we want to save this as a nifti image; The easiest way to do this is
% just to steal all the information from another image. For example the b0
% image
roi = dtiWriteNiftiWrapper(fa, dt.xformToAcpc, outname);