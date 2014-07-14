
function xcorsta5=step2lon(dxyz,t)
%
% Function step2lon
% ==================
%
%      This is a routine for the step2 of the tidal corrections.
%      They are called to account for the frequency dependence
%      of the love numbers.
%
%
% Sintaxe
% =======
%
%       xcorsta5=step2lon(dxyz,t) 
%
% Input
% =====
%       
%       dxyz  -> 3x1 vector with geocentric position of the station (ECEF)
%       t     -> factor from detide.m routine 
% 
% Output
% ======
%
%       xcorsta2 -> 3x1 vector with corrections induced by the latitude 
%                   dependence given by l^(1) 
%                   
%
% Created/Modified
% ================
%
% When          Who                        What
% ----          ---                        ----
% 2009/06/15    Carlos Alexandre Garcia    Function Created
%
% Comments
% ========
%
%       This routine was adapted from the routine dehanttideinel.f,
%       available at ftp://tai.bipm.org/iers/convupdt/chapter7/ (IERS).
%
% ==============================
% Copyright 2009 University of New Brunswick
% ============================== 

 deg2rad=0.0174532925199432957690;
 
% cf. table 7.5b of IERS conventions 2003 (TN.32, pg.82)
% columns are s,h,p,N',ps, dR(ip),dT(ip),dR(op),dT(op)
% IERS cols.= s,h,p,N',ps, dR(ip),dR(op),dT(ip),dT(op)
% units of mm
   
datdi= [  0,      0,      1,      2,      2
          0,      2,      0,      0,      0
          0,      0,     -1,      0,      0
          1,      0,      0,      0,      1
          0,      0,      0,      0,      0
         +0.47,  -0.20,  -0.11,  -0.13,  -0.05
         +0.23,  -0.12,  -0.08,  -0.11,  -0.05
         +0.16,  -0.11,  -0.09,  -0.15,  -0.06
         +0.07,  -0.05,  -0.04,  -0.07,  -0.03];
   
    
    s=      218.316645630 +481267.881940*t -0.00146638890*t*t+...
            0.000001851390*t^3;
    pr=     1.396971278*t +0.000308889*t*t +0.000000021*t^3+...
            0.000000007*t^4;
    s=      s+pr;
    h=      280.466450 +36000.76974890*t +0.000303222220*t*t+...
            0.000000020*t^3 -0.00000000654*t^4;
    p=      83.353243120 +4069.013635250*t-0.010321722220*t*t...
            -0.00001249910*t^3 +0.000000052630*t^4;
    zns=    234.955444990 +1934.136261970*t -0.002075611110*t*t...
            -0.000002139440*t^3 +0.000000016500*t^4;
    ps=     282.937340980 +1.719457666670*t +0.000456888890*t*t...
            -0.000000017780*t^3 -0.000000003340*t^4;
    
    rsta=   sqrt(dxyz(1)^2+dxyz(2)^2+dxyz(3)^2);
    sinphi= dxyz(3)/rsta;
    cosphi= sqrt(dxyz(1)^2+dxyz(2)^2)/rsta;
    cosla=  dxyz(1)/cosphi/rsta;
    sinla=  dxyz(2)/cosphi/rsta;
 
%  reduce angles to between 0 and 360
    s=  rem(  s,360.0);
    h=  rem(  h,360.0);
    p=  rem(  p,360.0);
    zns=rem(zns,360.0);
    ps= rem( ps,360.0);
    dr_tot=0.0;
    dn_tot=0.0;

    for i=1:3
     xcorsta(i)=0.0;
    end
 
%              1 2 3 4   5   6      7      8      9
%  columns are s,h,p,N',ps, dR(ip),dT(ip),dR(op),dT(op)
   for j=1:5
    thetaf= (datdi(1,j)*s+datdi(2,j)*h+datdi(3,j)*p+...
             datdi(4,j)*zns+datdi(5,j)*ps)*deg2rad;
    dr=      datdi(6,j)*(3.0*sinphi^2-1.0)/2.*cos(thetaf)+...
             datdi(8,j)*(3.0*sinphi^2-1.0)/2.*sin(thetaf);
    dn=      datdi(7,j)*(cosphi*sinphi*2.0)*cos(thetaf)+...
             datdi(9,j)*(cosphi*sinphi*2.0)*sin(thetaf);
    de=      0.0;
    dr_tot=  dr_tot+dr;
    dn_tot=  dn_tot+dn;

    xcorsta(1)=xcorsta(1)+dr*cosla*cosphi-de*sinla-dn*sinphi*cosla;
    xcorsta(2)=xcorsta(2)+dr*sinla*cosphi+de*cosla-dn*sinphi*sinla;
    xcorsta(3)=xcorsta(3)+dr*sinphi+dn*cosphi;
   end

   for i=1:3
    xcorsta(i)=xcorsta(i)/1000.0;
   end

xcorsta5=[xcorsta(1);xcorsta(2);xcorsta(3)];
