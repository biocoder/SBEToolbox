function A = incidence(B)
% A = incidence(B) - conversion from adjacency matrix to incidence matrix
%
% INPUT:    B - adjacency matrix of a graph (directed or undirected);
% OUTPUT:   A - incidence matrix; rows = vertices, columns = edges
%

% 08 Jul 2009   - created   Ondrej Sluciak <ondrej.sluciak@nt.tuwien.ac.at>

        

[M1,M2] = size(B);

if (M1 < 2)
    error('Graph must contain at least 2 nodes with one edge!');
end

if (M1 ~= M2)
    error('Input matrix must be square!');
end


[e,sym] = getEdges(B);
Me = size(e,1);
A = zeros(M1,Me);

for j=1:Me
    if (sym==1)
        A(e(j,1),j)=1;
        A(e(j,2),j)=1;
    else
        A(e(j,1),j) = 1;
        A(e(j,2),j) = -1;   %for directed graph, incoming edge = -1
    end
end

end

function a = issymmetric(B)
% find out if the graph is directed or undirected

B = logical(B);
a = sum(sum(abs(B-B'))) == 0;
    
end

function [e,sym] = getEdges(B)
% returns list of edges 'e' and boolean 'sym' to indicate if it is directed
% graph or not

M = size(B,1);
Me = sum(B*ones(M,1));

if (Me < 1)
    error('Graph must contain at least 1 edge!');
end

sym = issymmetric(B);

if (sym == 1)
    Me = Me/2;
end

e = zeros(Me,2);

k=1;
if (sym == 1)
    for i=1:M
        for j=i:M
            if (B(i,j)==1)
                e(k,:) = [i,j];
                k=k+1;
            end
        end
    end
else
    for i=1:M
        for j=1:M
            if (B(i,j)==1)
                e(k,:) = [i,j];
                k=k+1;
            end
        end
    end
end
end



function A = incidence2(B)
% A = incidence(B) - conversion from adjacency matrix to incidence matrix
%
% INPUT:    B - adjacency matrix of a graph (directed or undirected);
% OUTPUT:   A - incidence matrix; rows = vertices, columns = edges
%

% 08 Jul 2009   - created   Ondrej Sluciak <ondrej.sluciak@nt.tuwien.ac.at>

        siz = size(B); 
if siz(1)~=siz(2); 
    error('B must be square'); 
end 
 
nrknots = siz(1); 
nredges = nnz(B); 
[IXknots1,IXknots2] = find(B); 
sones = ones(nredges,1); 
IXedges = (1:nredges)'; 
 
A = sparse([IXedges; IXedges],... 
             [IXknots1; IXknots2],... 
             [-sones; sones],... 
             nredges,nrknots); 
         