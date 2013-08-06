function [c]=clusteringcoeff(sbeG,v)
%CLUSTERCOEFF - Clustering coefficient of Node(s) v
%
%
% See also: SOFFERCC
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
    v=1:size(sbeG,1);
end

c=zeros(length(v),1);

for k=1:length(v)
    n=v(k);
    i_neib=sbeG(:,n);
    c1=sum(sum(sbeG(i_neib,i_neib)))/2; 
    x=sum(i_neib);
    x=x*(x-1)/2;
    c(k)=c1./x;
end





