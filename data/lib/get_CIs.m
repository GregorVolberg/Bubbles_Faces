function [zcorr, zinco, diffp, zsc] = get_CIs(corrct, incorr)
ztmp = [ones(1,size(corrct.rp, 3)), zeros(1,size(incorr.rp,3))];
zvec = (ztmp -mean(ztmp)) / std(ztmp);
zsc = [zvec(1), zvec(end)];
zcorr = squeeze(mean(corrct.rp, 3)) .* size(corrct.rp, 3) .* zsc(1); % weighted sum
zinco = squeeze(mean(incorr.rp, 3)) .* size(incorr.rp, 3) .* zsc(2); % weighted sum
diffp = zcorr + zinco ; % "+" because zinco has negative weights
end