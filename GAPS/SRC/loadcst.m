function cst=loadcst()
%
% Function ladcst
% ===============
%       Load constants values needed for GPS data processing
%
% SINTAXE
% =======
%       cst=loadcst()
%
% INPUT
% =====
%       No input.
%
% OUTPUT
% ======
%       cst -> structure containing constants:
%           cst.c -> speed of light (m/s)
%           cst.f1 -> L1/E1 frequency (Hz)
%           cst.l1 -> L1/E1 wavelength (m)
%           cst.f2 -> L2 frequency (Hz)
%           cst.l2 -> L2 wavelength (m)
%           cst.f5 -> L5/E5a frequency (Hz)
%           cst.l5 -> L5/E5a wavelength (m)
%           cst.l3 -> Ion-free wavelength GPS(m)
%           cst.if1 -> Ion-free combination coefficient for GPS freq. L1*
%           cst.if2 -> Ion-free combination coefficient for GPS freq. L2*
%           cst.l3e -> Ion-free wavelength Galileo(m)
%           cst.ie1 -> Ion-free combination coefficient for Galileo freq. E1*
%           cst.ie5 -> Ion-free combination coefficient for Galileo freq. E5a*
%           (*) to be used in metric units
%
% CREATED/MODIFIED
% ================
% When          Who                     What
% ----          ---                     ----
% 2006/06/06    Rodrigo Leandro         Function created
% 2009/10/09    Landon Urquhart         Modified to include Galileo Frequencies
% 2009/12/13    Landon Urquhart         Changed constants to vector format
%                                       to support various frequencies.
%
%
% COPYRIGHT 2006, Rodrigo Leandro

%cst.c -> speed of light (m/s)
cst.c=299792458;
%cst.f1 -> L1 frequency (Hz)
cst.f1=[repmat(1575.42e6,40,1);repmat(NaN,40,1);repmat(1575.42e6,40,1)];
%cst.l1 -> L1 wavelength (m)
cst.l1=cst.c./cst.f1;
%cst.f2 -> L2 frequency (Hz)
cst.f2=[repmat(1227.60e6,40,1);repmat(NaN,40,1);repmat(1176.45e6,40,1)];
%cst.l2 -> L2 wavelength (m)
cst.l2=cst.c./cst.f2;


%ionosphere Free combination GPS L1/L2

%cst.if1 -> Ion-free combination coefficient for freq. L1
%           to be used in metric units
cst.if1= ( cst.f1.^2 )./ ( cst.f1.^2 - cst.f2.^2 );
%cst.if2 -> Ion-free combination coefficient for freq. L2
%           to be used in metric units
cst.if2= ( cst.f2.^2 )./ ( cst.f1.^2 - cst.f2.^2 );

%cst.l3 -> Ion-free wavelength (m)
cst.l3=(cst.if1.*cst.l1-cst.if2.*cst.l2);
