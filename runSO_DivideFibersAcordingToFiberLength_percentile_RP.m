function [TractProfile] = runSO_DivideFibersAcordingToFiberLength_percentile_RP
%%
[homeDir,subDir,JMD,CRD,LHON,Ctl,RP,AMDC] = Tama_subj2;

% Calculate vals along the fibers and return TP structure

fgN ={'LOR1206_D4L4.pdb','ROR1206_D4L4.pdb','LOTD4L4_1206.pdb','ROTD4L4_1206.pdb'};
% Fg  = {'LOTD4L4_1206.pdb','LOR1206_D4L4.pdb','ROTD4L4_1206.pdb','ROR1206_D4L4.pdb'};

Subs = [RP,Ctl,AMDC];
%% get diffusivities based on fiber length (percentile)
for ii =1:length(Subs)
    % define directory
    SubDir = fullfile(homeDir,subDir{Subs(ii)});
    fgDir  = fullfile(SubDir,'/dwi_2nd/fibers');
    %     newDir = fullfile(SubDir,'/dwi_2nd/fibers/conTrack/OR_1130');
    %     roiDir = fullfile(SubDir,'/dwi_2nd/ROIs');
    dt  = fullfile(homeDir,subDir{Subs(ii)},'dwi_2nd','dt6.mat');
    dt  = dtiLoadDt6(dt);
    
    for j =1:length(fgN)
        fg = fgRead(fullfile(fgDir,fgN{j}));
        
        [TractProfile{ii,j}, ~,~,~,~,~]...
            = SO_DivideFibersAcordingToFiberLength_percentile(fg,dt,0,'AP',100);
    end
end
%%
save /biac4/wandell/biac2/wandell/data/DWI-Tamagawa-Japan2/RP/RP_OTOR_PrCentile.mat TractProfile
return