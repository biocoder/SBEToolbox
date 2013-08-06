function [sbeG,sbeNode]=randnet_ph(v_deg)
%RANDNET_PH - Generates a random graph using stickiness model Przulj & Higham (Gnp) graph
%
% V_DEG = list of degrees of N nodes
%
% REFENCE: doi: 10.1098/rsif.2006.0147
% J. R. Soc. Interface 2006 3, 711-716
% Natasa Przulj and Desmond J Higham
% Modelling protein-protein interaction networks via a stickiness index
%
% Systems Biology and Evolution Toolbox (SBEToolbox).
% Authors: James Cai, Kranti Konganti.
% (C) Texas A&M University.
%
% $LastChangedDate: 2012-12-28 19:01:43 -0600 (Fri, 28 Dec 2012) $
% $LastChangedRevision: 278 $
% $LastChangedBy: konganti $
%

dgi=v_deg./sum(v_deg);
n=length(v_deg);
sbeG=false(n);
for i=1:n-1
for j=i+1:n
    if (rand<=dgi(i)*dgi(j))
	sbeG(i,j)=true;
    end
end
end
sbeG=sbeG|sbeG';
if (nargout>2)
    % Kranti Konganti
    % strread has been replaced by textscan in new version of matlab
	sbeNode=textscan(num2str(1:size(sbeG,1)),'%s');
    
    % textscan returns 1x1 cell array when a string line is passed
    % so, get actual cell array containing node information. i.e get
    % cell array within sbeNode.
    sbeNode = sbeNode{1};
    
end
