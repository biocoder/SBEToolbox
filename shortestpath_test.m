%
% Systems Biology and Evolution Toolbox (SBEToolbox).
% Authors: James Cai, Kranti Konganti.
% (C) Texas A&M University.
%
% $LastChangedDate: 2012-12-28 21:28:10 -0600 (Fri, 28 Dec 2012) $
% $LastChangedRevision: 279 $
% $LastChangedBy: jcai $
%

 noOfNodes  = 50;
 rand('state', 0);
 figure(1);
 clf;
 hold on;
 L = 1000;
 R = 200; % maximum range;
 netXloc = rand(1,noOfNodes)*L;
 netYloc = rand(1,noOfNodes)*L;
 for i = 1:noOfNodes
     plot(netXloc(i), netYloc(i), '.');
     text(netXloc(i), netYloc(i), num2str(i),'fontsize',15);
     for j = 1:noOfNodes
         distance = sqrt((netXloc(i) - netXloc(j))^2 + (netYloc(i) - netYloc(j))^2);
         if distance <= R
             G(i, j) = 1;   % there is a link;
             line([netXloc(i) netXloc(j)],...
                 [netYloc(i) netYloc(j)],...
                 'LineStyle', '-','linesmooth','on');
         else
             G(i, j) = inf;
         end;
     end;
 end;
 
 
 [pathx,totalCost,distance] = shortestpath(G, 1, 15);
 pathx
 totalCost
 if length(pathx) ~= 0
     for i = 1:(length(pathx)-1)
         line([netXloc(pathx(i)) netXloc(pathx(i+1))],...
              [netYloc(pathx(i)) netYloc(pathx(i+1))],...
              'Color','r','LineWidth', 5,...
              'LineStyle', ':','linesmooth','on');
     end;
 end;
 hold off;
 
 
 d=shortest_paths(sparse(double(G==1)),1)'
 distance==d
 
 
 
