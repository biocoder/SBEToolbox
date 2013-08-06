function [path_slash, addins_dir] = get_addins_dir
%get_addins_dir This function returns addins directory path
%
% Systems Biology and Evolution Toolbox (SBEToolbox).
% Authors: James Cai, Kranti Konganti.
% (C) Texas A&M University.
%
% $LastChangedDate: 2013-06-12 11:54:51 -0500 (Wed, 12 Jun 2013) $
% $LastChangedRevision: 637 $
% $LastChangedBy: konganti $
%

curr_path=fileparts(which(mfilename));

addins_dir = strcat(curr_path, filesep, 'addins', filesep);

if exist(addins_dir, 'dir') ~= 7
    addins_dir = strcat(regexprep(curr_path, '^(.+?)[\/|\\]+\w+$', '$1'),...
        filesep, 'addins', filesep);
    addins_dir = ['"', addins_dir, '"'];
end

path_slash = filesep;