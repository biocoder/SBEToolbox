function outputCell = test_plugin
% - Test plugin 
% It will print first 5 node names of the network.
% Shows the ability of SBEToolbox to extend the functionality of the
% software. Users have access to nodes and edges and can be loaded from 
% saved session as you can see below. User can then manipulate and leverage
% the power of various MATLAB toolboxes to perform various operations
%
% Kranti Konganti
%


%% Test and load either largest extracted network or original network
[g, e] = getcurrentnetsession;



%% Define size of output
outputCell = cell(5,1);



%% Output header
outputHeaderTitle = 'Test Plugin';



%% If network is not yet loaded, return
if isempty(g)
    outputCell{1} = sprintf('\n%s\n%s\n%s\n\n%s', outputHeaderTitle, ...
        '=======================================', ...
        'Network not yet loaded !', ...
        'Aborting plugin execution ...');
    return;
end

outputCell{1} = sprintf('\n%s\n', outputHeaderTitle);



%% Rest of the function output
for n = 2:6
    nodeIndOffset = n - 1;
    outputCell{n} = char(e{nodeIndOffset});
end
