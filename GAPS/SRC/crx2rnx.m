function rinexname=crx2rnx(namefile,path,pathexe)
%
% Function crx2rnx
% ================
% 
%	Converts GPS observation files from Hatanaka to Rinex format
%
% SINTAX
% ======
%
%	rinexname=crx2rnx(namefile)           
%
% INPUT
% =====
%
%	namefile = name of Hatanaka file (e.g. unb10011.00d)
% 
% OUTPUT
% ======
%      
%	inexname -> string with the name f the file created
%   The function creates a new file with same name, different extension.
%	For example, if called as crx2rnx(unb10011.00d), it creates a file
%	called unb10011.00o.
%
% CALLS
% =====
%      
%	It calls executable crx2rnx.exe.
%
% CREATED/MODIFIED
% ================
% 
% DATE       	WHO         WHAT
% ----       	---         ----
% 2006/01/30	Rodrigo	Function created
%
% ADDITIONAL COMMENTS
% ===================
%
%	This function was created to handle Hatanaka format from inside MatLab.
%


temp = fullfile(path,'rodrigo.rrd');
obs = fullfile(path, namefile);
movefile(obs,temp);

if ispc()
    system([fullfile(pathexe,crx2rnx.exe) ' ' temp])
elseif ismac()
    system(['/opt/local/bin/wine crx2rnx.exe ' temp])
else
    system(['/opt/bin/wine crx2rnx.exe ' temp])
end

rinexname=[obs(1:end-1) 'o'];
copyfile(fullfile(path,'rodrigo.rro'),rinexname);
delete(fullfile(path,'rodrigo.rro'));
delete(fullfile('rodrigo.rrd'));
