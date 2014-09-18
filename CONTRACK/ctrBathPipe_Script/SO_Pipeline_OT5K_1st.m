function SO_Pipeline_OT5K_1st
%% This function generate Optic tract in Tamagawa subs of DWI 1st data

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
for i = 20:length(subDir) %19
    % INPUTS
    SubDir=fullfile(homeDir,subDir{i});
    fgDir = (fullfile(SubDir,'/dwi_1st/fibers/conTrack/OT_5K'));
    roiDir = fullfile(SubDir,'/dwi_2nd/ROIs');
    
    cd(fgDir)
    % load fg
    fgf = {'*fg_OT_5K_Optic-Chiasm_Lt-LGN4*.pdb'
        '*fg_OT_5K_Optic-Chiasm_Rt-LGN4*.pdb'};
    roif= {'Right-Cerebral-White-Matter','Left-Cerebral-White-Matter'};
    
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
    fgDir = (fullfile(SubDir,'/dwi_1st/fibers/conTrack/OT_5K'));
%     roiDir = fullfile(SubDir,'/dwi_2nd/ROIs');
    cd(fgDir)
    % load fg and calcurate nFiber
    fgf = {...
        '*fg_OT_5K_Optic-Chiasm_Lt-LGN4*Right-Cerebral-White-Matter.pdb'
        '*fg_OT_5K_Optic-Chiasm_Rt-LGN4*Left-Cerebral-White-Matter.pdb'};
    for j= 1:2
        fgF=dir(fgf{j});
        fg = fgRead(fgF.name);
        %         nFiber = round(length(fg.fibers)*0.7);
        nFiber=50;
        
        % get .txt and .pdb filename
        dTxtF = {'*ctrSampler_OT_5K_Optic-Chiasm_Lt-LGN4*.txt'
            '*ctrSampler_OT_5K_Optic-Chiasm_Rt-LGN4*.txt'};
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
for i = 20:length(subDir)
    % INPUTS
    SubDir=fullfile(homeDir,subDir{i});
    fgDir = (fullfile(SubDir,'/dwi_1st/fibers/conTrack/OT_5K'));
%     roiDir = fullfile(SubDir,'/dwi_2nd/ROIs');
    cd(fgDir)
    % load fg and calcurate nFiber
%     fgf = {...
%         '*fg_OT_5K_Optic-Chiasm_Lt-LGN4*Right-Cerebral-White-Matter_Ctrk100.pdb'
%         '*fg_OT_5K_Optic-Chiasm_Rt-LGN4*Left-Cerebral-White-Matter_Ctrk100.pdb'};
%     
    fgf = {...
        '*fg_OT_5K_Optic-Chiasm_Lt-LGN4*Right-Cerebral-White-Matter_Ctrk50.pdb'
        '*fg_OT_5K_Optic-Chiasm_Rt-LGN4*Left-Cerebral-White-Matter_Ctrk50.pdb'}; % 19
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
%% Check fibers

for i = 1:length(subDir)
    % INPUTS
    SubDir=fullfile(homeDir,subDir{i});
    fgDir = (fullfile(SubDir,'/dwi_1st/fibers/conTrack/OT_5K'));
    %     roiDir = fullfile(SubDir,'/dwi_2nd/ROIs');
    cd(fgDir)
    
    % load fg
    fgf = dir('*Cerebral-White-Matter_Ctrk50_AFQ*');    
    fg = fgRead(fgf(1).name); % k==1, lh; K ==2, rh 
    
    % render both OCF in one figure
    AFQ_RenderFibers(fg, 'newfig', [1],'numfibers', 100 ,'color', [.7 .7 1],'camera','axial'); %fg() = fg
    fg = fgRead(fgf(2).name);
    
    % title('JMD','FontSize',12,'FontName','Times');
    AFQ_RenderFibers(fg, 'newfig', [0],'numfibers', 100 ,'color', [.7 .7 1],'camera','axial'); %fg() = fg
    
end