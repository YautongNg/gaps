function lhg_data=get_lhg_files(date,head)
doy1=ymd2doy(date);
year1=date(1);
if isequal(date(2),12) && isequal(date(3),31)
    year2=date(1)+1;
    doy2=1;
else
    year2=date(1);
    doy2=doy1+1;
end

if doy1 < 10
    doy1=['00' num2str(doy1)];
elseif doy1>=10 && doy1<100
    doy1=['0' num2str(doy1)];
else
    doy1=num2str(doy1);
end

if doy2 < 10
    doy2=['00' num2str(doy2)];
elseif doy2>=10 && doy2<100
    doy2=['0' num2str(doy2)];
else
    doy2=num2str(doy2);
end

try
    lhg1=urlread(['http://mars.hg.tuwien.ac.at/~ecmwf1/LHG/GPS/' num2str(year1) '/' num2str(year1) doy1 '.lhg_g']);
    lhg2=urlread(['http://mars.hg.tuwien.ac.at/~ecmwf1/LHG/GPS/' num2str(year2) '/' num2str(year2) doy2 '.lhg_g']);
catch
    lhg_data=[];
    return;
end

ind1=strfind(lhg1,head.stn);
ind2=strfind(lhg2,head.stn);
if isempty(ind1) || isempty(ind2) 
    warning('Not a valid station.');
    lhg_data=[];
    return
else
    for i=1:size(ind1,2)
         lhg1_data(i,:) = sscanf(lhg1(ind1(i):ind1(i)+47), '%*4s %f %f %f %f %f', [1, 5]);
    end

    lhg2_data(1,:) = sscanf(lhg2(ind2(1):ind2(1)+47), '%*4s %f %f %f %f %f', [1, 5]);

    lhg_data=[lhg1_data;lhg2_data];

    if isequal(size(lhg_data),[5,5])
        fprintf(1,'\nLHG files successfully downloaded.\n');
    else
        warning('Error in downloading LHG files, Using NMF')
        lhg_data=[];
        return;      
    end
end
