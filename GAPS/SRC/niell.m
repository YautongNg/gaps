function nmf = niell(recllh,doy,elev)
%
% Function niell
% ==============
%
%       Niel function returns a 2x1 vector with hydrostatic mapping 
%       function (mh) and non-hydrostatic mapping function (mnh):
% 
% Sintax
% ======
%
%       nmf = Niell(latp,doy,he,elev)
%
% Input
% =====
%
%       recllh -> 3x1 vector with receiver geodetic coordinates
%       doy -> Day of Year
%       elev -> Elevation angle (radians)
% 
% Output
% ======
%
%       Niel function returns a 2x1 vector with hydrostatic mapping 
%       function (mh) and non-hydrostatic mapping function (mnh):
%
%       nmf=[mh mnh]'
%            mh  -> [dimensionless]
%            mnh -> [dimensionless]
%
% Created/Modified
% ================
%
% When              Who                     What
% ----              ---                     ----
% 2005/05/01        Rodrigo Leandro         Function created
% 2006/06/21        Rodrigo Leandro         Function addapted to RLPPP I/O
%                                           standards
%
%
% ===================================
% Copyright 2005-2006 Rodrigo Leandro
% ===================================



% Compute latitude to degrees
latp=recllh(1,1)*180/pi;

% Height in m
he=recllh(3,1);

% Constants
aht = 2.53e-5;
bht = 5.49e-3;
cht = 1.14e-3;

%Coefficients
ahavg(1) = 0.0012769934;
ahavg(2) = 0.001268323;
ahavg(3) = 0.0012465397;
ahavg(4) = 0.0012196049;
ahavg(5) = 0.0012045996;
bhavg(1) = 0.0029153695;
bhavg(2) = 0.0029152299;
bhavg(3) = 0.0029288445;
bhavg(4) = 0.0029022565;
bhavg(5) = 0.0029024912;
chavg(1) = 0.062610505;
chavg(2) = 0.062837393;
chavg(3) = 0.063721774;
chavg(4) = 0.063824265;
chavg(5) = 0.064258455;
ahamp(1) = 0;
ahamp(2) = 0.000012709626;
ahamp(3) = 0.000026523662;
ahamp(4) = 0.000034000452;
ahamp(5) = 0.000041202191;
bhamp(1) = 0;
bhamp(2) = 0.000021414979;
bhamp(3) = 0.000030160779;
bhamp(4) = 0.000072562722;
bhamp(5) = 0.00011723375;
champ(1) = 0;
champ(2) = 0.0000901284;
champ(3) = 0.000043497037;
champ(4) = 0.00084795348;
champ(5) = 0.0017037206;
anh(1) = 0.00058021897;
anh(2) = 0.00056794847;
anh(3) = 0.00058118019;
anh(4) = 0.00059727542;
anh(5) = 0.00061641693;
bnh(1) = 0.0014275268;
bnh(2) = 0.0015138625;
bnh(3) = 0.0014572752;
bnh(4) = 0.0015007428;
bnh(5) = 0.0017599082;
cnh(1) = 0.043472961;
cnh(2) = 0.04672951;
cnh(3) = 0.043908931;
cnh(4) = 0.044626982;
cnh(5) = 0.054736038;


lat=latp;
latp=abs(latp);
if lat<15
    ahavgu = ahavg(1);
    bhavgu = bhavg(1);
    chavgu = chavg(1);
    ahampu = ahamp(1);
    bhampu = bhamp(1) ;
    champu = champ(1);
    anhu = anh(1);
    bnhu = bnh(1);
    cnhu = cnh(1);
elseif lat>75
    ahavgu = ahavg(5);
    bhavgu = bhavg(5);
    chavgu = chavg(5);
    ahampu = ahamp(5);
    bhampu = bhamp(5) ;
    champu = champ(5);
    anhu = anh(5);
    bnhu = bnh(5);
    cnhu = cnh(5);
else    
%Computation of Coefficients
ahavgu = ((latp - fix(latp / 15) * 15) / 15) * (ahavg(fix(latp / 15) + 1) - ahavg(fix(latp / 15))) + ahavg(fix(latp / 15));
bhavgu = ((latp - fix(latp / 15) * 15) / 15) * (bhavg(fix(latp / 15) + 1) - bhavg(fix(latp / 15))) + bhavg(fix(latp / 15));
chavgu = ((latp - fix(latp / 15) * 15) / 15) * (chavg(fix(latp / 15) + 1) - chavg(fix(latp / 15))) + chavg(fix(latp / 15));
ahampu = ((latp - fix(latp / 15) * 15) / 15) * (ahamp(fix(latp / 15) + 1) - ahamp(fix(latp / 15))) + ahamp(fix(latp / 15));
bhampu = ((latp - fix(latp / 15) * 15) / 15) * (bhamp(fix(latp / 15) + 1) - bhamp(fix(latp / 15))) + bhamp(fix(latp / 15));
champu = ((latp - fix(latp / 15) * 15) / 15) * (champ(fix(latp / 15) + 1) - champ(fix(latp / 15))) + champ(fix(latp / 15));
anhu = ((latp - fix(latp / 15) * 15) / 15) * (anh(fix(latp / 15) + 1) - anh(fix(latp / 15))) + anh(fix(latp / 15));
bnhu = ((latp - fix(latp / 15) * 15) / 15) * (bnh(fix(latp / 15) + 1) - bnh(fix(latp / 15))) + bnh(fix(latp / 15));
cnhu = ((latp- fix(latp / 15) * 15) / 15) * (cnh(fix(latp / 15) + 1) - cnh(fix(latp / 15))) + cnh(fix(latp / 15));
end
if lat<0
 ahampu=-ahampu;
 bhampu=-bhampu;
 champu=-champu;
end
ahu = ahavgu - ahampu * cos(2 * pi * ((doy - 28) / 365.25));
bhu = bhavgu - bhampu * cos(2 * pi * ((doy - 28) / 365.25));
chu = chavgu - champu * cos(2 * pi * ((doy - 28) / 365.25));

%Hidrostatic Mapping Function
c1 = 1 + (ahu / (1 + bhu / (1 + chu)));
c2 = sin(elev) + (ahu / (sin(elev) + bhu / (sin(elev) + chu)));
c3 = 1 + (aht / (1 + bht / (1 + cht)));
c4 = sin(elev) + (aht / (sin(elev) + bht / (sin(elev) + cht)));
mh = (c1 / c2) + (he/1000) * ((1 / sin(elev)) - (c3 / c4));

%Non-Hidrostatic Mapping Function
c1 = 1 + (anhu / (1 + bnhu / (1 + cnhu)));
c2 = sin(elev) + (anhu / (sin(elev) + bnhu / (sin(elev) + cnhu)));
mnh = (c1 / c2);

nmf=[mh ; mnh];