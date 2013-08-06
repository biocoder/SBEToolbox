function c = dynamic_clustering(trace)
% Function calculating the Dynamic Clustering Coefficient defined in the
% paper "Understanding and Modeling the Small-World Phenomenon in Dynamic
% Networks - AD. Nguyen et al. - MSWIM 2012".
% Inputs:
% - trace: the 3D-matrix denoting the temporal graph. The 1st and 2nd
% dimension correspond to node's IDs and the 3rd dimension corresponds to
% the time.
% Outputs:
% - c: average dynamic clustering coefficient of the network..
% Author: Anh-Dung Nguyen
% Email: nad1186@gmail.com


N = size(trace,1); % number of nodes
clustering_nodes = zeros(N,1);

for i = 1:N
    t_transitive = [];
    for t1 = 1:size(trace,3)
        neighbors = setdiff(find(trace(i,:,t1)==1),i);
        if ~isempty(neighbors)
            for k = 1:length(neighbors)
                for t2 = t1:size(trace,3)
                    neighbors_of_neighbor = setdiff(find(trace(neighbors(k),:,t2)==1),[neighbors(k) i]);
                    if ~isempty(neighbors_of_neighbor)
                        for l = 1:length(neighbors_of_neighbor)
                            t3 = find(trace(neighbors_of_neighbor(l),i,t2:end)==1,1);
                            if ~isempty(t3)
                                t_transitive = [t_transitive t3];
                            end
                        end
                        break;
                    end
                end
            end
            break;
        end
    end
   
    if isempty(t_transitive)
        clustering_nodes(i) = 0;
    else
        clustering_nodes(i) = 1/min(t_transitive);
    end
end
c = mean(clustering_nodes);
end