function files = s_mrtrix_init_tama(lmax)
%%
basedir = '/biac4/wandell/biac2/wandell/data/DWI-Tamagawa-Japan';

subnames = {...
    'JMD1-MM-20121025-DWI'
    'JMD2-KK-20121025-DWI'
    'JMD3-AK-20121026-DWI'
    'JMD4-AM-20121026-DWI'
    'JMD5-KK-20121220-DWI'
    'JMD6-NO-20121220-DWI'
    'LHON1-TK-20121130-DWI'
    'LHON2-SO-20121130-DWI'
    'LHON3-TO-20121130-DWI'
    'LHON4-GK-20121130-DWI'
    'LHON5-HS-20121220-DWI'
    'LHON6-SS-20121221-DWI'
    'JMD-Ctl-MT-20121025-DWI'
    'JMD-Ctl-YM-20121025-DWI'
    'JMD-Ctl-SY-20130222DWI'};

subinds = 15;

mrtrixfolder = fullfile(basedir, subnames{subinds},'dwi_2nd','mrtrix');
binfolder = fullfile(basedir,subnames{subinds}, 'dwi_2nd','bin');
preprofolder = fullfile(basedir, subnames{subinds},'raw');

dwRawfilename = 'dwi2nd_aligned_trilin.nii.gz';
dwRawFile = fullfile(preprofolder, dwRawfilename);
bvecsfilename = 'dwi2nd_aligned_trilin.bvecs';
bvalsfilename = 'dwi2nd_aligned_trilin.bvals';
bvecs  = fullfile(preprofolder, bvecsfilename);
bvals  = fullfile(preprofolder, bvalsfilename);
brainMaskFilename = 'brainMask.nii.gz';
brainMaskFile = fullfile(binfolder, brainMaskFilename);
% wmMaskFilename = 'wmMask.nii.gz';
% wmMaskFile = fullfile(binfolder, wmMaskFilename);

files.dwi = 'dwi.mif';
files.b = 'dwi.b';
files.brainmask = 'dwi_brainmask.mif';
files.dt = 'dwi_dt.mif';
files.fa = 'dwi_fa.mif';
files.ev = 'dwi_ev.mif';
files.sf = 'dwi_sf.mif';
files.response = 'dwi_response.mif';
files.wm = 'dwi_wm.mif';
files.csd = 'dwi_csd.mif';
%% Run All steps
cd(mrtrixfolder);

mrtrix_mrconvert(dwRawFile, files.dwi);
mrtrix_bfileFromBvecs(bvecs, bvals, files.b);
mrtrix_mrconvert(brainMaskFile, files.brainmask, false);
mrtrix_dwi2tensor(files.dwi, files.dt, files.b);
mrtrix_tensor2FA(files.dt, files.fa, files.brainmask);
  mrtrix_tensor2vector(files.dt, files.ev, files.fa);
  mrtrix_response(files.brainmask, files.fa, files.sf, files.dwi,...
      files.response, files.b, true); 
% mrtrix_mrconvert(wmMaskFile, files.wm);
mrtrix_csdeconv(files.dwi, files.response, lmax, files.csd, files.b, files.brainmask);
