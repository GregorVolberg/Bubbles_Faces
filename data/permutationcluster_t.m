function [] = permutationcluster_t()
rawpath  = '.\raw\';
permpath = '.\perm\';
stimpath = '..\stim\';
addpath('.\lib\');

alphaTwoSided  = 0.01; %

%cci = load('MF_tci.mat');
cci = load('MF_tciperm.mat');
ci = cci.tci;
% plotting parameters

%plotParam.colorAxis  = 2; % plus or minus

mm = load('.\face_mask.mat'); % fm.fmask, logical
msk = nan(size(mm.mask.f)); msk(mm.mask.f == 1) = 1;


thresh_t = abs(tinv(alphaTwoSided/2, 26)); % 26 df



for scale = 1:5
    for nrun = 1:size(ci,1)
ts = squeeze(ci(nrun, scale,:,:));

% figure; 
% subplot(1,3,1);
% imagesc(ts);
% subplot(1,3,2);
% imagesc(ts > thresh_t);
% subplot(1,3,3);
% imagesc((ts*-1) > thresh_t);



%% permutation clusters
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
 pixelperm(nrun, scale).neg.numpix       = numpix;
 pixelperm(nrun, scale).neg.clusterindex = clusterindex;

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
 pixelperm(nrun, scale).pos.numpix       = numpix;
 pixelperm(nrun, scale).pos.clusterindex = clusterindex;

    end
end


for scl = 1:size(pixelperm,2)
for allruns = 1:size(pixelperm,1)
    posmax(scl, allruns) = max(pixelperm(allruns,scl).pos.numpix);
    negmax(scl, allruns) = max(pixelperm(allruns,scl).neg.numpix);
end
end

permT. alphaTwoSided = alphaTwoSided;
permT.posmax = posmax;
permT.negmax = negmax;
    

save(['pixelperm_permutationclusterT',num2str(alphaTwoSided), '.mat'], 'pixelperm');
save(['permT',num2str(alphaTwoSided), '.mat'], 'permT');

%e. g. quantile(posmax(1,:), 0.95)

end

    