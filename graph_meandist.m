function [res]=graph_meandist(G)
%GRAPH_MEANDIST Get mean distance of the current graph sbeG.
%
% [res]=graph_meandist(G) get the average distance for the graph sbeG.
%
%  G: a sparse adjacency matrix that holds the network information, as same
%     as sbeG
%  res: average distance
%
% See also: graph_density, graph_clustercoeff
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
[D]=all_shortest_paths(double(sparse(G)));
idx=[];
for k=1:n
    if sum(D(k,:)==inf)==n-1
        idx=[idx,k];
    end
end
D(idx,:)=[];
D(:,idx)=[];
m=n-numel(idx);
res=nansum(D(:));
if res~=0
    res=res/(m*(m-1));
end

