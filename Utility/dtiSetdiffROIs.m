function newROI = dtiSetdiffROIs(roi1,roi2)
% This function set coords difference between roi1 and roi2. Returns the values in roi1.coords that are not in roi2.coords with no repetitions.
% 
% Example:
% roi1 = dtiRead(roi1); roi2 = dtiRead(rois20;
% ROI = dtiSetdiffROIs(roi1,roi2);
% 
% Shumpei Ogawa Vista lab 2014 

%
newROI = roi1;
newROI.name = sprintf('%s_%s',roi1.name,roi2.name);

newROI.coords = setdiff(roi1.coords,roi2.coords,'rows');

% % save newROI
% dtiWriteRoi(newROI, newROI.name)
return;