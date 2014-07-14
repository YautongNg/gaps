function ippll=ionopp(recxyz,satxyz)
%
% Function ionopp
% ===============
%
%       Computes the geodetic latitude and longitude of the ionospheric
%       piercing point for given reciver coordinates and satellite azimuth
%       and elevation angles. Formulas from Klobuchar model are used.
%
% Sintax
% ======
%
%       ippll=ionopp(recllh,az,el)
%
% Input
% =====
%
%       recxyz -> 3x1 vector with receiver cartesian coordinates.
%                 recxyz = [ X ; Y ; Z ]
%                           [m] [m] [m]
%       satxyz -> 3x1 vector with satellite cartesian coordinates.
%                 satxyz = [ X ; Y ; Z ]
%                           [m] [m] [m]
%
% Output
% ======
%
%       ippll -> 2x1 vector with ionospheric piercing point geodetic 
%                latitude and longitude
%
% Created/Modified
% ================
%
% When          Who                         What
% ----          ---                         ----
% 2006/08/10    Rodrigo Leandro             Function created
%
%
% ==============================
% Copyright 2006 Rodrigo Leandro
% ==============================

recllh=cart2geod(recxyz);
[el az]=elev(recxyz,recllh,satxyz);
%azdist=invsol(recxyz,satxyz);
%az=azdist(1,1);

% Convert angles to semicircles (SC)
rad2sc=1/pi;
sc2rad=pi;
lat=recllh(1,1)*rad2sc;
lon=recllh(2,1)*rad2sc;
az=az*rad2sc;
el=el*rad2sc;

psi=(0.0137/(el+0.11))-0.022;
latip=lat+psi*cos(az*sc2rad);
if latip>0.416
    latip=0.416;
elseif latip<-0.416
    latip=-0.416;
end
lonip=lon+((psi*sin(az*sc2rad))/cos(latip*sc2rad));

ippll=[latip*sc2rad;lonip*sc2rad];