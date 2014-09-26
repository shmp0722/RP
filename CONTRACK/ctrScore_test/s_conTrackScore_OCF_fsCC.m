function s_conTrackScore_OCF_fsCC(subjectnumber,thresh)
% Reduce number of fibers of OCF using sherbondy's conTrack score
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
%% 

if notDefined('subjectnumber'), subjectnumber = 1:length(subjectDir);end
if notDefined('thresh'), thresh = [0.01, 0.1, 0.3, 0.5, 0.7 ,0.9, 1.1, 1.5];end
%%
for i = subjectnumber;
    
    fibersFolder = fullfile(baseDir, subjectDir{i}, '/dwi_2nd/fibers/conTrack/OCF_Top50K_fsV1V2_3mm');
    % Set the fullpath to data directory
    cd(fibersFolder)
    
    %% To save and score a particular number of pathways
    % define file identifier
    fgf = '*fg_OCF_Top50K_fsV1V2_3mm*+fs_CC.pdb';
    txtf= '*OCF_Top50K_fsV1V2_3mm*.txt';
    % get .txt file and .pdb file
    dTxt = dir(txtf);
    dPdb = dir(fgf);
    
    for k = 1:length(thresh)
        % give the filename to scored fiber group 
        n = 'OCF_fsCC';
        outputfibername = fullfile(fibersFolder, sprintf('%s_Ctr%d.pdb', n, thresh(k)*100));
        
        % make command to get 25000 fibers for contrack
        ContCommand = sprintf('contrack_score.glxa64 -i %s -p %s --thresh %d %s', ...
            dTxt.name, outputfibername, thresh(k), dPdb.name);
        
        % run contrack
        system(ContCommand);
    end
    
end
