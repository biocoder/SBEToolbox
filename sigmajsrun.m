function url = sigmajsrun(sbeG,sbeNode,xy)
%SIGMAJSRUN - view network using sigma.js
% Syntax: sigmajsrun(sbeG,sbeNode)
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
if isGbig(sbeG), h=waitbar(0.5, 'Please wait... Formatting input for Sigma.js'); end
[path_slash, addins_dir] = get_addins_dir;

sigmajs_dir = strcat(addins_dir, 'sigmajs', path_slash);
%sigmajs_html_loc = strcat(addins_dir, 'sigmajs', path_slash, '*.html');
tmp_input_file = strcat(addins_dir, 'sigmajs', path_slash, 'input.xml');

if ~issymmetric(sbeG)
    [sbeG]=symmetrizeadjmat(sbeG);
end

writesbe2xml(sbeG,sbeNode,tmp_input_file,xy)

%d = dir(sigmajs_html_loc);
str = {'curve_edges', 'fisheye', 'force_atlas2', 'hide_non_neighbor', ...
    'highlight_neighbor'};

if isGbig(sbeG), waitbar(1, h); end
if exist('h','var'), close(h); end

[s,v] = listdlg('PromptString','Select a template file:',...
                'SelectionMode','single',...
                'ListString',str);
if v==1
    url = strcat(sigmajs_dir, strcat(str{s}, '.html'));
else
    url = '';
    return;
end




