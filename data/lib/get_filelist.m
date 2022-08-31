function [flist] = get_filelist(path_in, file_pattern)
tmp = dir([path_in, file_pattern]);
flist = strcat({tmp.folder}', '\', {tmp.name}');
end