function whotptsd(otptsd,gapsv)
%
% Function whotptsd
% =================
%
%       Writes the header fo the standard dev. ep. by ep. output file
%
% Sintax
% ======
%
%       whotptsd(otptp)
%
% Input
% =====
%
%       gapsv  -> string with GAPS name and version
%       otptsd -> file identifier
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

fprintf(otptsd,'%% %s\n',gapsv);
fprintf(otptsd,'%% Copyright 2009 University of New Brunswick\n');
fprintf(otptsd,'%%\n');
fprintf(otptsd,'%%YEAR  MTH DAY HOU MIN SEC GPSSEC LAT            LON            HEI            X              Y              Z              NAD\n');
fprintf(otptsd,'%%                                 m              m              m              m              m              m              m\n');          
fprintf(otptsd,'%%----  --  --  --  --  --  ------ -------------- -------------- -------------- -------------- -------------- -------------- --------------\n');