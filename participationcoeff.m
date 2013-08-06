function [p]=participationcoeff(sbeG,sbePartition)
%PARTICIPCOEFF - participation coefficient
%
% [p]=participcoeff(sbeG,sbePartition)
% where sbePartition is a 1 x n vector containing cluster membership IDs
% where n is the size of number of nodes.
%
% Ref: http://www.nature.com/nature/journal/v433/n7028/full/nature03288.html
% Guimerà R, Nunes Amaral LA. Functional cartography of complex metabolic
% networks. Nature. 2005 Feb 24;433(7028):895-900. PubMed PMID: 15729348; PubMed
% Central PMCID: PMC2175124.
%
% See also: within_module_deg
%
% Systems Biology and Evolution Toolbox (SBEToolbox).
% Authors: James Cai, Kranti Konganti.
% (C) Texas A&M University.
%
% $LastChangedDate: 2013-02-12 10:57:29 -0600 (Tue, 12 Feb 2013) $
% $LastChangedRevision: 428 $
% $LastChangedBy: konganti $
%

n=num_vertices(sbeG);
p=zeros(n,1);
for k=1:n    
    kv=sbePartition(sbeG(k,:));
    p(k)=1-sum((grpstats(kv,kv,'numel')./length(kv)).^2);
end
