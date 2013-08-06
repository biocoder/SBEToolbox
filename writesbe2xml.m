function writesbe2xml(sbeG,sbeNode,filename,xy)
% WRITESBE2XML
%
% writesbe2xml(sbeG,sbeNode,filename,useint)
%
if nargin<4
    xy=[];
end
if nargin < 3 || isempty(filename)
    [filename, pathname, filterindex] = uiputfile({'*.xml;*.gexf',...
        'Text Format Files (*.xml, *.gexf)';'*.*',  'All Files (*.*)'}, ...
        'Save as', 'Untitled.xml');
	if isequal(filename, 0), return;
    end
 
	filename=[pathname,filename];
	if filterindex==1, if isempty(find(filename=='.',1)),...
                filename=[filename,'.xml']; end, end
end
[n,~]=size(sbeG);


fid=fopen(filename,'w');

fprintf(fid,'<?xml version="1.0" encoding="UTF-8"?>\n');
fprintf(fid,'<gexf xmlns="http://www.gephi.org/gexf" xmlns:viz="http://www.gephi.org/gexf/viz">\n');
fprintf(fid,'<graph type="static">\n');
fprintf(fid,'<attributes class="node" type="static">\n');
fprintf(fid,'<attribute id="0" title="label" type="string"/>\n');
fprintf(fid,'</attributes>\n');
fprintf(fid,'<nodes>\n');

c{1}='<viz:color b="0" g="0" r="153"/>';
c{2}='<viz:color b="51" g="51" r="255"/>';
c{3}='<viz:color b="204" g="204" r="0"/>';
c{4}='<viz:color b="102" g="255" r="102"/>';
c{5}='<viz:color b="51" g="255" r="255"/>';
c{6}='<viz:color b="204" g="204" r="0"/>';
c{7}='<viz:color b="51" g="51" r="255"/>';
id=floor(rand*7)+1;

for k=1:length(sbeNode)
    fprintf(fid,'<node id="%d" label="%s">\n',k-1,sbeNode{k});
        fprintf(fid,'%s\n',c{id});
    if ~isempty(xy)
     fprintf(fid,'<viz:position x="%f" y="%f" z="0.0"/>\n',xy(k,1),xy(k,2));
    end
    fprintf(fid,'<viz:size value="3.6"/>\n');
    fprintf(fid,'<attvalues>\n');
    fprintf(fid,'<attvalue id="0" value="%s"/>\n',sbeNode{k});
    fprintf(fid,'</attvalues>\n');
    fprintf(fid,'</node>\n');
end
fprintf(fid,'</nodes>\n');

c=0;
fprintf(fid,'<edges>\n');
for i=1:n-1
for j=i+1:n
    if sbeG(i,j)
        fprintf(fid,'<edge id="%d" source="%d" target="%d"/>\n',c,i-1,j-1);
        c=c+1;
    end
end
end
fprintf(fid,'</edges>\n');
fprintf(fid,'</graph>\n');
fprintf(fid,'</gexf>\n');

if fid
    fclose(fid);
end