% SBEToolbox (Systems Biology & Evolution Toolbox).
% Version 1.3.2
% Authors: Kranti Konganti, Wang G, Yang E and James J. Cai
% (C) Texas A&M University.
%
% $LastChangedDate: 2013-05-29 13:40:21 -0500 (Wed, 29 May 2013) $
% $LastChangedRevision: 563 $
% $LastChangedBy: konganti $
% 
%
% ==== SBEToolbox Functions ====
%
%
%   Generate Random Networks
%   ------------------------
%
%       randnet_er               - Generate a random Erdös-Réyni network.
%       randnet_rl               - Generate a random Ring Lattice network.
%       randnet_sw               - Generate a random Small world network.
%
%   Graph Statistics
%   ----------------
%
%       graph_clustercoeff       - Calculate overall clustering coefficient of the graph.
%       graph_diameter           - Calculate diameter of the graph.
%       graph_efficiency         - Calculate efficiency measure of the graph.
%       graph_meandist           - Calculate mean distance of the graph.
%       graph_density            - Calculate density of the graph.
%
%   Node Statistics
%   ---------------
%
%       bridging_centrality      - Calculate Bridging Centrality.
%       closeness_centrality     - Calculate Closeness Centrality.
%       eccentricity_centrality  - Calculate Eccentricity Centrality.
%       delta_centrality         - Calculate Delta Centrality.
%       current_info_flow        - Calculate Current Information Flow.
%       assortativitycoeff       - Calculate Assortativity Coefficient.
%       bridgingcoeff            - Calculate Bridging Coefficient.
%       brokeringcoeff           - Calculate Brokering Coefficient.
%       clusteringcoeff          - Calculate Clustering Coefficient.
%       soffercc                 - Calculate Clustering Coefficient of Soffer & Vázquez (2005).
%       order2cc                 - Calculate Clustering Coefficient considering 2nd level of connections.
%       hierarchy                - Calculate Degree of Hierarchy.
%       kclique                  - Caldulate K-clique.
%       kcore                    - Calculate K-core of network.
%       locavgcon                - Calculate Local Average Connectivity.
%       neighborhood_conn        - Calculate Neighborhood Connectivity.      
%       participationcoeff       - Calculate Participation Coefficient.
%       richclubcoeff            - Calculate Rich Club Coefficient.
%       smallworldindex          - Calculate Small World Index.
%       within_module_deg        - Calculate Within Module Degree.
%
%   Node Annotation
%   ---------------
%
%       save_GO_annotation      - Save GO annotation from file and store as MAT file.
%       update_GO_annotation    - Updates GO annotations by downloading new annotation files from ftp://ftp.geneontology.org/pub/go/gene-associations/
%       annotate_nodes          - Get short or full annotation for a node.
%
%   Module Detection
%   ----------------
%
%       clusteronerun            - Detect modeules using ClusterONE algorithm.
%       mcode                    - Detect modeules using MCODE algorithm.
%       mcl                      - Implementation of Stijn van Dongen's algorithm to deduce clusters of current graph.
%       deduce_mcl_clusters      - Interpret MCL results and return number of MCL clusters and their membership.       
%
%   Network Evolution
%   -----------------
%       network_evolution        - Randomly duplicate, delete nodes and rewire edges
%     
%   Plugin Management
%   -----------------
%
%       create_plugin            - Create a new plugin from template 
%       plugin_manage            - Install, uninstall, package, delete and list local plugins
% 
%   Input & Output
%   --------------
%
%       readmat2sbe              - Read network information in MATLAB matrix format into G.  
%       readpajek2sbe            - Read network information PAJEK format into G.
%       readsif2sbe              - Read network information in SIF format into G.
%       readtab2sbe              - Read network information on TAB format into G.
%       writeadjmat2mat          - Write adjacency matrix into MAT file.
%       writeattribute2tab       - Write node attribute in a TAB delimited file.
%       writesbe2mat             - Write Network information as MATLAB MAT file.
%       writesbe2pajek           - Write network information in PAJEK format.
%       writesbe2protovis        - Write network information into Protovis accepted format.
%       writesbe2sif             - Write network information in SIF format.
%       writesbe2tab             - Write network information in TAB Delimited format.
%       writesbe2xml             - Write network information into XML format for visualization plugins.
%
%   Visualization
%   -------------
%
%       plotnet                  - View network in a plot.
%       plotnet_edgewidth        - View network in a plot with defined edge width.
%       plotnet_curve            - View network in a plot with curved edges.
%       plotnet_treering         - View network in a treering plot.
%       viewnetsvg               - View network using SVG.
%       powerlawplot             - Plot relationship between degree and number of nodes.
%       sbe_layout               - Gateway function for layout methods.
%
%   Miscellanous
%   ------------
%
%       laplacian                - Get graph Laplacian matrix.
%       incidence                - Conversion from adjacency matrix to incidence matrix.
%       modmat                   - Modularity matrix for undirected graph.
%       symmetrizeadjmat         - Symmetrize network G.
%       issimple                 - Check if network is simple (no self-loops, no double edges).
%       issymmetric              - Check if network loaded into G is symmetric.
%       cytoscaperun             - Export network in SIF format and invoke external program Cytoscape.
%       moduleid2net             - Represents module id output in a matrix for plotting
