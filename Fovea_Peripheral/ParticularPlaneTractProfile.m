function[ TractProfile_R,TractProfile_L ] = ParticularPlaneTractProfile(val,X,nodes)
% To take TractProfile along one patrticular 
% eccentoricity.
% val = 'fa','md','ad','rd'
%
%% Identify directory
[homeDir,subDir,JMD,CRD,LHON,Ctl,RP] = Tama_subj2;
%% Calculate vals along the fibers and return TP structure
for i =1:length(subDir)
    % define directory
    fgDir  = fullfile(homeDir,subDir{i},'/dwi_2nd/fibers/conTrack/OR_Top100K_V1_3mm_clipped_LGN4mm');
    dt  = fullfile(homeDir,subDir{i},'dwi_2nd','dt6.mat');
    dt  = dtiLoadDt6(dt);
%     t1w = niftiRead(dt.files.t1);
    
    % Right
    % load Right Optic radiation
    fgN = dir(fullfile(fgDir,'*Lh_NOT1201_MD4.pdb'));
    fg = fgRead(fullfile(fgDir,fgN.name));
    
    % cut point
    for jj= 1 : length(X)
        % Take the voxels on X
        fgOut = dtiClipFiberGroup(fg, [X(jj)+1, 80], [-60, 80], [],0);
        fgOut1 = dtiClipFiberGroup(fgOut, [-80, X(jj)-1], [], [],0);
        
        
        ind    = cellfun(@length, fgOut1.fibers)<11;
        fgOut2 = fgOut1;
        fgOut2.fibers = fgOut1.fibers(ind);
      
        % TractProfile
        [TractProfile_R{i,jj}] = SO_FiberValsInTractProfiles(fgOut2,dt,'AP',nodes,1);
    end
    
    % Left
    % load Right Optic radiation
    fgN = dir(fullfile(fgDir,'*Rh_NOT1201_MD4.pdb'));
    fg = fgRead(fullfile(fgDir,fgN.name));  
    
    for jj= 1 : length(X)
        % Take the voxels on X
        fgOut = dtiClipFiberGroup(fg, [-X(jj)-1, 80], [-60, 80], [],0);
        fgOut1 = dtiClipFiberGroup(fgOut, [-80, -X(jj)+1], [], [],0);        
        
        ind    = cellfun(@length, fgOut1.fibers)<11;
        fgOut2 = fgOut1;
        fgOut2.fibers = fgOut1.fibers(ind);
       
        % TractProfile
        [TractProfile_L{i,jj}] = SO_FiberValsInTractProfiles(fgOut2,dt,'AP',nodes,1);
    end
end
TractProfile_L, TractProfile_R
return
%%
% cd('/biac4/wandell/biac2/wandell/data/DWI-Tamagawa-Japan2/results') 
% mkdir('ParticularPlane');
% cd('ParticularPlane')
% 
% savenameL = sprintf('TP_%snodes_L',nodes);
% savenameR = sprintf('TP_%snodes_R',nodes);
% 
% save  savenameL TractProfile_L
% save  TP_node10_R TractProfile_R 
%% Plot vals
% make one sheet diffusivity
for subID = 1:length(subDir);
    if isempty(TractProfile_R{subID}.nfibers);
        fa_R(subID,:) = nan(1,nodes);
    else
        fa_R(subID,:) = TractProfile_R{subID}.vals.fa;
    end;
    
    if isempty(TractProfile_R{subID}.nfibers);
        md_R(subID,:) =nan(1,nodes);
    else
        md_R(subID,:) = TractProfile_R{subID}.vals.md;
    end;
    
    if isempty(TractProfile_R{subID}.nfibers);
        rd_R(subID,:) =nan(1,nodes);
    else
        rd_R(subID,:) = TractProfile_R{subID}.vals.rd;
    end;
    
    if isempty(TractProfile_R{subID}.nfibers);
        ad_R(subID,:) =nan(1,nodes);
    else
        ad_R(subID,:) = TractProfile_R{subID}.vals.ad;
    end;
    
    % L
    if isempty(TractProfile_L{subID}.nfibers);
        fa_L(subID,:) =nan(1,nodes);
    else
        fa_L(subID,:) =  TractProfile_L{subID}.vals.fa;
    end;
    
    if isempty(TractProfile_L{subID}.nfibers);
        md_L(subID,:) =nan(1,nodes);
    else
        md_L(subID,:) = TractProfile_L{subID}.vals.md;
    end;
    
    if isempty(TractProfile_L{subID}.nfibers);
        rd_L(subID,:) =nan(1,nodes);
    else
        rd_L(subID,:) = TractProfile_L{subID}.vals.rd;
    end;
    
    if isempty(TractProfile_L{subID}.nfibers);
        ad_L(subID,:) =nan(1,nodes);
    else
        ad_L(subID,:) = TractProfile_L{subID}.vals.ad;
    end;
end

%%
switch val
    case 'fa'
        Val = fa;
    case 'md'
        Val = md;
    case 'ad'
        Val = ad;
    case 'rd'
        Val = rd;
end

%%
figure; hold on;
X = 1: nodes;
c = lines(length(subDir));

% Control
st = nanstd(fa_R(Ctl,:),1);
m   = nanmean(fa_R(Ctl,:));

% render control subjects range
A3 = area(m+2*st);
A1 = area(m+st);
A2 = area(m-st);
A4 = area(m-2*st);

% set color and style
set(A1,'FaceColor',[0.6 0.6 0.6],'linestyle','none')
set(A2,'FaceColor',[0.8 0.8 0.8],'linestyle','none')
set(A3,'FaceColor',[0.8 0.8 0.8],'linestyle','none')
set(A4,'FaceColor',[1 1 1],'linestyle','none')

plot(m,'color',[0 0 0], 'linewidth',3 )
clear m

% add individual FA plot
for k = CRD %1:length(subDir)
    plot(X,fa_R(k,:),'Color',c(3,:),...
        'linewidth',1);
end
m   = nanmean(fa_R(CRD,:));
plot(X,m,'Color',c(3,:) ,'linewidth',3)
clear m

% add individual
for k = RP %1:length(subDir)
    plot(X,fa_R(k,:),'Color',c(1,:),'linewidth',1);
end
% plot mean value
m   = nanmean(fa_R(RP,:));
plot(X,m,'Color',c(1,:) ,'linewidth',3)

% add label
xlabel('Location Peri -> foveal','fontName','Times','fontSize',14);
ylabel('Fractional anisotropy','fontName','Times','fontSize',14);
title('Slice at X = +/- 25','fontName','Times','fontSize',14)
axis([1, nodes ,0.1, 0.800001])

%%
id = RP;
for ii = 1:length(RP)
    plot(X, TractProfile_L{id(ii)}.vals.fa)
%     % Current subject
%     cur_subj = subDir{id(ii)}; 
%     tmp = find(cur_subj=='-');
%     cur_subjname = cur_subj(1:tmp(1)-1);
end

id = CRD;
for ii = 1:length(CRD)
    plot(X, TractProfile_L{id(ii)}.vals.fa,'r')
    % Current subject
    cur_subj = subDir{id(ii)}; 
    tmp = find(cur_subj=='-');
    cur_subjname = cur_subj(1:tmp(1)-1);
end

id = Ctl;
for ii = 1:length(Ctl)
    plot(X, TractProfile_L{id(ii)}.vals.fa,'color', [0 0 0])
    % Current subject
    cur_subj = subDir{id(ii)}; 
    tmp = find(cur_subj=='-');
    cur_subjname = cur_subj(1:tmp(1)-1);
end
hold off;

