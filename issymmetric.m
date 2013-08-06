function [y]=issymmetric(G)
%
% [y]=issymmetric(G)
%
% Systems Biology and Evolution Toolbox (SBEToolbox).
% Authors: James Cai, Kranti Konganti.
% (C) Texas A&M University.
%
% $LastChangedDate: 2012-12-28 19:01:43 -0600 (Fri, 28 Dec 2012) $
% $LastChangedRevision: 278 $
% $LastChangedBy: konganti $
%

y=isequal(G,G.');
%y = max(max(G-G'))<=e
%y=norm(G'-G) <= sqrt(eps);