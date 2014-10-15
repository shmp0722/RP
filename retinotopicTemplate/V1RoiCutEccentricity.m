function V1RoiCutEccentricity(MinDegree, MaxDegree)
% This function divide V1 ROI in periferal and foveal part based on
% retiontopic eccentrisity.
%
% You need to run fs_retinotopicTemplate and get eccecntricity map before this function.  
% See; fs_retinotopicTemplate
%
% 
%       outType     - 'nifti' or 'mat' [outType='nifti']

%

%% Set the path to data directory
[homeDir, subDir] = Tama_subj;
% [homeDir2]         =  Tama_subj;
%% Divide V1 ROI based on eccentricity
for i = 1:length(subDir);    
    eccDir  = fullfile(homeDir,subDir{i},'fs_Retinotopy2');    
    hemi ={'lh','rh'};
    for j =  1 : length(hemi)
        %% Load ecc or pol nii.gz
        ni =niftiRead(fullfile(eccDir,sprintf('%s_%s_ecc.nii.gz',subDir{i},hemi{j})));        
        %% select voxels has less than Maximum
        % foveal ROL
        EccROI = ni;
        EccROI.data(EccROI.data >= MaxDegree)=0;
        EccROI.data(EccROI.data < MinDegree)=0;
        EccROI.data(EccROI.data >0) = 1;
        
        % ROI name
        EccROI.fname = fullfile(fileparts(ni.fname),sprintf('%s_Ecc%dto%d',hemi{j},MinDegree,MaxDegree));

        %% save the ROI
        % nii.gz
        niiName =  [EccROI.fname,'.nii.gz'];
        niftiWrite(EccROI,niiName)
        
        % mat
        matName =  [EccROI.fname,'.mat'];
        binary = true; save = true;
        dtiRoiFromNifti(niiName,0,matName,'mat',binary,save);                
       
    end
end

return
% 
% %% transform ROI.nii.gz to ROI.mat 
% for i = 1:length(subDir); %20 
%     
%     SubDir = fullfile(homeDir,subDir{i});
%     eccDir  = fullfile(SubDir,'fs_Retinotopy2');
%     ROIdir  = fullfile(SubDir,'/dwi_2nd/ROIs');
%     ROIni = {sprintf('%s_%dDegree_ecc','lh',MaxDegree),...
%         sprintf('%s_Peri%dDegree_ecc','lh',MaxDegree),...
%         sprintf('%s_%dDegree_ecc','rh',MaxDegree),...
%         sprintf('%s_Peri%dDegree_ecc','rh',MaxDegree),...
%        };
%     cd(eccDir)
%     %% clean it and save it in .mat 
%     for j = 1: length(ROIni)
%         nifti = fullfile(eccDir,[ROIni{j},'.nii.gz']);
%         niiName = [ROIni{j},'.mat'];       
%         ROI = dtiRoiFromNifti(nifti,[],niiName,'mat',[],0);
%         % clean ROI
%         ROI = dtiRoiClean(ROI,0,['fillholes', 'dilate', 'removesat']);      
%         % save roi in .mat in ROI directory
%         cd(ROIdir)
%         dtiWriteRoi(ROI,niiName);
%     end
% end
% 
% 
% %% transform ROI.nii.gz to ROI.mat 
% for i = 1:length(subDir); %20 
%     
%     SubDir = fullfile(homeDir2,subDir{i});
%     eccDir  = fullfile(homeDir,subDir{i},'fs_Retinotopy2');
%     ROIdir  = fullfile(SubDir,'/dwi_2nd/ROIs');
%     ROIni = {sprintf('%s_%dDegree_ecc','lh',MaxDegree),...
%         sprintf('%s_Peri%dDegree_ecc','lh',MaxDegree),...
%         sprintf('%s_%dDegree_ecc','rh',MaxDegree),...
%         sprintf('%s_Peri%dDegree_ecc','rh',MaxDegree),...
%        };
%     cd(eccDir)
%     %% clean it and save it in .mat 
%     for j = 1: length(ROIni)
%         nifti = fullfile(eccDir,[ROIni{j},'.nii.gz']);
%         niiName = [ROIni{j},'.mat'];       
%         ROI = dtiRoiFromNifti(nifti,[],niiName,'mat',[],0);
%         % clean ROI
%         ROI = dtiRoiClean(ROI,0,['fillholes', 'dilate', 'removesat']);      
%         % save roi in .mat in ROI directory
%         cd(ROIdir)
%         dtiWriteRoi(ROI,niiName);
%     end
% end
    
    
    
    
    