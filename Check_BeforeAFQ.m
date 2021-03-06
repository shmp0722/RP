%% Checking if these subjects have OR and OT files

[homeDir,subDir,JMD,CRD,LHON,Ctl,RP,AMDC] = Tama_subj2;

% Pick up subject

Control = [Ctl,AMDC];

%% Checking file existence
subnumber = [RP,Control];
for ii = 1:length(subnumber)

   current_subject  = fullfile(homeDir, subDir{subnumber(ii)});
   
   % fiber tract files
   fgDir = fullfile(current_subject,'/dwi_2nd/fibers');
   Fg  = {'LOTD3L2_1206.pdb','LOTD4L4_1206.pdb','LOR1206_D4L4.pdb','ROTD3L2_1206.pdb','ROTD4L4_1206.pdb','ROR1206_D4L4.pdb'};  
   
   for jj =1 : length(Fg); 
       Ex(ii,jj) = exist(fullfile(fgDir, Fg{jj}));
   end
   
   % ROI files
   RoiDir = fullfile(current_subject,'/dwi_2nd/ROIs');
   Roi = { '85_Optic-Chiasm.mat','Lt-LGN4.mat','Rt-LGN4.mat','lh_V1_smooth3mm_NOT.mat','rh_V1_smooth3mm_NOT.mat'};
   
   for kk =1 : length(Roi); 
       R(ii,kk) = exist(fullfile(RoiDir,Roi{kk}));
   end
   
   % copy Optic -chasm ROI
   if exist(fullfile(RoiDir,'Optic-Chiasm.mat')) && ~exist(fullfile(RoiDir,'85_Optic-Chiasm.mat'));
       cd(RoiDir)
       !cp Optic-Chiasm.mat 85_Optic-Chiasm.mat
   end
   
end

%% 
% If rois don't exist, you can simply run SO_GetRoisId3(id) %% Tamagawa3 directory   
id = R(:,1)==0;
% for 
SO_GetRoisId2(subnumber(id))


%% subject dose not have ORs 
NeedOR = squeeze(subDir(subnumber(Ex(:,6)==0)));

for jj = 1:length(NeedOR)
fgDir = fullfile(current_subject,'/dwi_2nd/fibers');
end


%% check

subnumber = [RP,Control];
for ii = 1:length(subnumber)

   current_subject  = fullfile(homeDir, subDir{subnumber(ii)});
   
   % fiber tract files
   fgDir = fullfile(current_subject,'/dwi_2nd/fibers');
   Fg  = {'LOTD4L4_1206.pdb','LOR1206_D4L4.pdb','ROTD4L4_1206.pdb','ROR1206_D4L4.pdb'};
   
   mrvNewGraphWin; hold on;
   
   for jj = 1:length(Fg)
       fg = fgRead(fullfile(fgDir,Fg{jj}));
       
       AFQ_RenderFibers(fg,'numfibers',50,'newfig',0)
   end
      view([0 90])
      axis off 
      axis image
      title(subDir{subnumber(ii)})
       
   hold off
end

%% AFQ
load '/sni-storage/wandell/biac2/wandell/data/DWI-Tamagawa-Japan2/RP/AFQ_8RP_14Ctl_0820.mat'

sub_dirs = afq.sub_dirs;

for jj = length(afq.sub_dirs)+1: length(afq.sub_dirs)+length(AMDC)
    sub_dirs{jj} = fullfile(homeDir, subDir{AMDC(jj-length(afq.sub_dirs))},'dwi_2nd');
end
% Subject grouping is a little bit funny because afq only takes two groups
% but we have 3. For now we will divide it up this way but we can do more
% later
a = zeros(1,length(sub_dirs));
% b = [16:23,31:33,35:37];
a(1,1:length(RP)) = 1; 
sub_group = a;
% sub_group = [1,0];

% Now create and afq structure
% afq = AFQ_Create('sub_dirs', sub_dirs, 'sub_group', sub_group, 'clip2rois', 0);
% if you would like to use ants for normalization
% afq = AFQ_Create('sub_dirs', sub_dirs, 'sub_group', sub_group, 'clip2rois', 0,'normalization','ants');

% % To have afq overwrite the old fibers
% afq = AFQ_set(afq,'overwritesegmentation');
% afq = AFQ_set(afq,'overwritecleaning');

% % afq.params.cutoff=[5 95];
% afq.params.outdir = ...
%     fullfile(AFQdata,'/AFQ_results/6LHON_9JMD_8Ctl');
afq = AFQ_set(afq,'outdir','/sni-storage/wandell/biac2/wandell/data/DWI-Tamagawa-Japan2/RP');
afq = AFQ_set(afq,'outname','afq_8RP_25Normal');

% afq.params.outname = 'AFQ_Tama3_11AMDC_mrtrix.mat';
afq.params.run_mode = 'mrtrix';

%% Run AFQ on these subjects
afq = AFQ_run(sub_dirs, sub_group, afq);

%% load afq structure
load '/sni-storage/wandell/biac2/wandell/data/DWI-Tamagawa-Japan2/RP/afq_8RP_25Normal';

%% clip2rois was 'true', so it is needed to be '0'
afq.params.clip2rois   = 0;
afq.params.cleanFibers = 0;
afq.params.outname = 'afq_8RP_25Normal_02112015.mat';
%% Add OT and OR

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

%% save afq
save '/sni-storage/wandell/biac2/wandell/data/DWI-Tamagawa-Japan2/RP/afq_8RP_25Normal_02112015.mat'

%% render resuts
% See RP_RP_plot_24C_2
