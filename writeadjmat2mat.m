function writeadjmat2mat(sbeG,isascii,filename)
%
% Systems Biology and Evolution Toolbox (SBEToolbox).
% Authors: James Cai, Kranti Konganti.
% (C) Texas A&M University.
%
% $LastChangedDate: 2013-02-05 13:32:46 -0600 (Tue, 05 Feb 2013) $
% $LastChangedRevision: 411 $
% $LastChangedBy: konganti $
%
if ispref('SBEToolbox', 'fileimportexportmat') 
    prevPath = getpref('SBEToolbox', 'fileimportexportmat');
else    
    prevPath = '';
    addpref('SBEToolbox', 'fileimportexportmat', pwd);
end

prevPath = [prevPath, filesep, 'Untitled'];

if issparse(sbeG)
    sbeG = full(sbeG);
end

if nargin<2
    isascii=true;
end
if nargin < 3
    [F,P,I] = uiputfile( ...
       {'*.tab', 'Text (Tab delimited) (*.tab)';
        '*.csv', 'CSV (Comma delimited) (*.csv)';
        '*.*',  'All Files (*.*)'},'',prevPath);
    if P ~= 0
        setpref('SBEToolbox', 'fileimportexportmat', P);
    end
	if ~(F), return; end
	if (I==1)
		if (isempty(find(F=='.',1))),
    		F=[F,'.tab'];
		end
		delimiter = sprintf('\t');
	elseif (I==2)
		if (isempty(find(F=='.',1))),
        	F=[F,'.csv'];
		end
		delimiter = sprintf(',');
	end
   % [F,P]=uiputfile('*');
   filename = [P,F];
end


if isascii
    fid = fopen(filename,'wt');
    if fid == -1
       disp('Unable to open file.');
       return;
    end
    n=size(sbeG,1);
    for i=1:n
    for j=1:n    
        fprintf(fid,'%d%s',sbeG(i,j),delimiter);
    end
        fprintf(fid,'\n');
    end
    fclose(fid);
end
