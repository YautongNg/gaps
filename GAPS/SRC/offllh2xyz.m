function dxyz=offllh2xyz(recllh,offllh)
%
% Function offllh2xyz
% ===================
%
%       Computes offsets in XYZ for given UP, NORTH and EAST offsets at a 
%       given position.
%
% Sintax
% ======
%
%       dxyz=offllh2xyz(recllh,offllh)
%
% Input
% =====
%
%       rellh -> 3x1 vector with receiver geodetic coordinates.
%                recllh=[ lat ; lon ; hei ]
%                        (rad) (rad)  (m)
%       offllh -> 3x1 vector with offsets
%                 offllh=[ UP ; NORTH ; EAST]
%                          (m)  (m)     (m)
%
% Output
% ======
%
%       dxyz -> 3x1 vector with xyz offsets
%               dxyz=[ DX ; DY ; DZ ]
%                      (m)  (m)  (m)
%
% Created/Modified
% ================
%
% When          Who                     What
% ----          ---                     ----
% 2006/07/07    Rodrigo Leandro         Function created
%
%
% ==============================
% Copyright 2006 Rodrigo Leandro
% ==============================

dh = offllh(1,1);
dn = offllh(2,1);
de = offllh(3,1);

slat = sin(recllh(1,1));      
clat = cos(recllh(1,1));     
slon = sin(recllh(2,1));
clon = cos(recllh(2,1));

dxyz(1,1) = - (clon*slat*dn) - (slon*de) + (clat*clon*dh);
dxyz(2,1) = - (slon*slat*dn) + (clon*de) + (clat*slon*dh);
dxyz(3,1) =   (clat*dn)                       + (slat*dh);