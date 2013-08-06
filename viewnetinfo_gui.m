function guiOutput = viewnetinfo_gui(sbeG, guiOutput)
%
% Systems Biology and Evolution Toolbox (SBEToolbox).
% Authors: James Cai, Kranti Konganti.
% (C) Texas A&M University.
%
% $LastChangedDate: 2013-03-13 09:49:28 -0500 (Wed, 13 Mar 2013) $
% $LastChangedRevision: 496 $
% $LastChangedBy: konganti $
%

%fprintf('Number of nodes: %d\n',num_vertices(sbeG));
%fprintf('Number of edges: %d\n',num_edges(sbeG)/2);
guiOutput{2} = sprintf('Number of nodes: %d',size(sbeG,1));
guiOutput{3} = sprintf('Number of edges: %d',int32(nnz(sbeG)/2));
speciesListCell = load('speciesList.mat');
guiOutput{4} = sprintf('%s%s', 'Selected annotation database: ', ...
    speciesListCell.speciesList{getpref('SBEToolbox', 'annotation_db')});

%guiOutput{3} = sprintf('Number of edges ( including self connections ): %d',int32(nnz(sbeG)/2));

%fprintf('Is symmetric: %d\n',issymmetric(sbeG));
%fprintf('Is simple: %d\n',issimple(sbeG));
