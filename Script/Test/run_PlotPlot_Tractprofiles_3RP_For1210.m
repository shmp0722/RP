function run_PlotPlot_Tractprofiles_3RP_For1210
% Run Plot_Tractprofiles_3RP_For1201 
% 
%
% SO


diffusivity = {'fa','md','ad','rd'};
Type = 'png';
for i = 1: length(diffusivity)
    Plot_Tractprofiles_3RP_For1210(diffusivity{i},Type);
end
