function bdytde=btide(recllh,cdate)
%
% Function btide
% ==============
%
%       Computes the radial, s->n and w->e displacements due to boody tides
%       for given time and position.
%
% Sintax
% ======
%
%       bdytde=btide(recllh,cdate)
%
% Input
% =====
%
%       recllh -> receiver geodetic coordinates
%       cdate -> current date (cdate=[Y;M;D;H;M;S])
%
% Output
% ======
%
%       bdytde -> 3x1 vector with 3D displacements (m)
%                 bdytde=[U;N;E]
%                        U -> radial displacement
%                        N -> S->N displacement
%                        E -> W->E displacement
%
% Created/Modified
% ================
%
% When          Who                     What
% ----          ---                     ----
% 2006/07/06    Rodrigo Leandro         Function created
%
%
% Comments
% ========
%
%
%
% ==============================
% Copyright 2006 Rodrigo Leandro
% ==============================


d=0.0174532925;
%   love numbers
first = 0.609;
shida = 0.085;

dlat=recllh(1,1);
dlon=recllh(2,1);

f=dlat-0.192424*sin(2*dlat)*d;
w=dlon;
dsinf=sin(f);
dcosf=cos(f);
dcw=cos(w);
dsw=sin(w);
% input & use xmoon & xsun positions
dmjd=date2mjd(cdate);
sidt=mjd2sdt(dmjd,cdate);
xsun=suncrd(dmjd,sidt);
xmoon=mooncrd(dmjd,sidt);
rmoon=sqrt(xmoon(1)^2+xmoon(2)^2+xmoon(3)^2);
rmoonc=sqrt(xmoon(1)^2+xmoon(2)^2);
rsun=sqrt(xsun(1)^2+xsun(2)^2+xsun(3)^2);
rsunc=sqrt(xsun(1)^2+xsun(2)^2);
decms=xmoon(3)/rmoon;
decmc=rmoonc/rmoon;
hourms=-((xmoon(2)*dcw-xmoon(1)*dsw)/rmoonc);
hourmc=(xmoon(1)*dcw+xmoon(2)*dsw)/rmoonc;
decss=xsun(3)/rsun;
decsc=rsunc/rsun;
hourss=-((xsun(2)*dcw-xsun(1)*dsw)/rsunc);
hoursc=(xsun(1)*dcw+xsun(2)*dsw)/rsunc;
z11=dsinf*decss;
z12=dcosf*decsc*hoursc;
z1=z11+z12;
z21=dsinf*decms;
z22=dcosf*decmc*hourmc;
z2=z21+z22;
sunr=1.49597870691e11/rsun;
c9=384401e3/rmoon;
c93=c9^3;

sunr3=sunr^3;
argm1=decms^2-(decmc^2)*(hourmc^2);
argm2=2 * decms * decmc * hourmc * cos(2* f);
argm3=2 * dcosf^2  * decmc^2  * hourms * hourmc;
argm4=2 * dsinf * dcosf * decms * decmc * hourms;
args1=decss^2 - decsc^2 * hoursc^2;
args2=2 * decss * decsc * hoursc * cos(2*f);
args3=2 * dcosf^2 * decsc^2  * hourss * hoursc;
args4=2 * dsinf * dcosf * decss * decsc * hourss;
vmlat=53.625 * (sin(2*f)*argm1+argm2)*c93;
vmlon=53.625 * (argm3+argm4)*c93 /dcosf;
vslat=24.625 * (sin(2*f)*args1 + args2)*sunr3;
vslon=24.625 * (args3+args4)*sunr3 /dcosf;
tup=first*(53.625*(z2*z2-1/3)*c93+ ...
    24.625*(z1*z1-1/3)*sunr3)/100;
% iers89 conventions correction
tup =tup -0.025*sin(f)*cos(f)*sin(sidt+ w);

tnorth= (vmlat + vslat) * shida/100;
teast=-((vmlon + vslon) * shida/100);
bdytde=[tup;tnorth;teast];