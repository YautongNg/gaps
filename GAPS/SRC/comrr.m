function rr=comrr(sp3,prn,tod,rc)
%
% Function comrr
% ==============
%
%       Computes the satellite range rate using precise ephemeris.
%
% Sintaxe
% =======
%
%       rr=comrr(sp3,prn,tod,rc)
%
% Input
% =====
%
%       sp3 -> structure containing satellite arcs (computed using prosp3)
%              sp3 = 1x3 structure
%              sp3{1,1} = px
%              sp3{1,2} = py
%              sp3{1,3} = pz
%                  px,py,pz are 4xNS structures
%                  NS = Number of Satellites
%                  px{idx,prn}=17x1 polynomial coefficients
%                  idx = arc            number
%                     0h - 6h     -> 1
%                     6h - 12h    -> 2
%                     12h - 18h   -> 3
%                     18h - 24h   -> 4
%       prn -> nx1 vector with PRN of the satellites for which the 
%              position will be computed
%       tod -> time of day - nx1 vector with times for which the position 
%              will be computed (seconds of day!!)
%       rc -> 3x1 vector with receiver coordinates
%             rc=[xr;yr;zr]
%
% Output
% ======
%
%       rr -> nx1 vector with range rates, each row corresponding
%       to the respective row in prn and tod
%
% Created/Modified
% ================
%
% When              Who                     What
% ----              ---                     ----
% 2006/06/08        Rodrigo Leandro         Function created
%
% Comments
% ========
%
%       Time should be in seconds of day!
%
% ==============================
% Copyright 2006 Rodrigo Leandro
% ==============================

% Initialize Satellite Velocities Matrix
rr=zeros(size(prn,1),1);


for i=1:size(prn,1)
    
    % Get interpolated satellite positions
    isp1=intsp(sp3,prn(i),tod(i)-0.5);
    isp2=intsp(sp3,prn(i),tod(i)+0.5);
    
    % Compute ranges
    r1=norm(isp1-rc');
    r2=norm(isp2-rc');

    % Compute range rate
    rr(i,1)=r2-r1;
    
end