function Path = TamagawaPath(option)
%
% Change directory to '/DWI-Tamagawa-Japan';
% 
%
%
% SO Vista lab 2014


%%
if isempty(option); option =1;
end

switch option
    case {1}
        Path = '/biac4/wandell/biac2/wandell/data/DWI-Tamagawa-Japan';
        cd(Path)         
    case {2}
        Path = '/biac4/wandell/biac2/wandell/data/DWI-Tamagawa-Japan2';
        cd(Path)
    case {3}
        Path = '/biac4/wandell/biac2/wandell/data/DWI-Tamagawa-Japan3';
        cd(Path)
    case {'git'}
        Path = '/home/shumpei/matlab/git';
        cd(Path)
    case {'freesurfer'}
        Path = '/biac4/wandell/biac2/wandell/data/DWI-Tamagawa-Japan/freesurfer';
        cd(Path)
end


