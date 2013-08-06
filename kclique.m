function [components,outclique,CC] = kclique(k,M)
%KCLIQUE - algorithm as defined in the paper
% "Uncovering the overlapping community structure of complex networks in
% nature and society"
%
% Example in the paper
% M = [1 1 0 0 0 0 0 0 0 1;
%     1 1 1 1 1 1 1 0 0 1;
%     0 1 1 1 0 0 1 0 0 0;
%     0 1 1 1 1 1 1 0 0 0;
%     0 1 0 1 1 1 1 1 0 0;
%     0 1 0 1 1 1 1 1 0 0;
%     0 1 1 1 1 1 1 1 1 1;
%     0 0 0 0 1 1 1 1 1 1;
%     0 0 0 0 0 0 1 1 1 1;
%     1 1 0 0 0 0 1 1 1 1];
%
% Systems Biology and Evolution Toolbox (SBEToolbox).
% Authors: James Cai, Kranti Konganti.
% (C) Texas A&M University.
%
% $LastChangedDate: 2012-12-28 19:01:43 -0600 (Fri, 28 Dec 2012) $
% $LastChangedRevision: 278 $
% $LastChangedBy: konganti $
%

nb_nodes = size(M,1);

% Find the largest possible clique size
degree_sequence = sort(sum(M,2) - 1,'descend');
max_s = 0;
for i = 1:length(degree_sequence)
    if degree_sequence(i) >= i - 1
        max_s = i;
    else 
        break;
    end
end

outclique = cell(0);
% Find all s-size kliques in the graph
for s = max_s:-1:3
    M_aux = M;
    % Loop over nodes
    for n = 1:nb_nodes
        A = n; % Set of nodes all linked to each other
        B = setdiff(find(M_aux(n,:)==1),n); % Set of nodes that are linked to each node in A
        C = transfer_nodes(A,B,s,M_aux);
        if ~isempty(C)
            for i = size(C,1)
                outclique = [outclique;{C(i,:)}];
            end
        end
        M_aux(n,:) = 0;
        M_aux(:,n) = 0;
    end
end

% Make the clique-clique overlap matrix
CC = zeros(length(outclique));
for c1 = 1:length(outclique)
    for c2 = c1:length(outclique)
        if c1==c2
            CC(c1,c2) = numel(outclique{c1});
        else
            CC(c1,c2) = numel(intersect(outclique{c1},outclique{c2}));
            CC(c2,c1) = CC(c1,c2);
        end
    end
end

% Making k-clique matrix
% Off-diagonal elements <= k-1 --> 0
% Diagonal elements <= k --> 0
CC(eye(size(CC))==1) = CC(eye(size(CC))==1) - k;
CC(eye(size(CC))~=1) = CC(eye(size(CC))~=1) - k + 1;
CC(CC >= 0) = 1;
CC(CC < 0) = 0;

% Component analysis on k-clique matrix
components = [];
for i = 1:length(outclique)
    linked_cliques = find(CC(i,:)==1);
    new_component = [];
    for j = 1:length(linked_cliques)
        new_component = union(new_component,outclique{linked_cliques(j)});
    end
    found = false;
    if ~isempty(new_component)
        for j = 1:length(components)
            if all(ismember(new_component,components{j}))
                found = true;
            end
        end
        if ~found
            components = [components; {new_component}];
        end
    end
end


    function R = transfer_nodes(S1,S2,clique_size,C)
        % Check if the union of S1 and S2 or S1 is inside an already found larger
        % clique 
        found_s12 = false;
        found_s1 = false;
        for c = 1:length(outclique)
            for cc = 1:size(outclique{c},1)
                if all(ismember(S1,outclique{c}(cc,:)))
                    found_s1 = true;
                end
                if all(ismember(union(S1,S2),outclique{c}(cc,:)))
                    found_s12 = true;
                    break;
                end
            end
        end
        
        if found_s12 || (length(S1) ~= clique_size && isempty(S2))
            R = [];
        elseif length(S1) == clique_size;
            if found_s1
                R = [];
            else
                R = S1;
            end
        else
            if isempty(find(S2>=max(S1),1))
                R = [];
            else
                R = [];
                for w = find(S2>=max(S1),1):length(S2)
                    S2_aux = S2;
                    S1_aux = S1;
                    S1_aux = [S1_aux S2_aux(w)];
                    S2_aux = setdiff(S2_aux(C(S2(w),S2_aux)==1),S2_aux(w));
                    R = [R;transfer_nodes(S1_aux,S2_aux,clique_size,C)];
                end
            end
        end
    end
end

