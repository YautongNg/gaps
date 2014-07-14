function cart = geod2cart(geod)
%
% Function geod2cart
% ==================
%
% Converts geodetic coordinates into cartesian coordinates.
%
% INPUT
% =====
%       geod -> nx3 matrix with geodetic coordinates
%               geod(:,1) -> Latitude in radians
%               geod(:,2) -> Longitude in radians
%               geod(:,3) -> Ellipsoidal height in meters
%            
%       ell -> structure with ellipsoid elements
%              ell.a -> major semi-axis (m)
%              ell.b -> minor semi-axis (m)
%
% OUTPUT
% ======
%    
%       cart -> nx3 matrix with cartesian coordinates
%               cart(:,1) -> X (m)
%               cart(:,2) -> Y (m)
%               cart(:,3) -> Z (m)
%
% CREATED/MODIFIED
% ================
%
% When        Who               What
% ----        ---               ----
% 2006/05/29  Rodrigo Leandro   Function Created
%
% COMMENTS
% ========
%  
%       Function for WGS84 Ellipsoid
%
%
%===============================
% Copyright 2006 Rodrigo Leandro
%===============================

% Ellipsoid axes
a = 6378137.0; % semi major axis
f = 1.0 / 298.2572235630;  % flattening
b = a * (1 - f);  % semi-minor axis;

% Geodetic coordinates
lat=geod(1,1);
lon=geod(2,1);
h=geod(3,1);

% Compute Prime Vertical radius
N = a^2 / sqrt( a^2 * (cos(lat))^2 + b^2 * (sin(lat))^2 );

% Cartesian coordinates
x = (N + h) * cos(lat) * cos(lon);
y = (N + h) * cos(lat) * sin(lon);
z = (N * (b/a)^2 + h) * sin(lat);
cart = [x y z]';