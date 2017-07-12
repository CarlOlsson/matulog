function selected_var = get_selected_var( handles )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
persistent disp_variables       % Variables to display in order
persistent counter              % To compare number of variables
persistent color                % To assign colors
persistent selected_var_tmp;

ctrlIsPressed = ismember('control',get(gcf,'currentModifier'));
if ctrlIsPressed == 0
    disp_variables = [];
    counter = [];
    color = [];
    selected_var_tmp = [];
end
currently_displayed_topic = [];
currently_displayed_field = [];
currently_displayed_field_name = [];
count = 0;
for i = 1:length(handles.topic_names)
    topic_name_i = handles.topic_names{i};
    idx = handles.data.(topic_name_i).Properties.UserData;
    topic_fieldnames = fieldnames(handles.data.(topic_name_i));
    topic_fieldnames_name = handles.data.(topic_name_i).Properties.VariableDescriptions;
    if ~isempty(idx)
        for j = idx
            count = count + 1;
            if count < 15
            topic_field = topic_fieldnames(j);
            topic_field_name = topic_fieldnames_name(j);
            currently_displayed_topic{count} = topic_name_i;
            currently_displayed_field = [currently_displayed_field;topic_field];
            currently_displayed_field_name = [currently_displayed_field_name;topic_field_name];
            end
        end
    end
end

selected_var_tmp.array = [currently_displayed_topic' currently_displayed_field];
selected_var_tmp.array_names = [currently_displayed_topic' currently_displayed_field_name];

selected_var_tmp.var_merged = [];
for i = 1:size(selected_var_tmp.array,1)
    selected_var_tmp.var_merged{i,1} = [selected_var_tmp.array{i,1} '.' selected_var_tmp.array{i,2}];
    selected_var_tmp.names_merged{i,1} = [selected_var_tmp.array{i,1} '.' selected_var_tmp.array_names{i,2}];
end

% If only one variable selected - reset all
if length(selected_var_tmp.var_merged) == 1 || ctrlIsPressed == 0
    disp_variables.var = selected_var_tmp.var_merged;
    disp_variables.names = selected_var_tmp.names_merged;
    % color cell: {color, name of assigned variable}
    color = {[0 0 1], [];   % blue
        [1 0 0], [];                                % red
        [1 .5 0],[];                                % orange
        [1 0 1], [];                                % magenta
        [0 1 0], [];                                % green
        [0 1 1], [];                                % cyan
        [0 0 0], [];                                % black
        [.6 .8 0], [];                              % light blue
        [.6 .3 0],[];                               % brown
        [.8 .6 1], [];                              % purple
        [1 .6 .8], [];                              % pink
        [.6 1 .8], [];                              % teal
        [.75 .75 .75], [];                          % grey
        [1 1 0], []};                               % yellow
    for i = 1:length(selected_var_tmp.var_merged)
        color{i,2} = cellstr(selected_var_tmp.var_merged{i});
    end
end

% Check if variable has been discarded
if length(selected_var_tmp.var_merged) == (counter-1)
    % Free assigned color
    [row, ~] = find(cellfun(@(x) any(strcmp(x,selected_var_tmp.var_merged)),color));
    for i = 1:length(color)
        if ~ismember(i,row)
            color{i,2} = [];
        end
    end
    % Remove the variable from display
    still_displayed = ismember(disp_variables.var, selected_var_tmp.var_merged);
    disp_variables.var = disp_variables.var(still_displayed);
    disp_variables.names = disp_variables.names(still_displayed);
end

% Update counter
counter = length(selected_var_tmp.var_merged);
% Add variable if not on the list
[~,index] = ismember(disp_variables.var, selected_var_tmp.var_merged);
temp = ~ismember(1:length(selected_var_tmp.var_merged),index);
disp_variables.var = [disp_variables.var; selected_var_tmp.var_merged(temp)];
disp_variables.names = [disp_variables.names; selected_var_tmp.names_merged(temp)];
temp3 = selected_var_tmp.var_merged(temp);
c = 0;
% Assign first free color to the variable
for k = 1:length(color)
    if isempty(color{k,2}) && any(temp)
        c = c + 1;
        color{k, 2} = temp3(c);
        if c == length(temp3)
            break;
        end
    end
end

for i = 1:length(selected_var_tmp.var_merged)
    tmp = strsplit(disp_variables.var{i},'.');
    selected_var_tmp.array_sorted{i,1} = tmp{1};
    selected_var_tmp.array_sorted{i,2} = tmp{2};
    selected_var_tmp.var_merged_sorted{i,1} = [selected_var_tmp.array_sorted{i,1} '.' selected_var_tmp.array_sorted{i,2}];
    [row, ~] = find(cellfun(@(x) any(strcmp(x, selected_var_tmp.var_merged_sorted{i})), color));
    selected_var_tmp.color_sorted{i,1} = color{row,1};
    selected_var_tmp.names_sorted{i,1} = disp_variables.names{i};
    selected_var(i).topic = tmp{1};
    selected_var(i).field = tmp{2};
    selected_var(i).field_name = disp_variables.names{i};
    selected_var(i).color = color{row,1};
end
end


