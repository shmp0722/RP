%% set directories

AFQdata = '/biac4/wandell/biac2/wandell/data/DWI-Tamagawa-Japan';

subs = {...
    'JMD1-MM-20121025-DWI'...
    'JMD2-KK-20121025-DWI'...
    'JMD3-AK-20121026-DWI'...
    'JMD4-AM-20121026-DWI'...
    'JMD5-KK-20121220-DWI'...
    'JMD6-NO-20121220-DWI'...
    'LHON1-TK-20121130-DWI'...
    'LHON2-SO-20121130-DWI'...
    'LHON3-TO-20121130-DWI'...
    'LHON4-GK-20121130-DWI'...
    'LHON5-HS-20121220-DWI'...
    'LHON6-SS-20121221-DWI'...
    'JMD-Ctl-MT-20121025-DWI'...
    'JMD-Ctl-YM-20121025-DWI'...
    'JMD-Ctl-SY-20130222DWI'...
     'JMD-Ctl-HH-20120907DWI'...
    };

% Make directory structure for each subject
for ii = 1:length(subs)
    sub_dirs{ii} = fullfile(AFQdata, subs{ii},'dwi_2nd');
end

% Subject grouping is a little bit funny because afq only takes two groups
% but we have 3. For now we will divide it up this way but we can do more
% later
sub_group = [1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0];

% Now create and afq structure
afq = AFQ_Create('sub_dirs', sub_dirs, 'sub_group', sub_group, 'clip2rois', 0);

% Run AFQ on these subjects
afq = AFQ_run(sub_dirs, sub_group, afq);



return

% For this project we may not care about the other groups AFQ gives but we
% do care about the optic radiations. So lets add the optic radiations to
% the afq structure. Before running this save each subject's fiber tract
% and ROIs in the /fibers and /ROIs directory
%afq = AFQ_AddNewFiberGroup(afq,fgName,roi1Name,roi2Name,cleanFibers,computeVals)

% fgName = 'TamagawaDWI3_Lt_LGN_ctx_lh_pericalcarineMD3.pdb'; 
fgName = 'LOR_MD3.pdb';
roi1Name = 'Lt-LGN.mat'; 
roi2Name = 'ctx-lh-pericalcarine.mat';

afq = AFQ_AddNewFiberGroup(afq, fgName, roi1Name, roi2Name, 0, 1);

% % Add the new fiber groups and ROIs to the afq structure
% afq = AFQ_set(afq,'new fiber group', fgName);
% afq = AFQ_set(afq, 'new roi', roi1Name, roi2Name);
% % Get the fiber group number. This will be equal to the number of fiber
% % groups since it is the last one to be added
% fgNumber = AFQ_get(afq,'numfg');

return
%% add more fiber groups of opticradiation to afq structure
fgName = 'ROR_MD3.pdb';
% fgName = 'ROR_MD3.mat';

roi1Name = 'Rt-LGN.mat';
roi2Name = 'ctx-rh-pericalcarine.mat';

afq = AFQ_AddNewFiberGroup(afq, fgName, roi1Name, roi2Name, 0, 1);

% afq = AFQ_set(afq,'new fiber group', fgName);
% afq = AFQ_set(afq, 'new roi', roi1Name, roi2Name);

fgName = 'LOR_MD4.pdb';
roi1Name = 'Lt-LGN.mat'; 
roi2Name = 'ctx-lh-pericalcarine.mat';

afq = AFQ_AddNewFiberGroup(afq, fgName, roi1Name, roi2Name, 0, 1);



fgName = 'ROR_MD4.pdb';
roi1Name = 'Rt-LGN.mat';
roi2Name = 'ctx-rh-pericalcarine.mat';

afq = AFQ_AddNewFiberGroup(afq, fgName, roi1Name, roi2Name, 0, 1);

%%
fgName = 'ROR_MD2.pdb';
roi1Name = 'Rt-LGN.mat';
roi2Name = 'ctx-rh-pericalcarine.mat';

afq = AFQ_AddNewFiberGroup(afq, fgName, roi1Name, roi2Name, 0, 1);

fgName = 'LOR_MD2.pdb';
roi1Name = 'Rt-LGN.mat';
roi2Name = 'ctx-rh-pericalcarine.mat';

afq = AFQ_AddNewFiberGroup(afq, fgName, roi1Name, roi2Name, 0, 1);

%%
fgName = 'LOCF1000.pdb';
roi1Name = 'CC.mat';
roi2Name = 'ctx-lh-pericalcarine.mat';

afq = AFQ_AddNewFiberGroup(afq, fgName, roi1Name, roi2Name, 0, 1);

fgName = 'ROCF1000.pdb';
roi1Name = 'CC.mat';
roi2Name = 'ctx-rh-pericalcarine.mat';

afq = AFQ_AddNewFiberGroup(afq, fgName, roi1Name, roi2Name, 0, 1);


%% Here are some notes about the afq structure

% Lets load up the dt6 file for subject 13
dt = dtiLoadDt6(afq.files.dt6{12});

% Now let's load up the segmented fiber group for subject 13
% fg = dtiReadFibers(afq.files.fibers.clean{13}); % dtireadFibers for .mat,
% dtiLoadFiberGroup for .pdb 
% fg = dtiLoadFiberGroup(afq.files.fibers.LOR_MD3{12});
fg = fgRead(afq.files.fibers.LOR_MD3{12});

% Now let's render the left hemisphere ILF just to see it. The ILF is fiber
% group number 13. For time's sake we will onl`y render 100 fibers from the
% fiber group
AFQ_RenderFibers(fg, 'numfibers', 1000 ,'color', [.7 .7 1]);

% AFQ_RenderFibers(fg,'camera','coronal');

% 
AFQ_RenderFibers(fg,'dt',dt)

% Add a slice from the t1. The path to this image is saved in the dt6 file
t1 = niftiRead(dt.files.t1)
AFQ_AddImageTo3dPlot(t1, [5 0 0]);

AFQ_AddImageTo3dPlot(t1, [0 -30 0]);

% Now lets render a fiber group heatmapped for fa values.
% First get FA for each point of each fiber
% valName.  The current valname options are:
%    - 'fa' (fractional anisotropy) (DEFAULT)
%    - 'md' (mean diffusivity)
%    - 'eigvals' (triplet of values for 1st, 2nd and 3rd eigenvalues)
%    - 'shapes' (triplet of values indicating linearity, planarity and
%              spherisity)
%    - 'dt6' (the full tensor in [Dxx Dyy Dzz Dxy Dxz Dyz] format
%    - 'pdd' (principal diffusion direction)
%    - 'linearity'
%    - 'fa md pdd', 'fa md ad rd', 'fa md pdd dt6'
%    - 'fa md ad rd shape'

vals = dtiGetValFromFibers(dt.dt6,fg(16),inv(dt.xformToAcpc),'fa');
vals = dtiGetValFromFibers(dt.dt6,fg,inv(dt.xformToAcpc),'fa');

% val_fa = dtiGetValFromFibers(dt.dt6,fg,inv(dt.xformToAcpc),'fa');
% val_md = dtiGetValFromFibers(dt.dt6,fg,inv(dt.xformToAcpc),'md');
% val_ad = dtiGetValFromFibers(dt.dt6,fg,inv(dt.xformToAcpc),'ad');
% val_rd = dtiGetValFromFibers(dt.dt6,fg,inv(dt.xformToAcpc),'rd');
% val_pdd = dtiGetValFromFibers(dt.dt6,fg,inv(dt.xformToAcpc),'pdd');
% val_dt6 = dtiGetValFromFibers(dt.dt6,fg,inv(dt.xformToAcpc),'dt6');
% val_shapes = dtiGetValFromFibers(dt.dt6,fg,inv(dt.xformToAcpc),'shapes');

% Then convert each fa value to a color
rgb = vals2colormap(vals); %val_fa, val_md, val_ad...

% Now render the fibers colored based on fa
% AFQ_RenderFibers(fg(13), 'numfibers', 100 ,'color', rgb);
AFQ_RenderFibers(fg, 'numfibers', 1000 ,'color', rgb);
AFQ_AddImageTo3dPlot(t1, [-10 0 0]);

% Now let's render the tract profile meaning the values along the fiber
% core. Let's dop it for a new tract. how about the inferior fronto
% occipital fasciculus
% AFQ_RenderFibers(fg(11), 'numfibers',200 ,'dt', dt, 'radius', [.5 3]);
AFQ_RenderFibers(fg, 'numfibers',200 ,'dt', dt, 'radius', [.5 3]);
AFQ_AddImageTo3dPlot(t1, [-10 0 0]);

% Now let's render the RD profile

AFQ_RenderFibers(fg, 'numfibers',200 ,'dt', dt, 'radius', [.5 3],'val','fa','crange',[.5 .6]);
AFQ_AddImageTo3dPlot(t1, [-10 0 0]);

% Let's add an ROI to the plot
[roi1 roi2] = AFQ_LoadROIs(1,[], afq);

AFQ_RenderRoi(roi1, [1 0 0])

%% Here are some aditional notes on our fiber group structure

% Your optic radiations fiber groups each contain just a single fiber group
LOR = dtiLoadFiberGroup(afq.files.fibers.LOR_MD3{12});

% While the "MoriGroups.mat" fiber group contains 20 fiber groups in it
mori = dtiLoadFiberGroup(afq.files.fibers.clean{12})





