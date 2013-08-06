function viewnetinfo(sbeG,sbeNode)
%
% Systems Biology and Evolution Toolbox (SBEToolbox).
% Authors: James Cai, Kranti Konganti.
% (C) Texas A&M University.
%
% $LastChangedDate: 2012-12-28 19:01:43 -0600 (Fri, 28 Dec 2012) $
% $LastChangedRevision: 278 $
% $LastChangedBy: konganti $
%

%fprintf('Number of nodes: %d\n',num_vertices(sbeG));
%fprintf('Number of edges: %d\n',num_edges(sbeG)/2);
fprintf('Number of nodes: %d\n',size(sbeG,1));
fprintf('Number of edges: %d\n',int32(nnz(sbeG)/2));

%fprintf('Is symmetric: %d\n',issymmetric(sbeG));
%fprintf('Is simple: %d\n',issimple(sbeG));
