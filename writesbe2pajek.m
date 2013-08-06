function writesbe2pajek(sbeG,sbeNode,sbePartition,saveaspaj,filename)
%
% Systems Biology and Evolution Toolbox (SBEToolbox).
% Authors: James Cai, Kranti Konganti.
% (C) Texas A&M University.
%
% $LastChangedDate: 2013-03-13 13:05:02 -0500 (Wed, 13 Mar 2013) $
% $LastChangedRevision: 497 $
% $LastChangedBy: konganti $
%

%writesbe2pajek(sbeG,sbeNode,sbePartition,saveaspaj,filename)

if ispref('SBEToolbox', 'filedirout') 
    prevPath = getpref('SBEToolbox', 'filedirout');
else    
    prevPath = '';
    addpref('SBEToolbox', 'filedirout', pwd);
end

if nargin < 5
    if saveaspaj
       prevPath = [prevPath, filesep, 'Untitled.paj'];
       [filename, pathname,filterindex] = uiputfile( ...
       {'*.paj', 'Pajek Project Files (*.paj)';
        '*.*',  'All Files (*.*)'}, ...
        'Save as', prevPath);
    
        if ~(filename), return; end
    
        filename=[pathname,filename];
        if pathname ~= 0
            setpref('SBEToolbox', 'filedirout', pathname);
        end
        
        if filterindex==1
            if ~(strfind(filename,'.')>1)
                filename=[filename,'.paj'];
            end
        end        
    else
        prevPath = [prevPath, '/Untitled.net'];
        [filename, pathname,filterindex] = uiputfile( ...
           {'*.net', 'Pajek Format Files (*.net)';
            '*.*',  'All Files (*.*)'}, ...
            'Save as', prevPath);
        
        if ~(filename), return; end
        
        filename=[pathname,filename];
        if pathname ~= 0
            setpref('SBEToolbox', 'filedirout', pathname);
        end
        
        if filterindex==1
            if ~(strfind(filename,'.')>1)
                filename=[filename,'.net'];
            end
        end
    end
end
if nargin<4, saveaspaj=1; end
if nargin<3, sbePartition=[]; end

  
%adj2pajek2(sbeG,filename,'nodeNames',sbeNode,'partition',sbePartition);

if isGbig(sbeG), h=waitbar(0.5, 'Please wait...'); end
n=num_vertices(sbeG);
if nargin<2, sbeNode=cellfun(@num2str,num2cell(1:size(sbeG,1)),'Uniform',false); end


fid = fopen(filename,'wt','native'); 
if saveaspaj, fprintf(fid,'*Network %s\n',filename); end

fprintf(fid,'*Vertices  %6i\n',n);
for i=1:n
  %fprintf(fid,'%3i %s %s\n', i, sbeNode{i}, 'ellipse');
  fprintf(fid,'%5d %s %s\n', i, sbeNode{i}, 'ellipse');
end

fprintf(fid,'*Edges\n');
%fprintf(fid,'*Arcs\n'); % directed
for i=1:n
  for j=1:n
    if sbeG(i,j)
      %fprintf(fid,' %4i   %4i   %2i\n',i,j,sbeG(i,j));
       fprintf(fid,' %5d   %5d 1\n',i,j);      
    end
  end
end

if ~isempty(sbePartition)
    if saveaspaj,
        fid2=fid;
        fprintf(fid2,'*Partition %s.clu\n',filename(1:end-4));
    else
        fid2 = fopen(sprintf('%s.clu', filename(1:end-4)),'wt','native'); 
    end
  fprintf(fid2,'*Vertices  %6i\n',n);
  for i=1:n, fprintf(fid2, '%d\n', sbePartition(i)); end
  if ~saveaspaj, fclose(fid2); end
end
fclose(fid);


if isGbig(sbeG), waitbar(1, h); end
if exist('h','var'), close(h); end

end


