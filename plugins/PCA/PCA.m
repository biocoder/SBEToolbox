function outputCell = PCA
% - PCA 
% This plugin performs Principal Component Analysis on 5 network properties: 
% Degree Centrality (Deg), Bridging Centrality (Bdg), 
% Betweenness Centrality (Btw), Brokering Coefficient (Bco) and 
% Clustering Coefficient (Clu) and displays the PCA Plot. 
%
% Kranti Konganti ( konganti@tamu.edu )
%
% Systems Biology and Evolution Toolbox (SBEToolbox).
% Authors: Kranti Konganti.
% (C) Texas A&M University.
%
% $LastChangedDate: 2013-06-25 14:19:19 -0500 (Tue, 25 Jun 2013) $
% $LastChangedRevision: 740 $
% $LastChangedBy: konganti $
%



%% Test and load either largest extracted network or original network
[g, ~] = getcurrentnetsession;

%% If network is not yet loaded, return
if isempty(g)
    outputCell{1} = sprintf('\n%s\n%s\n%s\n\n%s', 'Knotty Centrality', ...
        '=======================================', ...
        'Network not yet loaded !', ...
        'Aborting plugin execution ...');
    return;
end


%% No text output is needed since we are just displaying a plot.
outputCell = cell(0, 0);

if isGbig(g), h=waitbar(0.5, 'Please wait...'); end
if ~issparse(g), g = sparse(g); end

%% Get Centralities and Coefficients
btw = betweenness_centrality(double(g));
bdg = bridging_centrality(g);
bco = brokeringcoeff(g);
clu = clustering_coefficients(g);
deg = sum(g, 2);


%% Do PCA and display biplot
data = [full(btw) full(bdg) full(bco) full(clu) full(deg)];
data = data(all(~isnan(data),2),:);
figure('Color', 'w');
[coefs, score] = pca(zscore(data));
biplot(coefs(:,1:3), 'scores', score(:,1:3), 'varlabels', {'Btw', 'Bdg', 'Bco', 'Clu', 'Deg'});
title('PCA Plot of Network Properties');
if isGbig(g), waitbar(1, h); end
if exist('h','var'), close(h); end
end
