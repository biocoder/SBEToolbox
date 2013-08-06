function [path_slash, plugins_dir] = get_plugins_dir
%get_plugins_dir This function returns plugins directory path
%
% Systems Biology and Evolution Toolbox (SBEToolbox).
% Authors: James Cai, Kranti Konganti.
% (C) Texas A&M University.
%
% $LastChangedDate: 2013-06-11 17:11:20 -0500 (Tue, 11 Jun 2013) $
% $LastChangedRevision: 620 $
% $LastChangedBy: konganti $
%

curr_path=fileparts(which(mfilename));

if ispc
    path_slash = '\\';
else
    path_slash = '/';
end

plugins_dir = strcat(curr_path, path_slash, 'plugins', path_slash);

if exist(plugins_dir, 'dir') ~= 7
    plugins_dir = strcat(regexprep(curr_path, '^(.+?)[\/|\\]+\w+$', '$1'),...
        path_slash, 'plugins', path_slash);
    plugins_dir = ['"', plugins_dir, '"'];
end