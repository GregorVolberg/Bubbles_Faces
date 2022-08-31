% ==================
% function [] = grandaverage_zplanes()
% takes all data that is available in folder 'perm'

% step 1, get_rawData (raw data to one mat-file)
% step 2, get_sanitycheck (overall accuracy and N bubbles, for participant selection)
% step 3, get_responseplanes (response planes)
% step 4, get_permutation (z-planes)
% step 5, grandaverage z-planes
% ==================

function [] = grandaverage_forClusters()

% idea: take grandaverages for each permutation ci and identify largest
% cluster

rawpath  = '.\raw\';
permpath = '.\perm\';
stimpath = '..\stim\';
addpath('.\lib\');


exclude = {'S02', 'S04', 'S18', 'S30'}; 
temp = readtable('./raw/DemografieProbandenBubblesFaces.csv', 'Range',[1 1 32 4]);
vpsel = setdiff(temp.vpcode, exclude);
%vpsel = {'S01', 'S03'}

mm = load('.\face_mask.mat'); % fm.fmask, logical
mask = nan(size(mm.mask.f)); mask(mm.mask.f == 1) = 1;

% get patches for smoothing
stim = load([stimpath, 'fm_struct_npic_470x349.mat']);
rawd = load([rawpath, 'S07\S07_20220525T142929.mat']); % example raw data
[patches] = get_patches(stim.struct_npic.facedims, stim.struct_npic.mids, rawd.Bubbles.num_cycles, rawd.Bubbles.sd_Gauss); % from BKH_Bubbles.m
dims = [length(stim.struct_npic.mids), stim.struct_npic.picdims];

for vpn = 1:numel(vpsel)
    for scl = 1:5
    temp = load([permpath, 'perm_', vpsel{vpn}, '_condition1vs0.mat']);
    forZ(vpn,scl).m = temp.perm(scl).m_perm;
    forZ(vpn,scl).sd = temp.perm(scl).sd_perm;
    end
end

for run = 1:500
for vpn = 1:numel(vpsel)
    for scl = 1:5
    fnam = [permpath, vpsel{vpn}, '\perm_ci_', vpsel{vpn}, '_condition1vs0_scale', num2str(scl), '_', add_leadingzeros(run,3),'.mat'];
    tempperm = load(fnam);
    tempperm_zci(vpn, :, :)  = (tempperm.perm_ci - forZ(vpn).m) ./ forZ(vpn).sd;
    end
perm_zci{scl, run} = squeeze(nanmean(tempperm_zci,1));
clear tempperm_zci
end
end



flist2 = flist(contains(flist, vpsel));
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
zci    = zeros(dims);

for nscale = 1:5%size(zci, 1)
    for vp = 1:numel(flist)
      ld = load(flist{vp});
      tmpci(vp, :, :) = ld.perm(nscale).perm_zci;
    end
    %zci(nscale, :, :)    = squeeze(mean(tmpci, 1));
    tmpzci    = squeeze(nanmean(tmpci, 1));
zci(nscale,:,:) = imfilter(tmpzci, patches{nscale}/sum(patches{nscale}(:)), 'same');    % normalize filter output 
%zcivp 
end
con_zci = zci;
%end
save(['MF_zci.mat'], 'con_zci');
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
