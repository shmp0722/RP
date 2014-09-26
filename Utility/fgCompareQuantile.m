function [FA,MD,AD,RD] = fgCompareQuantile(fg,dt6,direction)
% this function return the diffusivities based on quantile of location.
% For example optic radiation is connecting between LGN and V1.
% This function divide the OR in four part from anterior to posterior.
%
% Input
% fg = fgread('OR_FG')
% dt6 = dtiLoadDt6('dt6.mat');
% direction = 'AP','SI','LR' ; See also 'SO_AlignFiberDirection'.
%

%% argument check
if ~isstruct(fg) && isstr(fg); fg = fgRead(fg);end

%% [LR,AP,SI]
 alignCoord = nan(1,3);
 alignCoord(1,2) = 1;

 fg_aligned = dtiFiberAlign(fg, alignCoord, 1, []);

% [T, M, S, DISTR, df] = dtiDirTestStat(g1, g2, Y, mask);

% Now let's get all of the coordinates that the fibers go through
coords = horzcat(fg.fibers{:});
% get the unique coordinates
coords_unique = unique(floor(coords'),'rows');
% get the quantile
y = prctile(coords_unique(:,2),[25 50 75]);
% select inds based on quantile
inds{1} = find(coords_unique(:,2)>=y(3));
inds{2} = find(y(2)<=coords_unique(:,2) & coords_unique(:,2)<y(3));
inds{3} = find(y(1)<=coords_unique(:,2) & coords_unique(:,2)<y(2));
inds{4} = find(coords_unique(:,2)<=y(1));

% These coordinates are in ac-pc (millimeter) space. We want to transform
% them to image indices.
img_coords_1 = unique(floor(mrAnatXformCoords(inv(dt.xformToAcpc), coords_unique(inds{1},:,:))), 'rows');
img_coords_2 = unique(floor(mrAnatXformCoords(inv(dt.xformToAcpc), coords_unique(inds{2},:,:))), 'rows');
img_coords_3 = unique(floor(mrAnatXformCoords(inv(dt.xformToAcpc), coords_unique(inds{3},:,:))), 'rows');
img_coords_4 = unique(floor(mrAnatXformCoords(inv(dt.xformToAcpc), coords_unique(inds{4},:,:))), 'rows');

% Convert these coordinates to image indices
 [fa,md,rd,ad] = dtiComputeFA(dt.dt6);

ind_1 = sub2ind(size(fa), img_coords_1(:,1), img_coords_1(:,2),img_coords_1(:,3));
ind_2 = sub2ind(size(fa), img_coords_2(:,1), img_coords_2(:,2),img_coords_2(:,3));
ind_3 = sub2ind(size(fa), img_coords_3(:,1), img_coords_3(:,2),img_coords_3(:,3));
ind_4 = sub2ind(size(fa), img_coords_4(:,1), img_coords_4(:,2),img_coords_4(:,3));


%     [T, M, S, DISTR, df] = dtiDirTestStat(g1, g2, Y, mask)

ind = {ind_1,ind_2,ind_3,ind_4};
for kk = 1:length(ind)
    % Now we can calculate FA
    [fa,md,rd,ad] = dtiComputeFA(dt.dt6);
    % Now lets take these coordinates and turn them into an image. First we
    % will create an image of zeros
    OR_img = zeros(size(fa));
    % Now replace every coordinate that has the optic radiations with a 1
    OR_img(ind{kk}) = 1;
    
    % Now you have an image. Just for your own interest if you want to make a
    % 3d rendering
    %         figure; hold on;
    %         isosurface(OR_img,.5);
    %         axis image
    %         camlight('headlight')
    %     end
    % For each voxel that does not contain the optic radiations we will zero
    % out its value
    fa(~OR_img) = 0;
    md(~OR_img) = 0;
    ad(~OR_img) = 0;
    rd(~OR_img) = 0;
    % not sure but sometimes we found FA>1. Lets correct the value.
    fa(fa>1) =1;
    
    FA{ii,kk}=fa(fa~=0);
    MD{ii,kk}=md(md~=0);
    RD{ii,kk}=rd(rd~=0);
    AD{ii,kk}=ad(ad~=0);
end