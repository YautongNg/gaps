function AUTOGAPS(obsname)

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
    ftime =  235959;
    %======================================================================
%==========================================================================


%==========================================================================
% Station
%--------------------------------------------------------------------------
    %======================================================================
    % Initial coordinates (XYZ or llh)
    % * [0;0;0]-> No initial coordinates
    %----------------------------------------------------------------------
    Xl =  0 ;
    Yl =  0 ;
    Zh =  0;
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
    fltname='none';
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
    prename2='get';
    %======================================================================
    %======================================================================
    % Precise Clock files
    %----------------------------------------------------------------------
    clkname1='get';
    clkname2='get';
    %======================================================================
    %======================================================================
    % P1-C1 biases file
    %----------------------------------------------------------------------
    p1c1name='get';
    %======================================================================
    %======================================================================
    % Antenna file
    %----------------------------------------------------------------------
    atxname='get';
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
% Ocean Tide Loading
    % 1 -> Apllied 
    % 0 -> Not Applied
    %----------------------------------------------------------------------
    ot=1;
    blqfile='IGStations.txt';
    %======================================================================
    %======================================================================
    % Earth Tide
    % 1 -> Apllied 
    % 0 -> Not Applied
    %----------------------------------------------------------------------
    bt=1;
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
    % >0 -> Constraint Standard Deviation (m)
    % -1 -> No tropospere 
    %----------------------------------------------------------------------
    sdt=0.02;
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
    % Use L2C for modernized satellites
    % For while, this option forces P2 to be substituted by C2
    % No biases are applied - should be used for research purposes only!!!
    % A very low weight is given for L2C satellite
    %----------------------------------------------------------------------
    %PRN    1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20
    useL2C=[0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0];
    %              21 22 23 24 25 26 27 28 29 30 31
    %useL2C=[useL2C  0  0  0  0  0  0  0  0  0  0  0 0 0 0 ];
    
    useL5=zeros(120,1);
    useL5(81:120,1)=ones;
    %======================================================================
    %======================================================================
    % P1-C1 bias mode
    % 0 -> Automatic
    % 1 -> Force non-cross-correlation receiver (uses P1 and P2)
    % 2 -> Force non-cross-correlation receiver using C1 (uses C1 and P2)
    % 3 -> Force cross-correlation receiver (uses C1 and P2')
    %----------------------------------------------------------------------
    p1c1m=0;
    %======================================================================
    %======================================================================
    % Residual tolerance (m)
    % cprt -> carrier-phase
    % prrt -> pseudorange
    %----------------------------------------------------------------------
    cprt=0.20;
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
    prsd=2.0;
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
    %======================================================================
    % Horizontal Gradient Estimation
    %----------------------------------------------------------------------
    shzg=-1;
    rwhg=-1;
%==========================================================================

%==========================================================================
% Output Options
%==========================================================================
    %======================================================================
    % Picture format
    %----------------------------------------------------------------------
    pic='emf';
    %======================================================================
%==========================================================================
    
    
GAPS(itime,ftime,irecc,obsname,fltname,direx,prename1,prename2, ...
    clkname1,clkname2,atxname,p1c1name,sdp,tp,ot,bt,sdt,rwt,shzg,rwhg,p1c1m,cprt,prrt,cllim,cpsd, ...
    prsd,coea,cslmt,jlmt,djlmt,picfmt,useL2C,useL5,blqfile)
  
%==========================================================================
% Organazing output files
%==========================================================================  
    data_output = fullfile(pwd(), 'OUTPUT');
    movefile('*.zip',data_output);
    delete('*.par','*.rio','*.cmp','*.par','*.l12','*.html',...
           '*.ppp','*.emf')  