function runAFQonMySubjects_6LHON_9MD_8normal_3RP_1206
% Run AFQ_run for these subjects
%
%% set directory
AFQdata = '/biac4/wandell/biac2/wandell/data/DWI-Tamagawa-Japan';

subs = {...
    'JMD1-MM-20121025-DWI'
    'JMD3-AK-20121026-DWI'
    'JMD5-KK-20121220-DWI'
    'JMD6-NO-20121220-DWI'
    'JMD2-KK-20121025-DWI'
    'JMD4-AM-20121026-DWI'
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
    'JMD-Ctl-YM-20121025-DWI'
    'JMD-Ctl-SY-20130222DWI'
    'JMD-Ctl-HH-20120907DWI'
    'JMD-Ctl-HT-20120907-DWI'
    'JMD-Ctl-FN-20130621-DWI'
    'JMD-Ctl-AM-20130726-DWI'
    'JMD-Ctl-SO-20130726-DWI'
     'RP1-TT-2013-11-01'
    'RP2-KI-2013-11-01'
     'RP3-TO-13120611-DWI'};

%% Make directory structure for each subject
for ii = 1:length(subs)
    sub_dirs{ii} = fullfile(AFQdata, subs{ii},'dwi_2nd');
end

% Subject grouping is a little bit funny because afq only takes two groups
% but we have 3. For now we will divide it up this way but we can do more
% later

sub_group = [1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 1 1 1 ];
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

% %% Run AFQ on these subjects
% afq = AFQ_run_parfor(sub_dirs, sub_group, afq);
% return

%%
% %% Compute tract profiles
% 
% % Difine fgName
% fgN = {'*-Rh_NOT1201_D4_L4.pdb', '*-Lh_NOT1201_D4_L4.pdb'};
% saveN = {'LOR1206_D4L4','ROR1206_D4L4'};
% roi1Name = {'Lt-LGN4.mat','Rt-LGN4.mat'};
% roi2Name = {'lh_V1_smooth3mm_NOT.mat', 'rh_V1_smooth3mm_NOT.mat'};
% 
%  
% for ii = 1:AFQ_get(afq,'numsubs')
%     SubDir = fullfile(AFQdata,subs{ii});
%     fgDir  = fullfile(SubDir,'/dwi_2nd/fibers/conTrack/OR_1130');
%     fiberDir = fullfile(SubDir,'/dwi_2nd/fibers');
%     for k= 1:length(fgN)
%         cd(fgDir)
%         fgF = dir(fgN{k});
%         fg = fgRead(fgF.name);
%         fg = SO_AlignFiberDirection(fg,'AP');
%         cd(fiberDir)
%         fg.name = saveN{k};
%         fgWrite(fg,[fg.name '.pdb'],'pdb')
%         
%     end
% end
% return
%% OR

fgName   = 'ROR1206_D4L4.pdb';

roi1Name= 'Rt-LGN4.mat';
roi2Name = 'rh_V1_smooth3mm_NOT.mat';
afq = AFQ_AddNewFiberGroup_2(afq, fgName, roi1Name, roi2Name, 0, 1);

fgName   = 'LOR1206_D4L4.pdb';
roi1Name = 'Lt-LGN4.mat';
roi2Name = 'lh_V1_smooth3mm_NOT.mat';
afq = AFQ_AddNewFiberGroup_2(afq, fgName, roi1Name, roi2Name,0, 1);

cd /biac4/wandell/biac3/wandell7/shumpei/matlab/git/LHON/3RP
save 3RP_1210 afq

%% OCF
fgName = 'OCFV1V2Not3mm_MD4Al.pdb';

roi1Name= 'lh_V1_smooth3mm_lh_V2_smooth3mm_NOT.mat';
roi2Name = 'rh_V1_smooth3mm_rh_V2_smooth3mm_NOT.mat';

%3
afq = AFQ_AddNewFiberGroup_3(afq, fgName, roi1Name, roi2Name, 0, 1);

cd /biac4/wandell/biac3/wandell7/shumpei/matlab/git/LHON/3RP
save 3RP_1210 afq

%% OT
fgName = 'ROTD4L4_1206.pdb';
roi1Name = 'Optic-Chiasm.mat';
roi2Name = 'Rt-LGN4.mat';
afq = AFQ_AddNewFiberGroup_2(afq, fgName, roi1Name, roi2Name, 0, 1);


fgName = 'LOTD4L4_1206.pdb';
roi1Name = 'Optic-Chiasm.mat';
roi2Name = 'Lt-LGN4.mat';

afq = AFQ_AddNewFiberGroup_2(afq, fgName, roi1Name, roi2Name, 0, 1);

cd /biac4/wandell/biac3/wandell7/shumpei/matlab/git/LHON/3RP
save 3RP_1210 afq
%% OCF from CC to V1+V2
fgName = 'LOCF_D4L4.pdb';

roi1Name= 'fs_CC.mat';
roi2Name = 'lh_V1_smooth3mm_lh_V2_smooth3mm.mat';
% 
afq = AFQ_AddNewFiberGroup_2(afq, fgName, roi1Name, roi2Name, 0, 1);

%
fgName = 'ROCF_D4L4.pdb';

roi1Name= 'fs_CC.mat';
roi2Name = 'rh_V1_smooth3mm_rh_V2_smooth3mm.mat';

% 3
afq = AFQ_AddNewFiberGroup_2(afq, fgName, roi1Name, roi2Name, 0, 1);

%%
cd /biac4/wandell/biac3/wandell7/shumpei/matlab/git/LHON/3RP
save 3RP_1210 afq
return