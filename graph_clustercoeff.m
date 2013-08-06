function [c1,c2]=graph_clustercoeff(G)
%GRAPH_CLUSTERCOEFF Get clustering coefficient of graph sbeG
%
% [c1, c2] = graph_clustercoeff(G) gives clustering coefficient - method 1 and 
%    clustering coefficient - method 2 for network sbeG.
%
% G  - a sparse adjacency matrix that holds the network information, as same
%          as sbeG
% c1 - clustering coefficient of method 1
% c2 - clustering coefficient of method 2
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
    Gx=sparse(G);
end
if ~isa(G,'double')
    Gx=double(G);
end

data=clustering_coefficients(Gx);
c1=nanmean(data);
if nargout>1
    c2=i_method2(G);
end


function C2=i_method2(G)
n=length(G);
CX=0;
CY=0;
for u=1:n
    V=find(G(u,:));
    k=length(V);
    if k>=2;                %degree must be at least 2
        S=G(V,V);
        CX=CX+sum(S(:));
        CY=CY+(k^2-k);
    end
end
C2=CX/CY;