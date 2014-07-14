function GPSt=ymdhms2gps(year,month,mday,hour,minute,second)
%
% Function ymdhms2gps
%
% Coputes GPS week and seconds of week for a given date
%
% Sintaxe:
% function GPSt=ymdhms2gps(year,month,mday,hour,minute,second)
%
% Reference: Source code from the Remondi Date/Time Algorithms
%            http://www.ngs.noaa.gov/gps-toolbox/bwr-f.txt
%
%      integer*4 gps_week,year,month,mday,hour,minute
%      real*8    sec_of_week, second
%      integer*4 jan61980, jan11901
%      real*8    sec_per_day
%      integer*4 yday, mjd, leap_month_day, regu_month_day
%      real*8    fmjd


regu_month_day=[0 31 59 90 120 151 181 212 243 273 304 334];
leap_month_day=[0 31 60 91 121 152 182 213 244 274 305 335];

jan61980 = 44244;
jan11901 = 15385;
sec_per_day = 86400;

if mod(year,4)==0
    yday = leap_month_day(month) + mday;
else
    yday = regu_month_day(month) + mday;
end

mjd = fix(((year - 1901)/4))*1461 + fix(mod((year - 1901),4))*365 + yday - 1 + jan11901;
fmjd = ((second/60.0 + minute)/60.0 + hour)/24.0;

gps_week = fix((mjd - jan61980)/7);
sec_of_week = ( (mjd - jan61980) - gps_week*7 + fmjd )*sec_per_day;

GPSt=[gps_week;sec_of_week];