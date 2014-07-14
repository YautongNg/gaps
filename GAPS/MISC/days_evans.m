% Computing GPS week
GPSt=ymdhms2gps(year,month,day,0,0,0);
GPSweek1=GPSt(1,1); % GPS week
GPSweek2=GPSweek1;

% Computing the day of the week
day1=(fix(GPSt(2,1)/86400));
day2=(fix(GPSt(2,1)/86400))+1;
if day2>6
    day2=0;
    GPSweek2=GPSweek2+1;
end