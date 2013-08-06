function [shortest_paths,distance] = bfs(A,s,t)
% breathe-first search algorithm as described in "Network: an Introduction
% (Newman 2010)"
% Input:
% A: adjacency matrix of the network
% s: starting node
% t: destination node
% Outputs:
% shortest_paths: all the shortest paths from s to t
% distance: vector containing distances from s to all other nodes 
% Author: Anh-Dung Nguyen
% Email: nad1186@gmail.com

distance = ones(1,size(A,1))*-1;
distance(s) = 0;
queue = zeros(1,size(A,1));
queue(1) = s;
read_pointer = 1;
write_pointer = 2;
sp_tree = zeros(size(A,1));
found = 0;
while read_pointer~=write_pointer % algorithm is terminated when the read and write pointers are pointing to the same element 
    d = distance(queue(read_pointer)); % find the distance d for the vertex in queue
    neighbor = setdiff(find(A(queue(read_pointer),:)==1),queue(read_pointer)); % find neighboring vertex
    for i=1:length(neighbor)
        if distance(neighbor(i))==-1 % if the distance of the neighboring vertex is unknown
            distance(neighbor(i)) = d+1; % assigne it distance d+1
            queue(write_pointer) = neighbor(i); % store its label in the queue
            write_pointer = write_pointer+1; % increase the write pointer by one
            sp_tree(neighbor(i),queue(read_pointer)) = 1; % 
        elseif distance(neighbor(i))==d+1
            sp_tree(neighbor(i),queue(read_pointer)) = 1;
        end
        if neighbor(i)==t
            found = 1;
            break;
        end
    end
    if found
        break;
    end
    read_pointer = read_pointer+1; % increase the read pointer to read the following element
end

% reconstruction of all the shortest paths
if found
    if s==t
        shortest_paths = [];
    else
        shortest_paths = find_paths(s,t);
    end
else
    shortest_paths = [];
end


function p = find_paths(u,v)
        if sp_tree(v,u)==1
            p = v;
        else
            neighbors = find(sp_tree(v,:)==1);            
            if length(neighbors)==1
                pp = find_paths(u,neighbors);
                if ~iscell(pp)
                    p = cat(2,pp,v);
                else
                    for m=1:length(pp)
                        p{m} = cat(2,pp{m},v);
                    end
                end                
            else             
                for n=1:length(neighbors)
                    pp = find_paths(u,neighbors(n));
                    if ~iscell(pp)
                        p{n} = cat(2,pp,v);
                    else
                        for m=1:length(pp)
                            p{m+n-1} = cat(2,pp{m},v);
                        end
                    end
                end
            end
        end
    end
end