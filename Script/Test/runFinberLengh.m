function runFinberLengh(showHist)

homeDir = '/biac4/wandell/biac2/wandell/data/DWI-Tamagawa-Japan';

subDir = {...
    'JMD1-MM-20121025-DWI'
    'JMD3-AK-20121026-DWI'
    'JMD5-KK-20121220-DWI'
    'JMD6-NO-20121220-DWI'
    'JMD2-KK-20121025-DWI'
    'JMD4-AM-20121026-DWI'
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
    'JMD-Ctl-YM-20121025-DWI'
    'JMD-Ctl-SY-20130222DWI'
    'JMD-Ctl-HH-20120907DWI'
    'JMD-Ctl-HT-20120907-DWI'
    'JMD-Ctl-FN-20130621-DWI'
    'JMD-Ctl-AM-20130726-DWI'
    'JMD-Ctl-SO-20130726-DWI'
    'RP1-TT-2013-11-01'
    'RP2-KI-2013-11-01'
    'RP3-TO-13120611-DWI'
    'LHON6-SS-20131206-DWI'
    'RP4-AK-2014-01-31'
    'RP5-KS-2014-01-31'};


%% Calculate vals along the fibers and return TP structure
for i =1:length(subDir)
    % define directory
    SubDir = fullfile(homeDir,subDir{i});
    fgDir  = fullfile(SubDir,'/dwi_2nd/fibers');
    %     newDir = fullfile(SubDir,'/dwi_2nd/fibers/conTrack/OR_1130');
    %     roiDir = fullfile(SubDir,'/dwi_2nd/ROIs');
    dt  = fullfile(homeDir,subDir{i},'dwi_2nd','dt6.mat');
    dt  = dtiLoadDt6(dt);
    %     cd(fgDir_contrack)
    cd /biac4/wandell/biac3/wandell7/shumpei/matlab/git/LHON/3RP
    
    %     'OCFV1V2Not3mm_MD4Al.pdb'
    %     fgN ={'ROR1206_D4L4.pdb','LOR1206_D4L4.pdb','ROTD4L4_1206.pdb','LOTD4L4_1206.pdb',...
    %         'ROCF_D4L4.pdb','LOCF_D4L4.pdb'};
    fgN ={'ROR1206_D4L4.pdb','LOR1206_D4L4.pdb','ROTD4L4_1206.pdb','LOTD4L4_1206.pdb',...
        'ROTD3L2_1206.pdb','LOTD3L2_1206.pdb'};
    
    for j =3:6; %1:length(fgN)
        fgF = fgRead(fullfile(fgDir,fgN{j}));
        Lmm=cellfun('length',fgF.fibers);
        [Lnorm, Mu, Sigma]= zscore(Lmm);
        
        %         Lmm = Fiberlength(fgF);
        
        
        % Show a histagram
        if showHist==1
            figure;hold on;
            [n xout]=hist(Lmm,20);
            bar(xout,n,'FaceColor','b','EdgeColor','k');
            axis([min(xout) max(xout) 0 max(n)]);
            xlabel('Fiber Length (mm)');
            plot([Mu Mu],[0 max(n)],'r','linewidth',2);
            plot([Mu-Sigma Mu-Sigma],[0 max(n)],'--r');
            plot([Mu+Sigma Mu+Sigma],[0 max(n)],'--r');
            plot([Mu-2*Sigma Mu-2*Sigma],[0 max(n)],'--r');
            plot([Mu+2*Sigma Mu+2*Sigma],[0 max(n)],'--r');
        end
    end
end