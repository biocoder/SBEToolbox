function outputCell = Knotty_Centrality
% - Knotty_Centrality 
% Plugin call to knottycentrality function
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


%% Test and load either largest extracted network or original network
[g, e] = getcurrentnetsession;


%% If network is not yet loaded, return
if isempty(g)
    outputCell{1} = sprintf('\n%s\n%s\n%s\n\n%s', 'Knotty Centrality', ...
        '=======================================', ...
        'Network not yet loaded !', ...
        'Aborting plugin execution ...');
    return;
end


%% Get Knotty Centrality
if ~issparse(g)
    g = sparse(g);
end
if isGbig(g), h=waitbar(0.5, 'Please wait...'); end
[nodes, kc] = knottycentrality(g, 1);
if isGbig(g), waitbar(1, h); end
if exist('h','var'), close(h); end

%% Define size of output
outputCell = cell(size(nodes, 1) + 2, 1);

% Output header
outputHeaderTitle = 'Knotty Centrality';
outputCell{1} = sprintf('\n%s\n%s', outputHeaderTitle, ...
    '================================================');
outputCell{2} = sprintf('%s\n%s', 'Nodes within found sub-graph: ', ...
    '================================================');

% Rest of the function output
for i = 1:length(nodes);
    nodeIndOffset = i + 2;
    outputCell{nodeIndOffset} = sprintf('%s', char(e{nodes(i)}));
end

outputCell{end + 1} = sprintf('%s\n%s\t%s\n%s', ... 
    '================================================', ...
    'It''s Knotty Centeredness: ', ...
    full(kc),...
    '================================================');
end