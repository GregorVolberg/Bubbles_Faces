function [] = export_clusterzFrMayer()

rawpath  = '.\raw\';
permpath = '.\perm\';
stimpath = '..\stim\';
maypath  = '.\fuerFrMayer\';
addpath('.\lib\');

cci = load('MF_zci_allVP.mat');

zci = cci.allVP.data;
vpsel = cci.allVP.vp;


act = load('pixelperm_clusterT0.05.mat'); % actual data, 'pixelperm'
rnd = load('permT0.05.mat'); % permutation results, 'permT'

for scl = 1:5
ind = find(act.pixelperm(scl).pos.numpix > quantile(rnd.permT.posmax(scl,:), 0.95))
if isempty(ind)
    posind{scl}=NaN;
else
    for nml = 1:length(ind)
    posind{scl, nml} = act.pixelperm(scl).pos.clusterindex{ind(nml)};
    end
end
end

for scl = 1:5
ind = find(act.pixelperm(scl).neg.numpix > quantile(rnd.permT.negmax(scl,:), 0.95))
if isempty(ind)
    negind{scl}=NaN;
else
    for nml = 1:length(ind)
    negind{scl, nml} = act.pixelperm(scl).neg.clusterindex{ind(nml)};
    end
end
end
%end

% for exporting
clstvalues{1} = posind{2, 1};
clstvalues{2} = posind{3, 1};
clstvalues{3} = posind{3, 2};
clstvalues{4} = posind{4, 1};
clstvalues{5} = posind{4, 2};
clstvalues{6} = negind{4, 1};
clstscales = [2, 3, 3, 4, 4, 4];

% for plotting
perscale{1} = [];
perscale{2} = [clstvalues{1}];
perscale{3} = [clstvalues{2}; clstvalues{3}];
perscale{4} = [clstvalues{4}; clstvalues{5}; clstvalues{6}];
perscale{5} = [];
%% hier weiter!!!

for clu = 1:numel(clstscales)
for vp = 1:numel(cci.allVP.vp)
      tmpcluster = squeeze(cci.allVP.data(vp, clstscales(clu), :, :));  
      clustermean(vp, clu) = nanmean(tmpcluster(clstvalues{clu}));
end
end


vps = cellfun(@(x) str2num(x(2:3)), cci.allVP.vp);
outm = [vps, clustermean];

csvwrite([maypath, 'clusterdat.csv'], outm);
save([maypath, 'perscale.mat'], 'perscale');

end