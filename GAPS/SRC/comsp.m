function [p v]=comsp(sp3,prn,cdate,soff,satclk,p0,cst,xsun)
%
% Function comsp
% ==============
%
%       Computes the satellite position using precise ephemeris.
%
% Sintaxe
% =======
%
%
% Input
% =====
%
%       sp3 -> structure containing satellite arcs (computed using prosp3)
%              sp3 = 1x3 structure
%              sp3{1,1} = px
%              sp3{1,2} = py
%              sp3{1,3} = pz
%                  px,py,pz are 4xNS structures
%                  NS = Number of Satellites
%                  px{idx,prn}=17x1 polynomial coefficients
%                  idx = arc            number
%                     0h - 6h     -> 1
%                     6h - 12h    -> 2
%                     12h - 18h   -> 3
%                     18h - 24h   -> 4
%       prn -> PRN of the satellite for which the position will be computed
%       tod -> nx1 vector with time of day - nx1 vector with times for 
%              which the position will be computed (seconds of day!!)
%       soff -> 31x3 matrix with antenna offsets
%               soff(PRN,1)=X offset*
%               soff(PRN,2)=Y offset*
%               soff(PRN,3)=Z offset*
%               (*) Satellite body coordinate system
%       cdate -> 6x1 vector with date.
%                cdate=[year;month;day;hour;minute;second]
%       satclk -> satellite clock error (m)
%       p0 -> pseudorange (m) 
%
% Output
% ======
%
%       p -> 3x1 vector with satellite coordinates
%            p=[ X ; Y ; Z ]
%               (m) (m) (m)
%
% Created/Modified
% ================
%
% When              Who                     What
% ----              ---                     ----
% 2006/06/08        Rodrigo Leandro         Function created
% 2006/06/20        Rodrigo Leandro         Added inputs to compute
%                                           transmission time inside the 
%                                           function (cdate, p0, cst, 
%                                           satclk)
%
% Comments
% ========
%
%       Time should be in seconds of day!
%
% ==============================
% Copyright 2006 Rodrigo Leandro
% ==============================

% Compute time in sod
sod=cdate(4,1)*3600+cdate(5,1)*60+cdate(6,1);

% Compute transmission time
tod=sod-p0/cst.c-satclk/cst.c;
    
% Get interpolated satellite position
isp=intsp(sp3,prn,tod);
isp2=intsp(sp3,prn,tod+1);
v = (isp2-isp)';

% Compute Julian Date
%jd=ymdhms2jd(cdate);

% Apply correction for antenna offset
if all(~isnan(isp))
    p=santoff(isp,soff(prn,:),xsun);
else
    p=isp;
end