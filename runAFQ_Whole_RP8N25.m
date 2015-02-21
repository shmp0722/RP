function afq = runAFQ_Whole_RP8N25
%% Checking if these subjects have OR and OT files

[homeDir,subDir,JMD,CRD,LHON,Ctl,RP,AMDC] = Tama_subj2;

% Pick up subject

Control = [Ctl,AMDC];
subnumber = [RP,Control];

% AFQ
for jj = 1: length(subnumber)
    sub_dirs{jj} = fullfile(homeDir, subDir{subnumber(jj)},'dwi_2nd');
end
% Subject grouping is a little bit funny because afq only takes two groups
% but we have 3. For now we will divide it up this way but we can do more
% later
a = zeros(1,length(subnumber));
% b = [16:23,31:33,35:37];
a(1,1:length(RP)) = 1; 
sub_group = a;
% sub_group = [1,0];

% Now create and afq structure
afq = AFQ_Create('sub_dirs', sub_dirs, 'sub_group', sub_group);
% if you would like to use ants for normalization
% afq = AFQ_Create('sub_dirs', sub_dirs, 'sub_group', sub_group, 'clip2rois', 0,'normalization','ants');

afq = AFQ_set(afq,'outdir','/sni-storage/wandell/biac2/wandell/data/DWI-Tamagawa-Japan2/RP');
% afq = AFQ_set(afq,'outname','afq_8RP_25Normal_02132015_2');
afq = AFQ_set(afq,'outname','afq_Whole_8RP_25Normal_02202015');
afq.params.run_mode = 'mrtrix';

%% load Callosal afq structure
load(fullfile(afq.params.outdir,'afq_Callosal_8RP25Normal_02182015.mat'))

afq = AFQ_set(afq,'outdir','/sni-storage/wandell/biac2/wandell/data/DWI-Tamagawa-Japan2/RP');
% afq = AFQ_set(afq,'outname','afq_8RP_25Normal_02132015_2');
afq = AFQ_set(afq,'outname','afq_Whole_8RP_25Normal_02202015');
afq.params.run_mode = 'mrtrix';
afq.params.maxDist = 4;
%% Run AFQ on these subjects

[afq patient_data control_data norms abn abnTracts] = AFQ_run(sub_dirs, sub_group, afq);


%% Add OT and OR

afq.params.clip2rois = 0;
afq.params.cleanFibers = 0;
afq.params.computenorms = 0;

% Fg = {'LOTD3L2_1206.pdb','LOTD4L4_1206.pdb','LOR1206_D4L4.pdb','ROTD3L2_1206.pdb','ROTD4L4_1206.pdb','ROR1206_D4L4.pdb'};
Fg = {'LOTD4L4_1206.pdb','ROTD4L4_1206.pdb','LOR1206_D4L4.pdb','ROR1206_D4L4.pdb'};

% afq = AFQ_AddNewFiberGroup(afq, fgName, roi1Name, roi2Name, [cleanFibers = true], ...
%          [computeVals = true], [showFibers = false], [segFgName = 'WholeBrainFG.mat'] ...
%          [overwrite = false])

% L-optic tract
fgName =  Fg{1};
roi1Name = '85_Optic-Chiasm.mat';
roi2Name = 'Lt-LGN4.mat';

afq = SO_AFQ_AddNewFiberGroup(afq, fgName, roi1Name, roi2Name, 0, 1,0,[],0);
% afq = AFQ_AddNewFiberGroup(afq, fgName, roi1Name, roi2Name, 0, 1,0,[],0);

% R-optic tract
fgName =  Fg{2};
roi1Name = '85_Optic-Chiasm.mat';
roi2Name = 'Rt-LGN4.mat';

afq = SO_AFQ_AddNewFiberGroup(afq, fgName, roi1Name, roi2Name, 0, 1,0,[],0);

% L-optic radiation
fgName =  Fg{3};
roi1Name = 'Lt-LGN4.mat';
roi2Name = 'lh_V1_smooth3mm_NOT.mat';

afq = SO_AFQ_AddNewFiberGroup(afq, fgName, roi1Name, roi2Name, 0, 1,0,[],0);

% R-optic radiation
fgName =  Fg{4};
roi1Name = 'Rt-LGN4.mat';
roi2Name = 'rh_V1_smooth3mm_NOT.mat';

afq = SO_AFQ_AddNewFiberGroup(afq, fgName, roi1Name, roi2Name, 0, 1,0,[],0);

%% save

save /sni-storage/wandell/biac2/wandell/data/DWI-Tamagawa-Japan2/RP/afq_8RP25Normal_02132015_4 afq

%% Compute norms
[norms, patient_data, control_data, afq] = AFQ_ComputeNorms(afq);

% %%
% cutoff   = 5;
% property = 'fa';
% comp     = 'profile';
% 
% [abn abnTracts] = AFQ_ComparePatientsToNorms(patient_data, norms, cutoff, property, comp);


