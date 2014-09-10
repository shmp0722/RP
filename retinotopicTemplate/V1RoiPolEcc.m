function V1RoiPolEcc(foveal, ventral, dorsal , peripheral)
% This function divide V1 ROI in four parts which are foveal, vetral, dorsal and peripheral bsed on retinotopic template. 
%
% You need to run fs_retinotopicTemplate and get eccecntricity map before this function.  
%
%
% I recommend these range
% foveal 1 - 10
% ventral 30-70, dorsal 110- 160
%

%% Set the path to data directory
homeDir = '/biac4/wandell/biac2/wandell/data/DWI-Tamagawa-Japan';
homeDir2 = '/biac4/wandell/biac2/wandell/data/DWI-Tamagawa-Japan2';

subDir = {...
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
    'RP8-YT-2014-03-14-dMRI-Anatomy'
    };

%% 
for i = 1:length(subDir);
    
    SubDir = fullfile(homeDir,subDir{i});
    eccDir  = fullfile(SubDir,'fs_Retinotopy2');
    cd(eccDir)
    
    hemi ={'lh','rh'};
    for j =  1 : length(hemi)
        %% Load ecc or pol nii.gz
        Ecc = niftiRead(sprintf('%s_%s_ecc.nii.gz',subDir{i},hemi{j}));
        Pol = niftiRead(sprintf('%s_%s_pol.nii.gz',subDir{i},hemi{j}));
        %% select voxels has less than Maximum
        % foveal ROI
        fovea = Ecc;
        fovea.data(fovea.data > foveal)=0;
        fovea.data(fovea.data > 0)=1;
        % peripheral ROI
        peri = Ecc; 
        peri.data(peri.data < peripheral)=0; 
        peri.data(peri.data > 0)=1;
        
        % ventral
        Ven = Pol;
        Ven.data(Ven.data >= ventral)=0;
        Ven.data(Ven.data > 0)=1;
        % remove foveal and peripheral voxels
        Ven.data(fovea.data > 0)=0;
        Ven.data(peri.data > 0)=0;        
        
        % Dorsal
        Dor = Pol;
        Dor.data(Dor.data < dorsal)=0;
        % remove foveal and peripheral voxels
        Dor.data(fovea.data > 0)=0;
        Dor.data(peri.data > 0)=0;     
        
        
        %% give new name to the ROI
        fovea.fname = sprintf('%s_%dDegree_ecc.nii.gz',hemi{j},foveal);
        peri.fname = sprintf('%s_Peri%dDegree_ecc.nii.gz',hemi{j},peripheral);
        Ven.fname = sprintf('%s_Ven_%dpol%d-%decc.nii.gz',hemi{j},ventral,foveal,peripheral);
        Dor.fname = sprintf('%s_Dor_%dpol%d-%decc.nii.gz',hemi{j},dorsal,foveal,peripheral);
      
        %% save the ROI
        Nifti = {fovea, peri, Ven, Dor};
        for k = 1:length(Nifti)
            niftiWrite(Nifti{k})
        end
      
    end
end


%% transform ROI.nii.gz to ROI.mat 
for i = 1:length(subDir); %27
    
    SubDir = fullfile(homeDir,subDir{i});
    SubDir2 = fullfile(homeDir2,subDir{i});
    
    eccDir  = fullfile(SubDir,'fs_Retinotopy2');
    ROIdir  = fullfile(SubDir2,'/dwi_2nd/ROIs');
    
    hemi ={'lh','rh'};
    for j =  1 : length(hemi)
        ROIni = { sprintf('%s_%dDegree_ecc',hemi{j},foveal)
            sprintf('%s_Peri%dDegree_ecc',hemi{j},peripheral)
            sprintf('%s_Ven_%dpol%d-%decc',hemi{j},ventral,foveal,peripheral)
            sprintf('%s_Dor_%dpol%d-%decc',hemi{j},dorsal,foveal,peripheral)
            };
        cd(eccDir)
        %% clean it and save it in .mat
        for k = 1: length(ROIni)
            nifti = fullfile(eccDir,[ROIni{k},'.nii.gz']);
            outName = [ROIni{k},'.mat'];
            ROI = dtiRoiFromNifti(nifti,[],outName,'mat',[],0);
            % clean ROI
            ROI = dtiRoiClean(ROI,0,['fillholes', 'dilate', 'removesat']);
            % save roi in .mat in ROI directory
            cd(ROIdir)
            dtiWriteRoi(ROI,outName);
        end
    end
end
    
%% generate OR
% s_ctrIntBathPipeline_ORin4_Tama2
    
    
    