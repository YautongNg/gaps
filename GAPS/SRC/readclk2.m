function clk=readclk2(clockfilename)
%
% Function readclk
% ================
%       Reads precise clock file and stores all the information in a matrix
%
% Sintaxe
% =======
%           clk=readclk(clockfilename)
%
% INPUT
% =====
%       clockfilename -> string, file name
%
% OUTPUT
% ======
%       clk=Nx3 matrix (N=total number of records)
%           clk(:,1) = time of day (seconds)
%           clk(:,2) = PRN
%           clk(:,3) = Clock offset (seconds)
%
% CREATED/MODIFIED
% ================
% When          Who                 What
% ----          ---                 ----
% 2006/02/01    Rodrigo Leandro     Original function readclk was created
% 2006/06/06    Rodrigo Leandro     Function readclk2 was created to
%                                   improve processing time. Original
%                                   function is kept. THis version runs
%                                   approx. 10 times faster than the
%                                   original one (processing time <3s).
%                                           
%
% ==============================
% Copyright 2006 Rodrigo Leandro
% ==============================

%----------
% Open file
fclk = fopen (clockfilename, 'rt');
%----------

%------------
% Read header
endheader=0; % end of header control
while endheader==0
    l = fgetl(fclk); % read next line
    if isequal(strtrim(l(61:73)),'END OF HEADER') % verify end of header 
        endheader=1; % if END OF HEADER, set EOH control
    end
end
%------------

%----------
% Read data
clk1=(fread(fclk,'*char')); % as character
clk1=sscanf(clk1','%7c%f%f%f%f%f%f%f%f%f\n',[16 inf]); 
                            % put in double matix format [16xnsolutions]
%----------

%------------------------------------
% Isolate GPS Satellite clock offsets
% The string 'AS G' at the begining of a line indicates that the solution
% of the line is for a GPS satellite. The string 'AS G' is [65 83 32 71] 
% in ASCII code
clk1=clk1(:,clk1(1,:)==65&clk1(2,:)==83&clk1(4,:)==71)';
%------------------------------------

%-----------------------------------------------------------
% Create output matrix with time (SOD), PRN and clock offset
%time (SOD):
clk(:,1)=(clk1(:,11)*3600)+(clk1(:,12)*60)+clk1(:,13);
%PRN:
% The ASCII code for a number is (number+48)
% So, PRN = (N1-48)*10 + (N2-48) = N1*10 + N2 -528
% N1 and N2 are the number of PRN, e.g. prn26 -> N1=2;N2=6
clk(:,2)=(clk1(:,5)*10)+clk1(:,6)-528;
%clock offset:
clk(:,3)=clk1(:,15);
%-----------------------------------------------------------

%-----------------
% Close clock file
fclose(fclk);
%-----------------