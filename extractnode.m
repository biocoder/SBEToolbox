function [sbeG,sbeNode,idx]=extractnode(sbeG,sbeNode,nodeid,dcutoff,D)
% extractnode(nodeid,sbeG,distcutoff,D)
%
% Systems Biology and Evolution Toolbox (SBEToolbox).
% Authors: James Cai, Kranti Konganti.
% (C) Texas A&M University.
%
% $LastChangedDate: 2012-12-28 19:01:43 -0600 (Fri, 28 Dec 2012) $
% $LastChangedRevision: 278 $
% $LastChangedBy: konganti $
%

if ~issparse(sbeG), sbeG=sparse(sbeG); end
if nargin<5
    %[D]=all_shortest_paths(double(sparse(sbeG)));
    %D=shortest_paths(double(sparse(sbeG)),nodeid);
    D=shortest_paths(double(sbeG),nodeid);
end
if nargin<4, dcutoff=1; end

    idx=D>dcutoff;
    sbeG(:,idx)=[];
    sbeG(idx,:)=[];
    sbeG=full(sbeG);
    sbeNode=sbeNode(~idx);
    idx=~idx;
end










