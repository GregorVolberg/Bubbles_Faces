function [fmat] = get_filemat(fp, vpm)
% get_filemat(fpath, vpmat, conditions);
fmat = {};
for vp = 1:numel(vpm)
    tmp  = dir([fp, vpm{vp}, '\', vpm{vp}, '_*']);
    tmp2 = strcat({tmp.folder}', cellstr(repmat('\', numel(tmp), 1)), {tmp.name}'); 
    tmp3 = sort(tmp2(~[tmp.isdir]));
    fmat{vp} = tmp3;   
end
fmat = fmat';
end
