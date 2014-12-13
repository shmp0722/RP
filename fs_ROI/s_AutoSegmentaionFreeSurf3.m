function s_AutoSegmentaionFreeSurf3
% (courtesy of Dr. JW)
tamagawahomedir = '/biac4/wandell/biac2/wandell/data/DWI-Tamagawa-Japan3';

%% navigate to direcotry containing new T1s
subnames = {...
%     'AMD-Ctl04-AO-61yo-dMRI-Anatomy'
    'AMD-Ctl05-TM-71yo-dMRI-Anatomy'
%     'AMD-Ctl06-YM-66yo-dMRI-Anatomy'
%     'AMD-Ctl07-MS-61yo-dMRI-Anatomy'
%     'AMD-Ctl08-HO-62yo-dMRI-Anatomy'
%     'AMD-Ctl09-KH-70yo-dMRI-Anatomy-dMRI'
%     'AMD-Ctl10-TH-65yo-dMRI-Anatomy-dMRI'...
    };


%% If you want to segment several subject simultaneously. It would be 
% better to use matlabpool. matlabpool OPEN <number of core>.
% matlabpool OPEN 6;

%%
parfor subinds =1:length(subnames);
    
    cd(fullfile(tamagawahomedir, subnames{subinds}))
    
    %% autosegmentation with freesurfer
    subjID = subnames{subinds};
    t1  = 't1.nii.gz';
    fs_autosegmentToITK(subjID, t1)
end   
    %% memo to solve a minor bag
    % if you will still have any problem above and you can find automatic
    % segmented  file in freesurfer folder
    % (i.e. /[tamagawadatapath]/freesurfer/[subject]/mri/ribon.mgz)
    %
    % please run a script below
    % if you will still have any problem above and you can find automatic segmented
%     outfile     = fullfile(fileparts(t1),...
%         sprintf('t1_class_fs_%s.nii.gz',  datestr(now, 'yyyy-mm-dd-HH-MM-SS')));
%     fillWithCSF = true;
%     alignTo     = t1;
%     
%     fs_ribbon2itk(subjID, outfile, fillWithCSF, alignTo);
% end

% matlabpool close;