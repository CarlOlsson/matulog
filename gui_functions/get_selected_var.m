function currently_displayed_variables = get_selected_var( handles )
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

selected_var_tmp.array = [{handles.currently_selected_variables.topic}' {handles.currently_selected_variables.field}'];
selected_var_tmp.array_names = [{handles.currently_selected_variables.topic}' {handles.currently_selected_variables.field_name}'];

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
    currently_displayed_variables(i).topic = tmp{1};
    currently_displayed_variables(i).field = tmp{2};
    currently_displayed_variables(i).full_name = disp_variables.names{i};
    currently_displayed_variables(i).color = color{row,1};
end
end


