%% This script will load up an optic radiations fiber group and an 

homeDir = '/biac4/wandell/biac2/wandell/data/DWI-Tamagawa-Japan';

subs = {...
    'JMD1-MM-20121025-DWI'
    'JMD2-KK-20121025-DWI'
    'JMD3-AK-20121026-DWI'
    'JMD4-AM-20121026-DWI'
    'JMD5-KK-20121220-DWI'
    'JMD6-NO-20121220-DWI'
    'LHON1-TK-20121130-DWI'
    'LHON2-SO-20121130-DWI'
    'LHON3-TO-20121130-DWI'
    'LHON4-GK-20121130-DWI'
    'LHON5-HS-20121220-DWI'
    'LHON6-SS-20121221-DWI'
    'JMD-Ctl-MT-20121025-DWI'
    'JMD-Ctl-SY-20130222DWI'
    'JMD-Ctl-YM-20121025-DWI'
    'JMD-Ctl-HH-20120907DWI'
    };
   
% Make directory structure for each subject
for ii = 11 %1:length(subs)
    subDir = fullfile(homeDir, subs{ii},'dwi_2nd');

    cd(subDir)

% Load up optic radiations

fgfile = {...
%             'Mori_Occ1000.pdb'...
% %             'Mori_Occ3000.pdb'...
%             'Mori_Occ5000.pdb'
            'wholeBrain+Mori_LOcc+Mori_ROcc.pdb'
            };
        
fgDir = fullfile(subDir,'fibers');

        for ij = 1:length(fgfile)
%             fg = dtiLoadFiberGroup(fullfile('fibers',fgfile{ij}));
            fgfileName = fullfile('fibers',fgfile{ij});
            fg = fgRead(fgfileName);

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
%             isosurface(OR_img,.5);

            % For each voxel that does not contain the optic radiations we will zero
            % out its value
            fa(~OR_img) = 0;

            % Now we want to save this as a nifti image; The easiest way to do this is
            % just to steal all the information from another image. For example the b0
            % image
            
            fgname = {...
%                 'Mori_Occ1000.nii.gz'
% %                 'Mori_Occ3000.nii.gz'
%                 'Mori_Occ5000.nii.gz'
                'Mori_deterministic'};
            
            
            dtiWriteNiftiWrapper(fa, dt.xformToAcpc, fgname{ij});
        end
        
end
disp('I did it')
