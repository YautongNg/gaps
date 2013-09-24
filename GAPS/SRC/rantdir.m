function rdir = rantdir(rllh)
%
% Function rantdir
% ================
%
%       Computes the direction of the receiver antenna.
%
% Sintaxe
% =======
%
%       rdir = rantdir(rxyz)
%
% Input
% =====
%
%       rxyz -> 3x1 vector with receiver XYZ coordinates
%
% Output
% ======
%
%       rdir -> Receiver antenna direction (3x3 matrix)
%               rdir=[xr;yr;zr]
%
% Created/Modified
% ================
%
% When              Who                     What
% ----              ---                     ----
% 2006/06/29        Rodrigo Leandro         Function created
%
%
% ==============================
% Copyright 2006 Rodrigo Leandro
% ==============================

% Get Latitude and Longitude
lat=rllh(1,1);
long=rllh(2,1);

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

% compute the direction vectors
rdir = P2*R2*R3;

rdir(1,1) =  -(sin(lat)*cos(long));
rdir(1,2) =  -(sin(lat)*sin(long));
rdir(1,3) = cos(lat);

rdir(2,1) =  (sin(long));
rdir(2,2) =  -(cos(long));
rdir(2,3) =  0;

rdir(3,1) =  (cos(lat)*cos(long));
rdir(3,2) =  (cos(lat)*sin(long));
rdir(3,3) =  sin(lat);