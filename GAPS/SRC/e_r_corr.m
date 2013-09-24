function X_sat_rot = e_r_corr(traveltime, X_sat)
%
% Function e_r_corr
%   Returns rotated satellite ECEF coordinates
% due to Earth rotation during signal travel time
%
% Sintaxe:
%
% X_sat_rot = e_r_corr(traveltime, X_sat)
%
% INPUT:   traveltime [s]
%          Satellite Coordinates (3x1) [m]
% OUTPUT:  Rotated Satellite Coordinates (3x1) [m]
%
% Reference: GPS MATLAB Tools at Aalborg University by Kai Borre
%            http://www.ngs.noaa.gov/gps-toolbox/Borre.htm
%
%
% Rodrigo Leandro
% November, 2005

Omegae_dot = 7.292115e-5;           %  rad/sec

omegatau = Omegae_dot*traveltime;
R3 = [  cos(omegatau) sin(omegatau) 0;
       -sin(omegatau) cos(omegatau) 0;
          0               0        1];
X_sat_rot = R3*X_sat;