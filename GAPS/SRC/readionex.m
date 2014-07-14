function ionex = readionex(ionexname)
%
% Fuction readionex
% =================
%
%  This function reads the contents of a ionex file and store the data into
%  a structure called ionex
%
% Sintax
% ======
%
% ionex = readionex('ionexname')
%
% Input
% =====
%
% ionexname -> string with ionex file name
%
% Output
% ======
%
% ionex -> structure with data from ionex file
%
% Created/Modified
% ================
%
% Date          Who                 What
% ----          ---                 ----
% 2007/01/25    Rodrigo Leandro     Fuction created
%
%
% ===========================================================
% Copyright 2007 Rodrigo Leandro, University of New Brunswick
% ===========================================================


%=========================================
% Initialize Exponent value (default = -1)
%-----------------------------------------
ionex.exp=-1;
%=========================================

%================
% Initialize maps
%----------------
ionex.tec=[];
ionex.rms=[];
ionex.height=[];
%================

%==========
% Open file
%----------
fiobs = fopen (ionexname, 'rt');
%==========

%==========================================================================
% Read header
%--------------------------------------------------------------------------
headerend='END OF HEADER';
l=repmat(' ',1,80);
while ~isequal(strtrim(l(61:end)), headerend)
    
    l=getrline(fiobs);
    
    if isequal(strtrim(l(61:end)), 'IONEX VERSION / TYPE')
            ionex.fversion=str2num(l(1:8));
            ionex.ftype=l(21);
            ionex.satsystem=l(41:43);
            
    elseif isequal(strtrim(l(61:end)), 'PGM / RUN BY / DATE')
            ionex.pgm=strtrim(l(1:20));
            ionex.runner=strtrim(l(21:40));
            ionex.date=strtrim(l(41:60));

    elseif isequal(strtrim(l(61:end)), 'EPOCH OF FIRST MAP')
            ionex.fyear=str2num(l(1:6));
            ionex.fmonth=str2num(l(7:12));
            ionex.fday=str2num(l(13:18));
            ionex.fhour=str2num(l(19:24));
            ionex.fminute=str2num(l(25:30));
            ionex.fsecond=str2num(l(31:36));
            ionex.fsod=ionex.fhour*3600+ionex.fminute*60+ionex.fsecond;

    elseif isequal(strtrim(l(61:end)), 'EPOCH OF LAST MAP')
            ionex.lyear=str2num(l(1:6));
            ionex.lmonth=str2num(l(7:12));
            ionex.lday=str2num(l(13:18));
            ionex.lhour=str2num(l(19:24));
            ionex.lminute=str2num(l(25:30));
            ionex.lsecond=str2num(l(31:36));
            ionex.lsod=ionex.lhour*3600+ionex.lminute*60+ionex.lsecond;
            
    elseif isequal(strtrim(l(61:end)), 'INTERVAL')
            ionex.interval=str2num(l(1:6));

    elseif isequal(strtrim(l(61:end)), 'MAPPING FUNCTION')
            ionex.mapfunction=strtrim(l(3:6));
            
    elseif isequal(strtrim(l(61:end)), 'ELEVATION CUTOFF')
            ionex.elevcutoff=str2num(l(1:8));
            
    elseif isequal(strtrim(l(61:end)), 'OBSERVABLES USED')
            ionex.obsused=strtrim(l(1:60));
    
    elseif isequal(strtrim(l(61:end)), 'BASE RADIUS')
            ionex.baseradius=str2num(l(1:8))*1000;
            
    elseif isequal(strtrim(l(61:end)), 'MAP DIMENSION')
            ionex.dimension=str2num(l(1:6));
            
    elseif isequal(strtrim(l(61:end)), 'HGT1 / HGT2 / DHGT')
            ionex.hgt1=str2num(l(3:8));
            ionex.hgt2=str2num(l(9:14));
            ionex.dhgt=str2num(l(15:20));
            
    elseif isequal(strtrim(l(61:end)), 'LAT1 / LAT2 / DLAT')
            ionex.lat1=str2num(l(3:8));
            ionex.lat2=str2num(l(9:14));
            ionex.dlat=str2num(l(15:20));
          
    elseif isequal(strtrim(l(61:end)), 'LON1 / LON2 / DLON')
            ionex.lon1=str2num(l(3:8));
            ionex.lon2=str2num(l(9:14));
            ionex.dlon=str2num(l(15:20));
            
    elseif isequal(strtrim(l(61:end)), 'EXPONENT')
            ionex.exp=str2num(l(1:6));
            
    end
            
    
end %while ~isequal(strtrim(l(61:end)), headerend)
%==========================================================================


%==========================================================================
% Read data
%--------------------------------------------------------------------------
end_of_file = 'END OF FILE';
% Keep reading file until end_of_file record is found
while ~isequal(strtrim(l(61:end)), end_of_file)

    % Get first record, which indicates if current map is TEC or RMS
    l=getrline(fiobs);
    % Check kind of map and call appropriate function to read it
    if isequal(strtrim(l(61:end)), 'START OF TEC MAP')
        map=getmap(ionex,fiobs);
        ionex.tec=[ionex.tec ; map];
    elseif isequal(strtrim(l(61:end)), 'START OF RMS MAP')
        map=getmap(ionex,fiobs);
        ionex.rms=[ionex.rms ; map];
    elseif isequal(strtrim(l(61:end)), 'START OF HEIGHT MAP')
        map=getmap(ionex,fiobs);
        ionex.height=[ionex.height ; map];
    end
    
end %while ~isequal(strtrim(l(61:end)), end_of_file)

end %function
%==========================================================================



%=======================================================
function l=getrline(fiobs)
%
% Function: get next 'no comment' line of the rinex file 
%
%-------------------------------------------------------
    comment = 'COMMENT';
    l = fgetl(fiobs);
    cond=1;
    while cond==1
        if length(l)>60 
            if isequal(strtrim(l(61:end)),comment)
                l = fgetl(fiobs);
            else break
            end % if
        else break
        end % if
    end % while
end % function
%=======================================================



%==========================================================================
function map=getmap(ionex,fiobs)
    % Initialize parameter
    end_of_map='END OF';
    map=[];
        
    % Get epoch of current map
    l=getrline(fiobs);
    day=str2double(l(13:18));
    hour=str2double(l(19:24));
    minute=str2double(l(25:30));
    second=str2double(l(31:36));
    sod=hour*3600+minute*60+second;
    if ionex.fday~=day
        sod=sod+86400;
    end
    while 1
        % Get lat, lon1, lon2, dlon, and height
        l=getrline(fiobs);
        if strcmp(l(61:66),end_of_map)
            break
        end
        lat=str2double(l(3:8));
        lon1=str2double(l(9:14));
        lon2=str2double(l(15:20));
        dlon=str2double(l(21:26));
        hei=str2double(l(27:32));
        % Number of longitudes
        nlons = (lon2-lon1)/dlon + 1;
        % Number of lines
        nlines = fix(nlons/16 + 0.00001) + 1;
        values=[];
        for line=1:nlines
            l=getrline(fiobs);
            values1=sscanf(l,'%f');
            values=[values;values1];
        end
        for loni=1:nlons
            map1(loni,1)=sod;
            map1(loni,2)=lat;
            map1(loni,3)=lon1+(loni-1)*dlon;
            map1(loni,4)=hei;
            map1(loni,5)=values(loni,1);
        end
        map=[map ; map1];
    end %while
end %function
%==========================================================================
    
    
        
        
        
        

        
        
        
    
    
    

    
    

    
