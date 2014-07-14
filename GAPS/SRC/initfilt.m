function [pfn npf amb amb1 amb2 ambi ionop rdcb rdcbvar jmp pwu]=initfilt()
%
%  Function initfilt
%
%  This function initializes the required filters for PPP
%
%  List of Filters:
% 
%       - Pseudorange smoothing filter
%       - Cycle Slip Filter
%       - Ambiguities and their variances
%
%  Sintaxe: [pfn npf amb cam]=initfilt()
%
%  INPUT
%         No inputs!
%
%  OUTPUT
%         pfn - nx1 vector containing ambiguity term for pseudorange 
%               smoothing filter.
%         npf - nx1 vector containing number of used observations in the 
%               pseudorange smoothing filter.
%         amb - nx1 vector containing ion-free ambiguities.
%         amb1 - nx1 vector containing L1 ambiguities;
%         amb2 - nx1 vector containing L2 ambiguities;
%         ambi - nx1 vector containing IONO model ambiguities
%         jmp - nx1 vector containing Clock Jump Corrections.
%         pwu - nx1 vector containing phase wind-up corrections.
%
% CREATED/MODIFIED
%
% Date         Who                 What
% ----         ---                 ----
% 2006/05/17   Rodrigo Leandro     Function Created
% 2006/06/30   Rodrigo Leandro     Added phase wind-up correction
% 2006/07/24   Rodrigo Leandro     amb1 & amb2 added
% 2006/08/02   Rodrigo Leandro     pam deleted
% 2007/01/23   Rodrigo Leandro     ambi added
% 2009/12/13   Landon Urquhart     Added support for 120 PRNs
%
% General Comments: Curretly this function supports prn's up to 120!
%
%
% ==============================
% Copyright 2006 Rodrigo Leandro
% ==============================

pfn=zeros(120,1);
npf=zeros(120,1);
amb=zeros(120,1);
ambi=zeros(120,1);
amb1=zeros(120,1);
amb2=zeros(120,1);
jmp=zeros(120,1);
pwu=nan(120,1);

rdcb=0;
rdcbvar=1e10;

% Initialize IONO model parameters
ionop.a0=0;
ionop.a1=0;
ionop.a2=0;
