function handle = askScreenPreference(varargin)
% ASKSCREENPREFERENCE
% This function will attempt to detect multiple monitors and logs the
% screen sizes for future figure positions.
%
%
% Systems Biology and Evolution Toolbox (SBEToolbox).
% Author(s): Kranti Konganti.
% (C) Texas A&M University.
%
% $LastChangedDate: 2013-02-12 10:57:29 -0600 (Tue, 12 Feb 2013) $
% $LastChangedRevision: 428 $
% $LastChangedBy: konganti $
%

if nargin < 1
    varargin{1} = 'NA';
end

if ~ispref('SBEToolbox', 'useMonitor')
    addpref('SBEToolbox', 'useMonitor', 0);
elseif ~strcmp(varargin{1}, 'changeScrSize')
    handle = 'noWait';
    return;
end

figure('units', 'pixels', 'Position', [100 100 826 623]);
handle = gcf;
movegui(gcf, 'center');
uicontrol('Style', 'text', ...
    'String', 'First, we will try to set your default screen position. Drag this window to the position of your choice and press OK below to set default screen position', ...
    'Position', [100 550 500 30]);
uicontrol('Style', 'pushbutton', 'String', 'OK', ...
    'Position', [200 400 50 30], ...
    'Callback', @setScreenSize);
uicontrol('Style', 'pushbutton', 'String', 'Cancel', ...
    'Position', [450 400 50 30], ...
    'Callback', @closeFig);
%pos = get(mH, 'Position');
%setpref('SBEToolbox', 'useMonitor', pos);

%{
monitors = java.awt.GraphicsEnvironment.getLocalGraphicsEnvironment.getScreenDevices;

if size(monitors, 1) > 1
    chooseMonitor(monitors)
else
   setscreenpref(monitors, 1); 
end

function chooseMonitor(m)
    monCell = cell(size(m, 1), 1);
    for mon = 1:size(m, 1);
        monCell{mon} = ['Monitor ', num2str(mon), ' :     ', ...
            num2str(m(mon).getDefaultConfiguration.getBounds.getWidth), ...
            ' x ', num2str(m(mon).getDefaultConfiguration.getBounds.getHeight)];
    end
    monInd = Search(monCell, 'Choose a Monitor of your Preference: ');
    if (monInd > 0)
        setscreenpref(m, monInd);
    end
end

function setscreenpref(m, ind)
    setpref('SBEToolbox', 'useMonitor', ... 
   [num2str(m(ind).getDefaultConfiguration.getBounds.getWidth), ...
       '|', num2str(m(ind).getDefaultConfiguration.getBounds.getHeight)]);
end

end
%}

function setScreenSize(varargin)
    pos = get(gcf, 'Position');
    set(0, 'DefaultFigurePosition', pos);
    setpref('SBEToolbox', 'useMonitor', pos);
    close(gcf);
end

function closeFig(varargin)
    close(gcf);
end

end