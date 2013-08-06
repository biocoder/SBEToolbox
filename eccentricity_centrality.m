function [res]=eccentricity_centrality(G)
%ECCENTRICITY_CENTRALITY Calculate eccentricity centrality
%
% [res] = eccentricity_centrality(G) is a array vector containing the statistic
%    for each node / vertex. 
%  G   - a sparse adjacency matrix that holds the network information, as same
%        as sbeG
%  res - the eccentricity centrality
%
% The eccentricity of a vertex j is the maximum of its finite distances to
% all other vertices, i.e. ecc(j) = max(dij). Computationally, ecc(j) is
% the maximum of each row of D(G). If all other vertices can be reached
% from j, then ecc(j) is the maximum number of steps needed to reach all of
% them. The radius of a digraph is the minimum eccentricity of all its
% vertices, radius(G) = min(ecc(j)). The diameter of a digraph is the
% maximum eccentricity, diameter(G) = max(ecc(j)).
%
% See Also: closeness_centrality, bridging_centrality
%
% Systems Biology and Evolution Toolbox (SBEToolbox).
% Authors: Kranti Konganti, James Cai.
% (C) Texas A&M University.
%
% $LastChangedDate: 2013-06-23 10:35:39 -0500 (Sun, 23 Jun 2013) $
% $LastChangedRevision: 717 $
% $LastChangedBy: yangence $ 
%

if issparse(G)
    G=double(sparse(G));
end
[D]=all_shortest_paths(G);
res=max(D,[],1);

%ecc=max(D,[],1);
%diam=max(ecc);
%radi=min(ecc);

