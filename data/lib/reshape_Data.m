function [rawData] = reshape_Data(allData)
rawData = [];

for vp = 1:numel(allData)
vpData = [];
outmat = [];
vpData = [allData{vp}.Bubbles];
outmat = cat(1, vpData(:).outmat);
ntrials = size(outmat, 1);

% add number of Bubbles
b_centers = cat(1, vpData(:).b_centers);
b_count   = NaN(ntrials, length(b_centers{1}));
for trial = 1:ntrials
    for scales = 1:numel(b_centers{1})
    b_count(trial, scales) = length(b_centers{trial}{scales});
    end
end

outmat = [[1:size(outmat, 1)]', outmat, b_count];

% not necessary here. Add anyways
% add condition code to outmat
con_code = [];
con_code(outmat(:, 6) == 1) = 1; %correct
con_code(outmat(:, 6) == 0) = 0; % incorrect
outmat(:, 14) = con_code; clear con_code
% 0: incorrect
% 1: correct


rawData(vp).vpcode     = vpData(1).vp;
rawData(vp).outmat     = outmat;
rawData(vp).b_centers  = b_centers;
rawData(vp).b_dims     = cat(1, vpData(:).b_dims);
rawData(vp).f_coords   = cat(1, vpData(:).f_coords);
rawData(vp).picdims    = vpData(1).picdims;
rawData(vp).facedims   = vpData(1).facedims;
rawData(vp).sd_Gauss   = vpData(1).sd_Gauss;
rawData(vp).num_cycles = vpData(1).num_cycles;
rawData(vp).stmfile    = vpData(1).stmfile;
end
end
