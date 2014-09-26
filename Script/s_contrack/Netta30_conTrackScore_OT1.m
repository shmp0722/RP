function Netta30_conTrackScore_OT1(subjectnumber,thresh)
%%
% To save and score a hways
%

baseDir = '/biac4/wandell/biac3/wandell4/data/reading_longitude/dti_adults';
subjectDir =  {'aab050307','ah051003','am090121','ams051015','as050307'...
    'aw040809','bw040922','ct060309','db061209','dla050311'...
    'gd040901','gf050826','gm050308','jl040902','jm061209'...
    'jy060309','ka040923','mbs040503','me050126','mo061209'...
    'mod070307','mz040828','pp050208','rfd040630','rk050524'...
    'sc060523','sd050527','sn040831','sp050303','tl051015'};
%% 

if notDefined('subjectnumber'), subjectnumber = 1:length(subjectDir);end
if notDefined('thresh'), thresh = [0.01, 0.1, 0.3, 0.5, 0.7 ,0.9, 1.1, 1.5];end
%%
for i = subjectnumber;
    
    fibersFolder = fullfile(baseDir, subjectDir{i}, '/dwi_2nd/fibers/conTrack/OpticTract5000');
    % Set the fullpath to data directory
    cd(fibersFolder)
    
    %% To save and score a particular number of pathways

    Ids = {
        '*-Right-WhiteMatter_Ctrk100_AFQ_*'
        '*-Left-WhiteMatter_Ctrk100_AFQ_*'};
    
    
    for ij = 1:length(Ids)
        fgF = dir(Ids{ij});
        
        % To save and score only pathways that have a score greater than
        % -thresh
        
        % get oldest files to match the identifier in the folder
        n = strfind([fgF.name],'-');
        dTxt = dir(sprintf('%s/*%s*.txt',fibersFolder, fgF.name(4:(n(5)-1))));
        dPdb = dir(Ids{ij});
        
        for k = 1:length(thresh)
            % give filename to fiber group
            l = {'LOT','ROT'};
            %         outputfibername = fullfile(fibersFolder, sprintf('%s_Ctr%d.pdb',dPdb.name(1:end-4),thresh*10));
            outputfibername = fullfile(fibersFolder, sprintf('%s_Ctr%d.pdb', l{ij}, thresh(k)*100));
            
            % make command to get fibers for contrack
            ContCommand = sprintf('contrack_score.glxa64 -i %s -p %s --thresh %d %s', ...
                dTxt.name, outputfibername, thresh(k), dPdb.name);
            
            % run contrack
            system(ContCommand);
        end
    end
end
