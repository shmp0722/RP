%
% This script is used for the analysis of fiber groups. It returns
% fiber values in a tab delimited text file that can be read into
% excel. The text file is saved in the baseDirectory by default.
%
% Values returned include:
% avgFA avgMD avgRD avgAD avgLength minLength maxLength
%
% subCodeList = '.txt';
% subs        = textread(subCodeList, '%s'); fprintf('\nWill process %d subjects...\n\n',numel(subs));
%
% HISTORY:
% 11.2.10  - LMP wrote the thing.

%% Set directory structure
%% I. Directory and Subject Informatmation
dirs          = 'dwi_2nd';
logDir        = '/biac2b/data1/finra/DTI/';
baseDir       = '/biac4/wandell/biac2/wandell/data/DWI-Tamagawa-Japan';
subs = {...
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
    'JMD-Ctl-AM-20130726-DWI'};
% subsSession2  = {'bg','jo','kc','mc','md','na'};

% Set fiber groups
RoiName   = {'Optic-Chiasm.mat'};
% /biac4/wandell/biac2/wandell/data/DWI-Tamagawa-Japan/JMD-Ctl-AM-20130726-DWI/dwi_2nd/fibers

% Loads MoriGroups
% load('/biac2b/data1/finra/DTI/fgNames.mat');
% fiberName = fgNames;

%% Set up the text file that will store the fiber vals.
dateAndTime     = getDateAndTime;
textFileName    = fullfile(baseDir,['ROIVals_',dateAndTime,'.csv']);
[fid1 message]  = fopen(textFileName, 'w');
% fprintf(fid1, 'Subject Code \t Fiber Name \t Mean FA \t Mean MD \t Mean Radial ADC \t Mean Axial ADC \t Number of Fibers (arb) \t Mean Length \t Min Length \t Max Length \t Mean Score \n');


%% Run the fiber properties functions
for ii=1:length(subs)
    sub = dir(fullfile(baseDir,[subs{ii} '*']));
    
    subDir   = fullfile(baseDir,sub.name);
    dt6Dir   = fullfile(subDir,dirs);
    fiberDir = fullfile(dt6Dir,'fibers');
    roiDir   = fullfile(subDir,'dwi_2nd','ROIs');
    
    dt = dtiLoadDt6(fullfile(dt6Dir,'dt6.mat'));
    
    fprintf('\nProcessing %s\n', subDir);
    
    % Read in fiber groups
    %             for kk=1:numel(RoiName)
    %                 RoiGroup = fullfile(roiDir, RoiName{kk});
    
    RoiGroup = fullfile(roiDir, RoiName);
    
    %         if exist(RoiGroup,'file')
    %             disp(['Computing dtiVals for ' RoiGroup ' ...']);
    %             try
    cd(roiDir)
    roi = dtiReadRoi('Optic-Chiasm.mat');
    
    % Compute the fiber statistics and write them to the text file
    %                 coords = horzcat(roi.coords)';
    numberOfVoxel=length(roi.coords);
    
    %                 % Measure the step size of the first fiber. They *should* all be the same!
    %                 stepSize = mean(sqrt(sum(diff(roi.fibers{1},1,2).^2)));
    %                 fiberLength = cellfun('length',roi.fibers);
    
    % The rest of the computation does not require remembering which node
    % belongd to which fiber.
    [val1,val2,val3,val4,val5,val6] = dtiGetValFromTensors(dt.dt6, roi.coords, inv(dt.xformToAcpc),'dt6','nearest');
    dt6 = [val1,val2,val3,val4,val5,val6];
    
    % Clean the data in two ways.
    % Some fibers extend a little beyond the brain mask. Remove those points by
    % exploiting the fact that the tensor values out there are exactly zero.
    dt6 = dt6(~all(dt6==0,2),:);
    
    % There shouldn't be any nans, but let's make sure:
    dt6Nans = any(isnan(dt6),2);
    if(any(dt6Nans))
        dt6Nans = find(dt6Nans);
        for jj=1:6
            dt6(dt6Nans,jj) = 0;
        end
        fprintf('\ NOTE: %d fiber points lengthhad NaNs. These will be ignored...',length(dt6Nans));
        disp('Nan points (ac-pc coords):');
        for jj=1:length(dt6Nans)
            fprintf('%0.1f, %0.1f, %0.1f\n',coords(dt6Nans(jj),:));
        end
    end
    
    % We now have the dt6 data from all of the fibers.  We
    % extract the directions into vec and the eigenvalues into
    % val.  The units of val are um^2/sec or um^2/msec
    % mrDiffusion tries to guess the original units and convert
    % them to um^2/msec. In general, if the eigenvalues are
    % values like 0.5 - 3.0 then they are um^2/msec. If they
    % are more like 500 - 3000, then they are um^2/sec.
    [vec,val] = dtiEig(dt6);
    
    % Some of the ellipsoid fits are wrong and we get negative eigenvalues.
    % These are annoying. If they are just a little less than 0, then clipping
    % to 0 is not an entirely unreasonable thing. Maybe we should check for the
    % magnitude of the error?
    nonPD = find(any(val<0,2));
    if(~isempty(nonPD))
        fprintf('\n NOTE: %d fiber points had negative eigenvalues. These will be clipped to 0...\n', numel(nonPD));
        val(val<0) = 0;
    end
    
    threeZeroVals=find(sum(val,2)==0);
    if ~isempty (threeZeroVals)
        fprintf('\n NOTE: %d of these fiber points had all three negative eigenvalues. These will be excluded from analyses\n', numel(threeZeroVals));
    end
    
    val(threeZeroVals,:)=[];
    
    % Now we have the eigenvalues just from the relevant fiber positions - but
    % all of them.  So we compute for every single node on the fibers, not just
    % the unique nodes.
    [fa,md,rd,ad] = dtiComputeFA(val);
    
    %Some voxels have all the three eigenvalues equal to zero (some of them
    %probably because they were originally negative, and were forced to zero).
    %These voxels will produce a NaN FA
    FA(1)=min(fa(~isnan(fa)));
    FA(2)=mean(fa(~isnan(fa)));
    FA(3)=max(fa(~isnan(fa))); % isnan is needed because sometimes if all the three eigenvalues are negative, the FA becomes NaN. These voxels are noisy.
    MD(1)=min(md);
    MD(2)=mean(md);
    MD(3)=max(md);
    radialADC(1) = min(rd);
    radialADC(2) = mean(rd);
    radialADC(3) = max(rd);
    axialADC(1)  = min(ad);
    axialADC(2)  = mean(ad);
    axialADC(3)  = max(ad);
    %                 length(1) = mean(fiberLength)*stepSize;
    %                 length(2) = min(fiberLength)*stepSize;
    %                 length(3) = max(fiberLength)*stepSize;
    
    avgFA = FA(2);
    avgMD = MD(2);
    avgRD = radialADC(2);
    avgAD = axialADC(2);
    %                 avgLength = length(1);
    %                 minLength = length(2);
    %                 maxLength = length(3);
    %                 numFibers = length(roi.coords);
    %                 meanScore = mean(roi.params{2}.stat);
    
    % volume
    t1 = readFileNifti(fullfile(subDir,'t1.nii.gz'));
    volume = dtiGetRoiVolume(roi,t1,dt);
    
    
    % Write out to the the stats file using the tab delimeter.
    %                 fprintf(fid1,'%s\t %s\t %.6f\t %.6f\t %.6f\t %.6f\t %.6f\t %.6f\t %.6f\t %.6f\t %.6f\t \n',...
    %                     subs{ii},roi.name,avgFA,avgMD,avgRD,avgAD,numFibers,avgLength,minLength,maxLength,meanScore);
%     fprintf(fid1,'%s\t %s\t %.6f\t %.6f\t %.6f\t %.6f\t %.6f\t \n',...
    fprintf(fid1,'%s %s %.6f %.6f %.6f %.6f %.6f \n',...
        subs{ii},roi.name,avgFA,avgMD,avgRD,avgAD,numberOfVoxel);
    %             catch ME
    %                 fprintf('Fiber group being skipped: %s',RoiGroup);
    %                 disp(ME);
    %                 clear ME
    %                 %                         fprintf('Can"t load the fiber group - It might be empty. Skipping.\n');
    %             end
    %         else disp(['Fiber group: ' RoiGroup ' not found. Skipping...'])
end

% end

% save the stats file.
fclose(fid1);

disp('DONE!');
return
