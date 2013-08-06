function [Diam,Rad,Pv,Cv]=graph_diameter(G)
%GRAPH_DIAMETER Get diameter of current graph G
%
% [Diam, Rad, Pv, Cv] = graph_diameter(G)
%
% A graph's diameter is the largest number of vertices which must be 
%    traversed in order to travel from one vertex to another when paths which 
%    backtrack, detour, or loop are excluded from consideration.
%
%  G     - a sparse adjacency matrix that holds the network information, as same
%          as sbeG
%  DIAM  - the diameter
%  RAD   - the radius
%  Pv    - the periphery vertexes of the graph
%  Cv    - the center vertexes of the graph
%
% Systems Biology and Evolution Toolbox (SBEToolbox).
% Authors: Kranti Konganti, James Cai.
% (C) Texas A&M University.
%
% $LastChangedDate: 2013-06-23 10:35:39 -0500 (Sun, 23 Jun 2013) $
% $LastChangedRevision: 717 $
% $LastChangedBy: yangence $ 
%
if ~issparse(G)
    G=double(sparse(G));
end
[D]=all_shortest_paths(G);
Ec=max(D); % the eccentricity of all vertexes
Diam=max(D(:));
if nargout>1
    Rad=min(D(:));
end
if nargout>2
    Pv=find(Ec==Diam); % the periphery vertexes of the graph
    Cv=find(Ec==Rad);  % the center vertexes of the graph
end