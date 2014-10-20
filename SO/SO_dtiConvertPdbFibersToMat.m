% dtiConvertFibersToMat.m
% 
% This script takes n .pdb or .Bfloat fiber groups for a group of subjects
% and saves them as .mat files so they can be easily loaded in dtiFiberUI.
%
% HISTORY:
% 07/27/2009 LMP wrote the thing.
%


%%
baseDir = '/biac4/wandell/biac2/wandell/data/DWI-Tamagawa-Japan';
cd(baseDir)

subs = {...
         'JMD1-MM-20121025-DWI'
         'JMD2-KK-20121025-DWI'
         'JMD3-AK-20121026-DWI'
         'JMD4-AM-20121026-DWI'
         'JMD5-KK-20121220-DWI'
         'JMD6-NO-20121220-DWI'
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
        };

 yr = 'dwi_2nd/fibers';
     
fibers = {...
%             'LOR_MD2.pdb'
            'LOR_MD3.pdb'
            'LOR_MD4.pdb'
%             'ROR_MD2.pdb'
            'ROR_MD3.pdb'
            'ROR_MD4.pdb'};
            



 
%%  Loops through subs

for ii=11:length(subs)

    subDir = fullfile(baseDir, subs{ii},'dwi_2nd'); %,'fibers');
    fiberDir = fullfile(baseDir, subs{ii},'dwi_2nd','fibers');
            dt = dtiLoadDt6(fullfile(subDir,'dt6.mat'));
            xform = dt.xformToAcpc;
                       
            for kk=1:length(fibers)
          
                filename = fullfile(fiberDir,fibers{kk});
                
                [fg,filename] = mtrImportFibers(filename,xform);
               
                fg.name = fibers{kk};
                savefile = fullfile(fiberDir,fg.name);
              
               dtiWriteFiberGroup(fg,savefile);
            end

       
end


disp('Done!');

