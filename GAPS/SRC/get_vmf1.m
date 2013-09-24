function mf=get_vmf1(recllh,elev,vmf_data,mjd)
a = interp1q(vmf_data(:,1), vmf_data(:,2:3),mjd);
if any(isnan(a))
    error('MATLAB:bad', 'vmf data doesn''t cover epoch %d.',mjd);
end
[temp(1), temp(2)] = vmf1_ht(a(1),a(2),mjd,recllh(1),recllh(3),(pi/2-elev));
mf=[temp(1); temp(2)];