function [y dat]=readsp3(file_name)
%
% Function readsp3
%
% Reads sp3 file and put all 15 min information into variable y
%
% Sintaxe:
%               y=readsp3(file_name)
%
% INPUT: file_name -> sp3 file name (string)
% OUTPUT: y -> structure with fields x, y, z and t
%               x satnds for X coordinates
%               y satnds for Y coordinates
%               z satnds for Z coordinates
%               t satnds for Time
%               Each one of the fields is a (N x 96) Matrix (double),
%               where the line number is PRN!! 
%
% Created/Modified
% ================
%
%   DATE        WHO                 WHAT
%   ----        ---                 ----
%   2005/01/06  Rodrigo Leandro     Function created.
%   2006/05/16  Rodrigo Leandro     Add capability of handling sp3 or sp3c
%                                   formats.
%   2006/05/24  Rodrigo Leandro     Preallocate space in memory for
%                                   variables xep, yep, zep and tep.
%   2009/12/13  Landon Urquhart     Support 120 satellites
%   2009/12/15  Landon Urquhart     Correctly index Galileo satellites
%   To Do: correctly idenfity glonass based on Satellite ID.
%
% Rodrigo Leandro
% Copyright 2005




%---------------------------
% 2006/05/16 - RL
% Check format - sp3 or sp3c
fil=fopen(file_name);
for i=1:24
    lin=fgets(fil);
end
if lin(2)=='G'|| 'E'
    fmt=1;
else
    fmt=0;
end
fclose(fil);
%----------------------------

% Read file
fil=fopen(file_name);

lin=fgets(fil);
dat=lin(47:51);
lin=fgets(fil);
interval=str2double(lin(24:38));
num_epochs=24*60*60/interval;
%-------------------------------
% 2006/05/24 - RL
% Preallocationg space in memory
xep=zeros(120,num_epochs);
yep=zeros(120,num_epochs);
zep=zeros(120,num_epochs);
tep=zeros(120,num_epochs);
%-------------------------------

lin=fgets(fil);



%nsat=sscanf(lin,'%*1c   %d   %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d');
%sat1=sscanf(lin,'%*1c   %*d   %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d');
% 2006/05/16 - RL
if fmt==0
    nsat=sscanf(lin,'%*1c   %d   %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d');
    sat1=sscanf(lin,'%*1c   %*d   %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d');
else
    nsat=sscanf(lin,'%*1c   %d   %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d');
    sat1=sscanf(lin,'%*10c%d%*1c%d%*1c%d%*1c%d%*1c%d%*1c%d%*1c%d%*1c%d%*1c%d%*1c%d%*1c%d%*1c%d%*1c%d%*1c%d%*1c%d%*1c%d%*1c%d');
end

lin=fgets(fil);
%sat2=sscanf(lin,'%*1c   %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d');
% 2006/05/16 - RL
if fmt==0
    sat2=sscanf(lin,'%*1c   %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d');
else
    sat2=sscanf(lin,'%*10c%d%*1c%d%*1c%d%*1c%d%*1c%d%*1c%d%*1c%d%*1c%d%*1c%d%*1c%d%*1c%d%*1c%d%*1c%d%*1c%d%*1c%d%*1c%d%*1c%d');
end
sat=[sat1;sat2];
sat(sat>40)=sat(sat>40)-50+80;
for i=1:18
    fgets(fil);
end

for i=1:num_epochs
    fgets(fil);
    for j=1:nsat
        lin=fgets(fil);
        %coord=sscanf(lin,'%*1c %d %f %f %f %f');
        % 2006/05/16 - RL
        if fmt==0
            coord=sscanf(lin,'%*1c %d %f %f %f %f');
        else
            coord=sscanf(lin,'%*2c%d %f %f %f %f %f %f %f %f');
        end
        xep(sat(j,1),i)=coord(2,1)*1000;
        yep(sat(j,1),i)=coord(3,1)*1000;
        zep(sat(j,1),i)=coord(4,1)*1000;
        tep(sat(j,1),i)=coord(5,1);
    end
end

y.x=xep;
y.y=yep;
y.z=zep;
y.t=tep;
fclose(fil);
end
