function [orb,out,raw,atm,exe,filt] = setGAPSPaths()
wd = pwd();
root = fileparts(wd);

orb = fullfile(root,'ORB');
out = fullfile(root,'OUT');
raw = fullfile(root,'RAW');
atm = fullfile(root,'ATM');
exe = fullfile(root,'EXE');
filt = fullfile(root,'FILT');

end