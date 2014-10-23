function [fa,md,rd,ad] = ParticularPlaneX_Diffusivity(val,fig)
% [fa,md,rd,ad] = ParticularPlaneX_Diffusivity(fg,val,X,Y,Z)
% This script is for checking diffusivities in OR according to
% eccentoricity.
% val = 'fa','md','ad','rd'
%
%% Identify directory
[homeDir,subDir,JMD,CRD,LHON,Ctl,RP] = Tama_subj2;
X = [20 25];
%% Calculate vals along the fibers and return TP structure
for i =RP%:length(subDir)
    
    % define directory
    fgDir  = fullfile(homeDir,subDir{i},'/dwi_2nd/fibers/conTrack/OR_Top100K_V1_3mm_clipped_LGN4mm');
    dt  = fullfile(homeDir,subDir{i},'dwi_2nd','dt6.mat');
    dt  = dtiLoadDt6(dt);
    t1w = niftiRead(dt.files.t1);
    
    % load Right Optic radiation
    fgN = dir(fullfile(fgDir,'*Lh_NOT1201_MD4.pdb'));
    fg = fgRead(fullfile(fgDir,fgN.name));
    
    for jj= 1 : length(X)
        % Take the voxels on X
        fgOut = dtiClipFiberGroup(fg, [X(jj)+1, 80], [-60, 80], [],0);
        fgOut1 = dtiClipFiberGroup(fgOut, [-80, X(jj)-1], [], [],0);
        
%         % easier way?
%         roi = dtiCreateRoiFromFibers(fgOut1);
%         roi.coords =  unique(roi.coords,'rows');
%         AFQ_RenderRoi(roi)           
%         
% %         % check
% %         AFQ_RenderFibers(fgOut1,'numfibers',50,'color', [0.2 0.3 0.6])
%         AFQ_AddImageTo3dPlot(t1w, [0, 0, -30]);
%         view(0 ,89);
%         axis image
        
        
        % Now let's get all of the coordinates that the fibers go through
        % and the unique coordinates
        coords = horzcat(fgOut1.fibers{:});
        coords_unique = unique(round(coords'),'rows');
        
        % These coordsinates are in ac-pc (millimeter) space. We want to transform
        % them to image indices.
        img_coords = unique(floor(mrAnatXformCoords(inv(dt.xformToAcpc), coords_unique)), 'rows');
        
        % Now we can calculate diffusivites
        [fa,md,rd,ad] = dtiComputeFA(dt.dt6);
        
        %         % Now lets take these coordinates and turn them into an image. First we
        %         % will create an image of zeros
        %         OR_img = zeros(size(fa));
        %         % Convert these coordinates to image indices
        %         ind = sub2ind(size(fa), img_coords(:,1), img_coords(:,2),img_coords(:,3));
        %         % Now replace every coordinate that has the optic radiations with a 1
        %         OR_img(ind) = 1;
        %
        %         % Now you have an image. Just for your own interest if you want to make a
        %         % 3d rendering
        %         figure;
        %         isosurface(OR_img,.5);
        
        % Convert these coordinates to image indices
        ind = sub2ind(size(fa), img_coords(:,1), img_coords(:,2),img_coords(:,3));
        
        %% scatter plot
        %
        switch val
            case 'fa'
                Val = fa;
            case 'md'
                Val = md;
            case 'ad'
                Val = ad;
            case 'rd'
                Val = rd;
        end
        
        % add mean value
        indY = unique(img_coords(:,2,:));
        for ii =1:length(indY);
            sortedY = img_coords(:,2,:)==indY(ii);
            cur_ind = sub2ind(size(Val), img_coords(sortedY,1), img_coords(sortedY,2),img_coords(sortedY,3));
            %
            m(ii)  = mean_nan(Val(cur_ind));
            st(ii) = nanstd(Val(cur_ind));
            %         scatter(indY(ii),mean_nan(fa(cur_ind)),60,30,'r','fill');
        end
        
        %% render control normal distribution
        % A1 = area(indY,m+st);
        % A2 = area(indY,m-st);
        % A3 = area(indY,m+2*st);
        % A4 = area(indY,m-2*st);
        
        % set color and style
        % set(A1,'FaceColor',[0.6 0.6 0.6],'linestyle','none')
        % set(A2,'FaceColor',[0.8 0.8 0.8],'linestyle','none')
        % set(A3,'FaceColor',[0.8 0.8 0.8],'linestyle','none')
        % set(A4,'FaceColor',[1 1 1],'linestyle','none')
        
        %% make a individual scatter plot
        if fig == true;
        figure;hold on;        
        scatter(img_coords(:,2,:),Val(ind),'b')
        scatter(indY,m,70,'fill','r')
        ylabel(val)
        xlabel('location')
        title(sprintf('%s ROR %d %s',subDir{i},X(jj) , val))
        hold off
        clear m, clear st,
        axis([18 35 0 1])
        end
    end
end
return

%% Keep these ideas

% easier way?
roi = dtiCreateRoiFromFibers(fgOut1);
roi.coords =  unique(roi.coords,'rows');
AFQ_RenderRoi(roi)

[roiKeep, roiNot] = dtiRoiClip(roi, [], [-70 80], [])

% AFQ_RenderRoi(roiKeep)
AFQ_RenderRoi(roiNot)
view(0 ,89)
 % Now let's get all of the coordinates that the fibers go through
        % and the unique coordinates
        coords =roiNot.coords% horzcat(fgOut1.fibers{:});
        coords =roiKeep.coords% horzcat(fgOut1.fibers{:});

        coords_unique = unique(round(coords),'rows');
        
        % These coordsinates are in ac-pc (millimeter) space. We want to transform
        % them to image indices.
        img_coords = unique(floor(mrAnatXformCoords(inv(dt.xformToAcpc), coords_unique)), 'rows');



% Convert the array of coordinates to an image
[roiImg, imgXform] = dtiRoiToImg(roi);
perimRoi = dtiRoiFromImg(roiImg, imgXform)

% check
AFQ_RenderFibers(fgOut1,'numfibers',50,'color', [0.2 0.3 0.6])
AFQ_AddImageTo3dPlot(t1w, [0, 0, -30]);
view(0 ,89);
axis image

%%
 % Convert the array of coordinates to an image
        [roiImg, imgXform] = dtiRoiToImg(roi);

