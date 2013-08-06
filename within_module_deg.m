function [d]=within_module_deg(G,s,isnormalized)
%WITHIN_MODULE_DEGREE - within module degree
%
% [d]=within_module_degree(G,s,isnormalized)
%
% 
%ref: http://www.nature.com/nature/journal/v433/n7028/full/nature03288.html
% See also: participationcoeff
%
% Systems Biology and Evolution Toolbox (SBEToolbox).
% Authors: James Cai, Kranti Konganti.
% (C) Texas A&M University.
%
% $LastChangedDate: 2013-02-12 10:57:29 -0600 (Tue, 12 Feb 2013) $
% $LastChangedRevision: 428 $
% $LastChangedBy: konganti $
%

if nargin<3,
    isnormalized=true;
end
xs=unique(s);
n=num_vertices(G);
d=zeros(n,1);
for k=1:length(xs)
    i=find(s==xs(k));
    di=sum(G(i,i));
    if isnormalized
        d(i)=zscore(di);
    else
        d(i)=di;
    end
end