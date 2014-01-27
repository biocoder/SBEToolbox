function outputCell = Correlation_Network(varargin)
% Correlation_Network 
% This plugin will infer Biological network from similarity matrices such 
% as microarray data and convert it into node pairs for analysis with 
% SBEToolbox. It uses mcxarray from MCL-Edge (http://micans.org/mcl/man/mcxarray.html) package.
%
% Version 1.0
%
% Correlation_Network('path_to_file');
%
% (C) Kranti Konganti
% Whole Systems Genomics Initiative
% Texas A&M University
%

%% Set SBEToolbox file path preferences

if ispref('SBEToolbox', 'filedir') 
    prevPath = getpref('SBEToolbox', 'filedir');
else
    prevPath = '';
    addpref('SBEToolbox', 'filedir', pwd);
end

if ~ispref('SBEToolbox', 'filename')
    addpref('SBEToolbox', 'filename', '');
end

%% Get file either from GUI or command line

if nargin < 1
    [filename, pathname] = uigetfile( ...
       {'*.tab;*.txt', 'Microarray Expression Data Files (*.tab, *.txt)'; ...
       '*.*', 'All Files (*.*)'}, 'Pick a Matrix File', ...
       prevPath);
    
    if ~(filename)
        outputCell = getHeader('Selection Incomplete !');
        return; 
    end
    retFname = filename;
	filename = [pathname,filename];
elseif nargin == 1
    filename = varargin{1};
elseif nargin > 1
    errordlg('Invalid number of options. See ''help Correlation_Network''', ...
        'SBEToolbox Plugin Error');
    outputCell{1} = sprintf('\n%s\n', ...
        'Invalid number of options. See ''help Correlation_Network''');
    return;
end

filename = ['"', filename, '"'];

%% Let user know if we are doing some initial compilation

waitH = waitbar(0.10, 'Checking if mcxarray is compiled and ready...');
if ismac && strcmpi(computer('arch'), 'maci64')
    % Do nothing...
elseif ismac && ~strcmpi(computer('arch'), 'maci64')
    errordlg('Cannot use pre-compiled binaries for other than i64 architecture');
    close(waitH);
    return;
elseif isunix && ~exist(['.', filesep, 'unix', filesep, 'bin', filesep, 'mcxarray'], 'file')
    waitbar(0.20, waitH, ['Compiling MCL-Edge for ', computer, ' architecture...']);
    [cmdStatus, ~] = unix(['.', filesep, 'mcl-12-068', filesep, ...
        'configure --prefix=', fileparts(which(mfilename)), ...
        filesep, 'unix', filesep, '. && make && make install']);
    if cmdStatus
        errordlg('Compiling MCL-Edge Failed !');
        close(waitH);
        return;
    end
end
    
%% Get appropriate mcxarray and mcxdump executables for system architecture

if ismac && strcmpi(computer('arch'), 'maci64')
    mcxarrayexe = ['"', fileparts(which(mfilename)), filesep, 'maci64', filesep, 'bin', ...
        filesep, 'mcxarray"'];
    mcxdumpexe = ['"', fileparts(which(mfilename)), filesep, 'maci64', filesep, 'bin', ...
        filesep, 'mcxdump"'];
elseif isunix
    mcxarrayexe = ['"', fileparts(which(mfilename)), filesep, 'unix', filesep, 'bin', ...
        filesep, 'mcxarray"'];
    mcxdumpexe = ['"', fileparts(which(mfilename)), filesep, 'unix', filesep, 'bin', ...
        filesep, 'mcxdump"'];
elseif ispc
    mcxarrayexe = ['"', fileparts(which(mfilename)), filesep, 'win', filesep, ...
        'mcxarray.exe"'];
    mcxdumpexe = ['"', fileparts(which(mfilename)), filesep, 'win', filesep...
        'mcxdump.exe"'];
end

%% Define default options for mcxarray and ask user if they want to change it

def={'0.9', '1', '1'};
dlgTitle='mcxarray Options';
lineNo=1;
prompt={'Retain gene pairs that have Pearson Correlation Coefficient >= ', ...
    'Skip Number of Columns: ', ...
    'Skip Number of Rows: '};
answer = inputdlg(prompt,dlgTitle, ...
    [lineNo, 65], def);
if isempty(answer)
   outputCell = getHeader('Selection Incomplete !');
   close(waitH);
   return;
end

co = answer{1};
skipc = answer{2};
skipr = answer{3};

%% Now run mcxarray and mcxdump

waitbar(0.30, waitH, 'Running mcxarray...');
[mcxarrayStatus, mcxOut] = system([mcxarrayexe, ' -co ', co, ...
    ' -write-tab ', '.', filesep, 'network', ...
    filesep, 'nodes.txt ', ' --pearson -skipc ', skipc, ' -skipr ', skipr, ...
    ' -o ', '.', filesep, 'network', filesep, 'net.imx -data ', filename]);
outputCell{1} = sprintf('%s\n%s\n%s', char(getHeader('')), mcxOut);
if ~mcxarrayStatus
    waitbar(0.40, waitH, 'Running mcxdump...');
    [~, mcxOut] = system([mcxdumpexe, ' -imx ', '.', filesep, ...
        'network', filesep, 'net.imx --dump-upper -o ', ...
    '.', filesep, 'network', filesep, 'net.tab']);
    outputCell{2} = sprintf('\n%s', mcxOut);
end

if ~isempty(regexpi(mcxOut, 'failed', 'match')) || mcxarrayStatus
    outputCell{end + 1} = sprintf('\n\n%s\n\n%s', 'mcxarray Failed !', ...
        'Is your data microarray expression data with PCC''s?', ...
        'For ex: Take a look at file ''Microarray_expression_data_PCCs_TAC_male.tab'' within ''example_dataset'' folder');
    waitbar(1, waitH);
    close(waitH);
    return;
else
    setpref('SBEToolbox', 'filedir', pathname);
    setpref('SBEToolbox', 'filename', retFname);
end

%% Format it to use with SBEToolbox and let SBEToolbox know that we want
%  the network to be reloaded

waitbar(0.50, waitH, 'Formatting data to use with SBEToolbox...');
[sbeG, sbeBNodes, ~] = readtab2sbe(['.', filesep, 'network', filesep, 'net.tab']);
sbeBNodes = adjustMCXIndices(sbeBNodes);
nodesFID = fopen(['.', filesep, 'network', filesep, 'nodes.txt'], 'r');
sbeNodes = textscan(nodesFID, '%s%s');
sbeNodeNames = sbeNodes{2};

sbeNode = cell(numel(sbeBNodes), 1);
for i = 1:numel(sbeBNodes)
    sbeNode{i} = sbeNodeNames{sbeBNodes(i)};
end

writenetsession(sbeG, sbeNode, 'sbeVars');
setpref('SBEToolbox', 'isPluginNetworkReload', 1);

%% Done transforming microarray data into adjacency matrix!
waitbar(1, waitH);
close(waitH);


%% Function to avoid repetetion
function adjNodes = adjustMCXIndices(nodes)
    adjNodes = zeros(numel(nodes), 1);
    for ind = 1:numel(nodes);
        adjNodes(ind) = str2double(nodes(ind)) + 1;
    end
end

%% Function to avoid repetetion
function O = getHeader(title)
    title = char(title);
    O{1} = sprintf('\n%s\n%s\n%s\n\n', 'Correlation Network Output', ...
        '=======================================', ...
        title);
end

end
