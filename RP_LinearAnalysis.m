function RP_LinearAnalysis

%% RP subjects RNFL thickness

load /biac4/wandell/biac2/wandell/data/DWI-Tamagawa-Japan2/RP/RP_DiscOCT.mat

%% Diffusion measures

load /biac4/wandell/biac2/wandell/data/DWI-Tamagawa-Japan2/RP/RP_OTOR_PrCentile.mat

% define subject num
RP  = [1:8];
Ctl = [9:33];

%% Render plot
% X = 1:100; %$ number of  nodes
c = lines(100); % line colors

%%
fibID = [1]; % OR
for ii = 1: length(fibID)
    pctl = 1;
    % take diffusion values
    for subID = 1:length(TractProfile);
        if isempty(TractProfile{subID,fibID(ii)}{pctl}.nfibers);
            fa(subID,:) =nan(1,100);
        else
            fa(subID,:) =  mean([TractProfile{subID,fibID(ii)}{pctl}.vals.fa;...
                TractProfile{subID,fibID(ii)+1}{pctl}.vals.fa]);
        end;
        
        if isempty(TractProfile{subID,fibID(ii)}{pctl}.nfibers);
            md(subID,:) =nan(1,100);
        else
            md(subID,:) = mean([ TractProfile{subID,fibID(ii)}{pctl}.vals.md;...
                TractProfile{subID,fibID(ii)+1}{pctl}.vals.md]);
        end;
        
        if isempty(TractProfile{subID,fibID(ii)}{pctl}.nfibers);
            rd(subID,:) =nan(1,100);
        else
            rd(subID,:) = mean([ TractProfile{subID,fibID(ii)}{pctl}.vals.rd;...
                TractProfile{subID,fibID(ii)+1}{pctl}.vals.rd]);
        end;
        
        if isempty(TractProfile{subID,fibID(ii)}{pctl}.nfibers);
            ad(subID,:) =nan(1,100);
        else
            ad(subID,:) = mean([ TractProfile{subID,fibID(ii)}{pctl}.vals.ad;...
                TractProfile{subID,fibID(ii)+1}{pctl}.vals.ad]);
        end;
    end
    
    %%
    pVal = struct;
    cVal = struct;
    
    % retrieve patient data
    pVal.fa = fa(RP,:);
    pVal.md = md(RP,:);
    pVal.ad = ad(RP,:);
    pVal.rd = rd(RP,:);
    
    % mean
    pVal.Mfa = nanmean(fa(RP,:),2);
    pVal.Mmd = nanmean(md(RP,:),2);
    pVal.Mad = nanmean(ad(RP,:),2);
    pVal.Mrd = nanmean(rd(RP,:),2);
    
    % control data
    cVal.fa = fa(Ctl,:);
    cVal.md = md(Ctl,:);
    cVal.ad = ad(Ctl,:);
    cVal.rd = rd(Ctl,:);
    
    % mean
    cVal.Mfa = nanmean(fa(Ctl,:),2);
    cVal.Mmd = nanmean(md(Ctl,:),2);
    cVal.Mad = nanmean(ad(Ctl,:),2);
    cVal.Mrd = nanmean(rd(Ctl,:),2);
    
    %% subjects data
    pAge = [35 43 36 71 38 59 57 36];
    cAge = [27 34 40 32 31 33 38 36 24 35 40 25 26 28 74 68 63 61 71 66 61 62 70 65 64];
    rVA = [0.1000    1.1000   -0.1760    0.4000   -0.1000    0.1000    2.8000    0.0500];
    lVA = [0.1000    0.8000   -0.1760    0.1600    0.2200    0.1600    2.3000    0.1000];
    
%     %% FA
%     figure;
%     subplot(3,1,1); hold on;
%     plot(pAge, pVal.Mfa,'ro')
%     plot(cAge, cVal.Mfa,'bo')
% %     ylim([0.35 0.7])
%     ylabel('FA')
%     % xlabel('Age')
%     
%     
%     % fit model
%     p = polyfit(pAge', pVal.Mfa,1);
%     yfit = polyval(p,pAge');
%     
%     xlabel('Age')
%     ylabel('FA')
%     % xlabel('Age')
%     
%     subplot(3,1,2); hold on;
%     plot(rVA, pVal.Mfa,'ro')
%     
%     xlabel('r-VA')
%     ylabel('FA')
%     % xlabel('Age')
%     
%     
%     subplot(3,1,3)
%     plot(lVA, pVal.Mfa,'ro')
%     xlabel('l-VA')
%     ylabel('FA')
%     % xlabel('Age')
%     
%     %% MD
%     figure;
%     subplot(3,1,1);hold on;
%     plot(pAge, pVal.Mmd,'ro')
%     plot(cAge, cVal.Mmd,'bo')
% 
%     ylabel('MD')
%     % xlabel('Age')
%     
%     % fit model
%     p = polyfit(pAge', pVal.Mmd,1);
%     yfit = polyval(p,pAge');
%     
%     R = corrcoef(pAge, pVal.Mmd);
%     
%     xlabel('Age')
%     ylabel('MD')
%     % xlabel('Age')
%     
%     subplot(3,1,2)
%     plot(rVA, pVal.Mmd,'ro')
%     xlabel('r-VA')
%     ylabel('MD')
%     % xlabel('Age')
%     
%     
%     subplot(3,1,3)
%     plot(lVA, pVal.Mmd,'ro')
%     xlabel('l-VA')
%     ylabel('MD')
%     % xlabel('Age')
%     %% AD
%     figure;
%     subplot(3,1,1); hold on;
%     plot(pAge, pVal.Mad,'ro')
%     plot(cAge, cVal.Mad,'bo')
%     
%     ylabel('AD')
%     % xlabel('Age')
%     
%     % fit model
%     p = polyfit(pAge', pVal.Mad,1);
%     yfit = polyval(p,pAge');
%     
%     R = corrcoef(pAge, pVal.Mad);
%     
%     xlabel('Age')
%     ylabel('AD')
%     % xlabel('Age')
%     
%     subplot(3,1,2)
%     plot(rVA, pVal.Mad,'ro')
%     xlabel('r-VA')
%     ylabel('AD')
%     % xlabel('Age')
%     
%     
%     subplot(3,1,3)
%     plot(lVA, pVal.Mad,'ro')
%     xlabel('l-VA')
%     ylabel('AD')
%     % xlabel('Age')
%     
%     %% RD
%     figure;
%     subplot(3,1,1); hold on;
%     plot(pAge, pVal.Mrd,'ro')
%     plot(cAge, cVal.Mrd,'bo')
%     
%     ylabel('RD')
%     % xlabel('Age')
%     
%     % fit model
%     p = polyfit(pAge', pVal.Mrd,1);
%     yfit = polyval(p,pAge');
%     
%     R = corrcoef(pAge, pVal.Mrd);
%     
%     xlabel('Age')
%     ylabel('RD')
%     % xlabel('Age')
%     
%     subplot(3,1,2)
%     plot(rVA, pVal.Mrd,'ro')
%     xlabel('r-VA')
%     ylabel('RD')
%     % xlabel('Age')
%     
%     
%     subplot(3,1,3)
%     plot(lVA, pVal.Mrd,'ro')
%     xlabel('l-VA')
%     ylabel('RD')
%     % xlabel('Age')
%     

%%
pR = struct;
pP = struct;
cR = struct;
cP = struct;
    %%
    mrvNewGraphWin;
    % FA
    subplot(2,2,1); hold on;
    
    plot(pAge, pVal.Mfa,'ro')
    plot(cAge, cVal.Mfa,'bo')
    ylabel('FA')     
    xlabel('Age')
    
    [pR.fa, pP.fa] = corrcoef(pAge, pVal.Mfa);
    [cR.fa, cP.fa] = corrcoef(cAge, cVal.Mfa);
    
    % MD
    subplot(2,2,2);hold on;
    plot(pAge, pVal.Mmd,'ro')
    plot(cAge, cVal.Mmd,'bo')
    xlabel('Age')
    ylabel('MD')
    
    [pR.md, pP.md] = corrcoef(pAge, pVal.Mmd);
    [cR.md, cP.md] = corrcoef(cAge, cVal.Mmd);
    
    % AD
    subplot(2,2,3);hold on;
    plot(pAge, pVal.Mad,'ro')
    plot(cAge, cVal.Mad,'bo')
    xlabel('Age')
    ylabel('AD')
    
    [pR.ad, pP.ad] = corrcoef(pAge, pVal.Mad);
    [cR.ad, cP.ad] = corrcoef(cAge, cVal.Mad);
    
    % RD
    subplot(2,2,4);hold on;
    plot(pAge, pVal.Mrd,'ro')
    plot(cAge, cVal.Mrd,'bo')
    xlabel('Age')
    ylabel('RD')
    
    [pR.rd, pP.rd] = corrcoef(pAge, pVal.Mrd);
    [cR.rd, cP.rd] = corrcoef(cAge, cVal.Mrd);
    
end
