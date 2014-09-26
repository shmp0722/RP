function runPysurfer(subject_number, hemi,map)
% run pysurfer wrtten by ariel for Tama_subject
%
% subject_number = subject "number"
% hemi = 'lh','rh'
% map = 'ecc','pol'

%% select subject
subs = {...
    'JMD1-MM-20121025-DWI'
    'JMD2-KK-20121025-DWI'
    'JMD3-AK-20121026-DWI'
    'JMD4-AM-20121026-DWI'
    'JMD5-KK-20121220-DWI'
    'JMD6-NO-20121220-DWI'
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
    'JMD-Ctl-SY-20130222DWI'
    'JMD-Ctl-YM-20121025-DWI'
    'JMD-Ctl-HH-20120907DWI'
    'JMD-Ctl-HT-20120907-DWI'
    'JMD-Ctl-FN-20130621-DWI'
    'JMD-Ctl-AM-20130726-DWI'
    'JMD-Ctl-SO-20130726-DWI'
    'RP1-TT-2013-11-01'
    'RP2-KI-2013-11-01'
    'RP3-TO-13120611-DWI'
    'LHON6-SS-20131206-DWI'
    'RP4-AK-2014-01-31'
    'RP5-KS-2014-01-31'
    'JMD3-AK-20140228-dMRI'
    'JMD-Ctl-09-RN-20130909'
    'JMD-Ctl-10-JN-20140205'
    'JMD-Ctl-11-MT-20140217'
    'RP6-SY-2014-02-28-dMRI'
    'Ctl-12-SA-20140307'
    'Ctl-13-MW-20140313-dMRI-Anatomy'
    'Ctl-14-YM-20140314-dMRI-Anatomy'
    'RP7-EU-2014-03-14-dMRI-Anatomy'
    'RP8-YT-2014-03-14-dMRI-Anatomy'};
    
%%
% subject_number =23;
% hemi = 'lh';
home_dir = '/biac4/wandell/biac2/wandell/data/DWI-Tamagawa-Japan';
fs_dir = '/biac4/wandell/biac2/wandell/data/DWI-Tamagawa-Japan/freesurfer';
fs_retinotopy_dir = fullfile(home_dir,subs{subject_number},'fs_Retinotopy2');

%%
switch map
    case 'ecc'
        fs_retinotoy_map = fullfile(fs_retinotopy_dir,sprintf('%s_%s_ecc.mgh',subs{subject_number},hemi));
        pysurfer(subs{subject_number}, hemi, 'inflated',fs_dir,fs_retinotoy_map, [], 1, 15, 'white','bone')

    case 'pol'
        fs_retinotoy_map = fullfile(fs_retinotopy_dir,sprintf('%s_%s_pol.mgh',subs{subject_number},hemi));
        pysurfer(subs{subject_number}, hemi, 'inflated',fs_dir,fs_retinotoy_map, [0, 180], 1, 180, 'white','bone')

end

%% run pysurfer


