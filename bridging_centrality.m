function [bc,b,c]=bridging_centrality(G)
%BRIDGING_CENTRALITY Calculate bridging centrality
% 
% [bc,b,c]=bridging_centrality(G) gets the bridging centrality of each node
% in graph sbeG.
%
% See also: eccentricity_centrality, closeness_centrality
%
% Ref: Hwang et al (2006)
%
% Systems Biology and Evolution Toolbox (SBEToolbox).
% Authors: Kranti Konganti, James Cai.
% (C) Texas A&M University.
%
% $LastChangedDate: 2012-12-28 19:01:43 -0600 (Fri, 28 Dec 2012) $
% $LastChangedRevision: 278 $
% $LastChangedBy: konganti $
%

if ~issparse(G), G=sparse(G); end
if ~isa(G,'double'), G=double(G); end

[b]=betweenness_centrality(G);
n=num_vertices(G);
%x=2*nchoosek(n-1,2); %b=b./x;
b=b./((n-1)*(n-2));
[c]=bridgingcoeff(G);

bc=b.*c;
