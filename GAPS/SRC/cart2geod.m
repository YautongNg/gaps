function llh=cart2geod(xyz)
%
% Function cart2geod
% ==================
%
%       Computes Latitude Longitude and Height for given X Y Z.
%
% Sintaxe
% =======
%
%       llh=cart2geod(xyz,ell)        
%
% Input
% =====
%        
%       xyz -> 3x1 vector with xyz coordinates (m)
%              xyz=[ X ; Y ; Z ]
%                   (m) (m) (m)
%       ell -> structure with ellipsoid elements
%              ell.a -> major semi-axis (m)
%              ell.b -> minor semi-axis (m)
% 
% Output
% ======
%
%       llh -> 3x1 vector with Latitude, Longitude and Height
%              llh=[ Lat ; Lon ; h ]
%                   (rad) (rad) (m)
%
% Created/Modified
% ================
%
% When          Who               What
% ----          ---               ----
% 2006/06/20    Rodrigo Leandro   Function Created
%
% Comments
% ========
%
%       This function uses WGS84 ellipsoid.
%
% ==============================
% Copyright 2006 Rodrigo Leandro
% ==============================

if sum(xyz~=0)>0

    x=xyz(1,1);
    y=xyz(2,1);
    z=xyz(3,1);

    a = 6378137.0; % semi major axis
    f = 1.0 / 298.2572235630;  % flattening
    %b = a * (1 - f);  % semi-minor axis;
    e2 = (2 * f) - (f ^ 2);
    P2 = sqrt(x ^ 2 + y ^ 2);
    %t = atan((y * a) / (P2 * b));
    %el2 = (a ^ 2 - b ^ 2) / (b ^ 2);
    lonp = atan2(y,x);

    latp=0;
    hp=0;
    latpf=1;
    hpf=1;

    while abs(latpf-latp)>0.0000000000001 & abs(hpf-hp)>0.0000000000001
    latpf=latp;
    no = a / (sqrt(1 - (e2 * (sin(latp)) ^ 2)));
    latp = atan(((z/P2))*(1-(e2*(no/(no+hp))))^-1);
    hpf=hp;
    hp = (P2 / cos(latp)) - no;
    end


    llh=[latp ; lonp ; hp];

else
    
    llh=[0;0;0];
    
end