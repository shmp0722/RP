function runOsmosisDtiCod
% Caliculate the cross validation coeffcient of determination for the DTI
% model
%
%
%


homeDir = '/biac4/wandell/biac2/wandell/data/DWI-Tamagawa-Japan';
subDir = {...
    'JMD1-MM-20121025-DWI'
    'JMD2-KK-20121025-DWI'
    'JMD3-AK-20121026-DWI'
    'JMD4-AM-20121026-DWI'
    'JMD5-KK-20121220-DWI'
    'JMD6-NO-20121220-DWI'
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
    'JMD-Ctl-SY-20130222DWI'
    'JMD-Ctl-YM-20121025-DWI'
    %     'JMD-Ctl-HH-20120907DWI'
    %     'JMD-Ctl-HT-20120907-DWI'
    'JMD-Ctl-FN-20130621-DWI'
    'JMD-Ctl-AM-20130726-DWI'
    'JMD-Ctl-SO-20130726-DWI'
    'RP1-TT-2013-11-01'
    'RP2-KI-2013-11-01'
    'RP3-TO-13120611-DWI'
    'LHON6-SS-20131206-DWI'
    'RP4-AK-2014-01-31'
    'RP5-KS-2014-01-31'};




%% command run Osmosis-dti-cod
for i =1:length(subDir)
    cd(fullfile(homeDir, subDir{i},'raw'))
    !osmosis-dti-cod.py dwi1st_aligned_trilin.nii.gz dwi1st_aligned_trilin.bvecs dwi1st_aligned_trilin.bvals dwi2nd_aligned_trilin.nii.gz dwi2nd_aligned_trilin.bvecs dwi2nd_aligned_trilin.bvals dti_cod.nii.gz
end

%% command run Osmosis-dti-cod with wmMask
for i =1:length(subDir)
    cd(fullfile(homeDir, subDir{i},'raw'))
    !osmosis-dti-cod.py dwi1st_aligned_trilin.nii.gz dwi1st_aligned_trilin.bvecs dwi1st_aligned_trilin.bvals dwi2nd_aligned_trilin.nii.gz dwi2nd_aligned_trilin.bvecs dwi2nd_aligned_trilin.bvals dti_cod_wmMask.nii.gz --mask_file wmMask.nii.gz

end


%% load cod.nii and create fiberROI.nii
for  i =1:length(subDir)
    %  load coeffcient of determination
    nicodDir = fullfile(homeDir, subDir{i},'raw');
    cd(nicodDir)
    nicod = niftiRead(fullfile(nicodDir,'dti_cod.nii.gz'));
  
    % load the fiber group and dt6 files
    fgDir  = fullfile(homeDir,subDir{i},'/dwi_2nd/fibers');
    dt  = fullfile(homeDir,subDir{i},'dwi_2nd','dt6.mat');
    dt  = dtiLoadDt6(dt);
    
    %     'OCFV1V2Not3mm_MD4Al.pdb'
    fgN ={'BOR1206_D4L4_rsquared_rGM.nii.gz','BOR1206_D4L4_rsquared_WM.nii.gz'};

    
    
    %
    for j = 1: length(fgN)
        fg = fgRead(fullfile(fgDir,fgN{j}));        
        
        %%
        % Now let's get all of the coordinates that the fibers go through
        coords = horzcat(fg.fibers{:});
        
        % get the unique coordinates
        coords_unique = unique(floor(coords'),'rows');
        
        % These coordsinates are in ac-pc (millimeter) space. We want to transform
        % them to image indices.
        img_coords = unique(floor(mrAnatXformCoords(inv(dt.xformToAcpc), coords_unique)), 'rows');
                
        % Now lets take these coordinates and turn them into an image. First we
        % will create an image of zeros
        OR_img = zeros(size(nicod.data));
        % Convert these coordinates to image indices
        ind = sub2ind(size(nicod.data), img_coords(:,1), img_coords(:,2),img_coords(:,3));
        % Now replace every coordinate that has the optic radiations with a 1
        OR_cod = nicod.data(ind);
        OR_Positivecod = OR_cod(OR_cod>0);
        m(i)  = mean(OR_cod);
        
        m2(i) = mean(OR_Positivecod);
        sd(i) = std(OR_cod);
%         
%         
%         % % Now you have an image. Just for your own interest if you want to make a
%         % % 3d rendering
%         OR_img(ind) = 1;
%         isosurface(OR_img,.5);
%         % For each voxel that does not contain the optic radiations we will zero
%         % out its value
%         
%         
%         % Now we want to save this as a nifti image; The easiest way to do this is
%         % just to steal all the information from another image. For example the b0
%         % image
%         niFg = dtiWriteNiftiWrapper(OR_img, dt.xformToAcpc, sprintf('%s.nii.gz',[fg.name,'_2']));
%         nicod.data(~ind)=0;

    end
end




