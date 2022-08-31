% ==================
% function [rtrn] = get_sanitycheck()
% G. Volberg
% ==================

function [] = get_behavFrMayer()
%fpath = 'D:\Bubbles_Faces\data\';
rawpath  = '.\raw\';
maypath  = '.\fuerFrMayer\';
addpath('.\lib\');
load([rawpath, 'BubblesFacesRaw.mat'], 'rawData');

%tmpcell = {rawData(:).vpcode}';
exclude = {'S02', 'S04', 'S18', 'S30'}; 
rawData = rawData(~ismember({rawData.vpcode}, exclude));

tmpcell = {rawData(:).vpcode}';
for vpnums =1:numel(tmpcell)
%vpnums  = find(ismember(tmpcell, vp));


% prz correct
rtable = tabulate(rawData(vpnums).outmat(:,14));
vp = rawData(vpnums).vpcode;
trls = size(rawData(vpnums).outmat,1);
corr = rtable(2, 3);
mBubb = round(mean(rawData(vpnums).outmat(:,9)));
fprintf('\nParticipant %s, ', vp);
fprintf('%i Trials, ', trls);
fprintf('%.2f %% correct, ', corr);
fprintf('mean %i Bubbles',mBubb);
rtrn(vpnums, :) = [str2num(vp(2:3)), trls, corr, mBubb];

% % plot
% pltdata1 = rawData(vpnums).outmat(:,9);
% 
% %if plotflag
% fhandle = figure; plot(pltdata1);
% text(200, 90, [num2str(round(rtable(2,3),2)), '% correct']);
% title(vp);
% saveas(fhandle, [rawpath, vp, '_sanity.png']);
% close(fhandle);
end
fprintf('\n');
csvwrite([maypath, 'behavdat.csv'], rtrn);
end

