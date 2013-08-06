function [sbeG,sbeNode]=randnet_er(n,p)
%RANDNET_ER Generates a random Erdös-Réyni (Gnp) graph
%
% [sbeG,sbeNode]=randnet_er(n,p) generates a random Gnp graph with n 
%    vertices and where the probability of each edge is p. The resulting
%    graph is symmetric.
%  sbeG: a sparse adjacency matrix that holds the network information
%  sbeNode: a cell string vector that holds the node information
%
% This function is different from the Boost Graph library version, it was
%    reimplemented natively in Matlab.
%
% Example:
%   A = randnet_erdosreyni(100,0.05);
%
% See Also: randnet_rl, randnet_sw
%
% Systems Biology and Evolution Toolbox (SBEToolbox).
% Authors: Kranti Konganti, James Cai.
% (C) Texas A&M University.
%
% $LastChangedDate: 2013-06-23 10:35:39 -0500 (Sun, 23 Jun 2013) $
% $LastChangedRevision: 717 $
% $LastChangedBy: yangence $ 
%

%%
sbeG=triu(rand(n)<p,1);
%A = sparse(A);
sbeG=sbeG|sbeG';

% Kranti Konganti
% strread has been replaced by textscan in new version of matlab
sbeNode = textscan(num2str(1:size(sbeG,1)),'%s');

 % textscan return 1x1 cell array when a string line is passed
 % so, get actual cell array containing node information. i.e get
 % cell array within sbeNode.
sbeNode = sbeNode{1};

if ~issparse(sbeG)
    sbeG = sparse(sbeG);
end

%for k=1:n, sbeNode{k}=sprintf('Node%d',k); end
%if nargin<1 n=10; end
%a=rand(n)>=0.8;
%G=triu(a,1)+triu(a,1)';