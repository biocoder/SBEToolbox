function outputCell = Participation_Coefficient_MCL
% - Participation_Coefficient_MCL 
%
% Displays Participation Coefficient of each node participating in the 
% detected sub clusters by MCL
%
% Ref: http://www.nature.com/nature/journal/v433/n7028/full/nature03288.html
% Guimerà R, Nunes Amaral LA. Functional cartography of complex metabolic
% networks. Nature. 2005 Feb 24;433(7028):895-900. PubMed PMID: 15729348; PubMed
% Central PMCID: PMC2175124.
%
%
% Systems Biology and Evolution Toolbox (SBEToolbox).
% Authors: Kranti Konganti.
% (C) Texas A&M University.
%
% $LastChangedDate: 2013-06-25 11:22:25 -0500 (Tue, 25 Jun 2013) $
% $LastChangedRevision: 725 $
% $LastChangedBy: konganti $
%


%% Test and load either largest extracted network or original network or the edited network
[g, e] = getcurrentnetsession;

%% If network is not yet loaded, return
if isempty(g)
    outputCell{1} = sprintf('\n%s\n%s\n%s\n\n%s', 'Participation Coefficient MCL', ...
        '=======================================', ...
        'Network not yet loaded !', ...
        'Aborting plugin execution ...');
    return;
end

%% Run MCL and get a vector of cluster membership ids.
mcl_deduced_g = mcl(g, 0, 0, 0, 0, 50);
[~, mcl_out] = deduce_mcl_clusters(unique(mcl_deduced_g, 'rows'), e);

clusterMembership = zeros(size(mcl_out, 2), 1);
for i = 1:size(mcl_out, 2);
    mclresstrings = strsplit(char(mcl_out(i)), '\t');
    clusterMembership(strcmpi(mclresstrings(2), e)) = str2double(mclresstrings(3));
end

%% Now, get participation coefficient
p = participationcoeff(g, clusterMembership);

%% Define size of output
outputCell = cell(size(p, 1),1);

if isempty(e)
    outputCell{1} = sprintf('\n%s\n', 'Network not yet loaded !');
end

% Output header
outputHeaderTitle = 'Participation Coefficient MCL';
outputCell{1} = sprintf('\n%s', outputHeaderTitle);
outputCell{2} = sprintf('%s', '========================================');

% Rest of the function output
for n = 3:size(p, 1) + 2
    nodeIndOffset = n - 2;
    outputCell{n} = sprintf('Node%04d\t%s\t%g', nodeIndOffset, ...
        char(e{nodeIndOffset}), p(nodeIndOffset));
end
