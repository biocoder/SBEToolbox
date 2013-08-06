function q = modularity_ws05(G, s)
%MODULARITY_WS05 - modularity measure (alternative)
%
%   q = modularity_ws05(G) returns modularity measure of graph G. Use set(G, 'group', ...)
%       to set group id. q is defined as:
%
%   q = sum of (A(vc,vc)/A(v,v) - (A(vc,v)/A(v,v))^2)
%       v is verties and vc is verties in group c. A(vc, v) represent edges
%       weight between vc and v, 0 if they are not link.
%
%   q = modularity_ws05(G, s) returns modularity measure of graph G grouped according to 
%       grouping vector s corresponding to each node. 
%
%   Example:
%   q = modularity_ws05(G)
%   q = modularity_ws05(G, [1 1 2 1 3 3]);
%
%   See also MODULARITY, SET.

% Ref: Scott Whitey and Padhraic Smyth 2005
% Adopted from: @graph modularity2.m by Kyaw Tun

% White S., Smyth P. (2005) in Proceedings of the 5th SIAM International
% Conference on Data Mining, eds Kargupta H., Srivastava J., Kamath C.,
% Goodman A. (Society for Industrial and Applied Mathematics,
% Philadelphia), pp 274–285.


Avv = sum(sum(G));

if nargin < 2
    n=size(G,1);
    s = (rand(1,n) > rand)*2-1;
end

q = 0;
for k = min(s):max(s)
    c = find(s==k);
    if isempty(c), continue; end
    Avcvc = sum(sum(G(c,c)));
    Avcv = sum(sum(G(c,:)));    
    q = q + Avcvc/Avv - (Avcv/Avv)^2;
end
