function [kden]=graph_density(sbeG)
%GRAPH_DENSITY Gets the density of the current graph
%
% [kden] = graph_density(sbeG) will tell how densly the nodes are
%    connected.
%
%  sbeG: a sparse adjacency matrix that holds the network information
%  kden: density of nodes connections
%
% See also: graph_meandist, graph_clustercoeff
%
% Systems Biology and Evolution Toolbox (SBEToolbox).
% Authors: Kranti Konganti, James Cai.
% (C) Texas A&M University.
%
% $LastChangedDate: 2013-06-23 10:35:39 -0500 (Sun, 23 Jun 2013) $
% $LastChangedRevision: 717 $
% $LastChangedBy: yangence $ 
%

K=num_edges(sbeG);
N=num_vertices(sbeG);

kden = K/((N^2-N)/2);