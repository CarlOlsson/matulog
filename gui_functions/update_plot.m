function update_plot( handles )
for i = 1:length(handles.selected_var)
    time_vector = handles.data.(handles.selected_var(i).topic).timestamp./1e6; % convert from us to s
    h = plot(time_vector, handles.data.(handles.selected_var(i).topic).(handles.selected_var(i).field),handles.line_spec,'linewidth',handles.line_width, 'Color', handles.selected_var(i).color);
    hold on
end

hold off
grid on
xlim([time_vector(1) time_vector(end)])
legend({handles.selected_var.field_name}, 'Interpreter', 'none');
xlabel('Time [s]')
end