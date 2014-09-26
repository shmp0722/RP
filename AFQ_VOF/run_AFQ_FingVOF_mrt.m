%% Run AFQ_FindVOF
%% difine argument
[homeDir,subDir] = Tama_subj;

parfor i = 2:length(subDir)
    %% load files
    % whole brain connectome
    wholebrainfgPath =fullfile(homeDir,subDir{i},...
        '/dwi_2nd/fibers/life_mrtrix/dwi2nd_aligned_trilin_csd_lmax2_dwi2nd_aligned_trilin_brainmask_dwi2nd_aligned_trilin_wm_prob-500000.pdb');
    
    if ~exist(wholebrainfgPath);
        display([subDir{i},'-- Has No Whole brain connectome']);
    else
        
        
        % transform WB.pdb to WB.mat
        [a,b,c]=fileparts(wholebrainfgPath);
        cd(a)
        Pdb2mat(wholebrainfgPath);
        wholebrainfgPath = [a,'/', b, '.mat'];
        % dt and T1
        dt = fullfile(homeDir,subDir{i},'/dwi_2nd/dt6.mat');
        dt = dtiLoadDt6(dt);
        t1 = niftiRead(dt.files.t1);
        %% take several ROI from fs segmentation file
        outDir = fullfile(homeDir,subDir{i},'/dwi_2nd/fsROIs');
        fsROIdir = outDir;
        
        if ~exist(outDir); mkdir(outDir)
            fsIn = fullfile(homeDir,'/freesurfer',subDir{i},'/mri/aparc+aseg.nii.gz');
            type = 'mat';
            fs_roisFromAllLabels(fsIn,outDir,type,[])
        end
        
        %% get L,R-arcuate from WB
        WB = fgRead(wholebrainfgPath);
        
        Atlas=[];
        antsInvWarp = 0;
        useRoiBasedApproach=[4 0];
        useInterhemisphericSplit=true;        
        
        [fg_classified,fg_unclassified,classification,fg] = ...
            AFQ_SegmentFiberGroups(dt, WB, Atlas, ...
            useRoiBasedApproach, useInterhemisphericSplit, antsInvWarp);
        
        L_arcuate =fg_classified(1,19);
        R_arcuate =fg_classified(1,20);
        
        % clean up arcuates
        L_arcuate = AFQ_removeFiberOutliers(L_arcuate,3,3,25);
        R_arcuate = AFQ_removeFiberOutliers(R_arcuate,3,3,25);
        
        %% AFQ_FindVOF
        %
        outdir  =   fullfile(homeDir,subDir{i},'/dwi_2nd/fibers/life_mrtrix');
        thresh = [.95 .6];
        v_crit = 1.3;
        
        [L_VOF, R_VOF, L_pArc, R_pArc, L_pArc_vot, R_pArc_vot] = AFQ_FindVOF(wholebrainfgPath,L_arcuate,R_arcuate,fsROIdir,outdir,thresh,v_crit, dt);
        
        % %% fiber check
        % % VOF
        % c=jet(8);
        %
        % AFQ_RenderFibers(L_VOF,'color', c(5,:))
        % AFQ_RenderFibers(R_VOF,'newfig',0,'color', c(6,:))
        %
        % AFQ_AddImageTo3dPlot(t1, [0, 0, -30]);
        % AFQ_AddImageTo3dPlot(t1, [1, 0, 0]);
        % view(-11,32)
        %
        % %%
        % AFQ_RenderFibers(L_arcuate,'color', c(5,:),'numfibers',100)
        % AFQ_RenderFibers(R_arcuate,'newfig',0,'color', c(6,:),'numfibers',100)
        %
        % AFQ_AddImageTo3dPlot(t1, [0, 0, -30]);
        % AFQ_AddImageTo3dPlot(t1, [1, 0, 0]);
        % view(-11,32)
        %
        %
        % %% Vert
        % AFQ_RenderFibers(L_fg_vert,'color', c(1,:))
        % AFQ_RenderFibers(R_fg_vert,'newfig',0,'color', c(2,:))
        %
        % AFQ_AddImageTo3dPlot(t1, [0, 0, -30]);
        % AFQ_AddImageTo3dPlot(t1, [1, 0, 0]);
        % view(-11,32)
        % %% pArc
        % AFQ_RenderFibers(L_pArc,'color', c(3,:))
        % AFQ_RenderFibers(R_pArc,'newfig',0,'color', c(4,:))
        %
        % AFQ_AddImageTo3dPlot(t1, [0, 0, -30]);
        % AFQ_AddImageTo3dPlot(t1, [1, 0, 0]);
        % view(-11,32)
        %% Save 6 tracts
        cd(a)
        if ~exist('VOF');mkdir('VOF');end;
        cd('VOF')
        FG = {L_VOF, R_VOF, L_pArc, R_pArc, L_pArc_vot, R_pArc_vot};
        % save all tracts
        for k = 1: length(FG)
            fgWrite(FG{k})
        end
    end
end