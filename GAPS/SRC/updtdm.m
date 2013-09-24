function A=updtdm(A,recxyz,satxyz,gmtrng,nmf,df_dhzg)
%
% Function updtdm
% ===============
%
%       Updates design matrix for adjustment, using RLPPP standards
%
% Sintax
% ======
%
%       A=updtdm(A,recxyz,satxyz,gmtrng,nmf)
%
% Input
% =====
%
%       A -> current design matrix
%       recxyz -> 3x1 vector with receiver XYZ corrdinates (m)
%       satxyz -> 3x1 vector with satellite XYZ corrdinates (m)
%       gmtrng -> geometric range (m)
%       nmf -> 2x1 vector with Niell mapping functions
%
% Output
% ======
%
%       A -> updated design matrix
%
% Created/Modified
% ================
%
% When              Who                     What
% ----              ---                     ----
% 2006/06/21        Rodrigo Leandro         Function created
%
%
% ==============================
% Copyright 2006 Rodrigo Leandro
% ==============================
npar=7;
%           (Xs - Xr)
% df_dx= -  ---------
%               r
df_dx=-(satxyz(1,1)-recxyz(1,1))/gmtrng;

%           (Ys - Yr)
% df_dy= -  ---------
%               r
df_dy=-(satxyz(2,1)-recxyz(2,1))/gmtrng;

%           (Zs - Zr)
% df_dz= -  ---------
%               r
df_dz=-(satxyz(3,1)-recxyz(3,1))/gmtrng;

% df_dc = derivative for clock -> using 1 to compute clock error in m
df_dc=1;

% df_dt = derivative for residual troposphere delay -> non hydrostatic
%         mapping function
df_dt=nmf(2,1);

% df_dNS = derivative for NS horizontal gradient  ->
df_dNS=df_dhzg(1);

% df_dEW = derivative for EW horizontal gradient ->
df_dEW=df_dhzg(2);

% df_dn = derivative for ambiguity -> using 1 to compute ambiguity in
%         metric units
df_dn=1;

partials=[df_dx df_dy df_dz df_dc df_dt df_dNS df_dEW;
          df_dx df_dy df_dz df_dc df_dt df_dNS df_dEW];

A(end+1:end+2,1:npar)=partials(:,1:npar);

A(end,end+1)=df_dn;
