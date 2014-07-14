function [pfn npf cx0 cxi0 cx12 obuf pwu]= ...
    slpjmp(obs,pfn,npf,cx0,cxi0,cx12,obuf,poob,cst,cslmt, ...
    jlmt,djlmt,sp3,rc,otptu,pwu)
%
% Function slpjmp
% ===============
%
%  Detects cycle slips and/or clock jumps
%
% SINTAXE
% =======
%         [pfn npf cx0 cx12 jmp obuf pwu]= ...
%    slpjmp(obs,pfn,npf,cx0,cx12,jmp,obuf,poob,cst,cslmt, ...
%    jlmt,djlmt,sp3,rc,otptu,pwu)
%
% INPUT
% =====
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
% OUTPUT
% ======
%
%
% CALLS
% =====
%
%
% CREATED/MODIFIED
% ================
% When          Who                  What
% ----          ---                  ----
% 2006/06/02    Rodrigo Leandro      Function created
% 2006/07/24    Rodrigo Leandro      cx12 added to control
%
% COMMENTS
% ========
%  No comments
%
% ==============================
% Copyright 2006 Rodrigo Leandro
% ==============================


%==========================================================================
% Cycle slip block
%--------------------------------------------------------------------------

%--------------------------------------
%Test each one of the 120 possible PRN's
for iprn=1:size(obs,1)
    
    prn=obs(iprn,2); 
    
    %------------------------------------
    % Is there current obs. for this prn?
    %if isobs4prn(obs,prn) %In case there is obs. for this prn
        
        %-------------------------------------------
        % Is the buffer totally filled for this prn?
        if sum(isnan(obuf.L1(:,prn)))==0 %Buffer is totally filled
            
            %----------------
            %Check Cycle Slip
            if iscycleslip(obuf,obs,poob,prn,cst,cslmt,otptu) 
            %It IS a cycle slip
                
                %-----------
                %Reset Block
                % Reset buffer, ambiguity, clock jmp corr. and
                % pseudorange smoothing filter for current prn
                [pfn npf cx0 cxi0 cx12 obuf pwu]= ...
                    resetblock(pfn,npf,cx0,cxi0,cx12,obuf,prn,pwu);
                %-----------              
                
            end %iscycleslip(obuf,obs,poob,prn)
            % if it is NOT a cycle slip, just go ahead
            %----------------
            
        end %if sum(isnan(obuf.L1(:,1)))==0
        % If buffer is NOT totally filled, just go ahead
        %-------------------------------------------
 
    %else %In case there is NOT obs for this prn
        
        %-----------
        %Reset Block
        % Reset buffer, ambiguity, clock jmp corr. and
        % pseudorange smoothing filter for current prn
        %[pfn npf cx0 cxi0 cx12 obuf pwu]= ...
        %    resetblock(pfn,npf,cx0,cxi0,cx12,obuf,prn,pwu);
        %-----------
        
    %end %if (sum(obs(:,2)==prn))
    %------------------------------------

end %for prn=1:31
%--------------------------------------

%--------------------------------------------------------------------------
% End of Cycle slip block
%==========================================================================


