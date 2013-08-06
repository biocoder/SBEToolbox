function [moduleid]=sbe_module(sbeG,method)
%SBE_MODULE - Gateway function for module detection methods
%
% [moduleid]=sbe_module(sbeG,method)
% method: 1 - ClusterONE, 2 - MCODE, 3 - MCL
% 
% Systems Biology and Evolution Toolbox (SBEToolbox).
% Authors: Kranti Konganti, James Cai.
% (C) Texas A&M University.
%
% $LastChangedDate: 2012-12-28 19:01:43 -0600 (Fri, 28 Dec 2012) $
% $LastChangedRevision: 278 $
% $LastChangedBy: konganti $
%

switch method
    case 1
        [moduleid]=clusteronerun(sbeG);
    case 2
        [moduleid]=mcode(sbeG);
    case 3
        g = mcl(sbeG, 2, 2, 0, false);
        [moduleid]=i_net2moduleid(g);
end


function [moduleid]=i_net2moduleid(deduced_net)
    
    moduleid=zeros(1,size(full_deduced_net, 1));
    full_deduced_net = unique(full(deduced_net), 'rows');
    cluster_id=0;
           for k = 1:size(full_deduced_net, 1);

               cluster_id = cluster_id + 1;
               nc = find(full_deduced_net(k, :));               
               for j = 1:length(nc)
                   moduleid(nc(j))=cluster_id;
               end               
           end
