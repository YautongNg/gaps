function aplxyz=intapl(apldata,doy,recllh)

n = interp1(apldata(:,1),apldata(:,2),doy);
e = interp1(apldata(:,1),apldata(:,3),doy);
u = interp1(apldata(:,1),apldata(:,4),doy);
aplxyz=offllh2xyz(recllh,[u;n;e]);
end
