function jmp=updtcj(obuf,obs,cst,jmp,jp,sp3,rc)
%
% Function updtcj
% ===============
%
%       Update the vector of clock jump corrections
%       Currently the correction are being computed using the precise
%       orbits. What has to be implemented in the future is the option of
%       computing the correction based on observation series. In this case,
%       in case we have filled buffer for the prn, corrections are computed
%       from obs., otherwise from orbits.
%       In case there is no obs. for the current prn in the obs. buffer, 
%       there is no update. It means it is the first observation of the 
%       series, so it shouldn't receive a correction. 
%
% Sintaxe
% =======
%         jmp=updtcj(obuf,obs,poob,cst,jmp,jp,sp3,rc)
%
% INPUT
% =====
%
%       obs -> nsxno matrix containing observations (same order as stated 
%              in the header)
%              ns -> # of satellites
%              no -> # of observables
%              obs(:,1) -> GPS Time (sow)
%              obs(:,2) -> Satellite PRN
%              obs(:,3:end) -> Observables
%
%       obuf -> observation buffer
%               obuf.P1(ep,prn) -> P1 buffer
%               obuf.P2(ep,prn) -> P2 buffer
%               obuf.L1(ep,prn) -> L1 buffer
%               obuf.L2(ep,prn) -> L2 buffer
%               ep=1:5
%               prn=1:31
%
%       cst -> structure containing constants:
%              cst.c -> speed of light (m/s)
%              cst.f1 -> L1 frequency (Hz)
%              cst.l1 -> L1 wavelength (m)
%              cst.f2 -> L2 frequency (Hz)
%              cst.l2 -> L2 wavelength (m)
%
%       jmp -> nx1 vector containing Clock Jump Corrections (m)
%
%       jp -> value of the clock jump (m)
%
%       sp3 -> structure containing orbits
%
%       rc -> 3x1 vector with receiver XYZ coordinates (m)
%
% OUTPUT
% ======
%
%       jmp -> updated nx1 vector containing Clock Jump Corrections
%
% CALLS
% =====
%
%
% CREATED/MODIFIED
% ================
% When          Who                  What
% ----          ---                  ----
% 2006/06/15    Rodrigo Leandro      Function created
%
% COMMENTS
% ========
%  No comments
%
% ==============================
% Copyright 2006 Rodrigo Leandro
% ==============================

%--------------------------------------
%Test each one of the 40 possible PRN's
for prn=1:31 
    
    %------------------------------------
    % Is there current obs. for this prn?
    if isobs4prn(obs,prn) %In case there is obs. for this prn

        %-------------------------------------------------
        % Is there observation in the buffer for this prn?
        if sum(isnan(obuf.L1(:,1)))>0 %Buffer has observations
        
            %----------------------------------------------
            % Compute time tag for this observations in SOD
            t=obs(obs(:,2)==prn,1);
            sod=mod(t,86400);
            %----------------------------------------------

            %--------------------------------
            % Compute range rate for this prn
            rr=comrr(sp3,prn,sod,rc);
            %--------------------------------

            %------------------------------
            % Compute jump value in seconds
            jps=jp/cst.c;
            %------------------------------

            %---------------------------------------------------
            % Compute and assign correction to correction vector
            jmp(prn)=jmp(prn)+jps*rr;
            %---------------------------------------------------
            
        end % if sum(isnan(obuf.L1(:,1)))>0
        %-------------------------------------------------
                
    end %if (sum(obs(:,2)==prn))
    %------------------------------------

end %for prn=1:31
%--------------------------------------