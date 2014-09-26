%% To compare diffusivities along the tracts.
% 
% 
%
[homeDir,subs,JMD,CRD,Ctl,RP] = Tama_subj2;


%% Make directory structure for each subject
for ii = 1:length(subs)
    subDir = fullfile(homeDir, subs{ii},'dwi_2nd');
    fgDir  = fullfile(subDir,'fibers');
    cd(subDir)
    
    % Load up optic radiations
    Fg = {'LOR1206_D4L4.pdb','ROR1206_D4L4.pdb','LOTD4L4_1206.pdb','ROTD4L4_1206.pdb'};
    % Load up the dt6
    dt = dtiLoadDt6('dt6.mat');
    cd(fgDir)
    
    for jj = 1 :length(Fg);
        fg{jj} = fgRead(Fg{jj});
    end
    % Now let's get all of the coordinates that the fibers go through
    coords = horzcat(fg{1}.fibers{:},fg{2}.fibers{:},fg{3}.fibers{:},fg{4}.fibers{:});
    
    % get the unique coordinates
    coords_unique = unique(floor(coords'),'rows');
    
    % These coordsinates are in ac-pc (millimeter) space. We want to transform
    % them to image indices.
    img_coords = unique(floor(mrAnatXformCoords(inv(dt.xformToAcpc), coords_unique)), 'rows');
    
    % Now we can calculate FA
    [fa,md,rd,ad] = dtiComputeFA(dt.dt6);
    
    % Now lets take these coordinates and turn them into an image. First we
    % will create an image of zeros
    OR_img = zeros(size(fa));
    % Convert these coordinates to image indices
    ind = sub2ind(size(fa), img_coords(:,1), img_coords(:,2),img_coords(:,3));
    % Now replace every coordinate that has the optic radiations with a 1
    OR_img(ind) = 1;
    
    %         % Now you have an image. Just for your own interest if you want to make a
    %         % 3d rendering
    %         isosurface(OR_img,.5);
    
    % For each voxel that does not contain the optic radiations we will zero
    % out its value
    fa(~OR_img) = 0;
    md(~OR_img) = 0;
    ad(~OR_img) = 0;
    rd(~OR_img) = 0;
    % not sure but sometimes we found FA>1. Lets correct the value.
    fa(fa>1) =1;
  
    FA{ii}=fa(fa~=0);
    MD{ii}=md(md~=0);
    RD{ii}=rd(rd~=0);
    AD{ii}=ad(ad~=0);
    
    % Now we want to save this as a nifti image; The easiest way to do this is
    % just to steal all the information from another image. For example the b0
    % image
    if ~exist('OrVoxelWithFA');
        mkdir 'OrVoxelWithFA';end;
    cd('OrVoxelWithFA')
    dtiWriteNiftiWrapper(fa, dt.xformToAcpc, sprintf('%s.nii.gz','OpticPathway'));
    showMontage(fa,[],jet(256))
    colormap('jet')
end
disp('finished')

%% let's compare FA across groups
% classify all subjects intogroups
JMD = 1:4;
CRD = 5:9;
% LHON = 10:15;
LHON = [10:14,27];

Ctl = [16:23,31:33,35:37];
RP = [24:26,28,29,34,38,39];


% Render plots which comparing CRD ,LHON, Ctl
% Y=nan(length(subDir),100);
X = 1:100;
c = lines(100);
%% ShowMontage
for ii = 1:length(subs)
    subDir = fullfile(homeDir, subs{ii},'dwi_2nd');
    figDir  = fullfile(subDir,'fibers','OrVoxelWithFA');
    cd(figDir)
    
    ni = niftiRead('OpticPathway.nii.gz');
    H = showMontage(ni.data,[],jet(256));
    hold off;
end

%% Make directory structure for each subject
for ii = 1:length(subs)
    subDir = fullfile(homeDir, subs{ii},'dwi_2nd');
    fgDir  = fullfile(subDir,'fibers');
    cd(subDir)
    
    % Load up optic radiations
    Fg = {'LOR1206_D4L4.pdb','ROR1206_D4L4.pdb'};
    % Load up the dt6
    dt = dtiLoadDt6('dt6.mat');
    cd(fgDir)
    
    for jj = 1 :length(Fg);
        fg{jj} = fgRead(Fg{jj});
    end
    % Now let's get all of the coordinates that the fibers go through
    coords = horzcat(fg{1}.fibers{:},fg{2}.fibers{:});
    
    % get the unique coordinates
    coords_unique = unique(floor(coords'),'rows');
    
    % These coordsinates are in ac-pc (millimeter) space. We want to transform
    % them to image indices.
    img_coords = unique(floor(mrAnatXformCoords(inv(dt.xformToAcpc), coords_unique)), 'rows');
    
    % Now we can calculate FA
    [fa,md,rd,ad] = dtiComputeFA(dt.dt6);
    
    % Now lets take these coordinates and turn them into an image. First we
    % will create an image of zeros
    OR_img = zeros(size(fa));
    % Convert these coordinates to image indices
    ind = sub2ind(size(fa), img_coords(:,1), img_coords(:,2),img_coords(:,3));
    % Now replace every coordinate that has the optic radiations with a 1
    OR_img(ind) = 1;
    
    %         % Now you have an image. Just for your own interest if you want to make a
    %         % 3d rendering
    %         isosurface(OR_img,.5);
    
    % For each voxel that does not contain the optic radiations we will zero
    % out its value
    fa(~OR_img) = 0;
    md(~OR_img) = 0;
    ad(~OR_img) = 0;
    rd(~OR_img) = 0;
    % not sure but sometimes we found FA>1. Lets correct the value.
    fa(fa>1) =1;
  
    FA{ii}=fa(fa~=0);
    MD{ii}=md(md~=0);
    RD{ii}=rd(rd~=0);
    AD{ii}=ad(ad~=0);
    
%     % Now we want to save this as a nifti image; The easiest way to do this is
%     % just to steal all the information from another image. For example the b0
%     % image
%     if ~exist('OrVoxelWithFA');
%         mkdir 'OrVoxelWithFA';end;
%     cd('OrVoxelWithFA')
%     dtiWriteNiftiWrapper(fa, dt.xformToAcpc, sprintf('%s.nii.gz','OpticPathway'));
%     showMontage(fa,[],jet(256))
%     colormap('jet')
end
OR = struct;
OR.FA = FA;
OR.MD = MD;
OR.AD = AD;
OR.RD = RD;

disp('finished')

%% Make directory structure for each subject
for ii = 1:length(subs)
    subDir = fullfile(homeDir, subs{ii},'dwi_2nd');
    fgDir  = fullfile(subDir,'fibers');
    cd(subDir)
    
    % Load up optic radiations
    Fg = {'LOTD4L4_1206.pdb','ROTD4L4_1206.pdb'};
    % Load up the dt6
    dt = dtiLoadDt6('dt6.mat');
    cd(fgDir)
    
    for jj = 1 :length(Fg);
        fg{jj} = fgRead(Fg{jj});
    end
    % Now let's get all of the coordinates that the fibers go through
    coords = horzcat(fg{1}.fibers{:},fg{2}.fibers{:});
    
    % get the unique coordinates
    coords_unique = unique(floor(coords'),'rows');
    
    % These coordsinates are in ac-pc (millimeter) space. We want to transform
    % them to image indices.
    img_coords = unique(floor(mrAnatXformCoords(inv(dt.xformToAcpc), coords_unique)), 'rows');
    
    % Now we can calculate FA
    [fa,md,rd,ad] = dtiComputeFA(dt.dt6);
    
    % Now lets take these coordinates and turn them into an image. First we
    % will create an image of zeros
    OR_img = zeros(size(fa));
    % Convert these coordinates to image indices
    ind = sub2ind(size(fa), img_coords(:,1), img_coords(:,2),img_coords(:,3));
    % Now replace every coordinate that has the optic radiations with a 1
    OR_img(ind) = 1;
    
    %         % Now you have an image. Just for your own interest if you want to make a
    %         % 3d rendering
    %         isosurface(OR_img,.5);
    
    % For each voxel that does not contain the optic radiations we will zero
    % out its value
    fa(~OR_img) = 0;
    md(~OR_img) = 0;
    ad(~OR_img) = 0;
    rd(~OR_img) = 0;
    % not sure but sometimes we found FA>1. Lets correct the value.
    fa(fa>1) =1;
  
    FA{ii}=fa(fa~=0);
    MD{ii}=md(md~=0);
    RD{ii}=rd(rd~=0);
    AD{ii}=ad(ad~=0);
    
%     % Now we want to save this as a nifti image; The easiest way to do this is
%     % just to steal all the information from another image. For example the b0
%     % image
%     if ~exist('OrVoxelWithFA');
%         mkdir 'OrVoxelWithFA';end;
%     cd('OrVoxelWithFA')
%     dtiWriteNiftiWrapper(fa, dt.xformToAcpc, sprintf('%s.nii.gz','OpticPathway'));
%     showMontage(fa,[],jet(256))
%     colormap('jet')
end
OT = struct;
OT.FA = FA;
OT.MD = MD;
OT.AD = AD;
OT.RD = RD;

disp('finished')
