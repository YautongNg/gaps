function [dfiles_oc dfile_atx]=getoc(prename1,atxname,year,month,day,nd,tp,path,pathexe)
%
% Function getoc
% ==============
%
%       This function was created to download orbit and clock files from
%       IGS ftp server. Later it was extended to also download the antenna
%       (ANTEX) file
%
% Input
% =====
%
%       prename1 - name of local precise orbits file
%       atxname - name of local ANTEX file
%                 If the local names above are set to 'get', then the function
%                 download new files. 
%       nd - number of days for which files should be downloaded
%
% Output
% ======
%
%       dfiles_oc - list of orbit and clock file names that were downloaded
%       dfile_atx - ANTEX file name
%
% Created/Modfied
% ===============
%
% When          Who                     What
% ----          ---                     ----
% 2006/05/01    Rodrigo Leandro         Function created
% 2008/08/11    Rodrigo Leandro         Header was out of format - header
%                                       formatted!
% 2008/08/11    Rodrigo Leandro         error handling: if local ANTEX file
%                                       does not exist, download one (before 
%                                       this situation caused an error and
%                                       termination of the program)
% 2012/04/30    Matthew McAdam          Added provision for igs08.atx for
%                                       dates after and including 
%                                       April 17, 2011 (GPS week 1632).
%                                       igs05.atx will be used prior to
%                                       this week. Based on IGS-MAIL:6354.
%      
% ==========================================
% Copyright 2008 University of New Brunswick
% ==========================================
flag = false;

% Initialize outputs 
% (so the function doesn't crash if we need only one of them)
dfiles_oc=[];
dfile_atx=[];


fprintf(1,'Download Orbit/Clock/Antenna files:\n');

% Computing GPS week
GPSt=ymdhms2gps(year,month,day,0,0,0);
GPSweek1=GPSt(1,1); % GPS week
GPSweek2=GPSweek1;

% Computing the day of the week
day1=(fix(GPSt(2,1)/86400));
day2=(fix(GPSt(2,1)/86400))+1;
if day2>6
    day2=0;
    GPSweek2=GPSweek2+1;
end

% Converting to String
dayw1=num2str(day1);
dayw2=num2str(day2);
GPSweeks1=num2str(GPSweek1); % String format
GPSweeks2=num2str(GPSweek2); % String format
if GPSweek1<1000
    GPSweeks1=['0' GPSweeks1];
end
if GPSweek2<1000
        GPSweeks2=['0' GPSweeks2];
end





dfiles_oc{1,1} = 'none';
dfiles_oc{2,1} = 'none';


nf=0;
if strcmp(prename1, 'get')

    %======================================================================
    % Directory 1
    %======================================================================
 

    % Try IGS
    % Creating file names
    fname1=strcat('igs',GPSweeks1,dayw1,'.sp3.Z');
    fname2=strcat('igs',GPSweeks1,dayw1,'.clk_30s.Z');
    fname3=strcat('igs',GPSweeks2,dayw2,'.sp3.Z');
    fname4=strcat('igs',GPSweeks2,dayw2,'.clk_30s.Z');
    if tp==0
        fname2=strcat('igs',GPSweeks1,dayw1,'.clk.Z');
        fname4=strcat('igs',GPSweeks2,dayw2,'.clk.Z');
    end
    % Downloading files
    fprintf(1,'      Trying IGS Files...\n');
    local1 = dir(fullfile(path,fname1(1:end-2)));
    local2 = dir(fullfile(path,fname2(1:end-2)));
    local3 = dir(fullfile(path,fname3(1:end-2)));
    local4 = dir(fullfile(path,fname4(1:end-2)));

        if size(local1,1)>=1 && size(local2,1)>=1 % Check if the files are already available localy
            dfiles_oc{1,1}=fullfile(path,fname1(1:end-2));
            dfiles_oc{2,1}=fullfile(path,fname2(1:end-2));
            nf=nf+2;
        else
        % Try Logging into IGS ftp server....
        try
            fprintf(1,'   Logging into IGS ftp server...\n');
            ppftp='igscb.jpl.nasa.gov';
            igsftp1=ftp(ppftp);
            % Creating directory string
            dirstr1=strcat('/pub/product/',GPSweeks1,'/');
            dirstr2=strcat('/pub/product/',GPSweeks2,'/');
            dirstr3='/pub/station/general/';
            flag = true;
        catch
            fprintf(1,'   Try logging into CDDIS ftp server...\n');
            ppftp='cddis.gsfc.nasa.gov';
            igsftp1=ftp(ppftp);
            dirstr1=strcat('/gps/products/',GPSweeks1,'/');
            dirstr2=strcat('/gps/products/',GPSweeks2,'/');
            dirstr3='';
        end
        
        % Accessing directory 1
        fprintf(1,'   Accessing GPS Week directory (1)...\n');
        cd(igsftp1,dirstr1);
        
            
            file1=mget(igsftp1,[fname1 '*'],path);
            file2=mget(igsftp1,[fname2 '*'],path);
            %if isempty(file2)
             %   file2=mget(igsftp,[fname2(1:12) '.Z']);
            %end
            if size(file1,1)
                dfiles_oc{1,1}=gunzip(file1{1,1},path,pathexe);
                delete(file1{1,1});
            end
            if size(file2,1)
                dfiles_oc{2,1}=gunzip(file2{1,1},path,pathexe);
                delete(file2{1,1});
            end
            nf=nf+size(file1,1)+size(file2,1);
            close(igsftp1);
        end
        
        

        if size(local3,1)>=1 && size(local4,1)>=1% Check if the files are already available localy
            dfiles_oc{3,1}=fullfile(path,fname3(1:end-2));
            dfiles_oc{4,1}=fullfile(path,fname4(1:end-2));
            nf=nf+2;
        else
                    % Try Logging into IGS ftp server....
        try
            fprintf(1,'   Logging into IGS ftp server...\n');
            ppftp='igscb.jpl.nasa.gov';
            igsftp1=ftp(ppftp);
            % Creating directory string
            dirstr1=strcat('/pub/product/',GPSweeks1,'/');
            dirstr2=strcat('/pub/product/',GPSweeks2,'/');
            dirstr3='/pub/station/general/';
            flag = true;
        catch
            fprintf(1,'   Try logging into CDDIS ftp server...\n');
            ppftp='cddis.gsfc.nasa.gov';
            igsftp1=ftp(ppftp);
            dirstr1=strcat('/gps/products/',GPSweeks1,'/');
            dirstr2=strcat('/gps/products/',GPSweeks2,'/');
            dirstr3='';
        end
        
            igsftp2=ftp(ppftp);
            cd(igsftp2,dirstr2);
            file3=mget(igsftp2,[fname3 '*'],path);
            file4=mget(igsftp2,[fname4 '*'],path);
            %if isempty(file4)
             %   file4=mget(igsftp,[fname4(1:12) '.Z']);
            %end
            if size(file3,1)
                dfiles_oc{3,1}=gunzip(file3{1,1},path,pathexe);
                delete(file3{1,1});
            end
            if size(file4,1)
                dfiles_oc{4,1}=gunzip(file4{1,1},path,pathexe);
                delete(file4{1,1});
            end
            nf=nf+size(file3,1)+size(file4,1);
            close(igsftp2);
        end
    
        
    

    if nf==4
        message=strcat('      Downladed: ', num2str(nf),' file(s)!');
        fprintf(1,'%s\n',message);
    else
        fprintf(1,'      No IGS files found!\n');
    end

    % If not all igs files, try IGR
    if nf ~=4
        % Creating file names
        fname1=strcat('igr',GPSweeks1,dayw1,'.sp3.Z');  
        fname2=strcat('igr',GPSweeks1,dayw1,'.clk.Z');
        fname3=strcat('igr',GPSweeks2,dayw2,'.sp3.Z');  
        fname4=strcat('igr',GPSweeks2,dayw2,'.clk.Z');
        % Downloading files 
        fprintf(1,'      Trying IGR Files...\n');
        local1 = dir(fullfile(path,fname1(1:end-2)));
        local2 = dir(fullfile(path,fname2(1:end-2)));
        local3 = dir(fullfile(path,fname3(1:end-2)));
        local4 = dir(fullfile(path,fname4(1:end-2)));
        if size(local1,1)>=1 && size(local2,1)>=1 && size(local3,1)>=1 && size(local4,1)>=1 % Check if the files are already available localy
            dfiles_oc{1,1}=fname1(1:end-2);
            dfiles_oc{2,1}=fname2(1:end-2);
            dfiles_oc{3,1}=fname3(1:end-2);
            dfiles_oc{4,1}=fname4(1:end-2);
            nf=4;
        else
            igsftp1=ftp(ppftp);
            cd(igsftp1,dirstr1);
            file1=mget(igsftp1,[fname1 '*'],path);
            file2=mget(igsftp1,[fname2 '*'],path);
            
            igsftp2=ftp(ppftp);
            cd(igsftp2,dirstr2);
            file3=mget(igsftp2,[fname3 '*'],path);
            file4=mget(igsftp2,[fname4 '*'],path);
            if size(file1,1)
                dfiles_oc{1,1}=gunzip(file1{1,1},path,pathexe);
                delete(file1{1,1});
            end
            if size(file2,1)
                dfiles_oc{2,1}=gunzip(file2{1,1},path,pathexe);
                delete(file2{1,1});
            end
            if size(file3,1)
                dfiles_oc{3,1}=gunzip(file3{1,1},path,pathexe);
                delete(file3{1,1});
            end
            if size(file4,1)
                dfiles_oc{4,1}=gunzip(file4{1,1},path,pathexe);
                delete(file4{1,1});
            end
            nf=size(file1,1)+size(file2,1)+size(file3,1)+size(file4,1);
            close(igsftp1);
            close(igsftp2);
        end
        if nf>1
            message=strcat('      Downladed: ', num2str(nf),' file(s)!');
            fprintf(1,'%s\n',message);  
        else
            %fprintf(1,'      No IGR files found!\n');
            error('No Orbit and Clock Products Found.');
        end
    end


    %======================================================================

    
end %if strcmp(prename1, 'get')

if strcmp(atxname, 'get')
    
    if GPSweek1 >= 1632
        % Creating file names
        fname3=('igs08_*.atx');
        % Get list of available atx files
    else
        fname3=('igs05.atx');
    end
    
    local_atxfilelist=dir(fullfile(path,fname3));
    if size(local_atxfilelist,1)>=1 %& strcmp(atxfilelist(end).name,local_atxfilelist(end).name)
        fprintf(1,'      Local file matches latest file...\n');
        fprintf(1,'      Download cancelled...\n');
        dfile_atx{1,1}=fullfile(path,local_atxfilelist(end).name);
    else
        % Accessing antenna file directory
        fprintf(1,'   Accessing antenna file directory...\n');
        if ~flag
            ppftp='igscb.jpl.nasa.gov';
            dirstr3='/pub/station/general/';
        end
        igsftp=ftp(ppftp);
        cd(igsftp,dirstr3);
        atxfilelist=dir(igsftp,fname3);
        fprintf(1,'      Downloading latest file...\n');
        % Download the latest one
        dfile_atx=mget(igsftp,atxfilelist(end).name,path);
        close(igsftp)
    end
end

% Closing connection
fprintf(1,'   Closing connection...\n');

fprintf(1,'   Local Files:\n');
if strcmp(prename1, 'get')
    for i=1:size(dfiles_oc,1)
    fprintf(1,'                      %s\n',dfiles_oc{i,1});
    end
end
if strcmp(atxname, 'get')
    fprintf(1,'                      %s\n',dfile_atx{1,1});
end

fprintf(1,'   Done.\n');
