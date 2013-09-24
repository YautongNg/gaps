function  [recxyz,recllh,recclk,zennad,hzg,amb]=...
    updtx(delta,recxyz,recclk,zennad,hzg,amb,prnlist)
%
% Function updtx
% ==============
%
%       Updates the parameters of the adjustment
%
% Sintax
% ======
%
%       [recxyz,recllh,recclk,zennad,amb]=updtx ...
%    (delta,recxyz,recclk,zennad,amb)
%
% Input
% =====
%
%       delta -> nx1 vector with parameters update vector
%       recxyz -> 3x1 vector with current receiver XYZ coordinates
%       recclk -> current receiver clock offset
%       zennad -> 2x1 vector with current zenith NA delay
%       amb -> 31x1 vector with current ambiguity values
%       prnlist -> nx1 vector with prn list
%
% Output
% ======
%
%       recxyz -> 3x1 vector with updated receiver XYZ coordinates
%       recllh -> 3x1 vector with updated receiver geodetic coordinates
%       recclk -> updated receiver clock offset
%       zennad -> 2x1 vector with current zenith NA delay
%       amb -> 31x1 vector with updated ambiguity values
%
% Created/Modified
% ================
%
% When              Who                     What
% ----              ---                     ----
% 2006/06/22        Rodrigo Leandro         Function created
%
%
%
% ==============================
% Copyright 2006 Rodrigo Leandro
% ==============================
npar=7;
%=====================
% Receiver coordinates
%---------------------
recxyz=recxyz+delta(1:3,1);
recllh=cart2geod(recxyz);
%=====================

%===============
% Receiver clock
%---------------
recclk=recclk+delta(4,1);
%===============

%================================
% Neutral atmosphere zenith delay
%--------------------------------
    zennad(2,1)=zennad(2,1)+delta(5,1);
%================================

%================================
% Horizontal Tropospheric gradients
%--------------------------------
    hzg(1)=hzg(1)+delta(6,1);
    hzg(2)=hzg(2)+delta(7,1);
%============
% Ambiguities
%------------
for i=npar+1:size(delta)
    prn=prnlist(i-npar);
    amb(prn)=amb(prn)+delta(i);
end
%============