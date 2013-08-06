function [sbeG,sbeNode,retFname]=readtab2sbe(filename,usenodenum,casesensitive)
%% readtab2sbe - reads Tab delimited file
%
% This function reads in network information in TAB delimited format and 
% returns edge and node information in sbeG and sbeNode. Only the first
% two columns are read and the rest discarded.
%
% See also: readsif2sbe, readpajek2sbe
%
% Systems Biology and Evolution Toolbox (SBEToolbox).
% Authors: James Cai, Kranti Konganti.
% (C) Texas A&M University.
%
% $LastChangedDate: 2013-01-28 16:56:39 -0600 (Mon, 28 Jan 2013) $
% $LastChangedRevision: 378 $
% $LastChangedBy: konganti $
%

%% UI for Browse file window
sbeG=[]; sbeNode=[]; retFname='';

if ispref('SBEToolbox', 'filedir') 
    prevPath = getpref('SBEToolbox', 'filedir');
else    
    prevPath = '';
    addpref('SBEToolbox', 'filedir', pwd);
end

if ~ispref('SBEToolbox', 'filename')
    addpref('SBEToolbox', 'filename', '');
end

if nargin<3
    casesensitive = true;
end
if nargin<2
    usenodenum = false;
end
if nargin < 1
    [filename, pathname] = uigetfile( ...
       {'*.tab;*.txt', 'Tab Separated Text Files (*.tab, *.txt)'; ...
       '*.*', 'All Files (*.*)'}, 'Pick a Text file', ...
       prevPath);
	if ~(filename), return; end
    retFname = filename;
	filename=[pathname,filename];
    if pathname ~= 0
        setpref('SBEToolbox', 'filedir', pathname);
        setpref('SBEToolbox', 'filename', retFname);
    end
end

%% Read file using fopen and textscan
net_file = dir(filename);
tab_file_id = fopen(filename, 'r');
dataCell = textscan(tab_file_id,'%s%s%*[^\n\r]', 'delimiter', '\t',...
    'Bufsize', net_file.bytes);
c = [dataCell{1}; dataCell{2}];
fclose(tab_file_id);

%% Store edge and node information into sbeG and sbeNode
if ~usenodenum
    
    if ~casesensitive
        c=upper(c);
    end    
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
else
    n=max(c(:));
    if min(c)~=1
        error('Node label should start from 1')
    end
    
    sbeG=false(n);
    for k=1:length(dataCell{1})
        sbeG(dataCell{1}(k),dataCell{2}(k))=true;
        sbeG(dataCell{2}(k),dataCell{1}(k))=true;
    end
end

%% Assign empty node as 'N/A'
isemptyNodeNameIdx = find(logical(cellfun(@isempty, sbeNode)));
if ~isempty(isemptyNodeNameIdx) && isempty(sbeNode{isemptyNodeNameIdx})
   sbeNode{isemptyNodeNameIdx} = 'N/A';
end
