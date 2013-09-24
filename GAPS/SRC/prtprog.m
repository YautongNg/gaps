function prog=prtprog(ctime,itime,ftime,prog)
%
% Function prtprog
% ================
%
%       Print the progress (%) in the screen
%
% Sintax
% ======
%
%       prog=prtprog(ctime,itime,ftime,prog)
%
% Input
% =====
%
%   ctime -> current time (hhmmss)
%   itime -> initial time (hhmmss)
%   ftime -> finel time (hhmmss)
%   prog -> progress (%)
%
% Output
% ======
%
%       prog -> updated progress (%)
%
% Created/Modified
% ================
%
% When          Who                     What
% ----          ---                     ----
% 2006/06/28    Rodrigo Leandro         Function created
%
%
% ==============================
% Copyright 2006 Rodrigo Leandro
% ==============================

prg=((ctime-itime)/(ftime-itime))*100;

if prg-prog>=10
    prog=prog+10;
    fprintf(1,'%2i %% completed\n',prog);
end