function [el az] = elev(recxyz,recllh,satxyz)
%
% Function elev
% =============
%
%       Computes the elevation angle and azimuth (in radians) for given 
%       receiver and satellite coordinates
%
% Sintax
% ======
%
%       [ el az ] = elev(recxyz,satxyz)
%
% Input
% =====
%
%       recxyz -> 3x1 vector with receiver XYZ coordinates
%       recllh -> 3x1 vector with receiver geodetic coordinates
%       satxyz -> 3x1 vector with satellite XYZ coordinates
%
% Output
% ======
%
%       el -> elevation angle (rad)
%       az -> azimuth angle (rad)
%
% Created/Modified
% ================
%
% When              Who                     What
% ----              ---                     ----
% 2006/02/01        Rodrigo Leandro         Function created
% 2006/06/21        Rodrigo Leandro         Function addapted to RLPPP I/O
%                                           standards
% 2008/11/24        Rodrigo Leandro         Extended to compute azimuth
%
%
% ==============================
% Copyright 2006 Rodrigo Leandro
% ==============================

if (recxyz==0)==zeros(3,1)

    % Get Latitude and Longitude
    lat=recllh(1,1);
    long=recllh(2,1);

    % compute the range vector in geodetic cs

    rG = satxyz-recxyz;

    % define the rotation matrices:

    P2 = [1  0  0
          0 -1  0
          0  0  1];

    R2 = [cos(lat - pi/2)        0          -sin(lat - pi/2)
                 0               1                 0
          sin(lat - pi/2)        0           cos(lat - pi/2)];

    R3 = [cos(long - pi)        sin(long - pi)              0
         -sin(long - pi),       cos(long - pi)              0
              0                     0                       1];

    % compute the range vector in local geodetic cs

    rLG = P2*R2*R3*rG;

    % compute the elev. angle:
    el = asin(rLG(3,1)/norm(rG));

    % compute azimuth
    az = atan2( rLG(2,1) , rLG(1,1) );

else
    
    el = pi/2;
    
    az = 0;
    
    
end