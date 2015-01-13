function Path = TamagawaPath(option)
%
% Change directory to '/DWI-Tamagawa-Japan';
%
%
%
% SO Vista lab 2014


%% argument check
if notDefined('option') || isempty(option); option =1;
end
if ischar(option)
    option = lower(strrep(option,' ',''));
end
%% Where is your destination?
switch option
    case {1}
        Path = '/biac4/wandell/biac2/wandell/data/DWI-Tamagawa-Japan';
    case {2}
        Path = '/biac4/wandell/biac2/wandell/data/DWI-Tamagawa-Japan2';
    case {3}
        Path = '/biac4/wandell/biac2/wandell/data/DWI-Tamagawa-Japan3';
    case {'subj','subject','subjectname'}
        Path = '/biac4/wandell/biac2/wandell/data/DWI-Tama-subjects';
    case {'git'}
        Path = '/home/shumpei/matlab/git';
    case {'freesurfer','fs'}
        Path = '/biac4/wandell/biac2/wandell/data/DWI-Tamagawa-Japan/freesurfer';
    case {'qmr','qmri','quantitative'}
        Path = '/peach/shumpei/qMRI';
    case {'mouse'}
        Path = '/biac4/wandell/biac2/wandell/data/Ogawa_Mouse_DWI';
    case {'life_demo'}
        Path = '/home/shumpei/Downloads/data';
    case {'netta'}
        Path ='/biac4/wandell/biac3/wandell4/data/reading_longitude/dti_adults';
end
cd(Path)
sprintf('You are here. "%s"',Path)
end

