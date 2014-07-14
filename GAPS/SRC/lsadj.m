function [delta prnlist elvlist cx rc rp]= ...
    lsadj(A,P,w,cx,cprt,prrt,prnlist,elvlist,recxyz,epcount,irecxyz)
%
% Function lsadj
% ==============
%
%       Performs the least squares adjustment
%
% Sintax
% ======
%
%       [delta N apvf]=lsadj(A,P,w,cx,prnlist)
%
% Input
% =====
%
%       A -> design matrix
%       P -> weight matrix
%       w -> misclousure vector
%       px -> constraint matrix
%
% Output
% ======
%
%       delta -> parameters update vector
%       N -> normal matrix
%       apvf -> a posteriori variance factor
%
% Created/Modified
% ================
%
% When              Who                     What
% ----              ---                     ----
% 2006/06/22        Rodrigo Leandro         Function created
% 2006/06/26        Rodrigo Leandro         Added apvf
%
%
% Comments
% ========
%
%       Residuals control to be implemented!!!
%
% ==============================
% Copyright 2006 Rodrigo Leandro
% ==============================
npar=7;
delta=zeros(npar,1);
rc=[];
rp=[];
cond=0;
while cond==0;
    if isempty(A)
        delta=zeros(npar,1);
        cond=1;
        rc=[];
        rp=[];
    else
        %=======================================
        % This block avoids badscaling of the Cx 
        %idx=(cx==1e10);
        %cx1=cx;
        %cx1(idx)=1;
        %icx=inv(cx1);
        %icx(idx)=1e-10;
        icx=inv(cx);
        %=======================================
        N=A'*P*A+icx;
        u=A'*P*w;
        delta=N\u;
        
        r=A*delta-w;
        apvf=r'*P*r/(size(A,1)-size(A,2));
        % Separate between carrier-phase and pseudorange
        % *c -> carrier-phase
        % *p -> pseudorange
        Ac=A((sum(A'~=0)'==npar+1),:);
        wc=w((sum(A'~=0)'==npar+1));
        Pc=P((sum(A'~=0)'==npar+1),(sum(A'~=0)'==npar+1));
        rc=r((sum(A'~=0)'==npar+1));
        Ap=A((sum(A'~=0)'==npar),:);
        wp=w((sum(A'~=0)'==npar));
        Pp=P((sum(A'~=0)'==npar),(sum(A'~=0)'==npar));
        rp=r((sum(A'~=0)'==npar));
        % Check for carrier residuals
        if (irecxyz==0)~=zeros(3,1) & epcount==1
            delta(npar,1)=0;
            cond=1;
        else
            if max(abs(rp))>prrt
                % Get indexes of residual
                l=(abs(rp)==max(abs(rp)));
                c=[zeros(npar,1);l];
                % Eliminate row and column
                Ac=Ac(l==0,c==0);
                wc=wc(l==0);
                Pc=Pc(l==0,l==0);
                Ap=Ap(l==0,c==0);
                wp=wp(l==0);
                Pp=Pp(l==0,l==0);
                cx=cx(c==0,c==0);
                prnlist=prnlist(l==0);
                elvlist=elvlist(l==0);
                % Rebuild Matrices
                A=[Ac ; Ap];
                w=[wc ; wp];
                P=[Pc zeros(size(Pc)) ; zeros(size(Pc)) Pp];
            elseif max(abs(rc))>cprt
                % Get indexes of residual
                l=(abs(rc)==max(abs(rc)));
                c=[zeros(npar,1);l];
                % Eliminate row and column
                Ac=Ac(l==0,c==0);
                wc=wc(l==0);
                Pc=Pc(l==0,l==0);
                Ap=Ap(l==0,c==0);
                wp=wp(l==0);
                Pp=Pp(l==0,l==0);
                cx=cx(c==0,c==0);
                prnlist=prnlist(l==0);
                elvlist=elvlist(l==0);
                % Rebuild Matrices
                A=[Ac ; Ap];
                w=[wc ; wp];
                P=[Pc zeros(size(Pc)) ; zeros(size(Pc)) Pp];
            else
                cx=inv(N);
                cond=1;
            end % if max(abs(rc))>cprt
        end
    end % if isempty(A)
end %while cond==0;    