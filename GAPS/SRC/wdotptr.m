function wdotptr(otptr,cdate,prnlist,rc,rp,elvlist,azlist,amb)
%
% Function wdotptr
% ================
%
%       Writes data to the residuals ep. by ep. output file
%
% Sintax
% ======
%
%       wdotptp(otptp)
%
% Input
% =====
%
%       otptp -> file identifier
%       cdate -> current date
%       prnlist -> nx1 vector with PRN's
%       rc -> nx1 vector with carrier-phase residuals (m)
%       rp -> nx1 vector with pseudorange residuals (m)
%       elvlist -> nx1 vector with elevation angles (rad)
%
% Output
% ======
%
%       No output!
%
% Created/Modified
% ================
%
% When          Who                     What
% ----          ---                     ----
% 2006/06/28    Rodrigo Leandro         Function created
% 2006/07/12    Rodrigo Leandro         handle ARP offset
% 2006/11/27    Rodrigo Leandro         Added elevation angle
%
%
% ==============================
% Copyright 2006 Rodrigo Leandro
% ==============================

sod=cdate(6,1)+cdate(5,1)*60+cdate(4,1)*3600;
for i=1:size(rc,1)
    fprintf(otptr,'%5i%4i%15.4f%15.4f%15.4f%15.4f%15.4f\n',sod,prnlist(i),rp(i),rc(i),elvlist(i)*180/pi,azlist(i)*180/pi,amb(prnlist(i)));
end