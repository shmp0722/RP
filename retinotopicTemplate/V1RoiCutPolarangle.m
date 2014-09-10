function V1RoiCutPolarangle(Min,Max)
%% Set the path to data directory
homeDir = '/biac4/wandell/biac2/wandell/data/DWI-Tamagawa-Japan';
subDir = {...
    'JMD1-MM-20121025-DWI'
    'JMD3-AK-20121026-DWI'
    'JMD5-KK-20121220-DWI'
    'JMD6-NO-20121220-DWI'
    'JMD2-KK-20121025-DWI'
    'JMD4-AM-20121026-DWI'
    'JMD7-YN-20130621-DWI'
    'JMD8-HT-20130621-DWI'
    'JMD9-TY-20130621-DWI'
    'LHON1-TK-20121130-DWI'
    'LHON2-SO-20121130-DWI'
    'LHON3-TO-20121130-DWI'
    'LHON4-GK-20121130-DWI'
    'LHON5-HS-20121220-DWI'
    'LHON6-SS-20121221-DWI'
    'JMD-Ctl-MT-20121025-DWI'
    'JMD-Ctl-YM-20121025-DWI'
    'JMD-Ctl-SY-20130222DWI'
    'JMD-Ctl-HH-20120907DWI'
    'JMD-Ctl-HT-20120907-DWI'
    'JMD-Ctl-FN-20130621-DWI'
    'JMD-Ctl-AM-20130726-DWI'
    'JMD-Ctl-SO-20130726-DWI'
    'RP1-TT-2013-11-01'
    'RP2-KI-2013-11-01'
    'RP3-TO-13120611-DWI'
%     'LHON6-SS-20131206-DWI'
    'RP4-AK-2014-01-31'
    'RP5-KS-2014-01-31'
    'JMD3-AK-20140228-dMRI'
    'JMD-Ctl-09-RN-20130909'
    'JMD-Ctl-10-JN-20140205'
    'JMD-Ctl-11-MT-20140217'
    'RP6-SY-2014-02-28-dMRI'
    'Ctl-12-SA-20140307'
    'Ctl-13-MW-20140313-dMRI-Anatomy'
    'Ctl-14-YM-20140314-dMRI-Anatomy'
    'RP7-EU-2014-03-14-dMRI-Anatomy'
    'RP8-YT-2014-03-14-dMRI-Anatomy'
    };

%% 
for i = 1:length(subDir);
    
    SubDir = fullfile(homeDir,subDir{i});
    eccDir  = fullfile(SubDir,'fs_Retinotopy2');
    cd(eccDir)
    
    hemi ={'lh','rh'};
    for j =  1 : length(hemi)
        %% Load ecc or pol nii.gz
        ni =niftiRead(sprintf('%s_%s_pol.nii.gz',subDir{i},hemi{j}));
        
        %% select voxels within 10degree (80-100)
        newNi = ni;
        newNi.data(newNi.data >= Max)=0;
        newNi.data(newNi.data <= Min)=0;
        newNi.data(newNi.data > 0)=1;
        %% peripheral ROI
        %  so that to be more smart. idx2  = find(keep2);        
%         peri = ni;
%         peri.data(peri.data < Max)=0;
%         peri.data(peri.data > Min)=0;
%         peri.data(peri.data > 0)=1;
%         inds = peri.data(peri.data(:)==1);
        %% give new mname to the ROI
        newNi.fname = sprintf('%s_%d_%dDegree_pol.nii.gz',hemi{j},Min,Max);
%         peri.fname = sprintf('%s_Peri%d_%dDegree_pol.nii.gz',hemi{j},Min,Max);
        %% save the ROI
        niftiWrite(newNi)
%         niftiWrite(peri)
        
    end
end

return
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