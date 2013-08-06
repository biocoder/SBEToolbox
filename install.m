function install
% Installs SBEToolbox by adding appropriate paths using the addpath
% command. It then opens pathtool window so that you can save and close
% that window.
% 
% Check for the following directories that should be prepended.
%
% SBEToolbox
%          |_ addins
%          |_ annotation
%          |_ plugins
%          |_ lib
%               |_ gaimc
%               |_ bgl
%          |_ session
%          |_ help
%
% Usage: install
%
% Systems Biology and Evolution Toolbox (SBEToolbox).
% Authors: Kranti Konganti, James Cai.
% (C) Texas A&M University.
%
% $LastChangedDate: 2013-06-26 10:09:36 -0500 (Wed, 26 Jun 2013) $
% $LastChangedRevision: 742 $
% $LastChangedBy: konganti $ 
%

[RootSBE, ~, ~] = fileparts(which(mfilename()));
if ~ispref('SBEToolbox', 'installPath')
    addpref('SBEToolbox', 'installPath', RootSBE);
else
    setpref('SBEToolbox', 'installPath', RootSBE);
end
addins = [RootSBE, filesep, 'addins'];
annotation = [RootSBE, filesep, 'annotation'];
plugins = [RootSBE, filesep, 'plugins'];
lib = [RootSBE, filesep, 'lib'];
gaimc = [RootSBE, filesep, 'lib', filesep, 'gaimc'];
bgl = [RootSBE, filesep, 'lib', filesep, 'bgl'];
session = [RootSBE, filesep, 'session'];
help = [RootSBE, filesep, 'help'];

disp('Adding Paths ...')
addpath([RootSBE, filesep], '-BEGIN');
addpath(addins, '-BEGIN');
addpath(annotation, '-BEGIN');
addpath(plugins, '-BEGIN');
addpath(lib, '-BEGIN');
addpath(gaimc, '-BEGIN');
addpath(bgl, '-BEGIN');
addpath(session, '-BEGIN');
addpath(help, '-BEGIN');
disp('Done !')
disp('We will open the pathtool in 5 seconds ...');
disp('Please click on Save and then on Close to save the paths.');
pause(5);
pathtool;
