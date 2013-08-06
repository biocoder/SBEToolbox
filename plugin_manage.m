function plugin_manage(pName, varargin)
% - plugin_manage(options)
% 
% This function is a tool to manage SBEToolbox's plugins. It will update 
% the global pluginList.info file appropriately.
%
% Example: plugin_manage('demo plugin 2', 'del')
%
% Above command will delete the plugin named 'demo plugin 2'. It will 
% automatically adjust the pluginList.info file if it cannot find the 
% specific plugin directory while deleting a plugin.
%
% Example: plugin_manage('list-local')
%
% Above command will show locally installed plugins. If it cannot find the
% plugin mentioned in the pluginList.info, it will appropriately update it.
%
% Example: plugin_manage('install-fl')
% 
% Above command will open a window to browse for a tarred plugin archive
% and will install plugin from that file. It will be installed into the 
% plugins directory under SBEToolbox.
%
% Example: plugin_manage('pak')
% 
% Above command will open a window to browse a plugin directory and
% will package it into .tar.gz archive so that you can publish / distribute
% your plugin.
%
% Example: plugin_manage('plugin name' 'edit')
% 
% Above command will open a MATLAB editor window to be able to edit the
% plugin code
%
%
% Systems Biology and Evolution Toolbox (SBEToolbox).
% Authors: Kranti Konganti, James Cai.
% (C) Texas A&M University.
%
% $LastChangedDate: 2013-07-11 09:55:16 -0500 (Thu, 11 Jul 2013) $
% $LastChangedRevision: 746 $
% $LastChangedBy: konganti $ 
%

[pPath, ~, ~] = fileparts(which(mfilename()));
pPath = [pPath, filesep, 'plugins', filesep];

if nargin > 2
    fprintf(2, '\n%s\n\n', 'Error: Too many input options. See help plugin_manage');
elseif nargin == 1 && strcmpi(pName, 'list-local')
    list(pPath);
elseif nargin == 2 && strcmpi(varargin{1}, 'del');
    delete(pName, pPath);
elseif nargin == 1 && strcmpi(pName, 'install-fl');
    if ispref('SBEToolbox', 'plfiledir') 
        prevPath = getpref('SBEToolbox', 'plfiledir');
    else    
        prevPath = '';
        addpref('SBEToolbox', 'plfiledir', pwd);
    end
    install_from_file(prevPath, pPath);
elseif nargin == 1 && strcmpi(pName, 'pak');
    package_plugin(pPath);
elseif nargin == 2 && strcmpi(varargin{1}, 'edit');
    edit_plugin(pName, pPath);
elseif nargin == 1 || nargin == 2
    fprintf(2, '\n%s\n\n', 'Unknown option. See help plugin_manage');
end

%--------------------------------------------------------------------------
% Edit plugin in MATLAB editor
%--------------------------------------------------------------------------
function edit_plugin(plName, plPath)
    if strcmpi(plName, 'test plugin')
        errordlg('Cannot edit test plugin. SBEToolbox uses this as template to create new plugins.');
        return;
    end
    
    plName = regexprep(plName, '\-|\_|\s+', '_');
    
    if ~exist([plPath, plName], 'dir')
        fprintf(2, '\n%s\n\n', ['Plugin ', plName, ' does not exist.']);
        return;
    end
    
    cd([plPath, plName]);
    plCode = ['edit ', plName];
    eval(plCode);
    [sbePath, ~, ~] = fileparts(which(mfilename()));
    cd(sbePath);
end

%--------------------------------------------------------------------------
% Package plugin into .tar.gz archive
%--------------------------------------------------------------------------
function package_plugin(plPath)
    pDir = uigetdir(plPath, 'Select Plugin directory to package');
    
	if ~(pDir), return; end;
    [pTarPath, pDirname, ~] = fileparts(pDir);
    tar([pTarPath, filesep, pDirname, '.tar.gz'], '*', pDir);
    fprintf(1, '\n%s\n\n', [pDirname, '.tar.gz has been created at ', ...
        pTarPath]);
end

%--------------------------------------------------------------------------
% Install plugin from file
%--------------------------------------------------------------------------
function install_from_file(prPath, plPath)
    [filename, pathname] = uigetfile( ...
       {'*.tar.gz', 'Tarred plugin file (*.tar.gz)'},...
       'Choose Plugin to Install from tarred archive', prPath);
	if ~(filename), return; end
    
    if pathname ~= 0
        setpref('SBEToolbox', 'plfiledir', pathname);
    end
    
    pfilename=[pathname, filename];
    
    if isempty(regexp(filename, '\.tar\.gz$', 'match'))
        fprintf(2, '\n%s\n\n', 'Plugin must be a tarred archive in format: pluginname.tar.gz');
    elseif exist([plPath, pfilename], 'file')
        fprintf(2, '\n%s\n\n', ['Plugin ( ', filename, ' ) already exists in plugin folder : ', ...
            plPath, ', Exiting ...']);
        return;
    else
        untarIntofilename = regexp(filename, '(^.+?)\.tar\.gz$', 'tokens');
        [isStockPlPath, ~, ~] = fileparts(pfilename);
        isStockPlPath = [isStockPlPath, filesep];
        
        if ~strcmp(isStockPlPath, plPath)
            movefile(pfilename, plPath);
            untar([plPath, filename], [plPath, char(untarIntofilename{1}(1))]);
        else
            untar(pfilename, [plPath, char(untarIntofilename{1}(1))]);
        end

        p_info_FID = fopen([plPath, char(untarIntofilename{1}(1)), ...
            filesep, char(untarIntofilename{1}(1)), '.info'], 'r');
        
        if p_info_FID < 0
            errordlg('Fatal Error, Cannot recover. Try creating manually.')
            return;
        end
        
        p_info = textscan(p_info_FID, '%[^\n]');
        fclose(p_info_FID);
        p_name = char(p_info{1}(3));
        
        pList_FID = fopen([plPath, 'pluginList.info'], 'r');
        pList_append_FID = fopen([plPath, 'pluginList.info'], 'a');
        pluginList = textscan(pList_FID, '%[^\n]');

        for i = 1:size(pluginList{1,:}, 1)
            if ~strcmpi(pluginList{1}(i), p_name)
                isListed = 0;
            else
                isListed = 1;
            end
        end

        if ~isListed
            fprintf(pList_append_FID, '\n%s\n\n', p_name);
            fprintf(1, '\n%s\n\n', ['Plugin ', p_name, ' has been installed into ', ...
                plPath]);
        else
            fprintf(2, '\n%s\n%s\n\n', ...
                ['Skipping plugin ', p_name, ' installation.'], ...
                ['It has already been installed into ', ...
                plPath]);
        end
        fclose(pList_FID);
    end
end


%--------------------------------------------------------------------------
% List local plugins
%--------------------------------------------------------------------------
function list(pluginPath)
    pList_FID = fopen([pluginPath, 'pluginList.info'], 'r');
    pluginList = textscan(pList_FID, '%[^\n]');
    
    for m = 1:size(pluginList{1,:}, 1)
        plName = char(regexprep(pluginList{1}(m), '\-|\_|\s+', '_'));
        folderPath = [pluginPath, plName];
        if ~exist(folderPath, 'dir')
            delete(char(pluginList{1}(m)), pluginPath);
        else
            fprintf(1, '\n%s\n%s\n', ['Plugin : ', char(pluginList{1}(m))], ['Installed Path : ', ...
                folderPath]);
        end
    end
    fprintf(1, '\n');
end


%--------------------------------------------------------------------------
% Delete plugin
%--------------------------------------------------------------------------
function delete(list, pluginPath)
    if strcmpi(list, 'test plugin')
        errordlg('Cannot delete test plugin. SBEToolbox uses this as template to create new plugins.');
        return;
    end
    mvPInfo2tmp(pluginPath);
    pList_FID = fopen([pluginPath, 'pluginList.info.tmp'], 'r');
    pList_writeNew_FID = fopen([pluginPath, 'pluginList.info'], 'w+');
    pluginList = textscan(pList_FID, '%[^\n]');
    folderPath = [pluginPath, regexprep(list, '\-|\_|\s+', '_')];
    
    if ~exist(folderPath, 'dir')
        fprintf(2, '\n%s\n\n', ['Plugin ', list, ' does not exist.']);
    else
        fprintf(1, '\n%s\n\n', ['Plugin ', list, ' will be uninstalled from ', ...
            pluginPath]);
    end
    
    for m = 1:size(pluginList{1,:}, 1)
        if strcmpi(list, pluginList{1}(m))
            [isDel, msg, ~] = rmdir(folderPath, 's');
            if ~isDel
                fprintf(2, ['Error: ', msg]);
                fprintf(1, '\n%s\n', 'Adjust pluginList.info'); 
                continue;
            end
        else
            fprintf(pList_writeNew_FID, '%s\n', char(pluginList{1}(m)));
        end
    end
end

function mvPInfo2tmp(path)
   PFID = fopen([path, 'pluginList.info'], 'r');
   tmpPFID = fopen([path, 'pluginList.info.tmp'], 'w+');
   plname = fgetl(PFID);
   while ischar(plname)
       fprintf(tmpPFID, '%s\n', plname);
       plname = fgetl(PFID);
   end
end

end

