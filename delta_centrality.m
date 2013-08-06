function [C]=delta_centrality(G,fhandle,showwaitbar)
%DELTA_CENTRALITY delta centrality of nodes
%
% [C] = delta_centrality(G,fhandle,showwaitbar) 
%
% G           - the input graph adjacency matrix
% fhandle     - current figure handle
% showwaitbar - show function progress for large networks
% C           - delta centrality of nodes
%
% Delta centrality measures the importance of a node related to the ability
% of the network to respond to the deactivation of the node from the network.
%
% Also known as: closeness_centrality
%
% Systems Biology and Evolution Toolbox (SBEToolbox).
% Authors: Kranti Konganti, James Cai.
% (C) Texas A&M University.
%
% $LastChangedDate: 2013-06-23 10:35:39 -0500 (Sun, 23 Jun 2013) $
% $LastChangedRevision: 717 $
% $LastChangedBy: yangence $ 
%

if nargin<3
    showwaitbar=false;
end
if nargin<2
    fhandle=@graph_efficiency;
end
if issparse(G)
    G=double(sparse(G));
end
if ischar(fhandle), fhandle=str2func(fhandle); end
if ~isa(fhandle,'function_handle')
    error('Requires function handle');
end

n=num_vertices(G);
[xe0]=fhandle(G);
C=zeros(n,1);

if showwaitbar
     h = waitbar(0,'Please wait...');
else
     h = 0;
end
for k=1:n
    G2=G;
    G2(:,k)=0;
    G2(k,:)=0;
    xek=fhandle(G2);
    C(k)=(xe0-xek)/xe0;
    if h && rem(k, 100) == 0, waitbar(k/n,h); end
end
if h, close(h); end



