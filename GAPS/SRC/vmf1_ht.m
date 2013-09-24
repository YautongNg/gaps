function [vmf1h,vmf1w]=vmf1_ht (ah,aw,dmjd,dlat,ht,zd)
      
%C     !!! This is the version with height correction !!!  
%C     !!! It has to be used with the grid !!!    
%C
%C     This subroutine determines the VMF1 (Vienna Mapping Functions 1)
%C     Reference: Boehm, J., B. Werl, H. Schuh (2006), 
%C     Troposphere mapping functions for GPS and very long baseline interferometry 
%C     from European Centre for Medium-Range Weather Forecasts operational analysis data,
%C     J. Geoph. Res., Vol. 111, B02406, doi:10.1029/2005JB003629.
%C
%C     input data
%C     ----------
%C     ah:   hydrostatic coefficient a (www.hg.tuwien.ac.at/~ecmwf1)
%C     aw:   wet coefficient a         (www.hg.tuwien.ac.at/~ecmwf1)  
%C     dmjd: modified julian date
%C     dlat: latitude in radians
%C     ht:   ellipsoidal height in meter
%C     zd:   zenith distance in radians
%C
%C     output data
%C     -----------
%C     vmf1h: hydrostatic mapping function
%C     vmf1w: wet mapping function
%C
%C     Johannes Boehm, 2005 October 2
%C

%      implicit double precision (a-h,o-z)

      pi = 3.14159265359;
      
%C     reference day is 28 January
%C     this is taken from Niell (1996) to be consistent
      doy = dmjd  - 44239 + 1 - 28;
      
      bh = 0.0029;
      c0h = 0.062;
      if (dlat<0) %then   ! southern hemisphere
          phh  = pi;
          c11h = 0.007;
          c10h = 0.002;
      else                   %  ! northern hemisphere
          phh  = 0;
          c11h = 0.005;
          c10h = 0.001;
      end %if
      ch = c0h + ((cos(doy/365.25*2*pi + phh)+1)*c11h/2 + c10h)*(1-cos(dlat));


      sine   = sin(pi/2 - zd);
      beta   = bh/( sine + ch  );
      gamma  = ah/( sine + beta);
      topcon = (1 + ah/(1 + bh/(1 + ch)));
      vmf1h   = topcon/(sine+gamma);
      
%C  height correction [Niell, 1996]     
      a_ht = 2.53e-5;
      b_ht = 5.49e-3;
      c_ht = 1.14e-3;
      hs_km  = ht/1000;
      beta         = b_ht/( sine + c_ht);
      gamma        = a_ht/( sine + beta);
      topcon       = (1 + a_ht/(1 + b_ht/(1 + c_ht)));
      ht_corr_coef = 1/sine - topcon/(sine + gamma);
      ht_corr      = ht_corr_coef * hs_km;
      vmf1h        = vmf1h + ht_corr;

      bw = 0.00146;
      cw = 0.04391;
      beta   = bw/( sine + cw );
      gamma  = aw/( sine + beta);
      topcon = (1 + aw/(1 + bw/(1 + cw)));
      vmf1w   = topcon/(sine+gamma);
      
      end 