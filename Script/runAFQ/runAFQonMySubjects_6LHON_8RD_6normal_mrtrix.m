function runAFQonMySubjects_6LHON_8RD_6normal_mrtrix
% Run AFQ_run for these subjects
% set directories

[AFQdata, subs] = Tama_subj2;
%% Make directory structure for each subject
for ii = 1:length(subs)
    sub_dirs{ii} = fullfile(AFQdata, subs{ii},'dwi_2nd');
end

% Subject grouping is a little bit funny because afq only takes two groups
% but we have 3. For now we will divide it up this way but we can do more
% later
a = ones(1,39);
b = [16:23,31:33,35:37];
a(1,b) = 0; 
sub_group = a;
% sub_group = [1,0];

% Now create and afq structure
afq = AFQ_Create('sub_dirs', sub_dirs, 'sub_group', sub_group, 'clip2rois', 0);
% if you would like to use ants for normalization
% afq = AFQ_Create('sub_dirs', sub_dirs, 'sub_group', sub_group, 'clip2rois', 0,'normalization','ants');

% % To have afq overwrite the old fibers
% afq = AFQ_set(afq,'overwritesegmentation');
% afq = AFQ_set(afq,'overwritecleaning');

% % afq.params.cutoff=[5 95];
% afq.params.outdir = ...
%     fullfile(AFQdata,'/AFQ_results/6LHON_9JMD_8Ctl');
% afq.params.outname = 'AFQ_6LHON_9JMD_8Ctl_1015.mat';

%% Run AFQ on these subjects
% afq = AFQ_run(sub_dirs, sub_group, afq);

%%
% For this project we may not care about the other groups AFQ gives but we
% do care about the optic radiations. So lets add the optic radiations to
% the afq structure. Before running this save each subject's fiber tract
% and ROIs in the /fibers and /ROIs directory
%afq = AFQ_AddNewFiberGroup(afq,fgName,roi1Name,roi2Name,cleanFibers,computeVals)

% %% add more fiber groups of opticradiation to afq structure
%

%%
% % I would like to copy fg files form inside conTrack directory to fiber
% % directory.
% for ii = 1:length(subs);
%     
%     formFgDir = fullfile( afq.sub_dirs{ii} ,'/fibers/conTrack/OR_Top100K_V1_3mm_clipped_LGN4mm');
%     goFgDir = fullfile(afq.sub_dirs{ii} ,'fibers');
%     fgfiles = fullfile( formFgDir,'*OR_0711_Ctr*.pdb');
%     
%     copyfile(fgfiles, goFgDir)
% end
%%
for ii =1:length(subs) %7 doesnt work
    fromDir = fullfile(afq.sub_dirs{ii} ,'/fibers/mrtrix2');
    toDir  = fullfile(afq.sub_dirs{ii} ,'/fibers');
    cd(fromDir)
    %     RFgf = dir('*R-OR_0711_Ctr*.pdb');
    %     LFgf = dir('*R-OR_0711_Ctr*.pdb');
    
    RFgfFrom = dir('dwi2nd_aligned_trilin_csd_lmax2_Rt-LGN4_rh_V1_smooth3mm_NOT_Rt-LGN*_Rt-LGN4_prob.pdb');
    LFgfFrom = dir('dwi2nd_aligned_trilin_csd_lmax2_Lt-LGN4_lh_V1_smooth3mm_NOT_Lt-LGN*_Lt-LGN4_prob.pdb');
    fgR = fgRead(RFgfFrom.name);
    fgL = fgRead(LFgfFrom.name);
    
    cd(toDir) 
    fgR.name = 'ROR_mrt';
    fgL.name = 'LOR_mrt';

    fgWrite(fgR ,[fgR.name, '.pdb'],'pdb' );
    fgWrite(fgL ,[fgL.name, '.pdb'],'pdb' );
    
end

% %% ADD ROR
% for j = size(RFgfTo,2)
%         fgName   = RFgfTo{j};
%         
%         roi1Name= 'Rt-LGN.mat';
%         roi2Name = 'rh_V1_smooth3mm_NOT.mat';
%         afq = AFQ_AddNewFiberGroup_2(afq, fgName, roi1Name, roi2Name, 1, 1,[],[]);
%         
%         
%         fgName   = LFgfTo{j};
%         roi1Name = 'Lt-LGN.mat';
%         roi2Name = 'lh_V1_smooth3mm_NOT.mat';
%         afq = AFQ_AddNewFiberGroup_2(afq, fgName, roi1Name, roi2Name, 1, 1,[],[]);
% end
%    
%% ADD OR mrt
fgName   = 'ROR_mrt.pdb';

roi1Name= 'Rt-LGN4.mat';
roi2Name = 'rh_V1_smooth3mm_NOT.mat';
afq = AFQ_AddNewFiberGroup_2(afq, fgName, roi1Name, roi2Name, 1, 1);
% afq = AFQ_AddNewFiberGroup_2(afq, fgName, roi1Name, roi2Name, 0, 1,[],[],1);


fgName   = 'LOR_mrt.pdb';
roi1Name = 'Lt-LGN4.mat';
roi2Name = 'lh_V1_smooth3mm_NOT.mat';
afq = AFQ_AddNewFiberGroup_2(afq, fgName, roi1Name, roi2Name,1, 1);

save afq_ORmrt_2.mat afq
%% ADD OR BigNotROI
fgName   = 'RORV13mmClipBigNotROI5_clean.pdb';

roi1Name= 'Rt-LGN.mat';
roi2Name = 'rh_V1_smooth3mm_NOT.mat';
afq = AFQ_AddNewFiberGroup_2(afq, fgName, roi1Name, roi2Name, 0, 1);
% afq = AFQ_AddNewFiberGroup_2(afq, fgName, roi1Name, roi2Name, 0, 1,[],[],1);


fgName   = 'LORV13mmClipBigNotROI5_clean.pdb';
roi1Name = 'Lt-LGN.mat';
roi2Name = 'lh_V1_smooth3mm_NOT.mat';
afq = AFQ_AddNewFiberGroup_2(afq, fgName, roi1Name, roi2Name,0, 1);


%% OCF
fgName = 'OCFV1V2Not3mm_MD4.pdb';

roi1Name= 'lh_V1_smooth3mm_lh_V2_smooth3mm_NOT.mat';
roi2Name = 'rh_V1_smooth3mm_rh_V2_smooth3mm_NOT.mat';
afq = AFQ_AddNewFiberGroup_2(afq, fgName, roi1Name, roi2Name, 1, 1);

%% OT

fgName = 'ROT100_clean.pdb';
roi1Name = 'Optic-Chiasm.mat';
roi2Name = 'Rt-LGN4.mat';
afq = AFQ_AddNewFiberGroup_2(afq, fgName, roi1Name, roi2Name, 0, 1);


fgName = 'LOT100_clean.pdb';
roi1Name = 'Optic-Chiasm.mat';
roi2Name = 'Lt-LGN4.mat';

afq = AFQ_AddNewFiberGroup_2(afq, fgName, roi1Name, roi2Name, 1, 1);


