function [sbeG,sbeNode]=sbe_openfile(filename,formatid)
%SBE_OPENFILE - Open network file
%
% [sbeG,sbeNode]=sbe_openfile(filename,formatid)
% formatid: 1 - TAB, 2 - SIF, 3 - MAT, 4 - Pajek

% Systems Biology and Evolution Toolbox (SBEToolbox).
% Authors: James Cai, Kranti Konganti.
% (C) Texas A&M University.
%
% $LastChangedDate: 2012-12-28 19:01:43 -0600 (Fri, 28 Dec 2012) $
% $LastChangedRevision: 278 $
% $LastChangedBy: konganti $
%

sbeG=[];
sbeNode=[];
if nargin < 1
    [filename,pathname,filterindex] = uigetfile( ...
       {'*.txt;*.tab;*.tgf', 'Text Files (*.txt, *.tab, *.tgf)'; 
        '*.sif', 'SIF Files (*.sif)';
        '*.mat', 'MAT Files (*.mat)';        
        '*.net', 'Pajek Network Files (*.net)';        
        '*.*',  'All Files (*.*)'}, ...
        'Open a file');
	
	if (filterindex==4)
	      formatid=i_ask4formatid;
	else
	      formatid=filterindex;
    end	

	if isequal(filename,0) || isequal(pathname,0)
		return;
	else
		filename=fullfile(pathname,filename); 
	end
end

disp(['Reading ',filename]);
switch (formatid)
    case (1)
	 [sbeG,sbeNode]=readtab2sbe(filename);
    case (2)
     [sbeG,sbeNode]=readsif2sbe(filename);
    case (3)
     load(filename,'sbeG','sbeNode');
    case (4)
      [sbeG,sbeNode]=readpajek2sbe(filename);
end




function [id] = i_ask4formatid()

	ButtonName=questdlg('What kind of file format?', ...
			    'Select sequence format', ...
			    'TXT','SIF','MAT','Pajek');
	switch ButtonName,
	    case 'TXT', 
            id=1;          
	    case 'SIF'
            id=2;    
	    case 'MAT'
            id=3;        
        otherwise
            id=4;
	end

