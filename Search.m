function varargout = Search(varargin)
% SEARCH MATLAB code for Search.fig
%      SEARCH, by itself, creates a new SEARCH or raises the existing
%      singleton*.
%
%      H = SEARCH returns the handle to a new SEARCH or the handle to
%      the existing singleton*.
%
%      SEARCH('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SEARCH.M with the given input arguments.
%
%      SEARCH('Property','Value',...) creates a new SEARCH or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Search_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Search_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Search
%
% Search - Dynamic search function will respond to user input and returns
% found results.
%
% Systems Biology and Evolution Toolbox (SBEToolbox).
% Authors: Kranti Konganti, James Cai.
% (C) Texas A&M University.
%
% $LastChangedDate: 2013-06-07 16:21:42 -0500 (Fri, 07 Jun 2013) $
% $LastChangedRevision: 598 $
% $LastChangedBy: konganti $
%
% Last Modified by GUIDE v2.5 07-Jun-2013 15:14:08

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Search_OpeningFcn, ...
                   'gui_OutputFcn',  @Search_OutputFcn, ...
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


% Position the GUI at center of screen
%movegui(gcf(), 'center');


% --- Executes just before Search is made visible.
function Search_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Search (see VARARGIN)

% Choose default command line output for Search
handles.output = hObject;

% Set listbox and global variables
global query queryIndex sbeNodeSearch
query = cell(1,1);
queryIndex = 1;
sbeNodeSearch = varargin{1};
set(handles.SearchTitle, 'String', varargin{2});
set(handles.SearchListBox, 'String', sbeNodeSearch);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Search wait for user response (see UIRESUME)
 uiwait(handles.SearchGUI);


% --- Outputs from this function are returned to the command line.
function varargout = Search_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
global userSelected sbeNodeSearch noregex
if ~iscell(userSelected)
    varargout{1} = 0;
elseif isempty(noregex)
    varargout{1} = find(~cellfun(@isempty,regexpi(sbeNodeSearch, userSelected)));
    if size(varargout{1}, 1) > 1, varargout{1} = datasample(varargout{1}, ...
            1, 'Replace', true); end
elseif noregex == 1
    %patmatch = strcat('^', userSelected, '$');
    %varargout{1} = find(~cellfun(@isempty,regexpi(sbeNodeSearch, patmatch)));
    varargout{1} = find(strcmp(sbeNodeSearch, userSelected));
    if size(varargout{1}, 1) > 1, varargout{1} = datasample(varargout{1}, ...
            1, 'Replace', true); end
end

function SearchNode_Callback(hObject, eventdata, handles)
% hObject    handle to SearchNode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SearchNode as text
%        str2double(get(hObject,'String')) returns contents of SearchNode as a double


% --- Executes during object creation, after setting all properties.
function SearchNode_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SearchNode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over SearchNode.
function SearchNode_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to SearchNode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if strcmp(get(handles.SearchGUI, 'SelectionType'), 'normal') ||...
    strcmp(get(handles.SearchGUI, 'SelectionType'), 'open')
    set(hObject, 'Enable', 'On');
    set(handles.SearchNode, 'String', '');
end


% --- Executes on key press with focus on SearchNode and none of its controls.
function SearchNode_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to SearchNode (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
global query queryIndex sbeNodeSearch userSelected noregex
set(handles.SearchListBox, 'value', 1);
if length(eventdata.Key) == 1 || strcmpi(eventdata.Key, 'space')
    %disp(eventdata.Key);
    if strcmpi(eventdata.Key, 'space')
        query{1}(queryIndex) = ' ';
    else
        query{1}(queryIndex) = eventdata.Key;
    end
    queryIndex = queryIndex + 1;
    searchResIndexes = find(~cellfun(@isempty,regexpi(sbeNodeSearch, query{1})));
    setListBox(hObject, eventdata, handles, searchResIndexes);
elseif strcmp(eventdata.Key, 'backspace')
    %disp(query);
    queryIndex = queryIndex - 1;
    if queryIndex <= 1
        queryIndex = 1;
        setListBox(hObject, eventdata, handles, 0);
    else
        query{1}(queryIndex) = '';
        searchResIndexes = find(~cellfun(@isempty,regexpi(sbeNodeSearch, query{1})));
        setListBox(hObject, eventdata, handles, searchResIndexes);
    end
elseif strcmp(eventdata.Key, 'return') || strcmp(eventdata.Key, 'enter')
    userSelected = query;
    noregex = 1;
    Search_OutputFcn(hObject, eventdata, handles);
    close;
end


% --- Executes on selection change in SearchListBox.
function SearchListBox_Callback(hObject, eventdata, handles)
% hObject    handle to SearchListBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns SearchListBox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from SearchListBox
global userSelected noregex
contents = cellstr(get(hObject, 'String'));
userSelected = contents(get(hObject, 'Value'));
if (strcmp(get(handles.SearchGUI, 'SelectionType'), 'open'))
    noregex = 1;
    Search_OutputFcn(hObject, eventdata, handles);
    close;
end


% --- Executes during object creation, after setting all properties.
function SearchListBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SearchListBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in SearchOK.
function SearchOK_Callback(hObject, eventdata, handles, varargout)
% hObject    handle to SearchOK (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Search_OutputFcn(hObject, eventdata, handles);
close

% --- Executes on button press in SearchCancel.
function SearchCancel_Callback(hObject, eventdata, handles)
% hObject    handle to SearchCancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global userSelected
userSelected = 0;
Search_OutputFcn(hObject, eventdata, handles);
close

% --- Sets the list box per found node names
function setListBox (hObject, eventdata, handles, indexes)
% hObject    handle to SearchCancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global sbeNodeSearch
if indexes == 0
    showCount = size(sbeNodeSearch, 1);
    set(handles.SearchListBox, 'String', sbeNodeSearch);
else
    showCount = length(indexes);
    sbeNodeSearchUpdate = cell(length(indexes), 1);
    for i = 1:length(indexes)
        sbeNodeSearchUpdate{i} = sbeNodeSearch{indexes(i)};
    end
    set(handles.SearchListBox, 'String', sbeNodeSearchUpdate);
end
resCount{1} = sprintf('%s%d%s%d', 'Showing ', showCount,...
    ' of ', max(size(sbeNodeSearch)));
set(handles.SearchResultCount, 'String', resCount);


% --- Executes on key press with focus on SearchOK and none of its controls.
function SearchOK_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to SearchOK (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
if strcmp(eventdata.Key, 'return') || strcmp(eventdata.Key, 'enter')
    Search_OutputFcn(hObject, eventdata, handles);
    close;
end


% --- Executes on key press with focus on SearchCancel and none of its controls.
function SearchCancel_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to SearchCancel (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
global userSelected
if strcmp(eventdata.Key, 'return') || strcmp(eventdata.Key, 'enter')
    userSelected = 0;
    Search_OutputFcn(hObject, eventdata, handles);
    close;
end


% --- Executes on key press with focus on SearchListBox and none of its controls.
function SearchListBox_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to SearchListBox (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
global userSelected
contents = cellstr(get(hObject,'String'));
userSelected = contents(get(hObject, 'Value'));
if strcmp(eventdata.Key, 'return') || strcmp(eventdata.Key, 'enter')
    %disp('well hello');
    Search_OutputFcn(hObject, eventdata, handles);
    close;
end


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over SearchCancel.
function SearchCancel_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to SearchCancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global userSelected
if strcmp(eventdata.Key, 'return') || strcmp(eventdata.Key, 'enter')
    userSelected = 0;
    Search_OutputFcn(hObject, eventdata, handles);
    close;
end


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over SearchOK.
function SearchOK_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to SearchOK (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 Search_OutputFcn(hObject, eventdata, handles);
 close;


% --- Executes when user attempts to close SearchGUI.
function SearchGUI_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to SearchGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
delete(hObject);


% --- Executes during object creation, after setting all properties.
function SearchGUI_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SearchGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object deletion, before destroying properties.
function SearchGUI_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to SearchGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on mouse press over figure background.
function SearchGUI_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to SearchGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function SearchGUI_WindowButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to SearchGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on mouse motion over figure - except title and menu.
function SearchGUI_WindowButtonMotionFcn(hObject, eventdata, handles)
% hObject    handle to SearchGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function SearchGUI_WindowButtonUpFcn(hObject, eventdata, handles)
% hObject    handle to SearchGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on key press with focus on SearchGUI or any of its controls.
function SearchGUI_WindowKeyPressFcn(hObject, eventdata, handles)
% hObject    handle to SearchGUI (see GCBO)
% eventdata  structure with the following fields (see FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on key release with focus on SearchGUI or any of its controls.
function SearchGUI_WindowKeyReleaseFcn(hObject, eventdata, handles)
% hObject    handle to SearchGUI (see GCBO)
% eventdata  structure with the following fields (see FIGURE)
%	Key: name of the key that was released, in lower case
%	Character: character interpretation of the key(s) that was released
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) released
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on scroll wheel click while the figure is in focus.
function SearchGUI_WindowScrollWheelFcn(hObject, eventdata, handles)
% hObject    handle to SearchGUI (see GCBO)
% eventdata  structure with the following fields (see FIGURE)
%	VerticalScrollCount: signed integer indicating direction and number of clicks
%	VerticalScrollAmount: number of lines scrolled for each click
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on key press with focus on SearchGUI and none of its controls.
function SearchGUI_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to SearchGUI (see GCBO)
% eventdata  structure with the following fields (see FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on key release with focus on SearchGUI and none of its controls.
function SearchGUI_KeyReleaseFcn(hObject, eventdata, handles)
% hObject    handle to SearchGUI (see GCBO)
% eventdata  structure with the following fields (see FIGURE)
%	Key: name of the key that was released, in lower case
%	Character: character interpretation of the key(s) that was released
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) released
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when SearchGUI is resized.
function SearchGUI_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to SearchGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over SearchListBox.
function SearchListBox_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to SearchListBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
