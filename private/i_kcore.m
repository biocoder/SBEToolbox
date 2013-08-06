function [outM, h_kcore] =i_kcore( M )
% SEE ALSO: excessretention
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

%check dataset
[n, m]=size(M);
if n~=m, error('Matrix M is not a square matrix'); end

outM=M;
%calculate kcore
degree=sum(M);
c_kcore=min(degree);
pos=find(degree==c_kcore);
M(pos,:)=[];
M(:,pos)=[];
t_kcore=min(sum(M));

%outputs
if c_kcore==0&&t_kcore==0
    h_kcore=1;
    return
end

if t_kcore<c_kcore
    h_kcore=c_kcore+1;
    return
end

[outM, h_kcore]=i_kcore(M);

end





