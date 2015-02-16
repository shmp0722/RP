function afq = runAFQ_Callosal_RP8N25
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
afq = AFQ_set(afq,'outname','afq_Callosal_8RP25Normal_02142015');
afq.params.run_mode = 'mrtrix';


%% Run AFQ on these subjects
afq.params.computenorms = 0;
afq = SO_AFQ_SegmentCallosum(afq);

