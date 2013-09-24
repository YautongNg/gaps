function rngcor=xyz2rngcor(xyzoff,recxyz,satxyz)
%
% Function xyz2rngcor
% ===================
%
%       Computes the range correction due to an XYZ offset, given satellite
%       and receiver positions.
%
% Sintax
% ======
%
%       rngcor=xyz2rngcor(xyzoff,recxyz,satxyz)
%
% Input
% =====
%
%       xyzoff -> 3x1 vector with xyz offset (m)
%       recxyz -> 3x1 vector with receiver cartesian coordinates
%       satxyz -> 3x1 vector with satellite cartesian coordinates
%
% Output
% ======
%
%       rngcor -> range correction (m)
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


vrs=(satxyz-recxyz);
uvrs=vrs/norm(vrs);
rngcor=dotr(xyzoff,uvrs);