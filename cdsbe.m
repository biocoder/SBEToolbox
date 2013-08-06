function curr_path=cdsbe(filename)
%CDSBE - A helper function to change working directory to SBEToolbox directory.
%
% Systems Biology and Evolution Toolbox (SBEToolbox).
% Authors: James Cai, Kranti Konganti.
% (C) Texas A&M University.
%
% $LastChangedDate: 2013-01-01 13:33:15 -0600 (Tue, 01 Jan 2013) $
% $LastChangedRevision: 296 $
% $LastChangedBy: jcai $
%

%curr_path = fileparts(which(filename));

pw0=pwd;
pw1=fileparts(which(mfilename));
if ~strcmp(pw0,pw1)
    [selectedButton,dlgShown]=uigetpref('SBEToolbox',... % Group
           'cdsbe_ask',...                               % Preference
           'Changing Working Directory',...              % Window title
           {'Do you want to change current working directory to SBEToolbox directory?'},...
           {'always','never';'Yes','No'},...       % Values and button strings
            'ExtraOptions','Cancel',...             % Additional button
            'DefaultButton','Yes');
    switch selectedButton
        case {'always','Yes'}
            cd(pw1);
        case {'never','No','Cancel'}
    end
end



