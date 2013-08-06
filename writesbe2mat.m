function writesbe2mat(sbeG,sbeNode,filename)
%
% Systems Biology and Evolution Toolbox (SBEToolbox).
% Authors: James Cai, Kranti Konganti.
% (C) Texas A&M University.
%
% $LastChangedDate: 2013-02-05 13:32:46 -0600 (Tue, 05 Feb 2013) $
% $LastChangedRevision: 411 $
% $LastChangedBy: konganti $
%

if ispref('SBEToolbox', 'filedirout') 
    prevPath = getpref('SBEToolbox', 'filedirout');
else    
    prevPath = '';
    addpref('SBEToolbox', 'filedirout', pwd);
end

prevPath = [prevPath, filesep, 'Untitled.mat'];

if nargin < 3
    [filename, pathname,~] = uiputfile( ...
       {'*.mat', 'Matlab Variables Binary Files (*.mat)'}, ...
        'Save as', prevPath);
    
	if ~(filename), return; end
    if pathname ~= 0
        setpref('SBEToolbox', 'filedirout', pathname);
    end
    filename=[pathname,filename];
    
    %if filterindex==1
	%	if isempty(find(filename=='.',1))
    %        filename=[filename,'.mat'];
    %    end
    %end
end
save(filename,'sbeG','sbeNode');




