function dllh = distllh(p1xyz,p2xyz)
%
% Function elev
% =============
%
%       Computes the distances (in m) in lat, long and height between two 
%       sets of coordinates, in the sense of P2-P1.
%
% Sintaxe
% =======
%
%       dllh = distllh(p1xyz,p2xyz)
%
% Input
% =====
%
%       p1xyz -> 3x1 vector with P1 XYZ coordinates
%       p2xyz -> 3x1 vector with satellite XYZ coordinates
%
% Output
% ======
%
%       dllh -> 3x1 vector with the distances (in m) in lat, long and
%       height
%
% Created/Modified
% ================
%
% When              Who                     What
% ----              ---                     ----
% 2006/06/28        Rodrigo Leandro         Function created
%
%
% ==============================
% Copyright 2006 Rodrigo Leandro
% ==============================

% Get Latitude and Longitude
p1llh=cart2geod(p1xyz);
p2llh=cart2geod(p2xyz);
lat=p1llh(1,1);
long=p1llh(2,1);

% compute the range vector in geodetic cs

rG = p2xyz-p1xyz;

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
J_inv=(P2*R2*R3)';
dllh = J_inv*rG;


%J_inv =
%
%        -0.142186857870998         0.988297361977462        0.0552378652480538
%         0.921222505003735         0.152539582759327        -0.357883740852045
%         0.362121517896156                         0         0.932130895462962

