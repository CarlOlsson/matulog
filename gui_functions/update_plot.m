function update_plot( handles )
x_min = handles.data.(handles.currently_displayed_variables(1).topic).timestamp(1)./1e6;
x_max = handles.data.(handles.currently_displayed_variables(1).topic).timestamp(end)./1e6;
for i = 1:length(handles.currently_displayed_variables)
    time_vector = handles.data.(handles.currently_displayed_variables(i).topic).timestamp./1e6; % convert from us to s
    if time_vector(1) < x_min
        x_min = time_vector(1);
    end
    if time_vector(end) > x_max
        x_max = time_vector(end);
    end
    h = plot(time_vector, handles.data.(handles.currently_displayed_variables(i).topic).(handles.currently_displayed_variables(i).field),handles.line_spec,'linewidth',handles.line_width, 'Color', handles.currently_displayed_variables(i).color);
    hold on
end

hold off
grid on
try
    xlim([x_min x_max])
catch
    disp('Failed setting xlim, no datapoints logged for the selected topic?')
end
legend({handles.currently_displayed_variables.full_name}, 'Interpreter', 'none');
xlabel('Time [s]')

%Pass the handles struct to the cursor fcn
setappdata(gca,'handles',handles);
dcmObj = datacursormode(gcf);
set(dcmObj,'UpdateFcn',@matulog_cursor_fcn,'Enable','on');
    
end