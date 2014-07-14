function clk=readclk(clockfilename)
%
% Function readclk
%
%  Sintaxe: clk=readclk(clockfilename)
%
% Reads precise clock file and stores all the information in a matrix
%
% clk=Nx3 matrix (N=total number of records)
%
%  clk(:,1) = time of day (seconds)
%  clk(:,2) = PRN
%  clk(:,3) = Clock offset (seconds)
%
% Created by Rodrigo Leandro
% February of 2006

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Opening File
% originally witten by F.Nievinski
% addapted by RL from sub read_rinex_obs()
if ( exist(clockfilename,'file') ~= 2 )
    error (sprintf('File %s does not exist.', clockfilename));
end
[fclk, temp_msg] = fopen (clockfilename, 'rt');
if (fclk == -1)
    error (sprintf('Couldn''t open file %s. %s', clockfilename, temp_msg));
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Creating/Reseting clk matrix
clk=zeros(40*24*60,3);  

nl=0; %Number of lines in

while feof(fclk) == 0
    l = fgetl(fclk); 
    if isequal(strtrim(l(1:4)),'AS G') 
    % 'AS G' means line related to a GPS Satellite
        nl=nl+1;
        prn=str2double(l(5:7)); % Sat. PRN
        h=str2double(l(19:21)); % Hour
        m=str2double(l(22:24)); % Minute
        s=str2double(l(25:34)); % Seconds
        t=s+(m*60)+(h*3600); % SOD - Sec. of day
        cb=str2double(l(41:59)); % Clock Bias
        clk(nl,1)=t;
        clk(nl,2)=prn;
        clk(nl,3)=cb;
    end
end

clk=clk(1:nl,:);

fclose(fclk);