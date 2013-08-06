function cytoscaperun(sbeG,sbeNode)
%CYTOSCAPERUN - view network using CytoScape
%
% Syntax: cytoscaperun(sbeG,sbeNode)
%
% Cytoscape is an open source bioinformatics software platform for
% visualizing molecular interaction networks and integrating these
% interactions with gene expression profiles and other state data.
%
% Systems Biology and Evolution Toolbox (SBEToolbox).
% Authors: James Cai, Kranti Konganti.
% (C) Texas A&M University.
%
% $LastChangedDate: 2012-12-28 19:01:43 -0600 (Fri, 28 Dec 2012) $
% $LastChangedRevision: 278 $
% $LastChangedBy: konganti $
%

[path_slash, addins_dir] = get_addins_dir;

tmp_input_file = strcat(addins_dir, 'cytoscape', path_slash, 'input.sif');

writesbe2sif(sbeG,sbeNode,tmp_input_file);
[status,outmsg]=system('java -version');

if status == 0
    javacmd='java';
else    
    errordlg(strcat('Could not find java at system level on your computer: ',...
        outmsg));
    return;
end

%helpdlg([javacmd ' -jar '...
%    addins_dir 'cytoscape' path_slash 'cytoscape.jar -network ' tmp_input_file...
%    ' -p ' addins_dir 'cytoscape' path_slash 'plugins' path_slash ' &']);

syscmd = [javacmd ' -Xmx512m -jar "' addins_dir 'cytoscape'...
    path_slash 'cytoscape.jar" -network "' tmp_input_file ...
    '" -p "' addins_dir 'cytoscape' path_slash 'plugins" &'];

[s, r] = system(syscmd);

if s ~= 0
    errordlg(r);
end