function [sbeG,sbeNode,fName]=readsif2sbe(filename)
%% readsif2sbe - read in SIF format file
%
% This function reads in network information in SIF format and returns
% edge and node information in sbeG and sbeNode
%
% See also: readtab2sbe, readpajek2sbe
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
        {'*.sif', 'SIF Files (*.sif)';'*.*',  'All Files (*.*)'}, ...
        'Pick an SIF file', prevPath);
    
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

%% Read file using fopen and textscan
sif_file_id = fopen(filename);
dataCell = textscan(sif_file_id, '%s%s%s');
fclose(sif_file_id);
c = [dataCell{1};dataCell{3}];

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