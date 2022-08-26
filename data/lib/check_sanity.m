% ==================
% function [rtrn] = check_sanity(vp, plotflag)
% G. Volberg
% ==================

function [rtrn] = check_sanity(vp, plotflag)

% fpath = 'D:\Bubbles_Faces\data\';
% rawpath  = [fpath, 'raw\'];
% addpath([fpath, 'lib\']);
% 
% load([rawpath, 'BubblesFacesRaw.mat'], 'rawData');

tmpcell = {rawData(:).vpcode}';
for vpnums =1:numel(tmpcell)
%vpnums  = find(ismember(tmpcell, vp));


% prz correct
rtable = tabulate(rawData(vpnums).outmat(:,14));
code = rawData(vpnums).vpcode;
trls = size(rawData(vpnums).outmat,1);
corr = rtable(2, 3);
mBubb = round(mean(rawData(vpnums).outmat(:,9)));
fprintf('\nParticipant %s, ', code);
fprintf('%i Trials, ', trls);
fprintf('%.2f %% correct, ', corr);
fprintf('mean %i Bubbles\n',mBubb);
tab(vpnums, :) = [str2num(code(2:3)), trls, corr, mBubb];

% plot
pltdata1 = rawData(vpnums).outmat(:,9);

if plotflag
fhandle = figure; plot(pltdata1);
text(200, 90, [num2str(round(rtable(2,3),2)), '% correct']);
title(vp);
saveas(fhandle, [rawpath, vp, '_sanity.png']);
close(fhandle);
end



% col1:  running number
% col2:  trial count witin block
% col3:  trial (stimulus) identifier
% col4:  key code, actual response
% col5:  reaction time
% col6:  response correct (1 = correct, 0 = false)
% col7:  n bubbles in first scale
% col8:  face gender (1 = male, 2 = female)
% col9:  face emotion (1 = happy, 2 = sad)
% col10: face condition (1 = neutral, 2 = emotion)
% col11: n bubbles 1st scale (same as col7)
% col12: n bubbles 2nd scale
% col13: n bubbles 3rd scale
% col14: n bubbles 4th scale
% col15: n bubbles 5th scale
% col16: NE-HA = 1, NE-SA = 2

%% sub-functions =================

function [fpath, rawpath, permpath, rppath] = set_fileR_paths(fname)
% nam = getenv('COMPUTERNAME');
% if ismember({nam}, {'DESKTOP-MDU4B4V'})
% fpath = ['C:\Users\Gregor\Filr\', fname];
% elseif ismember({nam}, {'PC1012101290'})
% fpath = ['C:\Users\LocalAdmin\Filr\', fname];
% end
fpath = fname;
rawpath  = [fpath, 'raw\'];
permpath = [fpath, 'perm\'];
rppath   = [fpath, 'rp\'];
addpath([fpath, 'lib\']);
end
end