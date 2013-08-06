function [sbeG,sbeNode,fName]=opensbematfile(filename)
%
% - Read network information from Matlab MAT file.
%
% Systems Biology and Evolution Toolbox (SBEToolbox).
% Authors: James Cai, Kranti Konganti.
% (C) Texas A&M University.
%
% $LastChangedDate: 2013-01-28 16:56:39 -0600 (Mon, 28 Jan 2013) $
% $LastChangedRevision: 378 $
% $LastChangedBy: konganti $
%
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
    [filename,pathname] = uigetfile( ...
       {'*.mat', 'Matlab Variables Binary Files (*.mat)'; 
        '*.*',  'All Files (*.*)'}, ...
        'Open a file', prevPath);
    
    if pathname ~=0
        setpref('SBEToolbox', 'filedir', pathname);
        setpref('SBEToolbox', 'filename', filename);
    end
    
    if isequal(filename,0) || isequal(pathname,0)
		return;
    else
        fName = filename;
		filename=fullfile(pathname,filename); 
	end
end
%disp(['Reading ',filename]);
try
    load(filename,'sbeG','sbeNode');
catch ME
    sbeG=[]; sbeNode=[];
    rethrow(ME)
end

%% Assign empty node as 'N/A'
isemptyNodeNameIdx = find(logical(cellfun(@isempty, sbeNode)));
if ~isempty(isemptyNodeNameIdx) && isempty(sbeNode{isemptyNodeNameIdx})
   sbeNode{isemptyNodeNameIdx} = 'N/A';
end