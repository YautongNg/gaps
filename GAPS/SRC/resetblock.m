function [pfn npf cx0 cxi0 cx12 obuf pwu]= ...
                    resetblock(pfn,npf,cx0,cxi0,cx12,obuf,prn,pwu)
%
% Function resetblock
% ===================
%
%   This function resets the following controls (for a given prn):
%
%       - Observation buffer
%       - Pseudorange smoothing filter
%       - Ambiguity
%       - Clock jump
%
% SINTAXE
% =======
%       [pfn npf cx0 cx12 jmp obuf pwu]= ...
%       resetblock(pfn,npf,cx0,cx12,jmp,obuf,prn,pwu)
%
% INPUT
% =====
%         pfn - nx1 vector containing ambiguity term for pseudorange 
%               smoothing filter.
%         npf - nx1 vector containing number of used observations in the 
%               pseudorange smoothing filter.
%         cx0 - 36x36 matrix with parameter constraints
%         cx12 - 1x31 cell array with L1&L2 ambiguity constraints
%         jmp - nx1 vector containing Clock Jump Corrections.
%         obuf - structure containing observation buffer
%                obuf.P1(ep,prn) -> P1 buffer
%                obuf.P2(ep,prn) -> P2 buffer
%                obuf.L1(ep,prn) -> L1 buffer
%                obuf.L2(ep,prn) -> L2 buffer
%         prn -> PRN of satellite which needs to be reset
%         pwu -> nx1 vector with phase wind-up corrections
%
% OUTPUT
% ======
%
%       Updated: pfn npf cx0 cx12 jmp obuf
%
% CREATED/MODIFIED
% ================
%
% When          Who                     What
% ----          ---                     ----
% 2006/06/06    Rodrigo Leandro         Function created
% 2006/06/28    Rodrigo Leandro         Change from amb and pam to cx0
% 2006/06/30    Rodrigo Leandro         Added phase wind-up buffer
% 2006/06/24    Rodrigo Leandro         cx12 added
% 2010/01/25    Landon Urquhart         npar to accept varying number of
%                                       parameters
%
% COMMENTS
% ========
%
%       No comments!
%
%
% ==============================
% Copyright 2006 Rodrigo Leandro
% ==============================
npar=7;
% Reset buffer
obuf.P1(:,prn)=NaN; % P1 buffer
obuf.P2(:,prn)=NaN; % P2 buffer
obuf.L1(:,prn)=NaN; % L1 buffer
obuf.L2(:,prn)=NaN; % L2 buffer

% Reset Pseudorange smoothing filter
pfn(prn)=0;
npf(prn)=0;

% Reset ambiguity
cx0(prn+npar,:)=0;
cx0(:,prn+npar)=0;
cx0(prn+npar,prn+npar)=1e10;

% Reset IONO model ambiguity
cxi0(prn+3,:)=0;
cxi0(:,prn+3)=0;
cxi0(prn+3,prn+3)=1e10;

% Reset phase wind-up correction
pwu(prn)=NaN;

% % Reset L1&L2 ambiguity constraints
% pL1=(prn-1)*2+1;
% pL2=(prn-1)*2+2;
% cx12(pL1,:)=0;
% cx12(pL2,:)=0;
% cx12(:,pL1)=0;
% cx12(:,pL2)=0;
% cx12(pL1,pL1)=1e10;
% cx12(pL2,pL2)=1e10;
% cx12(pL1,pL2)=0;
% cx12(pL2,pL1)=0;
