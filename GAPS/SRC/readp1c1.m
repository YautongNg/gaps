function bias_vector=readp1c1(p1c1_file_name,path)
% Function readP1C1
% ================
%
%   Reads p1c1biases file and puts all information in 40x1 vector where the
%   line number is the PRN.
%
% Sintaxe
% =======
%
%       bias_vector=readp1c1(p1c1_file_name)
%
% Input                        
% =====                        
%
%       p1c1_file_name -> '.dcb' file containing the pc1c1 biases for GPS
%       satellites.
%       
% Output
% ======
%
%       bias_vector -> 1x40 vector containing the biases associated with
%       each PRN where PRN is the line number
%
% Created/Modified
% ================
%
% When              Who                     What
% ----              ---                     ----
% 2008/08/11        Landon Urquhart         Function created
% 2008/08/11        Rodrigo Leandro         Output changed from 40x1 to 1x40
%                                           vector
%
%
% ==========================================
% Copyright 2008 University of New Brunswick
% ==========================================

p1c1_file_name = fullfile(path,p1c1_file_name);
% Opening File
if ( exist(p1c1_file_name,'file') ~= 2 )
    error (sprintf('File %s does not exist.', p1c1_file_name));
end
[fp1c1, temp_msg] = fopen (p1c1_file_name, 'rt');
if (fp1c1 == -1)
    error (sprintf('Couldn''t open file %s. %s', p1c1_file_name, temp_msg));
end

% Creating/Reseting bias vector matrix
bias_vector=zeros(1,40); 

while feof(fp1c1) == 0
    l = fgetl(fp1c1); 
    if ~isempty(l);
        if isequal(strtrim(l(1)),'G') 
            prn=str2num(strtrim(l(2:3)));
            % 'G' means line related to a GPS Satellite
            bias_vector(1 , prn)=str2num(strtrim(l(27:35)));
        end
    end
end