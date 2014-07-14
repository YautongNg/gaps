function [p1c1 lrtype]=dp1c1b(p1c1name,cdate,path)
%
% Function dp1c1b
% ===============
%
%       Determines the P1-C1 values to be used for this date.
%
% Sintax
% ======
%
%       p1c1=dp1c1b()
%
% Input
% =====
%
%       cdate -> Current date
%                cdate=[Y;M;D;H;M;S]
%
% Output
% ======
%
%       p1c1 -> 40x1 vector with P1-C1 biases
%
% Created/Modfied
% ===============
%
% When          Who                     What
% ----          ---                     ----
% 2007/07/11    Rodrigo Leandro         Function created
% 2008/08/11    Rodrigo Leandro         Added functions that handle CODE
%                                       P1C1 bias files
% 2009/10/30    Landon Urquhart         read p1c1.hist to get receiver type
%
% ==========================================
% Copyright 2008 University of New Brunswick
% ==========================================

% Read biases from file
[p1c1_local lrtype] = rp1c1b('p1c1bias.hist',path);

% If file was succesfully downloaded, get biases from it, otherwise use
% local file as fallback
if ~strcmp(p1c1name,'')
    
    p1c1 = readp1c1(p1c1name,path);
    
else

    % Put date in appropriate format
    dat = cdate(1,1)*10000 + cdate(2,1)*100 + cdate(3,1);

    % Get approprite values
    for i=size(p1c1_local,1):-1:1

        if dat>=p1c1_local(i,1)

            p1c1=p1c1_local(i,2:end);
            break

        end

    end
    
end