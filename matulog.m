function varargout = matulog(varargin)
% MATULOG MATLAB code for matulog.fig
%      MATULOG, by itself, creates a new MATULOG or raises the existing
%      singleton*.
%
%      H = MATULOG returns the handle to a new MATULOG or the handle to
%      the existing singleton*.
%
%      MATULOG('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MATULOG.M with the given input arguments.
%
%      MATULOG('Property','Value',...) creates a new MATULOG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the MATULOG before matulog_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to matulog_OpeningFcn via varargin.
%
%      *See MATULOG Options on GUIDE's Tools menu.  Choose "MATULOG allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help matulog

% Last Modified by GUIDE v2.5 04-Jul-2017 16:33:26

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @matulog_OpeningFcn, ...
    'gui_OutputFcn',  @matulog_OutputFcn, ...
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


% --- Executes just before matulog is made visible.
function matulog_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to matulog (see VARARGIN)

% Choose default command line output for matulog
handles.output = hObject;

% Add gui_functions folders to path
addpath(genpath([pwd '/gui_functions']))
addpath(genpath([pwd '/utilities']))

% Get name of logfile and path
if exist('defaults.mat')
    load 'defaults.mat';
    handles.current_fileName = defaults.current_fileName;
    handles.current_dir_PathName = defaults.current_dir_PathName;
    if ~exist([handles.current_dir_PathName handles.current_fileName '.mat']) || ~exist([handles.current_dir_PathName handles.current_fileName '.ulg'])
        [handles.current_fileName, handles.current_dir_PathName] = get_current_logfile_popup(handles);
    end
else
    [handles.current_fileName, handles.current_dir_PathName] = get_current_logfile_popup(handles);
end
run openLogFile.m

set(handles.popupmenu_logfiles,'String', handles.ulog_files_in_dir);
index = find(contains(handles.ulog_files_in_dir, handles.current_fileName));
set(handles.popupmenu_logfiles, 'Value', index);

% Activate multiselection for the fields listbox
set(handles.listbox_fieldnames,'Max',2,'Min',0);

handles.line_spec = '-';
handles.line_width = 1;

set(handles.listbox_topics,'Value',1);
set(handles.listbox_fieldnames,'Value',1);

handles.currently_selected_variables(1).topic = handles.selected_topic;
handles.currently_selected_variables(1).field = handles.data.(handles.selected_topic).Properties.VariableNames{1};
handles.currently_selected_variables(1).field_name = handles.data.(handles.selected_topic).Properties.VariableDescriptions{1};

handles.currently_displayed_variables = get_currently_displayed_variables( handles );

% Update handles structure
guidata(hObject, handles);
update_plot(handles)
uicontrol(handles.listbox_topics) % Make listbox_topics active

% UIWAIT makes matulog wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = matulog_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;

% --- Executes on selection change in listbox_topics.
function listbox_topics_Callback(hObject, eventdata, handles)
% Get selected topic
handles.selected_topic = handles.topic_names{get(hObject,'Value')};

% Update the fieldnames listbox to display the fields of the selected topic
set(handles.listbox_fieldnames,'String',handles.data.(handles.selected_topic).Properties.VariableDescriptions);

% Make the fieldnames in the listbox that are currently displayed grey
idx = [];
logic_topic = find(strcmp({handles.currently_selected_variables.topic},handles.selected_topic));
for i = 1:length(logic_topic)
    idx(i) = find(strcmp(handles.listbox_fieldnames.String,{handles.currently_selected_variables(logic_topic(i)).field_name}));
end
set(handles.listbox_fieldnames,'Value',idx);

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function listbox_topics_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in listbox_fieldnames.
function listbox_fieldnames_Callback(hObject, eventdata, handles)
% Check if ctrl was pressed, if not -> clear all variables to display
ctrlIsPressed = ismember('control',get(gcf,'currentModifier'));
if ctrlIsPressed == 0
    handles.currently_selected_variables = [];
    L = 0;
else
    handles.currently_selected_variables(strcmp({handles.currently_selected_variables.topic},handles.selected_topic)) = [];
    L = length(handles.currently_selected_variables);
end
selected = get(hObject,'Value');
for i = 1:length(selected)
    handles.currently_selected_variables(L+i).topic = handles.selected_topic;
    handles.currently_selected_variables(L+i).field = handles.data.(handles.selected_topic).Properties.VariableNames{selected(i)};
    handles.currently_selected_variables(L+i).field_name = handles.data.(handles.selected_topic).Properties.VariableDescriptions{selected(i)};
end

% Get which fields are currently selected
handles.currently_displayed_variables = get_currently_displayed_variables( handles );

% {handles.selected_var.field_name}'
update_plot(handles)
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function listbox_fieldnames_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function topbar_file_Callback(hObject, eventdata, handles)
[handles.current_fileName handles.current_dir_PathName] = get_current_logfile_popup(handles);
run openLogFile.m
set(handles.popupmenu_logfiles,'String',handles.ulog_files_in_dir);
index = find(contains(handles.ulog_files_in_dir, handles.current_fileName));
set(handles.popupmenu_logfiles, 'Value', index);
handles.currently_displayed_variables = get_currently_displayed_variables( handles );
update_plot(handles)
guidata(hObject, handles);
uicontrol(handles.listbox_topics) % Make listbox_topics active

% --- Executes on selection change in popupmenu_logfiles.
function popupmenu_logfiles_Callback(hObject, eventdata, handles)
handles.current_fileName = handles.ulog_files_in_dir{get(hObject,'Value')};
run openLogFile.m
handles.currently_displayed_variables = get_currently_displayed_variables( handles );
update_plot(handles)
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function popupmenu_logfiles_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% Save information on the current session to use next time matulog is
% launched
defaults.current_fileName = handles.current_fileName;
defaults.current_dir_PathName = handles.current_dir_PathName;
save('defaults.mat','defaults');
delete(hObject);
clear defaults

function line_spec_lines_Callback(hObject, eventdata, handles)
handles.line_spec = '-';
guidata(hObject, handles);
update_plot(handles)

function line_spec_dots_Callback(hObject, eventdata, handles)
handles.line_spec = '.';
guidata(hObject, handles);
update_plot(handles)

function axes_context_menu_Callback(hObject, eventdata, handles)

function line_spec_linesAndDots_Callback(hObject, eventdata, handles)
handles.line_spec = '.-';
guidata(hObject, handles);
update_plot(handles)

function line_spec_Callback(hObject, eventdata, handles)

function marker_width_Callback(hObject, eventdata, handles)

function marker_width_1_Callback(hObject, eventdata, handles)
handles.line_width = 1;
guidata(hObject, handles);
update_plot(handles)

function marker_width_1p5_Callback(hObject, eventdata, handles)
handles.line_width = 1.5;
guidata(hObject, handles);
update_plot(handles)

function marker_width_2_Callback(hObject, eventdata, handles)
handles.line_width = 2;
guidata(hObject, handles);
update_plot(handles)

% --- Executes on key press with focus on listbox_topics and none of its controls.
function listbox_topics_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to listbox_topics (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA
if strcmp(eventdata.Key,'rightarrow')
    set(handles.listbox_fieldnames,'Value',1);
    uicontrol(handles.listbox_fieldnames) % Make listbox_fieldnames active
    
    handles.currently_selected_variables = [];
    handles.currently_selected_variables(1).topic = handles.selected_topic;
    handles.currently_selected_variables(1).field = handles.data.(handles.selected_topic).Properties.VariableNames{1};
    handles.currently_selected_variables(1).field_name = handles.data.(handles.selected_topic).Properties.VariableDescriptions{1};

    % Get which fields are currently selected
    handles.currently_displayed_variables = get_currently_displayed_variables( handles );
    update_plot(handles)
    guidata(hObject, handles);
end

% --- Executes on key press with focus on listbox_fieldnames and none of its controls.
function listbox_fieldnames_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to listbox_fieldnames (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
if strcmp(eventdata.Key,'leftarrow')
    uicontrol(handles.listbox_topics) % Make listbox_topics active
end

function topbar_plot_Callback(hObject, eventdata, handles)

function topbar_export_plot_Callback(hObject, eventdata, handles)
[FileName,PathName,~] = uiputfile('','Save image as',handles.current_dir_PathName);
if FileName ~= 0
    export_fig(handles.axes1, [PathName FileName]);
end
