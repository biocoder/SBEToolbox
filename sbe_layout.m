function [xy]=sbe_layout(sbeG,method)
%SBE_LAYOUT - Gateway function for layout methods
%
% [xy]=sbe_layout(sbeG,method)
% method: 1 - Random, 2 - Circle, 3 - Tree Ring
%         4 - Kamada-Kawai Spring
%         5 - Gursoy-Atun
%         6 - Fruchterman-Reingold Force Directed
% 
% Systems Biology and Evolution Toolbox (SBEToolbox).
% Authors: Kranti Konganti, James Cai.
% (C) Texas A&M University.
%
% $LastChangedDate: 2012-12-28 19:01:43 -0600 (Fri, 28 Dec 2012) $
% $LastChangedRevision: 278 $
% $LastChangedBy: konganti $
%

if nargin<2
    method=1;
end

switch method
    case 1
        xy=random_graph_layout(sbeG);
    case 2
        xy=circle_layout(sbeG);
    case 3
        xy=treering_layout(sbeG,ncenter);
    case 4
        xy=kamada_kawai_spring_layout(double(sparse(plot_sbeG)));
    case 5
        xy=gursoy_atun_layout(double(sparse(plot_sbeG)));
    case 6
        xy=fruchterman_reingold_force_directed_layout(double(sparse(sbeG)));
    otherwise
        error('Invalid method option.');        
end
