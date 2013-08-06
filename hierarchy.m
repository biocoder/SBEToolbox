function h = hierarchy(sbeG)
%HIERARCHY - Degree of hierarchy
%
%   h = hierarchy(sbeG) find degree of hierarchy, which measure normalized
%   coorlation between vertex degree of adjacent nodes
%
% Graph is assumed as undirected.
%
% Systems Biology and Evolution Toolbox (SBEToolbox).
% Authors: James Cai, Kranti Konganti.
% (C) Texas A&M University.
%
% $LastChangedDate: 2012-12-28 19:01:43 -0600 (Fri, 28 Dec 2012) $
% $LastChangedRevision: 278 $
% $LastChangedBy: konganti $
%

if directed(sbeG)
    error('Graph must be undirected.');
end
B = modmat(sbeG);
deg = degree(sbeG);
m = sum(deg)/2; % number of edges
% n = size(sbeG,1);
% x = deg' - 2*m/n; % normalize
x = sqrt(length(deg)) * deg' / sqrt(deg * deg');
% x = deg' / sqrt(deg * deg');
h = x' * B * x / (2*m);

% adj = adjacency(sbeG);
% deg = degree(sbeG);
% m = sum(deg);
% t1 = deg * adj * deg';
% t2 = sum(deg * adj);
% h = t1 / m - (t2 / m)^2;
% h = full(h); % just convert to full matrix, though h is scaler

