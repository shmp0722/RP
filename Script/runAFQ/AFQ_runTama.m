
% Run AFQ analysis on a set of subjects to generate Tract Profiles of white
% matter properties.
%
% [afq patient_data control_data norms abn abnTracts] = AFQ_run(sub_dirs,
% sub_group, [afq])
%
% AFQ_run is the main function to run the AFQ analysis pipeline.  Each AFQ
% function is an independent module that can be run on its own.  However
% when AFQ_run is used to analyze data all the proceeding analyses are
% organized into the afq data structure. The AFQ analysis pipeline is
% described in Yeatman J.D., Dougherty R.F., Myall N.J., Wandell B.A.,
% Feldman H.M. (2012). Tract Profiles of White Matter Properties:
% Automating Fiber-Tract Quantification. PLoS One.
%
% Input arguments:
%  sub_dirs  = 1 x N cell array where N is the number of subjects in the
%              study. Each cell should contain the full path to a subjects
%              data directory where there dt6.mat file is.
%
%  sub_group = Binary vector defining each subject's group. 0 for control
%              and 1 for patient.
%
%  afq       = This is a structure that sets up all the parameters for the
%              analysis.  If it is blank AFQ_run will use the default
%              parameters.  See AFQ_Create.
%
% Outputs: 
% afq          = afq structure containing all the results
%
% patient_data = A 1X20 structured array of tract diffusion profiles where
%                data for each tract is in a cell of the structure (eg.
%                patient_data(1) is data for the left thalamic radiation).
%                Each diffusion properties is stored as a different field
%                (eg. patient_data(1).FA is a matrix of FA profiles for the
%                left thalamic radiation). Within the data matrix each
%                subject is a row and each location is a column.  This
%                output variable contains all the data for the patients
%                defined by sub_group ==1.
%
% control_data = The same structure as for patient_data but this contains
%                data for the control subjects defined by sub_group==0.
%
% norms        = Means and standard deviations for each tract diffusion
%                profile calculated based on the control_data.
%
% abn          = A 1 x N vector where N is the number of patients.
%                Each patient that is abnormal on at least one tract is
%                marked with a 1 and each subject that is normal on every
%                tract is marked with a 0. The criteria for abnormal is
%                defined in afq.params.cutoff.  See AFQ create
%
% abnTracts    = An M by N matrix where M is the number of subjects and N
%                is the number of tracts. Each row is a subject and each 
%                column is a tract.  1 means that tract was abnormal for
%                that subject and 0 means it was normal.
%
%  Web resources
%    http://white.stanford.edu/newlm/index.php/AFQ
%
%  Example:
%   
%   % Get the path to the AFQ directories
%   [AFQbase AFQdata] = AFQ_directories;
%   % Create a cell array where each cell is the path to a data directory
%   sub_dirs = {[AFQdata '/patient_01/dti30'], [AFQdata '/patient_02/dti30']...
%   [AFQdata '/patient_03/dti30'], [AFQdata '/control_01/dti30']...
%   [AFQdata '/control_02/dti30'], [AFQdata '/control_03/dti30']};
%   % Create a vector of 0s and 1s defining who is a patient and a control
%   sub_group = [1, 1, 1, 0, 0, 0]; 
%   % Run AFQ in test mode to save time. No inputs are needed to run AFQ 
%   % with the default settings. AFQ_Create builds the afq structure. This
%   % will also be done automatically by AFQ_run if the user does not wish 
%   % to modify any parameters
%   afq = AFQ_Create('run_mode','test', 'sub_dirs', sub_dirs, 'sub_group', sub_group); 
%   [afq patient_data control_data norms abn abnTracts] = AFQ_run(sub_dirs, sub_group, afq)
%
% Copyright Stanford Vista Team, 2011. Written by Jason D. Yeatman,
% Brian A. Wandell and Robert F. Dougherty

%% set parameters
% [afq patient_data control_data norms abn abnTracts] = AFQ_run(sub_dirs, sub_group, afq)

homedir = '/biac4/wandell/biac2/wandell/data/DWI-Tamagawa-Japan';

sub_dirs = {...
%     [homedir,'/JMD1-MM-20121025-DWI/dwi_2nd']
     [homedir,'/JMD2-KK-20121025-DWI/dwi_2nd']
%     [homedir,'/JMD3-AK-20121026-DWI/dwi_2nd']
%     [homedir,'/JMD4-AM-20121026-DWI/dwi_2nd']
%     [homedir,'/JMD5-KK-20121220-DWI/dwi_2nd']
%     [homedir,'/JMD6-NO-20121220-DWI/dwi_2nd']
%     [homedir,'/LHON1-TK-20121130-DWI/dwi_2nd']
%     [homedir,'/LHON2-SO-20121130-DWI/dwi_2nd']
%     [homedir,'/LHON3-TO-20121130-DWI/dwi_2nd']
%     [homedir,'/LHON4-GK-20121130-DWI/dwi_2nd']
%     [homedir,'/LHON5-HS-20121220-DWI/dwi_2nd']
%     [homedir,'/LHON6-SS-20121221-DWI/dwi_2nd']
      [homedir,'/JMD-Ctl-MT-20121025-DWI/dwi_2nd']
%     [homedir,'/JMD-Ctl-YM-20121025-DWI/dwi_2nd']
%     [homedir,'/JMD-Ctl-SY-20130222DWI/dwi_2nd']
%     [homedir,'/JMD-Ctl-HH-20120907DWI/dwi_1st']
     };

sub_group = [1,0];
afq = AFQ_Create('run_mode','test', 'sub_dirs', sub_dirs, 'sub_group', sub_group); 

%%
[afq patient_data control_data norms abn abnTracts] = AFQ_run(sub_dirs, sub_group, afq)


