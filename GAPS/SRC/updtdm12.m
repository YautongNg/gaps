function A=updtdm12(prnlist,cst,ipp,recllh,elvlist)
%
% Function updtdm12
% =================
%
%       Updates the design matrix for L1/L2 ambiguities computation
%
% Sintax
% ======
%
%       A=updtdm12(A)
%
% Input
% =====
%
%       A -> Design matrix
%       cst -> Constants structure
%
% Output
% ======
%
%       A -> Updated design matrix
%
%
% Design matrix organization:
% ===========================
%
%              Clock              Ambiguities                   Iono delays
%            --------- ----------------------------------  ---------------------
%            rec  rec  sat1 sat1 sat2 sat2 ...  satn satn  A0     A1        A2
%            clk1 clk2 amb1 amb2 amb1 amb2      amb1 amb2  I      I         I  
% sat1 L1    1    0    1    0    0    0    ...  0    0    -1/m   -dlat/m   -dlon/m                    
% sat1 L2    0    1    0    1    0    0    ...  0    0    -g*1/m -g*dlat/m -g*dlon/m  
% sat1 P1    1    0    0    0    0    0    ...  0    0     1/m    dlat/m    dlon/m             
% sat1 P2    0    1    0    0    0    0    ...  0    0     g*1/m  g*dlat/m  g*dlon/m         
% sat2 L1    1    0    0    0    1    0    ...  0    0    -1/m   -dlat/m   -dlon/m         
% sat2 L2    0    1    0    0    0    1    ...  0    0    -g*1/m -g*dlat/m -g*dlon/m  
% sat2 P1    1    0    0    0    0    0    ...  0    0     1/m    dlat/m    dlon/m                
% sat2 P2    0    1    0    0    0    0    ...  0    0     g*1/m  g*dlat/m  g*dlon/m    
% ...        ...  ...  ...  ...  ...  ...  ...  ...  ...   ...    ...       ...                 
% satn L1    1    0    0    0    0    0    ...  1    0    -1/m   -dlat/m   -dlon/m             
% satn L2    0    1    0    0    0    0    ...  0    1    -g*1/m -g*dlat/m -g*dlon/m    
% satn P1    1    0    0    0    0    0    ...  0    0     1/m    dlat/m    dlon/m               
% satn P2    0    1    0    0    0    0    ...  0    0     g*1/m  g*dlat/m  g*dlon/m        
% 
%
% Created/modified
% ================
%
% When          Who                     What
% ----          ---                     ----
% 2006/08/01    Rodrigo Leandro         Function created
%
%
% ===============================
% Copyritght 2006 Rodrigo Leandro
% ===============================


%========================================
% Derivatives for clock (columns 1 and 2)
%----------------------------------------
for prn=1:size(prnlist,1)
    % row number for current prn
    nl=(prn-1)*5;
    %L1
    A(nl+1,1)=1;
    %L2
    A(nl+2,1)=1;
    A(nl+2,2)=1;
    %P1
    A(nl+3,1)=0;
    %P2
    A(nl+4,1)=0;
    A(nl+4,2)=0;
end
%========================================


%============================
% Derivatives for ambiguities
%----------------------------
for prn=1:size(prnlist,1)
    % row number for current prn
    nl=(prn-1)*5;
    % column number for current prn
    nc=2+(prn-1)*2;
    %L1
    A(nl+1,nc+1)=1;
    %L2
    A(nl+2,nc+2)=1;
    %Ionfree
    A(nl+5,nc+1)=cst.if1;
    A(nl+5,nc+2)=-cst.if2;
end
%============================


%==========================================
% Derivatives for IONO delay (L1 frequency)
%------------------------------------------
m=2;
if m==2
    
    % Using bilinear model + mapping function
    for sat=1:size(prnlist,1)
        
        % row number for current prn
        nl=(sat-1)*5;

        % get current number of columns
        nc=2+size(prnlist,1)*2;
        
        % get PRN
        prn=prnlist(sat);
        
        % get elevation angle
        elevang=elvlist(sat);
        
        % compute mapping function
        R=6378136.3; % Mean radius of the Earth
        Sh=350000; % Shell height
        m=sqrt(1-(R*cos(elevang)/(R+Sh))^2); % Mapping function
        
        % compute delta_lat and delta_long
        ippll=ipp{prn}; % get IPP lat and long
        dlat=ippll(1,1)-recllh(1,1);
        dlon=ippll(2,1)-recllh(2,1);
        
        % compute gamma constant (for L2!)
        gamma=(cst.f1^2)/(cst.f2^2);
        
        % assign values
        %L1
        A(nl+1,nc+1)=-1/m;
        A(nl+1,nc+2)=-dlat/m;
        A(nl+1,nc+3)=-dlon/m;
        %L2
        A(nl+2,nc+1)=-gamma*1/m;
        A(nl+2,nc+2)=-gamma*dlat/m;
        A(nl+2,nc+3)=-gamma*dlon/m;
        %P1
        A(nl+3,nc+1)=1/m;
        A(nl+3,nc+2)=dlat/m;
        A(nl+3,nc+3)=dlon/m;
        %P2
        A(nl+4,nc+1)=gamma*1/m;
        A(nl+4,nc+2)=gamma*dlat/m;
        A(nl+4,nc+3)=gamma*dlon/m;
        
        
    end
           
else
    
    % One parameter for each satellite
    for sat=1:size(prnlist,1)
        % row number for current prn
        nl=(sat-1)*5;
        % column number for current prn
        nc=2+size(prnlist,1)*2+(sat-1);
        %L1
        A(nl+1,nc+1)=-1;
        %L2
        A(nl+2,nc+1)=-(cst.f1^2)/(cst.f2^2);
        %P1
        A(nl+3,nc+1)=1;
        %P2
        A(nl+4,nc+1)=(cst.f1^2)/(cst.f2^2);
    end

end

%==========================================