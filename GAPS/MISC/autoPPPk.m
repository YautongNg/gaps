function autoPPP()

%==========================================================================
% Options Section of the PPP software
%==========================================================================

%load 'rodrigo'

%==========================================================================
% Clear Environment
%--------------------------------------------------------------------------
%clear
%==========================================================================

%==========================================================================
% Time
%--------------------------------------------------------------------------
    %======================================================================
    % Initial time (HHMMSS)
    %----------------------------------------------------------------------
    itime =  000000;
    %======================================================================
    %======================================================================
    % Final time (HHMMSS)
    %----------------------------------------------------------------------
    ftime =  240000;
    %======================================================================
%==========================================================================


%==========================================================================
% Station
%--------------------------------------------------------------------------
    %======================================================================
    % Initial coordinates (XYZ or llh)
    % * [0;0;0]-> No initial coordinates
    %----------------------------------------------------------------------
    Xl = 1112777.1682;
    Yl = -4341475.8527;
    Zh =  4522955.7993;
    irecc=[Xl;Yl;Zh];
    %======================================================================
%==========================================================================


%==========================================================================
% Files
%--------------------------------------------------------------------------
    %======================================================================
    % Output files
    %----------------------------------------------------------------------
        %==================================================================
        % Data processing ('screen' to get it in the screen)
        %------------------------------------------------------------------
        %outname='proPPP.txt';
        %==================================================================
        %==================================================================
        % Epoch by epoch results
        %------------------------------------------------------------------
        % Parameters:
        %outnamep='parPPP.txt';
        % Standard Deviation:
        %outnamesd='sdvPPP.txt';
        % Residuals
        %outnamer='resPPP.txt';
        %==================================================================
    %======================================================================
    %======================================================================
    % Observation file
    %----------------------------------------------------------------------
    obsname='kngs0910.06O';
    fltname='kngs0900_06O.flt';
    %======================================================================
    %======================================================================
    % Directory extension
    %----------------------------------------------------------------------
    direx='';
    %======================================================================
    %======================================================================
    % Precise ephemeris files ('get'--> download files from IGS)
    %----------------------------------------------------------------------
    prename1='get';
    prename2='igs13045.sp3';
    %======================================================================
    %======================================================================
    % Precise Clock files
    %----------------------------------------------------------------------
    clkname1='igs13044.clk';
    clkname2='igs13045.clk';
    %======================================================================
    %======================================================================
    % P1-C1 biases file
    %----------------------------------------------------------------------
    %p1c1name='p1c1bias.hist';
    %======================================================================
%==========================================================================


%==========================================================================
% Constraints
%--------------------------------------------------------------------------
    %======================================================================
    % Position Constraint
    % 0 -> Unconstrained
    % ~0 -> Constraint Standard Deviation (m)
    % The same sdp will be applied to the three components!!
    %----------------------------------------------------------------------
    sdp=0;
    %======================================================================
    %======================================================================
    % Position Type
    % 0 -> Static
    % 1 -> Kinematic
    % The same sdp will be applied to the three components!!
    %----------------------------------------------------------------------
    tp=0;
    %======================================================================
    %======================================================================
    % Residual Neutral Atmosphere Delay Constraint
    % 0 -> Unconstrained
    % ~0 -> Constraint Standard Deviation (m)
    %----------------------------------------------------------------------
    sdt=0.1;
    %======================================================================
    %======================================================================
    % Residual Neutral Atmosphere Delay Random Walk
    % 0 -> Single Value for whole time period
    % ~0 -> Random Walk (mm/h)
    %----------------------------------------------------------------------
    rwt=5;
    %======================================================================
%==========================================================================


%==========================================================================
% Constants
%--------------------------------------------------------------------------
    %======================================================================
    % P1-C1 bias mode
    % 0 -> Automatic
    % 1 -> Force non-cross-correlation receiver (uses P1 and P2)
    % 2 -> Force non-cross-correlation receiver using C1 (uses C1' and P2)
    % 3 -> Force cross-correlation receiver (uses C1' and P2')
    %----------------------------------------------------------------------
    p1c1m=0;
    %======================================================================
    %======================================================================
    % Residual tolerance (m)
    % cprt -> carrier-phase
    % prrt -> pseudorange
    %----------------------------------------------------------------------
    cprt=0.2;
    prrt=10;
    %======================================================================
    %======================================================================
    % Convergence limit for iterations (m)
    %----------------------------------------------------------------------
    cllim=1;
    %======================================================================
    %======================================================================
    % Standard deviation
    % cpsd -> Carrier-phase standard deviation (m)
    % prsd -> Pseudorange standard deviation (m)
    %----------------------------------------------------------------------
    cpsd=0.02;
    prsd=2;
    %======================================================================
    %======================================================================
    % Cutoff elevation angle (degrees)
    %----------------------------------------------------------------------
    coea=10;
    %======================================================================
    %======================================================================
    % Cycle slip detection limit (m)
    %----------------------------------------------------------------------
    cslmt=0.08;
    %======================================================================
    %======================================================================
    % Clock jump detection limits (m)
    %----------------------------------------------------------------------
    jlmt=200;
    djlmt=2;
    %======================================================================
%==========================================================================

PPP1(itime,ftime,irecc,obsname,fltname,direx,prename1,prename2, ...
    clkname1,clkname2,sdp,tp,sdt,rwt,p1c1m,cprt,prrt,cllim,cpsd, ...
    prsd,coea,cslmt,jlmt,djlmt)