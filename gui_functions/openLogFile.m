current_path = pwd;
eval(['cd ' handles.current_dir_PathName])
set(handles.figure1, 'pointer', 'watch')
drawnow;
if ~exist([handles.current_fileName '.mat'])
    log = ulg2mat(handles.current_fileName);
else
    load([handles.current_fileName '.mat']);
end

set(handles.figure1, 'pointer', 'arrow')
handles.data = log.data;
clear log
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
if ~isfield(handles,'selected_topic') || ~any(contains(handles.topic_names,handles.selected_topic))
    handles.selected_topic = handles.topic_names{1};
    set(handles.listbox_topics,'Value',1);
    set(handles.listbox_fieldnames,'Value',1);
    handles.currently_selected_variables = [];
    handles.currently_selected_variables(1).topic = handles.selected_topic;
    handles.currently_selected_variables(1).field = handles.data.(handles.selected_topic).Properties.VariableNames{1};
    handles.currently_selected_variables(1).field_name = handles.data.(handles.selected_topic).Properties.VariableDescriptions{1};

else
    set(handles.listbox_topics,'Value',find(strcmp(handles.topic_names,handles.selected_topic)));
end
set(handles.listbox_topics,'String',handles.topic_names);
set(handles.listbox_fieldnames,'String',handles.data.(handles.selected_topic).Properties.VariableDescriptions);
set(handles.popupmenu_logfiles,'String',handles.ulog_files_in_dir);
index = find(contains(handles.ulog_files_in_dir, handles.current_fileName));
set(handles.popupmenu_logfiles, 'Value', index);