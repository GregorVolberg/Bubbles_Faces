function [allData, blocks] = get_allData(fmat)
allData = cell(numel(fmat),1);
for vp = 1:numel(fmat)
    vpData = [];
    blocks = [];
    for nfile = 1:numel(fmat{vp})
    tmp = load(fmat{vp}{nfile});
    vpData = [vpData; tmp];
    blocks(nfile) = size(tmp.Bubbles.outmat,1);
    
    end
    allData{vp} = vpData;
end
end
