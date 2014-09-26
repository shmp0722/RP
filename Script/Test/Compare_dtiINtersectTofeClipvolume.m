%% Set the path to data directory
homeDir = '/biac4/wandell/biac2/wandell/data/DWI-Tamagawa-Japan';
subDir = {...
    'JMD1-MM-20121025-DWI','JMD2-KK-20121025-DWI','JMD3-AK-20121026-DWI',...
    'JMD4-AM-20121026-DWI','JMD5-KK-20121220-DWI','JMD6-NO-20121220-DWI',...
    'LHON1-TK-20121130-DWI','LHON2-SO-20121130-DWI','LHON3-TO-20121130-DWI',...
    'LHON4-GK-20121130-DWI','LHON5-HS-20121220-DWI','LHON6-SS-20121221-DWI',...
    'JMD-Ctl-MT-20121025-DWI','JMD-Ctl-SY-20130222DWI','JMD-Ctl-YM-20121025-DWI',...
    'JMD-Ctl-HH-20120907DWI','JMD-Ctl-HT-20120907-DWI'};

% Part of dtiIntersectfiberWithRoi
for i = 1:length(subDir);
        
    SubDir = fullfile(homeDir,subDir{i});
    roiDir = fullfile(SubDir,'dwi_2nd','ROIs');
    fgDir  = fullfile(SubDir,'/dwi_2nd/fibers/conTrack/OR_Top100K_fs2ROIV1_3mm'); 
    cd(fgDir)
    
    % INPUTS:
    % 
    fgfile = {...
        'fg_OR_Top100K_fs2ROIV1_3mm_Lt-LGN_lh_V1_smooth3mm_2013-06-05_01.07.38.pdb'
        'fg_OR_Top100K_fs2ROIV1_3mm_Rt-LGN_rh_V1_smooth3mm_2013-06-05_01.07.38.pdb'};
    for hemisphere = 1:length(fgfile)
        switch(hemisphere)
            case 1
                Roifile1 = 'Rh_BigNotROI.mat';
            case 2
                Roifile1 = 'Lh_BigNotROI.mat';
        end
         
    % load dt, fg.pdb
    dt = dtiLoadDt6(fullfile(SubDir,'dwi_2nd','dt6.mat'));
    fg1 = fgRead(fgfile{hemisphere});
    
    % Set params
    options = 'not';
    minDist = 0.87;
    handles = 0;
    
    roi1 = dtiReadRoi(fullfile(roiDir,Roifile1));
    [fgOut1,contentiousFibers1, keep1, keepID1] = dtiIntersectFibersWithRoi(handles, options, minDist, roi1, fg1);
    
    % save the pdb file
    switch(hemisphere)
        case 1
            fgOut1.name = 'fg_LOR_Top100K_Rh_BigNotROI';
        case 2
            fgOut1.name = 'fg_ROR_Top100K_Lh_BigNotROI';
    end

    savefilename = sprintf('%s.pdb',fgOut1.name);
    mtrExportFibers(fgOut1,savefilename);           
    

% %% Part of feClipFiberToVolum
% 
% % Keep parameters, once 
% params      = fg1.params;
% pathwayInfo = fg1.pathwayInfo;
% 
% % Clear parameters fields that we do not need:
% fg1.params      = [];
% fg1.pathwayInfo = [];
% 
% % Clip the fibers' nodes that are 1mm away from the WM.
% maxVolDist = 1; % mm
% fg2 = feClipFibersToVolume(fg1,roi1.coords,maxVolDist);
% 
% % Back parameter
% 
% % Show a random 2000 fibers
% % fg1=fg;
% % fg1.fibers = fg1.fibers(randsample(1:length(fg1.fibers),500));
% % feConnectomeDisplay(fg1,figure)
% 
% % Save the clipped fiber group back to disk.
% fg2.name = sprintf('%s-WmMask.pdb',fg2.name);
% mtrExportFibers(fg2,fg2.name)
% 

%% Remove outlier with different maximum distance using AFQ
        for i=3:5; % max distance

            maxDist = i;
            maxLen = 4;
            numNodes = 25;
            M = 'mean';
            count = 1;
            show = 1;

            [fgclean keep] =  AFQ_removeFiberOutliers(fgOut1,maxDist,maxLen,numNodes,M,count,show);
            fname       = sprintf('%s_MD%d.pdb',fgclean.name,maxDist);
            mtrExportFibers(fgclean,fname);
        end
    end
end

    