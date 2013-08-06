function [swidx]=smallworldindex(sbeG)
%SMALLWORLDINDEX - small-world index
%
% [swidx]=smallworldindex(sbeG)
%
% Systems Biology and Evolution Toolbox (SBEToolbox).
% Authors: James Cai, Kranti Konganti.
% (C) Texas A&M University.
%
% $LastChangedDate: 2012-12-28 19:01:43 -0600 (Fri, 28 Dec 2012) $
% $LastChangedRevision: 278 $
% $LastChangedBy: konganti $
%

[kden]=graph_density(sbeG);
G2=randnet_er(num_vertices(sbeG),kden/2);

sbeG=double(sparse(sbeG));
G2=double(sparse(G2));

cc1=clustering_coefficients(sbeG);
cc2=clustering_coefficients(G2);

% we define the characteristic path length ?(G) of a graph as the global
% mean of the finite entries of its distance matrix. Thus, the
% characteristic path length constitutes a measure of central tendency of
% D(G).

D1=all_shortest_paths(sbeG);
D2=all_shortest_paths(G2);
dd1=mean(D1(:));
dd2=mean(D2(:));

swidx=(mean(cc1)./mean(cc2))./(dd1./dd2);

%Humphries et al

