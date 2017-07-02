current_path = pwd;
eval(['cd ' handles.current_dir_PathName])
if ~exist([handles.current_fileName '.mat'])
    set(handles.figure1, 'pointer', 'watch')
    drawnow;
    ulg2mat(handles.current_fileName);
    set(handles.figure1, 'pointer', 'arrow')
end
load([handles.current_fileName '.mat']);
handles.data = data;
clear data
tmp = dir('*.ulg');
% Remove .ulg extension
for i = 1:length(tmp)
    tmp2 = strsplit(tmp(i).name,'.');
    tmp(i).name = tmp2{1};
end
handles.ulog_files_in_dir = {tmp(:).name}';
eval(['cd ' current_path]);

% Set GUI window title
set(handles.figure1, 'Name', ['Matulog - ' handles.current_dir_PathName handles.current_fileName '.ulg']);

handles.topic_names = fieldnames(handles.data);
handles.selected_topic = handles.topic_names{1};
handles.selected_field = handles.data.(handles.topic_names{1}).Properties.VariableNames{1};
set(handles.listbox_topics,'String',handles.topic_names);
set(handles.listbox_fieldnames,'String',handles.data.(handles.topic_names{1}).Properties.VariableDescriptions);
set(handles.popupmenu_logfiles,'String',handles.ulog_files_in_dir);
index = find(contains(handles.ulog_files_in_dir, handles.current_fileName));
set(handles.popupmenu_logfiles, 'Value', index);