function [nc]=neighborhood_conn(G,v)
%NEIGHBORHOOD_CONN - neighborhood connectivity
%
% Science 3 May 2002: Vol. 296. no. 5569, pp. 910 - 913
% DOI: 10.1126/science.1065103
% Specificity and Stability in Topology of Protein Networks
% Sergei Maslov and Kim Sneppen
%
% In undirected networks, the neighborhood connectivity of a node v is
% defined as the average connectivity of all neighbors.
%
% The neighborhood connectivity distribution is computed from the average
% of the neighborhood connectivities of all nodes v with k neighbors for k
% = 0,1,....Maslov and Sneppen (2002) used the neighborhood connectivity
% distribution to comparecorrelation patterns in interaction and regulatory
% networks.
%
% Systems Biology and Evolution Toolbox (SBEToolbox).
% Authors: James Cai, Kranti Konganti.
% (C) Texas A&M University.
%
% $LastChangedDate: 2012-12-28 19:01:43 -0600 (Fri, 28 Dec 2012) $
% $LastChangedRevision: 278 $
% $LastChangedBy: konganti $
%

if nargin<2
    v=1:size(G,1);
end

nc=zeros(length(v),1);
d=sum(G);
for k=1:length(v)
    n=v(k);    
    i_neib=G(:,n);
    d_neib=d(i_neib);
    nc(k)=mean(d_neib);
end

