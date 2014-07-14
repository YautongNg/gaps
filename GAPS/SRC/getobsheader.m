function head=getobsheader(fiobs)
%
% Function getobsheader
% =====================
% This function reads the observation file header and stores all the 
% information of it into a structure (head).
%
% SINTAXE
% =======
%         head=getobsheader(fiobs)
% 
% Created by Rodrigo Leandro
% May, 2006
    
    
% Getting information from header

    headerend='END OF HEADER';
    l=repmat(' ',1,80);
    nwl=0;
    nto=0;
    nob=0; % reseting the number of observations 
    while ~isequal(strtrim(l(61:end)), headerend)
    
        l=getrline(fiobs);

        if isequal(strtrim(l(61:end)), 'RINEX VERSION / TYPE')
            head.fversion=str2num(l(1:9));
            head.ftype=l(21);
            head.satsystem=l(31);

        
        elseif isequal(strtrim(l(61:end)), 'PGM / RUN BY / DATE')
            head.pgm=strtrim(l(1:20));
            head.runner=strtrim(l(21:40));
            head.date=strtrim(l(41:60));

        
        elseif isequal(strtrim(l(61:end)), 'MARKER NAME')
            head.markname=strtrim(l(1:60));


        elseif isequal(strtrim(l(61:end)), 'MARKER NUMBER')
            head.marknumber=strtrim(l(1:60));


        elseif isequal(strtrim(l(61:end)), 'OBSERVER / AGENCY')
            head.observer=strtrim(l(1:20));
            head.agency=strtrim(l(21:60));
    

        elseif isequal(strtrim(l(61:end)), 'REC # / TYPE / VERS')
            head.recnumber=strtrim(l(1:20));
            head.rectype=strtrim(l(21:40));
            head.recversion=strtrim(l(41:60));
    
 
        elseif isequal(strtrim(l(61:end)), 'ANT # / TYPE')
            head.antnumber=strtrim(l(1:20));
            head.anttype=strtrim(l(21:40));
    

        elseif isequal(strtrim(l(61:end)), 'APPROX POSITION XYZ')
            head.aproxx=str2num(l(1:14));
            head.aproxy=str2num(l(15:28));
            head.aproxz=str2num(l(29:42));     
    

        elseif isequal(strtrim(l(61:end)), 'ANTENNA: DELTA H/E/N')
            head.deltah=str2num(l(1:14));
            head.deltae=str2num(l(15:28));
            head.deltan=str2num(l(29:42));     

        
        % the function reads only one line for wavelength factors
        %   the following lines are ignored
        elseif isequal(strtrim(l(61:end)), 'WAVELENGTH FACT L1/2') & nwl==0
            head.wfact1=str2num(l(1:6));
            head.wfact2=str2num(l(7:12));
            nwl=1;

        
        elseif isequal(strtrim(l(61:end)), '# / TYPES OF OBSERV') & nto==0
            %obstype=cell(18);
            head.ntype=str2num(l(1:6));
            if head.ntype<10
                pos=11;
                for i=1:head.ntype
                    head.obstype(i)=cellstr(strtrim(l(pos:pos+1)));
                    pos=pos+6;
                end % for
            else
                pos=11;
                for i=1:9
                    head.obstype(i)=cellstr(strtrim(l(pos:pos+1)));
                    pos=pos+6;
                end % for
                l = fgetl(fiobs);
                pos=11;
                for i=10:head.ntype
                    head.obstype(i)=cellstr(strtrim(l(pos:pos+1)));
                    pos=pos+6;
                end % for
            end % if
            nto=1;
        
        
        elseif isequal(strtrim(l(61:end)), 'INTERVAL')
            head.interval=str2num(l(1:10));
        
        
        elseif isequal(strtrim(l(61:end)), 'TIME OF FIRST OBS')
            head.fyear=str2num(l(1:6));
            if head.fyear < 50
                head.fyear = head.fyear + 2000;
            elseif head.fyear < 100
                head.fyear = head.fyear + 1900;
            end
            head.fmonth=str2num(l(7:12));
            head.fday=str2num(l(13:18));
            head.fhour=str2num(l(19:24));
            head.fminute=str2num(l(25:30));
            head.fsecond=str2num(l(31:43));
            head.timesystem=strtrim(l(49:51));
        
        
        elseif isequal(strtrim(l(61:end)), 'TIME OF LAST OBS')
            head.lyear=str2num(l(1:6));
            head.lmonth=str2num(l(7:12));
            head.lday=str2num(l(13:18));
            head.lhour=str2num(l(19:24));
            head.lminute=str2num(l(25:30));
            head.lsecond=str2num(l(31:43));
        
        
        elseif isequal(strtrim(l(61:end)), 'RCV CLOCK OFFS APPL')
            head.offapp=str2num(l(1:6));
        
        
        elseif isequal(strtrim(l(61:end)), 'LEAP SECONDS')
            head.leapsec=str2num(l(1:6));
            % Number of leap seconds since 6-Jan-1980 -- optional    
   
    
        end % if

    
    end % while
    % End of Header!!!
end
    
    
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