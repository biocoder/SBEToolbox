function [n, e] = readnetsession(fname)
%READNETSESSION Read current loaded network from a retained session.
% 
% 
% See also: writenetsession
%
% Systems Biology and Evolution Toolbox (SBEToolbox).
% Authors: Kranti Konganti, James Cai.
% (C) Texas A&M University.
%
% $LastChangedDate: 2013-02-05 13:40:38 -0600 (Tue, 05 Feb 2013) $
% $LastChangedRevision: 412 $
% $LastChangedBy: konganti $
%

[sessionPath, ~, ~] = fileparts(which(mfilename));
sessionPathFile = [sessionPath, filesep, 'session', filesep, fname, '.mat'];

if exist(sessionPathFile, 'file')
    n = load(sessionPathFile, 'nodes');
    e = load(sessionPathFile, 'edges');
    n = n.nodes;
    e = e.edges;
else
    n = [];
    e = [];
end
