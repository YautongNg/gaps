function  xcorsta2=step2diu(sinphi,cosphi,cosla,sinla,fhr,t,zla)
%
% Function step2diu
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
%       xcorsta2=step2diu(sinphi,cosphi,cosla,sinla,fhr,t,zla)  
%
% Input
% =====
%       
%       sinphi -> factor from detide.m routine
%       cosphi -> factor from detide.m routine              
%       sinla -> factor from detide.m routine
%       cosla -> factor from detide.m routine
%       t     -> factor from detide.m routine 
%       zla   -> factor from detide.m routine
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

%      Note: following table is derived from dehanttideinelMJD.f 
%      has minor differences from that of dehanttideinel.f 
%      D.M. edited to strictly follow published table 7.5a 
% 
%      cf. table 7.5a of IERS conventions 2003 (TN.32, pg.82)
%      columns are s,h,p,N',ps, dR(ip),dR(op),dT(ip),dT(op)
%      units of mm

datdi=[ 
 -3.000	-3.000	-2.000	-2.000	-2.000	-1.000	-1.000	-1.000	0.000	0.000	0.000	0.000	0.000	1.000	1.000	1.000	1.000	1.000	1.000	1.000	1.000	1.000	1.000	1.000	1.000	1.000	1.000	2.000	2.000	3.000	3.000
0.000	2.000	0.000	0.000	2.000	0.000	0.000	2.000	-2.000	0.000	0.000	0.000	2.000	-3.000	-2.000	-2.000	-1.000	-1.000	0.000	0.000	0.000	0.000	1.000	1.000	1.000	2.000	2.000	-2.000	0.000	0.000	0.000
2.000	0.000	1.000	1.000	-1.000	0.000	0.000	0.000	1.000	-1.000	1.000	1.000	-1.000	0.000	0.000	0.000	0.000	0.000	0.000	0.000	0.000	0.000	0.000	0.000	0.000	-2.000	0.000	1.000	-1.000	0.000	0.000
0.000	0.000	-1.000	0.000	0.000	-1.000	0.000	0.000	0.000	0.000	0.000	1.000	0.000	0.000	1.000	0.000	0.000	0.000	-1.000	0.000	1.000	2.000	0.000	0.000	1.000	0.000	0.000	0.000	0.000	0.000	1.000
0.000	0.000	0.000	0.000	0.000	0.000	0.000	0.000	0.000	0.000	0.000	0.000	0.000	1.000	0.000	0.000	-1.000	1.000	0.000	0.000	0.000	0.000	-1.000	1.000	-1.000	0.000	0.000	0.000	0.000	0.000	0.000
-0.010	-0.010	-0.020	-0.080	-0.020	-0.100	-0.510	0.010	0.010	0.020	0.060	0.010	0.010	-0.060	0.010	-1.230	0.020	0.040	-0.220	12.000	1.730	-0.040	-0.500	0.010	-0.010	-0.010	-0.110	-0.010	-0.020	0.000	0.000
-0.010	-0.010	-0.010	0.000	-0.010	0.000	0.000	0.000	0.000	0.010	0.000	0.000	0.000	0.000	0.000	-0.070	0.000	0.000	0.010	-0.780	-0.120	0.000	-0.010	0.000	0.000	0.000	0.010	0.000	0.020	0.010	0.010
0.000	0.000	0.000	0.010	0.000	0.000	-0.020	0.000	0.000	0.000	0.000	0.000	0.000	0.000	0.000	0.060	0.000	0.000	0.010	-0.670	-0.100	0.000	0.030	0.000	0.000	0.000	0.010	0.000	0.000	0.000	0.000
0.000	0.000	0.000	0.010	0.000	0.000	0.030	0.000	0.000	0.000	0.000	0.000	0.000	0.000	0.000	0.010	0.000	0.000	0.000	-0.030	0.000	0.000	0.000	0.000	0.000	0.000	0.000	0.000	0.010	0.010	0.000];


       s= 218.316645630 +481267.881940*t -0.00146638890*t*t+...
          0.00000185139d0*t^3;
     tau= fhr*15.0 +280.46061840 +36000.77005360*t +0.000387930*t*t...
          -0.00000002580*t^3 -s;
      pr= 1.396971278*t +0.000308889*t*t +0.000000021*t^3+...
          0.000000007*t^4;
       s= s + pr;
       h= 280.466450 +36000.76974890*t +0.000303222220*t*t+...
          0.000000020*t^3 -0.00000000654*t^4;
       p= 83.353243120 +4069.013635250*t -0.010321722220*t*t...
          -0.00001249910*t^3 +0.000000052630*t^4;
     zns= 234.955444990 +1934.136261970*t -0.002075611110*t*t...
          -0.000002139440*t^3+0.000000016500*t^4;
      ps= 282.937340980 +1.719457666670*t +0.00045688889d0*t*t...
          -0.000000017780*t^3 -0.000000003340*t^4;
      
% reduce angles to between 0 and 360

        s= rem(  s,360.0);
      tau= rem(tau,360.0);
        h= rem(  h,360.0);
        p= rem(  p,360.0);
      zns= rem(zns,360.0);
       ps= rem( ps,360.0);

      
      for i=1:3
        xcorsta(i)=0.0;
      end
 
      for j=1:31
        thetaf= (tau+datdi(1,j)*s +datdi(2,j)*h +datdi(3,j)*p+...
                 datdi(4,j)*zns +datdi(5,j)*ps) *deg2rad;     
            dr=  datdi(6,j)*2.0*sinphi*cosphi*sin(thetaf+zla)+...
                 datdi(7,j)*2.0*sinphi*cosphi*cos(thetaf+zla);
            dn=  datdi(8,j)*(cosphi^2-sinphi^2)*sin(thetaf+zla)+...
                 datdi(9,j)*(cosphi^2-sinphi^2)*cos(thetaf+zla);             
            de=  datdi(8,j)*sinphi*cos(thetaf+zla)-...
                 datdi(9,j)*sinphi*sin(thetaf+zla);
             
    xcorsta(1)=  xcorsta(1)+dr*cosla*cosphi-de*sinla...
                 -dn*sinphi*cosla;
    xcorsta(2)=  xcorsta(2)+dr*sinla*cosphi+de*cosla...
                 -dn*sinphi*sinla;
    xcorsta(3)=  xcorsta(3)+dr*sinphi+dn*cosphi;
     end

      for i=1:3
         xcorsta(i)=xcorsta(i)/1000.0;
      end       
            

xcorsta2=[xcorsta(1);xcorsta(2);xcorsta(3)];
     