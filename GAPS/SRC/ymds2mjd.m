function mjd=ymds2mjd(iyr,imo,ida,sod)
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
%       mjd=ymds2mjd(iyr,imo,ida,sod)
%
% Input
% =====
%
%       iyr     -> Year
%       imo     -> Month
%       ida     -> Day
%       sod     -> Seconds of day
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
%
% Comments
% ========
%
% Originally addapted from SR written by M. Schenewerk
%
% ==============================
% Copyright 2006 Rodrigo Leandro
% ==============================


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
ymdmjd=b+c+d+ida-679006;

% Rodrigo Leandro 060207 -> inclusion of HMS
% mjd=ymdmjd+(iho/24)+(imi/(60*24))+(ise/(60*60*24));

% Rodrigo Leandro 060614 -> inclusion of SOD
mjd=ymdmjd+sod/86400;