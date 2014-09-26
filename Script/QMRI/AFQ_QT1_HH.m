%% AFQ_QT1_HH.m
% set directories
AFQdata = '/biac4/wandell/biac2/wandell/data/DWI-Tamagawa-Japan';
saveDir = '/biac2/wandell2/data/WH/069_HH';

%%
% T1
HH_SMNS_T1map     = '/biac2/wandell2/data/WH/069_HH/Qmr/130328_SIEMENS/SPGR_1/Align_2.0312_2.0312_2/T1_map_lsq.nii.gz';
HH_GE_T1map       = '/biac2/wandell2/data/WH/069_HH/Qmr/20130226_4024/SPGR_1/Align_0.9375_0.9375_1/maps/T1_map_lsq.nii.gz';
HH_GE_T1map_New   = '/biac2/wandell2/data/WMDevo/code/CompareMaps/HH_GE2Siemens/WarpMan_T1_map_lsq.nii.gz';

% T1w
HH_SMNS_T1w = '/biac2/wandell2/data/WH/069_HH/Qmr/130328_SIEMENS/SPGR_1/Align_2.0312_2.0312_2/T1wfs_4.nii.gz';
HH_GE_T1w   = '/biac2/wandell2/data/WH/069_HH/Qmr/20130226_4024/SPGR_1/Align_0.9375_0.9375_1/T1wfs_4.nii.gz';

% Diffusion
dtDir = '/biac2/wandell2/data/WH/069_HH/DTI/dti96rt';

% Make directory structure for each subject
sub_dirs{1} = dtDir;
sub_dirs{2} = dtDir;
sub_dirs{3} = dtDir;


% Subject grouping 
sub_group = [1 0 0];

% % Now create and afq structure
% afq = AFQ_Create('sub_dirs', sub_dirs, 'sub_group', sub_group, 'clip2rois', 0);
% if you would like to use ants for normalization
afq = AFQ_Create('sub_dirs', sub_dirs, 'sub_group', sub_group, 'clip2rois', 1,'normalization','ants');

% To have afq overwrite the old fibers
% afq = AFQ_set(afq,'overwritesegmentation',1);
% afq = AFQ_set(afq,'overwritecleaning',1);

% afq = AFQ_set(afq,'overwritesegmentation',0);
% afq = AFQ_set(afq,'overwritecleaning',0);

% afq.params.cutoff=[0 90];
afq.params.outdir = ...
    fullfile(saveDir);
afq.params.outname = 'AFQ_QT1_HH_4.mat';

% add additional maps to the structure.
t1Path{1} = HH_SMNS_T1map;
t1Path{2} = HH_GE_T1map;
t1Path{3} = HH_GE_T1map_New;

t1wPath{1} = HH_SMNS_T1w;
t1wPath{2} = HH_GE_T1w;

afq = AFQ_set(afq, 'images', t1Path);
% afq = AFQ_set(afq, 'images', t1wPath);


%% Run AFQ on these subjects
afq = AFQ_run_forHH(sub_dirs, sub_group, afq);
return
%% plots QT1 value in each fiber group
for ii = 1:20;
    figure(ii);hold on;
    X = 1:100;
    Y1 = afq.vals.T1_map_lsq{ii}(1,:);
    Y2 = afq.vals.T1_map_lsq{ii}(2,:);
%     Y3 = afq.vals.T1_map_lsq{ii}(3,:);
    
    c = lines(3);
    
    plot(X,Y1,'Color',c(1,:),'linewidth',3);
    plot(X,Y2,'Color',c(2,:),'linewidth',3);
%     plot(X,Y3,'Color',c(3,:),'linewidth',3);
    
    label = 'Quantitative T1'

    % scale the axes and name them
    %         axis(axisScale);
    xlabel('Location','fontName','Times','fontSize',12);
    ylabel(label,'fontName','Times','fontSize',12)
    title(afq.fgnames{ii},'fontName','Times','fontSize',14)
    set(gcf,'Color','w');
    set(gca,'Color',[.9 .9 .9],'fontName','Times','fontSize',12)
    legend('SMNS','GE');
    
    hold off;
end

%% plots QT1w value in each fiber group
for ii = 1:20;
    figure(ii);hold on;
    X = 1:100;
    Y1 = afq.vals.T1wfs_4{ii}(1,:);
    Y2 = afq.vals.T1wfs_4{ii}(2,:);
    
    plot(X,Y1,X,Y2);
    label = 'Quantitative T1w'
    
    % scale the axes and name them
    axis('auto');
    xlabel('Location','fontName','Times','fontSize',12);
    ylabel(label,'fontName','Times','fontSize',12)
    title(afq.fgnames{ii},'fontName','Times','fontSize',12)
    set(gcf,'Color','w');
    set(gca,'Color',[.9 .9 .9],'fontName','Times','fontSize',12)
    
    
    hold off;
end

%%

