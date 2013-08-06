function [g, msg] = mcl(g, e, r, n, a, iter)
%MCL Apply Markov Clustering Algorithm to the current network.
% 
% sbeG = mcl(g, e, r, n, a, iter)
%
% This function implements Markov Clustering Algorithm to deduce 
% appropriate number of non-overlapping clusters.
% 
% g    - Current network
%        ===============
%        The current loaded network.
%
%
% e    - Expansion coefficient (power)
%        =============================
%        The positive power coefficient to which the matrix must be raised 
%        before the inflation step (higher power gives fewer clusters, runs
%        slower for large-scale networks).
%        Default: 2
%
% r    - Inflation coefficient
%        =============================
%        The positive value to which each matrix column must be raised to 
%        make the matrix, column stochastic.
%        Default: 2
%
% n    - Minimum value for matrix pruning
%        ================================
%        Minimum value for pruning. All elements less than this value
%        will be made 0.
%        Default: 0.001
%
% a    - Allow each node to connect to itself
%        ====================================
%        Before iteration, allow self edge connection for each node
%        within the network (Enabling self connections for larger networks
%        improves the speed of the algorithm). 
%        Default: True
%
% iter - Number of iterations the algorithm should run 
%        =============================================
%        The algorithm runs for this many number of iterations and quits.
%        It will also quit if it is able to deduce clusters before approching 
%        it's limits.
%        Default: 20
%
% Example : mcl(g, 0, 0, 0, 0, 50) => run mcl with default values on graph g
%                                     for 50 iterations.
%         : mcl(g, 0, 1.8, 0, 0, 50) => run mcl with default values on
%                                       graph g with inflation of 1.8 for
%                                       50 iterations.
%
% Ref: Stijn van Dongen. A cluster algorithm for graphs. 
%      Technical Report INS-R0010, 
%      National Research Institute for Mathematics and Computer Science in 
%      the Netherlands, Amsterdam, May 2000.
% 
% See also: mcode, clusteronerun
%
% Systems Biology and Evolution Toolbox (SBEToolbox).
% Authors: Kranti Konganti, James Cai.
% (C) Texas A&M University.
%
% $LastChangedDate: 2013-05-14 17:18:54 -0500 (Tue, 14 May 2013) $
% $LastChangedRevision: 539 $
% $LastChangedBy: konganti $
%

%% Iterate until user specified maximum iterations
waitforMCLapplication = waitbar(0, 'Applying MCL Algorithm: Iteration: 0');

if ~ispref('SBEToolbox', 'MCLBreakVal')
    addpref('SBEToolbox', 'MCLBreakVal', -1);
end

setpref('SBEToolbox', 'MCLBreakVal', -1);

%% Define defaults
if isempty(e) || e == 0
    e = 2;
end
if isempty(r) || r == 0
    r = 2;
end
if isempty(n) || n == 0
    n = 0.001;
end
if isempty(a) || a == 0
    a = 'true';
end
if isempty(iter) || iter == 0
    iter = 20;
end

%% MCL Core

% Self loop each node
if (strcmp(a, 'true'))
    g(logical(eye(size(g, 1)))) = 1;
end

i = 0;
breakCounter = 0;
while i < iter
    % Sparse the matrix
    g = sparse(g);
    
    % Normalize matrix (column wise)
    g = bsxfun(@rdivide, g, sum(g));
    %g = bsxfun(@rdivide, g, sum(g, 2)); <-- row wise % ^ e;
    
    % Apply MCL
    g = runMCL(g, e, r);
        
    % Do pruning for min value of NaNs
    g(g < n) = 0; 
    
    % Do pruning for NaNs
    %g(isnan(g)) = 0;
    
    % Get MCL break value
    if isequal(size(unique(g, 'rows'), 1), ...
            getpref('SBEToolbox', 'MCLBreakVal'))
        breakCounter = breakCounter + 1;
        if breakCounter >= 5,  break, end;
    end
    
    % Set MCL break value
    if (i >= 1)
        setpref('SBEToolbox', 'MCLBreakVal', size(unique(g, 'rows'), 1));
    end
    
    waitbar(i/iter, waitforMCLapplication, sprintf('%s%d',...
        'Applying MCL Algorithm: Iteration: ', i));
    
    i = i + 1;
end
    
%% Return success or failure of cluster deduction
if length(find(g == 0)) == numel(g)
    msg = 0;
    closeWaitBar(waitforMCLapplication);
    return;
else
    msg = 1;
    closeWaitBar(waitforMCLapplication);
    return;
end

end

%% Run MCL Algorithm
function g = runMCL(g, e, r)
    % Apply Expansion by factor
    g = mpower(g, e);
    
    % Inflation by factor r
    g = power(g, r);
    
    % Re-normalize matrix (column wise)
    g = bsxfun(@rdivide, g, sum(g));
end

%% Close wait bar
function closeWaitBar(waitforMCLapplication)
    waitbar(1, waitforMCLapplication);
    close(waitforMCLapplication);
end
