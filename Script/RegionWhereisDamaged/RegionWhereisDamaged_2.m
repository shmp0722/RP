function RegionWhereisDamaged_2(subject,diffusivity,pathway,test)
% To make pictures of the region where we find diffusivities (AD,RD) difference
% diffusivity = 'fa', 'md', 'ad', 'rd'
% test = 'minus', 'effect size'
% radius = radius of tube
% pathway = 'OT', 'OR' or 'OCF'



%% Set the path to data directory
[homeDir,subDir,JMD,CRD,Ctl,RP] = Tama_subj2;

%% Load afq structure
cd /biac4/wandell/biac2/wandell/data/DWI-Tamagawa-Japan2/results

load Tama2_TP_SD.mat

%%
for ii = subject;  %1: size(afq.sub_dirs,2) % Subjects loop
    
     SubDir = fullfile(homeDir,subDir{ii});
            fgDir  = fullfile(SubDir,'/dwi_2nd/fibers');
            dt6  = fullfile(homeDir,subDir{ii},'dwi_2nd/dt6.mat');
            dt = dtiLoadDt6(dt6);
            cd(fgDir) 
            
       % 'OR'        
            fgR_OR = fgRead([TractProfile{ii,1}{1}.name, '.pdb']);
            fgL_OR = fgRead([TractProfile{ii,2}{1}.name, '.pdb']);
            
       % 'OT'            
            fgR_OT = fgRead([TractProfile{ii,3}{1}.name, '.pdb']);
            fgR_OT = fgRead([TractProfile{ii,4}{1}.name, '.pdb']);    
    
            FG = {fgR_OR,fgL_OR,fgR_OT,fgR_OT};
       %
       figure;hold on;
       for kk = 1:length(FG)
           vals = dtiGetValFromFibers(dt.dt6,FG{kk},inv(dt.xformToAcpc),'fa');
           rgb = vals2colormap(vals);
           switch kk
               case {1,2}
                   
                   AFQ_RenderFibers(FG{kk},'color',rgb,'crange',[0.3 0.7],'newfig',0,'numfibers',100);
               case {3,4}
                   AFQ_RenderFibers(FG{kk},'color',rgb,'crange',[0.3 0.7],'newfig',0);
           end
       end
            
   
                        
            AFQ_AddImageTo3dPlot(t1, [0, 0, -30]);
          
            axis image
            axis off
           % adjust view and give title
            view(0,89)
          
camlight('headlight');

       %% save the figure in 
       
       cd /biac4/wandell/biac3/wandell7/shumpei/matlab/git/LHON/RegionWhereisDamaged(.eps)
       print(gcf, '-depsc',sprintf('%s_%s_%s_%s_E_C.eps',subDir{ii},pathway,test,diffusivity))
        
%        cd /biac4/wandell/biac3/wandell7/shumpei/matlab/git/LHON/RegionWhereisDamaged(.png)
%        print(gcf, '-dpng',sprintf('%s_%s_%s_%s_E_C.png',subDir{ii},pathway,test,diffusivity))
        
       close all;
       
    
end
return
