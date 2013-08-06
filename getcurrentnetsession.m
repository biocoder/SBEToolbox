function [n, e] = getcurrentnetsession
% GETCURRENTNETSESSION
%
% Load active network for the session.
% 
% Example: 
%
% [graph, edges] = getcurrentnetsession
%
% See also: writenetsession, readnetsession
%
% Systems Biology and Evolution Toolbox (SBEToolbox).
% Authors: Kranti Konganti, James Cai.
% (C) Texas A&M University.
%
% $LastChangedDate: 2013-02-20 14:02:04 -0600 (Wed, 20 Feb 2013) $
% $LastChangedRevision: 454 $
% $LastChangedBy: konganti $
%

%% Test and load either largest extracted network or original network
if getpref('SBEToolbox', 'largestconnnetCalled') == 1
    [n, e] = readnetsession('sbeLargeConnNet');
elseif getpref('SBEToolbox', 'isRestore') == 1
    [n, e] = readnetsession('sbeEdit');
else
    [n, e] = readnetsession('sbeVars');
end