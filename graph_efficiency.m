function [out]=graph_efficiency(G)
%GRAPH_EFFICIENCY Get efficiency of current graph sbeG.
%
% [out]=graph_efficiency(G)
%
% The efficiency E[G] of a graph G is defined as: and measures the mean
%    flow-rate of information over G
%
%  G   - a sparse adjacency matrix that holds the network information, as
%        same as sbeG
%  out - efficiency of graph
%
% See also: delta_centrality, graph_diameter, graph_clustercoeff,
%           graph_density
%
% Reference: Latora V and Marchiori M 2001 Phys. Rev. Lett. 87 198701
%
% Systems Biology and Evolution Toolbox (SBEToolbox).
% Authors: Kranti Konganti, James Cai.
% (C) Texas A&M University.
%
% $LastChangedDate: 2013-06-23 10:35:39 -0500 (Sun, 23 Jun 2013) $
% $LastChangedRevision: 717 $
% $LastChangedBy: yangence $ 
%

n=num_vertices(G);
if ~issparse(G)
    G=double(sparse(G));
end
[D]=all_shortest_paths(G);
D=triu(D,1);
D=nonzeros(D);
%D=D(:);
%D=D(D>0);
out=2*sum(1./D)/(n*(n-1));

