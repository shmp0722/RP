function runOsmosisDtiRsquared
% Caliculate the cross validation coeffcient of determination for the DTI
% model using same diffusion tendsor model
%

homeDir = '/biac4/wandell/biac2/wandell/data/DWI-Tamagawa-Japan';
subDir = {...
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
    'JMD-Ctl-SO-20130726-DWI'
    'RP1-TT-2013-11-01'
    'RP2-KI-2013-11-01'
    'RP3-TO-13120611-DWI'
    'LHON6-SS-20131206-DWI'
    'RP4-AK-2014-01-31'
    'RP5-KS-2014-01-31'};


% %% command run Osmosis-dti-rsquered orig
% for i =1:length(subDir)
%     cd(fullfile(homeDir, subDir{i},'raw'))
%     !osmosis-dti-rsquared.py dwi1st_aligned_trilin.nii.gz dwi1st_aligned_trilin.bvecs dwi1st_aligned_trilin.bvals dwi2nd_aligned_trilin.nii.gz dwi2nd_aligned_trilin.bvecs dwi2nd_aligned_trilin.bvals dti_rsquared.nii.gz
% end
% return
%%
JMD  = [1,3,5,6];
CRD  = [2,4,7,8,9];
LHON = [10:15];
Ctl  = 16:23;
RP   = [24:26,28,29];

deseases = {JMD,CRD,LHON,Ctl,RP};
Deseases = {'JMD','CRD','LHON','Ctl','RP'};


%% command run Osmosis-dti-rsquared SO
parfor i =1:length(subDir)
    cd(fullfile(homeDir, subDir{i},'raw'))
    !osmosis-dti-rsquared.py dwi2nd_aligned_trilin.nii.gz dwi2nd_aligned_trilin.bvecs dwi2nd_aligned_trilin.bvals dwi2nd_aligned_trilin.nii.gz dwi2nd_aligned_trilin.bvecs dwi2nd_aligned_trilin.bvals dti2nd_rsquared.nii.gz
end


%% run Osmosis-dti-rsquared with white matter mask
matlabpool;
parfor i =3:length(subDir)
    copyfile(fullfile(homeDir, subDir{i},'/dwi_2nd/bin/wmMask.nii.gz'),fullfile(homeDir, subDir{i},'/raw/wmMask.nii.gz'));
    cd(fullfile(homeDir, subDir{i},'raw'))
    !osmosis-dti-rsquared.py dwi2nd_aligned_trilin.nii.gz dwi2nd_aligned_trilin.bvecs dwi2nd_aligned_trilin.bvals dwi2nd_aligned_trilin.nii.gz dwi2nd_aligned_trilin.bvecs dwi2nd_aligned_trilin.bvals dti2nd_rsquared_wm.nii.gz --mask_file wmMask.nii.gz
end

%% compare rsquared data across group
for i =1:length(subDir)
    cd(fullfile(homeDir, subDir{i},'raw'))
    
    % load rsquared file.nii.gz
    Dti_rsquared = niftiRead('dti2nd_rsquared.nii.gz');
    
    %     % load the fiber group and dt6 files
    fgDir  = fullfile(homeDir,subDir{i},'/dwi_2nd/fibers');
    dt  = fullfile(homeDir,subDir{i},'dwi_2nd','dt6.mat');
    dt  = dtiLoadDt6(dt);
    
    % load cortex.nii.gz
    % WMmask = niftiRead(fullfile(homeDir,subDir{i},'dwi_2nd/bin/wmMask.nii.gz'));
    
    % load fg
    fgN ={'ROR1206_D4L4.pdb','LOR1206_D4L4.pdb'};
    
    for j = 2%1: length(fgN)
        % load fg
        fg = fgRead(fullfile(fgDir,fgN{j}));
        
        % Now let's get all of the coordinates that the fibers go through
        coords = horzcat(fg.fibers{:});
        
        % get the unique coordinates
        coords_unique = unique(floor(coords'),'rows');
        
        % These coordsinates are in ac-pc (millimeter) space. We want to transform
        % them to image indices.
        img_coords = unique(floor(mrAnatXformCoords(inv(dt.xformToAcpc), coords_unique)), 'rows');
        
        % Now lets take these coordinates and turn them into an image. First we
        % will create an image of zeros
        Tract_img = zeros(size(Dti_rsquared.data));
        % Convert these coordinates to image indices
        ind = sub2ind(size(Dti_rsquared.data), img_coords(:,1), img_coords(:,2),img_coords(:,3));
        % Now replace every coordinate that has the optic radiations with a 1
        OR_rs = Dti_rsquared.data(ind);
        %         Dti_rsquared.data(~ind)=0;
        %         OR_PosRs = OR_rs(OR_rs>0);
        %         minmax(OR_rs)
        
        m{i,j}  = OR_rs;
        %         m2(i,j) = mean(OR_PosRs);
        %         sd(i,j) = std(OR_rs);
        %
        %
        %         % % Now you have an image. Just for your own interest if you want to make a
        %         % % 3d rendering
        Tract_img(ind) = 1;
        %                 isosurface(OR_img,.5);
        Dti_rsquared.data(~Tract_img)=0;
        
        % save nifti
        niftiWrite(Dti_rsquared,[fg.name,'_rsquared.nii.gz'])
        
        %         %% select voxels within WM mask
        %         ind2 =find(WMmask.data==0);
        %
        %         Dti_rsquared.data(ind2)
        %
        %                 % save nifti
        %         niftiWrite(Dti_rsquared,[fg.name,'_rsquared_WM.nii.gz'])
        
    end
end

%% Just caliculate RS. You already have rsquared values in tract
for i =1:length(subDir)
    cd(fullfile(homeDir, subDir{i},'raw'))
    
    % load rsquared file.nii.gz
    rs = {'ROR1206_D4L4_rsquared.nii.gz','LOR1206_D4L4_rsquared.nii.gz'};
    
    % keep rs value in each subject
    for j = 1 : length(rs)
        ni = niftiRead(rs{j});
        ind = ni.data(:)>0;
        m{i,j} = ni.data(ind);
    end
end

%% compare the rsquare across groups
figure; hold on;

y = {vertcat(m{LHON,1}),vertcat(m{CRD,1}),vertcat(m{Ctl,1}),vertcat(m{RP,1})};

Y = [mean(vertcat(m{LHON,1})),mean(vertcat(m{CRD,1})),mean(vertcat(m{Ctl,1})),mean(vertcat(m{RP,1}))];
h = bar(Y);
% get
[~, numbars] = size(Y);

xdata = get(h,'XData');
centerX = xdata;
centerY = Y;

E = [std(y{1}),std(y{2}),std(y{3}),std(y{4})];
% C = {'b','g','r'};

% legend(h,'LHON','CRD','Ctl','RP');

for i = 1:numbars
    errorbar(centerX(i), Y(i), E(i))%, C{i},...
%         'linestyle', 'none','LineWidth',2);
end
hold off;

%% compare the rsquare across groups
figure; hold on;

y = {vertcat(m{LHON,1}),vertcat(m{CRD,1}),vertcat(m{Ctl,1}),vertcat(m{RP,1})};

Y = [mean(vertcat(m{LHON,1})),mean(vertcat(m{CRD,1})),mean(vertcat(m{Ctl,1}))];
h = bar(Y);
% get
[~, numbars] = size(Y);

xdata = get(h,'XData');
centerX = xdata;
centerY = Y;

E = [std(y{1}),std(y{2}),std(y{3}),std(y{4})];
% C = {'b','g','r'};

% legend(h,'LHON','CRD','Ctl','RP');

for i = 1:numbars
    errorbar(centerX(i), Y(i), E(i))%, C{i},...
%         'linestyle', 'none','LineWidth',2);
end
hold off;

%% Create nifti fiber ROI
for i =1:length(subDir)
    rawDir = fullfile(homeDir, subDir{i},'raw');
    cd(rawDir)
    roiDir =  fullfile(homeDir, subDir{i},'dwi_2nd/ROIs');
    %     % load the fiber group and dt6 files
    fgDir  = fullfile(homeDir,subDir{i},'/dwi_2nd/fibers');
    dt  = fullfile(homeDir,subDir{i},'dwi_2nd','dt6.mat');
    dt  = dtiLoadDt6(dt);
    
    % load fg
    fgN ={'ROR1206_D4L4.pdb','LOR1206_D4L4.pdb'};
    
    for j = 1: length(fgN)
        % load fg
        fgF{j} = fgRead(fullfile(fgDir,fgN{j}));
    end
    fgF{3} = fgF{1};
    fgF{3}.fibers = vertcat(fgF{1}.fibers,fgF{2}.fibers);
    
    % nifti fg ROI
    fgF{3}.name = 'BOR_D4L2';
    Nroi = fiberROI(fgF{3}, dt, fgF{3}.name);
    
    
    %         ind = find(Nroi.data(WMmask.data==1 & Nroi.data>0));
    %         Nroi.data(~ind)=0;
    
    
end



%% Creat nifti ROI, merging L and R OR
for i =28:length(subDir)
    cd(fullfile(homeDir, subDir{i},'raw'))
    
    % load rsquared file.nii.gz
    rs = {'ROR1206_D4L4_rsquared.nii.gz','LOR1206_D4L4_rsquared.nii.gz'};
    dt  = fullfile(homeDir,subDir{i},'dwi_2nd','dt6.mat');
    dt  = dtiLoadDt6(dt);
%     fa = dtiComputeFA(dt.dt6);
    
    % merge L and R OR
    % hack the parameter
    ni = niftiRead(rs{1}); ni2 = niftiRead(rs{2});
    %     ni.qto_xyz = Nroi.qto_xyz;
    %     ni.qto_ijk = Nroi.qto_ijk;
    %     ni.quatern_b = Nroi.quatern_b;
    %     ni.quatern_c = Nroi.quatern_c;
    %     ni.quatern_d = Nroi.quatern_d;
    %     ni.qform_code= Nroi.qform_code;
    
    %
    %     roi = dtiWriteNiftiWrapper(ni.data, dt.xformToAcpc, ['Test_' ,ni.fname]);
    %     roi = dtiWriteNiftiWrapper(ni2.data, dt.xformToAcpc, ['Test_' ,ni2.fname]);
    
    
    BOR.data = ni.data + ni2.data;
    BOR.fname = 'BOR1206_D4L4_rsquared.nii.gz';
    BORroi =  dtiWriteNiftiWrapper(BOR.data, dt.xformToAcpc, BOR.fname);
    
    %     niftiWrite(BOR, BOR.fname)
    
    %% Create gray matter mask
    roiDir =  fullfile(homeDir,'freesurfer',subDir{i},'label');
    cd(roiDir)
    
    
    lh_cortex = niftiRead('lh_cortex.nii.gz');
    rh_cortex = niftiRead('rh_cortex.nii.gz');
    
    whole_cortex = lh_cortex;
    whole_cortex.data = lh_cortex.data + rh_cortex.data;
    whole_cortex.data(whole_cortex.data==2)=1;
    whole_cortex.fname = 'whole_cortex.nii.gz';
    
    %     niftiWrite(whole_cortex,whole_cortex.fname)
    [whole_cortex_2iso, ~] = mrAnatResampleToNifti(whole_cortex, BORroi,'whole_cortex_2iso.nii.gz',[]);
    
    % remove gray matter
    BORroi.data(whole_cortex_2iso.data==1)=0;
    BORroi.fname = 'BOR1206_D4L4_rsquared_rGM.nii.gz';
    % save BOR with out gray matter voxels
    cd(fullfile(homeDir, subDir{i},'raw'))
    BORroi =  dtiWriteNiftiWrapper(BORroi.data, dt.xformToAcpc, BORroi.fname);
    
    % showMontage(BOR.data)
    % colormap 'jet'
    
    
    ind = BORroi.data(:)>0;
    mOR{i} = BORroi.data(ind);
    
  
end
%% save the results 
cd /biac4/wandell/biac3/wandell7/shumpei/matlab/git/LHON/3RP/Osmosis_results

save mOR_rGM_D4L4 mOR

%% compare the rsquare across groups
figure; hold on;

y = {vertcat(mOR{LHON}),vertcat(mOR{CRD}),vertcat(mOR{Ctl}),vertcat(mOR{RP})};

Y = [mean(vertcat(mOR{LHON})),mean(vertcat(mOR{CRD})),mean(vertcat(mOR{Ctl})),mean(vertcat(mOR{RP}))];
h = bar(Y);
% get
[~, numbars] = size(Y);

xdata = get(h,'XData');
centerX = xdata;
centerY = Y;

E = [std(y{1}),std(y{2}),std(y{3}),std(y{4})];
% C = {'b','g','r'};

% legend(h,'LHON','CRD','Ctl','RP');

for i = 1:numbars
    errorbar(centerX(i), Y(i), E(i))%, C{i},...
%         'linestyle', 'none','LineWidth',2);
end
hold off;


%% visualize the pearson corelation in optic radiation

for i =1:length(subDir)
    cd(fullfile(homeDir, subDir{i},'raw'))
    
    ni1 = niftiRead('BOR1206_D4L4_rsquared_rGM.nii.gz');
    ni2 = niftiRead('BOR1206_D4L4_rsquared.nii.gz');
    
    showMontage(ni1.data)
    colormap 'jet'
    showMontage(ni2.data)
    colormap 'jet'
    
end

%% compare diffusivity in voxel base
for i =1:length(subDir)
    cd(fullfile(homeDir, subDir{i},'raw'))
    
    % caliculatre diffusivities
    dt  = fullfile(homeDir,subDir{i},'dwi_2nd','dt6.mat');
    dt  = dtiLoadDt6(dt);
    [fa,md,rd,ad] = dtiComputeFA(dt.dt6);
        
    % take voxels of OR
    ni1 = niftiRead('BOR1206_D4L4_rsquared_rGM.nii.gz');
    ni2 = niftiRead('BOR1206_D4L4_rsquared.nii.gz');
    
    % 
    rGM{i}.fa = fa(ni1.data>0);
    wGM{i}.fa = fa(ni2.data>0);
    
    
    fa = nanreplace(fa);
    ind = find(fa(ni1.data>0));

   
    fa(~ind) = 0;
    showMontage(fa)
    
    rGM{i}.md = md(ni1.data>0);
    wGM{i}.md = md(ni2.data>0);
    
    rGM{i}.ad = ad(ni1.data>0);
    wGM{i}.ad = ad(ni2.data>0);
    
    rGM{i}.rd = rd(ni1.data>0);
    wGM{i}.rd = rd(ni2.data>0);
    
    
    % mean
    fa_rGM_mean{i} = nanmean(rGM{i}.fa);
    fa_wGM_mean{i} = nanmean(wGM{i}.fa);
    
    md_rGM_mean{i} = nanmean(rGM{i}.md);
    md_wGM_mean{i} = nanmean(wGM{i}.md);
    
    ad_rGM_mean{i} = nanmean(rGM{i}.ad);
    ad_wGM_mean{i} = nanmean(wGM{i}.ad);
    
    rd_rGM_mean{i} = nanmean(rGM{i}.rd);
    rd_wGM_mean{i} = nanmean(wGM{i}.rd);
%     % std
%     fa_rGM_std{i} = nanstd(fa_rGM);
%     fa_wGM_std{i} = nanstd(fa_wGM);
%     
%     md_rGM_std{i} = nanstd(md_rGM);
%     md_wGM_std{i} = nanstd(md_wGM);
%     
%     ad_rGM_std{i} = nanstd(ad_rGM);
%     ad_wGM_std{i} = nanstd(ad_wGM);
%     
%     rd_rGM_std{i} = nanstd(rd_rGM);
%     rd_wGM_std{i} = nanstd(rd_wGM);


end

%% compare the fa in optic radiation across groups
figure; hold on;

y = {vertcat(fa_rGM_mean{LHON}),vertcat(fa_rGM_mean{CRD}),vertcat(fa_rGM_mean{Ctl}),vertcat(fa_rGM_mean{RP})};

Y = [mean(vertcat(fa_rGM_mean{LHON})),mean(vertcat(fa_rGM_mean{CRD})),mean(vertcat(fa_rGM_mean{Ctl})),mean(vertcat(fa_rGM_mean{RP}))];
h = bar(Y);
% get
[~, numbars] = size(Y);

xdata = get(h,'XData');
centerX = xdata;
centerY = Y;

E = [std(y{1}),std(y{2}),std(y{3}),std(y{4})];
% C = {'b','g','r'};

% legend(h,'LHON','CRD','Ctl','RP');

for i = 1:numbars
    errorbar(centerX(i), Y(i), E(i))%, C{i},...
%         'linestyle', 'none','LineWidth',2);
end
hold off;

%% compare the fa in optic radiation across groups
figure; hold on;

y = {vertcat(fa_wGM_mean{LHON}),vertcat(fa_wGM_mean{CRD}),vertcat(fa_wGM_mean{Ctl}),vertcat(fa_wGM_mean{RP})};

Y = [mean(vertcat(fa_rGM_mean{LHON})),mean(vertcat(fa_rGM_mean{CRD})),mean(vertcat(fa_rGM_mean{Ctl})),mean(vertcat(fa_rGM_mean{RP}))];
h = bar(Y);
% get
[~, numbars] = size(Y);

xdata = get(h,'XData');
centerX = xdata;
centerY = Y;

E = [std(y{1}),std(y{2}),std(y{3}),std(y{4})];
% C = {'b','g','r'};

% legend(h,'LHON','CRD','Ctl','RP');

for i = 1:numbars
    errorbar(centerX(i), Y(i), E(i))%, C{i},...
%         'linestyle', 'none','LineWidth',2);
end
hold off;
