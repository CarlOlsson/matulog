function update_plot( handles )
for i = 1:length(handles.currently_displayed_variables)
    time_vector = handles.data.(handles.currently_displayed_variables(i).topic).timestamp./1e6; % convert from us to s
    h = plot(time_vector, handles.data.(handles.currently_displayed_variables(i).topic).(handles.currently_displayed_variables(i).field),handles.line_spec,'linewidth',handles.line_width, 'Color', handles.currently_displayed_variables(i).color);
    hold on
end

hold off
grid on
xlim([time_vector(1) time_vector(end)])
legend({handles.currently_displayed_variables.full_name}, 'Interpreter', 'none');
xlabel('Time [s]')

%Pass the handles struct to the cursor fcn
setappdata(gca,'handles',handles);
dcmObj = datacursormode(gcf);
set(dcmObj,'UpdateFcn',@matulog_cursor_fcn,'Enable','on');
    
end