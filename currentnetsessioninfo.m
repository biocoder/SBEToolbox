function guiOutput = currentnetsessioninfo(G, guiOutput, retFname)

guiOutput{1} = sprintf('\n%s\n%s',...
    ['Current loaded network : ', retFname], ...
    '===========================================================');
guiOutput = viewnetinfo_gui(G, guiOutput);
[gcc] = graph_clustercoeff(G);
    
guiOutput{4} = sprintf('%s%g', 'Graph clustering coefficient: ', gcc);
[largesbeGinfo,~] = largest_component(G);
    
guiOutput{5} = sprintf('%s%d%s',...
    'Largest connected component within current network has ',...
    size(largesbeGinfo, 1), ' nodes');
    
if size(G,1) > 10000
    guiOutput{6} = sprintf('%s\n%s', ...
        '===========================================================', ...
        'WARNING: Working with a large network may take time during compuation of some statistics');
else
    guiOutput{6} = sprintf('===========================================================\n');
end