%% runJMDonset
% to compare JMD adult onset to early onset.

%% set directories
AFQdata = '/biac4/wandell/biac3/wandell4/data/reading_longitude/dti_adults';

subjDirs     = {...               
                'Link to JMD1-MM-20121025-DWI'...
                'Link to JMD2-KK-20121025-DWI'...
                'Link to JMD3-AK-20121026-DWI'...
                'Link to JMD4-AM-20121026-DWI'...
                'Link to JMD5-KK-20121220-DWI'...
                'Link to JMD6-NO-20121220-DWI'};


% Make directory structure for each subject
for ii = 1:length(subjDirs)
    sub_dirs{ii} = fullfile(AFQdata, subjDirs{ii},'dwi_2nd');
end

% Subject grouping is a little bit funny because afq only takes two groups
% but we have 3. For now we will divide it up this way but we can do more
% later
sub_group = [0,1,0,1,0,0];

% Now create and afq structure
afq = AFQ_Create('sub_dirs', sub_dirs, 'sub_group', sub_group, 'clip2rois', 0);

% Run AFQ on these subjects
afq = AFQ_run(sub_dirs, sub_group, afq);

%% add more fiber groups of opticradiation to afq structure
% add ROR_MD3

fgName = 'ROR_MD3.pdb';

roi1Name = 'Rt-LGN.mat';
roi2Name = 'ctx-rh-pericalcarine.mat';

afq = AFQ_AddNewFiberGroup(afq, fgName, roi1Name, roi2Name, 0, 1);

%add LOR_MD3
fgName = 'LOR_MD3.pdb';

roi1Name = 'Lt-LGN.mat';
roi2Name = 'ctx-lh-pericalcarine.mat';

afq = AFQ_AddNewFiberGroup(afq, fgName, roi1Name, roi2Name, 0, 1);

% add L-OCF_MD2
fgName = 'LOCF_MD2.pdb';

roi1Name = 'CC.mat';
roi2Name = 'ctx-lh-pericalcarine.mat';

afq = AFQ_AddNewFiberGroup(afq, fgName, roi1Name, roi2Name, 0, 1);

% add R-OCF_MD2
fgName = 'ROCF_MD2.pdb';

roi1Name = 'CC.mat';
roi2Name = 'ctx-rh-pericalcarine.mat';

afq = AFQ_AddNewFiberGroup(afq, fgName, roi1Name, roi2Name, 0, 1);
