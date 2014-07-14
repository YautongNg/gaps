function APLOUT=get_APL(station,cdate,xyz,path)

xyz=xyz';
yy=num2str(cdate(1));

if cdate(2)<10
    mn=['0' num2str(cdate(2))];
else
    mn=num2str(cdate(2));
end
if cdate(3)<10
    dd=['0' num2str(cdate(3))];
else
    dd=num2str(cdate(3));
end

date_form=[yy '.' mn '.' dd];

APL_file=['vsgd_' yy '_' mn '.eph'];

fid=fopen(fullfile(path,APL_file),'r');


while ~feof(fid)
    tline=fgetl(fid);
    if strcmpi(tline(1),'D'),apl2=NaN;return;end
    if strcmpi(tline(1),'S') 
        if strcmpi(strtrim(tline(4:11)),station),break;end
       X=str2num(strtrim(tline(14:26))); Y=str2num(strtrim(tline(28:40))); Z=str2num(strtrim(tline(42:54))); 
       pos=[X Y Z];
       if norm(pos-xyz)<1500
           station=strtrim(tline(4:11));
           break;
       end
       
    end
end

APL=[];
while ~feof(fid) & size(APL,1)~=4
    tline=fgetl(fid);
    if strcmpi(tline(1),'D') & strcmpi(tline(25:34),date_form) & strcmpi( strtrim(tline(46:53)),station);
        doy=ymd2doy([str2double(tline(25:28));str2double(tline(30:31));str2double(tline(33:34))+str2double(tline(36:37))/24]);
        APL=[APL; doy str2double(tline(55:62)) str2double(tline(64:71)) str2double(tline(73:80))];
    end
end
if size(APL)==[4 4]
    APLOUT=[APL(:,1) APL(:,4) APL(:,3) APL(:,2)];
else
    APLOUT=NaN;
end
fclose(fid);
