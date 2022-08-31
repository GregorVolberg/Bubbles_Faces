% ==================
% function [] = grandaverage_zplanes()
% takes all data that is available in folder 'perm'

% step 1, get_rawData (raw data to one mat-file)
% step 2, get_sanitycheck (overall accuracy and N bubbles, for participant selection)
% step 3, get_responseplanes (response planes)
% step 4, get_permutation (z-planes)
% step 5, grandaverage z-planes
% ==================

function [] = ttest_forPermutationsRuns()

rawpath  = '.\raw\';
permpath = '.\perm\';
tperm    = '.\tperm\';
stimpath = '..\stim\';
addpath('.\lib\');


exclude = {'S02', 'S04', 'S18', 'S30'}; 
temp = readtable('./raw/DemografieProbandenBubblesFaces.csv', 'Range',[1 1 32 4]);
vpsel = setdiff(temp.vpcode, exclude);
%vpsel = {'S01', 'S03'}

% get patches for smoothing
stim = load([stimpath, 'fm_struct_npic_470x349.mat']);
rawd = load([rawpath, 'S07\S07_20220525T142929.mat']); % example raw data
[patches] = get_patches(stim.struct_npic.facedims, stim.struct_npic.mids, rawd.Bubbles.num_cycles, rawd.Bubbles.sd_Gauss); % from BKH_Bubbles.m
dims = [length(stim.struct_npic.mids), stim.struct_npic.picdims];

% get fmask for plotting
%mm = load('.\face_mask.mat'); % fm.fmask, logical
%msk = nan(size(mm.mask.f)); msk(mm.mask.f == 1) = 1;

flist = get_filelist(permpath, 'perm_S*_condition1vs0.mat');
flist = flist(contains(flist, vpsel));
% each matfile contains structure 'perm' with fields:
%     corrct
%     incorr
%     m_perm
%     sd_perm
%     classimg
%     z_classimg
%     condition
%     numruns
%     seed

% pre-allocate
numruns = 500;
tci    = zeros([numruns, dims]);
%vp=1



for nscale = 1:5%size(zci, 1)
    for nrun = 1:numruns
    str_count = add_leadingzeros(nrun, length(num2str(numruns)));
    for vp = 1:numel(flist)
      ld   = load([permpath, vpsel{vp}, '\perm_ci_', vpsel{vp}, '_condition1vs0_scale', num2str(nscale), '_', str_count, '.mat']);
      msd  = load(flist{vp});
      pzci = (ld.perm_ci - msd.perm(nscale).m_perm) ./ msd.perm(nscale).sd_perm;
      tmpci(vp, :, :) = pzci;
    end
    %zci(nscale, :, :)    = squeeze(mean(tmpci, 1));
    [~, ~, ~, t] = ttest(tmpci);
tci(nrun, nscale, :, :) = imfilter(squeeze(t.tstat), patches{nscale}/sum(patches{nscale}(:)), 'same');    % normalize filter output 
%zcivp 
    end
end

%end
save(['MF_tciperm.mat'], 'tci', '-v7.3');
%plot_spatial(con_zci, pic, msk, [nnames{whichGroup}, '_', groupcode], plotParam);

% now randomize superthreshold pixels

%% sub-functions =================


% function [] = plot_spatial(cci, bckgrnd_pic, mask, figname, plotParam)
% figure('Name', figname); 
% titles = {'happy', 'neut-h', 'sad', 'neut-s'};
% tplus  = [0, 5, 10, 15];
% for con = 1:numel(cci)
% ci = cci{con};
% for j=1:5
% subplot(4,5,tplus(con)+j);
% %imagesc(squeeze(ci(j,:,:)).*mask); caxis([-2 2]);
% image(bckgrnd_pic); colormap(gray);
% hold on
% plt = squeeze(ci(j,:,:)).*mask;
% imagesc(plt, 'AlphaData', (plt > plotParam.tThreshold | plt < -plotParam.tThreshold));
% colormap(jet); caxis([-plotParam.colorAxis plotParam.colorAxis]);
% title(titles(con));
% end
% end
% end
% % for j=1:5
% % subplot(4,5,15+j);
% % h = imagesc(nnpic); colormap(gray);
% % alph = dfplane(:,:,j);
% % aa = alph./255; %alph./max(alph(:));
% % set(h, 'AlphaData',aa)
% %end
% %end

% function[patch] = get_patches(picdims, mids, num_cycles, sd_Gauss)
%  onecycle  = picdims(2) ./ fliplr(mids);
%  allcycles = onecycle * num_cycles;
% 
%  sd_pic = onecycle .* sd_Gauss;
%  picsize  = onecycle .* num_cycles * 2; % large pics so that gauss comes to zero
%  k = (sd_pic./picsize) *2; 
%         
%  for md = 1:numel(mids)
%     w1 = window(@gausswin, round(picsize(md)),1/k(md)); %previously k = 0.35
%     patch{md} = w1*w1';
%  end
% end

end % end function
