function A=updtdmi(prnlist,cst,ipp,recllh,elvlist)
%
% Function updtdm12
% =================
%
%       Updates the design matrix for IONO delays computation
%
% Sintax
% ======
%
%       A=updtdmi(prnlist,cst,ipp,recllh,elvlist)
%
% Input
% =====
%
%       A -> Design matrix
%       prnlist -> list of PRN
%       cst -> Constants structure
%       ipp -> list of ionospheric piercing point coordinates (rad)
%       recllh -> receiver geodetic coordinates
%       elvlist -> list of elevation angles (rad)
%
% Output
% ======
%
%       A -> Design matrix
%
%
% Design matrix organization:
% ===========================
%
%                       Iono delays                     Ambiguities               
%            ---------------------------------      -------------------  
%            A0       A1           A2               sat1 sat2 ...  satn   
%            I        I            I                amb1 amb1      amb1   
% sat1 L     (1-g)/m  (1-g)dlat/m  (1-g)dlon/m      1    0    ...  0                 
% sat1 P     (g-1)/m  (g-1)dlat/m  (g-1)dlon/m      0    0    ...  0                      
% sat2 L     (1-g)/m  (1-g)dlat/m  (1-g)dlon/m      0    1    ...  0                 
% sat2 P     (g-1)/m  (g-1)dlat/m  (g-1)dlon/m      0    0    ...  0                         
% ...        ...      ...          ...              ...  ...  ...  ...                   
% satn L     (1-g)/m  (1-g)dlat/m  (1-g)dlon/m      0    0    ...  1                    
% satn P     (g-1)/m  (g-1)dlat/m  (g-1)dlon/m      0    0    ...  0                       
% 
%
% Created/modified
% ================
%
% When          Who                     What
% ----          ---                     ----
% 2006/08/01    Rodrigo Leandro         Function updtdm12 created
% 2007/01/15    Rodrigo Leandro         Function created based on
%                                       updtdm12 function
%
%
% =================================================================
% Copyritght 2006-2007 Rodrigo Leandro, University of New Brunswick
% =================================================================

%=======================================================================
% Derivatives for IONO delay parameters (in m or m/rad for L1 frequency)
%-----------------------------------------------------------------------
% Using bilinear model + mapping function
for sat=1:size(prnlist,1)

    % row number for current prn
    nl=(sat-1)*2;

    % get PRN
    prn=prnlist(sat);

    % get elevation angle
    elevang=elvlist(sat);

    % compute mapping function
    R=6378136.3; % Mean radius of the Earth
    Sh=350000; % Shell height
    m=sqrt(1-(R*cos(elevang)/(R+Sh))^2); % Mapping function

    % compute delta_lat and delta_long in radians
    ippll=ipp{prn}; % get IPP lat and long
    dlat=ippll(1,1)-recllh(1,1);
    dlon=ippll(2,1)-recllh(2,1);

    % compute gamma constant (for L2!)
    gamma=(cst.f1(prn)^2)/(cst.f2(prn)^2);

    % assign values
    % Carrier-phase
    A(nl+1,1)=(1-gamma)/m;
    A(nl+1,2)=(1-gamma)*dlat/m;
    A(nl+1,3)=(1-gamma)*dlon/m;
    % Code
    A(nl+2,1)=(gamma-1)/m;
    A(nl+2,2)=(gamma-1)*dlat/m;
    A(nl+2,3)=(gamma-1)*dlon/m;

end
%=======================================================================


%============================
% Derivatives for ambiguities
%----------------------------
for sat=1:size(prnlist,1)
    % row number for current prn
    nl=(sat-1)*2;
    % column number for current prn
    nc=3+(sat-1)*1;
    A(nl+1,nc+1)=1;
end
%============================


