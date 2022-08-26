% ==================
% function [] = get_responseplanes(vp_selection)
% vp_selection can be cell array with subject codes, eg {'S11', 'S14'}
% or {'all'}
% ==================
function [] = get_responseplanes(vp_selection)

rawpath  = '.\raw\';
rppath   = '.\rp\';
stimpath = '..\stim\';

addpath('.\lib\');

% read raw data and condition codes
load([rawpath, 'BubblesFacesRaw.mat'], 'rawData');

% load example pic and get bubble properties
picfilename = [stimpath, rawData(1).stmfile]; % 
[~, ~, npic, mids] = load_stimuli(picfilename);
patches  = get_patches(rawData(1).facedims, mids, rawData(1).num_cycles, rawData(1).sd_Gauss);

% get response planes
get_resp_planes_raw(rawData, rppath, vp_selection, patches, npic); % write to disk

end







