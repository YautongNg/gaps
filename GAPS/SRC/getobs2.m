function [obs sta cdate gtcount]=getobs2(gtobs,head,gtcount)

sta = 1;

obs = [];

% Get next line
gtcount = gtcount + 1;
obs(1,1) = gtobs(gtcount,2);
obs(1,2:size(gtobs,2)-2)=[sysid2svid(gtobs(gtcount,3),gtobs(gtcount,4)) gtobs(gtcount,5:end)];
%obs(1,2:size(gtobs,2)-2)=gtobs(gtcount,4:end);
% Compute cdate
%cdate(1,1)=head.fyear;
%cdate(2,1)=head.fmonth;
%cdate(3,1)=head.fday;
%hod=mod(obs(1,1),86400)/3600;
%cdate(4,1)=floor(hod);
%moh=(hod-cdate(4,1))*60;
%cdate(5,1)=floor(moh);
%cdate(6,1)=(moh-cdate(5,1))*60;
[hobs.fyear,hobs.fmonth,hobs.fday, hobs.fhour, hobs.fminute, hobs.fsecond]=gps2ymdhms(gtobs(gtcount,1),obs(1,1));
cdate=[hobs.fyear;hobs.fmonth;hobs.fday; hobs.fhour; hobs.fminute; hobs.fsecond];


for i = gtcount+1 : size(gtobs,1)
    
    if (gtobs(i,2)~=obs(1,1))
        gtcount = i - 1;
        break;
    else
        idx=size(obs,1)+1;
        obs(idx,1) = gtobs(i,2);
        obs(idx,2:size(gtobs,2)-2)=[sysid2svid(gtobs(i,3),gtobs(i,4)) gtobs(i,5:end)];
       %obs(idx,2:size(gtobs,2)-2)=gtobs(i,4:end);
        gtcount = i;
    end
end

if gtcount == size(gtobs,1)
    sta = 0; % Means end of file
end
