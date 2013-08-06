function [G]=moduleid2net(moduleid,sbeG)
%MODULEID2NET - converts network sbeG and module id to deduced network.
%
% [moduleid]=mcode(sbeG);
% [G]=moduleid2net(moduleid,sbeG);
%
% Systems Biology and Evolution Toolbox (SBEToolbox).
% Authors: James Cai, Kranti Konganti.
% (C) Texas A&M University.
%
% $LastChangedDate: 2013-06-17 15:04:35 -0500 (Mon, 17 Jun 2013) $
% $LastChangedRevision: 673 $
% $LastChangedBy: konganti $

if ~islogical(sbeG)
    sbeG=logical(sbeG);
end

G=false(size(sbeG));
m=max(moduleid(:));

for k=1:m
    ix=find(moduleid==k);
    for ki=1:length(ix)-1
        for kj=ki:length(ix)
            G(ix(ki),ix(kj))=true;
            G(ix(kj),ix(ki))=true;
        end
    end
end
%G=G&sbeG;
