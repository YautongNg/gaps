function ionexval=getionexval(ionex,tim,lat,lon)
%
% Function getionexval
% ====================
%
%  Gets ionex values (TEC,RMS,Height) for given time, latitude and 
% longitude
%
% Sintax
% ======
%
% ionexval=getionexval(ionex,time,lat,long)
%
% Input
% =====
%
%   ionex -> structure with information from ionex file
%            (created by readionex.m)
%   tim -> time of the day, in seconds of the day
%   lat -> latitude of interest, in degrees
%   lon -> longitude of interest, in degrees
%
% Output
% ======
%
%   ionexval -> 2x1 matrix with computed values
%               ionexval=[TEC;RMS]
%                          (TECU)
%
% Created/Modified
% ================
%
% When              Who                 What
% ----              ---                 ----
% 2007/01/29        Rodrigo Leandro     Function created
%
% ===========================================================
% Copyright 2007 Rodrigo Leandro, University of New Brunswick
% ===========================================================

% Find lat
latv=unique(ionex.tec(:,2));
latdif=[latv latv-lat];
latless=latdif(latdif(:,2)<=0,:);
lat1=latless(end,1);
latmore=latdif(latdif(:,2)>=0,:);
lat2=latmore(1,1);

% Find lon
lonv=unique(ionex.tec(:,3));
londif=[lonv lonv-lon];
lonless=londif(londif(:,2)<=0,:);
lon1=lonless(end,1);
lonmore=londif(londif(:,2)>=0,:);
lon2=lonmore(1,1);

% Find time
timv=unique(ionex.tec(:,1));
timdif=[timv timv-tim];
timless=timdif(timdif(:,2)<=0,:);
tim1=timless(end,1);
timmore=timdif(timdif(:,2)>=0,:);
tim2=timmore(1,1);

% Get MFLT, where T-time F-lat L-long and M=T(tec)orR(rms)
% Values at tim1
T111=ionex.tec(ionex.tec(:,1)==tim1&ionex.tec(:,2)==lat1&ionex.tec(:,3)==lon1,5);
T121=ionex.tec(ionex.tec(:,1)==tim1&ionex.tec(:,2)==lat1&ionex.tec(:,3)==lon2,5);
T211=ionex.tec(ionex.tec(:,1)==tim1&ionex.tec(:,2)==lat2&ionex.tec(:,3)==lon1,5);
T221=ionex.tec(ionex.tec(:,1)==tim1&ionex.tec(:,2)==lat2&ionex.tec(:,3)==lon2,5);
R111=ionex.rms(ionex.rms(:,1)==tim1&ionex.rms(:,2)==lat1&ionex.rms(:,3)==lon1,5);
R121=ionex.rms(ionex.rms(:,1)==tim1&ionex.rms(:,2)==lat1&ionex.rms(:,3)==lon2,5);
R211=ionex.rms(ionex.rms(:,1)==tim1&ionex.rms(:,2)==lat2&ionex.rms(:,3)==lon1,5);
R221=ionex.rms(ionex.rms(:,1)==tim1&ionex.rms(:,2)==lat2&ionex.rms(:,3)==lon2,5);
% Values at tim2
T112=ionex.tec(ionex.tec(:,1)==tim2&ionex.tec(:,2)==lat1&ionex.tec(:,3)==lon1,5);
T122=ionex.tec(ionex.tec(:,1)==tim2&ionex.tec(:,2)==lat1&ionex.tec(:,3)==lon2,5);
T212=ionex.tec(ionex.tec(:,1)==tim2&ionex.tec(:,2)==lat2&ionex.tec(:,3)==lon1,5);
T222=ionex.tec(ionex.tec(:,1)==tim2&ionex.tec(:,2)==lat2&ionex.tec(:,3)==lon2,5);
R112=ionex.rms(ionex.rms(:,1)==tim2&ionex.rms(:,2)==lat1&ionex.rms(:,3)==lon1,5);
R122=ionex.rms(ionex.rms(:,1)==tim2&ionex.rms(:,2)==lat1&ionex.rms(:,3)==lon2,5);
R212=ionex.rms(ionex.rms(:,1)==tim2&ionex.rms(:,2)==lat2&ionex.rms(:,3)==lon1,5);
R222=ionex.rms(ionex.rms(:,1)==tim2&ionex.rms(:,2)==lat2&ionex.rms(:,3)==lon2,5);

% Interpolate in time
if (tim2-tim1)==0
    F=0;
else
    F=(tim-tim1)/(tim2-tim1);
end
T11 = T111 + (T112-T111)*F;
T12 = T121 + (T122-T121)*F;
T21 = T211 + (T212-T211)*F;
T22 = T221 + (T222-T221)*F;
R11 = sqrt( R111^2 + (R112*F)^2 + (R111*F)^2);
R12 = sqrt( R121^2 + (R122*F)^2 + (R121*F)*2);
R21 = sqrt( R211^2 + (R212*F)^2 + (R211*F)^2);
R22 = sqrt( R221^2 + (R222*F)^2 + (R221*F)^2);

% Interpolate in Longitude
if (lon2-lon1)==0
    F=0;
else
    F=(lon-lon1)/(lon2-lon1);
end
T1 = T11 + (T12-T11)*F;
T2 = T21 + (T22-T21)*F;
R1 = sqrt( R11^2 + (R12*F)^2 + (R11*F)^2);
R2 = sqrt( R21^2 + (R22*F)^2 + (R21*F)^2);

% Interpolate in Latitude
if (lat2-lat1)==0
    F=0;
else
    F=(lat-lat1)/(lat2-lat1);
end
T = T1 + (T2-T1)*F;
R = sqrt( R1^2 + (R2*F)^2 + (R1*F)^2);






ionexval=[T*10^ionex.exp;R*10^ionex.exp];

