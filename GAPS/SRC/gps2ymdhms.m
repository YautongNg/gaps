function [year,month,day, hour, minute,second]=gps2ymdhms(gps_week,sec_of_week)

jan61980 = 44244;
jan11901 = 15385;
sec_per_day = 86400;
mjd=(sec_of_week/sec_per_day)+gps_week*7+jan61980;

y=1;

while y
    %mjd2ymd.m modified from:
    %        H. van der Marel, LGR, 29-04-95 
    %        (c) Geodetic Computing Centre, TU Delft 

    % Express day in Gregorian calendar 

    jd=fix(mjd)+2400001; 
    fmjd=mjd-fix(mjd);

    n4  = 4 * ( jd + fix((fix((6*fix((4*jd-17918)/146097))/4)+1)/2) - 37 ); 
    nd10=10 * fix(rem(n4-237,1461)/4) + 5; 

    year=fix(n4/1461)-4712; 
    month=rem(fix(nd10/306)+2,12)+1; 
    day=fix(rem(nd10,306)/10)+1; 
    hour=fix(fmjd*24);
    minute=fix(fmjd*24*60) - hour*60;
    second=((fmjd*24-hour)*60-minute)*60;
    if second-round(second*1000)/1000 < 1e-5
        mjd=mjd+(1e-6)/60/24;
    else
        second=round(second*1000)/1000;
        y=0;
    end
end
