function writenetsession(nodes, edges, fname)
%WRITENETSESSION Save current loaded network to be retained for a session.
% 
% 
% See also: readnetsession
%
% Systems Biology and Evolution Toolbox (SBEToolbox).
% Authors: Kranti Konganti, James Cai.
% (C) Texas A&M University.
%
% $LastChangedDate: 2013-06-28 08:45:40 -0500 (Fri, 28 Jun 2013) $
% $LastChangedRevision: 743 $
% $LastChangedBy: konganti $
%

[sessionPath, ~, ~] = fileparts(which(mfilename));
sessionPathFile = [sessionPath, filesep, 'session', filesep, fname, '.mat'];

if ~issparse(nodes)
    nodes = sparse(nodes);
end

save(sessionPathFile, 'nodes', 'edges');
