function runOsmosis_dti_rrmse
% Caliculate the cross validation coeffcient of determination for the DTI
% model
%
%
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
        'JMD-Ctl-HH-20120907DWI' % i = 19
        'JMD-Ctl-HT-20120907-DWI' % i = 20
    'JMD-Ctl-FN-20130621-DWI'
    'JMD-Ctl-AM-20130726-DWI'
    'JMD-Ctl-SO-20130726-DWI'
    'RP1-TT-2013-11-01'
    'RP2-KI-2013-11-01'
    'RP3-TO-13120611-DWI'
    'LHON6-SS-20131206-DWI'
    'RP4-AK-2014-01-31'
    'RP5-KS-2014-01-31'};


%% command run osmosis-dti-rrmse.py with wmMask
matlabpool;
parfor i =1:length(subDir)
    cd(fullfile(homeDir, subDir{i},'raw'))
    !osmosis-dti-rrmse.py dwi1st_aligned_trilin.nii.gz dwi1st_aligned_trilin.bvecs dwi1st_aligned_trilin.bvals dwi2nd_aligned_trilin.nii.gz dwi2nd_aligned_trilin.bvecs dwi2nd_aligned_trilin.bvals dti_rrmse_wmMask.nii.gz --mask_file wmMask.nii.gz

end
matlabpool close;

%% grab the rrmse in B-OR 
for i = [1:18,21:length(subDir)];
    cd(fullfile(homeDir, subDir{i},'raw'))
    % load a dt6 file
    dt  = fullfile(homeDir,subDir{i},'dwi_2nd','dt6.mat');
    dt  = dtiLoadDt6(dt);
    
    rrmse_ni = niftiRead('dti_rrmse_wmMask.nii.gz');

% showMontage(rrmse_ni.data) 
% hist(rrmse_ni.data(:)>1)
    orig_ni =  rrmse_ni.data;
    ni1 = niftiRead('BOR1206_D4L4_rsquared_rGM.nii.gz');
    ni2 = niftiRead('BOR1206_D4L4_rsquared.nii.gz');
    %
    ind1 = ni1.data(:)>0;
    orig_ni(~ind1)=0;
    N1name = 'BOR_rrmse_rGM.nii.gz';    
    Ni1 =  dtiWriteNiftiWrapper(orig_ni, dt.xformToAcpc, N1name);
    %
    orig_ni =  rrmse_ni.data;
    ind2 = ni2.data(:)>0;
    orig_ni(~ind2)=0;
    N2name = 'BOR_rrmse_wGM.nii.gz';    
    Ni2 =  dtiWriteNiftiWrapper(orig_ni, dt.xformToAcpc, N2name);
    
   rrmse_rGM{i} = Ni1.data(Ni1.data(:)>0);  
   rrmse_wGM{i} = Ni2.data(Ni2.data(:)>0);
   
end


%% save
cd /biac4/wandell/biac3/wandell7/shumpei/matlab/git/LHON/3RP/Osmosis_results

save rrmse_rGM rrmse_rGM;
save rrmse_wGM rrmse_wGM;
%% load rrmse files

cd /biac4/wandell/biac3/wandell7/shumpei/matlab/git/LHON/3RP/Osmosis_results

load rrmse_rGM rrmse_rGM;
load rrmse_wGM rrmse_wGM;

%%
JMD  = [1,3,5,6];
CRD  = [2,4,7,8,9];
LHON = [10:15];
Ctl  = 16:23;
RP   = [24:26,28,29];

deseases = {JMD,CRD,LHON,Ctl,RP};
Deseases = {'JMD','CRD','LHON','Ctl','RP'};

%% compare the rrmse across groups
figure; hold on;

y = {vertcat(rrmse_rGM{LHON}),vertcat(rrmse_rGM{CRD}),vertcat(rrmse_rGM{Ctl}),vertcat(rrmse_rGM{RP})};

Y = [mean(vertcat(rrmse_rGM{LHON})),mean(vertcat(rrmse_rGM{CRD})),mean(vertcat(rrmse_rGM{Ctl})),mean(vertcat(rrmse_rGM{RP}))];
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
%% save the picture
cd /biac4/wandell/biac3/wandell7/shumpei/matlab/git/LHON/3RP/Osmosis_results
print(gcf,'-dpng','ORrrmse_rGM_4group')

%% compare the rrmse across groups
figure; hold on;

y = {vertcat(rrmse_wGM{LHON}),vertcat(rrmse_wGM{CRD}),vertcat(rrmse_wGM{Ctl}),vertcat(rrmse_wGM{RP})};

Y = [mean(vertcat(rrmse_wGM{LHON})),mean(vertcat(rrmse_wGM{CRD})),mean(vertcat(rrmse_wGM{Ctl})),mean(vertcat(rrmse_wGM{RP}))];
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

%% save the picture
cd /biac4/wandell/biac3/wandell7/shumpei/matlab/git/LHON/3RP/Osmosis_results
print(gcf,'-dpng','ORrrmse_wGM_4group')


%% grab the rrmse in B-OR 
for i = [1:length(subDir)];
    cd(fullfile(homeDir, subDir{i},'raw'))
    % load a dt6 file
%     dt  = fullfile(homeDir,subDir{i},'dwi_2nd','dt6.mat');
%     dt  = dtiLoadDt6(dt);
%     
    rrmse_ni = niftiRead('dti_rrmse_wmMask.nii.gz');
    
    ind =  rrmse_ni.data(:)>0;
    rrmse_whole{i} = rrmse_ni.data(ind);
 end
%% save
cd /biac4/wandell/biac3/wandell7/shumpei/matlab/git/LHON/3RP/Osmosis_results

save rrmse_whole rrmse_whole;
%% compare the rsquare across groups
figure; hold on;

y = {vertcat(rrmse_whole{LHON}),vertcat(rrmse_whole{CRD}),vertcat(rrmse_whole{Ctl}),vertcat(rrmse_whole{RP})};

Y = [mean(vertcat(rrmse_whole{LHON})),mean(vertcat(rrmse_whole{CRD})),mean(vertcat(rrmse_whole{Ctl})),mean(vertcat(rrmse_whole{RP}))];
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
%% save the picture
cd /biac4/wandell/biac3/wandell7/shumpei/matlab/git/LHON/3RP/Osmosis_results
print(gcf,'-dpng','ORrrmse_whole_4group')
