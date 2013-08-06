function [evoG, evoE, msg] = network_evolution(g, e, mode, steps, varargin)
% - NETWORK_EVOLUTION
%
% This function will simulate the events in nature such as random mutations
% which results in loss / gain of new gene functions and new co expression
% networks. 
%
% Example: 
%
% For modes 1, 2, 3, 4 :
%
% [newNodes, newEdges, message] = network_evolution(sbeG, sbeNode, mode, 50), 
% where 50 is number of steps for which the current network is randomly evolved.
%
% To perform simulation of targeted selection of nodes:
%
% [newNodes, newEdges, message] = network_evolution(sbeG, sbeNode, mode, 50, 'norandevol') 
%
% Random evolution is disabled and user is asked to select a node for targetted evolution simulation
%
%
% mode is one of the following supported evolutionary events:
%
% 
% 1 - Preferential Attachment.
% 2 - Node Duplication ( Gene Duplication (?) )
% 3 - Edge Rewiring
% 4 - Node Loss ( Gene Loss (?) )
%
% ------------------- For future versions of SBEToolbox -------------------
% 5 - Sub-functionalization ( Node Duplication and Edge Loss)
% 6 - Neo-functionalization
% -------------------------------------------------------------------------
%
% Systems Biology and Evolution Toolbox (SBEToolbox).
% Authors: Kranti Konganti, James Cai.
% (C) Texas A&M University.
%
% $LastChangedDate: 2013-06-10 14:51:59 -0500 (Mon, 10 Jun 2013) $
% $LastChangedRevision: 605 $
% $LastChangedBy: konganti $ 
%

if nargin == 6 && strcmpi(varargin{1}, 'norandevol')
    setpref('SBEToolbox', 'RandomEvolutionUserPref', 0);
end

if ~isinteger(mode) && isempty(find((mode == [1, 2, 3, 4]), 1))
    errordlg('Not a valid mode. See help network_evolution');
    return;
elseif (mode == 1)
   [~, num_gen, ~, ~] = randEvolCycle(steps, mode, e);
   if isempty(num_gen)
       evoG = g;
       evoE = e;
       msg{1} = sprintf('%s\n%s\n%s', ...
           '=============================================', ...
           'Network Evolved (?) : Selection Incomplete !', ...
           '=============================================');
       setpref('SBEToolbox', 'NetEvolMsg', -1);
       setpref('SBEToolbox', 'isRestore', 0);
       return; 
   end
   [evoG, evoE, msg] = preferential_attachment(g, e, num_gen); 
elseif (mode == 2)
    [nodeIdxs, num_gen, evoRate, evoProb] = randEvolCycle(steps, mode, e);
    if isempty(num_gen), evoG = g; evoE = e; msg = ''; return; end;
    [evoG, evoE, msg] = duplicate_node(g, e, num_gen, nodeIdxs, evoRate, evoProb);
elseif (mode == 3)
    [nodeIdxs, num_gen, evoRate, evoProb] = randEvolCycle(steps, mode, e);
    if isempty(num_gen), evoG = g; evoE = e; msg = ''; return; end;
    msg = cell(num_gen + 1, 1);
    msg{1} = sprintf('%s\n%s\n%s\n%s\t%s\t%s\t%s\t%s\n%s', ...
        '=============================================', ...
        'Network Evolved : Rewire Edge !', ...
        '=============================================', ...
        'StepNo', 'Node', 'CurrLink', 'NewLink', 'FixationProbability', ...
        '=============================================');
    evoG = g;   
    evoE = e;
    succSims = 0;
    wh = updateNetEvolWairBar(num_gen, 500, 0, 'init');
    for cycle = 1:num_gen
        [evoG, evoE, msg{cycle + 1}, succ] = rewire(evoG, evoE, nodeIdxs, ...
            evoRate, evoProb, cycle);
        if succ == 1; succSims = succSims + 1; end;
        if getpref('SBEToolbox', 'NetEvolMsg') == -1; msg = msg{cycle + 1}; break; end;
        %msg{cycle + 1} = sprintf('%d\t%s', cycle, msg{cycle + 1});
        if succSims == -99; break; end;
        wh = updateNetEvolWairBar(num_gen, 500, cycle, 'update', wh);
    end
     msg{end+1} = sprintf('\n%s\n%s\n%s', ...
        '=============================================', ...
        ['Number of Successful Simulation Steps: ', num2str(succSims)], ...
        '=============================================');
    setpref('SBEToolbox', 'NetEvolMsg', 1);
    updateNetEvolWairBar(num_gen, 500, 0, 'close', wh);
elseif (mode == 4)
    [nodeIdxs, num_gen, evoRate, evoProb] = randEvolCycle(steps, mode, e);
    if isempty(num_gen), evoG = g; evoE = e; msg = ''; return; end;
    [evoG, evoE, msg] = delete_node(g, e, num_gen, nodeIdxs, evoRate, evoProb);
% ------------------- For future versions of SBEToolbox -------------------
%elseif (mode == 5)
%    [evoG, evoE, msg] = sub_func(g, e);
%elseif (mode == 6)
%    [evoG, evoE, msg] = neo_func(g, e);
% -------------------------------------------------------------------------
end

%% ------------------------------------------------------------------------
%  Preferntial attachment.
%  ------------------------------------------------------------------------
function [G, E, m] = preferential_attachment(G, E, Cyc)
    if getpref('SBEToolbox', 'NetEvolMsg') == -1
        m{1} = sprintf('%s\n%s\n%s', ...
                '=============================================', ...
                'Network Evolved (?) : Selection Incomplete !', ...
                '=============================================');
            setpref('SBEToolbox', 'isRestore', 0);
            return;
    else
        m{1} = sprintf('%s\n%s\n%s\n%s\t%s\t%s\t%s\n%s', ...
            '=============================================', ...
            'Network Evolved : Preferential Attachment !', ...
            '=============================================', ...
            'StepNo', 'NewNode', 'AttachedTo (degree)', 'Prob (p)', ...
            '=============================================');
    end
        
    whp = updateNetEvolWairBar(Cyc, 1000, 0, 'init');
    
    for i = 1:Cyc
        degree = sum(G,2);
        prob = degree / sum(degree);
        [prob, probInd] = sort(prob, 'descend');
        suc = 0;
        while(1)
            for attachedToInd = 1:numel(probInd)
                randP = rand;
                if randP <= prob(attachedToInd)
                    G = addNewNode(G);
                    newNode = size(G, 1);
                    G(probInd(attachedToInd), newNode) = 1;
                    E{newNode} = num2str(newNode);
                    
                    m{end + 1} = sprintf('%d\t%d\t%s\t%s', i, newNode, ...
                        [E{probInd(attachedToInd)}, ' (', num2str(prob(attachedToInd) * sum(degree)), ')'], ...
                        num2str(randP));
                    suc = 1;
                    break;
                end
            end
            if suc == 1; break; end
        end
        
        whp = updateNetEvolWairBar(Cyc, 1000, i, 'update', whp);
    end
    m{end+1} = sprintf('%s', ...
        '=============================================');
    setpref('SBEToolbox', 'NetEvolMsg', 1);
    updateNetEvolWairBar(Cyc, 1000, 0, 'close', whp);
end

%% ------------------------------------------------------------------------
%  Random or targetted node duplication with replacement
%  ------------------------------------------------------------------------
function [G, E, m] = duplicate_node(G, E, Cyc, nodeIdxs, evoRate, evoProb)
    if getpref('SBEToolbox', 'RandomEvolutionUserPref') == 0
        if size(nodeIdxs, 2) == 1 && (nodeIdxs == 0 || nodeIdxs == -1) 
            m{1} = sprintf('%s\n%s\n%s', ...
                '=============================================', ...
                'Network Evolved (?) : Selection Incomplete !', ...
                '=============================================');
            setpref('SBEToolbox', 'NetEvolMsg', -1);
            setpref('SBEToolbox', 'isRestore', 0);
            return; 
        end
        netnodes = cell(numel(nodeIdxs), 1);
        for ind = 1:numel(nodeIdxs)
            netnodes{ind}= E{nodeIdxs(ind)};
        end
        idxs = nodeIdxs;
        logMsg = ' selected ';
    else
        logMsg = ' chosen randomly ';
    end
    
    m{1} = sprintf('%s\n%s\n%s', ...
        '=============================================', ...
        'Network Evolved : Node Duplicated !', ...
        '=============================================');
    
    whd = updateNetEvolWairBar(Cyc, 1000, 0, 'init');
    successSteps = 0;
    for step = 1:Cyc
        m{end + 1} = sprintf('\n%s%d\n%s', 'Step Num: ', step, ...
            '---------------------------------------------');
        
        randP = rand;
        if randP >= evoProb
            successSteps = successSteps + 1;
            if getpref('SBEToolbox', 'RandomEvolutionUserPref') == 1
                 [netnodes, idxs] = datasample(E, evoRate, 'Replace', true);
            end
            for ind = 1:numel(netnodes)
                m{end + 1} = sprintf('\n%s%d\n%s', 'Node: ', ind, ...
                    '*************');
                node = netnodes(ind);
                idx = idxs(ind);
                G(end + 1, :) = G(idx, :);
                G(:, end + 1) = G(:, idx);
                E{end + 1} = E{idx};
                neighborIdxs = find(G(idx,:));
                m{end + 1} = sprintf('%s%s%s\n\n', ['Node ', char(node), ...
                    ' has been', logMsg, ...
                    '( with fixation probability fp = ', num2str(randP)], [' ) '...
                    'and duplicated including its links to :']);
                for nodeIdx = 1:numel(neighborIdxs)
                    m{end + 1} = sprintf('%s', E{neighborIdxs(nodeIdx)});
                end
            end
        end
        whd = updateNetEvolWairBar(Cyc, 1000, step, 'update', whd);
    end
    m{end+1} = sprintf('\n%s\n%s\n%s', ...
        '=============================================', ...
        ['Number of Successful Simulation Steps: ', num2str(successSteps)], ...
        '=============================================');
    setpref('SBEToolbox', 'NetEvolMsg', 1);
    updateNetEvolWairBar(Cyc, 1000, 0, 'close', whd);
end

%% -------------------------------------------------------------------------
%  Random or targetted node loss without replacement
%  ------------------------------------------------------------------------
function [G, E, m] = delete_node(G, E, Cyc, nodeIdxs, evoRate, evoProb)
    if getpref('SBEToolbox', 'RandomEvolutionUserPref') == 0
        if size(nodeIdxs, 2) == 1 && (nodeIdxs == 0 || nodeIdxs == -1) 
            m{1} = sprintf('%s\n%s\n%s', ...
                '=============================================', ...
                'Network Evolved (?) : Selection Incomplete !', ...
                '=============================================');
            setpref('SBEToolbox', 'NetEvolMsg', -1);
            setpref('SBEToolbox', 'isRestore', 0);
            return; 
        end
        targetnetnodes = cell(numel(nodeIdxs), 1);
        for ind = 1:numel(nodeIdxs)
            targetnetnodes{ind}= E{nodeIdxs(ind)};
        end
        logMsg = ' selected ';
    else
        logMsg = ' chosen randomly ';
    end

    whl = updateNetEvolWairBar(Cyc, 1000, 0, 'init');
    %idxs = sort(idxs, 'descend');
    m{1} = sprintf('%s\n%s\n%s', ...
        '=============================================', ...
        'Network Evolved : Node Loss !', ...
        '=============================================');
    
    successSteps = 0;
    for step = 1:Cyc
        m{end + 1} = sprintf('\n%s%d\n%s', 'Step Num: ', step, ...
            '---------------------------------------------');
        randP = rand;
        if randP >= evoProb
            if size(G, 1) < 1
                m{end + 1} = sprintf('\n%s\n', 'No more nodes left for simulation !');
                netEvolMsgCode = 99;
                break;
            else
                netEvolMsgCode = -100;
            end
            
            successSteps = successSteps + 1;
            
            if getpref('SBEToolbox', 'RandomEvolutionUserPref') == 1
                [netnodes, idxs] = datasample(E, evoRate, 'Replace', false);
                G(idxs, :) = [];
                G(:, idxs) = [];
                E(idxs) = [];
            else
                [netnodes, ~] = datasample(targetnetnodes, evoRate, 'Replace', false);
            end
            
            
            for ind = 1:numel(netnodes)
                if getpref('SBEToolbox', 'RandomEvolutionUserPref') == 0
                    G(strcmpi(netnodes(ind), E), :) = [];
                    G(:, strcmpi(netnodes(ind), E)) = [];
                    E(strcmpi(netnodes(ind), E)) = [];
                end
                netnode = netnodes(ind);
                m{end + 1} = sprintf('\n%s%d\n%s', 'Node: ', ind, ...
                    '*************');
                m{end + 1} = sprintf('%s%s%s\n\n', ['Node ', char(netnode), ...
                    ' has been', logMsg, ...
                    '( with fixation probability fp = '], num2str(randP), [' ) '...
                    'and deleted including its links to :']);
            end
        end
        whl = updateNetEvolWairBar(Cyc, 1000, step, 'update', whl);
    end
    
    m{end+1} = sprintf('\n%s\n%s\n%s', ...
        '=============================================', ...
        ['Number of Successful Simulation Steps: ', num2str(successSteps)], ...
        '=============================================');
    
    if exist('netEvolMsgCode', 'var') && netEvolMsgCode == 99
        setpref('SBEToolbox', 'NetEvolMsg', 99);
    else
        setpref('SBEToolbox', 'NetEvolMsg', 1);
    end
    
    updateNetEvolWairBar(Cyc, 1000, 0, 'close', whl);
end


%% ------------------------------------------------------------------------
%  Randomly rewire an edge within all possible edges
%  ------------------------------------------------------------------------
function [G, E, m, isSimSuccess] = rewire(G, E, nodeIdxs, evoRate,...
        evoProb, cyc)
    if getpref('SBEToolbox', 'RandomEvolutionUserPref') == 0
        thisNodes = nodeIdxs;
    else
        [~, thisNodes] = datasample(E, evoRate);
        nodeIdxs = thisNodes;
    end
    
    if size(nodeIdxs, 2) == 1 && (nodeIdxs == 0 || nodeIdxs == -1) 
        m{1} = sprintf('%s\n%s\n%s', ...
            '=============================================', ...
            'Network Evolved (?) : Selection Incomplete !', ...
            '=============================================');
        setpref('SBEToolbox', 'NetEvolMsg', -1);
        setpref('SBEToolbox', 'isRestore', 0);
        isSimSuccess = -99;
        return; 
    else
    end
    
    m = '';
    
    isSimSuccess = 0;
    
    for targetNode = 1:numel(thisNodes)
        thisNode = thisNodes(targetNode);
        [~, Edges] = find(G(thisNode, :));
        ext_nNames = getCellContents(Edges, E);
        randP = rand;
        
        if randP >= evoProb
            newNode = datasample(E, 1);
            newNodeIdxFull = strcmpi(E, newNode);
            if evoRate >= numel(Edges); evoRate = numel(Edges); end;
            randomEdges = datasample(Edges, evoRate);
            
            for i = 1:numel(randomEdges)
                randomThisEdge = randomEdges(i);
                
                if ~strcmpi(E{thisNode}, E{randomThisEdge}) && ...
                        ~strcmpi(E{thisNode}, newNode) && ...
                        any((strcmp(newNode, ext_nNames)) == 0) && ...
                        full(G(thisNode, randomThisEdge)) == 1 && ...
                        full(G(thisNode, newNodeIdxFull)) ~= 1
                    
                    G(thisNode, randomThisEdge) = 0;
                    G(thisNode, newNodeIdxFull) = 1;
                    isSimSuccess = 1;
                    
                    m = [m, sprintf('%d\t%s\t%s\t%s\t%s', cyc, char(E{thisNode}), ...
                        char(E{randomThisEdge}), char(newNode)), num2str(randP)];
                    if numel(thisNodes) > 1
                        m = [m, sprintf('\n')];
                    end
                end
            end
        end
    end
    
    if isSimSuccess == 0;
        m = sprintf('%s', '');
    end
end

%% ------------------------------------------------------------------------
%  Add new node without any connections
%  ------------------------------------------------------------------------
function g = addNewNode(g)
    for i = size(g, 1) + 1
        g(size(g, 1) + 1, i) = 0;
    end
end

%% ------------------------------------------------------------------------
%  Get cell contents
%  ------------------------------------------------------------------------
 function ext_nNames = getCellContents(extlist, list)
    ext_nNames = cell(length(extlist), 1);
    for nName = 1:length(extlist)
        ext_nNames{nName} = cellstr(list{nName});
    end
 end

%% ------------------------------------------------------------------------
%  Update waitbar
%  ------------------------------------------------------------------------
function varargout = updateNetEvolWairBar(Cyc, limit, iter, status, varargin)
    if isempty(Cyc) || Cyc <= limit; varargout{1} = ''; return; end;
    if nargin == 5, waitH = varargin{1}; end;
    if strcmpi(status, 'init') && Cyc > limit
        varargout{1} = waitbar(0, 'Network Evolution, Starting...');
        return;
    end
    if strcmpi(status, 'update') && exist('waitH', 'var')
        if rem(iter, 100) == 0
            varargout{1} = waitbar(iter/Cyc, waitH, ...
                sprintf('%s%d', 'Network Evolution, Step number: ', iter));
        else
            varargout{1} = waitH;
        end
        return;
    end
    if strcmpi(status, 'close') && exist('waitH', 'var')
        waitH = waitbar(1, waitH, ...
            sprintf('%s', 'Network Evolution Complete !'));
        close(waitH);
        return;
    end
end

%% ------------------------------------------------------------------------
%  Ask how many cycles they want to randomly evolve
%  ------------------------------------------------------------------------
function [nodeIdxs, cycles, evoRate, evoProb] = randEvolCycle(cyc, mode, nodeNames)
    if cyc == 0
        setpref('SBEToolbox', 'NetEvolMsg', 1);
        if mode == 2
            askUserPhrase = 'Node Duplication Rate: ';
        elseif mode == 3
            askUserPhrase = 'Edge Rewire Rate: ';
        elseif mode == 4
            askUserPhrase = 'Node Loss Rate: ';
        elseif mode == 1
            cycles = inputdlg({'Number of Steps: '}, ...
            'Evolution Simulation', [1 50], {'1'});
            evoRate = '';
            evoProb = '';
            nodeIdxs = '';
            cycles = str2double(cycles);
            if cycles <= 0
                errordlg('Number of simulation steps cannot be less than or equal to 0.');
                nodeIdxs = 0;
                setpref('SBEToolbox', 'NetEvolMsg', -1);
                setpref('SBEToolbox', 'isRestore', 0);
                return;
            end
            return;
        end
        answer = inputdlg({askUserPhrase, ...
            'Fixation Probability: ', 'Number of Steps: '}, ...
            'Evolution Simulation', ...
            [1, 50; 1, 50; 1, 50], {'1', '0.5', '1'});
        
        if isempty(answer)
            cycles = '';
            evoRate = '';
            evoProb = '';
            nodeIdxs = 0;
            return;
        else
            cycles = str2double(answer{3});
            evoRate = str2double(answer{1});
            evoProb = str2double(answer{2});
        end
        
        if cycles <= 0
            errordlg('Number of simulation steps cannot be less than or equal to 0.');
            nodeIdxs = 0;
            setpref('SBEToolbox', 'NetEvolMsg', -1);
            setpref('SBEToolbox', 'isRestore', 0);
            return;
        end
        
        if evoProb > 1 || mod(evoRate, 1) ~= 0 || mod(cycles, 1) ~= 0 || evoRate < 1
            errordlg(['Fixation Probability cannot be more than 1. Also, ', ...
                regexprep(askUserPhrase, '\:|\s+$', ''), ...
                ' and Number of Steps must be a positive integer.'], 'Options Error');
            cycles = '';
            evoRate = '';
            evoProb = '';
            nodeIdxs = 0;
            return;
        end
    else
        cycles = cyc;
        evoRate = 1;
        evoProb = 0.5;
    end
     
     if getpref('SBEToolbox', 'RandomEvolutionUserPref') == 0 %&& mode ~= 3
         nodeIdxs = SelectionGUI(nodeNames);
     %elseif getpref('SBEToolbox', 'RandomEvolutionUserPref') == 0 && mode == 3
     %    nodeIdxs = Search(nodeNames, 'Select a node to randomly rewire its edges');
     %    if nodeIdxs == 0; nodeIdxs = -1; end;
     %    return;
     else
         nodeIdxs = 0;
     end
     
     if nodeIdxs == -1, return; end;
     
     if (numel(nodeIdxs) ~= (evoRate * cycles) ) && mode == 4 && ...
             getpref('SBEToolbox', 'RandomEvolutionUserPref') == 0
        errordlg(['Number of selected nodes ( ', ...
            num2str(numel(nodeIdxs)), ' ) must be equal to product of Node Loss Rate and ', ...
            'Number of Steps, which is ', num2str(evoRate * cycles), '.']);
        cycles = '';
        evoRate = '';
        evoProb = '';
        nodeIdxs = 0;
        return;
     end
     
     if getpref('SBEToolbox', 'RandomEvolutionUserPref') == 0 && ...
             evoRate ~= numel(nodeIdxs) && mode == 2
         errordlg([regexprep(askUserPhrase, '\:|\s+$', ''), ' ( ', ...
             num2str(evoRate), ' ) is not equal to Number of nodes selected ( ', ...
             num2str(numel(nodeIdxs)), ' ).']);
        cycles = '';
        evoRate = '';
        evoProb = '';
        nodeIdxs = 0;
        return;
     end
end

end