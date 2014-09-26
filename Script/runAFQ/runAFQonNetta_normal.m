%% set directories

AFQdata ='/biac3/wandell4/data/reading_longitude/dti_adults';

subs = {'aab050307','ah051003','am090121','ams051015','as050307'...
                'aw040809','bw040922','ct060309','db061209','dla050311'... 
                'gd040901','gf050826','gm050308','jl040902','jm061209'...
                'jy060309','ka040923','mbs040503','me050126','mo061209'...    
                'mod070307','mz040828','pp050208','rfd040630','rk050524'...
                'sc060523','sd050527','sn040831','sp050303','tl051015'};

% Make directory structure for each subject
for ii = 1:length(subs)
    sub_dirs{ii} = fullfile(AFQdata, subs{ii},'dti06');
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

% Lets load up the dt6 file for subject 13
dt = dtiLoadDt6(afq.files.dt6{13});

% Now let's load up the segmented fiber group for subject 13
fg = dtiReadFibers(afq.files.fibers.clean{13});

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












