function [current_fileName, current_dir_PathName] = get_current_logfile_popup(handles)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% Set the starting directory of the popup window. Will this work on
% windows?
if isfield(handles,'current_dir_PathName')
    s = handles.current_dir_PathName(1:end-1);
    idx = max(strfind(s,'/'));
    start_dir = s(1:idx);
else
    start_dir = '~/';
end
[FileNameDotExt, current_dir_PathName, ~] = uigetfile([start_dir '/*.ulg'], 'Select the .ulg file');
[~, current_fileName, ~] = fileparts([current_dir_PathName FileNameDotExt]);
end


