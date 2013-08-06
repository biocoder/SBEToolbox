function q = modularity_n06(G,s)
%MODULARITY_N06 - modularity of the graph for given partitioning vector
%
%   q = modularity_n06 (g, s) modularity of the graph g for given partitioning
%   vector s. 
%
%         1
%   q = ----- s' * B * s
%        4*m
%
% B: modularity matrix.
% s: partitioning vector, s_i = 1 if vertex i belongs to group 1 and s_i =
% -1 if vertex i belong to group 2.
% m: the total number of edges.
%
% Example:
%  n = size(g,1);
%  s = (rand(1,n) > rand)*2-1; % generate random partitioning
%  q = modularity(g, s);
%
% Ref: Newman M. E. Proc Natl Acad Sci U S A 2006 
%
% See also MODULARITY2, MODMAT.

% Modularity and community structure in networks
% M. E. J. Newman*
% http://www.pnas.org/content/103/23/8577.full.pdf+html



if nargin<2,
    n=size(G,1);
    s = (rand(1,n) > rand)*2-1;
end

deg = sum(G);
m = sum(deg)/2;
s = s(:);

q = s' * modmat(G) * s / (4*m);
