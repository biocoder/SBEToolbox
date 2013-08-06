function [outM, h_kcore] =kcore(sbeG)
%KCORE - calculates K-core of network
%
%k-core analysis is an iterative process in which the nodes are removed
%from the graphs in order of least connected (Wuchty and Almaas, 2005).
%More specifically, for each iteration of k, given the network from the
%previous iteration, genes with less than k connections are removed from
%the graph. This will result in a series of subgraphs that gradually reveal
%the globally central region of the original network.
%
%Wuchty, S. and Almaas, E. (2005) Peeling the yeast protein network.
%Proteomics, 5, 444?49
%
% Systems Biology and Evolution Toolbox (SBEToolbox).
% Authors: James Cai, Kranti Konganti.
% (C) Texas A&sbeG University.
%
% $LastChangedDate: 2013-02-03 21:55:03 -0600 (Sun, 03 Feb 2013) $
% $LastChangedRevision: 402 $
% $LastChangedBy: konganti $
%

%check dataset
[n, m]=size(sbeG);
if n~=m, error('Matrix sbeG is not a square matrix'); end

outM=sbeG;
%calculate kcore
degree=sum(sbeG);
c_kcore=min(degree);
pos=find(degree==c_kcore);
sbeG(pos,:)=[];
sbeG(:,pos)=[];
h_kcore=min(sum(sbeG));


function [out]=i_kcore(sbeG)
if ~issparse(sbeG)
    sbeG=double(sparse(sbeG));
end
[out]=core_numbers(sbeG);


%excessretention 
%
%Wuchty, S. and Almaas, E. (2005) Peeling the yeast protein network.
%Proteomics, 5, 444–449
%
%In order to measure the centrality of the selected set of genes, the
%excess retention (ER) of the differentially expressed genes was calculated
%for each k-core. ER is a measure of the degree to which proteins from a
%particular group are represented relative to the entire protein network.
%The detailed explanation of ER has been described elsewhere (Wuchty and
%Almaas, 2005). 
%
%see also: KCORE
%
% Systems Biology and Evolution Toolbox (SBEToolbox).
% Authors: James Cai, Kranti Konganti.
% (C) Texas A&M University.
%
% $LastChangedDate: 2013-02-03 21:55:03 -0600 (Sun, 03 Feb 2013) $
% $LastChangedRevision: 402 $
% $LastChangedBy: konganti $


