function [satatx recatx]=readatx(atxname)
%
% Function readatx
% ================
%
%   Reads the antex file specified in atxname and stores all values into
%   appropriate variables
%
% Sintax
% ======
%
%   [satatx recatx]=readatx(atxname)
%
% Input
% =====
%
%   atxname -> string with antex file name
%
% Output
% ======
%
%   satatx -> nx1 structure with satellite APC values/information
%             satatx(i).prn -> Double, PRN number
%             satatx(i).dazi -> Double, azimuth interval (0 if NOAZI)
%             satatx(i).zen -> 3x1, [ZEN1;ZEN2;DZEN]
%             satatx(i).nfreq -> Double, number of frequencies
%             satatx(i).vfrom -> Double (YYYYMMDD), initial date
%             satatx(i).vuntil -> Double (YYYYMMDD), final date
%             satatx(i).freq -> nfreqx1 structure with freq. information
%               satatx(i).freq(j).number -> Double, freq. number
%               satatx(i).freq(j).neu -> 3x1, North-East-up offsets
%               satatx(i).freq(j).noazi -> nx1, No azimuth phase corr.
%               satatx(i).freq(j).azi -> nxm, Azimuth phase corr.
%                                               ([] for dazi=0)
%   recatx -> nx1 structure with receiver APC values/information
%             recatx(i).type -> String, Receiver type
%             recatx(i).dazi -> Double, azimuth interval (0 if NOAZI)
%             recatx(i).zen -> 3x1, [ZEN1;ZEN2;DZEN]
%             recatx(i).nfreq -> Double, number of frequencies
%             recatx(i).vfrom -> Double (YYYYMMDD), initial date
%             recatx(i).vuntil -> Double (YYYYMMDD), final date
%             recatx(i).freq -> nfreqx1 structure with freq. information
%               recatx(i).freq(j).number -> Double, freq. number
%               recatx(i).freq(j).neu -> 3x1, North-East-up offsets
%               recatx(i).freq(j).noazi -> nx1, No azimuth phase corr.
%               recatx(i).freq(j).azi -> nxm, Azimuth phase corr.
%                                               ([] for dazi=0)
%
% Created/Modified
% ================
%
% When              Who                     What
% ----              ---                     ----
% 2006/11/04        Rodrigo Leandro         Function created
% 2009/12/15        Wei Cao                 Modified to read Galileo 
% 2009/12/15        Landon Urquhart         Modified to read GLONASS and
%                                           then default to receiver. 
% 
% 
% ==============================
% Copyright 2006 Rodrigo Leandro
% ==============================

fprintf(1,'Reading ANTEX file... ');
%satatx=repmat(struct('prn',NaN,'dazi',NaN,'zen',NaN,'nfreq',NaN,'vfrom',NaN,'vuntil',NaN,'freq',NaN),1,120);

%---------------------------------------
% Initialize satellite/receiver counters
isat=0;
irec=0;
%---------------------------------------

%----------
% Open file
fatx = fopen(atxname, 'rt');
%----------

%------------
% Read header
endheader=0; % end of header control
while endheader==0
    l = getncl(fatx); % read next line
    if isequal(strtrim(l(61:73)),'END OF HEADER') % verify end of header 
        endheader=1; % if END OF HEADER, set EOH control
    end
end
%------------

%----------
% Read data
% -> read all antennas until the end of the file
while feof(fatx)==0
    
    % START OF ANTENNA
    l = getncl(fatx); % read next line
    % This line should be the start of a new antenna
    if ~isequal(strtrim(l(61:76)),'START OF ANTENNA') % verify start 
        error('Antex file format error');
    end
    % No information to get from this line
    
    % TYPE / SERIAL NO
    l = getncl(fatx); % read next line
    if ~isequal(strtrim(l(61:76)),'TYPE / SERIAL NO') % verify record 
        error('Antex file format error');
    end
    % Save this line into a string
    type=l(1:60);
    
    % METH / BY / # / DATE
    l = getncl(fatx); % read next line
    if ~isequal(strtrim(l(61:80)),'METH / BY / # / DATE') % verify record 
        error('Antex file format error');
    end
    % No information to get from this line
    
    % DAZI
    l = getncl(fatx); % read next line
    if ~isequal(strtrim(l(61:64)),'DAZI') % verify record 
        error('Antex file format error');
    end
    % Get Azimuth variation
    dazi=str2double(l(1:8));
    
    % ZEN1 / ZEN2 / DZEN
    l = getncl(fatx); % read next line
    if ~isequal(strtrim(l(61:78)),'ZEN1 / ZEN2 / DZEN') % verify record 
        error('Antex file format error');
    end
    % Get zenith/nadir angle variation
    zen=sscanf(strtrim(l(1:20)),'%f');
    
    % # OF FREQUENCIES
    l = getncl(fatx); % read next line
    if ~isequal(strtrim(l(61:76)),'# OF FREQUENCIES') % verify record 
        error('Antex file format error');
    end
    % Get number of frequencies
    nfreq=str2double(l(1:6));
    
    % VALID FROM  !!OPTIONAL!!
    l = getncl(fatx); % read next line
    if isequal(strtrim(l(61:70)),'VALID FROM') % verify record
        vfrom=sscanf(strtrim(l(1:60)),'%f');
        vfrom=vfrom(1,1)*10000+vfrom(2,1)*100+vfrom(3,1);
        l = getncl(fatx); % read next line
    else
        vfrom=0;
    end
    
    % VALID UNTIL  !!OPTIONAL!!
    if isequal(strtrim(l(61:71)),'VALID UNTIL') % verify record
        vuntil=sscanf(strtrim(l(1:60)),'%f');
        vuntil=vuntil(1,1)*10000+vuntil(2,1)*100+vuntil(3,1);
        l = getncl(fatx); % read next line
    else
        vuntil=99999999;
    end

    % SINEX CODE  !!OPTIONAL!!
    if isequal(strtrim(l(61:71)),'SINEX CODE') % verify record
        l = getncl(fatx); % read next line
    end
    
    for ifreq=1:nfreq % Get all frequencies
        
        if ifreq>1
            l = getncl(fatx); % read next line
        end
        % No need of reading the next line for the first frequency because 
        % it was alredy read to check optional records above
        
        % START OF FREQUENCY
        if ~isequal(strtrim(l(61:78)),'START OF FREQUENCY') % verify record 
            error('Antex file format error');
        end
        % Get frequecy system/number
        freq(ifreq).number=str2double(l(5:6));
        
        
        % NORTH / EAST / UP
        l = getncl(fatx); % read next line
        if ~isequal(strtrim(l(61:77)),'NORTH / EAST / UP') % verify record 
            error('Antex file format error');
        end
        % Get north/east/up offsets
        freq(ifreq).neu=sscanf(strtrim(l(1:60)),'%f');

        % NOAZI values
        l = getncl(fatx); % read next line
        % Get NOAZI values
        freq(ifreq).noazi=sscanf(strtrim(l(9:end)),'%f');
        
        % AZI values
        if dazi>0
            freq(ifreq).azi=[];
            for i=1:360/dazi+1
                l = getncl(fatx); % read next line
                temp_azi=sscanf(strtrim(l),'%f');
                freq(ifreq).azi=[freq(ifreq).azi ; temp_azi'];
            end %for i=1:360/dazi+1
        else
            freq(ifreq).azi=[];
        end %if dazi>0
           
        % END OF FREQUENCY
        l = getncl(fatx); % read next line
        if ~isequal(strtrim(l(61:76)),'END OF FREQUENCY') % verify record 
            error('Antex file format error');
        end
        % No data to get from this line

    end %for ifreq=1:nfreq
        
    % END OF ANTENNA
    l = getncl(fatx); % read next line
    if ~isequal(strtrim(l(61:74)),'END OF ANTENNA') % verify record 
        error('Antex file format error');
    end
    % No data to get from this line

    
    %======================================================================
    % Put data into appropriate variables
    %----------------------------------------------------------------------
    if isequal(strtrim(type(1:5)),'BLOCK')
        % In this case this is a GPS satellite
        isat=isat+1;
        satatx(isat).prn=str2double(type(22:23));
        satatx(isat).dazi=dazi;
        satatx(isat).zen=zen;
        satatx(isat).nfreq=nfreq;
        satatx(isat).vfrom=vfrom;
        satatx(isat).vuntil=vuntil;
        satatx(isat).freq=freq;
     elseif isequal(strtrim(type(1:7)),'GALILEO')
        % In this case this is a GALILEO satellite
        isat=isat+1;
        satatx(isat).prn=str2double(type(22:23))+30;
        satatx(isat).dazi=dazi;
        satatx(isat).zen=zen;
        satatx(isat).nfreq=nfreq;
        satatx(isat).vfrom=vfrom;
        satatx(isat).vuntil=vuntil;
        satatx(isat).freq=freq;
     elseif isequal(strtrim(type(1:7)),'GLONASS')
        % In this case this is a GLONASS satellite
        isat=isat+1;
        satatx(isat).prn=str2double(type(22:23))+40;
        satatx(isat).dazi=dazi;
        satatx(isat).zen=zen;
        satatx(isat).nfreq=nfreq;
        satatx(isat).vfrom=vfrom;
        satatx(isat).vuntil=vuntil;
        satatx(isat).freq=freq;
    else
        % In this case this is NOT a GPS NEITHER a GLONASS satellite
        % Therefore it is a station antenna (Not considering Galileo here)
        irec=irec+1;
        recatx(irec).type=strtrim(type(1:20));
        recatx(irec).dazi=dazi;
        recatx(irec).zen=zen;
        recatx(irec).nfreq=nfreq;
        recatx(irec).vfrom=vfrom;
        recatx(irec).vuntil=vuntil;
        recatx(irec).freq=freq;
        
    
    end
    
    %======================================================================
    
end %while feof(fatx)==0

fprintf(1,'Done.\n');

end %function [satatx recatx]=readatx(atxname)



function l=getncl(fatx)
% This function gets the next non-comment line
    NC=0; % No Comment control
    while NC==0;
        l = fgetl(fatx);
        if ~isequal(strtrim(l(61:67)),'COMMENT') % verify comment
            NC=1; % set No Comment control in case it is NOT comment
        end
    end
end
            


