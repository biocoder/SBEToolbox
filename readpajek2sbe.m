function [sbeG,sbeNode,fName]=readpajek2sbe(filename)
%% readsif2sbe - read in PAJEK format file
%
% This function reads in network information in PAJEK format and returns
% edge and node information in sbeG and sbeNode
%
% See also: readtab2sbe, readsif2sbe
%
% Systems Biology and Evolution Toolbox (SBEToolbox).
% Authors: James Cai, Kranti Konganti.
% (C) Texas A&M University.
%
% $LastChangedDate: 2013-03-13 13:05:02 -0500 (Wed, 13 Mar 2013) $
% $LastChangedRevision: 497 $
% $LastChangedBy: konganti $
%

%% UI for Browse file window
sbeG=[]; sbeNode=[]; fName='';

if ispref('SBEToolbox', 'filedir') 
    prevPath = getpref('SBEToolbox', 'filedir');
else
    prevPath = '';
    addpref('SBEToolbox', 'filedir', pwd);
end

if ~ispref('SBEToolbox', 'filename')
    addpref('SBEToolbox', 'filename', '');
end

if nargin < 1
    [filename, pathname] = uigetfile( ...
        {'*.paj', 'Pajek Network File (*.paj)'; ...
        '*.net', 'Pajek Network File (*.net)'; ...
        '*.*',  'All Files (*.*)'}, ...
        'Pick a Pajek format file', prevPath);
    
    if isequal(filename, 0)
        return 
    end
    fName = filename;
    filename=[pathname,filename];
    if pathname ~= 0
        setpref('SBEToolbox', 'filedir', pathname);
        setpref('SBEToolbox', 'filename', fName);
    end
end

%% Read in file using fopen and textscan
pajek_file_id = fopen(filename, 'r');
dataCell = textscan(pajek_file_id,'%s%q%s%s%*[^\n\r]');
afterVerticesStart = find(~cellfun(@isempty, regexpi(dataCell{1}, '\*vertices')), 1) + 1;
beforeEdgesEnd = find(~cellfun(@isempty, regexpi(dataCell{1}, '\*edges')), 1) - 1;
pajekNodes = cell(beforeEdgesEnd - afterVerticesStart + 1, 1);

if isGbig(pajekNodes), h=waitbar(0.5, 'Please wait...'); end

num_nodes = 0;
for i = afterVerticesStart:beforeEdgesEnd
    num_nodes = num_nodes + 1;
    pajekNodes{num_nodes} = dataCell{2}(i);
    %pajekNodes{num_nodes} = regexprep(dataCell{2}(i), '\"', '');
end

pajekFromNode = cell(num_nodes, 1);
pajekToNode = cell(num_nodes, 1);

nodeStart = 0;
for i = beforeEdgesEnd + 2:size(dataCell{1}, 1)
    nodeStart = nodeStart + 1;
    if ~(mod(str2double(dataCell{1}(i)), 1) == 0), break; end;
    pajekFromNode{nodeStart} = char(pajekNodes{str2double(dataCell{1}(i))});
    pajekToNode{nodeStart} = char(pajekNodes{str2double(dataCell{2}(i))});
end

fclose(pajek_file_id);
c = [pajekFromNode; pajekToNode];

%% Store edge and node information into sbeG and sbeNode
[sbeNode,~,x]=unique(c);
n=numel(sbeNode);
y=reshape(x,[numel(x)/2 2]);
%z=[x(1:numel(x)/2),x(numel(x)/2+1:end)];
%all(y==z);

sbeG=false(n);
for k=1:numel(x)/2
    sbeG(y(k,1),y(k,2))=true;
    sbeG(y(k,2),y(k,1))=true;
end

%% Assign empty node as 'N/A'
isemptyNodeNameIdx = find(logical(cellfun(@isempty, sbeNode)));
if ~isempty(isemptyNodeNameIdx) && isempty(sbeNode{isemptyNodeNameIdx})
   sbeNode{isemptyNodeNameIdx} = 'N/A';
end

%% Close wait bar
if isGbig(sbeG), waitbar(1, h); end
if exist('h','var'), close(h); end

end
