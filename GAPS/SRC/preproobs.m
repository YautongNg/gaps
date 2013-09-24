function [hobs fiobs]=preproobs(obsname)
%
% Function preproobs
% ==================
% This funtion Opens and prepare the observation file to be read epoch by
% epoch during data processing. It calls function getobsheader to read the 
% file header.
%
% SINTAXE
% =======
%          [hobs fiobs]=preproobs(obsname)
%
% Created by Rodrigo Leandro
% May of 2006

    %%%%%%%%%%%%%%%%
    % open file for reading
    %(witten by F. Nievinski - addapted from 'read_rinex_obs()')
    %if ( exist(obsname,'file') ~= 2 )
    %    error (sprintf('File %s does not exist.', obsname));
    %end
    [fiobs, temp_msg] = fopen (obsname, 'rt');
    %if (fiobs == -1)
    %    error (sprintf('Couldn''t open file %s. %s', obsname, temp_msg));
    %end
    %clear temp_msg
    %%%%%%%%%%%%%%%%

    hobs=getobsheader(fiobs);