function SP = findAllPaths(EncounterMatrix,AdjacencyMatrix)
% This function allows to find all the shortest paths between all pairs of
% nodes using the ouput E of shortest_path_distance(states,1)
% Inputs:
% - EncouterMatrix: E
% - AdjacencyMatrix: states
% Outputs:
% - SP: contains all the shortest paths between all pairs of nodes
% Author: Anh-Dung Nguyen
% Email: nad1186@gmail.com
N = length(EncounterMatrix);
SP = cell(N);
for u = 1:N
    u
    for v = 1:N
        if u~=v
            SP{u,v} = find_paths(u,v);
        end
    end
end

    function P = find_paths(i,j)
        if isempty(EncounterMatrix{i})
            P = [];
        else
            if j==i
                P = [];
            else
                % Find all predecessor of j
                pred = EncounterMatrix{i}(EncounterMatrix{i}(:,1) == j,2:3);
                
                if ~isempty(pred)
                    % j has only one predecessor
                    if size(pred,1) == 1
                        % find recursively the path from i to pred(j)
                        PP = find_paths(i,pred(1));
                        pred_to_j = bfs(AdjacencyMatrix(:,:,pred(2)),pred(1),j); % find all shortest paths from pred(j) to j at this time 
                        
                        if ~iscell(PP) || (length(PP) == 1 && iscell(PP))
                            % If there is only 1 path from i to pred(j)
                            if ~iscell(pred_to_j)
                                P = cat(1,PP,[pred_to_j' ones(length(pred_to_j),1)*pred(2)]);
                            else
                                for l=1:length(pred_to_j)
                                    P{l} = cat(1,PP,[pred_to_j{l}' ones(length(pred_to_j{l}),1)*pred(2)]);
                                end
                            end
                        elseif iscell(PP) && length(PP) > 1
                            % If there are multiple paths from i to pred(j)
                            c = 1;
                            for m = 1:length(PP)
                                if ~iscell(pred_to_j)
                                    P{m} = cat(1,PP{m},[pred_to_j' ones(length(pred_to_j),1)*pred(2)]);
                                else
                                    for l=1:length(pred_to_j)
                                        P{c} = cat(1,PP{m},[pred_to_j{l}' ones(length(pred_to_j{l}),1)*pred(2)]);
                                        c = c + 1;
                                    end
                                end
                            end
                        end
                    else
                        % If j has several predecessors then do the same thing
                        % with each predecessor
                        c = 1;
                        for n = 1:size(pred,1)
                            PP = find_paths(i,pred(n,1));
                            pred_to_j = bfs(AdjacencyMatrix(:,:,pred(n,2)),pred(n,1),j); % find all shortest paths from pred(j) to j at this time
                            if ~iscell(PP) || (length(PP) == 1 && iscell(PP))
                                if ~iscell(pred_to_j)
                                    P{c} = cat(1,PP,[pred_to_j' ones(length(pred_to_j),1)*pred(n,2)]);
                                    c = c + 1;
                                else
                                    for l=1:length(pred_to_j)
                                        P{c} = cat(1,PP,[pred_to_j{l}' ones(length(pred_to_j{l}),1)*pred(n,2)]);
                                        c = c + 1;
                                    end
                                end
                            elseif iscell(PP) && length(PP) > 1
                                for m = 1:length(PP)
                                    if ~iscell(pred_to_j)
                                        P{c} = cat(1,PP{m},[pred_to_j' ones(length(pred_to_j),1)*pred(n,2)]);
                                        c = c + 1;
                                    else
                                        for l=1:length(pred_to_j)
                                            P{c} = cat(1,PP{m},[pred_to_j{l}' ones(length(pred_to_j{l}),1)*pred(n,2)]);
                                            c = c + 1;
                                        end
                                    end
                                end
                            end
                        end
                    end
                else
                    % If j has no predecessor
                    P = [];
                end
            end
        end
    end
end