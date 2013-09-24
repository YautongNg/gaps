function p=intsp(sp3,prn,tod)
%
% Function comsp
% ==============
%
%       Interpolates the satellite position using precise ephemeris.
%
% Sintaxe
% =======
%
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
%       tod -> nx1 vector with times for which the position will be 
%              computed (seconds of day!!)
%
% Output
% ======
%
%       p -> nx3 matrix with satellite coordinates, each row corresponding
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

% Initialize satellite position matrix
p=zeros(size(prn,1),3);

% Determine the arc number
mids=[3 6 9 12 15 18 21 24];
[c arc]=min(abs(mids-(tod/3600)));

% Get component polynomials (X, Y and Z)
px=sp3{1,1};
py=sp3{1,2};
pz=sp3{1,3};

% Inpterpolate for each prn of the list
for i=1:size(prn,1)
    if arc(i) <= size(pz,1)
    % Interpolation
    x=polyvalr(px{arc(i),prn(i)},tod(i)-(arc(i)-1)*3*3600);
    y=polyvalr(py{arc(i),prn(i)},tod(i)-(arc(i)-1)*3*3600);
    z=polyvalr(pz{arc(i),prn(i)},tod(i)-(arc(i)-1)*3*3600);
    
    % Assign values
    p(i,1:3)=[x y z];
    else
        p(i,1:3)=nan(3,1);
    end
end