function [xy]=circle_layout(G,idx)
%CIRCLE_LAYOUT - circle layout.
%
% [xy]=circle_layout(G)
% [xy]=circle_layout(G,idx) to put the IDX-th node in the center
%
% Systems Biology and Evolution Toolbox (SBEToolbox).
% Authors: James Cai, Kranti Konganti.
% (C) Texas A&M University.
%
% $LastChangedDate: 2012-12-28 19:01:43 -0600 (Fri, 28 Dec 2012) $
% $LastChangedRevision: 278 $
% $LastChangedBy: konganti $
%

%format compact
%format long e
if nargin<2
    idx=[];
end
if ~isempty(idx)
    G(idx,:)=[];
    G(:,idx)=[];
end
theta = linspace(0,2*pi,length(G)+1);
xy = zeros(length(G)+1,2);
x = cos(theta);
y = sin(theta);
xy(1:length(G)+1,1) = x(1:length(G)+1);
xy(1:length(G)+1,2) = y(1:length(G)+1);

%figure, gplot(G,xy,'.-');
%set(gcf, 'Color', [1 1 1]);
%axis('equal');
%xlim([-1.1 1.1]);
%ylim([-1.1 1.1]);
%axis off;
xy(end,:)=[];
if ~isempty(idx)
    xy=[xy(1:idx-1,:);[0 0];xy(idx:end,:)];
end