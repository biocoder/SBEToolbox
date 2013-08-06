function [msg, moduleid]=clusteronerun(sbeG,sbeNode)
%CLUSTERONERUN - view network using protovis (JavaScript + SVG)
%
% Syntax: [moduleid]=clusteronerun(sbeG,sbeNode)
% 
% Ref: Detecting overlapping protein complexes in protein-protein interaction networks
%      Nature Methods 9, 471–472 (2012) doi:10.1038/nmeth.1938
%
% Systems Biology and Evolution Toolbox (SBEToolbox).
% Authors: James Cai, Kranti Konganti.
% (C) Texas A&M University.
%
% $LastChangedDate: 2013-06-17 10:50:01 -0500 (Mon, 17 Jun 2013) $
% $LastChangedRevision: 665 $
% $LastChangedBy: konganti $
%

if nargin<2
    sbeNode=cellfun(@num2str,num2cell(1:size(sbeG,1)),'Uniform',false);
end

[path_slash, addins_dir] = get_addins_dir;

input_file = [addins_dir, 'clusterone', path_slash, 'input.sif'];
output_file = [addins_dir, 'clusterone', path_slash, 'output.txt'];

writesbe2sif(sbeG,sbeNode,input_file);
[status,outmsg]=system('java -version');

if status == 0
    javacmd='java';
else
    errordlg(strcat('Could not find java at system level on your computer: ',...
        outmsg));
    return;
end

[s, r] = system([javacmd, ' -jar ', '"', addins_dir, 'clusterone', path_slash, ...
    'cluster_one-0.94.jar', '" -f sif "', input_file, '"'...
    ' > ', '"', output_file, '"']);

msg = '';

if s ~= 0
    errordlg(r);
else
    msg = strsplit(char(r), '\n');
    msg = msg{end - 1};
end

moduleid=zeros(size(sbeNode));

fid=fopen(output_file,'r');
ts=textscan(fid,'%s','Delimiter','\n');
fclose(fid);
ts=ts{1};
for k=1:length(ts)
   t=textscan(ts{k},'%s');
   [~,idx]=intersect(sbeNode,t{1});
   moduleid(idx)=k;
end