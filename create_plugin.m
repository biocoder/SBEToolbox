function create_plugin(pInfo, varargin)
% - create_plugin(pInfo)
%
% This function will create a plugin from a template test_plugin 
% given a cell string array with the first, second and third values being 
% plugin name, plugin description and plugin author information respectively
%
% Ex: create_plugin({'demoPlugin', 'This plugin will do something', ...
%                     'Kranti Konganti ( konganti@tamu.edu )||Texas A&M University'})
%
% Introducing pipe symbol '|' between the text will print new line in the
% meta data field of plugin display area of SBEToolbox's UI
%
% A plugin name can contain any alpha numeric characters and 3 special
% characters: '-' (hyphen), ' ' (space), '_' (underscore). All special
% characters are converted to '_' (underscore), where as the actual plugin
% name is retained in global pluginList.info file to be able to display in
% the SBEToolbox's UI dropdown menu.
% 
%
% create_plugin({'demo_ok', 'plugin desc', 'author info'}, 1) forces the
% plugin directory to be re created.
%
%
% Systems Biology and Evolution Toolbox (SBEToolbox).
% Authors: Kranti Konganti, James Cai.
% (C) Texas A&M University.
%
% $LastChangedDate: 2013-06-25 11:22:25 -0500 (Tue, 25 Jun 2013) $
% $LastChangedRevision: 725 $
% $LastChangedBy: konganti $ 
%

if ~iscell(pInfo) || size(pInfo, 2) < 3
    fprintf(2, '\nError: Input must be a cell array. See help create_plugin\n\n');
    return;
end

if ~isempty(regexpi(pInfo{1}, '[^\w|\-|\_|\s+]', 'match'))
    fprintf(2, ['\nError: Plugin name contains invalid characters',...
        '\nIt can contain any alpha numeric characters and 3 special variables:\n', ...
        '''_'' (underscore), '' '' (space) or a ''-'' (hyphen)\n\n']);
    return;
end

[pPath, ~, ~] = fileparts(which(mfilename()));
pPath = [pPath, filesep, 'plugins', filesep];

pFolderName = [pPath, regexprep(pInfo{1}, '\-|\_|\s+', '_')];

if nargin < 2 && exist(pFolderName, 'dir')
    fprintf(2, ['\nError: Plugin directory already exists\n', ...
        'Use create_plugin(', pInfo{1}, ', ' pInfo{2}, ', ', pInfo{3}, ...
        ', 1) to forcefully re create directory\n' ...
        'See help create_plugin for more information\n\n']);
elseif nargin == 2 && varargin{1} ~= 1
    fprintf(2, '\nError: Not a valid option. Use 1 to force create directory.\n\n');
elseif nargin > 2
    fprintf(2, '\nError: Too many input options.\nSee help create_plugin\n\n');
else
    [ismkdir, ~, ~] = mkdir(pFolderName);
    if ismkdir
        write_template(pInfo, ...
            pPath, pFolderName, regexprep(pInfo{1}, '\-|\_|\s+', '_'), ...
            pInfo{3}, pInfo{1});
    end
end

function write_template(info, plPath, folder, name, aInfo, unalt_name)
%
t_info_FID = fopen([folder, filesep, name, '.info'], 'w+');
fprintf(t_info_FID, '%s\n%s\n%s', info{2}, info{3}, unalt_name);
fclose(t_info_FID);

pList_FID = fopen([plPath, 'pluginList.info'], 'r');
pList_append_FID = fopen([plPath, 'pluginList.info'], 'a');
pluginList = textscan(pList_FID, '%[^\n]');

for i = 1:size(pluginList{1,:}, 1)
    if ~strcmpi(pluginList{1}(i), unalt_name)
        isListed = 0;
    else
        isListed = 1;
    end
end

if ~isListed
    fprintf(pList_append_FID, '\n%s', unalt_name);
end

fclose(pList_FID);

t_wm_FID = fopen([folder, filesep, name, '.m'], 'w+');
t_m_FID = fopen([plPath, 'test_plugin', filesep, 'test_plugin.m'], 'r');
mContents = fgetl(t_m_FID);


temp_plugin_pat = '(test.*?plugin)';
place_holder_pat = '.*?(PlaceHolder)';
stock_author_pat = '(Kranti.*?Konganti)';
guiOutTitle_pat = 'outputHeaderTitle.*?(test.*?plugin)';

while ischar(mContents)    
    replace_plugin_name = regexpi(mContents, temp_plugin_pat, 'match');
    print_new_line = regexpi(mContents, place_holder_pat, 'match');
    author = regexpi(mContents, stock_author_pat, 'match');
    title = regexpi(mContents, guiOutTitle_pat, 'match');
    
    if ~isempty(title)
        mContents = regexprep(mContents, title, ['outputHeaderTitle = ''', ...
            unalt_name]);
    elseif ~isempty(replace_plugin_name)
        mContents = regexprep(mContents, replace_plugin_name, name);
    end
    
    if ~isempty(author)
        authorName = splitSentence(aInfo);
        mContents = regexprep(mContents, author, authorName{1});
    end
    
    if ~isempty(print_new_line)
        fprintf(t_wm_FID, '\n');
    else
        fprintf(t_wm_FID, '%s\n', char(mContents));
    end
    mContents = fgetl(t_m_FID);
end

fclose(t_wm_FID);

end

end