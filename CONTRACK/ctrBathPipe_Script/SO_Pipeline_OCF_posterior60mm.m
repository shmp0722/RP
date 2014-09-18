function SO_Pipeline_OCF_posterior60mm

homeDir = '/biac4/wandell/biac2/wandell/data/DWI-Tamagawa-Japan';

subDir ={
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
    'JMD-Ctl-SO-20130726-DWI'};

%% dtiIntersectFibers
for i =1:length(subDir)
    % INPUTS
    SubDir=fullfile(homeDir,subDir{i});
    fgDir = (fullfile(SubDir,'/dwi_2nd/fibers/conTrack/OCF_Top50K_fsV1V2_3mm_posterior60mm'));
    roiDir = fullfile(SubDir,'/dwi_2nd/ROIs');
    % load roi
    cd(roiDir)
    roi = dtiReadRoi('fs_CC.mat');
    cd(fgDir)
    % load fg
    fgf = dir('fg_OCF_Top50K_fsV1V2_3mm_posterior60mm_*.pdb');
    fg = fgRead(fgf(end).name);
    % remove Fibers don't go through CC using dtiIntersectFibers
    [fgOut,~,keep,~] = dtiIntersectFibersWithRoi([],'and',[],roi,fg);
    
    % keep pathwayInfo and Params.stat to use contrack scoring
    for l = 1:length(fgOut.params)
        fgOut.params{1,l}.stat=fgOut.params{1,l}.stat(keep);
    end
    fgOut.pathwayInfo = fgOut.pathwayInfo(keep);
    
    fgOutname = sprintf('%s.pdb',fgOut.name);
    mtrExportFibers(fgOut, fgOutname,[],[],[],2)
end

return

%% contrack scoring
for i = 1:length(subDir)
    % INPUTS
    SubDir=fullfile(homeDir,subDir{i});
    fgDir = (fullfile(SubDir,'/dwi_2nd/fibers/conTrack/OCF_Top50K_fsV1V2_3mm_posterior60mm'));
    roiDir = fullfile(SubDir,'/dwi_2nd/ROIs');
    cd(fgDir)
    % load fg and calcurate nFiber
    fgf = dir('*fg_OCF_Top50K_fsV1V2_3mm_posterior60mm_*+fs_CC.pdb');
    fg = fgRead(fgf.name);
    nFiber = round(length(fg.fibers)*0.8);
    
    % get .txt and .pdb filename
    dTxt = dir('*ctrSampler_OCF_Top50K*');
    dPdb = fullfile(fgDir,fgf.name);
    
    % give filename to output f group
    outputfibername = fullfile(fgDir, sprintf('%s_Ctrk%d.pdb',prefix(fgf.name),nFiber));
    
    % command to get 80% fibers for contrack
    ContCommand = sprintf('contrack_score.glxa64 -i %s -p %s --thresh %d --sort %s', ...
        dTxt.name, outputfibername, nFiber, dPdb);
    
    % run contrack
    system(ContCommand);
end

% %% feClipVolume
% for i = 1:length(subDir)
%     % INPUTS
%     SubDir=fullfile(homeDir,subDir{i});
%     fgDir = (fullfile(SubDir,'/dwi_2nd/fibers/conTrack/OCF_Top50K_fsV1V2_3mm'));
%     roiDir = fullfile(SubDir,'/dwi_2nd/ROIs');
%     cd(fgDir)
%     % load fg and calcurate nFiber
%     fgf = matchfiles('*fg_OCF_Top50K*','t');
%     fg = fgRead(fgf{1});
%     % make white matter mask
%     roif ={...
%         'Right-Cerebral-White-Matter_Rt-LGN'
%         'Left-Cerebral-White-Matter_Lt-LGN'
%         'fs_CC'};
%     cd(roiDir)
%     
%     roi  = dtiReadRoi(roif{1});
%     roi2 = dtiReadRoi(roif{2});
%     roi3 = dtiReadRoi(roif{3});
%     
%     Maskroi = dtiMergeROIs(roi,roi2);
%     Maskroi = dtiMergeROIs(roi3,Maskroi);
%     Maskroi.name = 'WM_LGN';
%     
%     dtiWriteRoi(Maskroi,Maskroi.name);
%     
%     % Clear parameters fields that we do not need:
%     fgOut.params      = [];
%     fgOut.pathwayInfo = [];
%     
%     % Clip the fibers' nodes that are 1mm away from the WM.
%     maxVolDist = 1; % mm
%     fg1 = feClipFibersToVolume_2(fg, Maskroi.coords,maxVolDist);
%     
%     % Back parameter
%     
%     % % Show a random 2000 fibers
%     % fg1=fg;
%     % fg1.fibers = fg1.fibers(randsample(1:length(fg1.fibers),500));
%     % feConnectomeDisplay(fg1,figure)
%     
%     % Save the clipped fiber group back to disk.
%     cd(fgDir)
%     fg1.name = sprintf('%s_WM',fg1.name);
%     savename = [fg1.name, '.mat' ];
%     fgWrite(fg1,savename,'mat')
%     Mat2pdb(savename)
% end

%% AFQ_removeoutlier
for i = 1:length(subDir)
    % INPUTS
    SubDir=fullfile(homeDir,subDir{i});
    fgDir = (fullfile(SubDir,'/dwi_2nd/fibers/conTrack/OCF_Top50K_fsV1V2_3mm_posterior60mm'));
    roiDir = fullfile(SubDir,'/dwi_2nd/ROIs');
    cd(fgDir)
    
    % load fg
    fgf = dir('fg_OCF_Top50K_fsV1V2_3mm_posterior60mm_*+fs_CC_Ctr*');
    fg = fgRead(fgf.name);
    % run
    [fgclean, keep2]=AFQ_removeFiberOutliers(fg,4,4,25,'mean',1, 5,[]);
    % keep pathwayInfo and Params.stat for contrack scoring
    for l = 1:length(fgclean.params)
        fgclean.params{1,l}.stat=fgclean.params{1,l}.stat(keep2);
    end
    fgclean.pathwayInfo = fgclean.pathwayInfo(keep2);
    
    fgclean.name = sprintf('%s_AFQ_%d.pdb',fgclean.name,length(fgclean.fibers));
    mtrExportFibers(fgclean, fgclean.name,[],[],[],2)
    
    cd(fullfile(SubDir,'/dwi_2nd/fibers')) 
    name= 'OCFV1V2Not3mm_MD4.pdb';
    mtrExportFibers(fgclean, name,[],[],[],2)
    
    
end
