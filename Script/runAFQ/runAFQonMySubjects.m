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
    'JMD-Ctl-HH-20120907DWI'
    };

% Make directory structure for each subject
for ii = 1:length(subs)
    sub_dirs{ii} = fullfile(AFQdata, subs{ii},'dwi_1st');
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

afq = AFQ_AddNewFiberGroup(afq, 'L_OpticRadiation_final.mat', 'Lt-LGN.mat', 'ctx-lh-pericalcarine.mat', 0, 1);

% afq = AFQ_AddNewFiberGroup(afq, 'L_OpticRadiation_final.mat', 'Rt-LGN.mat', 'ctx-rh-pericalcarine.mat', 0, 1);

return

%% Here are some notes about the afq structure

% Lets load up the dt6 file for subject 1
dt = dtiLoadDt6(afq.files.dt6{1});

% Now let's load up the segmented fiber group for subject 1
fg = dtiReadFibers(afq.files.fibers.clean{1});

% Now let's render the left hemisphere ILF just to see it. The ILF is fiber
% group number 13. For time's sake we will only render 100 fibers from the
% fiber group
AFQ_RenderFibers(fg(13), 'numfibers', 100 ,'color', [.7 .7 1]);

% Add a slice from the t1. The path to this image is saved in the dt6 file
t1 = niftiRead(dt.files.t1)
AFQ_AddImageTo3dPlot(t1, [5 0 0]);

% Now lets render a fiber group heatmapped for fa values.
% First get FA for each point of each fiber
vals = dtiGetValFromFibers(dt.dt6,fg(13),inv(dt.xformToAcpc),'fa');
% Then convert each fa value to a color
rgb = vals2colormap(vals);
% Now render the fibers colored based on fa
AFQ_RenderFibers(fg(13), 'numfibers', 100 ,'color', rgb);
AFQ_AddImageTo3dPlot(t1, [-10 0 0]);

% Now let's render the tract profile meaning the values along the fiber
% core. Let's dop it for a new tract. how about the inferior fronto
% occipital fasciculus
AFQ_RenderFibers(fg(11), 'numfibers',200 ,'dt', dt, 'radius', [.5 3]);
AFQ_AddImageTo3dPlot(t1, [-10 0 0]);

% Now let's render the RD profile

AFQ_RenderFibers(fg(11), 'numfibers',100 ,'dt', dt, 'radius', [.5 3],'val','rd','crange',[.5 .6]);
AFQ_AddImageTo3dPlot(t1, [-10 0 0]);

% Let's add an ROI to the plot
[roi1 roi2] = AFQ_LoadROIs(11,[], afq);

AFQ_RenderRoi(roi1, [1 0 0])












