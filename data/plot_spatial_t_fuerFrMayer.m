function [] = plot_spatial_t_fuerFrMayer()

rawpath  = '.\raw\';
permpath = '.\perm\';
stimpath = '..\stim\';
maypath  = '.\fuerFrMayer\';
addpath('.\lib\');

df = 26;
cci = load('MF_tci.mat');
ci = cci.tci;
% plotting parameters

alphaTwoSided  = 0.05; %
plotParam.colorAxis  = 6; % plus or minus

mm = load('.\face_mask.mat'); % fm.fmask, logical
mask = nan(size(mm.mask.f)); mask(mm.mask.f == 1) = 1;

mayer = load([maypath, 'perscale.mat']);

% get patches for smoothing
stim = load([stimpath, 'fm_struct_npic_470x349.mat']);
%rawd = load([rawpath, 'S07\S07_20220525T142929.mat']); % example raw data
%[patches] = get_patches(stim.struct_npic.facedims, stim.struct_npic.mids, rawd.Bubbles.num_cycles, rawd.Bubbles.sd_Gauss); % from BKH_Bubbles.m
dims = [length(stim.struct_npic.mids), stim.struct_npic.picdims];

% get average face pic for plotting
pic = zeros(dims(2:3));
for picn = 1:size(stim.struct_npic.npic,1)
tmppic = sum(reshape([stim.struct_npic.npic{picn,1:6}], 470, 349, 6),3);
pic = pic + tmppic;
end
%pic = tmppic / size(stim.struct_npic.npic,1);
pic = pic ./ picn;
pic = repmat(pic, 1, 1, 3)./255;
clear stim rawd tmppic
%save pic pic

figure('Name', 'Male-Female classification image (t)'); 

plotParam.tThreshold(1) = tinv(alphaTwoSided/2, df); 
plotParam.tThreshold(2) = tinv(1-alphaTwoSided/2, df); 


for j=1:5
subplot(1,5,j);
%imagesc(squeeze(ci(j,:,:)).*mask); caxis([-2 2]);
image(pic); colormap(gray);
hold on
plt = squeeze(ci(j,:,:)).*mask;
plt2 = nan(size(plt)); plt2(mayer.perscale{j}) = plt(mayer.perscale{j});
imagesc(plt, 'AlphaData', (plt2 > plotParam.tThreshold(2) | plt2 < plotParam.tThreshold(1)));
%imagesc(plt2, 'AlphaData');
colormap(jet); caxis([-plotParam.colorAxis plotParam.colorAxis]);
%title(titles(con));
end

%end
end


