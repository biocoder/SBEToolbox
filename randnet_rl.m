function [sbeG, sbeNode] = randnet_rl(nodes, degree, definedProb)
%%RANDNET_RL Create random ring lattice graph with adjustable ß probability.
%
% [sbeG, sbeNode] = randnet_rl(nodes, degree, definedProb)
%
%  nodes: specified numeber of nodes
%  degree: degree
%  definedProb: defined probability
%  sbeG: a sparse adjacency matrix that holds the network information
%  sbeNode: a cell string vector that holds the node information%
%
% This function implements the Watts and Strogatz algorithm to create
%    random ring lattice network with specified number of nodes, degree and
%    defined probability.
%
% Ref: Watts DJ, Strogatz SH. Collective dynamics of 'small-world' networks. 
%      Nature. 1998 Jun 4;393(6684):440-2. PubMed PMID: 9623998.
%
% See also: randnet_sw, randnet_er.
%
% Systems Biology and Evolution Toolbox (SBEToolbox).
% Authors: Kranti Konganti, James Cai.
% (C) Texas A&M University.
%
% $LastChangedDate: 2013-06-23 10:35:39 -0500 (Sun, 23 Jun 2013) $
% $LastChangedRevision: 717 $
% $LastChangedBy: yangence $ 
%

sbeG = zeros(nodes);
sbeNode = cell(nodes,1);

%% Return Node list as string

for nodeIdxs = 1:nodes
    sbeNode{nodeIdxs} = num2str(nodeIdxs);
end

%% For each node make degree / 2 connections to the left and right of node

nodeIdx = 1:nodes;
leftEdgeConnections = degree / 2;
rightEdgeConnections = degree - leftEdgeConnections;

if nodes > 10000
    waitforNetworkCreationandRewiring = waitbar(0,...
        'Creating Ring Lattice Network...');
else
    waitforNetworkCreationandRewiring = 0;
end

for thisNode = 1:nodes
    for eachLeftEdgeConnection = 1:leftEdgeConnections
        leftofthisNodeIdx = thisNode - eachLeftEdgeConnection;
        
        if leftofthisNodeIdx <= 0
            %fprintf('thisNode\t%d\tedge<=0\t%d\n', thisNode, nodeIdx(end + leftofthisNodeIdx));
            sbeG(thisNode, nodeIdx(end + leftofthisNodeIdx)) = 1;
            %sbeG(nodeIdx(end - leftofthisNodeIdx), thisNode) = 1;
        else
            %fprintf('thisNode\t%d\tedge\t%d\n', thisNode, leftofthisNodeIdx);
            sbeG(thisNode, leftofthisNodeIdx) = 1;
            %sbeG(leftofthisNodeIdx, thisNode) = 1;
        end
    end
    
    for eachRightEdgeConnection = 1:rightEdgeConnections
        rightofthisNodeIdx = thisNode + eachRightEdgeConnection;
        
        if (rightofthisNodeIdx > nodes)
            sbeG(thisNode, (rightofthisNodeIdx - nodes)) = 1;
            %sbeG((rightofthisNodeIdx - nodes), thisNode) = 1;
        else
            sbeG(thisNode, rightofthisNodeIdx) = 1;
            %sbeG(rightofthisNodeIdx, thisNode) = 1;
        end
    end
    
    if waitforNetworkCreationandRewiring
       waitbar(thisNode/nodes, waitforNetworkCreationandRewiring);
    end
end

clear nodeIdx;
if ~issparse(sbeG)
    sbeG = sparse(sbeG);
end


%% Randomly rewire a proportion (ß) of edges in the graph

for thisNode = 1:nodes
    [~, Edges] = find(sbeG(thisNode, :));
    
    for thisEdge = 1:Edges
        while (1)
            if (rand < definedProb)
                newEdgeConnection = randi(nodes);
                if newEdgeConnection ~= thisNode && ...
                        any(newEdgeConnection == Edges) == 0
                    sbeG(thisNode, newEdgeConnection) = 1;
                    sbeG(thisNode, thisEdge) = 0;
                    break;
                end
                
                if waitforNetworkCreationandRewiring
                    waitbar(thisNode/nodes, ...
                        waitforNetworkCreationandRewiring, ...
                        'Rewiring Edges...');
                end
            else
                break;
            end
        end
    end
end

if waitforNetworkCreationandRewiring
    close(waitforNetworkCreationandRewiring)
end
