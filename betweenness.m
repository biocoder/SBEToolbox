function [betw]=betweenness(G)
%
% Systems Biology and Evolution Toolbox (SBEToolbox).
% Authors: James Cai, Kranti Konganti.
% (C) Texas A&M University.
%
% $LastChangedDate: 2012-12-28 21:28:10 -0600 (Fri, 28 Dec 2012) $
% $LastChangedRevision: 279 $
% $LastChangedBy: jcai $
%
n=num_vertices(G);
betw=zeros(n,1);
for i=1:n
  for j=i+1:n
    [route_st]=shortestpath(G,i,j);
    %route_st
    sl=length(route_st)-1;
    betw(route_st(2:sl)) = betw(route_st(2:sl)) + 1;
  end
end
betw=betw*2;