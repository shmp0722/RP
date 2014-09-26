function runAFQ_6LHON_9MD_8normal_2RP
% Run AFQ_run for these subjects
% set directories

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
    'RP2-KI-2013-11-01'};

%% Make directory structure for each subject
for ii = 1:length(subs)
    sub_dirs{ii} = fullfile(AFQdata, subs{ii},'dwi_2nd');
end

% Subject grouping is a little bit funny because afq only takes two groups
% but we have 3. For now we will divide it up this way but we can do more
% later

sub_group = [1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 1 1 ];
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
% afq = AFQ_run(sub_dirs, sub_group, afq);
% return
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
% %%
% for ii =1:length(subs)
%     goFgDir = fullfile(afq.sub_dirs{ii} ,'/fibers');
%     cd(goFgDir)
%     %     RFgf = dir('*R-OR_0711_Ctr*.pdb');
%     %     LFgf = dir('*R-OR_0711_Ctr*.pdb');
%
%     RFgfFrom = {'R-OR_0711_Ctr1.pdb','R-OR_0711_Ctr30.pdb','R-OR_0711_Ctr50.pdb',...
%         'R-OR_0711_Ctr70.pdb','R-OR_0711_Ctr90.pdb','R-OR_0711_Ctr1.100000e+02.pdb',...
%         'R-OR_0711_Ctr150.pdb','R-OR_0711_Ctr10.pdb'};
%     LFgfFrom = {'L-OR_0711_Ctr1.pdb','L-OR_0711_Ctr30.pdb','L-OR_0711_Ctr50.pdb',...
%         'L-OR_0711_Ctr70.pdb','L-OR_0711_Ctr90.pdb','L-OR_0711_Ctr1.100000e+02.pdb',...
%         'L-OR_0711_Ctr150.pdb','L-OR_0711_Ctr10.pdb'};
%
%     RFgfTo = {'ROR_Ctr1.pdb','ROR_Ctr30.pdb','ROR_Ctr50.pdb',...
%         'ROR_Ctr70.pdb','ROR_Ctr90.pdb','ROR_Ctr110.pdb',...
%         'ROR_Ctr150.pdb','ROR_Ctr10.pdb'};
%     LFgfTo = {'LOR_Ctr1.pdb','LOR_Ctr30.pdb','LOR_Ctr50.pdb',...
%         'LOR_Ctr70.pdb','LOR_Ctr90.pdb','LOR_Ctr110.pdb',...
%         'LOR_Ctr150.pdb','ROR_Ctr10.pdb'};
%
%
%     for j = 2:size(RFgfFrom,2)
%         movefile(RFgfFrom{j},RFgfTo{j});
%         movefile(LFgfFrom{j},LFgfTo{j});
%     end
% end


%% Compute tract profiles

% Difine fgName

fgName = {'*Rh_NOT1201_D4_L4.pdb', '*-Lh_NOT1201_D4_L4.pdb'};
fgSaveName = {'LOR_1201','ROR_1201'};

roi1Name = {'Lt-LGN4.mat','Rt-LGN4.mat'};

roi2Name = {'lh_V1_smooth3mm_NOT.mat', 'rh_V1_smooth3mm_NOT.mat'};

for k = 1: length(fgName)
           fgNumber = AFQ_get(afq,'numfg');

    % And add the path to it
        for ii = 1:AFQ_get(afq,'numsubs')
            afq.files.fibers.(prefix(fgSaveName{k})){ii} = fullfile(fgDir,fgSaveName{k});
        end
        
        
        % Add the name of the new rois for a fiber group
        afq.roi1names{end+1} = prefix(roi1Name{k});
        afq.roi2names{end+1} = prefix(roi2Name{k});
    
    for ii = 1:AFQ_get(afq,'numsubs')
        SubDir = fullfile(AFQdata,subs{ii});
        fgDir  = fullfile(SubDir,'/dwi_2nd/fibers/conTrack/OR_1130');
        
        % Define the current subject to process
        afq = AFQ_set(afq,'current subject',ii);
        
        %     if computeVals == 1
        fprintf('\nComputing Tract Profiles for subject %s',afq.sub_dirs{ii});
        % Load the subject's dt6
        dt = dtiLoadDt6(AFQ_get(afq,'dt6path',ii));
        % Load the propper fiber group. If they have been cleaned it will
        % load the cleaned version
        cd(fgDir)
        fgF = dir(fgName{1});
        fprintf('\nFiber group: %s',fgF.name);
        fg = fgRead(fgF.name);
        
        
        % Add the name of the new fiber group without the file extension
        afq.fgnames{end+1} =  fgSaveName{k};
        
        
        
        
        % correct fiber direction anterior to posterior
        for jj = 1:length(fg.fibers)
            if fg.fibers{jj}(2,1) < fg.fibers{jj}(2,end);
                fg.fibers{jj}= fliplr(fg.fibers{jj});end
        end
        
%         fgWrite(fg,[fgSaveName{k} '.pdb'],'pdb')
        
        % Determine how much to weight each fiber's contribution to the
        % measurement at the tract core. Higher values mean steaper falloff
        fWeight = AFQ_get(afq,'fiber weighting');
        % By default Tract Profiles of diffusion properties will always be
        % calculated
        [fa, md, rd, ad, cl, volume, TractProfile] = AFQ_ComputeTractProperties(fg, dt, 100, 0, afq.sub_dirs{ii}, 1, afq);
        
        % Parameterize the shape of each fiber group with calculations of
        % curvature and torsion at each point and add it to the tract
        % profile
        [curv, tors, TractProfile] = AFQ_ParamaterizeTractShape(fg, TractProfile);
        % Fill these variables with nans if they come out empty. This will
        % happen if the tract profile is empty for this subject
        if isempty(curv) || isempty(tors)
            curv = nan(size(fa)); tors = nan(size(fa));
        end
        
        
        
        % Calculate the volume of each Tract Profile
        TractProfile = AFQ_TractProfileVolume(TractProfile);
        
        % Add values to the afq structure
        afq = AFQ_set(afq,'vals','subnum',ii,'fgnum',fgNumber, 'fa',fa, ...
            'md',md,'rd',rd,'ad',ad,'cl',cl,'volume',volume,'curvature',curv,'torsion',tors);
        
        % Add Tract Profiles to the afq structure
        afq = AFQ_set(afq,'tract profile','subnum',ii,'fgnum',fgNumber,TractProfile);
        
    end
end



%% ADD ROR
for j = size(RFgfTo,2)
    fgName   = RFgfTo{j};
    
    roi1Name= 'Rt-LGN.mat';
    roi2Name = 'rh_V1_smooth3mm_NOT.mat';
    afq = AFQ_AddNewFiberGroup_2(afq, fgName, roi1Name, roi2Name, 1, 1,[],[]);
    
    
    fgName   = LFgfTo{j};
    roi1Name = 'Lt-LGN.mat';
    roi2Name = 'lh_V1_smooth3mm_NOT.mat';
    afq = AFQ_AddNewFiberGroup_2(afq, fgName, roi1Name, roi2Name, 1, 1,[],[]);
end



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

% 3
afq = AFQ_AddNewFiberGroup_3(afq, fgName, roi1Name, roi2Name, 1, 1);

%% OT

fgName = 'ROT100_clean.pdb';
roi1Name = 'Optic-Chiasm.mat';
roi2Name = 'Rt-LGN4.mat';
afq = AFQ_AddNewFiberGroup_4(afq, fgName, roi1Name, roi2Name, 0, 1);


fgName = 'LOT100_clean.pdb';
roi1Name = 'Optic-Chiasm.mat';
roi2Name = 'Lt-LGN4.mat';

afq = AFQ_AddNewFiberGroup_4(afq, fgName, roi1Name, roi2Name, 0, 1);


%% OCF from CC to V1+V2
fgName = 'LOCF_D4L4.pdb';

roi1Name= 'fs_CC.mat';
roi2Name = 'lh_V1_smooth3mm_lh_V2_smooth3mm_NOT.mat';
%
afq = AFQ_AddNewFiberGroup_2(afq, fgName, roi1Name, roi2Name, 0, 1);

%%
fgName = 'ROCF_D4L4.pdb';

roi1Name= 'fs_CC.mat';
roi2Name = 'rh_V1_smooth3mm_rh_V2_smooth3mm_NOT.mat';

% 3
afq = AFQ_AddNewFiberGroup_2(afq, fgName, roi1Name, roi2Name, 0, 1);







