function doy=ymd2doy(cdate)
%
% Function ymd2doy
% ================
%
%       Computes the day of year for given year, month and day
%
% Sintaxe
% =======
%
%       doy=ymd2doy(cdate)
%
% Input
% =====
%
%       cdate -> 6x1 vector with year, month, day, hour*, minute* and sec*
%                ymd=[ year ; month ; day ; hour ; minute ; second]
%
%                (*) optional
%
%                ** Four digits year **
%
% Output
% ======
%
%       doy -> Day of year
%
%


iyear=cdate(1,1);
imonth=cdate(2,1);
iday=cdate(3,1);

dmonth=[31;28;31;30;31;30;31;31;30;31;30;31];
if mod(iyear-1980,4)==0
    dmonth(2)=29;
end

doy=sum(dmonth(1:imonth-1))+(iday);    