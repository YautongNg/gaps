function sdt=mjd2sdt(mjd,cdate)
%
% Function mjd2sdt
% ================
%
%       Converts modified julian date (dmj) and time of day (ihr,imn,sec)
%       to sideral time in radians.
%
% Sintax
% ======
%
%       sdt=mjd2sdt(mjd,cdate)
%
% Input
% =====
%
%       mjd -> modified julian date (integer or decimal)
%       cdate -> current date
%                cdate=[Y;M;D;H;M;S]
%
% Output
% ======
%
%       sdt -> sideral time (radians)
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
%       Originally addapted from subroutine written by J.Kouba
%
%
% ==============================
% Copyright 2006 Rodrigo Leandro
% ==============================

%
%      implicit none
%c
%      integer*4 mjd
%      real*8    fmjddt,gpsutc,ut1utc,dut1,alphae,sidt
%c
%      integer*4 isidy
%      real*8    fmjd,secday,gmjd,d,hdot,h,sid,ut1,sidhr
%c

ut1utc = 0;
dut1   = 0;
alphae = 0;
secday=(mjd-fix(mjd))*86400;
mjd=fix(mjd);
%c     fmjd=mjd-0.5d0-36525.0d0
%c  jan 1, 2000 , 0h ut = mjd 51544
fmjd=mjd-0.5-51544.0;
%c     cong=(357.578+35999.050)*1.745329252d-2
%c     tdbtdt=0.001658*dsin(cong+0.0167*dsin(cong))
%c     fmjd=fmjd+(secday+51.184+tdbtdt)/86400.0d0     !!tdt days
gmjd=fmjd/36525; %                             !!tdb cent
%c
%c 2005feb18 : kouba :
%C      APPROXIMATE EPOCH IN YEARS FOR TOREF TRANSFORMATIONS
%      COMPUTE APPROXIMATE  GPSUTC +- 1SEC
epo= cdate(1,1) +((cdate(2,1)-1)*30+cdate(3,1))/365;
gpsutc = -13 - fix((epo-2000.5)/20*13);
ut1=ut1utc+dut1+gpsutc;
%c     ut1=ut1utc+dut1
%c 2005feb18 : kouba :
%c
%c   updated to j2000 system.
%c
d=13750.987083139756;
hdot=1.002737909350795+5.900575456e-11*gmjd;
h=24110.54841+gmjd*(8640184.812866+gmjd*(0.093104- ...
    gmjd*6.2e-6))+(ut1+ secday)*hdot;
sid=h+alphae*d;
sidhr=sid/3600;
isidy=fix(sidhr/24);
sdt=sidhr-(isidy*24);
%c  change from hrs to radians *****************
sdt= sdt*pi/12;
%     return
%      end