function writeattribute2tab(data,nodename,filename,format)
%WRITEATTRIBUTE2TAB - Writes data in tabular form to the file system.
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

prevPath = [prevPath, filesep, 'Untitled.txt'];

if nargin < 4
   format = '%f';
end
if nargin < 3 || isempty(filename)
    [F,P,I] = uiputfile( ...
       {'*.txt', 'Text (Tab delimited) (*.txt)';
        '*.csv', 'CSV (Comma delimited) (*.csv)';
        '*.*',  'All Files (*.*)'}, 'Save as', prevPath);
	if ~(F), return; end

    if P ~= 0
        setpref('SBEToolbox', 'filedirout', P);
    end
    
	if (I==1)
		if (isempty(find(F=='.'))),
		F=[F,'.txt'];
		end
		delimiter = sprintf('\t');
	elseif (I==2)
		if (isempty(find(F=='.'))),
		F=[F,'.csv'];
		end
		delimiter = sprintf(',');
	end
   filename = [P,F];
end

fid = fopen(filename,'wt');
if fid == -1
   disp('Unable to open file.');
   return
end
fformat=['%s\t',format,'\n'];
for k=1:length(data)
    if iscell(data)
        fprintf(fid, '%s\n', data{k});
    else
        fprintf(fid,fformat,nodename{k},data(k));
    end
end
fclose(fid);
