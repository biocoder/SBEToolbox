function varargout = annotate_nodes(varargin)
%Annotate a list of nodes if the annotation is available from the file.
% 
% annotation = annotate_nodes(node_index) will attempt to 
% find the annotation information for that particular species.
%
% Ex: annotation = annotate_nodes(1) will annotate first node 
% 
%                           OR
% 
% Ex: annotate_nodes
%
% Just running the function without any input arguments will ask the
% user to selec the database which is one of the following
%
% 1   ==> Agrobacterium tumefaciens str. C58 (PAMGO)
% 2   ==> Arabidopsis thaliana (TAIR)
% 3   ==> Aspergillus nidulans (AspGD)
% 4   ==> Bos taurus (GO Annotations @ EBI)
% 5   ==> Caenorhabditis elegans (WormBase)
% 6   ==> Candida albicans (CGD)
% 7   ==> Canis lupus familiaris (GO Annotations @ EBI)
% 8   ==> Danio rerio (ZFIN)
% 9   ==> Dickeya dadantii (PAMGO)
% 10  ==> Dictyostelium discoideum (dictyBase)
% 11  ==> Drosophila melanogaster (FlyBase)
% 12  ==> Escherichia coli (EcoCyc & EcoliHub)
% 13  ==> Gallus gallus (GO Annotations @ EBI)
% 14  ==> Homo sapiens (GO Annotations @ EBI)
% 15  ==> Leishmania major (Sanger GeneDB)
% 16  ==> Magnaporthe grisea (PAMGO)
% 17  ==> Mus musculus (MGI)
% 18  ==> Oomycetes (PAMGO)
% 19  ==> Oryza sativa (Gramene)
% 20  ==> Plasmodium falciparum (Sanger GeneDB)
% 21  ==> Pseudomonas aeruginosa PAO1 (PseudoCAP)
% 22  ==> Rattus norvegicus (RGD)
% 23  ==> Reactome [multispecies] (CSHL & EBI)
% 24  ==> Saccharomyces cerevisiae (SGD)
% 25  ==> Schizosaccharomyces pombe (PomBase)
% 26  ==> Solanaceae (SGN)
% 27  ==> Sus scrofa (GO Annotations @ EBI)
% 28  ==> Trypanosoma brucei (Sanger GeneDB)
%
%                           OR
%
% annotation = annotate_nodes(1, 'full') will return the full annotation fields.
%
% Ex: annotation = annotate_nodes(1, 'full') will annotate the first node
% contained in the sbeNode variable and return all annotation fields
%
% To view annotation fields do:
%
% annotation
%
% There will be 15 fields
%
% anntation = 
%
%    'DB'
%    'DBObjectID'
%    'DBObjectSymbol'
%    'Qualifier'
%    'GOID'
%    'DBReference'
%    'Evidence'
%    'WithORFrom'
%    'GOAspect'
%    'DBObjectName'
%    'DBObjectSynonym'
%    'DBObjectType'
%    'Taxon'
%    'Date'
%    'AnnotationAssignedBy'
%
% Ex: annotation = annotate_nodes(1, 'full');
%     annotation.DB
%     ans = 
%     
%     'SGD'
%
%     a.DBObjectSymbol
%
%     ans = 
%
%     'SNC1'
%
%     a.DBObjectSynonym
%
%     ans = 
%
%     'YAL030W'
%
% See also: save_GO_annotation
%
% Systems Biology and Evolution Toolbox (SBEToolbox).
% Authors: Kranti Konganti, James Cai.
% (C) Texas A&M University.
%
% $LastChangedDate: 2013-06-25 11:22:25 -0500 (Tue, 25 Jun 2013) $
% $LastChangedRevision: 725 $
% $LastChangedBy: konganti $
%

persistent sbeAnnotSpecies;

if ~ispref('SBEToolbox', 'annotation_db')
    addpref('SBEToolbox', 'annotation_db', '');
end

if nargin < 1
    speciesListCell = load('speciesList.mat');
    speciesList = speciesListCell.speciesList;
    
    [setSPId, answ] = listdlg('Name', 'Available Species List', ...
        'PromptString', 'Set annotation database to start working with a network: ', ...
        'SelectionMode', 'single', ...
        'ListSize', [500, 300], ...
        'ListString', speciesList);
    if answ, setpref('SBEToolbox', 'annotation_db', setSPId); end
    clear annotate_nodes;
    return;
elseif nargin == 2
    nodeIdx = varargin{1};
   
    if ~isa(nodeIdx, 'numeric')
        errordlg(['Not a valid Node Index: ', nodeIdx]);
        return;
    end
    
    if ~strcmpi(varargin{2}, 'full')
        errordlg(['Not a valid argument: ', varargin{2}]);
        return;
    end
elseif nargin == 1
    nodeIdx = varargin{1};
   
    if ~isa(nodeIdx, 'numeric')
        errordlg(['Not a valid Node Index: ', nodeIdx]);
        return;
    end
else
    errordlg('Invalid number of arguments. See help annotate_nodes');
    return;    
end

%% Species annotation containers
spKey = {'PAMGO_Atumefaciens', 'tair', 'aspgd', 'goa_cow', 'wb', 'cgd', ...
    'goa_dog', 'zfin', 'PAMGO_Ddadantii', 'dictyBase', 'fb', 'ecocyc', ...
    'goa_chicken', 'goa_human', 'GeneDB_Lmajor', 'PAMGO_Mgrisea', ...
    'mgi', 'PAMGO_Oomycetes', 'gramene_oryza', 'GeneDB_Pfalciparum', ...
    'pseudocap', 'rgd', 'reactome', 'sgd', 'pombase', 'sgn', 'goa_pig', ...
    'GeneDB_Tbrucei'};

[~, nodes] = getcurrentnetsession;
if isempty(sbeAnnotSpecies)
    %h = waitbar(0.25, 'Please wait... Loading annotation...');
    sbeAnnotSpecies = load(strcat(spKey{getpref('SBEToolbox', 'annotation_db')}, '.GO.mat'), 'annotationGO');
else
    %h = waitbar(0.5, 'Please wait... Annotating nodes(s)...');
end


%% Search in Gene symbols or in its synonyms and assign DBObjectName to the
%  node.
annotIdx = find(~cellfun(@isempty,regexpi(sbeAnnotSpecies.annotationGO.DBObjectSymbol, nodes{nodeIdx})), 1);
if isempty(annotIdx)
    annotIdx = find(~cellfun(@isempty,regexpi(sbeAnnotSpecies.annotationGO.DBObjectSynonym, nodes{nodeIdx})), 1);
end

if ~isempty(annotIdx) && nargin < 2
    annotation{1} = [char(sbeAnnotSpecies.annotationGO.DBObjectName(annotIdx)), ' | Synonyms:', ...
        char(sbeAnnotSpecies.annotationGO.DBObjectSynonym(annotIdx))];
    %msgbox(annotation, 'Node Annotation', 'help');
    varargout{1} = annotation;
elseif ~isempty(annotIdx) && nargin == 2
    annotation = struct();
    annotFields = fields(sbeAnnotSpecies.annotationGO);
    for i = 1:length(annotFields);
        vals = extractfield(sbeAnnotSpecies.annotationGO, char(annotFields(i)));
        annotation.(char(annotFields(i))) = vals{1}(annotIdx);
    end
    varargout{1} = annotation;
elseif isempty(annotIdx)
    varargout{1} = 'N/A';
    %msgbox('Cannot find node annotation !', 'Node Annotation', 'warn');
end

%waitbar(1, h, 'Done !')
%if exist('h','var'), close(h); end

end