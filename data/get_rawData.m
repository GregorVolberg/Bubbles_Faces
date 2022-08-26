% ==================
% get data, Zwischenauswertung
% 2021-09-15
% G. Volberg
% ==================
function [rawData] = get_rawData()

fpath = 'D:\Bubbles_Faces\data\';
rawpath  = [fpath, 'raw\'];
%rppath   = [fpath, 'rp\'];
addpath([fpath, 'lib\']);

exclude = {'S02', 'S04', 'S30'};
tmp = readtable('./raw/DemografieProbandenBubblesFaces.csv', 'Range',[1 1 32 4]);
vpmat = setdiff(tmp.vpcode, exclude);
%vpmat   = {'S01', 'S03', 'S05', 'S06', 'S14'};

filemat           = get_filemat(rawpath, vpmat);
[allData, ~]      = get_allData(filemat);
rawData           = reshape_Data(allData);

        
save([rawpath, 'BubblesFacesRaw.mat'], 'rawData');

% col1:  running number
% col2:  trial count witin block
% col3:  trial (stimulus) identifier
% col4:  key code, actual response
% col5:  reaction time
% col6:  response correct (1 = correct, 0 = false)
% col7:  n bubbles in first scale
% col8: n bubbles 1st scale (same as col7)
% col9: n bubbles 2nd scale
% col10: n bubbles 3rd scale
% col11: n bubbles 4th scale
% col12: n bubbles 5th scale
% col14: Condition codes (incl. correct/incorrect)

%% sub-functions =================

function [fpath, rawpath, permpath, rppath] = set_fileR_paths(fname)
fpath = fname;
rawpath  = [fpath, 'raw\'];
%permpath = [fpath, 'perm\'];
rppath   = [fpath, 'rp\'];
addpath([fpath, 'lib\']);
end




end
