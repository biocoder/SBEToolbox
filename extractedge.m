function [sbeG,idx]=extractedge(node1,node2,sbeG,distcutoff)
% [sbeG,idx]=extractedge(node1,node2,sbeG,distcutoff)
%
% Systems Biology and Evolution Toolbox (SBEToolbox).
% Authors: James Cai, Kranti Konganti.
% (C) Texas A&M University.
%
% $LastChangedDate: 2012-12-28 19:01:43 -0600 (Fri, 28 Dec 2012) $
% $LastChangedRevision: 278 $
% $LastChangedBy: konganti $
%

    %[D]=all_shortest_paths(double(sparse(sbeG)));
    D1=shortest_paths(double(sparse(sbeG)),node1);
    D2=shortest_paths(double(sparse(sbeG)),node2);

if nargin<4, distcutoff=1; end
idx1=(D1<=distcutoff);
idx2=(D2<=distcutoff);
idx=idx1|idx2;
sbeG(:,~idx)=[];
sbeG(~idx,:)=[];










