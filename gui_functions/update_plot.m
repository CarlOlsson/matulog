function update_plot( handles )
currently_displayed = [];
for i = 1:length(handles.topic_names)
    topic_ind = handles.topic_names{i};
    topic_fieldnames = handles.data.(topic_ind).Properties.VariableDescriptions';
    ind = handles.data.(topic_ind).Properties.UserData;
    data_to_plot = handles.data.(topic_ind){:,ind};
    if ~isempty(data_to_plot)
        topic_field = topic_fieldnames(ind);
        for j=1:length(topic_field)
            topic_field{j} = [topic_ind '.' topic_field{j}];
        end
        currently_displayed = [currently_displayed;topic_field];
        time_vector = handles.data.(topic_ind).timestamp./1e6; % convert from us to s
        h = plot(time_vector, handles.data.(topic_ind){:,handles.data.(topic_ind).Properties.UserData},handles.line_spec,'linewidth',handles.line_width);
        hold on
    end
end
hold off
grid on
xlim([time_vector(1) time_vector(end)])
legend(currently_displayed, 'Interpreter', 'none');
xlabel('Time [s]')
