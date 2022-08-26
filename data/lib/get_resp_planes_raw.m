
function [] = get_resp_planes_raw(rawData, rppath, vp_selection, patches, npic)
% select participants
tmpcell = {rawData(:).vpcode}';
if all(ismember(vp_selection, 'all'))
    vpnums = 1:numel(rawData);
else
    vpnums = find(ismember(tmpcell, vp_selection));
end
% loop
for vpnr = 1:numel(vpnums)
vp = vpnums(vpnr);
for scale = 1:5
res_planes_raw = zeros([rawData(vp).picdims, size(rawData(vp).outmat,1)]);
tmp = [];
for trial = 1:numel(rawData(vp).b_centers)
tmp = add_alphaplane(patches{scale}, npic{1}, rawData(vp).b_centers{trial}{scale}, rawData(vp).b_dims{trial}{scale}, rawData(vp).f_coords{trial}{scale}); %one patch size at a time
res_planes_raw(:, :, trial) =  res_planes_raw(:, :, trial) + tmp;
end
cns = unique(rawData(vp).outmat(:,14));
for j = 1:numel(cns)
rp = res_planes_raw(:, :, rawData(vp).outmat(:,14) == cns(j));   
save([rppath, 'rp_' rawData(vp).vpcode, '_s', num2str(scale), '_c', num2str(cns(j)), '_raw.mat'], 'rp'); clear rp
end
end
end
end

