function [prn sysid]=svid2sysid(sv)
%
%  Function svid2sysid
%
%  This function converts from the internal svid used in GAPS to the system
%  identification used in GT 
%
%
%  Sintaxe: [prn sysid]=sysid2svid(sv)
%

%
%  INPUT
%         sv - nx1 vector containing the unambiguous satellite id used in
%         GAPS.
%
%                      GPS: 0-40
%                  GLONASS: 41-80
%                  GALILEO: 81-120
%                     SBAS: 121+
%
%  OUTPUT
%         sysid - nx1 vector containing the system identification
%                  0 = GPS
%                  1 = GLONASS
%                  2 = GALILEO
%                  3 = SBAS
%         prn - nx1 vector containing the satellite PRN in the GT format
%
% CREATED/MODIFIED
%
% Date         Who                 What
% ----         ---                 ----
% 2009/10/05   Landon Urquhart     Function Created
%
%
%
%
prn=zeros(size(sv));
sysid=zeros(size(sv));
prn(sv<=40)=sv(sv<=40);
sysid(sv<=40)=0;
prn(sv>40 & sv<=80)=sv(sv>40 & sv<=80)-40;
sysid(sv>40 & sv<=80)=1;
prn(sv>80 & sv<=120)=sv(sv>80 & sv<=120)-80;
sysid(sv>80 & sv<=120)=2;
prn(sv>120)=sv(sv>120)-1;
sysid(sv>120)=3;
%! test !
%{
obs=[1546	322482	3	120	39668633.68	0	0	0	0	208460107.5	0	0 -714.038	0	38	0	0;
      1546	322482	3	138	39111647.06	0	39111623.57	0	0	205533103.1	0	153482513.2	-710.282	0	43	0	42;
      1546	322482	3	135	40791962.38	0	40791945.9	0	0	214363220.7	0	160076430.3	-530.446	0	39	0	38;
      1546	322482	0	3	19931868.72	0	0	19931868.01	19931874.05	104742682.8	81617676.11	0	-529.393	197.521	52	43	0;
      1546	322482	0	25	21084601.5	0	0	21084600.81	21084606.57	110800333.5	86337923.97	0	1073.669	836.618	51	42	0;
      1546	322482	0	31	25267591.61	25267600.26	0	25267590.89	25267597.65	132782093.2	103466563.3	0	-4074.881	-3175.288	40	22	0;
      1546	322482	2	2	25587675.97	0	25587677.55	0	0	134464149.9	0	100411537.4	2321.935	0	44	0	40;
      1546	322482	0	5	25718087.62	25718097.17	0	0	0	135149482.3	0	0	1733.914	0	29	0	0];
 sv=[121;139;136;3;25;31;82;5];
 [prn sysid]=svid2sysid(sv);
 assert(all(prn==obs(:,4)))
 assert(all(sysid==obs(:,3)))
 [newsv]=sysid2svid(sysid,prn);% test going opposite way
 assert(all(newsv==sv))
%}