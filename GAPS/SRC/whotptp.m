function whotptp(otptp,gapsv)
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

fprintf(otptp,'%% %s\n',gapsv);
fprintf(otptp,'%% Copyright 2009 University of New Brunswick\n');
fprintf(otptp,'%%\n');
fprintf(otptp,'%%YEAR  MTH DAY HOU MIN SEC GPSSEC  LAT             LON             HEI          DLAT           DLON           DHEI           X              Y              Z              DX             DY             DZ             NAD     DNAD     CLOCK          APRIORI HYD    HZG NS      HZG EW\n');
fprintf(otptp,'%%                                  sggg.mmsssssss  sggg.mmsssssss  m            m              m              m              m              m              m              m              m              m              m       m        m              m              m           m\n');          
fprintf(otptp,'%%----  --  --  --  --  --  ------  --------------  --------------  -----------  -------------  -------------  -------------  ------------   -------------  -------------  -------------  -------------  -------------  ------  -------  -------------- -------------  ----------- ---------\n');