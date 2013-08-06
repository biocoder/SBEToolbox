function [sbeG,sbeNode]=randnet_sw(n,p)
%RANDNET_SW Generate Small-World random network
% [sbeG,sbeNode]=randnet_sw(n,p) generates a random Small-World network
%    with n nodes, each with probability p.
%
%  n: numeber of nodes
%  p: probability
%  sbeG: a sparse adjacency matrix that holds the network information
%  sbeNode: a cell string vector that holds the node information
%
% See also: randnet_rl, randnet_er
%
% Systems Biology and Evolution Toolbox (SBEToolbox).
% Authors: Kranti Konganti, James Cai.
% (C) Texas A&M University.
%
% $LastChangedDate: 2013-06-23 10:35:39 -0500 (Sun, 23 Jun 2013) $
% $LastChangedRevision: 717 $
% $LastChangedBy: yangence $ 
%

seed =[0 1 0 0 1;1 0 0 1 0;0 0 0 1 0;0 1 1 0 0;1 0 0 0 0];
sbeG=logical(i_SFNG(n, p, seed));
%sbeG = sparse(sbeG);

if nargout>1
    % Kranti Konganti
    % strread has been replaced by textscan in new version of matlab
    sbeNode = textscan(num2str(1:size(sbeG,1)),'%s');
    
    % textscan returns 1x1 cell array when a string line is passed
    % so, get actual cell array containing node information. i.e get
    % cell array within sbeNode.
    sbeNode = sbeNode{1};
end

if ~issparse(sbeG)
    sbeG = sparse(sbeG);
end

function [G] = i_SFNG(Nodes, mlinks, seed)

seed = full(seed);
pos = length(seed);

%if (Nodes < pos) || (mlinks > pos) || (pos < 1) || (size(size(seed)) ~= 2) || (mlinks < 1) || (seed ~= seed') || (sum(diag(seed)) ~= 0)
%    error('invalid parameter value(s)');
%end

%if mlinks > 5 || Nodes > 15000 || pos > 15000
%    warning('Abnormally large value(s) may cause long processing time');
%end

RandStream.setGlobalStream(RandStream('mt19937ar','seed',sum(100*clock)));
%rand('state',sum(100*clock));

Net = zeros(Nodes, Nodes, 'single');
Net(1:pos,1:pos) = seed;
sumlinks = sum(sum(Net));
% Adding waitbar
if (Nodes > 1000)
    wb = waitbar(0, 'Creating Small World random network...');
else
    wb = 0;
end
while pos < Nodes
    pos = pos + 1;
    linkage = 0;
    while linkage ~= mlinks
        rnode = ceil(rand * pos);
        deg = sum(Net(:,rnode)) * 2;
        rlink = rand * 1;
        if rlink < deg / sumlinks && Net(pos,rnode) ~= 1 && Net(rnode,pos) ~= 1
            Net(pos,rnode) = 1;
            Net(rnode,pos) = 1;
            linkage = linkage + 1;
            sumlinks = sumlinks + 2;
        end
    end
    if (wb)
        waitbar(pos/Nodes, wb);
    end
end
if (wb)
    close(wb);
end
clear Nodes deg linkage pos rlink rnode sumlinks mlinks
G = Net;