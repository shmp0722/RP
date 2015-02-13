function RP_AFQ_PlotPatientMeans
% Plot patient data against controls
%
%
% Example:
%
% load /biac4/wandell/data/WH/analysis/AFQ_WestonHavens_Full.mat
% afq_controls = afq;
% load /biac4/wandell/data/WH/kalanit/PS/AFQ_PS.mat
% afq_patient = afq;
% AFQ_PlotPatientMeans(afq_patient,afq_controls,'T1_map_lsq_2DTI',[],'age', [53 73])
% AFQ_PlotPatientMeans(afq_patient,afq_controls,'fa',[],'age', [53 73])
% AFQ_PlotPatientMeans(afq_patient,afq_controls,'md',[],'age', [53 73])


%% load afq

load /sni-storage/wandell/biac2/wandell/data/DWI-Tamagawa-Japan2/RP/afq_8RP_25Normal_02132015_3.mat


% Which nodes to analyze
if notDefined('nodes')
    nodes = 20:80;
end

% % Define output directory
% if notDefined('outdir')
    outdir = '/sni-storage/wandell/biac2/wandell/data/DWI-Tamagawa-Japan2/RP';
% end
% if ~iscell(outdir)
%     out_dir{1} = outdir; outdir = out_dir;
% end

% If no value was defined than find all the values that match for controls
% and the patient
if notDefined('valname')
    valname = {'fa' 'md' 'rd' 'ad'};
elseif ischar(valname)
    tmp = valname;clear valname
    valname{1} = tmp;
end
% Get rid of underscores in the valname for the sake of axis labels
for v = 1:length(valname)
    valtitle{v} = valname{v};
    sp = strfind(valname{v},'_');
    if ~isempty(sp)
        valtitle{v}(sp) = ' ';
    end
end
% Get number of fiber groups and their names
% nfg = AFQ_get(afq,'nfg');
nfg = 20;

fgNames = AFQ_get(afq,'fgnames');

% Set the views for each fiber group
fgviews = {'leftsag', 'rightsag', 'leftsag', 'rightsag', ...
    'leftsag', 'rightsag', 'leftsag', 'rightsag', 'axial', 'axial',...
    'leftsag', 'rightsag', 'leftsag', 'rightsag',  'leftsag', 'rightsag'...
    'leftsag', 'rightsag', 'leftsag', 'rightsag'};
% Slices to add to the rendering
slices = [-5 0 0; 5 0 0; -5 0 0; 5 0 0; -5 0 0; 5 0 0; -5 0 0; 5 0 0;...
    0 0 -5; 0 0 -5; -5 0 0; 5 0 0; -5 0 0; 5 0 0; -5 0 0; 5 0 0; -5 0 0; 5 0 0; -5 0 0; 5 0 0];
% Set the colormap and color range for the renderings
cmap = AFQ_colormap('bgr'); crange = [-4 4];

% Make an output directory for this subject if there isn't one
% if ~exist(outdir,'dir')
%     mkdir(outdir);
% end
% fprintf('\nImages will be saved to %s\n',outdir{s});

%% Loop over the different values
mrvNewGraphWin; 

for v = 1:length(valname)
    % Open a new figure window for the mean plot
    subplot(2,2,v); hold('on');
    % Make an output directory if it does not exist
    vout = fullfile(outdir,valname{v});
    if ~exist(vout,'dir')
        mkdir(vout);
    end
    
    pVals = AFQ_get(afq,'patient data');
    cVals = AFQ_get(afq,'control data');
    
    % Loop over each fiber group
    for ii = 1:20 %nfg
        % Get the values for the patient and compute the mean
        vals_p = pVals(ii).(upper(valname{v}));
        
        % Remove nodes that are not going to be analyzed and only
        % compute for subject #s
        vals_p = vals_p(:,nodes);
        vals_pm = nanmean(vals_p(:));
        
        % Get the value for each control and compute the mean
        vals_c = cVals(ii).(upper(valname{v}));
        vals_c = vals_c(:,nodes);
        vals_cm = nanmean(vals_c,2);
             
        % Compute control group mean and sd
        m = nanmean(vals_cm);
        sd = nanstd(vals_cm);
               
        % Plot control group means and sd
        x = [ii-.2 ii+.2 ii+.2 ii-.2 ii-.2];
        y1 = [m-sd m-sd m+sd m+sd m-sd];
        y2 = [m-2*sd m-2*sd m+2*sd m+2*sd m-2*sd];
        fill(x,y2, [.6 .6 .6],'edgecolor',[0 0 0]);
        fill(x,y1,[.4 .4 .4] ,'edgecolor',[0 0 0]);
        
        % Define the color of the point for the fiber group based on its zscore
        tractcol = vals2colormap((vals_pm - m)./sd,cmap,crange);
        % Plot patient
        plot(ii, vals_pm,'ko', 'markerfacecolor',tractcol);
        
    end
    
    % make fgnames shorter
    newfgNames = {'l-TR','r-TR','l-C','r-C','l-CC','r-CC','l-CH','r-CH','CFMa',...
        'CFMi','l-IFOF','r-IFOF','l-ILF','r-ILF','l-SLF','r-SLF','l-U','r-U',...
        'l-A','r-A'}; 
    
    set(gca,'xtick',1:nfg,'xticklabel',newfgNames,'xlim',[0 nfg+1],'fontname','times','fontsize',11);
    rotateXLabels(gca,90);
    ylabel(upper(valtitle{v}));
   
end

return
% Load the fiber group for the patient
fg_p = AFQ_get(afq,'clean fg',1);

% Load up the b0 image for the patient
dt_p = dtiLoadDt6(AFQ_get(afq,'dt6path',1));
b0_p = readFileNifti(dt_p.files.b0);

%% Save an animated gif of the rotating fiber group
AFQ_RotatingFgGif(fg_p,[],fullfile(outdir{s},'000_RotatingFibers.gif'),b0_p,[1 0 0]);
    