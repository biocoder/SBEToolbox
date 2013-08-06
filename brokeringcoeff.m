function [b]=brokeringcoeff(G)
%
% Systems Biology and Evolution Toolbox (SBEToolbox).
% Authors: James Cai, Kranti Konganti.
% (C) Texas A&M University.
%
% $LastChangedDate: 2012-12-28 19:01:43 -0600 (Fri, 28 Dec 2012) $
% $LastChangedRevision: 278 $
% $LastChangedBy: konganti $
%


n=num_vertices(G);
data1=sum(G,2);
data1=data1./(n-1);    % degree
%data1=zscore(data1);


if ~issparse(G), G=sparse(G); end
if ~isa(G,'double'), G=double(G); end
data2=clustering_coefficients(G);

b=log(data1+1)-log(data2+1);





