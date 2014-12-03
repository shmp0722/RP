function ht_TamagawaPreprocess3(subDir, option)

% Preprocessing the diffusion MRI data obtained by SIEMENS 3T scanner in
% Tamagawa University, Machida, JAPAN
%
%  INPUTS:
%   subDir: subject directory name
%   (ex. 'LHON1-TK-20121130-DWI')
%   option:  0: default (single masurement. analyzing 'dwi.nii.gz')
%            1: analyzing first diffusion measure 'dwi1st.nii.gz'
%            2: analyzing second diffusion measure 'dwi2nd.nii.gz'
%
%
% (c) Hiromasa 2012 Stanford VISTA team

if notDefined('subDir')
    [basedir, subDir] = fileparts(pwd);
end

if notDefined('option')
    option = 0;
end

%% Set the fullpath to data directory
% basedir = '/biac4/wandell/biac2/wandell/data/DWI-Tamagawa-Japan3/';
% cd(basedir)

%% Set the optimal parameter for SIEMENS scan at Tamagawa
dwParams = dtiInitParams;
dwParams.clobber=1;
% This flipping is specifically important for SIEMENS scans
dwParams.rotateBvecsWithCanXform = 1;%1
dwParams.rotateBvecsWithRx = 0;
% Phase encoding direction is A/P
dwParams.phaseEncodeDir = 2; %default 2
dwParams.flipLrApFlag=0; % default = 0
dwParams.fitMethod = 'lsrt'; 
%% Define folder name for 1st and 2nd scans
dt6_base_names = {'dwi', 'dwi_1st', 'dwi_2nd', 'dwi_3rd','dwi_4th'};

subjectpath = fullfile(basedir, subDir);
cd(subjectpath);
t1File = fullfile(subjectpath, 't1.nii.gz');

%% Set xform to raw t1 File
ni = niftiRead(t1File);
ni1 = niftiSetQto(ni,ni.sto_xyz);
niftiWrite(ni1);

%%  mrAnatAverageAcpcNifti
% Make sure that Acpc alighnment was done
%if not finish yet, mrAnatAverageAcpcNifti.m


%% Selecting different file names between 1st and 2nd scans
switch option
    case 0,
        rawdtiFile = fullfile(subjectpath, 'raw', 'dwi.nii.gz');
        dwParams.bvecsFile = fullfile(subjectpath, 'raw', 'dwi.bvec');
        dwParams.bvalsFile = fullfile(subjectpath, 'raw', 'dwi.bval');
        dwParams.dt6BaseName= dt6_base_names{1};
    case 1,
        rawdtiFile = fullfile(subjectpath, 'raw', 'dwi1st.nii.gz');
        dwParams.bvecsFile = fullfile(subjectpath, 'raw', 'dwi1st.bvec');
        dwParams.bvalsFile = fullfile(subjectpath, 'raw', 'dwi1st.bval');
        dwParams.dt6BaseName= dt6_base_names{2};
    case 2,
        rawdtiFile = fullfile(subjectpath, 'raw', 'dwi2nd.nii.gz');
        dwParams.bvecsFile = fullfile(subjectpath, 'raw', 'dwi2nd.bvec');
        dwParams.bvalsFile = fullfile(subjectpath, 'raw', 'dwi2nd.bval');
        dwParams.dt6BaseName= dt6_base_names{3};
    case 3,
        rawdtiFile = fullfile(subjectpath, 'raw', 'dwi3rd.nii.gz');
        dwParams.bvecsFile = fullfile(subjectpath, 'raw', 'dwi3rd.bvec');
        dwParams.bvalsFile = fullfile(subjectpath, 'raw', 'dwi3rd.bval');
        dwParams.dt6BaseName= dt6_base_names{4};
    case 4,
        rawdtiFile = fullfile(subjectpath, 'raw', 'dwi4th.nii.gz');
        dwParams.bvecsFile = fullfile(subjectpath, 'raw', 'dwi4th.bvec');
        dwParams.bvalsFile = fullfile(subjectpath, 'raw', 'dwi4th.bval');
        dwParams.dt6BaseName= dt6_base_names{5};
end

%% Set rawdtiFile xform 
ni = readFileNifti(rawdtiFile);
ni = niftiSetQto(ni,ni.sto_xyz);
writeFileNifti(ni);

%% Run dtiInit
% Execute dtiInit
[dt6FileName, outBaseDir] = dtiInit(rawdtiFile, t1File, dwParams);

