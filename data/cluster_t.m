function [] = cluster_t()
rawpath  = '.\raw\';
permpath = '.\perm\';
stimpath = '..\stim\';
addpath('.\lib\');

alphaTwoSided  = 0.01; %

cci = load('MF_tci.mat');
ci = cci.tci;
% plotting parameters

%plotParam.colorAxis  = 2; % plus or minus

mm = load('.\face_mask.mat'); % fm.fmask, logical
msk = nan(size(mm.mask.f)); msk(mm.mask.f == 1) = 1;


thresh_t = abs(tinv(alphaTwoSided/2, 26)); % 26 df



    for scale = 1:5
ts = squeeze(ci(scale,:,:));

figure; 
subplot(1,3,1);
imagesc(ts);
subplot(1,3,2);
imagesc(ts > thresh_t);
subplot(1,3,3);
imagesc((ts*-1) > thresh_t);



%% actual clusters
zmap  = (ts .* msk * -1) > thresh_t;
[a, n] = bwlabel(zmap);
if n == 0
     numpix = 0;
     clusterindex = {};
 else
    for m = 1:n
    numpix(m) = sum(a(:) == m);
    clusterindex{m} = find(a == m);
    end
 end
 pixelperm(scale).neg.numpix       = numpix;
 pixelperm(scale).neg.clusterindex = clusterindex;

zmap  = (ts .* msk * 1) > thresh_t; %pos
[a, n] = bwlabel(zmap);
if n == 0
     numpix = 0;
     clusterindex = {};
else
    for m = 1:n
    numpix(m) = sum(a(:) == m);
    clusterindex{m} = find(a == m);
    end
 end
 pixelperm(scale).pos.numpix       = numpix;
 pixelperm(scale).pos.clusterindex = clusterindex;

    end
save(['pixelperm_clusterT',num2str(alphaTwoSided), '.mat'], 'pixelperm');

end

    