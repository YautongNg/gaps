function whotptr(otptr,gapsv)
%
% Function whotptr
% ================
%
%       Writes the header fo the residuals ep. by ep. output file
%
% Sintax
% ======
%
%       whotptr(otptr)
%
% Input
% =====
%
%       gapsv -> string with GAPS name and version
%       otptr -> file identifier
%
% Output
% ======
%
%       No output!
%
% Created/Modified
% ================
%
% When          Who                     What
% ----          ---                     ----
% 2006/07/12    Rodrigo Leandro         Function created
%
%
% ==============================
% Copyright 2006 Rodrigo Leandro
% ==============================

fprintf(otptr,'%% %s\n',gapsv);
fprintf(otptr,'%% Copyright 2009 University of New Brunswick\n');
fprintf(otptr,'%%\n');
fprintf(otptr,'%%TIME  PRN Pseudorange    Carrier-phase  Elevation      Azimuth        Ambiguity\n');
fprintf(otptr,'%%          residuals      residuals      angle\n');
fprintf(otptr,'%%sod                    m              m            deg            deg             m \n');          
fprintf(otptr,'%%----- --- -------------- -------------- -------------- -------------- --------------\n');