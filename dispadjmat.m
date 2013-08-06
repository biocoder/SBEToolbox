function dispadjmat(sbeG)
%
% Systems Biology and Evolution Toolbox (SBEToolbox).
% Authors: James Cai, Kranti Konganti.
% (C) Texas A&M University.
%
% $LastChangedDate: 2012-12-28 19:01:43 -0600 (Fri, 28 Dec 2012) $
% $LastChangedRevision: 278 $
% $LastChangedBy: konganti $
%

n=size(sbeG,1);
%for k=1:n
%    fprintf('%d',sbeG(k,:));
%    fprintf('\n');
%end
imagesc(sbeG)
axis square
colormap copper
