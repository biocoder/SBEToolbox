function [out]=closeness_centrality(G)
%CLOSENESS_CENTRALITY Calculate closeness centrality
%
% [out]=closeness_centrality(sbeG) stores closeness centrality statistic of
% each node within graph sbeG.
% 
% See also: bridging_centrality, eccentricity_centrality
%
% Ref: Freeman, L.C., 1979. Centrality in networks: I. Conceptual clarification.
% Social Networks 1, 215–239.
% http://www.biomedcentral.com/1471-2105/8/153
% http://dx.doi.org/10.1016/j.socnet.2004.02.001
% http://www.plosone.org/article/info:doi/10.1371/journal.pone.0001049
%
% Systems Biology and Evolution Toolbox (SBEToolbox).
% Authors: James Cai, Kranti Konganti.
% (C) Texas A&M University.
%
% $LastChangedDate: 2013-06-14 10:36:48 -0500 (Fri, 14 Jun 2013) $
% $LastChangedRevision: 654 $
% $LastChangedBy: konganti $
%

n=num_vertices(G);
if issparse(G)
    G=double(sparse(G));
end
[D]=all_shortest_paths(G);
out=(n-1)./sum(D,2);


