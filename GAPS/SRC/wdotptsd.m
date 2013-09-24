function wdotptsd(otptsd,cdate,cx,recxyz)
%
% Function wdotptsd
% =================
%
%       Writes data to the standard dev. ep. by ep. output file
%
% Sintax
% ======
%
%       wdotptsd(otptsd,cdate,cx0)
%
% Input
% =====
%
%       otptsd -> file identifier
%       cdate -> current date
%       cx0 -> cov. matrix
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
sd(5)=0;
for i=1:5
    sd(i)=sqrt(cx(i,i));
end
%sdllh=distllh(recxyz,recxyz+sd(1:3)');
sdllh=cxyz2llh(recxyz,cx);
cdate(6,1)=round(cdate(6,1));
fprintf(otptsd,'%5i%4i%4i%4i%4i%4i%8i%15.4f%15.4f%15.4f%15.4f%15.4f%15.4f%15.4f\n',cdate,0,sdllh,sd(1:3),sd(5));