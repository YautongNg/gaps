function [slft_data, pred_delay]=get_UNBRT(cdate,hobs)

doy=ymd2doy(cdate(1:3,1));

if floor(doy)<10
     strdoy=[ '00' num2str(floor(doy))];
elseif floor(doy) >= 10 & floor(doy) < 100
    strdoy=['0' num2str(floor(doy))];
else
    strdoy=num2str(floor(doy));
end
filename=[lower(hobs.stn) '_mf' num2str(cdate(1,1)) strdoy '.dat'];
 slft_data = load(filename);
 zen_filename=[lower(hobs.stn) '_delay_zen_predic_' num2str(cdate(1,1)) strdoy '.dat'];
 pred_delay=load(zen_filename);
