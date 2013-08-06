function writesbe2protovis(sbeG,sbeNode,sbePartition,filename)
% writesbe2protovis(sbeG,sbeNode,sbePartition,filename)
%
% Systems Biology and Evolution Toolbox (SBEToolbox).
% Authors: James Cai, Kranti Konganti.
% (C) Texas A&M University.
%
% $LastChangedDate: 2012-06-23 14:56:27 -0500 (Sat, 23 Jun 2012) $
% $LastChangedRevision: 146 $
% $LastChangedBy: konganti $
%

if nargin<4
        [filename, pathname,filterindex] = uiputfile( ...
           {'*.js', 'Javascript Files (*.js)';
            '*.*',  'All Files (*.*)'}, ...
            'Save as');
        if ~(filename), return; end
        filename=[pathname,filename];
        if filterindex==1
            if ~(strfind(filename,'.')>1)
                filename=[filename,'.js'];
            end
        end
end
if nargin<3, sbePartition=[]; end

%adj2pajek2(sbeG,filename,'nodeNames',sbeNode,'partition',sbePartition);

n=num_vertices(sbeG);
if nargin<2, sbeNode=cellfun(@num2str,num2cell(1:size(sbeG,1)),'Uniform',false); end

%errordlg(num2str(fopen(filename,'w+','native')));
fid = fopen(filename,'w+','native'); 
fprintf(fid,'var miserables = {\n');
fprintf(fid,'  nodes:[\n');
if isempty(sbePartition)
    for i=1:n 
      fprintf(fid,'{nodeName:"%s", group:0},\n', sbeNode{i});
    end
else
    for i=1:n 
      fprintf(fid,'{nodeName:"%s", group:%d},\n', sbeNode{i},sbePartition(i)-1);
    end
end
fprintf(fid,'  ],\n');
fprintf(fid,'  links:[\n');

for i=1:n
  for j=1:n
    if sbeG(i,j)
       fprintf(fid,'    {source:%d, target:%d, value:1},\n',i-1,j-1);      
    end
  end
end
fprintf(fid,'  ]\n');
fprintf(fid,'};\n');

fclose(fid);
end