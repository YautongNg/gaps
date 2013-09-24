function p1c1_file_name=getP1C1( Y_num , M_num, path, pathexe )
% Function getP1C1
% ================
%
%   This function automatically downloads the most recent P1C1bias file    
%    from the CODE data analysis centre.
%
% Sintax
% ======
%
%       p1c1_file_name=getP1C1( Y_num , M_num )
%
% Input                        Type
% =====                        =====
%
%       Y_num --> year ex. 2008      int
%       M_num --> month ex. 8        int
%       
% Output
% ======
%
%       p1c1_file_name--> Name of the P1C1bias file which was downloaded
%
% Created/Modified
% ================
%
% When              Who                     What
% ----              ---                     ----
% 2008/08/07        Landon Urquhart         Function created
% 2008/08/08        Rodrigo Leandro         Change in the file name that is
%                                           returned -> return full path
% 2008/08/08        Rodrigo Leandro         Differentiate between M,Y
%                                           as string, and M,Y as number
% 2008/08/08        Rodrigo Leandro         Avoided continuous loop when
%                                           year <=1999 is reached
% 2008/08/08        Rodrigo Leandro         Unzip file and handle uncompressed files in the local folder.
%
%
% ==========================================
% Copyright 2008 University of New Brunswick
% ==========================================


%accessing directory on CODE ftp server
fprintf(1,'   Logging into CODE ftp server...\n');
cdeftp=ftp('ftp.unibe.ch');
dirstr1=['aiub/CODE'];
cd(cdeftp,dirstr1);

while 1
    
    %====================================================
    % Avoid continuous loop - Inserted by RFL on 20080808
    %----------------------------------------------------
    if Y_num <= 1999
        fprintf(1,'      Sorry, not possible to download requested file.\n');
        p1c1_file_name='';
        close(cdeftp);
        return;
    end
    %====================================================

    Y = num2str(Y_num);
    M = num2str(M_num);
    if size(M,2)<2
        M=['0',M];
    end
    
    %move to year directory
    cd(cdeftp,Y);

    % Creating file names
    p1c1_file_name=['P1C1' Y(3:4) M '.DCB.Z'];
    
    % Check for local file
    % local_P1C1bias_file=dir(p1c1_file_name); Commented by RFL on 20080808
    local_P1C1bias_file=dir(fullfile(path,p1c1_file_name(1:end-2))); % Inseted by RFL on 20080808 - handle unziped local files
    
    % if it is there then cancel download
    if ~isempty(local_P1C1bias_file)
        fprintf(1,'      Local file matches latest file...\n');
        fprintf(1,'      Download cancelled...\n');
        p1c1_file_name=local_P1C1bias_file.name;
        close(cdeftp);
        return;
    end

    % Downloading files
    fprintf(1,'      Trying CODE Files for year: %s month: %s...\n',Y,M);
    nf=dir(cdeftp,p1c1_file_name);
    if ~isempty(nf)
        file=mget(cdeftp,p1c1_file_name,path);
        fprintf(1,'      One file downloaded.\n');
        %p1c1_file_name=file{1,1}(25:end); Commented by RFL on 20080808
        p1c1_file_name=file{1,1};  % Inserted by RFL on 20080808 - name returned was not complete
                                   %   now p1c1_file_name receives the name
                                   %   with full path
        p1c1_file_name = gunzip( p1c1_file_name, path, pathexe ); % Inserted by RFL on 20080808
        delete([p1c1_file_name '.Z']); % RFL 200808 - Cleanup -> delete zipped file
        close(cdeftp);
        return;  
    else
        %step back one month
        M_num = str2num(M)-1;
        if M_num == 0
            M_num = M_num + 12;
            Y_num = str2num(Y)-1;
        end
    end
    
    %step back to origional directory
    cd(cdeftp,'..');
end
