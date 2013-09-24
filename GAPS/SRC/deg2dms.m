function dms=deg2dms(ddeg)
%
% Function deg2dms
% ================
%
%       Converts angles in decimal degrees to the format gg.mmsssssssss
%
% Sintax
% ======
%
%       dms=deg2dms(ddeg)
%
% Input
% =====
%
%       ddeg -> angle in decimal degrees
%
% Output
% ======
%
%       dms -> angle in the format gg.mmsssssssss
%
% Created/Modified
% ================
%
% When          Who                     What
% ----          ---                     ----
% 2006/06/28    Rodrigo Leandro         Function created
%
%
% ==============================
% Copyright 2006 Rodrigo Leandro
% ==============================

%====================================

%=======================
% 1. Get sign of angle
%-----------------------
sig=sign(ddeg);
ddeg=abs(ddeg);

%====================================
% 2. Get degrees, minutes and seconds
%------------------------------------
deg=fix(ddeg);

min=((ddeg-deg)*60);
min1=fix(min);
if 1-mod(min,1)<1e-10
	min1=min1+1;
end

sec=(min-min1)*60;

%==================================
% 3. Compute angle in ggg.mmsssssss
%----------------------------------
dms=sig.*(deg+min1/100+sec/10000);

end

%!test
%! deg = [0; -90; 90.5; -(90+1/3600); -(1/60); 180; 1; (90+1/60)];
%! dms = [0.0; -90.0; 90.300; -90.0001; -00.0100; 180.0; 1; 90.0060];
%! dms2 = deg2dms (deg);
%! %dms2 - dms  % DEBUG
%! assert (dms2, dms, -eps);

%!test
%! n = ceil(10*rand);
%! temp = rand(n,1);
%! sig = ones(n,1);  sig(temp>0.5) = -1;
%! deg = ceil(rand(n,1)*180);
%! min = ceil(rand(n,1)*60);
%! sec = rand(n,1)*60;
%! 
%! idx = sec == 60;  min(idx) = min(idx) + 1;  sec(idx) = 0; 
%! idx = min == 60;  deg(idx) = deg(idx) + 1;  min(idx) = 0; 
%! 
%! ddeg = sig .* (deg + (min + sec/60)/60);
%! dms  = sig .* (deg + (min + sec/100)/100);
%! 
%! dms2 = deg2dms(ddeg);
%! err = dms2 - dms;
%! %idx = err > 1000*eps;
%! %err(idx), [dms(idx), dms2(idx)], [deg(idx), min(idx), sec(idx)]
%! assert (err, 0, -1000*eps);

