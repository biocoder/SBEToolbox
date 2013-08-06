function [idx]=findgenename(nodename,findwhat)
%
% Systems Biology and Evolution Toolbox (SBEToolbox).
% Authors: James Cai, Kranti Konganti.
% (C) Texas A&M University.
%
% $LastChangedDate: 2012-05-29 22:49:45 -0500 (Tue, 29 May 2012) $
% $LastChangedRevision: 80 $
% $LastChangedBy: konganti $
%

x=strfind(nodename,findwhat);
idx=~cellfun(@isempty,x);