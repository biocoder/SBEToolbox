function k = dkernel(sbeG, beta)
%DKERNEL - Returns diffusion kernel
%
%   K = DKERNEL(G, BETA) return diffusion kernel of given diffusion
%   probability BETA. Diffusion kernel of a graph is defined as
%   K = exp (BETA * L), where L is graph lapalcian matrix and exp is matrix
%   exponential, which is calucalted by SVD.

% Kyaw Tun
% 6/6/2009

[u, ~, v] = svd(full(laplacian(sbeG)));
% u and v is the same since laplacian is symetric.
k = u * diag(beta * sum(sbeG)) * v;


