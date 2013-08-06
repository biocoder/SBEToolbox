function [equation, H] = powerlawplot(Net)
% Power-Law Degree Distribution Graphing
% Finds out how many connections each node has
%
% Systems Biology and Evolution Toolbox (SBEToolbox).
% Authors: James Cai, Kranti Konganti.
% (C) Texas A&M University.
%
% $LastChangedDate: 2012-12-28 19:01:43 -0600 (Fri, 28 Dec 2012) $
% $LastChangedRevision: 278 $
% $LastChangedBy: konganti $
%

connections = single(sum(Net));

% Initialize variable that will hold how many nodes have each degree
frequency = single(zeros(1,length(Net)));

% Initialize variable that will hold the graphing quanitites
plotvariables = zeros(2,length(Net));
P = [];

for T = 1:length(Net)
    % Variable will be used as a list of possible degrees a node can have
    P(1,T) = T;
    if connections(1,T) ~= 0
        frequency(1,connections(1,T)) = frequency(1,connections(1,T)) + 1;
    end
end

for c = 1:length(frequency)
    % Disregard degrees with no frequency
    if frequency(1,c) ~= 0
       [~,Y] = find(plotvariables == 0);
       plotvariables(1,min(Y)) = P(1,c);
       plotvariables(2,min(Y)) = frequency(1,c);
    end
end

% Find the last non-zero element in plotvariables
for d = 1:length(plotvariables)
    if plotvariables(1,d) == 0 && plotvariables(2,d) == 0
        break
    end
end

x = plotvariables(1,1:d-1);
y = plotvariables(2,1:d-1);
[g,~,b] = fit(x',y','power1');
H=loglog(x,y,'ko','MarkerSize',10,'MarkerFaceColor','k');
hold on;
H2=plot(g);
set(H2,'LineWidth',2);
xlim([.9 (max(sum(Net)) + 10)]);
ylim([.9 length(Net)]);
legend off;
xlabel('Degree');
ylabel('Number of nodes');
%grid on
set(gca,'YGrid','on')
% Use this feature to extract variables from cfit variables
%a = g.a;
%b = g.b;
%rsquare = f.rsquare;
equation = g;
