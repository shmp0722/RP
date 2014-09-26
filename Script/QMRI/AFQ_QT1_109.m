function [afq, patient_data, control_data, norms, abn, abnTracts]  = AFQ_QT1_109
% set directories
AFQdata = '/biac4/wandell/biac2/wandell/data/DWI-Tamagawa-Japan';
saveDir = '/biac2/wandell2/data/WH/109_SO';

%% T1 align method using FSL
% http://fsl.fmrib.ox.ac.uk/fsl/fsl-4.1.9/flirt/examples.html
% cd(T1 map directory) 
% run below code on command line
% flirt -in T1_map_lsq_SIEMENS.nii.gz -ref T1_map_lsq_GE.nii.gz -out T1_map_lsq_SIEMENS_alignedGE.nii.gz -omat inSIEMENSrefGE.mat

%% set T1 and T1w files from GE and Siemens
% T1
% SO_SMNS_T1map     = '/biac2/wandell2/data/WH/109_SO/Qmr/130328_SIEMENS/SPGR_1/Align_2.0312_2.0312_2/T1_map_lsq.nii.gz';
% SO_SMNS_T1map     ='/biac4/wandell/biac2/wandell/data/DWI-Tamagawa-Japan/QuantitativeT1/SO_tmp_vibe/SPGR_1/Align_2.0312_2.0312_2/T1_map_lsq.nii.gz';
% SO_SMNS_T1map     = '/biac4/wandell/biac2/wandell/data/DWI-Tamagawa-Japan/QuantitativeT1/SO_tmp_vibe/SPGR_1/Align_2.0312_2.0312_2/T1map_acpc.gz';
% SO_SMNS_T1map     = '/biac4/wandell/biac2/wandell/data/DWI-Tamagawa-Japan/QuantitativeT1/SO_GE_SIEMENS_comparison/T1_map_lsq_SIEMENS_alignedGE.nii.gz';
SO_SMNS_T1map = '/biac4/wandell/biac2/wandell/data/DWI-Tamagawa-Japan/QuantitativeT1/SO_GE_KendrickUtility_Feb11/SPGR_1/Align_2.0312_2.0312_2/T1_map_lsq.nii.gz';

%%

% /biac2/wandell2/data/WH/109_SO/Qmr/20131003_5569/SPGR_1/Align_0.9375_0.9375_1/
% HH_GE_T1map       = '/biac2/wandell2/data/WH/109_SO/Qmr/20130226_4024/SPGR_1/Align_0.9375_0.9375_1/maps/T1_map_lsq.nii.gz';
% SO_GE_T1map       = '/biac2/wandell2/data/WH/109_SO/Qmr/20131003_5569/SPGR_1/Align_0.9375_0.9375_1/maps/T1_map_lsq.nii.gz';
SO_GE_T1map       = '/biac4/wandell/biac2/wandell/data/DWI-Tamagawa-Japan/QuantitativeT1/SO_GE_SIEMENS_comparison/T1_map_lsq_GE.nii.gz';
 
%% mrAnatResampleToNifti

    % Up sample
    basedir = pwd;
    originalResNifti = SO_SMNS_T1map;
    finalResNifti    = SO_GE_T1map;
    fname            = fullfile(basedir,'SMNS_upsampled.nii.gz');
    res_up              = mrAnatResampleToNifti(originalResNifti, finalResNifti,fname);

    
    %% down sample
    basedir = pwd;
    originalResNifti = SO_GE_T1map;
    finalResNifti    = SO_SMNS_T1map;
    fname            = fullfile(basedir,'GE_downsampled.nii.gz');
    res_down              = mrAnatResampleToNifti(originalResNifti, finalResNifti,fname);


%%
% SO_GE_T1map_New   = '/biac2/wandell2/data/WMDevo/code/CompareMaps/HH_GE2Siemens/WarpMan_T1_map_lsq.nii.gz';

% T1w
% SO_SMNS_T1w = '/biac4/wandell/biac2/wandell/data/DWI-Tamagawa-Japan/JMD-Ctl-SO-20130726-DWI/t1.nii.gz';
% SO_GE_T1w   = '/biac2/wandell2/data/WH/109_SO/Qmr/20130226_4024/SPGR_1/Align_0.9375_0.9375_1/T1wfs_4.nii.gz';
% SO_GE_T1w   = '/biac2/wandell2/data/WH/109_SO/Qmr/20131003_5569/SPGR_1/Align_0.9375_0.9375_1/T1wfs_4.nii.gz';

% Diffusion
% dtDir = '/biac2/wandell2/data/WH/109_SO/DTI/dti96rt';
dtDir = '/biac4/wandell/biac2/wandell/data/DWI-Tamagawa-Japan/JMD-Ctl-SO-20130726-DWI/dwi_2nd';

% Make directory structure for each subject
sub_dirs{1} = dtDir;
sub_dirs{2} = dtDir;
% sub_dirs{3} = dtDir;


% Subject grouping 
sub_group = [1 0 ];

% % Now create and afq structure
afq = AFQ_Create('sub_dirs', sub_dirs, 'sub_group', sub_group);%, 'clip2rois', 1);
% if you would like to use ants for normalization
% afq = AFQ_Create('sub_dirs', sub_dirs, 'sub_group', sub_group, 'clip2rois', 0,'normalization','ants');

% To have afq overwrite the old fibers
% afq = AFQ_set(afq,'overwritesegmentation',1);
% afq = AFQ_set(afq,'overwritecleaning',1);

% afq = AFQ_set(afq,'overwritesegmentation',0);
% afq = AFQ_set(afq,'overwritecleaning',0);

% % afq.params.cutoff=[0 90];
% afq.params.outdir = ...
%     fullfile(saveDir);
% afq.params.outname = 'AFQ_comparison_qMR_SIEMENS_GE_109.mat';

% for ii = 1:length(sub_dirs)
%     t1Path{ii} = fullfile(sub_dirs{ii}, 't1_map.nii.gz'), end

% add additional maps to the structure.

% t1Path{1} = res_up.fname;
t1Path{1} = res_down.fname;


t1Path{2} = SO_GE_T1map;
afq = AFQ_set(afq, 'images', t1Path);


% t1Path{3} = SO_GE_T1map_New;

% t1wPath{1} = SO_SMNS_T1w;
% t1wPath{2} = SO_GE_T1w;

afq = AFQ_set(afq, 'images', t1Path);
% afq = AFQ_set(afq, 'images', t1wPath);


%% Run AFQ on these subjects
% [afq, patient_data, control_data, norms, abn, abnTracts] =  AFQ_run_forHH(sub_dirs, sub_group, afq);
[afq, patient_data, control_data, norms, abn, abnTracts] =  AFQ_run_forHH(sub_dirs, sub_group, afq);


return
save afq_resdown afq


%% plots QT1 value in each fiber group
for ii = 1:20;
    figure(ii);hold on;
    X = 1:100;
%     Y1 = afq.vals.T1_map_lsq{ii}(1,:);
%     Y2 = afq.vals.T1_map_lsq{ii}(2,:);
    
    Y1 = afq.vals.SMNS_upsampled{ii}(1,:);
    Y2 = afq.vals.SMNS_upsampled{ii}(2,:);
    
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

%% plots QT1 value in each fiber group
for ii = 1:20;
    figure(ii);hold on;
    X = 1:100;
%     Y1 = afq.vals.T1_map_lsq{ii}(1,:);
%     Y2 = afq.vals.T1_map_lsq{ii}(2,:);
    
    Y1 = afq.vals.GE_downsampled{ii}(1,:);
    Y2 = afq.vals.GE_downsampled{ii}(2,:);
    
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

