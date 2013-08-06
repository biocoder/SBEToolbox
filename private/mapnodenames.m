function [M]=mapnodenames(sbeNode,M)
%
% Systems Biology and Evolution Toolbox (SBEToolbox).
% Authors: James Cai, Kranti Konganti.
% (C) Texas A&M University.
%
% $LastChangedDate: 2012-05-29 22:49:45 -0500 (Tue, 29 May 2012) $
% $LastChangedRevision: 80 $
% $LastChangedBy: konganti $
%

if nargin<1, M=containers.Map(); end
for k=1:numel(sbeNode)
    M(sbeNode{k}) = k;
end