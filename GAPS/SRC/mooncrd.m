function monxyz=mooncrd(mjd,sdt)
%
% Function mooncrd
% ================
%
%       Computes the xyz coordinates of the Moon for given modified julian
%       date and sideral time.
%
% Sintax
% ======
%
%       monxyz=mooncrd(mjd,sdt)
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
%       monxyz -> 3x1 vector with cartesian coordinates of the Moon
%                 monxyz=[X;Y;Z]
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
%       Function originally based on subroutine moonxyz, developed by 
%       J. Vondrak of Astronomomical Inst. Prague cca 1960
%       * ecliptical lat & long are accurate within 10 sec of arc
%
% 
% ==============================
% Copyright 2006 Rodrigo Leandro
% ==============================


%      INTEGER*4 IAR(49),I,IARG,I1,I2,I3,I4

iar=[5553,5554,5555,5556,5557,5559,5573,5575,5577,5633, ...
     5635,5637,5653,5655,5656,5657,5753,5755,6435,6453, ...
     6455,6457,6533,6535,6537,6551,6553,6554,6555,6556, ...
     6557,6573,6575,6633,6635,6651,6653,6655,6753,7455, ...
     7535,7551,7553,7555,7557,7653,7655,8553,8555];
 
al=[ones(1,3)*0, -125, 2370, 14, -55, -412, -6, ones(1,2)*0, ...
     -1, -165, -668, 18, -24, -8, -7, 0, 28, ...
     148, 15, 9, 40, -6, -38, -4586, 19, ...
     22640, -8, 192, 0, -45, 0, 0, -4, -206, ...
     -110, 7, 10, -1, -31, -212, 769, 14, -9, ...
     -8, -13, 36];
 
asp=[ones(1,2)*0, 3422.5, -1.0, 28.2, 0.3, -0.1, ones(1,5)*0, 1.9, ...
     -0.4, 0.1, -0.3, 0.1, ones(1,2)*0, -0.2, 1.2, 0.2, 0, ...
     -0.7, 0, 0.6, 34.3, 0, 186.5, -0.1, 3.1, -0.1, ...
     ones(1,3)*0, 0.1, 1.4, -0.9, 0, 0.1, 0, 0.4, -0.3, ...
     10.2, 0.3, 0, ones(1,2)*-0.1, 0.6];
 
ab=[-624, 5, 18461, -5, 117, 1, -2, -6, 0, ...
    -8, -5, -12, -30, -6, 1, -1, -1, 0, 6, ...
     1, 7, 1, -199, 1000, 33, -7, -167, 0, ...
     1010, -1, 15, 0, -1, -9, -5, -1, -7, -5, ...
     0, 1, 32, -1, -16, 62, 2, ones(1,2)*-1, -2, 4];
 
 rod=57.2958;
 dros=206264.8062470963;
 
 % Get MJD in integer days
 mjd=mjd;
 
dt=(mjd-15019.5)/36525;
t=dt;
t2=t*t;
dl=973563+1732564379*dt-4*t2+14*sin(3.376-2.319*t);
a1=mod(dl,1296e3)/dros;
alm=mod(296.1047+477198.8492*dt+92e-4*t2,36e1)/rod;
al1=mod(358.4758+ 35999.0497*dt- 1e-4*t2,36e1)/rod;
af =mod( 11.2508+483202.0253*dt-32e-4*t2,36e1)/rod;
ad =mod(350.7375+445267.1142*dt-14e-4*t2,36e1)/rod;
dl=dl+7*sin(a1-af);
db=(-8)*sin(a1);
dsp=0;
sf=sin(af);
cf=cos(af);

for i=1:49
    iarg=fix(iar(i));
    i1=fix(iarg/1000)-5;
    i2=fix(mod(iarg/100,10))-5;
    i3=fix(mod(iarg/10,10))-5;
    i4=fix(mod(iarg,10))-5;
    arg=i1*alm+i2*al1+i3*af+i4*ad;
    sar=sin(arg);
    car=cos(arg);
    dl=dl+al(i)*sar;
    db=db+ab(i)*(sar*cf+car*sf);
    dsp=dsp+asp(i)*car;
end

dl=mod(dl,1296e3)/dros;
db=db/dros;
%dsp=dsp/dros;

%c  temp. modification added to vondrak's original subroutine
%c      compute rmoon
b1= mjd-15019.5;
c1=(279.6966788+0.9856473354*b1 +0.000303*t2)/rod;
c3=(270.434358+13.1763965268*b1  -0.001133*t2 + ...
    0.0000019*dt*t2)/rod;
c4=(334.329653+0.1114040803*b1 -0.010325*t2 - ...
    0.000012*dt*t2)/rod;

a2=(c3-c4);
a3=(c3-2*c1+c4);
a4=(c3-c1);
c90=1+0.0545*cos(a2)+0.01002*cos(a3);
c91=0.00825*cos(2*a4)+0.00297*cos(2*a2);
c9=c90+c91;
rm=384401e3/c9;
 
e0=(23.452294-0.0130125*dt-0.00000164*t2 + ...
    0.000000503*dt*t2)/rod;

%c compute geocentric moon coordinates from ecl. lat & long (db, dl)

xmoono= rm*cos(db)*cos(dl);
ymoone= rm*cos(db)*sin(dl);
zmoone= rm*sin(db);
ymoono= ymoone*cos(e0)-zmoone*sin(e0);
zmoon= zmoone*cos(e0)+ymoone*sin(e0);
xmoon= xmoono*cos(sdt)+ymoono*sin(sdt);
ymoon= ymoono*cos(sdt)-xmoono*sin(sdt);
monxyz=[xmoon;ymoon;zmoon];