function vmf_out=get_vmf1_files(cdate,recllh,path,pathexe)

epoch=datenum(cdate(1),cdate(2),cdate(3));
cdate2=datevec(epoch+1);

stn_lat=rad2deg(recllh(1));
if recllh(2)<0
    stn_lon=rad2deg(recllh(2))+360;
else
    stn_lon=rad2deg(recllh(2));
end
stn_h=recllh(3);
year1=num2str(cdate(1));

if cdate(2)<10
    month1=['0' num2str(cdate(2))];
else
    month1=num2str(cdate(2));
end
if cdate(3)<10
    day1=['0' num2str(cdate(3))];
else
    day1=num2str(cdate(3));
end

year2=num2str(cdate2(1));
if cdate2(2)<10
    month2=['0' num2str(cdate2(2))];
else
    month2=num2str(cdate2(2));
end

if cdate2(3)<10
    day2=['0' num2str(cdate2(3))];
else
    day2=num2str(cdate2(3));
end


try
    if str2double(year1) < 2009
        exten = '.gz';
    elseif str2double(year1) >=2009
        exten=[];
    end
    
    if str2double(year2) < 2009
        exten2 = '.gz';
    elseif str2double(year2) >=2009
        exten2=[];
    end
    
    do_unzip=zeros(5,1);
    
    if ~exist(fullfile(path,['VMFG_' year1 month1 day1 '.H00']),'file')
        urlwrite(['http://ggosatm.hg.tuwien.ac.at/DELAY/GRID/VMFG/' year1 '/VMFG_' year1 month1 day1 '.H00' exten],fullfile(path,['VMFG_' year1 month1 day1 '.H00' exten]));
        do_unzip(1,1)=1;
    end
    if ~exist(fullfile(path,['VMFG_' year1 month1 day1 '.H06']),'file')
        urlwrite(['http://ggosatm.hg.tuwien.ac.at/DELAY/GRID/VMFG/' year1 '/VMFG_' year1 month1 day1 '.H06' exten],fullfile(path,['VMFG_' year1 month1 day1 '.H06' exten]));
        do_unzip(2,1)=1;
    end
    if ~exist(fullfile(path,['VMFG_' year1 month1 day1 '.H12']),'file')
        urlwrite(['http://ggosatm.hg.tuwien.ac.at/DELAY/GRID/VMFG/' year1 '/VMFG_' year1 month1 day1 '.H12' exten],fullfile(path,['VMFG_' year1 month1 day1 '.H12' exten]));
        do_unzip(3,1)=1;
    end
    if ~exist(fullfile(path,['VMFG_' year1 month1 day1 '.H18']),'file')
        urlwrite(['http://ggosatm.hg.tuwien.ac.at/DELAY/GRID/VMFG/' year1 '/VMFG_' year1 month1 day1 '.H18' exten],fullfile(path,['VMFG_' year1 month1 day1 '.H18' exten]));
        do_unzip(4,1)=1;
    end
    if ~exist(fullfile(path,['VMFG_' year2 month2 day2 '.H00']),'file')
        urlwrite(['http://ggosatm.hg.tuwien.ac.at/DELAY/GRID/VMFG/' year2 '/VMFG_' year2 month2 day2 '.H00' exten2],fullfile(path,['VMFG_' year2 month2 day2 '.H00' exten2]));
        do_unzip(5,1)=1;
    end
    
    if str2double(year1) < 2009
        if do_unzip(1,1)
            vmf1_files{1,1}=gunzip(['VMFG_' year1 month1 day1 '.H00' exten],path,pathexe);
        else
            vmf1_files{1,1}=fullfile(path,['VMFG_' year1 month1 day1 '.H00']);
        end
        %delete(['VMFG_' year1 month1 day1 '.H00' exten])
        if do_unzip(2,1)
            vmf1_files{2,1}=gunzip(['VMFG_' year1 month1 day1 '.H06' exten],path,pathexe);
        else
            vmf1_files{2,1}=fullfile(path,['VMFG_' year1 month1 day1 '.H06']);
        end
        %delete(['VMFG_' year1 month1 day1 '.H06' exten])
        if do_unzip(3,1)
            vmf1_files{3,1}=gunzip(['VMFG_' year1 month1 day1 '.H12' exten],path,pathexe);
        else
            vmf1_files{3,1}=fullfile(path,['VMFG_' year1 month1 day1 '.H12']);
        end
        %delete(['VMFG_' year1 month1 day1 '.H12' exten])
        if do_unzip(4,1)
            vmf1_files{4,1}=gunzip(['VMFG_' year1 month1 day1 '.H18' exten]);
        else
            vmf1_files{4,1}=fullfile(path,['VMFG_' year1 month1 day1 '.H18']);
        end
        %delete(['VMFG_' year1 month1 day1 '.H18' exten])
    else
        vmf1_files{1,1}=fullfile(path,['VMFG_' year1 month1 day1 '.H00' exten]);
        vmf1_files{2,1}=fullfile(path,['VMFG_' year1 month1 day1 '.H06' exten]);
        vmf1_files{3,1}=fullfile(path,['VMFG_' year1 month1 day1 '.H12' exten]);
        vmf1_files{4,1}=fullfile(path,['VMFG_' year1 month1 day1 '.H18' exten]);
    end
    
    if str2double(year2) < 2009
        if do_unzip(5,1)
            vmf1_files{5,1}=gunzip(['VMFG_' year2 month2 day2 '.H00' exten],path,pathexe);
        else
            vmf1_files{5,1}=fullfile(path,['VMFG_' year2 month2 day2 '.H00']);
        end
        %delete(['VMFG_' year2 month2 day2 '.H00' exten])
    else
        vmf1_files{5,1}=fullfile(path,['VMFG_' year2 month2 day2 '.H00' exten]);
    end
    
catch
    vmf_out=[];
    return;
end


fid = fopen(fullfile(path,'orography.ell'));
A = fscanf(fid, '%f', [145 91]);
fclose(fid);
A=A';


dlat=2;
dlon=2.5;
g=9.784;
R=0.289644;
% if ispc()
%     slash = '\';
% else
%     slash = '/';
% end
        
for i =1:5
    [lat lon ah aw zh zw] = textread([vmf1_files{i}],'%f %f %f %f %f %f','headerlines',7);
    [fdir,fname,fext] = fileparts(vmf1_files{i});
    vmf1_file = [fname fext];
    mjd(i,1)=ymds2mjd(str2num(vmf1_file(6:9)),str2num(vmf1_file(10:11)),str2num(vmf1_file(12:13)), str2num(vmf1_file(end-1:end))*3600);
    vmf_data= [lat lon ah aw zh zw];
    latidx1=find(vmf_data(:,1)==fix(stn_lat/dlat)*dlat);
    latidx2=find(vmf_data(:,1)==(fix(stn_lat/dlat)+1)*dlat);
    
    lonidx1=find(vmf_data(:,2)==fix((stn_lon)/dlon)*dlon);
    lonidx2=find(vmf_data(:,2)==(fix((stn_lon)/dlon)+1)*dlon);
    
    idx1=intersect(lonidx1,latidx1);
    idx2=intersect(lonidx2,latidx2);
    idx3=intersect(lonidx1,latidx2);
    idx4=intersect(lonidx2,latidx1);
    
    grid_h1=A((45-vmf_data(idx1,1)/dlat)+1,((vmf_data(idx1,2))/dlon)+1);
    grid_h2=A((45-vmf_data(idx2,1)/dlat)+1,((vmf_data(idx2,2))/dlon)+1);
    grid_h3=A((45-vmf_data(idx3,1)/dlat)+1,((vmf_data(idx3,2))/dlon)+1);
    grid_h4=A((45-vmf_data(idx4,1)/dlat)+1,((vmf_data(idx4,2))/dlon)+1);
    
    [pres1,temp1,undu1] = gpt (mjd(i,1),deg2rad(vmf_data(idx1,1)),deg2rad(vmf_data(idx1,2)),grid_h1);
    [pres2,temp2,undu2] = gpt (mjd(i,1),deg2rad(vmf_data(idx2,1)),deg2rad(vmf_data(idx2,2)),grid_h2);
    [pres3,temp3,undu3] = gpt (mjd(i,1),deg2rad(vmf_data(idx1,1)),deg2rad(vmf_data(idx2,2)),grid_h3);
    [pres4,temp4,undu4] = gpt (mjd(i,1),deg2rad(vmf_data(idx2,1)),deg2rad(vmf_data(idx2,1)),grid_h4);

    
    vmf_data(idx1,5)=vmf_data(idx1,5)-0.002277*(g/R)*(pres1/(temp1+273.15))*(stn_h/1000-grid_h1/1000);
    vmf_data(idx2,5)=vmf_data(idx2,5)-0.002277*(g/R)*(pres2/(temp2+273.15))*(stn_h/1000-grid_h2/1000);
    vmf_data(idx3,5)=vmf_data(idx3,5)-0.002277*(g/R)*(pres3/(temp3+273.15))*(stn_h/1000-grid_h3/1000);
    vmf_data(idx4,5)=vmf_data(idx4,5)-0.002277*(g/R)*(pres4/(temp4+273.15))*(stn_h/1000-grid_h4/1000);
    
    
    %==========================================================================
    % Interpolate for latitude
    %--------------------------------------------------------------------------
    ah1=vmf_data(idx1,3)+(stn_lat-vmf_data(idx1,1))*(vmf_data(idx3,3)-vmf_data(idx1,3))/(vmf_data(idx3,1)-vmf_data(idx1,1));
    ah2=vmf_data(idx2,3)+(stn_lat-vmf_data(idx2,1))*(vmf_data(idx4,3)-vmf_data(idx2,3))/(vmf_data(idx4,1)-vmf_data(idx2,1));
    aw1=vmf_data(idx1,4)+(stn_lat-vmf_data(idx1,1))*(vmf_data(idx3,4)-vmf_data(idx1,4))/(vmf_data(idx3,1)-vmf_data(idx1,1));
    aw2=vmf_data(idx2,4)+(stn_lat-vmf_data(idx2,1))*(vmf_data(idx4,4)-vmf_data(idx2,4))/(vmf_data(idx4,1)-vmf_data(idx2,1));
    
    zh1=vmf_data(idx1,5)+(stn_lat-vmf_data(idx1,1))*(vmf_data(idx3,5)-vmf_data(idx1,5))/(vmf_data(idx3,1)-vmf_data(idx1,1));
    zh2=vmf_data(idx2,5)+(stn_lat-vmf_data(idx2,1))*(vmf_data(idx4,5)-vmf_data(idx2,5))/(vmf_data(idx4,1)-vmf_data(idx2,1));
    zw1=vmf_data(idx1,6)+(stn_lat-vmf_data(idx1,1))*(vmf_data(idx3,6)-vmf_data(idx1,6))/(vmf_data(idx3,1)-vmf_data(idx1,1));
    zw2=vmf_data(idx2,6)+(stn_lat-vmf_data(idx2,1))*(vmf_data(idx4,6)-vmf_data(idx2,6))/(vmf_data(idx4,1)-vmf_data(idx2,1));
    %==========================================================================

    %==========================================================================
    % Interpolate for longitude
    %--------------------------------------------------------------------------
    ah3(i,1)=ah1+(stn_lon-vmf_data(idx1,2))*(ah2-ah1)/(vmf_data(idx4,2)-vmf_data(idx1,2));
    aw3(i,1)=aw1+(stn_lon-vmf_data(idx1,2))*(aw2-aw1)/(vmf_data(idx4,2)-vmf_data(idx1,2));
    zh3(i,1)=zh1+(stn_lon-vmf_data(idx1,2))*(zh2-zh1)/(vmf_data(idx4,2)-vmf_data(idx1,2));
    zw3(i,1)=zw1+(stn_lon-vmf_data(idx1,2))*(zw2-zw1)/(vmf_data(idx4,2)-vmf_data(idx1,2));

end
%delete(['VMFG_' year1 month1 day1 '.H00'])
%delete(['VMFG_' year1 month1 day1 '.H06'])
%delete(['VMFG_' year1 month1 day1 '.H12'])
%delete(['VMFG_' year1 month1 day1 '.H18'])
%delete(['VMFG_' year2 month2 day2 '.H00'])
vmf_out=[mjd ah3 aw3 zh3 zw3];








