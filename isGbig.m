function [yes]=isGbig(G)
yes=false;
if size(G,1) >= 1000 || int32(nnz(G)/2) >= 1000
    yes=true;
end
