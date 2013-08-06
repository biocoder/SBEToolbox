function writesbe2sif(sbeG,sbeNode,filename,useint)
%writesbe2sif(sbeG,sbeNode,filename,useint)
%
% Systems Biology and Evolution Toolbox (SBEToolbox).
% Authors: James Cai, Kranti Konganti.
% (C) Texas A&M University.
%
% $LastChangedDate: 2013-06-17 10:50:01 -0500 (Mon, 17 Jun 2013) $
% $LastChangedRevision: 665 $
% $LastChangedBy: konganti $
%

if ispref('SBEToolbox', 'filedirout') 
    prevPath = getpref('SBEToolbox', 'filedirout');
else    
    prevPath = '';
    addpref('SBEToolbox', 'filedirout', pwd);
end

prevPath = [prevPath, filesep, 'Untitled.sif'];

if nargin<4
    useint=false;
end

if nargin < 3
    [filename, pathname,filterindex] = uiputfile( ...
       {'*.sif', 'SIF Format Files (*.sif)';
        '*.*',  'All Files (*.*)'}, ...
        'Save as', prevPath);
	
    if ~(filename), return; 
    end
    
	filename=[pathname,filename];
    if pathname ~= 0
        setpref('SBEToolbox', 'filedirout', pathname);
    end
    
	if filterindex==1, if isempty(find(filename=='.',1))
            filename=[filename,'.sif']; end, end
end
[n,~]=size(sbeG);


fid=fopen(filename,'w');
if useint
    fprintf(fid, '%%%% Edges\n');
end

for i=1:n-1
for j=i+1:n
    if sbeG(i,j)
        if ~useint
            fprintf(fid, '%s\tpp\t%s\n',sbeNode{i},sbeNode{j});
        else
            fprintf(fid, '%d\tpp\t%d\n',i,j);
        end
    end
end
end

if useint
    fprintf(fid, '%%%% Node Info\n');
    for k=1:n
           fprintf(fid, '%d\t%s\n',k,sbeNode{i});
    end
end
fclose(fid);





