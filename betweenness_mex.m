function [betw]=betweenness_mex(sbeG)
%
% Systems Biology and Evolution Toolbox (SBEToolbox).
% Authors: James Cai, Kranti Konganti.
% (C) Texas A&M University.
%
% $LastChangedDate: 2012-12-28 21:28:10 -0600 (Fri, 28 Dec 2012) $
% $LastChangedRevision: 279 $
% $LastChangedBy: jcai $
%
betw=betweenness_centrality(double(sparse(sbeG)));
