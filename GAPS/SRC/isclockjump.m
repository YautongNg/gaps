function jmp=isclockjump(obuf,obs,poob,jlmt,djlmt,cst,otptu)
%
% Function isclockjump
% ====================
%
%  Determine if the current epoch has the effect of a clock jump or not
%  It uses a "geometry free" comparison between carrier phase measurements
%   in both frequencies, as well as the measurements at each individual
%   frequency.
%
%  A 2nd order polynomial is adjusted to the buffer 5 observations at each
%   frequency.
%  The diference btw the polynomial extrapolation is compared with
%   the current observation. 
%  If difference is greater than imposed limit and the differences are 
%   similar for both frequencies the observation is flagged as potential
%   clock jump.
%  If all satellites are flagged than there is a clock jump to be accounted
%   for.
%
% INPUT
% =====
%       obuf -> observations buffer
%       obs -> current observations
%       poob -> observables position
%       jlmt -> jump limit (m)
%       djlmt -> differential jump limit (m)
%       cst -> structure with constants
%
% OUTPUT
% ======
%       jmp ->   0, NOT a clock jump
%               ~0, clock jump value (m)
%
% CREATED/MODIFIED
% ================
% When          Who                     What
% ----          ---                     ----
% 2006/06/06    Rodrigo Leandro         Function created
% 2006/06/20    Rodrigo Leandro         Added control for curve fitting to
%                                       avoid usage of series with clock 
%                                       jumps in the analisys.
%
%
% ==============================
% Copyright 2006 Rodrigo Leandro
% ==============================

%-------------------------------------------------------------------
% Create matrices with carrier phase measurements in meters (buffer)
b1=cst.l1*obuf.L1;
b2=cst.l2*obuf.L2;
%-------------------------------------------------------------------

%-------------------------------------------------------------------------
% Create vectors with carrier phase measurements in meters (current epoch)
c1=cst.l1*obs(:,poob.L1);
c2=cst.l2*obs(:,poob.L2);
%-------------------------------------------------------------------------

%-----------------------------------------------------
% Perform test for each one of the observed satellites
prn=obs(:,2); % List of observed prn's
nprn=size(prn,1); % Number of satellites observed
nefprn=0; % Number of effective prn's
%            (buffer must be filled to prn to be usefull)
flg=zeros(nprn,1);
e1=zeros(nprn,1);
e2=zeros(nprn,1);
for i=1:nprn
    
    %---------------------------------------------
    % Check if there are observations for this prn
    if isobs4prn(obs,prn(i))
    
        %--------------------------
        % Check if buffer is filled
        if sum(isnan(b1(:,prn(i))))==0 % If there is NONE NaN in the vector

            %--------------------------------------------
            % Calibrate polinomials and evaluate it for current epoch
            pol1=polyfitr((1:5)',b1(:,prn(i)),2);
            pol2=polyfitr((1:5)',b2(:,prn(i)),2);
            % Compute rms of the curve fit
            p1p=zeros(5,1);
            p2p=zeros(5,1);
            for ix=1:5
                p1p(ix)=polyvalr(pol1,ix);
                p2p(ix)=polyvalr(pol2,ix);
            end
            rms1=std(p1p-b1(:,prn(i)));
            rms2=std(p2p-b2(:,prn(i)));
            % Check if RMS is under certain value - it means there is no
            % clok jumps in the series
            if rms1<10 && rms2<10
                % Add prn to effective list
                nefprn=nefprn+1;
                % Evaluate polynomials for current epoch
                p1=polyvalr(pol1,6);
                p2=polyvalr(pol2,6);
                % Compute errors for the two frequencies
                e1(nefprn)=p1-c1(i);
                e2(nefprn)=p2-c2(i);
                % Flag:
                if abs(e1(nefprn))>jlmt && abs(e2(nefprn))>jlmt ...
                        && abs(e1(nefprn)-e2(nefprn))<djlmt
                    flg(nefprn,1)=1; % Clock jump!!
                else
                    flg(nefprn,1)=0; % NOT a clock jump!!
                end
            end % if rms1<10 && rms2<10
            %--------------------------------------------

        end % if sum(isnan(b1(:,prn(i))))==0
        %--------------------------
        
    end % if isobs4prn(obs,prn(i))
    %---------------------------------------------
    
end
%-----------------------------------------------------

%---------------------------------------------------------
% Compare all efective satellites and determine clock jump
if sum(flg)==nefprn && nefprn>0
    jmp=mean([e1;e2]);
    fprintf(otptu,'Clock jump detected.\n');
elseif sum(flg)==0
    jmp=0;
else
    jmp=0;
    %error('isclockjump: inconsistency between satellites!!!\n');
end
%---------------------------------------------------------
