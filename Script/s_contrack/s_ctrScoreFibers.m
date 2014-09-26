%% s_conTrackPartNumPostMultiSS
% To save and score a particular number of pathways
%

homedir = '/biac4/wandell/biac2/wandell/data/DWI-Tamagawa-Japan/JMD-Ctl-SY-20130222DWI/fibers/conTrack';

    %% Set the fullpath to data directory
    
    cd(homedir)
    
    %% To save and score a particular number of pathways
    %  you should change fileidentifier = '_20130124T175152' and nFibers.
        
    % inputfiberpath = 'fgIn.pdb';
    Ids = {...
        '_20130307T100829'
        '_20130307T100957'
        '_20130307T100914'
        '_20130307T100948'};
    
    for ij = 1:length(Ids)
        
        fileidentifier = Ids{ij};
        % fileidentifier = '_Rt-LGN_rhcalcarine';
        %TamagawaDWI3
        % pick up 25000 fibers
        nFiber = 25000;
        
        % get oldest files to match the identifier in the folder
        dTxt = matchfiles(sprintf('%s/*%s*.txt',homedir,fileidentifier),'tr');
        dPdb = matchfiles(sprintf('%s/*%s*.pdb',homedir,fileidentifier),'tr');
        [~, tmp] = fileparts(dPdb{1});
        
        inds = strfind(tmp,fileidentifier);
        name = tmp(1:inds-1);
        
        % define filename for 25000 fiber group
        outputfibername = fullfile(homedir, sprintf('%s%s-%d.pdb',name,fileidentifier,nFiber));
        
        % make command to get 25000 fibers for contrack
        ContCommand = sprintf('contrack_score.glxa64 -i %s -p %s --thresh %d --sort %s', ...
            dTxt{1}, outputfibername, nFiber, dPdb{1});
        
        % run contrack
        system(ContCommand);
        
        %% reduce number of fibers to 5000, 3000 and 1000
        
        % store the filename of 5000 fibers 
        fiber5000name = outputfibername;
        
        % define how many fibers you want to reduce into
        nFibers = [20000 10000 5000 3000 1000];
        
        for ii = 1:length(nFibers)
            
            % get number of fibers
            nFiber = nFibers(ii);
            
            % give new name for cropped fibers            
            outputfibername = fullfile(homedir, sprintf('%s%s-%d.pdb',name,fileidentifier,nFiber));
            
            % make new command for contrack
            ContCommand = sprintf('contrack_score.glxa64 -i %s -p %s --thresh %d --sort %s', ...
                dTxt{1}, outputfibername, nFiber, fiber5000name);
            
            % run contrack
            system(ContCommand);
            
        end
        
        
    end
% end