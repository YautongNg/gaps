% GAPS
% GPS data Analysis and Positioning Software

function GAPSFGN(itime,ftime,irecc,obsname,fltname,direx,prename1,prename2, ...
    clkname1,clkname2,atxname,sdp,tp,sdt,rwt,p1c1m,cprt,prrt,cllim,cpsd, ...
    prsd,coea,cslmt,jlmt,djlmt,picfmt,useL2C)


%==========================================================================
% Convert hatanaka to rinex if necessary
% Store original file name
%--------------------------------------------------------------------------
oobsname=obsname;
if strcmp(obsname(end),'d')
    obsname=crx2rnx(obsname);
end
%==========================================================================


%==========================================================================
% Open Output Files
%--------------------------------------------------------------------------
defname=[oobsname(end-11:end-4) '_' oobsname(end-2:end) direx];
outname=[defname '.pro'];
outnamep=[defname '.par'];
outnamesd=[defname '.std'];
outnamer=[defname '.res'];
outname12=[defname '.l12'];
outnameri=[defname '.rio'];
outnamemp=[defname '.cmp'];
if strcmp(outname,'screen')
    otptu=1;
else
    otptu=fopen(outname,'w');
end
otptp=fopen(outnamep,'w');
otptsd=fopen(outnamesd,'w');
otptr=fopen(outnamer,'w');
otpt12=fopen(outname12,'w');
otptri=fopen(outnameri,'w');
otptmp=fopen(outnamemp,'w');
% Write Headers
gapsv='GAPS v5.0 - University of New Brunswick - GGE';
whotptp(otptp,gapsv);
whotptr(otptr,gapsv);
whotptsd(otptsd,gapsv);
pro_option = 1;
%==========================================================================


%==========================================================================
% Load Constants
% cst -> structure containing constants:
%        cst.c -> speed of light (m/s)
%        cst.f1 -> L1 frequency (Hz)
%        cst.l1 -> L1 wavelength (m)
%        cst.f2 -> L2 frequency (Hz)
%        cst.l2 -> L2 wavelength (m)
%        cst.if1 -> Ion-free combination coefficient for freq. L1*
%        cst.if2 -> Ion-free combination coefficient for freq. L2*
%        (*) to be used in metric units
%--------------------------------------------------------------------------
cst=loadcst();
%==========================================================================


%==========================================================================
% Open observation file, read header and leave it open for data access
% hobs -> structure containing header information
% ifo -> observation file identifier (to be used to read file)
% Restore original filename 
%--------------------------------------------------------------------------
[hobs ifo]=preproobs(obsname);
obsname=oobsname;
%==========================================================================


%==========================================================================
% Get position of observables in observation file, from header variable
% poob -> structure containing observable positions
%         poob.P1 -> P1 pseudorange position
%         poob.P2 -> P2 pseudorange position
%         poob.L1 -> L1 carrier phase position
%         poob.L2 -> L2 carrier phase position
%--------------------------------------------------------------------------
poob=getpobs(hobs);
%==========================================================================

%==========================================================================
% Download orbits/clocks/antenna files form IGS ftp server if needed
% dfiles_oc -> nx1 structure containing orbit/clock file names
% dfile_atx -> 1x1 structure containing antenna file name
%--------------------------------------------------------------------------
if strcmp(prename1, 'get') | strcmp(atxname, 'get')    
    [dfiles_oc dfile_atx]= ...
        getoc(prename1,atxname,hobs.fyear,hobs.fmonth,hobs.fday,2);
end
if strcmp(prename1, 'get') 
    prename1=dfiles_oc{1,1};
    clkname1=dfiles_oc{2,1};
    if size(dfiles_oc,1)==4
        prename2=dfiles_oc{3,1};
        clkname2=dfiles_oc{4,1};
    else
        prename2='none';
        clkname2='none';
    end
end
if strcmp(atxname, 'get') 
    atxname=dfile_atx{1,1};
end
%==========================================================================

%==========================================================================
% 1.Read Antenna file and put receiver and satellite antenna information
%   into variables
% 2.Reformat Satellite antenna variable (satatx) to allow direct indexing 
%   using prn code (prnatx) 
%--------------------------------------------------------------------------
if ~strcmp(atxname,'old')
    %(1)
    [satatx recatx]=readatx(atxname);
    %(2)
    prnatx=sat2prnatx(satatx,hobs.fyear,hobs.fmonth,hobs.fday);
end
%==========================================================================

%==========================================================================
% Open, read and process Precise ephemeris files
%           sp3 = 1x3 structure
%           sp3{1,1} = px
%           sp3{1,2} = py
%           sp3{1,3} = pz
%               px,py,pz are 4xNS structures
%               NS = Number of Satellites
%               px{idx,prn}=17x1 polynomial coefficients
%               idx = arc            number
%                     0h - 6h     -> 1
%                     6h - 12h    -> 2
%                     12h - 18h   -> 3
%                     18h - 24h   -> 4
%--------------------------------------------------------------------------
[sp3 dat]=prosp3(prename1,prename2);
% Section commented by RL in 2006/06/14 - Back to the original way -> keep
%  one variable (sp3) for the three components.
% Separate between X, Y and Z components and clear sp3 variable
%spx=sp3{1,1};
%spy=sp3{1,2};
%spz=sp3{1,3};
%clear sp3;
%==========================================================================


%==========================================================================
% Open, read and process Precise clock files
%          clk = structure
%          clk{prn,idx} = 3x1 vector with polinomial coefficients
%          idx = arc (in sod)    number
%                0-1200      ->  1
%                1200-2400   ->  2
%                2400-3600   ->  3
%                ...             ...
%                85200-86400 ->  72
%--------------------------------------------------------------------------
[clk clk1]=proclk(clkname1,clkname2);
%==========================================================================


%==========================================================================
% Generate Satellite Antenna Offsets for this day
%       soff -> 31x3 matrix with antenna offsets
%               soff(PRN,1)=X offset*
%               soff(PRN,2)=Y offset*
%               soff(PRN,3)=Z offset*
%               (*) Satellite body coordinate system
%--------------------------------------------------------------------------
if strcmp(atxname,'old')
    soff=prnoff(hobs.fyear,hobs.fmonth,hobs.fday);
else
    soff=prnoffabs(satatx,cst,hobs.fyear,hobs.fmonth,hobs.fday);
end
%==========================================================================


%==========================================================================
% Initialize Current Date and progress value (%)
%--------------------------------------------------------------------------
cdate=[hobs.fyear;hobs.fmonth;hobs.fday;hobs.fhour; ...
    hobs.fminute;hobs.fsecond];
ctime=0;
prog=0;
%==========================================================================

%==========================================================================
% Generate P1-C1 biases for this day and list of receiver types
%       p1c1 -> 40x1 vector with P1C1 biases (nsec)
%--------------------------------------------------------------------------
p1c1name='p1c1bias.hist';
[p1c1 lrtype]=dp1c1b(p1c1name,cdate);
[p1c1m poob]=dp1c1m(p1c1m,hobs,poob,lrtype);
%==========================================================================

%==========================================================================
% Generate the APC offset and variation for user antenna
% apc -> 22x2 vector with APC values (mm) - igs_01.pcv file
% apc -> structure with absolute APC info - IGS05_YYYY.atx file
% -------------------------------------------------------------------------
if strcmp(atxname,'old')
    apc=genapc(hobs);
else
    apc=genapcabs(hobs,recatx);
end 
%==========================================================================

%==========================================================================
% Initialize receiver coordinates
%       recxyz -> 3x1 vector with receiver XYZ coordinates
%                 recxyz=[ X ; Y ; Z ]
%                         (m) (m) (m)
%       recllh -> 3x1 vector with receiver geodetic coordinates
%                 recllh=[ Lat ; Lon ; h ]
%                         (rad) (rad) (m)
%       1st option -> get coordinates from command file
%       2nd option -> get coordinates from RINEX header
%       other options to be implemented, such as improvement with code
%       solution
%--------------------------------------------------------------------------
[irecxyz irecllh uirecxyz uirecllh]=initrecc(irecc,hobs);
recxyz=irecxyz;
recllh=irecllh;
%==========================================================================


%==========================================================================
% Initialize receiver clock offset
%       recclk -> Receiver clock offset (m)
%                 Clock is initialized with zero and updated with every
%                 epoch solution, treated as white noise.
%--------------------------------------------------------------------------
recclk=0;
%==========================================================================


%==========================================================================
% Initialize zenith neutral atmosphere delay 
%       zennad -> Zenith neutral atmosphere delay (m)
%                 The initial value for the delay is computed using UNB3m
%                 model.
%--------------------------------------------------------------------------
% Compute DOY
doy=ymd2doy(cdate(1:3,1));
% Compute the zenith delay
zennad=zunb3m(recllh,doy);
% sdt=-1 is a flag to process data 
% without using any tropospheric model/estimation
if sdt==-1
    zennad=[0;0];
    sdt=0.0000001;
    rwt=0;
end
izennad=zennad;
%==========================================================================


%==========================================================================
% Initialize ionospheric piercing point structure 
%       ipp -> structure with ipp geodetic latitude and longitude
%              ipp{prn}=[ lat ; lon ]
%                        [rad] [rad]
%--------------------------------------------------------------------------
ipp{31}=nan;
%==========================================================================


%==========================================================================
% Initialize Filters
%         pfn - nx1 vector containing ambiguity term for pseudorange 
%               smoothing filter.
%         npf - nx1 vector containing number of used observations in the 
%               pseudorange smoothing filter.
%         amb - nx1 vector containing ion-free ambiguities.
%         amb1 - nx1 vector containing L1 ambiguities
%         amb2 - nx1 vector containing L2 ambiguities
%         ambi - nx1 vector containing IONO ambiguities
%         ionop - structure containing IONO delay model parameters
%         rdcb - receiver DCB
%         rdcbvar - receiver DCB variance
%         jmp - nx1 vector containing Clock Jump Corrections.
%         pwu - nx1 vector containing phase wind-up corrections.
%--------------------------------------------------------------------------
[pfn npf amb amb1 amb2 ambi ionop rdcb rdcbvar jmp pwu]=initfilt();
%==========================================================================


%==========================================================================
% Initialize Observation Buffer
%    obuf -> observation buffer
%            obuf.P1(ep,prn) -> P1 buffer
%            obuf.P2(ep,prn) -> P2 buffer
%            obuf.L1(ep,prn) -> L1 buffer
%            obuf.L2(ep,prn) -> L2 buffer
%--------------------------------------------------------------------------
obuf=initobuf();
%==========================================================================

%==========================================================================
% Initialize Constraint Matrices
%       sdp -> Standard Deviation for Position
%       sdt -> Standard Deviation for Res. Neutral Atm. Delay
%       cx0 -> 36x36 Matrix - Cov. matrix of the constrained parameters
%       cx12 -> 62x62 matrix - Cov. matrix of the L1/L2 ambiguities
%--------------------------------------------------------------------------
cx0=initcx0(sdp,sdt);
cx12=initcx12();
cxi0=initcxi0();
%==========================================================================

%==========================================================================
% If informed, load file with filter variables
%--------------------------------------------------------------------------
if ~strcmp(fltname,'none')
    load(fltname,'-mat');
end
%==========================================================================

%==========================================================================
% Loop to process data epoch by epoch
%--------------------------------------------------------------------------
% Reseting observation file status
%   1 -> NOT end of file
%   0 -> end of file
staifo=1;
%--------------------------------------------------------------------------
 fprintf(1,'Processing observations:\n');
 epcount=0; % Epoch counter
 while staifo==1
%==========================================================================


    %======================================================================
    % Read Observation Record
    %       obs -> nsxno matrix containing observations (same order as 
    %              stated in the header)
    %              ns -> # of satellites
    %              no -> # of observables
    %       staifo -> Status of the function - 1 -> data read
    %                                          0 -> data read, end of file 
    %                                               reached
    %
    %       ocdate -> old current date
    %----------------------------------------------------------------------
    octime=ctime; % store old time
    ocdate=cdate; % store old date
    [obs staifo cdate]=getobs(ifo,hobs);
    obs=sortrows(obs,2);
    %======================================================================
    
    %======================================================================
    % Use C2 if needed
    %
    % This function puts C2 in place of P2, for IIR-M satellites
    % So C2 is used rather than P2 for chosen satellites
    %
    % useL2C is a 1x31 logical vector (1-> use C2; 0-> don't use C2)
    %----------------------------------------------------------------------
    obs=useC2(obs,useL2C);
    %======================================================================
    
    %======================================================================
    % Check if time is within time interval
    %----------------------------------------------------------------------
    ctime=cdate(4,1)*10000+cdate(5,1)*100+cdate(6,1);
    if ctime>ftime || ctime<octime
        staifo=0;
    end
    if ctime>=itime && ctime<=ftime && staifo==1
        epcount=epcount+1;
    %======================================================================
 
    %======================================================================
    % Compute Body Tide
    %   btdllh -> tide in U,N,E directions
    %   btdxyz -> tide in X,Y,Z directions
    %----------------------------------------------------------------------
    btdllh=btide(recllh,cdate);
    btdxyz=offllh2xyz(recllh,btdllh);
    %======================================================================
   
    %======================================================================
    % Print epoch header section and progress
    %----------------------------------------------------------------------
    prog=prtprog(ctime,itime,ftime,prog);
    if pro_option
    fprintf(otptu,'=======================================================\n');
    fprintf(otptu,'%4i %2i %2i %2i %2i %7.4f - %2i satellites\n', ...
        cdate,size(obs,1));
    fprintf(otptu,'-------------------------------------------------------\n');
    fprintf(otptu,'RECEIVER\n');
    fprintf(otptu,'RECXYZ: %13.4f m %13.4f m %13.4f m\n',recxyz);
    fprintf(otptu,'RECCLK: %13.4f m\n',recclk);
    fprintf(otptu,'ZENNAD: %13.4f m\n',sum(zennad));
    fprintf(otptu,'BDYTDE: %13.4f m %13.4f m %13.4f m\n',btdllh);
    end
    %======================================================================
    
    %======================================================================
    % Compute DOY (it will be used by all satelllites)
    %----------------------------------------------------------------------
    doy=ymd2doy(cdate);
    %======================================================================
    
    
    %======================================================================
    % Check Cycle Slips / Clock Jumps
    % Update clock jump corrections if needed
    %     slp -> flag for cycle slip
    %            0 -> no cycle slip
    %            1 -> cycle slip!
    %     jmp -> correction for clock Jumps
    %----------------------------------------------------------------------
    [pfn npf cx0 cxi0 cx12 jmp obuf pwu]= ...
        slpjmp(obs,pfn,npf,cx0,cxi0,cx12,jmp,obuf,poob,cst,cslmt, ...
        jlmt,djlmt,sp3,recxyz,otptu,pwu);
    %======================================================================
    

    %======================================================================
    % Update Observation Buffer
    %----------------------------------------------------------------------
    obuf=upobuf(obs,obuf,poob);
    %======================================================================
  
    %======================================================================
    % Update pseudorange smoothing filter
    %----------------------------------------------------------------------
    % TO BE IMPLEMENTED
    %======================================================================
    
    %======================================================================
    % Convergence loop - control convergence for adjustment iterations
    %----------------------------------------------------------------------
    clcon=0; % convergence loop condition
    itcount=0; % iteration counter
    while clcon==0
    %======================================================================

    %======================================================================
    % Reset
    % 1. prnlist -> list of PRN's used in the adjustment
    % 2. A -> design matrix
    % 3. w -> misclousure vector
    % 4. P -> weight matrix
    % 5. p1,p2,l1,l2 -> observables for the two frequencies
    % 6. Update iteration counter (itcount)
    %======================================================================
    prnlist=[];
    elvlist=[];
    A=[];
    w=[];
    P=[];
    p1=zeros(31,1);
    p2=zeros(31,1);
    l1=zeros(31,1);
    l2=zeros(31,1);
    itcount=itcount+1;
    if pro_option
    fprintf(otptu,'\n-------------------------------------------------------\n');
    fprintf(otptu,'Iteration %1i\n',itcount);
    end
    %======================================================================
    
    %======================================================================
    % Loop for each satellite
    %----------------------------------------------------------------------
    for sat=1:size(obs,1)
    %======================================================================
    
        %==================================================================
        % Check if it is an effective satellite (obs. available)
        % If yes, create ionfree observation and compute corrections
        %------------------------------------------------------------------
        if isobs4prn(obs,obs(sat,2))
        %==================================================================
            
            %==============================================================
            % Get PRN
            %--------------------------------------------------------------
            prn=obs(sat,2);
            %==============================================================        
            
            %==============================================================
            % Create observations (combined)
            % p0 -> Ion free pseudorange before any correction (m)
            % l0 -> Ion free carrier-phase before any correction (m)
            %--------------------------------------------------------------
            [p0 l0 p1m l1m p2m l2m]=creobs(obs,sat,poob,cst,p1c1m,p1c1);
            %==============================================================
            
            
            
            %==============================================================
            % Compute satellite clock error (m)
            %--------------------------------------------------------------
            satclk=comsc(clk,clk1,prn,cdate,p0,cst);
            %==============================================================
            
            %==============================================================
            % Compute orbits
            %--------------------------------------------------------------
            satxyz=comsp(sp3,prn,cdate,soff,satclk,p0,cst);
            %==============================================================
            
            %==============================================================
            % Compute azimuth
            % az -> azimuth (rec->sat) in radians
            %==============================================================
            azdist=invsol(recxyz,satxyz);
            az=azdist(1,1);
            %==============================================================
           
            %==============================================================
            % Compute elevation angle
            %==============================================================
            elvang=elev(recxyz,recllh,satxyz);
            %==============================================================

            %==============================================================
            % Compute satellite nadir angle
            %==============================================================
            satnadir=nadir(satxyz,recxyz);
            %==============================================================
            
            %==============================================================
            % Compute ionospheric piercing point
            %==============================================================
            ipp{prn}=ionopp(recxyz,satxyz);
            %==============================================================
            
            %==============================================================
            % Compute relativistic effect (m)
            %--------------------------------------------------------------
            releff=rel(sp3,prn,cdate,satclk,satxyz,p0,cst);
            %==============================================================
            
            %==============================================================
            % Compute sagnac delay correction (m)
            %--------------------------------------------------------------
            sagcor=sagnac(satxyz,recxyz,cst);
            %==============================================================

            %==============================================================
            % Compute slant neutral atmosphere delay (m)
            %   nmf=[hmf nhmf]'
            %   zennad=[hd nhd]'
            %--------------------------------------------------------------
            %nmf=niell(recllh,doy,elvang);
            nmf=my_map_func (recllh(1,1), recllh(2,1), recllh(3,1), cdate(1:3,1), ...
                cdate(6,1) + cdate(5,1)*60 + cdate(4,1)*3600, elvang, az);
            sltnad=sum(zennad.*nmf);
            %==============================================================

            %==============================================================
            % Compute body tide correction (m)
            %--------------------------------------------------------------
            bdytde=xyz2rngcor(btdxyz,recxyz,satxyz);
            %==============================================================            
            
            %==============================================================
            % Compute phase wind-up correction (m)
            %--------------------------------------------------------------
            [phswdp phswdp1 phswdp2 pwu]= ...
                phasewup(satxyz,cdate,recxyz,recllh,cst,pwu,prn);
            %==============================================================            
            
            %==============================================================
            % Compute receiver antena phase center correction (m)
            %--------------------------------------------------------------
            if strcmp(atxname,'old')
                [antphc antphc1 antphc2]= ...
                    antphasecenter(apc,recxyz,recllh,satxyz,elvang,cst);
            else
                [antphc antphc1 antphc2]= ...
                    apcabs(apc,recxyz,recllh,satxyz,elvang,az,cst);
            end
            %==============================================================            
            
            %==============================================================
            % Compute satellite apc variation correction (m)
            %--------------------------------------------------------------
            if ~strcmp(atxname,'old')
                satapc=satapcv(satatx,recxyz,satxyz,prn,satnadir,cst);
            else
                satapc=0;
            end
            %==============================================================            
            
            %==============================================================
            % Compute geometric range (m)
            %--------------------------------------------------------------
            gmtrng=norm(satxyz-recxyz);
            %==============================================================
            
            %==============================================================
            % Apply corrections
            % Corrections are applied to ionfree pseudorange and carrier
            % and also to pseudorange and carrier at the two separated
            % frequencies
            %--------------------------------------------------------------
            if pro_option
            fprintf(otptu,'\nPRN %2i\n',prn);
            fprintf(otptu,'SATXYZ: %14.3f %14.3f %14.3f\n',satxyz);
            fprintf(otptu,'ELVANG: %14.3f\n',elvang*180/pi);
            fprintf(otptu,'NADANG: %14.3f\n',satnadir*180/pi);
            fprintf(otptu,'OBS(m):                %14.3f %14.3f\n',p0,l0);
            end
            %---------------------- Ambiguity -----------------------------
            l0=l0-amb(prn);
            l1(prn)=l1m;
            l2(prn)=l2m;
            if pro_option
                fprintf(otptu,'AMBGTY: %14.3f %14.3f %14.3f\n',amb(prn),p0,l0);
            end
            %-------------------- Receiver clock --------------------------
            p0=p0-recclk;
            p1(prn)=p1m-recclk;
            p2(prn)=p2m-recclk;
            l0=l0-recclk;
            l1(prn)=l1(prn)-recclk;
            l2(prn)=l2(prn)-recclk;
            if pro_option
                fprintf(otptu,'RECCLK: %14.3f %14.3f %14.3f\n',recclk,p0,l0);
            end
            %-------------------- Satellite clock -------------------------
            p0=p0+satclk;
            p1(prn)=p1(prn)+satclk;
            p2(prn)=p2(prn)+satclk;
            l0=l0+satclk;
            l1(prn)=l1(prn)+satclk;
            l2(prn)=l2(prn)+satclk;
            if pro_option
                fprintf(otptu,'SATCLK: %14.3f %14.3f %14.3f\n',satclk,p0,l0);
            end
            %------------------ Relativistic effect -----------------------
            p0=p0+releff;
            p1(prn)=p1(prn)+releff;
            p2(prn)=p2(prn)+releff;
            l0=l0+releff;
            l1(prn)=l1(prn)+releff;
            l2(prn)=l2(prn)+releff;
            if pro_option
                fprintf(otptu,'RELEFF: %14.3f %14.3f %14.3f\n',releff,p0,l0);
            end
            %--------------------- Sagnac delay ---------------------------
            p0=p0+sagcor;
            p1(prn)=p1(prn)+sagcor;
            p2(prn)=p2(prn)+sagcor;
            l0=l0+sagcor;
            l1(prn)=l1(prn)+sagcor;
            l2(prn)=l2(prn)+sagcor;
            if pro_option
                fprintf(otptu,'SAGCOR: %14.3f %14.3f %14.3f\n',sagcor,p0,l0);
            end
            %--------------- Neutral atmosphere delay ---------------------
            p0=p0-sltnad;
            p1(prn)=p1(prn)-sltnad;
            p2(prn)=p2(prn)-sltnad;
            l0=l0-sltnad;
            l1(prn)=l1(prn)-sltnad;
            l2(prn)=l2(prn)-sltnad;
            if pro_option
                fprintf(otptu,'SLTNAD: %14.3f %14.3f %14.3f\n',sltnad,p0,l0);
            end
            %---------------------- Body tide  ----------------------------
            p0=p0+bdytde;
            p1(prn)=p1(prn)+bdytde;
            p2(prn)=p2(prn)+bdytde;
            l0=l0+bdytde;
            l1(prn)=l1(prn)+bdytde;
            l2(prn)=l2(prn)+bdytde;
            if pro_option
                fprintf(otptu,'BDYTDE: %14.3f %14.3f %14.3f\n',bdytde,p0,l0);
            end
            %-------------------- Phase wind-up ---------------------------
            % No correction for pseudoranges - carrier-phase only effect
            l0=l0-phswdp;
            l1(prn)=l1(prn)-phswdp1;
            l2(prn)=l2(prn)-phswdp2;
            if pro_option
                fprintf(otptu,'PHSWDP: %14.3f %14.3f %14.3f\n',phswdp,p0,l0);
            end
            %---------------------- Receiver APC --------------------------
            p0=p0+antphc;
            p1(prn)=p1(prn)+antphc1;
            p2(prn)=p2(prn)+antphc2;
            l0=l0+antphc;
            l1(prn)=l1(prn)+antphc1;
            l2(prn)=l2(prn)+antphc2;
            if pro_option
                fprintf(otptu,'RECAPC: %14.3f %14.3f %14.3f\n',antphc,p0,l0);
            end
            %---------------------- Satellite APC --------------------------
            p0=p0+satapc;
            p1(prn)=p1(prn)+satapc;
            p2(prn)=p2(prn)+satapc;
            l0=l0+satapc;
            l1(prn)=l1(prn)+satapc;
            l2(prn)=l2(prn)+satapc;
            if pro_option
                fprintf(otptu,'SATAPC: %14.3f %14.3f %14.3f\n',satapc,p0,l0);
            end
            %---------------------- Clock jump ----------------------------
            % Clock jump corrections disabled for while
            %p0=p0+jmp(prn);
            %l0=l0+jmp(prn);            
            if pro_option
                fprintf(otptu,'CLKJMP: %14.3f %14.3f %14.3f\n',jmp(prn),p0,l0);
            end
            %-------------------- Geometric range -------------------------
            p0=p0-gmtrng;
            p1(prn)=p1(prn)-gmtrng;            
            p2(prn)=p2(prn)-gmtrng;            
            l0=l0-gmtrng;          
            l1(prn)=l1(prn)-gmtrng;            
            l2(prn)=l2(prn)-gmtrng;            
            if pro_option
                fprintf(otptu,'GMTRNG: %14.3f %14.3f %14.3f\n',gmtrng,p0,l0);
            end
            %==============================================================
        
            %==============================================================
            % Check:
            %           - if satellite is above the cutoff elevation angle
            %           - if there was sat clock information available
            %--------------------------------------------------------------
            if elvang>coea*pi/180 && satclk~=0
            %==============================================================
            
                %==========================================================
                % If satellite pass through elev. angle test, it is used in
                % the adjustment. In this block:
                % 1. PRN list is updated with current prn
                % 2. Update design matrix
                % 3. Update misclousure vector
                % 4. Update weight matrix
                %----------------------------------------------------------
                prnlist=[prnlist;prn];
                elvlist=[elvlist;elvang];
                A=updtdm(A,recxyz,satxyz,gmtrng,nmf);
                w=updtmv(w,p0,l0);
                P=updtwm(P,elvang,cpsd,prsd,prn,useL2C);
                %==========================================================
                
            %==============================================================
            % Satellite is below cutoff elevation angle
            %--------------------------------------------------------------
            else
            %==============================================================

                %==========================================================
                % Print
                %----------------------------------------------------------
                if elvang<coea*pi/180
                    if pro_option
                    fprintf(otptu, ...
                '** PRN %2i rejected - elevation angle below %2i degrees\n', ...
                    prn,coea);
                    end
                elseif satclk==0
                    if pro_option
                    fprintf(otptu, ...
                '** PRN %2i rejected - No clock information\n', ...
                    prn);
                    end
                end
                %==========================================================

            %==============================================================
            % End of check for elev. angle
            %--------------------------------------------------------------
            end
            %==============================================================
        
        %==================================================================
        % End of check for effective satellite
        %------------------------------------------------------------------
        end
        %==================================================================
       
    %======================================================================
    % End of loop for each satellite
    %----------------------------------------------------------------------
    end
    %======================================================================
    
    %======================================================================
    % Build the constraints matrix
    %----------------------------------------------------------------------
    cx=bldcx(cx0,prnlist);
    %px=adns2px(px,tp,rwt,cdate,ocdate);
    %======================================================================
    
    %======================================================================
    % Least squares adjustment
    %----------------------------------------------------------------------
    [delta prnlist elvlist cx rc rp]= ...
        lsadj(A,P,w,cx,cprt,prrt,prnlist,elvlist,recxyz,epcount,irecxyz);
    if pro_option
        fprintf(otptu,'\nUPDATE: %7.3f %7.3f %7.3f %10.3f %7.3f\n\n',delta(1:5));
    end
    %======================================================================
    
    %======================================================================
    % Update parameters 
    %----------------------------------------------------------------------
    [recxyz,recllh,recclk,zennad,amb]= ...
        updtx(delta,recxyz,recclk,zennad,amb,prnlist);
    p1(:)=p1(:)-delta(4,1);
    p2(:)=p2(:)-delta(4,1);
    %======================================================================

    %======================================================================
    % Verify convergence loop condition 
    %----------------------------------------------------------------------
    if max(abs(delta(1:3))) <= cllim
        clcon=1;
    end
    %======================================================================

    %======================================================================
    % End of convergence loop
    %----------------------------------------------------------------------
    end
    %======================================================================

    %======================================================================
    % Update constraint matrix
    %----------------------------------------------------------------------
    cx0=updtcx0(cx,prnlist,tp,rwt,cdate,ocdate);
    %======================================================================

    %======================================================================
    % Compute L1 & L2 ambiguities
    % Do it only if a valid solution was obtained (delta~=0)
    %----------------------------------------------------------------------
%     if delta(1,1)~=0
%         [cx12 cx0 amb amb1 amb2]=l1l2(cx0,cx12,prnlist,elvlist, ...
%             amb,amb1,amb2,l1,l2,p1,p2,cst,cpsd,otpt12,cdate,rc,ipp,recllh);
%     end
    %======================================================================
    
    %======================================================================
    % Compute IONO delay model
    % Do it only if a valid solution was obtained (delta~=0)
    %----------------------------------------------------------------------
    if delta(1,1)~=0
        [ionop cxi0 ambi]= iono(ionop,cxi0,prnlist,elvlist, ...
            ambi,l1,l2,p1,p2,cst,cpsd,otpt12,otptri,cdate,ocdate,ipp,recllh);
    end
    %======================================================================
 
    %======================================================================
    % Compute code multipath
    % Do it only if a valid solution was obtained (delta~=0)
    %----------------------------------------------------------------------
    if delta(1,1)~=0
        [rdcb rdcbvar]= codemp(ionop,prnlist,elvlist,p1,p2,cst, ...
            cdate,ocdate,ipp,recllh,rdcb,rdcbvar,otptmp);
    end
    %======================================================================

    
    %======================================================================
    % Print data in the epoch by epoch files
    %----------------------------------------------------------------------
    wdotptp(otptp,cdate,recllh,recxyz,zennad,recclk,irecxyz,izennad,hobs);
    wdotptr(otptr,cdate,prnlist,rc,rp,elvlist);
    wdotptsd(otptsd,cdate,cx,recxyz);
    %======================================================================
    
    %======================================================================
    % End of check if time is within time interval
    %----------------------------------------------------------------------
    end % if ctime>=itime & ctime<=ftime
    %======================================================================
    
%==========================================================================
% End of epoch by epoch loop
%--------------------------------------------------------------------------
end
%==========================================================================


%==========================================================================
% Close Output Files
%--------------------------------------------------------------------------
if ~strcmp(outname,'screen')
    fclose(otptu);
end
fclose(otptp);
fclose(otptr);
fclose(otptsd);
fclose(otpt12);
fclose(otptmp);
fprintf(1,'Done.\n');
%==========================================================================

%==========================================================================
% Deal with Report
%--------------------------------------------------------------------------
plots;
createhtml;
fclose('all');
saveout
%winopen(PPP.html);
clear
%==========================================================================

