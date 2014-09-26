%% s_conTrackPartNumPostMulti
% To save and score a particular number of pathways
%

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
'JMD-Ctl-YM-20121025-DWI'};

%subinds = 3;

for subinds = 1:length(subnames)
    
    changedir = fullfile(homedir, subnames{subinds}, 'dwi_1st','fibers','conTrack','ConTrack_TamagawaDWI');
    %% Set the fullpath to data directory
    
    cd(changedir)
    
    %% To save and score a particular number of pathways
    %  you should change fileidentifier = '_20130124T175152' and nFibers.
        
    % inputfiberpath = 'fgIn.pdb';
    Ids = {...
        '_Rt-LGN_rhcalcarine'
        '_Lt-LGN_lhcalcarine'
        '_O-Chsm_Rt-LGN'
        '_O-Chsm_Lt-LGN'
        };
    
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
        
        %% reduce number of fibers to 3000 and 1000
        
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