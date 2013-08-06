function [t]=richclubcoeff(G,k)
%RICHCLUBCOEFF - computes rich-club coefficient
%
% t(k) = 2*Ek/(Nk*(Nk-1)), where 
% Ek the number of edges among the Nk nodes haveing degreee higher than a
% given value k.
%
% REF: Colizza et al. Nature Physicas 2006
% http://www.plosone.org/article/info%3Adoi%2F10.1371%2Fjournal.pone.0000335#s2
%
% Systems Biology and Evolution Toolbox (SBEToolbox).
% Authors: James Cai, Kranti Konganti.
% (C) Texas A&M University.
%
% $LastChangedDate: 2012-12-28 19:01:43 -0600 (Fri, 28 Dec 2012) $
% $LastChangedRevision: 278 $
% $LastChangedBy: konganti $
%

t=nan(1,length(k));
vect_k=sum(G);

for x=1:length(k)
    idx=vect_k>k(x);
    G2=G(idx,idx);
    [Nk,Mk]=size(G2);
    Ek=0.5*sum(G2(:));
    t(x)=2*Ek/(Nk*(Nk-1));
end
