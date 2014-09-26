function Netta30_Pipeline_OT5K

homeDir = '/biac4/wandell/biac3/wandell4/data/reading_longitude/dti_adults';

 
subDir = {'aab050307','ah051003','am090121','ams051015','as050307'...
    'aw040809','bw040922','ct060309','db061209','dla050311'...
    'gd040901','gf050826','gm050308','jl040902','jm061209'...
    'jy060309','ka040923','mbs040503','me050126','mo061209'...
    'mod070307','mz040828','pp050208','rfd040630','rk050524'...
    'sc060523','sd050527','sn040831','sp050303','tl051015'};

%% dtiIntersectFibers
for i = 2:length(subDir)
    % INPUTS
    SubDir=fullfile(homeDir,subDir{i});
    fgDir = (fullfile(SubDir,'/dwi_2nd/fibers/conTrack/OpticTract5000'));
    roiDir = fullfile(SubDir,'/dwi_2nd/ROIs');
    
    cd(fgDir)
    % load fg
    fgf = {'fg_OpticTract5000_Optic-Chiasm_clean1111_Rt-LGN_2013-04-17_15.29.15.pdb'
        'fg_OpticTract5000_Optic-Chiasm_clean1111_Lt-LGN_2013-04-17_15.29.15.pdb'};
    roif= {'Left-WhiteMatter.mat','Right-WhiteMatter.mat'};
    
    for j = 1:2
        % load roi
        cd(roiDir)
        roi = dtiReadRoi(roif{j});
        cd(fgDir)
        fgF = dir(fgf{j});
        fg = fgRead(fgF.name);
        
        % remove Fibers don't go through CC using dtiIntersectFibers
        [fgOut,~,keep,~] = dtiIntersectFibersWithRoi([],'not',[],roi,fg);
        
        % keep pathwayInfo and Params.stat to use contrack scoring
        keep = ~keep;
        for l = 1:length(fgOut.params)
            fgOut.params{1,l}.stat=fgOut.params{1,l}.stat(keep);
        end
        fgOut.pathwayInfo = fgOut.pathwayInfo(keep);
        
        fgOutname = sprintf('%s.pdb',fgOut.name);
        mtrExportFibers(fgOut, fgOutname,[],[],[],2)
    end
end

%% contrack scoring
for i =1:length(subDir)
    % INPUTS
    SubDir=fullfile(homeDir,subDir{i});
    fgDir = (fullfile(SubDir,'/dwi_2nd/fibers/conTrack/OpticTract5000'));
    roiDir = fullfile(SubDir,'/dwi_2nd/ROIs');
    cd(fgDir)
    % load fg and calcurate nFiber
    fgf = {...
        'fg_OpticTract5000_Optic-Chiasm_clean1111_Lt-LGN*Right-WhiteMatter.pdb'
        'fg_OpticTract5000_Optic-Chiasm_clean1111_Rt-LGN*Left-WhiteMatter.pdb'};
    for j= 1:2
        fgF=dir(fgf{j});
        fg = fgRead(fgF.name);
        %         nFiber = round(length(fg.fibers)*0.7);
        nFiber=100;
        
        % get .txt and .pdb filename
        dTxtF = {'ctrSampler_OpticTract5000_Optic-Chiasm_clean1111_Lt-LGN*.txt'
            'ctrSampler_OpticTract5000_Optic-Chiasm_clean1111_Rt-LGN*.txt'};
        dTxt = dir(dTxtF{j});
        dPdb = fullfile(fgDir,fgF.name);
        
        % give filename to output f group
        outputfibername = fullfile(fgDir, sprintf('%s_Ctrk%d.pdb',fg.name,nFiber));
        
        % command to get 80% fibers for contrack
        ContCommand = sprintf('contrack_score.glxa64 -i %s -p %s --thresh %d --sort %s', ...
            dTxt.name, outputfibername, nFiber, dPdb);
        
        % run contrack
        system(ContCommand);
    end
end


%% AFQ_removeoutlier
for i = 1:length(subDir)
    % INPUTS
    SubDir=fullfile(homeDir,subDir{i});
    fgDir = (fullfile(SubDir,'/dwi_2nd/fibers/conTrack/OpticTract5000'));
    roiDir = fullfile(SubDir,'/dwi_2nd/ROIs');
    cd(fgDir)
    % load fg and calcurate nFiber
    fgf = {...
        'fg_OpticTract5000_Optic-Chiasm_clean1111_Lt-LGN*_Ctrk100.pdb'
        'fg_OpticTract5000_Optic-Chiasm_clean1111_Rt-LGN*_Ctrk100.pdb'};
    for j= 1:2
        fgF = dir(fgf{j}); 
        fg  = fgRead(fgF.name);
        
        [fgclean, keep2]=AFQ_removeFiberOutliers(fg,4,4,25,'mean',1, 5,[]);
        % keep pathwayInfo and Params.stat for contrack scoring
        for l = 1:length(fgclean.params)
            fgclean.params{1,l}.stat=fgclean.params{1,l}.stat(keep2);
        end
        fgclean.pathwayInfo = fgclean.pathwayInfo(keep2);
        fgclean.name = sprintf('%s_AFQ_%d.pdb',fgclean.name,length(fgclean.fibers));
        mtrExportFibers(fgclean, fgclean.name,[],[],[],2)
    end
end

%% copyfile
for i = 1:length(subDir)
    % INPUTS
    SubDir=fullfile(homeDir,subDir{i});
    fgDir = (fullfile(SubDir,'/dwi_2nd/fibers/conTrack/OpticTract5000'));
    roiDir = fullfile(SubDir,'/dwi_2nd/ROIs');
    cd(fgDir)
    % load fg and calcurate nFiber
    fgf = {...
         '*-Right-WhiteMatter_Ctrk100_AFQ_*'
        '*-Left-WhiteMatter_Ctrk100_AFQ_*'};
    for j= 1:2
        cd(fgDir)
        fgF = dir(fgf{j}); 
        fg  = fgRead(fgF.name);
     cd ../../
     switch j
         case 1
             fg.name = 'LOT_D4L4';
         case 2
             fg.name = 'ROT_D4L4';
     end
        fgWrite(fg,fg.name,'pdb')
    end
end

%%
% Next step is  Netta30_conTrackScore_OT1.m





% %% contrack scoring
% for i = 1:length(subDir)
%     % INPUTS
%     SubDir=fullfile(homeDir,subDir{i});
%     fgDir = (fullfile(SubDir,'/dwi_2nd/fibers/conTrack/OT_5K'));
%     roiDir = fullfile(SubDir,'/dwi_2nd/ROIs');
%     cd(fgDir)
%     % load fg and calcurate nFiber
%     fgf = matchfiles('*fg_OT_5K_Optic-Chiasm_*','tr');
%
%     for j= 1:2
%         fg = fgRead(fgf{end+1-j});
%         nFiber = round(length(fg.fibers)*0.7);
%
%         % get .txt and .pdb filename
%         dTxt = {'ctrSampler_OT_5K_Optic-Chiasm_Rt-LGN4_2013-08-05_14.16.34.txt'
%             'ctrSampler_OT_5K_Optic-Chiasm_Lt-LGN4_2013-08-05_14.16.34.txt'};
%         dPdb = fullfile(fgDir,fgf{j});
%
%         % give filename to output f group
%         outputfibername = fullfile(fgDir, sprintf('%s_Ctrk%d.pdb',prefix(fgf{j}),nFiber));
%
%         % command to get 80% fibers for contrack
%         ContCommand = sprintf('contrack_score.glxa64 -i %s -p %s --thresh %d --sort %s', ...
%             dTxt{j}, outputfibername, nFiber, dPdb);
%
%         % run contrack
%         system(ContCommand);
%     end
% end


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
