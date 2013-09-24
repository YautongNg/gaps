function [mjd mjd_fullday fmjd] =date2mjd(cdate)
%
% Function ymds2mjd
% =================
%
%       Computes modified julian date from Year, Month, Day and Seconds of 
%       day.
%
% Sintaxe
% =======
%
%       mjd=ymds2mjd(cdate)
%
% Input
% =====
%
%       cdate -> current date
%       cdate = [Year;Month;Day;Hour;Minute;Second]
%
% Output
% ======
%
%       mjd     -> Modified Julian Date
%
% Created/Modified
% ================
%
% When          Who                     What
% ----          ---                     ----
% 2006/02/07    Rodrigo Leandro         Function created
% 2006/06/14    Rodrigo Leandro         Change time input from HMS to SOD
% 2006/07/05    Rodrigo Leandro         Change input from HMS/SOD to cdate
%
% Comments
% ========
%
% Originally addapted from SR written by M. Schenewerk
%
% ==============================
% Copyright 2006 Rodrigo Leandro
% ==============================

iyr=cdate(1,1);
imo=cdate(2,1);
ida=cdate(3,1);
iyrp=iyr;
if iyr<1900
    iyrp=iyr+1900;
end
imop=imo;
if imo<3
    iyrp=iyrp-1;
    imop=imop+12;
end

%........  1.0  calculation

a=fix(iyrp*0.01);
b=fix(2-a+fix(a*0.25));
c=fix(365.25*iyrp);
d=fix(30.6001*(imop+1));
mjd_fullday=b+c+d+ida-679006;

% Rodrigo Leandro 060207 -> inclusion of HMS
% mjd=ymdmjd+(iho/24)+(imi/(60*24))+(ise/(60*60*24));

% Rodrigo Leandro 060614 -> inclusion of fractional day
fmjd=cdate(4,1)/24+cdate(5,1)/(60*24)+cdate(6,1)/86400;
mjd=mjd_fullday+fmjd;