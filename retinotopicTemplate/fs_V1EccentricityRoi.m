function fs_V1EccentricityRoi(MinDegree, MaxDegree)
% This function divide V1 ROI in periferal and foveal part based on
% retiontopic eccentrisity.
%
% You need to run fs_retinotopicTemplate and get eccecntricity map before this function.  
% See; fs_retinotopicTemplate
%
% 
%       outType     - 'nifti' or 'mat' [outType='nifti']
% 
% SO@Vista lab Stanford 2014

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
        EccROI.data(EccROI.data > MaxDegree)=0;
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
