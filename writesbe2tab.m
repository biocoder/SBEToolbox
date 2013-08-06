function writesbe2tab(sbeG,sbeNode,useint,filename)
% WRITESBE2TAB
%
% writesbe2tab(sbeG,sbeNode,filename,useint)
%
% Systems Biology and Evolution Toolbox (SBEToolbox).
% Authors: James Cai, Kranti Konganti.
% (C) Texas A&M University.
%
% $LastChangedDate: 2013-06-17 11:11:30 -0500 (Mon, 17 Jun 2013) $
% $LastChangedRevision: 667 $
% $LastChangedBy: konganti $
%

if ispref('SBEToolbox', 'filedirout') 
    prevPath = getpref('SBEToolbox', 'filedirout');
else    
    prevPath = '';
    addpref('SBEToolbox', 'filedirout', pwd);
end

prevPath = [prevPath, filesep, 'Untitled.txt'];

if nargin < 3
    useint = false;
end

if nargin < 4
    [filename, pathname, filterindex] = uiputfile({'*.txt;*.tab',...
        'Text Format Files (*.txt, *.tab)';'*.*',  'All Files (*.*)'}, ...
        'Save as', prevPath);
	if isequal(filename, 0), return;
    end
 
	filename=[pathname,filename];
    if pathname ~= 0
        setpref('SBEToolbox', 'filedirout', pathname);
    end
    
	if filterindex==1, if isempty(find(filename=='.',1)),...
                filename=[filename,'.tab']; end, end
end
[n,~]=size(sbeG);

fid=fopen(filename,'w+');
if ~strcmpi('motifformat', useint)
    fprintf(fid, '%%%% Edges\n');
end

if ~issparse(sbeG)
    sbeG = sparse(sbeG);
end

[rowi, coli] = find(sbeG);

for i = 1:numel(coli)
    if sbeG(coli(i), rowi(i))
        if ~useint
            fprintf(fid, '%s\t%s\n',sbeNode{coli(i)},sbeNode{rowi(i)});
        elseif strcmpi('motifformat', useint) && rowi(i) ~= coli(i)
            fprintf(fid, '%d\t%d\t%d\n',coli(i), rowi(i), 1);
            sbeG(rowi(i), coli(i)) = 0;
        elseif ~strcmpi('motifformat', useint)
            fprintf(fid, '%d\t%d\n',coli(i), rowi(i));
        end
    end
end


%{
for i=1:n-1
for j=i+1:n
    if sbeG(i,j)
        if ~useint
            fprintf(fid, '%s\t%s\n',sbeNode{i},sbeNode{j});
        elseif strcmpi('motifformat', useint)
            fprintf(fid, '%d\t%d\n',i,j);
        else
            fprintf(fid, '%d\t%d\n',i,j);
        end
    end
end
end
%}

if ~strcmpi('motifformat', useint)
    fprintf(fid, '%%%% Node Info\n');
    for k=1:n
        fprintf(fid, '%d\t%s\n',k,sbeNode{k});
    end
end

if fid
    fclose(fid);
end