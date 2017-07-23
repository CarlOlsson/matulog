function output_txt = matulog_cursor_fcn(obj,event_obj)
% Display the position of the data cursor
% obj          Currently not used (empty)
% event_obj    Handle to event object
% output_txt   Data cursor text string (string or cell array of strings).
% Get the parent of the target object (i.e. the axes):
hAxes = get(get(event_obj,'Target'),'Parent');
% Get the data stored with the axes object:
handles = getappdata(hAxes,'handles');
% Get the data index (i.e. the x position):
pos = get(event_obj,'Position');

for i = 1:length(handles.currently_displayed_variables)
    data = handles.data.(handles.currently_displayed_variables(i).topic).(handles.currently_displayed_variables(i).field);
    timestamp = handles.data.(handles.currently_displayed_variables(i).topic).timestamp./1e6;
    tmp = find(timestamp<pos(1));
    index = tmp(end);
    output_txt{i} = [handles.currently_displayed_variables(i).full_name ': ' num2str(data(index))];
end
output_txt{end+1} = ['timestamp [s]: ' num2str(pos(1))];

end