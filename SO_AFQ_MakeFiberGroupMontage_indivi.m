function SO_AFQ_MakeFiberGroupMontage_indivi(afq, fgNames, tube , fgColors, subNums, numfibers)
% Make a montage of fiber group renderings across subjects
%
%
% example:
%
% fgNames = AFQ_get(afq,'fgnames');
% SO_AFQ_MakeFiberGroupMontage(afq,fgNames([3 5 9 10 11 13 15 17 19]))

%% Argument checking
% By default render for all subjects
if ~exist('subNums','var') || isempty(subNums)
    subNums = 1:AFQ_get(afq,'num subs');
end
% By default render for all subjects
if ~exist('tube','var') || isempty(tube)
   tube = 0;
end

% By default render the fibers using hsv colors
if ~exist('fgColors','var') || isempty(fgColors)
    fgColors = hsv(length(fgNames)).*.8;
end
% % By default render fibers in a 3x3 subplot window
% if ~exist('plotDims','var') || isempty(plotDims)
%     plotDims = [3 3];
% end
% By default render 200 fibers
if ~exist('numfibers','var') || isempty(numfibers)
    numfibers = 200;
end

% % Calculate the number of plots in a window
% numplots = prod(plotDims);


%% Load fibers and render

% Loop over subjects
for ii = subNums
%     mrvNewGraphWin; hold on; 

    % Initialize a variable to store fiber colors
    colors = [];
    % Initialize a variable for the combined fiber group
    fgCombined = [];
%     % Count plots in this window
%     c = c+1;
%     % Open a new figure window if the plotting window is full
%     if c == numplots+1
%         c = 1;
%         figure;
%     end
    
    % Load fiber groups
    for jj = 1:length(fgNames)
        % Load fibers
        fg = AFQ_get(afq,[prefix(fgNames{jj}) 'fg'],ii);
        % Designate the color of these fibers
        colors = vertcat(colors,repmat(fgColors(jj,:),length(fg.fibers),1));
        % Concatenate fibers
        fgCombined = vertcat(fgCombined,fg.fibers(:));
    end
    % Put concatenated fibers into a fiber group
    fg = dtiNewFiberGroup('all',[],[],[],fgCombined);
    % Render the fibers
%     SO_AFQ_RenderFibers(fg, 'color', colors, 'numfibers',numfibers,'tubes',tube,'subplot',[plotDims(1) plotDims(2) c]);
        SO_AFQ_RenderFibers(fg, 'color', colors, 'numfibers',numfibers,'tubes',tube);

    % add b=0 image
    dt6 = dtiLoadDt6(AFQ_get(afq,'dt6path',ii));
    b0 = niftiRead( dt6.files.b0);
    AFQ_AddImageTo3dPlot(b0,[1 0 0 ])
    
    
    axis off    
    title(sprintf('Subject #%d',ii));
    hold off
end