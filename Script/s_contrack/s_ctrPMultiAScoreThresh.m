%% s_conTrackPartNumPostMultiSS
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

% 'JMD-Ctl-SY-20130222DWI'
% subinds = 14;

 for subinds = 1:length(subnames)
    
    changedir = fullfile(homedir, subnames{subinds}, 'dwi_2nd','fibers','conTrack','TamagawaDWI3');
    %% Set the fullpath to data directory
    
    cd(changedir)
    
    %% To save and score a particular number of pathways
    %  you should change fileidentifier = '_20130124T175152' and nFibers.
        
    % inputfiberpath = 'fgIn.pdb';
    Ids = {...
        '_Rt-LGN_ctx-rh-pericalcarine'
        '_Lt-LGN_ctx-lh-pericalcarine'
        '_O-Chsm_Rt-LGN'
        '_O-Chsm_Lt-LGN'
        };
    
    for ij = 1:length(Ids)
        
        fileidentifier = Ids{ij};
        % fileidentifier = '_Rt-LGN_rhcalcarine';
        
        % To save and score only pathways that have a score greater than -thresh 1.5
        thresh = 0.1;
        
        % get oldest files to match the identifier in the folder
        dTxt = matchfiles(sprintf('%s/*%s*.txt',changedir,fileidentifier),'tr');
        dPdb = matchfiles(sprintf('%s/*%s*.pdb',changedir,fileidentifier),'tr');
        [~, tmp] = fileparts(dPdb{1});
        
        inds = strfind(tmp,fileidentifier);
        name = tmp(1:inds-1);
        
        % define filename for greater thresh 1.5 fiber group
        outputfibername = fullfile(changedir, sprintf('%s%s-%1.0f.pdb',name,fileidentifier,thresh*10));
        
        % make command to get  dTxt{1}thresh 1.5 fibers for contrack
        ContCommand = sprintf('contrack_score.glxa64 -i %s -p %s --thresh %1.2f %s',...
            dTxt{1}, outputfibername, thresh,dPdb{1});
        
        % run contrack
        system(ContCommand);
        
%         %% reduce number of fibers to 5000, 3000 and 1000
%         
%         % store the filename of 5000 fibers 
%         fiber5000name = outputfibername;
%         
%         % define how many fibers you want to reduce into
%         nFibers = [5000 3000 1000];
%         
%         for ii = 1:length(nFibers)
%             
%             % get number of fibers
%             thresh = nFibers(ii);
%             
%             % give new name for cropped fibers            
%             outputfibername = fullfile(changedir, sprintf('%s%s-%d.pdb',name,fileidentifier,thresh));
%             
%             % make new command for contrack
%             ContCommand = sprintf('contrack_score.glxa64 -i %s -p %s --thresh %d --sort %s', ...
%                 dTxt{1}, outputfibername, thresh, fiber5000name);
%             
%             % run contrack
%             system(ContCommand);
%             
%         end
        
        
    end
end