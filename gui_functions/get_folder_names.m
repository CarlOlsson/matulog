function folder_names = get_folder_names( path )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

% Get a list of all files and folders in this folder.
files = dir(path);
% Get a logical vector that tells which is a directory.
dirFlags = [files.isdir];
% Extract only those that are directories.
subFolders = files(dirFlags);

for i = 1:length(subFolders)

    tmp(i).name = subFolders(i).name;
end

% Print folder names to command window.
i = 1;
for k = 1 : length(subFolders)
    if(any(size(dir([path '/' subFolders(k).name '/*.ulg' ]),1)) && ~strcmp(subFolders(k).name, '.') && ~strcmp(subFolders(k).name, '..'))
        folder_names{i} = subFolders(k).name;
        i = i + 1;
    end
end

end

