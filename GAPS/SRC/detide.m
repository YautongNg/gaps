function dxtide=detide(dxyz,xsun,xmoon,mjd,fmjd) 
%
% Function detide
% ==================
%
%       This function was created to compute the tidal corrections 
%       of station displacements caused by lunar and solar gravitational 
%       attraction.
%       detide.m routine removes all tidal deformation, both cyclic 
%       and permanent. It implements the conventions described in the 
%       Section 7.1.2 of the IERS Conventions (2003). 
%
%        step 1 (here general degree 2 and 3 corrections +
%        call st1idiu + call st1isem + call st1l1)
%        + step 2 (call step2diu + call step2lon + call step2idiu).
%        It has been decided that the step 3 un-correction for permanent tide
%        would *not* be applied in order to avoid jump in the reference frame
%       (this step 3 must added in order to get the mean tide station position
%        and to be conformed with the iag resolution.)
%
% Sintaxe
% =======
%
%       dxtide=detide(dxyz,xsun,xmoon,mjd,fmjd)         
%
% Input
% =====
%        
%       recxyz -> Receiver cartesian coordinates              
% 
% Output
% ======
%
%       dxtide -> 3x1 vector with 3D displacements (ITRF)       
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
%--------------------------------------------------------------------------
if sum(dxyz)==0
    dxtide=[0;0;0];
    return;
end

      rsta=norm(dxyz);
      rmon=norm(xmoon);
      rsun=norm(xsun);
      scsun = dot(dxyz,xsun)/rsta/rsun;
      scmon = dot(dxyz,xmoon)/rsta/rmon;  
     
      sinphi=dxyz(3)/rsta;
      cosphi=(sqrt(dxyz(1)^2 + dxyz(2)^2))/rsta;
      cos2phi=(cosphi^2)-(sinphi^2);
      sinla=dxyz(2)/cosphi/rsta;
      cosla=dxyz(1)/cosphi/rsta;
      zla=atan2(dxyz(2),dxyz(1));

%  convert GPS time into TT time
      tsecgps=fmjd*86400.0;                       % GPS time (sec of day)
      tsectt =gps2tt(tsecgps);                    % TT  time (sec of day)
      fmjdtt =tsectt/86400.0;                     % TT  time (fract. day)
      dmjdtt=mjd+fmjdtt;                          % float MJD in TT
      t=(dmjdtt-51545.0)/36525.0;                 % days to centuries, TT
      fhr=(dmjdtt-fix(dmjdtt))*24.0;              % hours in the day, TT

%  nominal second degree and third degree love numbers and shida numbers
      h20=0.60780;
      l20=0.08470;
      h3=0.2920;
      l3=0.0150;      

%  computation of new h2 and l2
      cosphi=sqrt(dxyz(1)*dxyz(1) + dxyz(2)*dxyz(2))/rsta;
      h2=h20-0.00060*(1.0-3.0/2.0*cosphi*cosphi);
      l2=l20+0.00020*(1.0-3.0/2.0*cosphi*cosphi);
 
%  p2-term
      p2sun=3.0*(h2/2.0-l2)*scsun*scsun-h2/2.0;
      p2mon=3.0*(h2/2.0-l2)*scmon*scmon-h2/2.0;
 
%  p3-term
      p3sun=5.0/2.0*(h3-3.0*l3)*scsun^3+3.0/2.0*(l3-h3)*scsun;
      p3mon=5.0/2.0*(h3-3.0*l3)*scmon^3+3.0/2.0*(l3-h3)*scmon;
 
%  term in direction of sun/moon vector
      x2sun=3.0*l2*scsun;
      x2mon=3.0*l2*scmon;
      x3sun=3.0*l3/2.0*(5.0*scsun*scsun-1.0);
      x3mon=3.0*l3/2.0*(5.0*scmon*scmon-1.0);
 
%  factors for sun/moon 
      mass_ratio_sun=332945.9430620;
      mass_ratio_moon=0.0123000340;
      re =6378136.550;
      fac2sun=mass_ratio_sun*re*(re/rsun)^3;
      fac2mon=mass_ratio_moon*re*(re/rmon)^3;
      fac3sun=fac2sun*(re/rsun);
      fac3mon=fac2mon*(re/rmon);
 
%  total displacement
      dxtide = zeros(3,1);   
      for i=1:3
        dxtide(i)=fac2sun*( x2sun*xsun(i)/rsun + p2sun*dxyz(i)/rsta )+...
                  fac2mon*( x2mon*xmoon(i)/rmon + p2mon*dxyz(i)/rsta )+...
                  fac3sun*( x3sun*xsun(i)/rsun + p3sun*dxyz(i)/rsta )+...
                  fac3mon*( x3mon*xmoon(i)/rmon + p3mon*dxyz(i)/rsta );
      end
 
%  corrections for the out-of-phase part of love numbers
%  first, for the diurnal band
      xcorsta4=st1idiu(sinphi,cosphi,fac2sun,cos2phi,sinla,xsun,cosla,xmoon,fac2mon,rsun,rmon);
      dxtide(1)=dxtide(1)+xcorsta4(1);
      dxtide(2)=dxtide(2)+xcorsta4(2);
      dxtide(3)=dxtide(3)+xcorsta4(3);
 
% second, for the semi-diurnal band
      xcorsta3=st1isem(sinphi,cosphi,xsun,xmoon,cosla,sinla,rmon,rsun,fac2sun,fac2mon);
      dxtide(1)=dxtide(1)+xcorsta3(1);
      dxtide(2)=dxtide(2)+xcorsta3(2);
      dxtide(3)=dxtide(3)+xcorsta3(3);
 
% corrections for the latitude dependence of love numbers (part l^(1) )
      xcorsta1=st1l1(sinphi,cosphi,cosla,sinla,xsun,xmoon,rsun,rmon,fac2sun,fac2mon);
      dxtide(1)=dxtide(1)+xcorsta1(1);
      dxtide(2)=dxtide(2)+xcorsta1(2);
      dxtide(3)=dxtide(3)+xcorsta1(3);
 
% consider corrections for step 2
% second, the diurnal band corrections,
% (in-phase and out-of-phase frequency dependence):
      xcorsta2=step2diu(sinphi,cosphi,cosla,sinla,fhr,t,zla);
      dxtide(1)=dxtide(1)+xcorsta2(1);
      dxtide(2)=dxtide(2)+xcorsta2(2);
      dxtide(3)=dxtide(3)+xcorsta2(3);
  
% corrections for the long-period band,
% (in-phase and out-of-phase frequency dependence):
     xcorsta5=step2lon(dxyz,t);
      dxtide(1)=dxtide(1)+xcorsta5(1);
      dxtide(2)=dxtide(2)+xcorsta5(2);
      dxtide(3)=dxtide(3)+xcorsta5(3);
      