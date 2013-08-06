function [sbeG,sbeNode,fName]=readmat2sbe(filename)
%
% Systems Biology and Evolution Toolbox (SBEToolbox).
% Authors: James Cai, Kranti Konganti.
% (C) Texas A&M University.
%
% $LastChangedDate: 2013-01-15 11:54:38 -0600 (Tue, 15 Jan 2013) $
% $LastChangedRevision: 367 $
% $LastChangedBy: konganti $
%

sbeG=[]; sbeNode=[];

if getpref('SBEToolbox', 'filedir')
    prevPath = getpref('SBEToolbox', 'filedir');
else
    prevPath = '';
end

if ~ispref('SBEToolbox', 'filename')
    addpref('SBEToolbox', 'filename', '');
end

if nargin < 1
    [filename,pathname] = uigetfile( ...
       {'*.mat', 'Matlab Variables Binary Files (*.mat)'; 
        '*.*',  'All Files (*.*)'}, ...
        'Open a file', prevPath);
    if pathname ~= 0
        setpref('SBEToolbox', 'filedir', pathname);
        setpref('SBEToolbox', 'filename', filename);
    end
    
	if isequal(filename,0) || isequal(pathname,0)
        return;
    else
        fName=filename;
		filename=fullfile(pathname,filename); 
    end
end

try
    load(filename,'sbeG','sbeNode');
catch exception
    sbeG=[]; sbeNode=[];
    errordlg(exception);
end

sbeG = sparse(sbeG);

