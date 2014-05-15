function varargout = SBEGUI(varargin)
% SBEGUI M-network for SBEGUI.fig
%      SBEGUI, by itself, creates a new SBEGUI or raises the existing
%      singleton*.
%
%      H = SBEGUI returns the handle to a new SBEGUI or the handle to
%      the existing singleton*.
%
%      SBEGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SBEGUI.M with the given input arguments.
%
%      SBEGUI('Property','Value',...) creates a new SBEGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SBEGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SBEGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Statistics menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES
%
% Edit the above text to modify the response to help SBEGUI
%
% Systems Biology and Evolution Toolbox (SBEToolbox).
% Authors: Kranti Konganti, James Cai.
% (C) Texas A&M University.
%
% $LastChangedDate: 2013-06-26 10:09:36 -0500 (Wed, 26 Jun 2013) $
% $LastChangedRevision: 742 $
% $LastChangedBy: konganti $
%
% Last Modified by GUIDE v2.5 27-Nov-2013 08:44:06

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SBEGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @SBEGUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before SBEGUI is made visible.
function SBEGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SBEGUI (see VARARGIN)
% Choose default command line output for SBEGUI
handles.output = hObject;
global deduced_net;

%scrsz=get(0,'ScreenSize');
%pos_act=get(gcf,'Position');
%xr=scrsz(3)-pos_act(3);
%xp=round(xr/2);
%yr=scrsz(4)-pos_act(4);
%yp=round(yr/2);
%set(gcf,'position',[xp yp pos_act(3) pos_act(4)]);
%waitH = askScreenPreference;
%if ~strcmp(waitH, 'noWait'), waitfor(waitH); end
%disp(getpref('SBEToolbox', 'useMonitor'));
%set(0, 'DefaultFigurePosition', getpref('SBEToolbox', 'useMonitor'));
%set(gcf, 'units', 'pixels', ...
%    'Position', getpref('SBEToolbox', 'useMonitor'));
movegui(gcf, 'center');

if ~isempty(deduced_net)
    clear global deduced_net;
end


% --------------------------------------------------------------------
% User preferences
% --------------------------------------------------------------------
if ispref('SBEToolbox', 'installPath')
    cd(getpref('SBEToolbox', 'installPath'))
else
    addpref('SBEToolbox', 'installPath', fileparts(which(mfilename)));
end

if ~ispref('SBEToolbox', 'LoadDeducedNetworkUserPref')
    addpref('SBEToolbox', 'LoadDeducedNetworkUserPref', 0);
end
if getpref('SBEToolbox', 'LoadDeducedNetworkUserPref') == 1
    set(handles.LoadDeducedNetwork, 'enable', 'off');
    set(handles.LoadDeducedNetwork, 'checked', 'on');
end

if ~ispref('SBEToolbox', 'SaveWindowOutput2File')
    addpref('SBEToolbox', 'SaveWindowOutput2File', 0);
end
if getpref('SBEToolbox', 'SaveWindowOutput2File') == 1
    set(handles.WantToExportResultFile, 'checked', 'on');
end

if ~ispref('SBEToolbox', 'CopyWindowOutput2Clipboard')
    addpref('SBEToolbox', 'CopyWindowOutput2Clipboard', 0);
end
if getpref('SBEToolbox', 'CopyWindowOutput2Clipboard') == 1
    set(handles.WantToExportResultToClipboard, 'checked', 'on');
end

if ~ispref('SBEToolbox', 'ExportWindowOutput2Workspace')
    addpref('SBEToolbox', 'ExportWindowOutput2Workspace', 0);
end
if getpref('SBEToolbox', 'ExportWindowOutput2Workspace') == 1
    set(handles.WantToExportResultToClipboard, 'checked', 'on');
end

if ~ispref('SBEToolbox', 'ShowGraphInset')
    addpref('SBEToolbox', 'ShowGraphInset', 0);
end
if getpref('SBEToolbox', 'ShowGraphInset') == 1
    set(handles.alwaysViewGraphInset, 'checked', 'on');
end

if ~ispref('SBEToolbox', 'isRestore')
    addpref('SBEToolbox', 'isRestore', 0);
end

if ~ispref('SBEToolbox', 'largestconnnetCalled')
    addpref('SBEToolbox', 'largestconnnetCalled', 0);
end

if ~ispref('SBEToolbox', 'ShowGraphInset')
    addpref('SBEToolbox', 'ShowGraphInset', 0);
end

if ~ispref('SBEToolbox', 'pluginexe')
    addpref('SBEToolbox', 'pluginexe', '');
end

if ~ispref('SBEToolbox', 'filedir')
    addpref('SBEToolbox', 'filedir', '');
end

if ~ispref('SBEToolbox', 'filename')
    addpref('SBEToolbox', 'filename', '');
end

if ~ispref('SBEToolbox', 'graph_gui')
    addpref('SBEToolbox', 'graph_gui', '');
end

if ~ispref('SBEToolbox', 'graph_gui_drawn')
    addpref('SBEToolbox', 'graph_gui_drawn', '');
end 

if ~ispref('SBEToolbox', 'annotation_db')
    addpref('SBEToolbox', 'annotation_db', '');
end

if ~ispref('SBEToolbox', 'InitMatlabMemUsedMB')
    addpref('SBEToolbox', 'InitMatlabMemUsedMB', 0);
end

if ~ispref('SBEToolbox', 'RandomEvolutionUserPref')
    addpref('SBEToolbox', 'RandomEvolutionUserPref', 0);
end

if ~ispref('SBEToolbox', 'isPluginNetworkReload')
    addpref('SBEToolbox', 'isPluginNetworkReload', 0);
end

if ~ispref('SBEToolbox', 'NetEvolMsg')
    addpref('SBEToolbox', 'NetEvolMsg', 'Network Evolved (?)');
else
    setpref('SBEToolbox', 'NetEvolMsg', 1);
end

if isempty(getpref('SBEToolbox', 'annotation_db'))
    annotate_nodes;
end


% Users don't need gory details about update process
%hideSBEToolboxUpdate

% Timer function for memory monitoring
if ~isempty(timerfindall('Name', 'SBEGUI_CurrentMemUsage'))
    delete(timerfindall('Name', 'SBEGUI_CurrentMemUsage'));
end
memT = timer('Name', 'SBEGUI_CurrentMemUsage', 'ExecutionMode', ...
    'fixedRate', 'Period', 1, 'BusyMode', 'queue', ...
    'ObjectVisibility', 'off', 'TimerFcn', ...
    {@updateMemoryUsage, handles});

start(memT);


% --------------------------------------------------------------------
% Update handles structure
% --------------------------------------------------------------------
guidata(hObject, handles);
checkisRandomEvolution(handles);
SetMenuStatus(handles);

% UIWAIT makes SBEGUI wait for user response (see UIRESUME)
% uiwait(handles.SBEToolboxGUI);

% --------------------------------------------------------------------
function WorkspaceOutput_Callback(hObject, eventdata, handles)
% hObject    handle to WorkspaceOutput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of WorkspaceOutput as text
%        str2double(get(hObject,'String')) returns contents of WorkspaceOutput as a double


% --- Executes during object creation, after setting all properties.
function WorkspaceOutput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to WorkspaceOutput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Outputs from this function are returned to the command line.
function varargout = SBEGUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function Network_Callback(hObject, eventdata, handles)
% hObject    handle to Network (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
SetMenuStatus(handles);

% --------------------------------------------------------------------
function Statistics_Callback(hObject, eventdata, handles)
% hObject    handle to Statistics (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
SetMenuStatus(handles);

% --------------------------------------------------------------------
function Help_Callback(hObject, eventdata, handles)
% hObject    handle to Help (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
SetMenuStatus(handles);

% --------------------------------------------------------------------
function NetworkOpenMATFile_Callback(hObject, eventdata, handles)
% hObject    handle to NetworkOpenMATFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global sbeG sbeNode retFname
set(handles.StatusBar, 'String', 'Busy');
retFname_old = retFname;

[sbeG,sbeNode,retFname]=opensbematfile;
sbeG = sparse(sbeG);

if ~isempty(sbeG)
    guiOutput = i_dispheader_gui('Network loaded from MAT file!',...
        2);
    guiOutput = viewnetinfo_gui(sbeG, guiOutput);
    guiOutput=i_dispfooter_gui(guiOutput);
    set(handles.WorkspaceOutput, 'String', guiOutput);
    writenetsession(sbeG, sbeNode, 'sbeVars');
    setpref('SBEToolbox', 'largestconnnetCalled', 0);
    setpref('SBEToolbox', 'isRestore', 0);
else
    [sbeG, sbeNode] = getcurrentnetsession;
    retFname = retFname_old;
end

SetMenuStatus(handles);
set(handles.StatusBar, 'String', 'Ready');



% --------------------------------------------------------------------
function NetworkExit_Callback(hObject, eventdata, handles)
% hObject    handle to NetworkExit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

clear global sbeG sbeNode deduced_net retFname sbeG_ori sbeNode_ori;
clear functions;
writenetsession([], [], 'sbeVars');
writenetsession([], [], 'sbeLargeConnNet');
writenetsession([], [], 'sbeEdit');
close;


% --------------------------------------------------------------------
function HelpHelpContents_Callback(hObject, eventdata, handles)
% hObject    handle to HelpHelpContents (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%helpwin sbetoolbox;
%if ispc
%    help_dir = '.\\help\\';
%    if ((exist('.\\help', 'dir')) ~= 7)
%        help_dir = '..\\help\\';
%    end
%else
%    help_dir = './help/';
%    if ((exist('./help', 'dir')) ~= 7)
%        help_dir = '../help/';
%    end
%end
web('Contents.html', '-browser');
%web('http://sbetoolbox.sourceforge.net/Contents.html', '-browser');



% --------------------------------------------------------------------
function StatCentralityBetweenness_Callback(hObject, eventdata, handles)
% hObject    handle to StatCentralityBetweenness (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global sbeG sbeNode
set(handles.StatusBar, 'String', 'Busy');

if isbig(sbeG), h=waitbar(0.5, 'Please wait...'); end
%if isbig(sbeG), h=waitbar2a(0.5,'Please wait...', 'BarColor', 'g'); end

try
    data=betweenness_centrality(double(sparse(sbeG)));
    guiOutput = i_dispheader_gui('Betweenness Centrality', size(sbeG, 1));    

    for k=1:size(sbeG,1)
        guiHeaderOffset = k + 1;
        guiOutput{guiHeaderOffset} = sprintf('Node%04d\t%s\t%g',...
            k,sbeNode{k}, data(k));
        
    end
    guiOutput=i_dispfooter_gui(guiOutput);
    set(handles.WorkspaceOutput, 'String', guiOutput);
    i_conditionalexportresult(handles,data,sbeNode);
     %plot_histcurve(data, 1, 'Betweenness Centrality Distribution', ...
     %   'log_1_0(betweenness centrality)', 'nodes');
catch exception
    errordlg(exception.message);
    if exist('h','var'), close(h); end
    set(handles.StatusBar, 'String', 'Ready');
    return;
end
if isbig(sbeG), waitbar(1, h); end
if exist('h','var'), close(h); end


set(handles.StatusBar, 'String', 'Ready');


% --------------------------------------------------------------------
%{
function StatCentralityCurrentInformationFlow_Callback(hObject, eventdata, handles)
% hObject    handle to StatCentralityCurrentInformationFlow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global sbeG sbeNode
set(handles.StatusBar, 'String', 'Busy');

try
    warning off;
    [~,data]=current_info_flow(sbeG,1,true);
    guiOutput = i_dispheader_gui('Current Information Flow (Missiuro et al 2009)', ...
        size(sbeG, 1));
    for k=1:size(sbeG,1)
        guiHeaderOffset = k + 1;
        guiOutput{guiHeaderOffset} = sprintf('Node%04d\t%s\t%g',k,sbeNode{k},data(k));
    end
    guiOutput=i_dispfooter_gui(guiOutput);
    set(handles.WorkspaceOutput, 'String', guiOutput);
    i_conditionalexportresult(handles,data,sbeNode);
    warning on;
catch exception
    errordlg(exception.message);
    set(handles.StatusBar, 'String', 'Ready');
    warning on;
    return;
end
set(handles.StatusBar, 'String', 'Ready');
%}


% --------------------------------------------------------------------
function StatClusteringCoefficient_Callback(hObject, eventdata, handles)
% hObject    handle to StatClusteringCoefficient (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global sbeG sbeNode
set(handles.StatusBar, 'String', 'Busy');

if isbig(sbeG), h=waitbar(0.5, 'Please wait...'); end

%    h = waitbar(0,'1','Name','Computing Clustering Coefficient...',...
%            'CreateCancelBtn',...
%            'setappdata(gcbf,''canceling'',1)');
%    setappdata(h,'canceling',0)


try
    data=clustering_coefficients(double(sparse(sbeG)));
    guiOutput = i_dispheader_gui('Clustering Coefficient [CLUSTERING_COEFFICIENTS.m]', ...
        size(sbeG, 1));
    for k=1:size(sbeG,1)
        guiHeaderOffset = k + 1;
        guiOutput{guiHeaderOffset} = sprintf('Node%04d\t%s\t%g',k,sbeNode{k},data(k));        
    end
    guiOutput=i_dispfooter_gui(guiOutput);
    set(handles.WorkspaceOutput, 'String', guiOutput);
    i_conditionalexportresult(handles,data,sbeNode);
    
catch exception
    errordlg(exception.message);
    if exist('h','var'), close(h); end
    set(handles.StatusBar, 'String', 'Ready');
    return;
end

if isbig(sbeG), waitbar(1, h); end
if exist('h','var'), close(h); end

set(handles.StatusBar, 'String', 'Ready');


function i_conditionalexportresult(handles,data,nodename)
set(handles.StatusBar, 'String', 'Busy');
if (i_WantToExport(handles)),
    %filename=tempname;
    writeattribute2tab(data,nodename);
    %edit(filename);
end
if (i_WantToCopy(handles)),
    if iscell(data)
        warndlg(['Seems like the output is stored as Cell Array.',...
            ' Try to Save results or Export as a variable to Matlab workspace.'],...
            'Warning!');
        return;
    end
    selection = questdlg('Do you want to copy result into clipboard?',...
        'Pressing Yes will clear memory',...
        'Yes','No','No');
    switch selection,
        case 'Yes',
            num2clip(data);
        otherwise
            % do nothing
    end
end

if (i_WantToAssign(handles))
    export2wsdlg({'Assign node list to variable named:',...
        'Assign result to variable named:'},...
        {'sbeNode','sbeOut'},{nodename,data},...
        'Save to Workspace');
end
set(handles.StatusBar, 'String', 'Ready');


% --------------------------------------------------------------------
function Edit_Callback(hObject, eventdata, handles)
% hObject    handle to Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
SetMenuStatus(handles);

% --------------------------------------------------------------------
function Layout_Callback(hObject, eventdata, handles)
% hObject    handle to Layout (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
SetMenuStatus(handles);

% --------------------------------------------------------------------
function HelpDemo_Callback(hObject, eventdata, handles)
% hObject    handle to HelpDemo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
SetMenuStatus(handles);

% --------------------------------------------------------------------
function StatNetworkSummary_Callback(hObject, eventdata, handles)
% hObject    handle to StatNetworkSummary (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global sbeG;

guiOutput = i_dispheader_gui('Network Summary',2);
guiOutput = viewnetinfo_gui(sbeG, guiOutput);
guiOutput=i_dispfooter_gui(guiOutput);
set(handles.WorkspaceOutput, 'String', guiOutput);
set(handles.StatusBar, 'String', 'Ready');


%{
set(handles.StatusBar, 'String', 'Busy');

%[y]=issymmetric(sbeG);
%fprintf('Is symmetric: %d\n',y);

h=waitbar(0, 'Please wait...');
%try
    guiOutput = i_dispheader_gui('Network Summary', 7);
    waitbar(0.2, h);
    guiOutput = viewnetinfo_gui(sbeG, guiOutput);
    waitbar(0.4, h);
    guiOutput{4} = sprintf('Average Distance: %.3f',graph_meandist(sbeG));
    waitbar(0.6, h);
    [Diam,Rad]=graph_diameter(sbeG);
    waitbar(0.8, h);
    guiOutput{5} = sprintf('Diameter: %d',Diam);
    guiOutput{6} = sprintf('Radius: %d',Rad);
    guiOutput{7} = sprintf('Efficiency: %.3f',graph_efficiency(sbeG));
    waitbar(0.9, h);
%catch exception
%    errordlg(exception.message);
    %if exist('h','var'), close(h); end
    %set(handles.StatusBar, 'String', 'Ready');
    %return;
%end

if isbig(sbeG), waitbar(1, h); end
if exist('h','var'), close(h); end
set(handles.WorkspaceOutput, 'String', guiOutput);
set(handles.StatusBar, 'String', 'Ready');
%}


% --------------------------------------------------------------------
function StatDistanceBtw2Nodes_Callback(hObject, eventdata, handles)
% hObject    handle to StatDistanceBtw2Nodes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global sbeG sbeNode
set(handles.StatusBar, 'String', 'Busy');

%prompt={'Node 1:','Node 2:'};
%def={'1','2'};
%dlgTitle='Distance (Shortest Path) Between Nodes';
%lineNo=1;
%options.Resize='on';
%options.WindowStyle='normal';
%answer=inputdlg(prompt,dlgTitle,lineNo,def,options);

n1 = Search(sbeNode, 'Select node 1: ');
if ~n1, set(handles.StatusBar, 'String', 'Ready'); return; end
n2 = Search(sbeNode, 'Select node 2: ');

      %[n1,selected] = listdlg('Name','Nodes in network',...
      %                 'PromptString','Select node 1:',...
      %                 'SelectionMode','single',...
      %                 'ListString',sbeNode);
      %if ~selected, return; end                   
      %[n2,selected] = listdlg('Name','Nodes in network',...
      %                 'PromptString','Select node 2:',...
      %                 'SelectionMode','single',...
      %                 'ListString',sbeNode);
      % if ~selected, return; end 
      
 if n1>0 && n2>0
    %D=shortest_paths(double(sparse(sbeG)),n1);
    if isbig(sbeG), h=waitbar(0.5, 'Please wait...'); end
    try
        D=shortest_paths(double(sparse(sbeG)),n1,struct('target',n2));
        guiOutput = i_dispheader_gui(sprintf('Distance (Shortest Path)\nbetween %s and %s',...
                    sbeNode{n1},sbeNode{n2}),1);
        guiOutput{2} = sprintf('%d',D(n2));
        guiOutput=i_dispfooter_gui(guiOutput);
        set(handles.WorkspaceOutput, 'String', guiOutput);        
    catch exception
        errordlg(exception.message);
        if exist('h','var'), close(h); end
        set(handles.StatusBar, 'String', 'Ready');
        return;
    end
    if isbig(sbeG), waitbar(1, h); end
    if exist('h','var'), close(h); end
    
else
    set(handles.StatusBar, 'String', 'Ready');
    return;
end
set(handles.StatusBar, 'String', 'Ready');


% --------------------------------------------------------------------
function StatGraphAverageDistance_Callback(hObject, eventdata, handles)
% hObject    handle to StatGraphAverageDistance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global sbeG
set(handles.StatusBar, 'String', 'Busy');

if isbig(sbeG), h=waitbar(0.5, 'Please wait...'); end
try
    [out]=graph_meandist(sbeG);
catch exception
    errordlg(exception.message);
    if exist('h','var'), close(h); end
    set(handles.StatusBar, 'String', 'Ready');
    return;
end
if isbig(sbeG), waitbar(1, h); close(h); end

guiOutput = i_dispheader_gui(...
    'Average Graph Distance [GRAPH_MEANDIST.m]',0);
guiOutput{2} = sprintf('%g', out);
guiOutput=i_dispfooter_gui(guiOutput);
set(handles.WorkspaceOutput, 'String', guiOutput);
set(handles.StatusBar, 'String', 'Ready');


% --------------------------------------------------------------------
function StatGraphDiameter_Callback(hObject, eventdata, handles)
% hObject    handle to StatGraphDiameter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global sbeG
set(handles.StatusBar, 'String', 'Busy');

if isbig(sbeG), h=waitbar(0.5, 'Please wait...'); end
try
    if issparse(sbeG) && islogical(sbeG), sbeG=double(sbeG); end
    [out]=graph_diameter(sbeG);
    if issparse(sbeG) && ~islogical(sbeG), sbeG=logical(sbeG); end
catch exception
    errordlg(exception.message);
    if exist('h','var'), close(h); end
    set(handles.StatusBar, 'String', 'Ready');
    return;
end
if isbig(sbeG), waitbar(1, h); end
if exist('h','var'), close(h); end

guiOutput=i_dispheader_gui('Graph Diameter [GRAPH_DIAMETER.m]',0);
guiOutput{2} = sprintf('%g', out);
guiOutput=i_dispfooter_gui(guiOutput);
set(handles.WorkspaceOutput, 'String', guiOutput);
set(handles.StatusBar, 'String', 'Ready');


% --------------------------------------------------------------------
function ViewDistanceMatrix_Callback(hObject, eventdata, handles)
% hObject    handle to ViewDistanceMatrix (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global sbeG deduced_net
set(handles.StatusBar, 'String', 'Busy');
userWantsToLoadDeducedNetwork = loadDeducedClustersForPlotting(handles);

if (userWantsToLoadDeducedNetwork && ~isempty(deduced_net))
    plot_sbeG = deduced_net;
else
    plot_sbeG = sbeG;
end


if isbig(plot_sbeG), h=waitbar(0.5, 'Please wait...'); end
try
    [D]=all_shortest_paths(double(sparse(plot_sbeG)));
    figure;
    imagesc(D);
    axis square;
    x=gray; x=x(end:-1:1,:);
    colormap(x);
    colorbar;
catch exception
    errordlg(exception.message);
    if exist('h','var'), close(h); end
    set(handles.StatusBar, 'String', 'Ready');
    return;
end
if isbig(plot_sbeG), waitbar(1, h); end
if exist('h','var'), close(h); end

set(handles.StatusBar, 'String', 'Ready');

% --------------------------------------------------------------------
function NetworkNew_Callback(hObject, eventdata, handles)
% hObject    handle to NetworkNew (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global sbeG sbeNode retFname
set(handles.StatusBar, 'String', 'Busy');
retFname_old = retFname;
sbeG_ori_bNew = sbeG;
sbeNode_ori_bNew = sbeNode;

sbeNode = [];

g=graph_gui;
waitfor(g);

if getpref('SBEToolbox', 'graph_gui') == 1
    if ~isempty(sbeG)
        retFname = 'New network created !';
        guiOutput = i_dispheader_gui(retFname, 2);
        guiOutput = viewnetinfo_gui(sbeG, guiOutput);
        guiOutput=i_dispfooter_gui(guiOutput);
        set(handles.WorkspaceOutput, 'String', guiOutput);
        writenetsession(sbeG, sbeNode, 'sbeVars');
        setpref('SBEToolbox', 'filename', 'Drawn New Network');
    else
        [sbeG, sbeNode] = getcurrentnetsession;
    end
else
    retFname = retFname_old;
    sbeG = sbeG_ori_bNew;
    sbeNode = sbeNode_ori_bNew;
end

clear sbeG_ori_bNew sbeNode_ori_bNew;
SetMenuStatus(handles);
set(handles.StatusBar, 'String', 'Ready');

% --------------------------------------------------------------------
function ViewAdjacencyMatrix_Callback(hObject, eventdata, handles)
% hObject    handle to ViewAdjacencyMatrix (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global sbeG deduced_net
set(handles.StatusBar, 'String', 'Busy');
userWantsToLoadDeducedNetwork = loadDeducedClustersForPlotting(handles);

if (userWantsToLoadDeducedNetwork && ~isempty(deduced_net))
    plot_sbeG = deduced_net;
else
    plot_sbeG = sbeG;
end


if (size(plot_sbeG, 1) > 4000)
    h=waitbar(0, 'Please wait...');
end
try
    %guiOutput = i_dispheader_gui('Showing Adjacency Matrix ... ', ...
    %    size(sbeG, 1));
    %guiOutput = viewnetinfo_gui(sbeG, guiOutput);
    %for k = 1:size(sbeG, 1)
    %    guiHeaderOffset = k + 3;
    %    if issparse(sbeG(k,:))
    %        kr = full(sbeG(k,:));
    %    end
    %    guiOutput{guiHeaderOffset} = sprintf('%d',kr);
         %if (size(sbeG, 1) > 4000)
         %   waitbar(k/size(sbeG, 1), h);
         %end
    %end
    figure;
    dispadjmat(plot_sbeG);
    %spy(sbeG)
catch exception
    errordlg(exception.message);
    if exist('h','var'), close(h); end
    set(handles.StatusBar, 'String', 'Ready');
    return;
end
if (size(plot_sbeG, 1) > 4000)
    if exist('h','var'), close(h); end
end
%guiOutput=i_dispfooter_gui(guiOutput);
%set(handles.WorkspaceOutput, 'String', guiOutput);
%
set(handles.StatusBar, 'String', 'Ready');


% --------------------------------------------------------------------
function NetworkClose_Callback(hObject, eventdata, handles)
% hObject    handle to NetworkClose (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global sbeG sbeNode
sbeG=[]; sbeNode=[];
clear global sbeG sbeNode deduced_net
clear functions
%clearString = sprintf('\n%s\n%s\n', ...
%    'Function Output:',...
%    '=========================================');
set(handles.WorkspaceOutput, 'String', '');
SetMenuStatus(handles);
netCleared = sprintf('\n%s', 'Network cleared !');
set(handles.NetworkInformation, 'ForegroundColor', 'green');
%set(handles.NetworkInformation, 'ForegroundColor', [0, .6, 0]);
set(handles.NetworkInformation, 'String', netCleared);
setpref('SBEToolbox', 'largestconnnetCalled', 0);
setpref('SBEToolbox', 'isRestore', 0);
setpref('SBEToolbox', 'graph_gui', 0);
writenetsession([], [], 'sbeVars');
writenetsession([], [], 'sbeLargeConnNet');
writenetsession([], [], 'sbeEdit');
set(handles.StatusBar, 'String', 'Ready');


% --------------------------------------------------------------------
function StatCentralityInDegree_Callback(hObject, eventdata, handles)
% hObject    handle to StatCentralityInDegree (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global sbeG sbeNode
set(handles.StatusBar, 'String', 'Busy');

if isbig(sbeG), h=waitbar(0.5, 'Please wait...'); end
try
    data=sum(sbeG,2);
    guiOutput = i_dispheader_gui('Degree Centrality', size(sbeG, 1));
    
    for k=1:size(sbeG,1)
        guiHeaderOffset = k + 1;
        guiOutput{guiHeaderOffset} = sprintf('Node%04d\t%s\t%d',k, ...
            sbeNode{k}, full(data(k)));
    end
    
    guiOutput=i_dispfooter_gui(guiOutput);
	set(handles.WorkspaceOutput, 'String', guiOutput);
	i_conditionalexportresult(handles,data,sbeNode);
    %plot_histcurve(data, 1, 'Degree Centrality Distribution', ...
    %    'log_1_0(degree)', 'nodes');

catch exception
    errordlg(exception.message);
    if exist('h','var'), close(h); end
    set(handles.StatusBar, 'String', 'Ready');
    return;
end
if isbig(sbeG), waitbar(1, h); end
if exist('h','var'), close(h); end

set(handles.StatusBar, 'String', 'Ready');


% --------------------------------------------------------------------
function StatCentralityCloseness_Callback(hObject, eventdata, handles)
% hObject    handle to StatCentralityCloseness (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global sbeG sbeNode
set(handles.StatusBar, 'String', 'Busy');

if isbig(sbeG), h=waitbar(0.5, 'Please wait...'); end
try
    data=closeness_centrality(sbeG);
    guiOutput = i_dispheader_gui('Closeness Centrality', size(sbeG, 1));
    
    if exist('h', 'var'), waitbar(0.582, h); end;
    for k=1:size(sbeG,1)
        guiHeaderOffset = k + 1;
        guiOutput{guiHeaderOffset} = sprintf('Node%04d\t%s\t%g',k,...
            sbeNode{k}, full(data(k)));
    end
    guiOutput=i_dispfooter_gui(guiOutput);
set(handles.WorkspaceOutput, 'String', guiOutput);
i_conditionalexportresult(handles,data,sbeNode);
 %plot_histcurve(data, 1, 'Closeness Centrality Distribution', ...
 %       'log_1_0(closeness)', 'nodes');

catch exception
    errordlg(exception.message);
    if exist('h','var'), close(h); end
    set(handles.StatusBar, 'String', 'Ready');
    return;
end
if isbig(sbeG), waitbar(1, h); end
if exist('h','var'), close(h); end

set(handles.StatusBar, 'String', 'Ready');


% --------------------------------------------------------------------
function NetworkCreate_Callback(hObject, eventdata, handles)
% hObject    handle to NetworkCreate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function NetworkCreateSmallWorld_Callback(hObject, eventdata, handles)
% hObject    handle to NetworkCreateSmallWorld (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global sbeG sbeNode deduced_net retFname
set(handles.StatusBar, 'String', 'Busy');

   prompt={'Number of nodes:','Number of links a new node can make:'};
   def={'300','1'};
   dlgTitle='Generate Small-World Network';
   lineNo=1;
   answer=inputdlg(prompt, dlgTitle,...
       [lineNo, 60; lineNo, 60], def);
   if ~(isempty(answer)),
       n=str2double(answer{1});
       p=str2double(answer{2});       
       [sbeG,sbeNode]=randnet_sw(n,p);
       writenetsession(sbeG, sbeNode, 'sbeVars');
       setpref('SBEToolbox', 'isRestore', 0);
       setpref('SBEToolbox', 'largestconnnetCalled', 0);
       setpref('SBEToolbox', 'filename', 'RandNet - Small World');
   else
       set(handles.StatusBar, 'String', 'Ready');
       return;
   end
   guiOutput = i_dispheader_gui('Random network ( Small World ) created!',...
       2);
   guiOutput = viewnetinfo_gui(sbeG, guiOutput);
   guiOutput=i_dispfooter_gui(guiOutput);
   
   set(handles.WorkspaceOutput, 'String', guiOutput);  
      
   if ~isempty(deduced_net)
       clear global deduced_net;
   end

retFname = 'RandNet - Small World';
SetMenuStatus(handles)
set(handles.StatusBar, 'String', 'Ready');



% --------------------------------------------------------------------
function NetworkCreateErdosRenyi_Callback(hObject, eventdata, handles)
% hObject    handle to NetworkCreateErdosRenyi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global sbeG sbeNode deduced_net retFname

set(handles.StatusBar, 'String', 'Busy');

   prompt={'Number of vertices:','Probability of each edge:'};
   def={'100','0.05'};
   dlgTitle='Generate Erdös-Réyni Network';
   lineNo=1;
   answer=inputdlg(prompt, dlgTitle, ...
       [lineNo, 60; lineNo, 60], def);
   if ~(isempty(answer)),
       n=str2double(answer{1});
       p=str2double(answer{2});
       [sbeG,sbeNode]=randnet_er(n,p);
       writenetsession(sbeG, sbeNode, 'sbeVars');
       setpref('SBEToolbox', 'isRestore', 0);
       setpref('SBEToolbox', 'largestconnnetCalled', 0);
       setpref('SBEToolbox', 'filename', 'RandNet - Erdös-Réyni');
   else
       set(handles.StatusBar, 'String', 'Ready');
       return;
   end
   guiOutput = i_dispheader_gui('Random network ( Erdös-Réyni ) created!',...
       2);
   guiOutput = viewnetinfo_gui(sbeG, guiOutput);
   guiOutput=i_dispfooter_gui(guiOutput);   
   set(handles.WorkspaceOutput, 'String', guiOutput);
   if ~isempty(deduced_net)
       clear global deduced_net;
   end
   
retFname = 'RandNet - Erdös-Réyni';
SetMenuStatus(handles)

set(handles.StatusBar, 'String', 'Ready');

% --------------------------------------------------------------------
function NetworkCreateRingLattice_Callback(hObject, eventdata, handles)
% hObject    handle to NetworkCreateRingLattice (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global sbeG sbeNode deduced_net retFname
set(handles.StatusBar, 'String', 'Busy');

    prompt = {'Number of Nodes:',...
        'Number of connections each Node can make:',...
        'Watts and Strogatz Probability (ß):'};
    def={'20', '4', '0'};
    dlgTitle = 'Generate Ring Lattice Network';
    num_lines = 1;
    answer = inputdlg(prompt, dlgTitle, ...
        [num_lines, 70; num_lines, 70; num_lines, 70], def);
    if ~(isempty(answer))
        nodes = str2double(answer{1});
        degree = str2double(answer{2});
        prob = str2double(answer{3});
        
        if (nodes < 10)
            errordlg('Number of nodes should be at least 10', 'Ring Lattice Input Error!');
            set(handles.StatusBar, 'String', 'Ready');
            return;
        end
        
        if (mod(degree, 2) ~= 0)
            errordlg('All nodes must have an even degree', 'Ring Lattice Input Error!');
            set(handles.StatusBar, 'String', 'Ready');
            return;
        end
        if (prob < 0 || prob > 1)
            errordlg('Probability must be between 0 and 1', 'Ring Lattice Input Error!');
            set(handles.StatusBar, 'String', 'Ready');
            return;
        end        
        [sbeG, sbeNode] = randnet_rl(nodes, degree, prob);
        writenetsession(sbeG, sbeNode, 'sbeVars');
        setpref('SBEToolbox', 'isRestore', 0);
        setpref('SBEToolbox', 'largestconnnetCalled', 0);
        setpref('SBEToolbox', 'filename', 'RandNet - Ring Lattice');
    else
        set(handles.StatusBar, 'String', 'Ready');
        return;
    end
    
    guiOutput = i_dispheader_gui('Random network ( Ring Lattice ) created!',...
       2);
   guiOutput = viewnetinfo_gui(sbeG, guiOutput);
   guiOutput=i_dispfooter_gui(guiOutput);
   set(handles.WorkspaceOutput, 'String', guiOutput);  
      
   if ~isempty(deduced_net)
       clear global deduced_net;
   end
retFname = 'RandNet - Ring Lattice';
SetMenuStatus(handles)

set(handles.StatusBar, 'String', 'Ready');


% --------------------------------------------------------------------
function EditAddEdge_Callback(hObject, eventdata, handles)
% hObject    handle to EditAddEdge (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global sbeG sbeNode retFname
set(handles.StatusBar, 'String', 'Busy');
retFname_old = retFname;
sbeG_bEdit = sbeG;
sbeNode_bEdit = sbeNode;

xy=fruchterman_reingold_force_directed_layout(double(sparse(sbeG)));
g=graph_gui(sbeG,xy,1,0,0,1);
waitfor(g);

if getpref('SBEToolbox', 'graph_gui') == 1
    if ~isempty(sbeG)
        retFname = 'Network edited ( Edge(s) added ) !';
        guiOutput = i_dispheader_gui(retFname, 2);
        guiOutput = viewnetinfo_gui(sbeG, guiOutput);
        guiOutput=i_dispfooter_gui(guiOutput);
        set(handles.WorkspaceOutput, 'String', guiOutput);
        if ~ispref('SBEToolbox', 'isRestore'), addpref('SBEToolbox', 'isRestore', ''); end
        setpref('SBEToolbox', 'isRestore', 1);
        setpref('SBEToolbox', 'largestconnnetCalled', 0);
        writenetsession(sbeG, sbeNode, 'sbeEdit');
    end
else
    retFname = retFname_old;
    sbeG = sbeG_bEdit;
    sbeNode = sbeNode_bEdit;
end

clear sbeG_bEdit sbeNode_bEdit;
SetMenuStatus(handles);
set(handles.StatusBar, 'String', 'Ready');


% --------------------------------------------------------------------
function EditRemoveEdge_Callback(hObject, eventdata, handles)
% hObject    handle to EditRemoveEdge (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global sbeG sbeNode retFname
set(handles.StatusBar, 'String', 'Busy');
retFname_old = retFname;
sbeG_bEdit = sbeG;
sbeNode_bEdit = sbeNode;

xy=fruchterman_reingold_force_directed_layout(double(sparse(sbeG)));
g=graph_gui(sbeG,xy,0,1,0,1);
waitfor(g);

if getpref('SBEToolbox', 'graph_gui') == 1
    if ~isempty(sbeG)
        retFname = 'Network edited ( Edge(s) removed )!';
        guiOutput = i_dispheader_gui(retFname, 2);
        guiOutput = viewnetinfo_gui(sbeG, guiOutput);
        guiOutput=i_dispfooter_gui(guiOutput);
        set(handles.WorkspaceOutput, 'String', guiOutput);
        if ~ispref('SBEToolbox', 'isRestore'), addpref('SBEToolbox', 'isRestore', ''); end
        setpref('SBEToolbox', 'isRestore', 1);
        setpref('SBEToolbox', 'largestconnnetCalled', 0);
        writenetsession(sbeG, sbeNode, 'sbeEdit');
    end
else
    retFname = retFname_old;
    sbeG = sbeG_bEdit;
    sbeNode = sbeNode_bEdit;
end

clear sbeG_bEdit sbeNode_bEdit;
SetMenuStatus(handles);
set(handles.StatusBar, 'String', 'Ready');


% --------------------------------------------------------------------
function EditSymmetrizeAdjacencyMatrix_Callback(hObject, eventdata, handles)
% hObject    handle to EditSymmetrizeAdjacencyMatrix (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global sbeG
set(handles.StatusBar, 'String', 'Busy');

if issymmetric(sbeG)
    set(hObject,'enable','off');
end
if ~issymmetric(sbeG)
    [sbeG]=symmetrizeadjmat(sbeG);
    msgbox('Adjacency matrix (sbeG) has been symmetrized.','help');
end

set(handles.StatusBar, 'String', 'Ready');

% --------------------------------------------------------------------
function EditAddNode_Callback(hObject, eventdata, handles)
% hObject    handle to EditAddNode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global sbeG sbeNode retFname
set(handles.StatusBar, 'String', 'Busy');
retFname_old = retFname;
sbeG_bDraw = sbeG;
sbeNode_bDraw = sbeNode;

xy=fruchterman_reingold_force_directed_layout(double(sparse(sbeG)));
g=graph_gui(sbeG,xy,1,0,1,0);
waitfor(g);

if getpref('SBEToolbox', 'graph_gui') == 1
    if ~isempty(sbeG)
        retFname = 'Network edited ( Node(s) added ) !';
        guiOutput = i_dispheader_gui(retFname, 2);
        guiOutput = viewnetinfo_gui(sbeG, guiOutput);
        guiOutput=i_dispfooter_gui(guiOutput);
        set(handles.WorkspaceOutput, 'String', guiOutput);
        if ~ispref('SBEToolbox', 'isRestore'), addpref('SBEToolbox', 'isRestore', ''); end
        setpref('SBEToolbox', 'isRestore', 1);
        setpref('SBEToolbox', 'largestconnnetCalled', 0);
        writenetsession(sbeG, sbeNode, 'sbeEdit');
    end
else
    retFname = retFname_old;
    sbeG = sbeG_bDraw;
    sbeNode = sbeNode_bDraw;
end

clear sbeG_bDraw sbeNode_bDraw;
SetMenuStatus(handles);
set(handles.StatusBar, 'String', 'Ready');


% --------------------------------------------------------------------
function EditRemoveNode_Callback(hObject, eventdata, handles)
% hObject    handle to EditRemoveNode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global sbeG sbeNode retFname
set(handles.StatusBar, 'String', 'Busy');

      %[n1,b] = listdlg('Name','Select a node','PromptString','Select a node to remove:',...
      %                 'SelectionMode','single',...
      %                 'ListString',sbeNode);
n1 = Search(sbeNode, 'Select a node to remove');
if n1
      if n1>num_vertices(sbeG)
          errordlg(sprintf('Index exceeds matrix dimensions %d',num_vertices(sbeG)));
       else
           %i_dispheader('Information of Node')
           %fprintf('Node %d: %s\n', n1, sbeNode{n1});
        selection = questdlg('Remove or Disconnect Node?',...
                             'Remove Node',...
                             'Remove','Disconnect','Cancel','Remove');
                         switch selection
                             case 'Remove'
                                 sbeG(n1,:)=[];
                                 sbeG(:,n1)=[];
                                 sbeNode(n1)=[];
                             case 'Disconnect'
                                 sbeG(n1,:)=false;
                                 sbeG(:,n1)=false;
                             otherwise
                                 set(handles.StatusBar, 'String', 'Ready');
                                 return;
                         end
                         guiOutput = i_dispheader_gui('Network edited ( Node(s) removed / disconnected ) !',...
                             2);
                         guiOutput = viewnetinfo_gui(sbeG, guiOutput);
                         guiOutput=i_dispfooter_gui(guiOutput);
                         set(handles.WorkspaceOutput, 'String', guiOutput);  
                         if ~ispref('SBEToolbox', 'isRestore'), addpref('SBEToolbox', 'isRestore', ''); end
                         setpref('SBEToolbox', 'isRestore', 1);
                         setpref('SBEToolbox', 'largestconnnetCalled', 0);
                         writenetsession(sbeG, sbeNode, 'sbeEdit');
      end
else
    set(handles.StatusBar, 'String', 'Ready');
    return;
end

retFname = 'Network edited ( Node(s) removed / disconnected ) !';
SetMenuStatus(handles);
set(handles.StatusBar, 'String', 'Ready');


% --------------------------------------------------------------------
function HelpWebsite_Callback(hObject, eventdata, handles)
% hObject    handle to HelpWebsite (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.StatusBar, 'String', 'Busy');

try
    web('https://github.com/biocoder/SBEToolbox/releases', '-browser')
catch exception
    errordlg(exception.message);
    set(handles.StatusBar, 'String', 'Ready');
    return;
end

set(handles.StatusBar, 'String', 'Ready');


% --------------------------------------------------------------------
function HelpCheckLatest_Callback(hObject, eventdata, handles)
% hObject    handle to HelpCheckLatest (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function HelpCitation_Callback(hObject, eventdata, handles)
% hObject    handle to HelpCitation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function HelpAbout_Callback(hObject, eventdata, handles)
% hObject    handle to HelpAbout (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.StatusBar, 'String', 'Busy');

sbeversionstr='1.3.2';
info{1}='Systems Biology & Evolution Toolbox  (SBEToolbox)';
info{2}='';
info{3}=sprintf(' Version: %s', sbeversionstr);
info{4}='';
info{5}=' Authors:  Kranti Konganti and James Cai';
info{6}='';
info{7}=' Code Contributions:  Gang Wang and Ence Yang';
info{8}='';
info{9} = ' (C) Texas A&M University,  All Rights Reserved.';
info{10}='';
info{11}=' Please cite us when using this software as part of your research.';
info{12} ='';
info{13} =' ASCII Art: Sydney Harper';
info{14} ='';
helpdlg(info,' About SBEToolbox');

set(handles.StatusBar, 'String', 'Ready');


% --------------------------------------------------------------------
function NetworkImport_Callback(hObject, eventdata, handles)
% hObject    handle to NetworkImportAdjacencyMatrix (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function NetworkExport_Callback(hObject, eventdata, handles)
% hObject    handle to NetworkExportAdjacencyMatrix (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function NetworkExportAdjacencyMatrix_Callback(hObject, eventdata, handles)
% hObject    handle to NetworkExportAdjacencyMatrix (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global sbeG
set(handles.StatusBar, 'String', 'Busy');

if isbig(sbeG), h=waitbar(0.5, 'Please wait...'); end
try
    writeadjmat2mat(sbeG);
catch exception
    errordlg(exception.message);
    if exist('h','var'), close(h); end
    set(handles.StatusBar, 'String', 'Ready');
    return;
end
if isbig(sbeG), waitbar(1, h); end
if exist('h','var'), close(h); end

guiOutput{1} = 'Network exported !';
set(handles.WorkspaceOutput, 'String', guiOutput);

SetMenuStatus(handles);
set(handles.StatusBar, 'String', 'Ready');


% --------------------------------------------------------------------
function NetworkAssignGlobalVariablesToWorkSpace_Callback(hObject, eventdata, handles)
% hObject    handle to NetworkAssignGlobalVariablesToWorkSpace (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global sbeG sbeNode
set(handles.StatusBar, 'String', 'Busy');

try
    if ~isempty(sbeG),
    %assignin('base','sbeG', sbeG);
    %assignin('base','sbeNode', sbeNode);
    %helpdlg('Adjecency matrix and info has been assigned as sbeG and sbeNode',...
    %        'Assign varibles into workspace')
    export2wsdlg({'Assign adjecency matrix to variable named:',...
        'Assign node list to variable named:'},...
        {'sbeG','sbeNode'},{sbeG,sbeNode},...
        'Save to Workspace');
    else
        warndlg('Adjecency matrix is empty.','Save to Workspace')
    end
catch exception
    errordlg(exception.message);
    set(handles.StatusBar, 'String', 'Ready');
    return;
end

set(handles.StatusBar, 'String', 'Ready');


% --------------------------------------------------------------------
function LayoutRandom_Callback(hObject, eventdata, handles)
% hObject    handle to LayoutRandom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global sbeG sbeNode
set(handles.StatusBar, 'String', 'Busy');

try
    xy=random_graph_layout(sbeG);
    overviewplot;
    alwaysViewAns = isAlwaysViewChecked(handles);
    plotnet(sbeG,xy,sbeNode, alwaysViewAns);
catch exception
    errordlg(exception.message)
end

set(handles.StatusBar, 'String', 'Ready');

% --------------------------------------------------------------------
function ExtractLargestConnectedNetwork_Callback(hObject, eventdata, handles)
% hObject    handle to ExtractLargestConnectedNetwork (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global sbeG sbeNode retFname
set(handles.StatusBar, 'String', 'Busy');

[sbeG,idx] = largest_component(sbeG);
sbeNode=sbeNode(idx);

guiOutput = i_dispheader_gui('Largest connected network extracted!',...
                              2);
guiOutput = viewnetinfo_gui(sbeG, guiOutput);
guiOutput = i_dispfooter_gui(guiOutput);

retFname = regexprep(retFname, ...
    'Largest connected network within ', '');
retFname = ['Largest connected network within ', retFname];

if ~ispref('SBEToolbox', 'largestconnnetCalled')
    addpref('SBEToolbox', 'largestconnnetCalled');
end
if ~ispref('SBEToolbox', 'isRestore')
    addpref('SBEToolbox', 'isRestore', '');
end

setpref('SBEToolbox', 'isRestore', 1);
setpref('SBEToolbox', 'largestconnnetCalled', 1);
writenetsession(sbeG, sbeNode, 'sbeLargeConnNet');
set(handles.WorkspaceOutput, 'String', guiOutput);  
SetMenuStatus(handles);
set(handles.StatusBar, 'String', 'Ready');

% --------------------------------------------------------------------
function EditExtractSubnetworkAroundNode_Callback(hObject, eventdata, handles)
% hObject    handle to EditExtractSubnetworkAroundNode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global sbeG sbeNode retFname
set(handles.StatusBar, 'String', 'Busy');

      %[n1,b] = listdlg('PromptString','Select a node:',...
      %                 'SelectionMode','single',...
      %                 'ListString',sbeNode);
n1 = Search(sbeNode, 'Select a node:');

if n1
      if n1>num_vertices(sbeG)
          errordlg(sprintf('Index exceeds matrix dimensions %d',num_vertices(sbeG)));
      else
           extractedAroundNode = sbeNode{n1};
           prompt={['Index of node ( ', ...
               char(sbeNode{n1}), ' ) :'] ,'Graph distance cutoff:'};
           def={sprintf('%d',n1),'2'};
           dlgTitle='Node and cutoff';
           lineNo=1;
           answer=inputdlg(prompt,dlgTitle,lineNo,def);
           if ~(isempty(answer)),
               nodeid=str2double(answer{1});
               distcutoff=str2double(answer{2});
               [sbeG,sbeNode]=extractnode(sbeG,sbeNode,nodeid,distcutoff);
               writenetsession(sbeG, sbeNode, 'sbeEdit');
               if ~issparse(sbeG), sbeG = sparse(sbeG); end
               retFname = ['Extracted subnetwork around node ( ', ...
                   extractedAroundNode, ' ) !'];
                guiOutput = i_dispheader_gui(retFname, size(sbeG, 1));
                guiOutput = viewnetinfo_gui(sbeG, guiOutput);
                guiOutput{4} = guiOutput{3};
                guiOutput{3} = guiOutput{2};
                guiOutput{2} = sprintf('Subnetwork around selected Node ( %d ): %s',...
                    n1, extractedAroundNode);                
                guiOutput{5} = sprintf('%s\n', ...
                    '=======================================');
                set(handles.WorkspaceOutput, 'String', guiOutput);
                if ~ispref('SBEToolbox', 'isRestore'), addpref('SBEToolbox', 'isRestore', ''); end
                setpref('SBEToolbox', 'isRestore', 1);
                setpref('SBEToolbox', 'largestconnnetCalled', 0);
           end
      end     
end
SetMenuStatus(handles);
set(handles.StatusBar, 'String', 'Ready');


% --------------------------------------------------------------------
function EditRestoreNetwork_Callback(hObject, eventdata, handles)
% hObject    handle to EditRestoreNetwork (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global sbeG sbeNode retFname

[sbeG, sbeNode] = readnetsession('sbeVars');
setpref('SBEToolbox', 'isRestore', 0);
guiOutput = i_dispheader_gui('Network restored!', 2);
guiOutput = viewnetinfo_gui(sbeG, guiOutput);
retFname = ['Network restored ( ', getpref('SBEToolbox', 'filename'), ' ) !'];
guiOutput = i_dispfooter_gui(guiOutput);
set(handles.WorkspaceOutput, 'String', guiOutput);
set(handles.StatusBar, 'String', 'Ready');
setpref('SBEToolbox', 'NetEvolMsg', 9999999999);
SetMenuStatus(handles);


% --------------------------------------------------------------------
function EditBrowseNodeList_Callback(hObject, eventdata, handles)
% hObject    handle to EditBrowseNodeList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global sbeG sbeNode


%      [n1,b] = listdlg('Name','Nodes in network',...
%                       'PromptString','Select a node for details:',...
%                       'SelectionMode','single',...
%                       'ListString',sbeNode);

set(handles.StatusBar, 'String', 'Busy');
n1 = Search(sbeNode, 'Select a node to view it''s vicinity details');
if n1
      if n1>num_vertices(sbeG)
          errordlg(sprintf('Index exceeds matrix dimensions %d',num_vertices(sbeG)));
       else
           guiOutput = i_dispheader_gui('Information of Nodes',3);
           guiOutput{2} = sprintf('Node%04d: %s', n1, sbeNode{n1});
           idx=find(sbeG(n1,:));
           if ~isempty(idx)
               guiOutput{3} = sprintf('\nNumber of neighbor nodes: %d\n\nList of neighbor nodes: ',...
                       numel(idx));
               for nodeIdx = 1:length(idx)
                   guiOutput{end+1} = sprintf('%s',sbeNode{idx(nodeIdx)});
               end
           else
               guiOutput{3} = sprintf('Number of neighbor nodes: 0');
           end
           guiOutput=i_dispfooter_gui(guiOutput);
           set(handles.WorkspaceOutput, 'String', guiOutput);  
       end
end

set(handles.StatusBar, 'String', 'Ready');


% --------------------------------------------------------------------
function EditAnnotateNodeList_Callback(hObject, eventdata, handles)
% hObject    handle to EditAnnotateNodeList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global sbeG

set(handles.StatusBar, 'String', 'Busy');
annotate_nodes;
guiOutput = i_dispheader_gui('Network Summary',2);
guiOutput = viewnetinfo_gui(sbeG, guiOutput);
guiOutput=i_dispfooter_gui(guiOutput);
set(handles.WorkspaceOutput, 'String', guiOutput);
set(handles.StatusBar, 'String', 'Ready');

SetMenuStatus(handles);


% --------------------------------------------------------------------
function EditGetAnnotation_Callback(hObject, eventdata, handles)
% hObject    handle to EditGetAnnotation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global sbeNode
set(handles.StatusBar, 'String', 'Busy');
nodeIdx = Search(sbeNode, 'Select a node to get short annotation');
if nodeIdx == 0; set(handles.StatusBar, 'String', 'Ready'); return; end;
if exist('sbeAnnotSpecies', 'var') && isempty(sbeAnnotSpecies)
    h = waitbar(0.25, 'Please wait... Loading annotation...');
else
    h = waitbar(0.5, 'Please wait... Annotating node(s)...');
end
guiOutput = i_dispheader_gui('Node Annotation', 1);
guiOutput{3} = sprintf('%s\t%s', sbeNode{nodeIdx}, ...
    char(annotate_nodes(nodeIdx)));
guiOutput=i_dispfooter_gui(guiOutput);
set(handles.WorkspaceOutput, 'String', guiOutput);
waitbar(1, h, 'Done !')
if exist('h', 'var'), close(h); end
set(handles.StatusBar, 'String', 'Ready');


% --------------------------------------------------------------------
function EditGetAnnotationMulitplNodes_Callback(hObject, eventdata, handles)
% hObject    handle to EditGetAnnotationMulitplNodes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global sbeNode
set(handles.StatusBar, 'String', 'Busy');
nodeIdxs = SelectionGUI(sbeNode);
if nodeIdxs <= 0; set(handles.StatusBar, 'String', 'Ready'); return; end;
if isempty(nodeIdxs); set(handles.StatusBar, 'String', 'Ready'); return; end;

if exist('sbeAnnotSpecies', 'var') && isempty(sbeAnnotSpecies)
    h = waitbar(0.25, 'Please wait... Loading annotation...');
else
    h = waitbar(0.5, 'Please wait... Annotating node(s)...');
end
guiOutput = i_dispheader_gui('Node Annotation', 1);
for i = 1:numel(nodeIdxs)
    guiOutput{end + 1} = sprintf('%s\t%s\n', sbeNode{nodeIdxs(i)}, ...
        char(annotate_nodes(nodeIdxs(i))));
end
guiOutput=i_dispfooter_gui(guiOutput);
set(handles.WorkspaceOutput, 'String', guiOutput);
waitbar(1, h, 'Done !')
if exist('h', 'var'), close(h); end
set(handles.StatusBar, 'String', 'Ready');

% --------------------------------------------------------------------
function LayoutCircle_Callback(hObject, eventdata, handles)
% hObject    handle to LayoutCircle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global sbeG sbeNode
set(handles.StatusBar, 'String', 'Busy');

try
    [xy]=circle_layout(sbeG);
    overviewplot;
    alwaysViewAns = isAlwaysViewChecked(handles);
    plotnet(sbeG,xy,sbeNode, alwaysViewAns);
catch exception
    errordlg(exception.message)
end

set(handles.StatusBar, 'String', 'Ready');


% --------------------------------------------------------------------
function LayoutFruchtermanReingold_Callback(hObject, eventdata, handles)
% hObject    handle to LayoutFruchtermanReingold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global sbeG sbeNode deduced_net
set(handles.StatusBar, 'String', 'Busy');
alwaysViewAns = isAlwaysViewChecked(handles);
userWantsToLoadDeducedNetwork = loadDeducedClustersForPlotting(handles);

if (userWantsToLoadDeducedNetwork && ~isempty(deduced_net))
    plot_sbeG = deduced_net;
else
    plot_sbeG = sbeG;
end

prompt={'Iterations:'};
   def={'200'};
   dlgTitle='Layout Options';
   lineNo=1;
   answer=inputdlg(prompt,dlgTitle, ...
       [lineNo, 50], def);
   if ~(isempty(answer)),
       n1=str2double(answer{1});
       if mod(n1, 1) ~= 0
          errordlg('Invalid Iterations');
       else
           if ~issymmetric(plot_sbeG)
               [plot_sbeG]=symmetrizeadjmat(plot_sbeG);
           end
           if n1 >= 500, h=waitbar(0.5, ['Please wait... Running Frucherman-Reingold layout for ', num2str(n1), ' iterations']); end
           try
               xy=fruchterman_reingold_force_directed_layout(double(sparse(plot_sbeG)),...
                   'iterations',n1);
               overviewplot;
               plotnet(plot_sbeG,xy,sbeNode, alwaysViewAns);
           catch exception
               errordlg(exception.message)
           end
           if n1 > 500, waitbar(1, h); end
           if exist('h','var'), close(h); end
       end
   end
   
set(handles.StatusBar, 'String', 'Ready');

% --------------------------------------------------------------------
function LayoutGursoyAtun_Callback(hObject, eventdata, handles)
% hObject    handle to LayoutGursoyAtun (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global sbeG sbeNode
set(handles.StatusBar, 'String', 'Busy');

try
    xy=gursoy_atun_layout(double(sparse(sbeG)));
    overviewplot;
    alwaysViewAns = isAlwaysViewChecked(handles);
    plotnet(sbeG,xy,sbeNode,alwaysViewAns);
catch exception
    errordlg(exception.message)
end

set(handles.StatusBar, 'String', 'Ready');


% --------------------------------------------------------------------
function LayoutKamadaKawaiSpring_Callback(hObject, eventdata, handles)
% hObject    handle to LayoutKamadaKawaiSpring (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global sbeG sbeNode
set(handles.StatusBar, 'String', 'Busy');

if ~issymmetric(sbeG)
    [sbeG]=symmetrizeadjmat(sbeG);
end

if isbig(sbeG), h=waitbar(0.5, 'Please wait...'); end
try
    xy=kamada_kawai_spring_layout(double(sparse(sbeG)));
catch exception
    errordlg(exception.message);
    if exist('h','var'), close(h); end
    set(handles.StatusBar, 'String', 'Ready');
    return;
end
if isbig(sbeG), waitbar(1, h); end
if exist('h','var'), close(h); end

try
    overviewplot;
    alwaysViewAns = isAlwaysViewChecked(handles);
    plotnet(sbeG,xy,sbeNode, alwaysViewAns);
catch exception
    errordlg(exception.message)
end

set(handles.StatusBar, 'String', 'Ready');


% --------------------------------------------------------------------
function ViewPowerLawDegreeDistribution_Callback(hObject, eventdata, handles)
% hObject    handle to ViewPowerLawDegreeDistribution (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global sbeG
set(handles.StatusBar, 'String', 'Busy');

if isbig(sbeG), h=waitbar(0.5, 'Please wait...'); end

try
    figure;
    powerlawplot(single(full(sbeG)));
    %PL_Equation = powerlawplot(single(sbeG));
    %assignin('base','lastans',PL_Equation);
catch exception
    errordlg(exception.message);
    if exist('h','var'), close(h); end
    set(handles.StatusBar, 'String', 'Ready');
    return;
end

if isbig(sbeG), waitbar(1, h); end
if exist('h','var'), close(h); end

set(handles.StatusBar, 'String', 'Ready');


% --------------------------------------------------------------------
function NetworkOpenTABFile_Callback(hObject, eventdata, handles)
% hObject    handle to NetworkOpenTABFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global sbeG sbeNode deduced_net retFname
set(handles.StatusBar, 'String', 'Busy');
retFname_old = retFname;

[sbeG,sbeNode,retFname]=readtab2sbe;
sbeG = sparse(sbeG);

if ~isempty(sbeG)
    guiOutput = i_dispheader_gui(['Network loaded from TAB delimited file ( ',...
        retFname, ' ) !'], 2);
    guiOutput = viewnetinfo_gui(sbeG, guiOutput);
    guiOutput=i_dispfooter_gui(guiOutput);
    set(handles.WorkspaceOutput, 'String', guiOutput);  
    writenetsession(sbeG, sbeNode, 'sbeVars');
    setpref('SBEToolbox', 'isRestore', 0);
    setpref('SBEToolbox', 'largestconnnetCalled', 0);
else
    [sbeG, sbeNode] = getcurrentnetsession;
    retFname = retFname_old;
end

if ~isempty(deduced_net)
    clear global deduced_net;
end

SetMenuStatus(handles);
set(handles.StatusBar, 'String', 'Ready');


% --------------------------------------------------------------------
function NetworkOpenSIFFile_Callback(hObject, eventdata, handles)
% hObject    handle to NetworkOpenSIFFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global sbeG sbeNode deduced_net retFname
set(handles.StatusBar, 'String', 'Busy');
retFname_old = retFname;

[sbeG,sbeNode,retFname]=readsif2sbe;
sbeG = sparse(sbeG);

if ~isempty(sbeG)
    guiOutput = i_dispheader_gui('Network loaded from SIF format file!',...
        2);
    guiOutput = viewnetinfo_gui(sbeG, guiOutput);
    guiOutput=i_dispfooter_gui(guiOutput);
    set(handles.WorkspaceOutput, 'String', guiOutput);  
    writenetsession(sbeG, sbeNode, 'sbeVars');
    setpref('SBEToolbox', 'isRestore', 0);
    setpref('SBEToolbox', 'largestconnnetCalled', 0);
else
    [sbeG, sbeNode] = getcurrentnetsession;
    retFname = retFname_old;
end

if ~isempty(deduced_net)
    clear global deduced_net;
end

SetMenuStatus(handles);
set(handles.StatusBar, 'String', 'Ready');


% --------------------------------------------------------------------
function NetworkOpenPajekFile_Callback(hObject, eventdata, handles)
% hObject    handle to NetworkOpenPajekFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global sbeG sbeNode deduced_net retFname
set(handles.StatusBar, 'String', 'Busy');
retFname_old = retFname;

[sbeG,sbeNode,retFname] = readpajek2sbe;
sbeG = sparse(sbeG);

if ~isempty(sbeG)
    guiOutput = i_dispheader_gui('Network loaded from PAJEK delimited file!',...
        2);
    guiOutput = viewnetinfo_gui(sbeG, guiOutput);
    guiOutput=i_dispfooter_gui(guiOutput);
    set(handles.WorkspaceOutput, 'String', guiOutput);  
    writenetsession(sbeG, sbeNode, 'sbeVars');
    setpref('SBEToolbox', 'isRestore', 0);
    setpref('SBEToolbox', 'largestconnnetCalled', 0);
else
    [sbeG, sbeNode] = getcurrentnetsession;
    retFname = retFname_old;
end

if ~isempty(deduced_net)
    clear global deduced_net;
end

SetMenuStatus(handles);
set(handles.StatusBar, 'String', 'Ready');


% --------------------------------------------------------------------
function NetworkImportAdjacencyMatrix_Callback(hObject, eventdata, handles)
% hObject    handle to NetworkImportAdjacencyMatrix (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global sbeG sbeNode retFname
set(handles.StatusBar, 'String', 'Busy');

if ispref('SBEToolbox', 'fileimportexportmat') 
    prevPath = getpref('SBEToolbox', 'fileimportexportmat');
else    
    prevPath = '';
    addpref('SBEToolbox', 'fileimportexportmat', pwd);
end

[filename, pathname] = uigetfile( ...
    {'*.tab', 'Tab delimited file (*.tab)'; '*.mat', ...
    'Matrix File (*.mat)'; '*.csv', 'Comma delimited file (*.csv)'; '*.*',...
    'All Files (*.*)'},...
    'Select a file containing Adjacency Matrix', prevPath);
retFname = filename;

if pathname ~= 0
    setpref('SBEToolbox', 'fileimportexportmat', pathname);
end

if isequal(filename, 0)
    set(handles.StatusBar, 'String', 'Ready');
    retFname = '';
    return;
else
    filename = [pathname,filename];
    try
        if regexpi(filename, '^*\Wmat$')
            sbeGStruct = load(filename);
            sbeG = sbeGStruct.sbeG.sbeG;
            sbeNode = sbeGStruct.sbeG.sbeNode;
            writenetsession(sbeG, sbeNode, 'sbeVars');
            setpref('SBEToolbox', 'isRestore', 0);
        else
            sbeG = load(filename, '-ascii');
            writenetsession(sbeG, [], 'sbeVars');
            setpref('SBEToolbox', 'isRestore', 0);
        end
    catch exception
        errordlg([exception.message,...
            '... Does your file contain an adjacency matrix  ?']);
    end
    retFname = ['Network imported from Adjacency Matrix file ( ', retFname, ...
        ' ) !'];
    guiOutput = i_dispheader_gui(retFname, 2);
    guiOutput = viewnetinfo_gui(sbeG, guiOutput);
    guiOutput=i_dispfooter_gui(guiOutput);
    set(handles.WorkspaceOutput, 'String', guiOutput);  
end

sbeG = sparse(sbeG);
SetMenuStatus(handles);
set(handles.StatusBar, 'String', 'Ready');


% --------------------------------------------------------------------
function NetworkSaveAsTABFile_Callback(hObject, eventdata, handles)
% hObject    handle to NetworkSaveAsTABFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global sbeG sbeNode
set(handles.StatusBar, 'String', 'Busy');
if isbig(sbeG), h=waitbar(0.5, 'Please wait...'); end
try
    writesbe2tab(sbeG,sbeNode);
catch exception
    errordlg(exception.message);
end
if isbig(sbeG), waitbar(1, h); end
if exist('h','var'), close(h); end
set(handles.StatusBar, 'String', 'Ready');

% --------------------------------------------------------------------
function NetworkSaveAsTABFileNodeIndexes_Callback(hObject, eventdata, handles)
% hObject    handle to NetworkSaveAsTABFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global sbeG sbeNode
set(handles.StatusBar, 'String', 'Busy');
if isbig(sbeG), h=waitbar(0.5, 'Please wait...'); end
try
    writesbe2tab(sbeG,sbeNode,'motifformat');
catch exception
    errordlg(exception.message);
end
if isbig(sbeG), waitbar(1, h); end
if exist('h','var'), close(h); end
set(handles.StatusBar, 'String', 'Ready');


% --------------------------------------------------------------------
function NetworkSaveAsSIFFile_Callback(hObject, eventdata, handles)
% hObject    handle to NetworkSaveAsSIFFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global sbeG sbeNode
set(handles.StatusBar, 'String', 'Busy');
if isbig(sbeG), h=waitbar(0.5, 'Please wait...'); end
try
    writesbe2sif(sbeG,sbeNode);
catch exception
    errordlg(exception.message);
end
if isbig(sbeG), waitbar(1, h); end
if exist('h','var'), close(h); end
set(handles.StatusBar, 'String', 'Ready');

% --------------------------------------------------------------------
function NetworkSaveAsPajekNetFile_Callback(hObject, eventdata, handles)
% hObject    handle to NetworkSaveAsPajekNetFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global sbeG sbeNode
set(handles.StatusBar, 'String', 'Busy');
if isbig(sbeG), h=waitbar(0.5, 'Please wait...'); end
try
    writesbe2pajek(sbeG,sbeNode,[],false);
catch exception
    errordlg(exception.message);
end
if isbig(sbeG), waitbar(1, h); end
if exist('h','var'), close(h); end
set(handles.StatusBar, 'String', 'Ready');

% --------------------------------------------------------------------
function NetworkSaveMATFile_Callback(hObject, eventdata, handles)
% hObject    handle to NetworkSaveMATFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global sbeG sbeNode
set(handles.StatusBar, 'String', 'Busy');
if isbig(sbeG), h=waitbar(0.5, 'Please wait...'); end
try
    writesbe2mat(sbeG,sbeNode);
catch exception
    errordlg(exception.message);
end
if isbig(sbeG), waitbar(1, h); end
if exist('h','var'), close(h); end
set(handles.StatusBar, 'String', 'Ready');


% --------------------------------------------------------------------
function EditExtractSubnetworkAroundEdge_Callback(hObject, eventdata, handles)
% hObject    handle to EditExtractSubnetworkAroundEdge (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global sbeG sbeNode
set(handles.StatusBar, 'String', 'Busy');

   prompt={'Index of node 1:','Index of node 2:','Graph distance cutoff:'};
   def={'1','2','1'};
   dlgTitle='Nodes and cutoff';
   lineNo=1;
   answer=inputdlg(prompt,dlgTitle,lineNo,def);
   if ~(isempty(answer)),
       nodeid1=str2double(answer{1});
       nodeid2=str2double(answer{2});
       distcutoff=str2double(answer{3});
       [sbeG,idx]=extractedge(nodeid1,nodeid2,sbeG,distcutoff);
       sbeNode=sbeNode(idx);
       guiOutput = i_dispheader_gui('Extracted subnetwork around edge!',...
           size(sbeG, 1));
       guiOutput = viewnetinfo_gui(sbeG, guiOutput);
       guiOutput=i_dispfooter_gui(guiOutput);
       set(handles.WorkspaceOutput, 'String', guiOutput);  
   end
   
   SetMenuStatus(handles);
   set(handles.StatusBar, 'String', 'Ready');


% --------------------------------------------------------------------
function EditDisplayNodesList_Callback(hObject, eventdata, handles)
% hObject    handle to EditDisplayNodesList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global sbeG sbeNode
set(handles.StatusBar, 'String', 'Busy');

if isbig(sbeG), h=waitbar(0.5, 'Please wait...'); end
try
    guiOutput = i_dispheader_gui('List of Nodes', size(sbeNode, 1));
    for k=1:numel(sbeNode)
        guiHeaderOffset = k + 1;
        guiOutput{guiHeaderOffset} = sprintf('Node%04d\t%s',k,sbeNode{k});
    end
    guiOutput=i_dispfooter_gui(guiOutput);
    set(handles.WorkspaceOutput, 'String', guiOutput);  
catch exception
    errordlg(exception.message);
    if exist('h','var'), close(h); end
    set(handles.StatusBar, 'String', 'Ready');
    return;
end
if isbig(sbeG), waitbar(1, h); end
if exist('h','var'), close(h); end
set(handles.StatusBar, 'String', 'Ready');

%{
        selection = questdlg('Do you want to copy result into clipboard?',...
                             'Pressing Yes will clear memory',...
                             'Yes','No','No');
        switch selection,
           case 'Yes',
            %num2clip(data);
            clipboard('copy', sbeNode);
           otherwise
            % do nothing
        end
%}


% --------------------------------------------------------------------
function EditIncludeExcludeNodes_Callback(hObject, eventdata, handles)
% hObject    handle to EditIncludeExcludeNodes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global sbeG sbeNode
set(handles.StatusBar, 'String', 'Busy');

[s,v] = choosebox('Name','Pick node(s)','PromptString',...
    'Nodes available:','SelectString','Selected nodes:',...
    'ListString',sbeNode');
if (v==1)
        idx=setdiff(1:num_vertices(sbeG),s);
        sbeG(idx,:)=[];
        sbeG(:,idx)=[];
	    sbeNode=sbeNode(s);
else
    set(handles.StatusBar, 'String', 'Ready');
    return;
end

set(handles.StatusBar, 'String', 'Ready');

%{
% --------------------------------------------------------------------
function LayoutIteration_Callback(hObject, eventdata, handles)
% hObject    handle to LayoutIteration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if strcmp(get(hObject,'checked'),'on')
    set(hObject,'checked','off')
else
    set(hObject,'checked','on')
end
guidata(hObject, handles);

% --------------------------------------------------------------------
% handles    structure with handles and user data (see GUIDATA)
function [yes]=i_WantToIteration(handles)
if strcmp(get(handles.LayoutIteration,'checked'),'on')
    yes=true;
else
    yes=false;
end
%}

% --------------------------------------------------------------------
function StatsGraphEfficiency_Callback(hObject, eventdata, handles)
% hObject    handle to StatsGraphEfficiency (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global sbeG
set(handles.StatusBar, 'String', 'Busy');

if isbig(sbeG), h=waitbar(0.5, 'Please wait...'); end
try
    if issparse(sbeG) && islogical(sbeG), sbeG=double(sbeG); end;
    [out]=graph_efficiency(sbeG);
    if issparse(sbeG) && ~islogical(sbeG), sbeG=logical(sbeG); end;
catch exception
    errordlg(exception.message);
    if exist('h','var'), close(h); end
    set(handles.StatusBar, 'String', 'Ready');
    return;
end
if isbig(sbeG), waitbar(1, h); end
if exist('h','var'), close(h); end
guiOutput = i_dispheader_gui('Network Efficiency (Latora & Marchiori 2001) [GRAPH_EFFICIENCY.m]', ...
    0);
guiOutput{2} = sprintf('%g', out);
guiOutput=i_dispfooter_gui(guiOutput);
set(handles.WorkspaceOutput, 'String', guiOutput);  
set(handles.StatusBar, 'String', 'Ready');

%{
--------------------------------------------------------------------
function EditFindNode_Callback(hObject, eventdata, handles)
% hObject    handle to EditFindNode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global sbeG sbeNode

	ButtonName=questdlg('Find by name or index?', ...
			    'Select key', ...
			    'Name','Index','Name');
    answer=[];
	switch ButtonName,
	    case 'Index',
            prompt={'Index of node:'};
            def={'1'};
            dlgTitle='Find Node';
            lineNo=1;
            answer=inputdlg(prompt,dlgTitle,lineNo,def);
            n1=str2double(answer{1});
            assignin('base','lastans',sbeNode{n1});
        case 'Name'
            prompt={'Name of node:'};
            def={'Node1'};
            dlgTitle='Find Node';
            lineNo=1;
            answer=inputdlg(prompt,dlgTitle,lineNo,def);
            [y1,n1]=ismember(answer{1},sbeNode);
            assignin('base','lastans',n1);
            if ~y1
                msgbox('Not find');
                return;
            end
        otherwise
            msgbox('Not find');
            return;
    end

   if ~(isempty(answer)),
       if n1>num_vertices(sbeG)
          errordlg(sprintf('Index exceeds matrix dimensions %d',num_vertices(sbeG)));
       else
           i_dispheader('Information of Node')
           fprintf('Node %d: %s\n', n1, sbeNode{n1});
           idx=find(sbeG(n1,:));
           fprintf('Number of neighbor nodes: %d\n', numel(idx));
           fprintf('%s,', sbeNode{idx(1:end-1)});
           fprintf('%s\n', sbeNode{idx(end)});
           i_dispfooter;
       end
   end
%}


% --------------------------------------------------------------------
function NetworkSaveAsPajekPajFile_Callback(hObject, eventdata, handles)
% hObject    handle to NetworkSaveAsPajekPajFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global sbeG sbeNode
set(handles.StatusBar, 'String', 'Busy');
if isbig(sbeG), h=waitbar(0.5, 'Please wait...'); end

      [n1,b] = listdlg('PromptString','Select a node:',...
                      'SelectionMode','single',...
                      'ListString',sbeNode);
if b
      if n1>num_vertices(sbeG)
          errordlg(sprintf('Index exceeds matrix dimensions %d',num_vertices(sbeG)));
      else
           sbePartition=zeros(1,num_vertices(sbeG));
           sbePartition(n1)=1;
           writesbe2pajek(sbeG,sbeNode,sbePartition,true);
       end
end
if isbig(sbeG), waitbar(1, h); end
if exist('h','var'), close(h); end
set(handles.StatusBar, 'String', 'Ready');


% --------------------------------------------------------------------
function EditViewNetworkProtovis_Callback(hObject, eventdata, handles)
% hObject    handle to EditViewNetworkProtovis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global sbeG sbeNode deduced_net
userWantsToLoadDeducedNetwork = loadDeducedClustersForPlotting(handles);

if (userWantsToLoadDeducedNetwork && ~isempty(deduced_net))
    plot_sbeG = deduced_net;
else
    plot_sbeG = sbeG;
end

set(handles.StatusBar, 'String', 'Busy');
try
    url=protovisrun(plot_sbeG,sbeNode);
    if isempty(url)
        set(handles.StatusBar, 'String', 'Ready');
        return;
    end
    webNoDots(url, '-browser')
catch exception
    errordlg(exception.message);
end

set(handles.StatusBar, 'String', 'Ready');

% --------------------------------------------------------------------
function EditViewNetworkCytoscape_Callback(hObject, eventdata, handles)
% hObject    handle to EditViewNetworkCytoscape (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global sbeG sbeNode deduced_net
userWantsToLoadDeducedNetwork = loadDeducedClustersForPlotting(handles);
set(handles.StatusBar, 'String', 'Busy');
if isbig(sbeG), h=waitbar(0.5, 'Please wait...'); end
if (userWantsToLoadDeducedNetwork && ~isempty(deduced_net))
    plot_sbeG = deduced_net;
else
    plot_sbeG = sbeG;
end

try
    cytoscaperun(plot_sbeG,sbeNode);
catch exception
    errordlg(exception.message)
end

if isbig(sbeG), waitbar(1, h); end
if exist('h','var'), close(h); end
set(handles.StatusBar, 'String', 'Ready');
SetMenuStatus(handles)

% --------------------------------------------------------------------
function View_Callback(hObject, eventdata, handles)
% hObject    handle to View (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
SetMenuStatus(handles);


% --------------------------------------------------------------------
function WantToExportResultFile_Callback(hObject, eventdata, handles)
% hObject    handle to WantToExportResultFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if strcmp(get(hObject,'checked'),'on')
    setpref('SBEToolbox', 'SaveWindowOutput2File', 0);
    set(hObject,'checked','off')
else
    setpref('SBEToolbox', 'SaveWindowOutput2File', 1);
    set(hObject,'checked','on')
    %msgbox('Result will be saved into a file.','Save Result into File','help');
end
guidata(hObject, handles);

% --------------------------------------------------------------------
% handles    structure with handles and user data (see GUIDATA)
function [yes]=i_WantToExport(handles)
if strcmp(get(handles.WantToExportResultFile,'checked'),'on')
    yes=true;
else
    yes=false;
end

%function i_exportres(data,nodename)
%if nargin<2
%   for i = 1:length(data)
%      nodename{i} = sprintf('Node%s',i);
%   end
%end
%writeattribute2tab(data,nodename);


% --------------------------------------------------------------------
function WantToExportResultToClipboard_Callback(hObject, eventdata, handles)
% hObject    handle to WantToExportResultToClipboard (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if strcmp(get(hObject,'checked'),'on')
    setpref('SBEToolbox', 'CopyWindowOutput2Clipboard', 0);
    set(hObject,'checked','off')
else
    setpref('SBEToolbox', 'CopyWindowOutput2Clipboard', 1);
    set(hObject,'checked','on')
    %msgbox('Result will be copied into clipboard.','Copy Result into Clipboard','help');
end
guidata(hObject, handles);


function [yes]=i_WantToCopy(handles)
if strcmp(get(handles.WantToExportResultToClipboard,'checked'),'on')
    yes=true;
else
    yes=false;
end


% --------------------------------------------------------------------
function WantToExportResultToWS_Callback(hObject, eventdata, handles)
% hObject    handle to WantToExportResultToWS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if strcmp(get(hObject,'checked'),'on')
    setpref('SBEToolbox', 'ExportWindowOutput2Workspace', 0);
    set(hObject,'checked','off')
else
    setpref('SBEToolbox', 'ExportWindowOutput2Workspace', 1);
    set(hObject,'checked','on')
    %msgbox('Result will be assigned into workspace as varible SBEOUT.',...
    %       'Export Result to Workspace','help');
end
guidata(hObject, handles);


function [yes]=i_WantToAssign(handles)
if strcmp(get(handles.WantToExportResultToWS,'checked'),'on')
    yes=1;
else
    yes=0;
end


% --------------------------------------------------------------------
function StatCentralityBridging_Callback(hObject, eventdata, handles)
% hObject    handle to StatCentralityBridging (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global sbeG sbeNode
set(handles.StatusBar, 'String', 'Busy');

if isbig(sbeG), h=waitbar(0.5, 'Please wait...'); end
try
    data=bridging_centrality(sbeG);
    guiOutput = i_dispheader_gui('Bridging Centrality', size(sbeG, 1));
    for k=1:size(sbeG,1)
        guiHeaderOffset = k + 1;
        guiOutput{guiHeaderOffset} = sprintf('Node%04d\t%s\t%g',k,sbeNode{k},data(k));
    end
        guiOutput=i_dispfooter_gui(guiOutput);
        set(handles.WorkspaceOutput, 'String', guiOutput);
        i_conditionalexportresult(handles,data,sbeNode);
         %plot_histcurve(data, 1, 'Bridging Centrality Distribution', ...
         %'log_1_0(bridging centrality)', 'nodes');
        
catch exception
    errordlg(exception.message);
    if exist('h','var'), close(h); end
    set(handles.StatusBar, 'String', 'Ready');
    return;
end
if isbig(sbeG), waitbar(1, h); end
if exist('h','var'), close(h); end
set(handles.StatusBar, 'String', 'Ready');


% --- Executes during object creation, after setting all properties.
function SBEToolboxGUI_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SBEToolboxGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% --------------------------------------------------------------------
function StatBrokeringCoefficient_Callback(hObject, eventdata, handles)
% hObject    handle to StatBrokeringCoefficient (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global sbeG sbeNode
set(handles.StatusBar, 'String', 'Busy');

if isbig(sbeG), h=waitbar(0.5, 'Please wait...'); end
try
    data=brokeringcoeff(sbeG);
    guiOutput = i_dispheader_gui('Brokering Coefficient', size(sbeG, 1));
    for k=1:size(sbeG,1)
        guiHeaderOffset = k + 1;
        guiOutput{guiHeaderOffset} = sprintf('Node%04d\t%s\t%g',k,sbeNode{k},data(k));
        
    end
    guiOutput=i_dispfooter_gui(guiOutput);
    set(handles.WorkspaceOutput, 'String', guiOutput);
    i_conditionalexportresult(handles,data,sbeNode);
catch exception
    errordlg(exception.message);
    if exist('h','var'), close(h); end
    set(handles.StatusBar, 'String', 'Ready');
    return;
end
if isbig(sbeG), waitbar(1, h); end
if exist('h','var'), close(h); end


set(handles.StatusBar, 'String', 'Ready');


% --------------------------------------------------------------------
function StatCentrlityDelta_Callback(hObject, eventdata, handles)
% hObject    handle to StatCentrlityDelta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function StatCentralityEccentricity_Callback(hObject, eventdata, handles)
% hObject    handle to StatCentralityEccentricity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global sbeG sbeNode
set(handles.StatusBar, 'String', 'Busy');

if isbig(sbeG), h=waitbar(0.5, 'Please wait...'); end
try
    data=eccentricity_centrality(sbeG);
    guiOutput = i_dispheader_gui('Eccentricity Centrality', size(sbeG, 1));
    for k=1:size(sbeG,1)
        guiHeaderOffset = k + 1;
        guiOutput{guiHeaderOffset} = sprintf('Node%04d\t%s\t%g',k,sbeNode{k}, full(data(k)));
    end
    guiOutput=i_dispfooter_gui(guiOutput);
    set(handles.WorkspaceOutput, 'String', guiOutput);
    i_conditionalexportresult(handles,data,sbeNode);
     %plot_histcurve(data, 1, 'Eccentricity Centrality Distribution', ...
     %   'log_1_0(eccentricity)', 'nodes');
    
catch exception
    errordlg(exception.message);
    if exist('h','var'), close(h); end
    set(handles.StatusBar, 'String', 'Ready');
    return;
end
if isbig(sbeG), waitbar(1, h); end
if exist('h','var'), close(h); end
set(handles.StatusBar, 'String', 'Ready');


% --------------------------------------------------------------------
function StatCentrlityDeltaMeanDist_Callback(hObject, eventdata, handles)
% hObject    handle to StatCentrlityDeltaMeanDist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global sbeG sbeNode
set(handles.StatusBar, 'String', 'Busy');

if isbig(sbeG), h=waitbar(0.5, 'Please wait...'); end
try
    data=delta_centrality(sbeG,@graph_meandist,true);
    guiOutput = i_dispheader_gui('Delta Centrality (@graph_meandist)',...
        size(sbeG, 1));
    for k=1:size(sbeG,1)
        guiHeaderOffset = k + 1;
        guiOutput{guiHeaderOffset} = sprintf('Node%04d\t%s\t%g',k,sbeNode{k},full(data(k)));
    end
    guiOutput=i_dispfooter_gui(guiOutput);
    set(handles.WorkspaceOutput, 'String', guiOutput);
    i_conditionalexportresult(handles,data,sbeNode);
    %plot_histcurve(data, 1, 'Delta Centrality ( Graph mean distance ) Distribution', ...
        %'log_1_0(graph mean distance)', 'nodes');
    
catch exception
    errordlg(exception.message);
    if exist('h','var'), close(h); end
    set(handles.StatusBar, 'String', 'Ready');
    return;
end
if isbig(sbeG), waitbar(1, h); end
if exist('h','var'), close(h); end

set(handles.StatusBar, 'String', 'Ready');


% --------------------------------------------------------------------
function StatCentrlityDeltaDiameter_Callback(hObject, eventdata, handles)
% hObject    handle to StatCentrlityDeltaDiameter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global sbeG sbeNode
set(handles.StatusBar, 'String', 'Busy');

if isbig(sbeG), h=waitbar(0.5, 'Please wait...'); end
try
    data=delta_centrality(sbeG,@graph_diameter,true);
    guiOutput = i_dispheader_gui('Delta Centrality (@graph_diameter)', size(sbeG, 1));
    for k=1:size(sbeG,1)
        guiHeaderOffset = k + 1;
        guiOutput{guiHeaderOffset} = sprintf('Node%04d\t%s\t%g',k,sbeNode{k},full(data(k)));
    end
    guiOutput=i_dispfooter_gui(guiOutput);
    set(handles.WorkspaceOutput, 'String', guiOutput);
    i_conditionalexportresult(handles,data,sbeNode);
    %plot_histcurve(data, 1, 'Delta Centrality ( Graph diameter ) Distribution', ...
        %'log_1_0(graph diameter)', 'nodes');
    
catch exception
    errordlg(exception.message);
    if exist('h','var'), close(h); end
    set(handles.StatusBar, 'String', 'Ready');
    return;
end
if isbig(sbeG), waitbar(1, h); end
if exist('h','var'), close(h); end

set(handles.StatusBar, 'String', 'Ready');


% --------------------------------------------------------------------
function StatCentrlityDeltaEfficiency_Callback(hObject, eventdata, handles)
% hObject    handle to StatCentrlityDeltaEfficiency (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global sbeG sbeNode
set(handles.StatusBar, 'String', 'Busy');

if isbig(sbeG), h=waitbar(0.5, 'Please wait...'); end
try
    data=delta_centrality(sbeG,@graph_efficiency,true);
    guiOutput = i_dispheader_gui('Delta Centrality (@graph_efficiency)', size(sbeG, 1));
    for k=1:size(sbeG,1)
        guiHeaderOffset = k + 1;
        guiOutput{guiHeaderOffset} = sprintf('Node%04d\t%s\t%g',k,sbeNode{k},full(data(k)));
    end
    guiOutput=i_dispfooter_gui(guiOutput);
    set(handles.WorkspaceOutput, 'String', guiOutput);
    i_conditionalexportresult(handles,data,sbeNode);
    %plot_histcurve(data, 0, 'Delta Centrality ( Graph efficiency ) Distribution', ...
        %'log_1_0(graph efficiency)', 'nodes');
    
catch exception
    errordlg(exception.message);
    if exist('h','var'), close(h); end
    set(handles.StatusBar, 'String', 'Ready');
    return;
end
if isbig(sbeG), waitbar(1, h); end
if exist('h','var'), close(h); end

set(handles.StatusBar, 'String', 'Ready');


% --------------------------------------------------------------------
function LayoutTreeRing_Callback(hObject, eventdata, handles)
% hObject    handle to LayoutTreeRing (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global sbeG sbeNode
set(handles.StatusBar, 'String', 'Busy');

   n=num_vertices(sbeG);
   prompt={'Number of nodes in center:'};
   def={sprintf('%d',max([1,round(n./5)]))};
   dlgTitle='Tree Ring Layout Setup';
   lineNo=1;
   answer=inputdlg(prompt,dlgTitle,lineNo,def);
   if ~(isempty(answer)),
       ncenter=str2double(answer{1});
       if ncenter>=1 && ncenter<=n
           try
               overviewplot;
               alwaysViewAns = isAlwaysViewChecked(handles);
               plotnet_treering(sbeG,sbeNode,ncenter, alwaysViewAns);
           catch exception
               errordlg(exception.message)
           end
       else
           errordlg('NCENTER needs to be >=1 and <=N')
       end
   end

set(handles.StatusBar, 'String', 'Ready');

% --------------------------------------------------------------------
function StatsGraphClusteringCoefficient_Callback(hObject, eventdata, handles)
% hObject    handle to StatsGraphClusteringCoefficient (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global sbeG
set(handles.StatusBar, 'String', 'Busy');

if isbig(sbeG), h=waitbar(0.5, 'Please wait...'); end
try
    [out1]=graph_clustercoeff(sbeG);
catch exception
    errordlg(exception.message);
    if exist('h','var'), close(h); end
    set(handles.StatusBar, 'String', 'Ready');
    return;
end
if isbig(sbeG), waitbar(1, h); end
if exist('h','var'), close(h); end
 guiOutput = i_dispheader_gui('Network Clustering Coefficient [GRAPH_CLUSTERCOEFF.m]',...
     1);
 guiOutput{2} = sprintf('%g', out1);
 %guiOutput{3} = sprintf('Method 2: %f', out2);
 guiOutput=i_dispfooter_gui(guiOutput);
    set(handles.WorkspaceOutput, 'String', guiOutput);
    
 set(handles.StatusBar, 'String', 'Ready');


% --------------------------------------------------------------------
function StatClusteringCoefficientSoffer_Callback(hObject, eventdata, handles)
% hObject    handle to StatClusteringCoefficientSoffer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global sbeG sbeNode
set(handles.StatusBar, 'String', 'Busy');

if isbig(sbeG), h=waitbar(0.5, 'Please wait...'); end
try
    data=soffercc(sbeG);
    guiOutput = i_dispheader_gui('Clustering Coefficient (Soffer & Vázquez, 05) [SOFFERCC.m]',...
        size(sbeG, 1));
    for k=1:size(sbeG,1)
        guiHeaderOffset = k + 1;
        guiOutput{guiHeaderOffset}= sprintf('Node%04d\t%s\t%g',k,sbeNode{k},data(k));
    end
    guiOutput=i_dispfooter_gui(guiOutput);
    set(handles.WorkspaceOutput, 'String', guiOutput);
    i_conditionalexportresult(handles,data,sbeNode);
    
catch exception
    errordlg(exception.message);
    if exist('h','var'), close(h); end
    set(handles.StatusBar, 'String', 'Ready');
    return;
end
if isbig(sbeG), waitbar(1, h); end
if exist('h','var'), close(h); end

set(handles.StatusBar, 'String', 'Ready');


% --------------------------------------------------------------------
function LocalAverageConnectivity_Callback(hObject, eventdata, handles)
% hObject    handle to LocalAverageConnectivity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global sbeG sbeNode
set(handles.StatusBar, 'String', 'Busy');

if isbig(sbeG), h=waitbar(0.5, 'Please wait...'); end
try
    data=locavgcon(sbeG);
    guiOutput = i_dispheader_gui('Local Average Connectivity [LOCAVGCON.m]',...
        size(sbeG, 1));
    for k=1:size(sbeG,1)
        guiHeaderOffset = k + 1;
        guiOutput{guiHeaderOffset} = sprintf('Node%04d\t%s\t%g',k,sbeNode{k},data(k));
    end
    guiOutput=i_dispfooter_gui(guiOutput);
    set(handles.WorkspaceOutput, 'String', guiOutput);
    i_conditionalexportresult(handles,data,sbeNode);
    
catch exception
    errordlg(exception.message);
    if exist('h','var'), close(h); end
    set(handles.StatusBar, 'String', 'Ready');
    return;
end
if isbig(sbeG), waitbar(1, h); end
if exist('h','var'), close(h); end

set(handles.StatusBar, 'String', 'Ready');


% --------------------------------------------------------------------
function CoreNumber_Callback(hObject, eventdata, handles)
% hObject    handle to CoreNumber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global sbeG sbeNode
set(handles.StatusBar, 'String', 'Busy');

if isbig(sbeG), h=waitbar(0.5, 'Please wait...'); end
try
    [data, ~]=kcore(sbeG);
    guiOutput = i_dispheader_gui('Core Number [KCORE.m]', size(sbeG, 1));
    for k=1:size(sbeG,1)
        guiHeaderOffset = k + 1;
        guiOutput{guiHeaderOffset} = sprintf('Node%04d\t%s\t%g',k,...
            sbeNode{k},full(data(k)));
    end
    guiOutput=i_dispfooter_gui(guiOutput);
    set(handles.WorkspaceOutput, 'String', guiOutput);
    i_conditionalexportresult(handles,data,sbeNode);
    
catch exception
    errordlg(exception.message);
    if exist('h','var'), close(h); end
    set(handles.StatusBar, 'String', 'Ready');
    return;
end
if isbig(sbeG), waitbar(1, h); end
if exist('h','var'), close(h); end

set(handles.StatusBar, 'String', 'Ready');


% --------------------------------------------------------------------
function HelpResetAllWarnings_Callback(hObject, eventdata, handles)
% hObject    handle to HelpResetAllWarnings (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function clusteringAlgorithms_Callback(hObject, eventdata, handles)
% hObject    handle to clusteringAlgorithms (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function markovClustering_Callback(hObject, eventdata, handles)
% hObject    handle to markovClustering (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global sbeG sbeNode deduced_net
set(handles.StatusBar, 'String', 'Busy');

prompt = {'Inflation r:', 'Minimum value for pruning:', ...
    'Maximum number of iterations:'};
    
    dlgTitle = 'Apply MCL algorithm';
    num_lines = 1;
    answer = inputdlg(prompt, dlgTitle, ...
        [num_lines, 50; num_lines, 50; num_lines, 50], {'2', '0.001', '30'});
    
    if ~(isempty(answer))
        r = str2double(answer{1});
        n = str2double(answer{2});
        iter = str2double(answer{3});
        
        if (r < 0)
            errordlg('Inflation (r) must be positive', ...
                'MCL Algorithm Error!');
            set(handles.StatusBar, 'String', 'Ready');
            return;
        end
        
        if (~isa(n, 'numeric'))
            errordlg('Please enter a numeric value', ...
                'MCL Algorithm Error!');
            set(handles.StatusBar, 'String', 'Ready');
            return;
        end
        
        if (iter < 0  || mod(iter, 1) ~= 0)
            errordlg('Please enter a positive integer', ...
                'MCL Algorithm Error!');
            set(handles.StatusBar, 'String', 'Ready');
            return;
        end
        
        
       if (r == 2)
           display_mcl_help = 1;
       else
           display_mcl_help = 0;
       end
         
       try
           [deduced_net, msg] = mcl(sbeG, 2, r, n, 0, iter);
           if msg ~= 1
               if display_mcl_help
                   helpdlg(...
                       ['Unable to deduce non overlapping clusters.',...
                       'See if adjusting', ...
                       ' other parameters works.'],...
                       'MCL Iteration exhausted !');
                   return;
               else 
                    errordlg(...
                       'Unable to deduce non overlapping clusters.',...
                       'MCL Iteration exhausted !');
                   return;
               end
           end
       catch exception
           errordlg(exception.message);
           return;
       end
       
       
       if msg ~= 1
           guiOutput = i_dispheader_gui('Network restored!', 5);
           guiOutput = viewnetinfo_gui(sbeG, guiOutput);
       else
           guiOutput{1} = sprintf('%s\n%s', 'Markov Clustering Algorithm applied!',...
               '=================================================');          
           [num_clusters, mcl_out] = deduce_mcl_clusters(unique(deduced_net, 'rows'),...
               sbeNode);
 
       end
       guiOutput{2} = sprintf('%s%d\n%s', 'Number of clusters detected: ',...
           num_clusters, '=================================================');
       guiOutput{3} = sprintf('%s\t%s\t%s\n%s', '', 'Node',...
           'Cluster Membership ID',...
           '=================================================');
       guiOutput = [guiOutput, mcl_out];
       guiOutput{end+1}=sprintf('%s\n',...
           '=================================================');
      
       set(handles.WorkspaceOutput, 'String',guiOutput);
           else
        set(handles.StatusBar, 'String', 'Ready');
        return;
    end
SetMenuStatus(handles);
i_conditionalexportresult(handles,guiOutput,sbeNode);
set(handles.StatusBar, 'String', 'Ready');



% --------------------------------------------------------------------
function ModuleMCODE_Callback(hObject, eventdata, handles)
% hObject    handle to ModuleMCODE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global sbeG sbeNode deduced_net
set(handles.StatusBar, 'String', 'Busy');

if isbig(sbeG), h=waitbar(0.5, 'Please wait...'); end
try
    data=mcode(sbeG);
    guiOutput = i_dispheader_gui('MCODE (graph clustering)', size(sbeG, 1));
    guiOutput{2} = sprintf('%s\n%s', ['Detected ', num2str(max(data)), ' modules'], ...
        '=======================================');
    for k=1:size(sbeG,1)
        guiHeaderOffset = k + 2;
        guiOutput{guiHeaderOffset} = sprintf('Node%04d\t%s\t%d',k,sbeNode{k},data(k));
    end
    guiOutput=i_dispfooter_gui(guiOutput);
    set(handles.WorkspaceOutput, 'String', guiOutput);
    deduced_net = moduleid2net(data, sbeG);
    i_conditionalexportresult(handles,data,sbeNode);
    
catch exception
    errordlg(exception.message);
    if exist('h','var'), close(h); end
    set(handles.StatusBar, 'String', 'Ready');
    return;
end
if isbig(sbeG), waitbar(1, h); end
if exist('h','var'), close(h); end

set(handles.StatusBar, 'String', 'Ready');


% --------------------------------------------------------------------
function ModuleClusterOne_Callback(hObject, eventdata, handles)
% hObject    handle to ModuleClusterOne (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global sbeG sbeNode deduced_net
set(handles.StatusBar, 'String', 'Busy');

if isbig(sbeG), h=waitbar(0.5, 'Please wait...'); end
try
    [msg, data]=clusteronerun(sbeG,sbeNode);
    guiOutput = i_dispheader_gui('ClusterONE (graph clustering)', size(sbeG, 1));
    guiOutput{2} = sprintf('%s\n%s', msg, ...
        '=======================================');
    for k=1:size(sbeG,1)
        guiHeaderOffset = k + 2;
        guiOutput{guiHeaderOffset} = sprintf('Node%04d\t%s\t%d',k,sbeNode{k},data(k));
    end
    guiOutput=i_dispfooter_gui(guiOutput);
    set(handles.WorkspaceOutput, 'String', guiOutput);
    deduced_net = moduleid2net(data, sbeG);
    i_conditionalexportresult(handles,data,sbeNode);
    
catch exception
    errordlg(exception.message);
    if exist('h','var'), close(h); end
    set(handles.StatusBar, 'String', 'Ready');
    return;
end
if isbig(sbeG), waitbar(1, h); end
if exist('h','var'), close(h); end

set(handles.StatusBar, 'String', 'Ready');


% --------------------------------------------------------------------
function alwaysViewGraphInset_Callback(hObject, eventdata, handles)
% hObject    handle to alwaysViewGraphInset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA
if strcmp(get(hObject,'checked'),'on')
    setpref('SBEToolbox', 'ShowGraphInset', 0);
    set(hObject,'checked','off');
else
    setpref('SBEToolbox', 'ShowGraphInset', 1);
    set(hObject,'checked','on');
end


% --------------------------------------------------------------------
function alwaysViewAns = isAlwaysViewChecked(handles)
% Function to check if view inset graph is on
if strcmp(get(handles.alwaysViewGraphInset,'checked'),'on')
    alwaysViewAns=true;
else
    alwaysViewAns=false;
end


% --------------------------------------------------------------------
function EditViewNetworkSigmajs_Callback(hObject, eventdata, handles)
% hObject    handle to EditViewNetworkSigmajs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global sbeG sbeNode deduced_net
set(handles.StatusBar, 'String', 'Busy');
userWantsToLoadDeducedNetwork = loadDeducedClustersForPlotting(handles);

if (userWantsToLoadDeducedNetwork && ~isempty(deduced_net))
    plot_sbeG = deduced_net;
else
    plot_sbeG = sbeG;
end


[s,v] = listdlg('PromptString','Select a layout method:',...
    'SelectionMode','single',...
    'ListString',{'fruchterman_reingold_force','gursoy_atun',...
    'kamada_kawai','circle'});

if isempty(s)
    set(handles.StatusBar, 'String', 'Ready');
    return;
end

if ~issymmetric(plot_sbeG)
    [plot_sbeG]=symmetrizeadjmat(plot_sbeG);
end

if v==1
    switch s
        case 1
            xy=fruchterman_reingold_force_directed_layout(double(sparse(plot_sbeG)));
        case 2
            xy=gursoy_atun_layout(double(sparse(plot_sbeG)));            
        case 3
            xy=kamada_kawai_spring_layout(double(sparse(plot_sbeG)));    
        case 4
            [xy]=circle_layout(plot_sbeG);
    end
else
    xy=[];
end

try
    url=sigmajsrun(plot_sbeG,sbeNode,xy);
    if isempty(url)
        set(handles.StatusBar, 'String', 'Ready');
        return;
    end
    webNoDots(url, '-browser');
catch exception
    errordlg(exception.message);
end

set(handles.StatusBar, 'String', 'Ready');


function [yes]=isbig(G)
yes=false;
if size(G,1)>=1000
    yes=true;
end


% --------------------------------------------------------------------
function LoadDeducedNetwork_Callback(hObject, eventdata, handles)
% hObject    handle to LoadDeducedNetwork (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if strcmp(get(hObject,'checked'),'on')
    set(hObject,'checked','off')
    setpref('SBEToolbox', 'LoadDeducedNetworkUserPref', 0);
else
    set(hObject,'checked','on')
    setpref('SBEToolbox', 'LoadDeducedNetworkUserPref', 1);
end

SetMenuStatus(handles);


% --------------------------------------------------------------------
function userWantsToLoadDeducedNetwork = loadDeducedClustersForPlotting(handles)
% Function to check if view inset graph is on
if strcmp(get(handles.LoadDeducedNetwork,'checked'),'on')
    userWantsToLoadDeducedNetwork=true;	
else
    userWantsToLoadDeducedNetwork=false;	
end	
SetMenuStatus(handles);


% --------------------------------------------------------------------
function EditPreferences_Callback(hObject, eventdata, handles)
% hObject    handle to EditPreferences (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --------------------------------------------------------------------
%
% Plugin section
%
% --------------------------------------------------------------------


% --------------------------------------------------------------------
% --- Executes during object creation, after setting all properties.
function authorInformation_CreateFcn(hObject, eventdata, handles)
% hObject    handle to authorInformation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
% --- Executes during object creation, after setting all properties.
function pluginDescription_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pluginDescription (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
% --- Executes during object creation, after setting all properties.
function selectPluginsDropDown_CreateFcn(hObject, eventdata, handles)
% hObject    handle to selectPluginsDropDown (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over selectPluginsDropDown.
function varargout = selectPluginsDropDown_ButtonDownFcn(hObject, eventdata, handles, varargin)
% hObject    handle to selectPluginsDropDown (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(hObject, 'Enable', 'On');
set(handles.execute, 'enable', 'on')
[currPath, ~, ~] = fileparts(which(mfilename()));
pluginFID = fopen([currPath, filesep, 'plugins', filesep, 'pluginList.info'], 'r');
pluginList = textscan(pluginFID, '%[^\n]');
charPluginList = cell(size(pluginList{1,:}, 1), 1);
for i = 1:size(pluginList{1,:}, 1)
    charPluginList{i} = char(pluginList{1}(i));
end

if isempty(charPluginList)
    set(handles.selectPluginsDropDown, 'String', {'No Plugins Available'});
    return;
end

if nargin < 4
    set(handles.selectPluginsDropDown, 'String', charPluginList);
    selectPluginsDropDown_Callback(hObject, eventdata, handles);
end
varargout{1} = charPluginList;


% --------------------------------------------------------------------
% --- Executes on selection change in selectPluginsDropDown.
function selectPluginsDropDown_Callback(hObject, eventdata, handles, varargin)
% hObject    handle to selectPluginsDropDown (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: contents = cellstr(get(hObject,'String')) returns selectPluginsDropDown contents as cell array
%        contents{get(hObject,'Value')} returns selected item from selectPluginsDropDown
set(handles.StatusBar, 'String', 'Busy');
%global sbeG
if nargin == 4
    userSelectedPlugin = varargin{1};
else
    dropDownContents = cellstr(get(hObject, 'String'));
    userSelectedPlugin = dropDownContents{get(hObject, 'Value')};
end

if ~ispref('SBEToolbox', 'pluginexe')
    addpref('SBEToolbox', 'pluginexe', '');
end

formatPat = '\s+|\-|\_';
formattedName = regexprep(userSelectedPlugin, formatPat, '_');
[currPath, ~, ~] = fileparts(which(mfilename()));
pluginFolder = [currPath, filesep, 'plugins', filesep, formattedName, filesep];
pluginInfoFID = fopen([pluginFolder, formattedName, '.info'], 'r');

if pluginInfoFID < 0
    set(handles.pluginDescription, 'String', 'N/A');
    set(handles.authorInformation, 'String', 'N/A');
    set(handles.execute, 'enable', 'off');
    return;
else
    %if ~isempty(sbeG), set(handles.execute, 'enable', 'on'), end
    pInfoUIPanel = textscan(pluginInfoFID, '%[^\n]');
    set(handles.pluginDescription, 'String', splitSentence(pInfoUIPanel{1}(1)));
    set(handles.authorInformation, 'String', splitSentence(pInfoUIPanel{1}(2)));
    setpref('SBEToolbox', 'pluginexe', [currPath, '|', pluginFolder, '|',...
        formattedName, '|', userSelectedPlugin]);
end
set(handles.searchPluginList, 'String', 'Search Plugin List');
set(handles.StatusBar, 'String', 'Ready');


% --------------------------------------------------------------------
% --- Executes on button press in downloadLatestPlugins.-------------------
function downloadLatestPlugins_Callback(hObject, eventdata, handles)
% hObject    handle to downloadLatestPlugins (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.StatusBar, 'String', 'Refreshing Plugin List');
exePrg = regexpi(getpref('SBEToolbox', 'pluginexe'), '\|', 'split');
[currPath, ~, ~] = fileparts(which(mfilename()));
pPath = [currPath, filesep, 'plugins', filesep, regexprep(exePrg{4}, '\-|\_|\s+', '_')];
pList = selectPluginsDropDown_ButtonDownFcn(hObject, eventdata, handles, 0);
set(handles.selectPluginsDropDown, 'value', 1);
if ~exist(pPath, 'dir')
    exePrg{4} = pList{1};
elseif isempty(pList)
    exePrg{4} = 'No Plugins Available';
else
    exePrg{4} = 'test_plugin';
end
set(handles.selectPluginsDropDown, 'String', pList);
selectPluginsDropDown_Callback(hObject, eventdata, handles, exePrg{4});
set(handles.StatusBar, 'String', 'Ready');


% --------------------------------------------------------------------
% --- Executes on button press in searchPluginList.
function searchPluginList_Callback(hObject, eventdata, handles)
% hObject    handle to searchPluginList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global sbeG
set(handles.StatusBar, 'String', 'Busy');
charPluginList = selectPluginsDropDown_ButtonDownFcn(hObject, eventdata, handles, 0);
ind = Search(charPluginList, 'Search Plugin List');
if ind > 0
    selectPluginsDropDown_Callback(hObject, eventdata, handles, charPluginList{ind});
    set(handles.searchPluginList, 'String', strcat('Using:', {' '}, charPluginList{ind}));
    set(handles.selectPluginsDropDown, 'enable', 'off');
elseif isempty(sbeG)
    %set(handles.execute, 'enable', 'off');
    return;
else
    return;
end
set(handles.StatusBar, 'String', 'Ready');


% --------------------------------------------------------------------
% --- Executes on button press in execute.
function execute_Callback(hObject, eventdata, handles)
% hObject    handle to execute (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global sbeG sbeNode retFname
set(handles.StatusBar, 'String', 'Busy');
exePrg = regexpi(getpref('SBEToolbox', 'pluginexe'), '\|', 'split');

if ~exist(exePrg{2}, 'file')
    errordlg(['Plugin directory ', exePrg{2}, ' does not exist !']);
    return;
end

if ~exist([exePrg{2}, exePrg{3}, '.m'], 'file')
    errordlg(['Plugin source file ', exePrg{3}, '.m does not exist !']);
    return;
end

cd(exePrg{2});
guiOutput = eval(exePrg{3});
if ~isempty(guiOutput)
    set(handles.WorkspaceOutput, 'String', guiOutput);
end
cd(exePrg{1});
if getpref('SBEToolbox', 'isPluginNetworkReload') == 1
    [sbeG, sbeNode] = getcurrentnetsession;
    if ~issparse(sbeG)
        sbeG = sparse(sbeG);
    end
    setpref('SBEToolbox', 'isPluginNetworkReload', 0);
    retFname = getpref('SBEToolbox', 'filename');
    SetMenuStatus(handles);
end
i_conditionalexportresult(handles, guiOutput, '');
set(handles.StatusBar, 'String', 'Ready');


% --------------------------------------------------------------------
function NetworkEvolution_Callback(hObject, eventdata, handles)
% hObject    handle to NetworkEvolution (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function ManagePlugins_Callback(hObject, eventdata, handles)
% hObject    handle to ManagePlugins (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function ManagePluginInstallFromFile_Callback(hObject, eventdata, handles)
% hObject    handle to ManagePluginInstallFromFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.StatusBar, 'String', 'Busy');
try
    plugin_manage('install-fl');
catch exception
    errordlg(exception.message);
end
set(handles.StatusBar, 'String', 'Ready');

% --------------------------------------------------------------------
function ManagePluginPackage_Callback(hObject, eventdata, handles)
% hObject    handle to ManagePluginPackage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.StatusBar, 'String', 'Busy');
try
    plugin_manage('pak');
catch exception
    errordlg(exception.message);
end
set(handles.StatusBar, 'String', 'Ready');

% --------------------------------------------------------------------
function ManagePluginDelete_Callback(hObject, eventdata, handles)
% hObject    handle to ManagePluginDelete (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.StatusBar, 'String', 'Busy');
charPluginList = selectPluginsDropDown_ButtonDownFcn(hObject, eventdata, handles, 0);
ind = Search(charPluginList, 'Select a Plugin to Delete');
if ind > 0
    try
        plugin_manage(charPluginList{ind}, 'del');
    catch exception
        errordlg(exception.message);
    end
end
downloadLatestPlugins_Callback(hObject, eventdata, handles);
set(handles.StatusBar, 'String', 'Ready');


% --------------------------------------------------------------------
function ManagePluginCreateFromTemplate_Callback(hObject, eventdata, handles)
% hObject    handle to ManagePluginCreateFromTemplate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.StatusBar, 'String', 'Busy');

prompt = {'Plugin Name :',...
    'Plugin Description :',...
    'Author Information :'};
def={'demo plugin', 'This is a demo plugin', 'demo author||demo institution'};
dlgTitle = 'Create a Plugin from template';
num_lines = 5;
answer = inputdlg(prompt, dlgTitle, ...
    [num_lines, 100; num_lines, 100; num_lines, 100], def, 'on');

if ~(isempty(answer))
    try
        create_plugin({answer{1}, answer{2}, answer{3}});
    catch exception
        errordlg(exception.message);
    end
end
set(handles.StatusBar, 'String', 'Ready');


% --------------------------------------------------------------------
function PluginManageEditPlugin_Callback(hObject, eventdata, handles)
% hObject    handle to PluginManageEditPlugin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.StatusBar, 'String', 'Busy')
charPluginList = selectPluginsDropDown_ButtonDownFcn(hObject, eventdata, handles, 0);
ind = Search(charPluginList, 'Select a Plugin to Edit');
if ind > 0
    try
        plugin_manage(charPluginList{ind}, 'edit');
    catch exception
        errordlg(exception.message);
    end
end
set(handles.StatusBar, 'String', 'Ready');


% --------------------------------------------------------------------
function NetworkEvolutionPreferentialAttachment_Callback(hObject, eventdata, handles)
% hObject    handle to NetworkEvolutionPreferentialAttachment (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global sbeG sbeNode retFname
set(handles.StatusBar, 'String', 'Busy');
retFname_old = retFname;
sbeG_bEvol = sbeG;
sbeNode_bEvol = sbeNode;

[sbeG, sbeNode, guiOutput] = network_evolution(sbeG_bEvol, sbeNode_bEvol, 1, 0);
if ~isempty(sbeG) && ~isempty(guiOutput)
     if getpref('SBEToolbox', 'NetEvolMsg') == -1
        setpref('SBEToolbox', 'isRestore', 0);
        retFname = retFname_old;
     else
       setpref('SBEToolbox', 'isRestore', 1);
       retFname = 'Network Evolved ( Preferential Attachment ) !';
     end
    set(handles.WorkspaceOutput, 'String', guiOutput);
    if ~ispref('SBEToolbox', 'isRestore'), addpref('SBEToolbox', 'isRestore', ''); end
    setpref('SBEToolbox', 'isRestore', 1);
    writenetsession(sbeG, sbeNode, 'sbeEdit');
else
    retFname = retFname_old;
    sbeG = sbeG_bEvol;
    sbeNode = sbeNode_bEvol;
end
if getpref('SBEToolbox', 'NetEvolMsg') == -1; setpref('SBEToolbox', 'isRestore', 0); end
set(handles.StatusBar, 'String', 'Ready');
i_conditionalexportresult(handles,guiOutput,sbeNode);
SetMenuStatus(handles);

% --------------------------------------------------------------------
function NetworkEvolutionNodeDuplication_Callback(hObject, eventdata, handles)
% hObject    handle to NetworkEvolutionNodeDuplication (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global sbeG sbeNode retFname
set(handles.StatusBar, 'String', 'Busy');
retFname_old = retFname;
sbeG_bEvol = sbeG;
sbeNode_bEvol = sbeNode;

outMsg = get(handles.WorkspaceOutput, 'String');
infoMsg = i_dispheader_gui('Description of Options', 0);
infoMsg{2} = sprintf('%s\n\n%s\n\n%s', ...
    'Node Duplication Rate: This many number of nodes are duplicated at each simulation step including the connections to other node(s).', ...
    'Fixation Probability: The probability ( greater than or equal to ) at which the selected node(s) is / are likely to get introduced into the network.', ...
    'Number of Steps: The simulation will run for this many number of steps.');
infoMsg{3} = sprintf('%s', char(i_dispfooter_gui('')));
set(handles.WorkspaceOutput, 'String', infoMsg);

[sbeG, sbeNode, guiOutput] = network_evolution(sbeG_bEvol, sbeNode_bEvol, 2, 0);

if ~isempty(sbeG) && ~isempty(guiOutput)
    if getpref('SBEToolbox', 'NetEvolMsg') == -1
        setpref('SBEToolbox', 'isRestore', 0);
        retFname = retFname_old;
    else
        setpref('SBEToolbox', 'isRestore', 1);
        retFname = 'Network Evolved ( Node Duplication ) !';
    end
    set(handles.WorkspaceOutput, 'String', guiOutput);
    if ~ispref('SBEToolbox', 'isRestore'), addpref('SBEToolbox', 'isRestore', ''); end
    writenetsession(sbeG, sbeNode, 'sbeEdit');
else
    retFname = retFname_old;
    sbeG = sbeG_bEvol;
    sbeNode = sbeNode_bEvol;
    set(handles.WorkspaceOutput, 'String', outMsg);
end
set(handles.StatusBar, 'String', 'Ready');
i_conditionalexportresult(handles,guiOutput,sbeNode);
SetMenuStatus(handles);


% --------------------------------------------------------------------
function NetworkEvolutionNodeLoss_Callback(hObject, eventdata, handles)
% hObject    handle to NetworkEvolutionNodeLoss (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global sbeG sbeNode retFname
set(handles.StatusBar, 'String', 'Busy');
retFname_old = retFname;
sbeG_bEvol = sbeG;
sbeNode_bEvol = sbeNode;

outMsg = get(handles.WorkspaceOutput, 'String');
infoMsg = i_dispheader_gui('Description of Options', 0);
infoMsg{2} = sprintf('%s\n\n%s\n\n%s', ...
    ['Node Loss Rate: ', ...
    'This many number of nodes are deleted / lost at each simulation step including the connections to other node(s).', ...
    ' If multiple nodes are selected, then number of nodes selected must be equal to product of "Node Loss Rate" and "Number of Steps".'], ...
    'Fixation Probability: The probability ( greater than or equal to ) at which the selected node(s) is / are likely to be removed from the network.', ...
    'Number of Steps: The simulation will run for this many number of steps.');
infoMsg{3} = sprintf('%s', char(i_dispfooter_gui('')));
set(handles.WorkspaceOutput, 'String', infoMsg);

[sbeG, sbeNode, guiOutput] = network_evolution(sbeG_bEvol, sbeNode_bEvol, 4, 0);

if getpref('SBEToolbox', 'NetEvolMsg') == 99 || ...
        (~isempty(sbeG) && ~isempty(guiOutput))
    if getpref('SBEToolbox', 'NetEvolMsg') == -1
        setpref('SBEToolbox', 'isRestore', 0);
        retFname = retFname_old;
    else
        setpref('SBEToolbox', 'isRestore', 1);
        retFname = 'Network Evolved ( Node Loss ) !';
    end
    set(handles.WorkspaceOutput, 'String', guiOutput);
    if ~ispref('SBEToolbox', 'isRestore'), addpref('SBEToolbox', 'isRestore', ''); end
    writenetsession(sbeG, sbeNode, 'sbeEdit');
else
    retFname = retFname_old;
    sbeG = sbeG_bEvol;
    sbeNode = sbeNode_bEvol;
    set(handles.WorkspaceOutput, 'String', outMsg);
end
set(handles.StatusBar, 'String', 'Ready');
i_conditionalexportresult(handles,guiOutput,sbeNode);
SetMenuStatus(handles);


% --------------------------------------------------------------------
function NetworkEvolutionRewireEdge_Callback(hObject, eventdata, handles)
% hObject    handle to NetworkEvolutionRewireEdge (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global sbeG sbeNode retFname
set(handles.StatusBar, 'String', 'Busy');
retFname_old = retFname;
sbeG_bEvol = sbeG;
sbeNode_bEvol = sbeNode;

outMsg = get(handles.WorkspaceOutput, 'String');
infoMsg = i_dispheader_gui('Description of Options', 0);
infoMsg{2} = sprintf('%s\n\n%s\n\n%s', ...
    ['Edge Rewire Rate: ', ...
    'This many number of edges are rewired at each simulation step.', ...
    ' If multiple nodes are selected, then the number of edges equal to "Edge Rewire Rate" will be rewired with "Fixation Probability".', ...
    ' If the number of edges for the node is less than "Edge Rewire Rate", then the maximum number of edges will be rewired.'], ...
    'Fixation Probability: The probability ( greater than or equal to ) at which randomly selected edge is / are likely to be rewired to a randomly selected node within the network.', ...
    'Number of Steps: The simulation will run for this many number of steps.');
infoMsg{3} = sprintf('%s', char(i_dispfooter_gui('')));
set(handles.WorkspaceOutput, 'String', infoMsg);

[sbeG, sbeNode, guiOutput] = network_evolution(sbeG_bEvol, sbeNode_bEvol, 3, 0);

if ~isempty(sbeG) && ~isempty(guiOutput)
    if getpref('SBEToolbox', 'NetEvolMsg') == -1
        setpref('SBEToolbox', 'isRestore', 0);
        retFname = retFname_old;
    else
        setpref('SBEToolbox', 'isRestore', 1);
        retFname = 'Network Evolved ( Rewire Edge ) !';
    end
    set(handles.WorkspaceOutput, 'String', guiOutput);
    if ~ispref('SBEToolbox', 'isRestore'), addpref('SBEToolbox', 'isRestore', ''); end
    writenetsession(sbeG, sbeNode, 'sbeEdit');
else
    retFname = retFname_old;
    sbeG = sbeG_bEvol;
    sbeNode = sbeNode_bEvol;
    set(handles.WorkspaceOutput, 'String', outMsg);
end
set(handles.StatusBar, 'String', 'Ready');
i_conditionalexportresult(handles,guiOutput,sbeNode);
SetMenuStatus(handles);


% --------------------------------------------------------------------
function changeScreenPosition_Callback(hObject, eventdata, handles)
% hObject    handle to changeScreenPosition (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
waitH = askScreenPreference('changeScrSize');
waitfor(waitH);
set(gcf, 'units', 'pixels', 'Position', getpref('SBEToolbox', 'useMonitor'));


% --------------------------------------------------------------------
function updateMemoryUsage(src, eventdata, handles)
%totalMem = java.lang.Runtime.getRuntime.totalMemory;
%freeMem = java.lang.Runtime.getRuntime.freeMemory;

%totalMem = totalMem / 1024 / 1024;
%freeMem = freeMem / 1024 /1024;
%usedMem = totalMem - freeMem;

if isunix
    %[~, grepVersion] = unix('grep --version | grep ''GNU grep''');
    %if str2double(regexp(regexprep(grepVersion, '\.', ''), '(\d+)', 'match')) < 251 
    %    errordlg('GNU grep version 2.5.1 or greater required to update memory usage information');
    %    stop(timerfindall('Name', 'SBEGUI_CurrentMemUsage'));
    %    delete(timerfindall('Name', 'SBEGUI_CurrentMemUsage'));
    %    return;
    %end
    [~, MatlabMemUsedMB] = unix('ps aux | grep -i ''[M]ATLAB'' | grep ''desktop'' | awk ''{print $6 / 1024}'' ');
    if size(regexp(MatlabMemUsedMB, '[\n\r]', 'split'), 2) > 2
        waitfor(errordlg('More than 1 MATLAB instance is running on this machine. Cannot determine current MATLAB memory usage. Click on "Ok" to continue...'));
        stop(timerfindall('Name', 'SBEGUI_CurrentMemUsage'));
        delete(timerfindall('Name', 'SBEGUI_CurrentMemUsage'));
        return;
    end
    
    MatlabMemUsedMB = regexprep(MatlabMemUsedMB, '[\n\r]+', '');
    
    if uint16(str2double(MatlabMemUsedMB)) < uint16(str2double(getpref('SBEToolbox', 'InitMatlabMemUsedMB'))) || ...
            get(timerfindall('Name', 'SBEGUI_CurrentMemUsage'), 'TasksExecuted') == 1
        setpref('SBEToolbox', 'InitMatlabMemUsedMB', MatlabMemUsedMB);
        return;
    else
        MatlabMemUsedMB = uint16(str2double(MatlabMemUsedMB)) - uint16(str2double(getpref('SBEToolbox', 'InitMatlabMemUsedMB')));
    end
    
    if MatlabMemUsedMB == 0
        MatlabMemUsedMB = 'Updating...';
    else
        MatlabMemUsedMB = [num2str(MatlabMemUsedMB), ' MB'];
    end
    
    set(handles.currentMemoryUsage, 'String', sprintf('%s%s%s', ...
        'Current Memory Usage: ', MatlabMemUsedMB));
elseif ispc
    Memory = memory;
    MatlabMemUsedMB = round(Memory.MemUsedMATLAB / 1024 / 1024);
    
    if MatlabMemUsedMB <  getpref('SBEToolbox', 'InitMatlabMemUsedMB') || ...
            get(timerfindall('Name', 'SBEGUI_CurrentMemUsage'), 'TasksExecuted') == 1
        setpref('SBEToolbox', 'InitMatlabMemUsedMB', MatlabMemUsedMB);
        return;
    else
        MatlabMemUsedMB = MatlabMemUsedMB - getpref('SBEToolbox', 'InitMatlabMemUsedMB');
    end
    
    if MatlabMemUsedMB == 0
        MatlabMemUsedMB = 'Updating...';
    else
        MatlabMemUsedMB = [num2str(MatlabMemUsedMB), ' MB'];
    end
    
    set(handles.currentMemoryUsage, 'String', sprintf('%s%s%s', ...
        'Current Memory Usage: ', MatlabMemUsedMB));
else
    stop(timerfindall('Name', 'SBEGUI_CurrentMemUsage'));
    delete(timerfindall('Name', 'SBEGUI_CurrentMemUsage'));
    return;
end


% --------------------------------------------------------------------
function isRandomEvolution_Callback(hObject, eventdata, handles)
% hObject    handle to isRandomEvolution (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if strcmp(get(hObject,'checked'),'on')
    set(hObject,'checked','off')
    setpref('SBEToolbox', 'RandomEvolutionUserPref', 0);
else
    set(hObject,'checked','on')
    setpref('SBEToolbox', 'RandomEvolutionUserPref', 1);
end

SetMenuStatus(handles);

% --------------------------------------------------------------------
function checkisRandomEvolution(handles)
% Function to check if Random Evolution is on or off
if getpref('SBEToolbox', 'RandomEvolutionUserPref') == 1
    set(handles.isRandomEvolution, 'checked', 'on');
else
    set(handles.isRandomEvolution, 'checked', 'off');
end
SetMenuStatus(handles);

% --------------------------------------------------------------------
function UpdateAnnotationDatabases_Callback(hObject, eventdata, handles)
% hObject    handle to UpdateAnnotationDatabases (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.StatusBar, 'String', 'Busy');
update_GO_annotation
set(handles.StatusBar, 'String', 'Ready');

% --------------------------------------------------------------------
% Function that will refresh the Network information pane and other
% menu items
% --------------------------------------------------------------------
function SetMenuStatus(handles)
global sbeG deduced_net retFname

cannotbeempty = [
        handles.EditAddEdge,...
        handles.EditAddNode,...
        handles.EditBrowseNodeList,...
        handles.EditExtractSubnetworkAroundNode,...
        handles.EditRemoveEdge,...
        handles.EditRemoveNode,...
        handles.EditRestoreNetwork,...
        handles.EditSymmetrizeAdjacencyMatrix,...
        handles.ViewAdjacencyMatrix,...
        handles.EditViewNetworkCytoscape,...
        handles.EditViewNetworkProtovis,...
        handles.EditDisplayNodesList,...
        handles.LayoutCircle,...
        handles.LayoutTreeRing,...
        handles.LayoutFruchtermanReingold,...
        handles.LayoutGursoyAtun,...        
        handles.LayoutKamadaKawaiSpring,...
        handles.LayoutRandom,...
        handles.NetworkAssignGlobalVariablesToWorkSpace,...
        handles.NetworkClose,...
        handles.NetworkSaveAsPajekNetFile,...
        handles.NetworkSaveAsPajekPajFile,...
        handles.NetworkSaveAsSIFFile,...
        handles.NetworkSaveAsTABFile,...
        handles.NetworkSaveAsTABFileNodeIndexes,...
        handles.NetworkSaveMATFile,...
        handles.StatGraphAverageDistance,...
        handles.StatsGraphClusteringCoefficient,...
        handles.StatCentralityBetweenness,...
        handles.StatCentralityBridging,...
        handles.StatCentralityCloseness,...
        handles.StatCentralityEccentricity,...
        handles.StatCentralityInDegree,...
        handles.StatClusteringCoefficient,...
        handles.StatClusteringCoefficientSoffer,...
        handles.StatBrokeringCoefficient,...
        handles.StatGraphDiameter,...
        handles.ViewDistanceMatrix,...
        handles.StatDistanceBtw2Nodes,...
        handles.StatNetworkSummary,...
        handles.ViewPowerLawDegreeDistribution,...
        handles.StatsGraphEfficiency,...
        handles.WantToExportResultToWS,...
        handles.WantToExportResultToClipboard,...
        handles.WantToExportResultFile,...
        handles.LocalAverageConnectivity,...
        handles.CoreNumber,...
        handles.ExtractLargestConnectedNetwork,...
        handles.markovClustering,...
        handles.ModuleMCODE,...
        handles.ModuleClusterOne,...
        handles.alwaysViewGraphInset,...
        handles.EditViewNetworkSigmajs, ...
        handles.NetworkEvolutionRewireEdge, ...
        handles.NetworkEvolutionNodeLoss, ...
        handles.NetworkEvolutionNodeDuplication, ...
        handles.NetworkEvolutionPreferentialAttachment, ...
        handles.LoadDeducedNetwork, ...
        handles.EditAnnotateNodeList, ...
        handles.EditGetAnnotation, ...
        handles.isRandomEvolution, ...
        handles.EditGetAnnotationMulitplNodes];
    
if isempty(sbeG)
    set(cannotbeempty,'enable', 'off');   
    %set(handles.execute, 'enable', 'off');
else
    set(cannotbeempty,'enable','on');
    
    %[checkN, ~] = readnetsession('sbeVars');
    [checkN, ~] = getcurrentnetsession;
    guiOutput = cell(5, 1);
    if isempty(checkN)
        guiOutput{1} = sprintf('\n%s\n',...
            'Session not found ( Network not yet loaded ) !');
        if exist('sbeG', 'var')
            clear global sbeG;
            set(cannotbeempty,'enable','off');
            set(handles.NetworkInformation, 'String', guiOutput);
            set(handles.NetworkInformation, 'ForegroundColor', 'red');
            return;
        end
    else
        guiOutput{1} = sprintf('\n%s\n%s',...
            ['Current loaded network : ', ...
            retFname], ...
            '=======================================');
        guiOutput = viewnetinfo_gui(sbeG, guiOutput);
        
        if size(sbeG,1) > 9000
            guiOutput{5} = sprintf('%s\n%s', ...
                '=======================================', ...
                'WARNING: Working with a large network may take time during compuation of some statistics. Working with a sub-network around a node of interest or largest connected network may improve speed (?)');
            set(handles.NetworkInformation, 'ForegroundColor', [1, .55, 0]);
        else
            %set(handles.NetworkInformation, 'ForegroundColor', [0, .6, 0]);
            set(handles.NetworkInformation, 'ForegroundColor', 'green');
            guiOutput{5} = sprintf('=======================================\n');
        end
        set(handles.NetworkInformation, 'String', guiOutput);
    end  
    
    if issymmetric(sbeG)
        set(handles.EditSymmetrizeAdjacencyMatrix,'enable','off');
    end    
    
    if ispref('SBEToolbox', 'isRestore') && getpref('SBEToolbox', 'isRestore') == 1
        set(handles.EditRestoreNetwork,'enable','on');
    else
        set(handles.EditRestoreNetwork,'enable','off');
    end    

    if exist('deduced_net', 'var') && ~isempty(deduced_net) && ~isempty(sbeG)
        set(handles.LoadDeducedNetwork, 'enable', 'on');
    else
        set(handles.LoadDeducedNetwork, 'enable', 'off');
    end
    
end

if getpref('SBEToolbox', 'NetEvolMsg') == 99
    set(handles.EditRestoreNetwork, 'enable', 'on');
    guiOutput{1} = sprintf('\n%s\n%s',...
        ['Current loaded network : ', ...
        retFname], ...
        '=======================================');
    guiOutput = viewnetinfo_gui(sbeG, guiOutput);
    guiOutput{end+1} = sprintf('=======================================\n');
    set(handles.NetworkInformation, 'ForegroundColor', 'red');
    set(handles.NetworkInformation, 'String', guiOutput);
end


% --- Executes when user attempts to close SBEToolboxGUI.
function SBEToolboxGUI_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to SBEToolboxGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
if ~isempty(timerfindall('Name', 'SBEGUI_CurrentMemUsage'))
    stop(timerfindall('Name', 'SBEGUI_CurrentMemUsage'));
    delete(timerfindall('Name', 'SBEGUI_CurrentMemUsage'));
end
%NetworkClose_Callback(hObject, eventdata, handles);
delete(hObject);
