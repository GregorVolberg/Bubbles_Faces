% ==================
% data analysis script
% step 1, get_rawData (raw data to one mat-file)
% step 2, get_sanitycheck (ccuracy and N bubbles, for participant selection)
% step 3, get_responseplanes (response planes)
% step 4, get_permutation (z-planes)
% G. Volberg
% ==================
function [] = get_permutation()

rppath   = '.\rp\';
permpath = '.\perm\';
addpath('.\lib\');


% permutation zscore; eg Fiset 2017
% use pixels outside face mask, as eg implemented in Stat4CI toolbox
fm = load('.\face_mask.mat'); % fm.fmask, logical

% number of permutation runs
numruns = 500;

% conditions
cons = [0, 1]; % MF,   incorrect = 0, correct = 1 
conlabels = {'MF'};

% participants list
% exclude S02, S18, S30 because of missing data (technical problem)
% exclude S18 due to bad performance (68.83% correct at >350 bubbles)
exclude = {'S02', 'S04', 'S18', 'S30'}; 
tmp = readtable('./raw/DemografieProbandenBubblesFaces.csv', 'Range',[1 1 32 4]);
vpmat = setdiff(tmp.vpcode, exclude);

for vpn = 1:numel(vpmat)
    vp = vpmat{vpn};
vp_permpath = [permpath, vp, '\'];
mkdir(vp_permpath);

for cond = 1:size(cons,1)
    seed = rand(1); rng(seed);
    perm = [];    
    for scale = 1:5
    corrct = load([rppath, 'rp_', vp, '_s', num2str(scale), '_c', num2str(cons(cond, 2)), '_raw.mat'], 'rp');
    incorr = load([rppath, 'rp_', vp, '_s', num2str(scale), '_c', num2str(cons(cond, 1)), '_raw.mat'], 'rp');
    [zcor, zinc, ci, zsc] = get_CIs(corrct, incorr);

    allplanes = cat(3, corrct.rp, incorr.rp);
    tmp = nan([numruns, size(corrct.rp, 1), size(corrct.rp, 2)]); 
    fprintf('Condition %s, scale %i \n', ...
        conlabels{cond}, scale);
    for nrun = 1:numruns
        rnd = randsample(1:size(allplanes, 3), size(allplanes, 3));
        permplanes = allplanes(:,:,rnd);
        perm_corrct.rp = permplanes(:,:, 1:size(corrct.rp,3));
        perm_incorr.rp = permplanes(:,:, (size(corrct.rp,3)+1):(size(corrct.rp,3) + size(incorr.rp,3)));
        [~, ~, perm_ci, ~] = get_CIs(perm_corrct, perm_incorr);
        tmp(nrun, :, :) = perm_ci;
        str_count = add_leadingzeros(nrun, length(num2str(numruns)));
        save([vp_permpath, 'perm_ci_', vp, '_condition', num2str(cons(cond, 2)),...
        'vs', num2str(cons(cond, 1)),  '_scale', num2str(scale), '_', str_count, '.mat'], 'perm_ci');
    end
    m    = squeeze(nanmean(tmp, 1));
    sd   = squeeze(nanstd(tmp));
    perm(scale).corrct     = zcor;
    perm(scale).incorr     = zinc;
    perm(scale).weights    = zsc;
    perm(scale).m_perm     = m;
    perm(scale).sd_perm    = sd;
    perm(scale).ci         = ci;
    perm(scale).perm_zci    = (ci - m) ./ sd;
    perm(scale).fmask_zci   = (ci - mean(ci(fm.mask.pix_Index))) ./ std(ci(fm.mask.pix_Index));
    perm(scale).condition  = conlabels(cond);
    perm(scale).numruns    = numruns;
    perm(scale).seed       = seed; % seed for random number generator
    end
    
    save([permpath, 'perm_', vp, '_condition', num2str(cons(cond, 2)),...
    'vs', num2str(cons(cond, 1)),  '.mat'], 'perm');
end
end
end

