function s_conTrackScore_V13mm_clipped4mm_NOT0711(subjectnumber,thresh)
%%
% To save and score a hways
%

baseDir = '/biac4/wandell/biac2/wandell/data/DWI-Tamagawa-Japan';

subjectDir =  {...
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
%% SY,YM

if notDefined('subjectnumber'), subjectnumber = 1:length(subjectDir);end
if notDefined('thresh'), thresh = [0.01, 0.1, 0.3, 0.5, 0.7 ,0.9, 1.1, 1.5];end
%%
for i = subjectnumber;
    
    fibersFolder = fullfile(baseDir, subjectDir{i}, '/dwi_2nd/fibers/conTrack/OR_Top100K_V1_3mm_clipped_LGN4mm');
    % Set the fullpath to data directory
    cd(fibersFolder)
    
    %% To save and score a particular number of pathways
    
    Ids = {
        '*-Rh_NOT0711.pdb'
        '*-Lh_NOT0711.pdb'};
    
    for ij = 1:length(Ids)
        fgF = dir(Ids{ij});
        
        % To save and score only pathways that have a score greater than
        % -thresh
        
        % get oldest files to match the identifier in the folder
        dTxt = dir(sprintf('%s/*%s*.txt',fibersFolder, fgF.name(4:length(fgF.name)-16)));
        dPdb = dir(Ids{ij});
        
        for k = 1:length(thresh)
            % define filename for 25000 fiber group
            n = {'R-OR_0711','L-OR_0711'};
            %         outputfibername = fullfile(fibersFolder, sprintf('%s_Ctr%d.pdb',dPdb.name(1:end-4),thresh*10));
            outputfibername = fullfile(fibersFolder, sprintf('%s_Ctr%d.pdb', n{ij}, thresh(k)*100));
            
            % make command to get 25000 fibers for contrack
            ContCommand = sprintf('contrack_score.glxa64 -i %s -p %s --thresh %d %s', ...
                dTxt.name, outputfibername, thresh(k), dPdb.name);
            
            % run contrack
            system(ContCommand);
        end
    end
end
