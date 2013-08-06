function [b]=bridgingcoeff(G)
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
b=zeros(n,1);

if ~islogical(G)
    G=logical(G);
end
d=sum(G);   % degree;

for k=1:n
    b(k)=(1./d(k))./sum(1./d(G(:,k)));
end






