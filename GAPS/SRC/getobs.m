function [obs sta cdate]=getobs(fiobs,head)
%
% Function getobs
% ===============
%
% This function reads the observation record (one epoch) of the RINEX 
% observation file. The file has to be open and the header has to be 
% previously read.
%
% INPUT
% =====
%       ifo -> File identifier
%
% OUTPUT
% ======
%       obs -> nsxno matrix containing observations (same order as stated 
%              in the header)
%              ns -> # of satellites
%              no -> # of observables
%              obs(:,1) -> GPS Time (sow)
%              obs(:,2) -> Satellite PRN
%              obs(:,3:end) -> Observables
%
%       sta -> Status of the function - 1 -> data read
%                                       0 -> data read, end of file reached
%
% CREATED/MODIFIED
% ================
%
% WHEN         WHO                   WHAT
% ----         ---                   ----
% 2006/05/23   Rodrigo Leandro       Function created
%
% ==============================
% Copyright 2006 Rodrigo Leandro
% ==============================


% Status of the observation file (0-> end of file)
sta=1;

if feof(fiobs)
    error('PPP ERROR: End of observation file reached before closing loop!!');
else

    % Preallocatting Space in Memory
    prn=zeros(30,1);

    l=getrline(fiobs);
    eflag=str2double(l(29));
    while eflag>2
        if eflag>2 % in case there is an event flag
            nsrec=str2double(l(30:32)); % number of special records
            for i=1:nsrec+1
                l = fgetl(fiobs); % IGNORING special records
            end % for
        end % eflag>1
        eflag=str2double(l(29));
    end
        cyear=str2double(l(2:3));
        if cyear<50
            cyear=cyear+2000;
        else
            cyear=cyear+1900;
        end
        cmonth=str2double(l(5:6));
        cday=str2double(l(8:9));
        chour=str2double(l(11:12));
        cmnt=str2double(l(14:15));
        csec=str2double(l(16:26));
        cdate=[cyear;cmonth;cday;chour;cmnt;csec];
        nsat=str2double(l(30:32)); % number of satellites
        tim=ymdhms2gps(head.fyear,cmonth,cday,chour,cmnt,csec);
        if nsat<13
            ngsat=0; % number of GPS satellites
            pos=33;
            for i=1:nsat
                syid=(l(pos));
                if syid==' ' || syid=='G'
                    ngsat=ngsat+1;
                    prn(i)=str2double(l(pos+1:pos+2));
                else
                    prn(i)=0;
                end % if
                pos=pos+3;
            end % for
        else
            ngsat=0; % number of GPS satellites
            pos=33;
            for i=1:12
                syid=(l(pos));
                if syid==' ' || syid=='G'
                    ngsat=ngsat+1;
                    prn(i)=str2double(l(pos+1:pos+2));
                else
                    prn(i)=0;
                end % if
                pos=pos+3;
            end % for
            l = fgetl(fiobs); % getting next line with additional sat.
            pos=33;
            for i=13:nsat
                syid=(l(pos));
                if syid==' ' || syid=='G'
                    ngsat=ngsat+1;
                    prn(i)=str2double(l(pos+1:pos+2));
                else
                    prn(i)=0;
                end     %for
                pos=pos+3;
            end % for
        end % if -- number of satellites
        nob=0; % Number of observations for current epoch
        ngsat=0; % Number of GPS satellites for current epoch
        for i=1:nsat
            if prn(i)~=0
                ngsat=ngsat+1;
                nob=nob+1;
                obs(nob,1)=tim(2,1);
                obs(nob,2)=prn(i);
                l=getrline(fiobs);
                if head.ntype<6
                    pos=1;
                    for j=1:head.ntype
                        if length(l)>=pos+13
                            if ~isequal(l(pos:pos+13),'              ')
                                obs(nob,j+2)=str2double(l(pos:pos+13));
                            else
                                obs(nob,j+2)=0;
                            end % if
                        else
                            obs(nob,j+2)=0;
                        end % if
                        pos=pos+16;
                    end % for
                else % if head.ntype<6
                    pos=1;
                    for j=1:5
                        if length(l)>=pos+13
                            if ~isequal(l(pos:pos+13),'              ')
                                obs(nob,j+2)=str2double(l(pos:pos+13));
                            else
                                obs(nob,j+2)=0;
                            end % if
                        else
                            obs(nob,j+2)=0;
                        end % if
                        pos=pos+16;
                    end % for
                    l=getrline(fiobs);
                    pos=1;
                    for j=6:head.ntype
                        if length(l)>=pos+13
                            if ~isequal(l(pos:pos+13),'              ')
                                obs(nob,j+2)=str2double(l(pos:pos+13));
                            else
                                obs(nob,j+2)=0;
                            end % if ~isequal
                        else
                            obs(nob,j+2)=0;
                        end % if length(l)>=pos+13
                        pos=pos+16;
                    end % for j=6:head.ntype                      
                end % if head.ntype<6
            else
                l=getrline(fiobs);
                if head.ntype>5
                    l=getrline(fiobs);
                end % if head.ntype>5
            end % if prn(i~=0)
        end % for

    if feof(fiobs)
        sta=0;
    end

end % if feof(fiobs)

end % Function getobs





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
        