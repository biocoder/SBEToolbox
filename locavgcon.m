function [v,vnorm]=locavgcon(sbeG)
%LOCAVGCON - Local Average Connectivity
%
% Systems Biology and Evolution Toolbox (SBEToolbox).
% Authors: James Cai, Kranti Konganti.
% (C) Texas A&M University.
%
% $LastChangedDate: 2012-12-28 19:01:43 -0600 (Fri, 28 Dec 2012) $
% $LastChangedRevision: 278 $
% $LastChangedBy: konganti $
%

[m]=size(sbeG,1);

d=sum(sbeG);
v=zeros(m,1);
for k=1:m
    i=sbeG(:,k);
    try
        v(k)=0.5*sum(sum(sbeG(i,i)))/d(k);
    catch exception
        errordlg(exception.message);
        return;
    end
end
if nargout>1
    vnorm=v-min(v)./(max(v)-min(v));
end

