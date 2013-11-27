function update_GO_annotation
%
% Updates GO annotations by downloading new annotation files from
% ftp://ftp.geneontology.org/pub/go/gene-associations/
%
% update_GO_annotation
%
% Systems Biology and Evolution Toolbox (SBEToolbox).
% Authors: Kranti Konganti, James Cai.
% (C) Texas A&M University.
%
% $LastChangedDate: 2013-06-25 11:22:25 -0500 (Tue, 25 Jun 2013) $
% $LastChangedRevision: 725 $
% $LastChangedBy: konganti $
%

[annoPath, ~, ~] = fileparts(which(mfilename()));


if nargin < 1
    annoFTPDir = dir([annoPath, filesep, 'annotation']);
    wait_4_go_dls_h = waitbar(0, 'Downloading ...'); 
    for filei = 1:length(annoFTPDir)
        if strcmp(annoFTPDir(filei).name, '.') || strcmp(annoFTPDir(filei).name, '..') || ...
                strcmp(annoFTPDir(filei).name, '.svn') || ...
                strcmp(annoFTPDir(filei).name, 'speciesList.mat') || ...
                strcmp(annoFTPDir(filei).name, 'ftpget') || ...
                strcmp(annoFTPDir(filei).name, '.gitignore')
            continue;
        else
            species = strsplit(annoFTPDir(filei).name, '.');
            dl_filename = char(strcat(annoPath, filesep, 'annotation', filesep, ...
                'ftpget', filesep, 'gene_association.', species(1), '.gz'));
            dl_url = char(strcat('ftp://ftp.geneontology.org/pub/go/gene-associations/gene_association.' , species(1), '.gz'));
            waitbar(filei / length(annoFTPDir), wait_4_go_dls_h, sprintf('%s%s',...
                'Downloading ...  ',  char(strrep(species(1), '_', '\_'))));
            urlwrite(dl_url, dl_filename);
        end
    end
    close(wait_4_go_dls_h);
    save_GO_annotation;
else
   errordlg('This function does not accept any arguments.')
end