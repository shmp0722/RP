%% S_CtrInitBatchPipeline
% Multi-Subject Tractography
%

baseDir = '/biac4/wandell/biac2/wandell/data/DWI-Tamagawa-Japan';
cd(baseDir)

%% Set ctrInitBatchParams
% 
%
    ctrParams = ctrInitBatchParams;

    ctrParams.projectName = 'OCF';
    ctrParams.logName = 'myConTrackLog';
    ctrParams.baseDir = '/biac4/wandell/biac2/wandell/data/DWI-Tamagawa-Japan';
    ctrParams.dtDir = 'dwi_1st';
    ctrParams.roiDir = 'ROIs';
    ctrParams.subs = {...
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
                   'JMD-Ctl-HH-20120907DWI'
                   'JMD-Ctl-SY-20130222DWI'};
               
%     ctrParams.roi1 = {'O-Chsm','O-Chsm','Rt-LGN','Lt-LGN'};
    ctrParams.roi1 = {'CC','CC'};
    ctrParams.roi2 = {'ctx-rh-pericalcarine','ctx-lh-pericalcarine'};
%     ctrParams.roi2 = {'Lt-LGN','Rt-LGN','ctx-rh-pericalcarine','ctx-lh-pericalcarine'};

    ctrParams.nSamples = 10000;
    ctrParams.maxNodes = 240;
    ctrParams.minNodes = 10;
    ctrParams.stepSize = 1;
    ctrParams.pddpdfFlag = 0;
    ctrParams.wmFlag = 0;
    ctrParams.oi1SeedFlag = 'true';
    ctrParams.oi2SeedFlag = 'true';
    ctrParams.multiThread = 0;
    ctrParams.xecuteSh = 0;


%% Run ctrInitBatchTrack
% generate fibers
%
 [cmd infofile] = ctrInitBatchTrack(ctrParams);

 system(cmd);

%% Let's reduce number of fibers

homedir = '/biac4/wandell/biac2/wandell/data/DWI-Tamagawa-Japan';

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
     'JMD-Ctl-SY-20130222DWI'
     'JMD-Ctl-HH-20120907DWI'
    };


for subinds = 1:length(subnames)
    
    changedir = fullfile(homedir, subnames{subinds}, 'dwi_1st','fibers','conTrack','OCF');


    %% Set the fullpath to data directory
    
    cd(changedir)

    %% To save and score a particular number of pathways
    %  you should change fileidentifier = '_20130124T175152' and nFibers.
        
    % inputfiberpath = 'fgIn.pdb';
    Ids = {...
         '_OCF_CC_ctx-lh-pericalcarine'
         '_OCF_CC_ctx-rh-pericalcarine'};
    
    for ij = 1:length(Ids)
        
        fileidentifier = Ids{ij};
        % fileidentifier = '_Rt-LGN_rhcalcarine';
        % pick up 5000 fibers
        nFiber = 5000;
        
        % get oldest files to match the identifier in the folder
        dTxt = matchfiles(sprintf('%s/*%s*.txt',changedir,fileidentifier),'tr');
        dPdb = matchfiles(sprintf('%s/*%s*.pdb',changedir,fileidentifier),'tr');
        [~, tmp] = fileparts(dPdb{1});
        
        inds = strfind(tmp,fileidentifier);
        name = tmp(1:inds-1);
        
        % define filename for 5000 fiber group
        outputfibername = fullfile(changedir, sprintf('%s%s-%d.pdb',name,fileidentifier,nFiber));
        
        % make command to get 5000 fibers for contrack
        ContCommand = sprintf('contrack_score.glxa64 -i %s -p %s --thresh %d --sort %s', ...
            dTxt{1}, outputfibername, nFiber, dPdb{1});
        
        % run contrack
        system(ContCommand);
        
        %% reduce number of fibers to 5000, 3000 and 1000
        
        % store the filename of 5000 fibers 
        fiber5000name = outputfibername;
        
        % define how many fibers you want to reduce into
        nFibers = [3000 1000];
        
        for ii = 1:length(nFibers)
            
            % get number of fibers
            nFiber = nFibers(ii);
            
            % give new name for cropped fibers            
            outputfibername = fullfile(changedir, sprintf('%s%s-%d.pdb',name,fileidentifier,nFiber));
            
            % make new command for contrack
            ContCommand = sprintf('contrack_score.glxa64 -i %s -p %s --thresh %d --sort %s', ...
                dTxt{1}, outputfibername, nFiber, fiber5000name);
            
            % run contrack
            system(ContCommand);
            
        end
        
        
    end
end