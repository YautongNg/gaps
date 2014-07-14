function sunxyz=suncrd(mjd,sdt)
%
% Function suncrd
% ================
%
%       Computes the xyz coordinates of the Sun for given modified julian
%       date and sideral time.
%
% Sintax
% ======
%
%       sunxyz=suncrd(mjd,sdt)
%
% Input
% =====
%
%       mjd -> modified julian date (decimal/integer days)
%       sdt -> sideral time (radians)
%
% Output
% ======
%
%       sunxyz -> 3x1 vector with cartesian coordinates of the Sun
%                 sunxyz=[X;Y;Z]
%
% Created/Modified
% ================
%
% When          Who                     What
% ----          ---                     ----
% 2006/07/04    Rodrigo Leandro         Function created
%
% Comments
% ========
%
%       Function originally based on subroutine sunxyz, developed by NRCan.
%
% 
% ==============================
% Copyright 2006 Rodrigo Leandro
% ==============================

d=0.0174532925;
dmj=mjd;
dmjd=dmj-15019.5;
ddt=((dmjd/365.25-63.64)*0.862069+35.75)/(3600*24);

b1=dmjd+ddt;
b2=b1/36525;

c1=(279.6966788+0.9856473354*b1+0.000303*(b2^2))*d;
c2=(281.22083+0.0000470684*b1+0.000453*(b2^2)+0.000003*(b2^3))*d;

a1=(c1-c2);

p0=c1+(0.034*sin(a1));

c7=p0-0.043*sin(2*p0);
c8=asin(0.406*sin(c7)+0.008*sin(3*c7));

sunr=1+0.01675*cos(a1)+0.00028*cos(2*a1);

%  compute rect coordinates of sun

decsc=cos(c8);
decss=sin(c8);
rsun=1.49597870691e11/sunr;
xsun=rsun*decsc*cos(c7-sdt);
ysun=rsun*decsc*sin(c7-sdt);
zsun=rsun*decss;

sunxyz=[xsun;ysun;zsun];