function [pathv,totalCost,distance]=shortestpath(sbeG,x1,x2)
%
%
% pathv: the list of nodes in the pathx from source to destination;
% totalCost: the total cost of the pathx;
% farthestNode: the farthest node to reach for each node after performing
% the routing;
% x1: source node index;
% x2: destination node index;
%
% Systems Biology and Evolution Toolbox (SBEToolbox).
% Authors: James Cai, Kranti Konganti.
% (C) Texas A&M University.
%
% $LastChangedDate: 2012-12-28 21:28:10 -0600 (Fri, 28 Dec 2012) $
% $LastChangedRevision: 279 $
% $LastChangedBy: jcai $
%

n=size(sbeG,1);
farthestPreviousHop=1:n;
farthestNextHop=1:n; 

if islogical(sbeG)
    sbeG=single(sbeG);
end
    sbeG(sbeG==0)=inf;


visited=false(1,n);
distance=inf(1,n);    % it stores the shortest distance between each node and the source node;
parent=zeros(1,n);


distance(x1) = 0;
for i = 1:(n-1)
    temp = [];
    for h = 1:n
         if ~visited(h)   % in the tree;
             temp=[temp distance(h)];
         else
             temp=[temp inf];
         end
     end;
     [~, u] = min(temp);   % it starts from node with the shortest distance to the source;
     visited(u) = true;       % mark it as visited;
     for v = 1:n           % for each neighbors of node u;
         if (sbeG(u, v) + distance(u)) < distance(v)
             distance(v) = distance(u) + sbeG(u, v);   % update the shortest distance when a shorter pathv is found;
             parent(v) = u;                            % update its parent;
         end;             
     end;
end;

pathv = [];
if parent(x2) ~= 0   % if there is a pathv!
    t = x2;
    pathv = x2;
    while t ~= x1
        p = parent(t);
        pathv = [p pathv];
        
        if sbeG(t, farthestPreviousHop(t)) < sbeG(t, p)
            farthestPreviousHop(t) = p;
        end;
        if sbeG(p, farthestNextHop(p)) < sbeG(p, t)
            farthestNextHop(p) = t;
        end;

        t = p;      
    end
end
totalCost = distance(x2);
