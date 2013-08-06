function url = protovisrun(sbeG,sbeNode,sbePartition)
%PROTOVISRUN - view network using protovis (JavaScript + SVG)
% Syntax: protovisrun(sbeG,sbeNode)
% 
% Protovis is a visualization toolkit for JavaScript using SVG.
%
% Systems Biology and Evolution Toolbox (SBEToolbox).
% Authors: James Cai, Kranti Konganti.
% (C) Texas A&M University.
%
% $LastChangedDate: 2013-06-17 15:04:35 -0500 (Mon, 17 Jun 2013) $
% $LastChangedRevision: 673 $
% $LastChangedBy: konganti $
%
if isGbig(sbeG), h=waitbar(0.5, 'Please wait... Formatting input for Protovis'); end
if nargin<3
    sbePartition=[];
end

[path_slash, addins_dir] = get_addins_dir;

protovis_dir = strcat(addins_dir, 'protovis', path_slash);
%protovis_html_loc = strcat(addins_dir, 'protovis', path_slash, '*.html');
tmp_input_file = strcat(addins_dir, 'protovis', path_slash, 'input.js');

writesbe2protovis(sbeG,sbeNode,sbePartition, tmp_input_file);

%d = dir(protovis_html_loc);
str = {'arc-radial', 'arc', 'force', 'matrix-sort', 'matrix', 'network'};
if isGbig(sbeG), waitbar(1, h); end
if exist('h','var'), close(h); end

[s,v] = listdlg('PromptString','Select a template file:',...
    'SelectionMode','single',...
    'ListString',str);
           
if v==1
    url = strcat(protovis_dir, strcat(str{s}, '.html'));
else
    url = '';
    return;
end