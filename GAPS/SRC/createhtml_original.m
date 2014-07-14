% Script createhtml

fo=fopen([defname '.html'],'w');


oname=obsname;
prename8=prename1;

%==========================================================================
% Block 1
%--------------------------------------------------------------------------
fprintf(fo,'<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">\n');
fprintf(fo,'<html xmlns="http://www.w3.org/1999/xhtml">\n');
fprintf(fo,'<head>\n');
fprintf(fo,'<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />\n');
fprintf(fo,'<title>%s</title>\n',oobsname(1:end));
fprintf(fo,'<style type="text/css">\n');
fprintf(fo,'<!--\n');
fprintf(fo,'.style1 {\n');
fprintf(fo,'	font-size: 36px;\n');
fprintf(fo,'	font-family: "Times New Roman", Times, serif;\n');
fprintf(fo,'}\n');
fprintf(fo,'.style2 {font-size: 18px; }\n');
fprintf(fo,'.style3 {\n');
fprintf(fo,'	font-size: 14px;\n');
fprintf(fo,'	font-family: "Courier New", Courier, monospace;\n');
fprintf(fo,'	font-weight: bold;\n');
fprintf(fo,'}\n');
fprintf(fo,'.style6 {font-size: 14px; font-family: "Courier New", Courier, monospace; }\n');
fprintf(fo,'.style14 {color: #000000}\n');
fprintf(fo,'-->\n');
fprintf(fo,'</style>\n');
fprintf(fo,'</head>\n');
fprintf(fo,'<body>\n');
fprintf(fo,'<PRE align="left" class="style1"><img src="ell.gif" width="200" height="200" />      GAPS v5.0      <img src="ell2.gif" width="200" height="200" /></PRE>\n');
%==========================================================================

parPPP=load(outnamep);
sdvPPP=load(outnamesd);
resPPP=load(outnamer);
if ~isempty(parPPP) & ~isempty(sdvPPP) & ~isempty(resPPP)
    fprintf(fo,'<PRE align="left" class="style3"> </PRE>\n');
    fprintf(fo,'<p align="left" class="style3">General information:</p>\n');
    fprintf(fo,'<blockquote>\n');
    fprintf(fo,'<p align="left" class="style6">Station<span class="style14">: \n');
    fprintf(fo,'%s\n',hobs.markname);
    fprintf(fo,'<br />\n');
    fprintf(fo,'<p align="left" class="style6">Observation file<span class="style14">: \n');
    fprintf(fo,'%s\n',[oobsname exten]);
    fprintf(fo,'<br />\n');
    fprintf(fo,'  Processed from \n');
    h=parPPP(1,4);
    m=parPPP(1,5);
    s=parPPP(1,6);
    fprintf(fo,'%1i',h);
    fprintf(fo,':');
    fprintf(fo,'%1i',m);
    fprintf(fo,':');
    fprintf(fo,'%1i\n',s);
    fprintf(fo,' to \n');
    h=parPPP(end,4);
    m=parPPP(end,5);
    s=parPPP(end,6);
    fprintf(fo,'%1i',h);
    fprintf(fo,':');
    fprintf(fo,'%1i',m);
    fprintf(fo,':');
    fprintf(fo,'%1i\n',s);
    fprintf(fo,' of \n');
    y=hobs.fyear;
    m=hobs.fmonth;
    d=hobs.fday;
    fprintf(fo,'%1i',y);
    fprintf(fo,'/');
    fprintf(fo,'%1i',m);
    fprintf(fo,'/');
    fprintf(fo,'%1i\n',d);
    fprintf(fo,'<br />  \n');
    fprintf(fo,'Run at %s and finished in %s seconds<br />  \n',datestr(startTime),num2str((now-startTime)*86400,'%7.2f'));
    %fprintf(fo,'  Interval: %2i seconds<br />  \n',hobs.interval);
    fprintf(fo,'  Positioning type: \n');
    if tp==0
        fprintf(fo,'Static\n');
    elseif tp==1
        fprintf(fo,'Kinematic\n');
    else
        error('Invalid processing mode. Must enter 0 for static or 1 for kinematic');
    end
    fprintf(fo,'<br />\n');
    fprintf(fo,'  IGS orbits: \n');
    if strcmpi(prename1(end-9),'r')
        fprintf(fo,'Rapid \n');
    elseif strcmpi(prename1(end-9),'s')
        fprintf(fo,'Precise \n');
    else
        fprintf(fo,'Unknown \n');
    end   
    fprintf(fo,'<br />\n');
    fprintf(fo,'  Antenna calibration: \n');
    if strcmpi(atxname,'old')
        fprintf(fo,'Relative \n');
    else
        fprintf(fo,'Absolute \n');
    end   
    fprintf(fo,'<br />\n');
    fprintf(fo,'  Cutoff elevation angle: \n');
    fprintf(fo,'%2i\n',coea);
    fprintf(fo,' degrees<br />\n');
    fprintf(fo,'Neutral Atmosphere Delay (NAD) model: %s <br />\n',NADM{1});
    fprintf(fo,'A-priori NAD: \n');
    fprintf(fo,'%5.3f\n',sum(izennad));
    fprintf(fo,' m <br />\n');
    fprintf(fo,'A-priori NAD standard deviation: \n');
    fprintf(fo,'%5.3f\n',sdt);
    fprintf(fo,' m<br />\n');
    fprintf(fo,'NAD variation: \n');
    fprintf(fo,'%3.1f\n',rwt);
    fprintf(fo,' mm/sqrt(h) <br />\n');
    fprintf(fo,'Mapping Function: \n');
    fprintf(fo,'%s <br /> \n',NADM{2});
    fprintf(fo,'Gradient Estimation: \n');
    if shzg < 1e-8
        fprintf(fo,'Not Estimated <br />\n');
    elseif shzg > 1e-8
        fprintf(fo,'Estimated <br />\n');
        fprintf(fo,'A-priori Gradient Standard Deviation: \n');
        fprintf(fo,'%3.1f<br />\n',shzg);
        fprintf(fo,'Gradient Variation: \n');
        fprintf(fo,' %3.1f mm/sqrt(h)<br />',rwt);
    end
    fprintf(fo,'  Ocean Tidal Loading: ');
    if ot == 1
        fprintf(fo,'yes \n');
    elseif ot == 0
        fprintf(fo,'no \n');
    end   
    fprintf(fo,'<br />\n');
    
    if ot == 1
        if isempty(blqfile) && flagl == 1; 
            fprintf(fo,'Ocean tide corrections were applied using GAPS BLQ file');
            fprintf(fo,'<br />\n');
        elseif ~isempty(blqfile) && flagf == 1 
            fprintf(fo,'Ocean tide corrections were applied using the user BLQ file'); 
            fprintf(fo,'<br />\n');
        end    
    end
    
    fprintf(fo,'  Body Tidal Loading: ');
    if bt == 1
        fprintf(fo,'yes \n');
    elseif bt == 0
        fprintf(fo,'no \n');
    end   
    fprintf(fo,'<br />\n');
    fprintf(fo,' Receiver type : %s <br />\n',hobs.rectype);
    if p1c1m==1
        fprintf(fo,' Detected as a non cross-correlation receiver<br />\n');
    elseif p1c1m==2
        fprintf(fo,' Detected as a non cross-correlation receiver reporting C1<br />\n');
    elseif p1c1m ==3
        fprintf(fo,' Detected as a cross-correlation receiver<br />\n');
    else
        fprintf(fo,'Unknown receiver type.<br />\n');
    end
    
    if strcmp(atxname,'old')
        if apc(1,1)==0
            fprintf(fo,' Antenna type not recognized!<br />\n');
        end
    else
        fprintf(fo,' Antenna Calibration : %s <br />\n',apc.type);
        if apc.freq(1).neu(3,1)==0
            fprintf(fo,' Antenna type not recognized!<br />\n');
        end
    end
    fprintf(fo,'Marker to Antenna Reference Point (ARP): \n');
    fprintf(fo,'%5.3f\n',hobs.deltah);
    fprintf(fo,' m <br />\n');
    fprintf(fo,'ARP to Antenna Phase Center: \n');
    if strcmp(atxname,'old')
        fprintf(fo,'%5.3f\n',(cst.if1(1)*apc(1,1)-cst.if2(1)*apc(1,2))/1000);
    else
        fprintf(fo,'%5.3f\n',(cst.if1(1)*apc.freq(1).neu(3,1)-cst.if2(1)*apc.freq(2).neu(3,1))/1000);
    end
    fprintf(fo,' m <br />\n');
    if poob.C1==poob.P1
        fprintf(fo,'Observables processed : Pseudorange (C1/P2) and carrier-phase (L1/L2)<br />\n');
    else
        fprintf(fo,'Observables processed : Pseudorange (P1/P2) and carrier-phase (L1/L2)<br />\n');
    end    
    fprintf(fo,'Linear combination: ion-free </p>\n');
    fprintf(fo,'</blockquote>\n');
    cep=round((y+(m-1)/12+d/365.25)*10)/10;
    fprintf(fo,'<p align="left" class="style3">Final coordinates (%5s - epoch %6.1f):</p>\n',dat,cep);
    fprintf(fo,'<blockquote>\n');
    fprintf(fo,'  <p align="left" class="style6">Cartesian (X,Y,Z): \n');
    fprintf(fo,'%15.4f\n%15.4f\n%15.4f\n',parPPP(end,14:16));
    fprintf(fo,' (m)</p>\n');
    fprintf(fo,'  <p align="left" class="style6">Std. Dev. (X,Y,Z): \n');
    fprintf(fo,'%15.4f\n%15.4f\n%15.4f\n',sdvPPP(end,11:13));
    fprintf(fo,' (m) </p>\n');
    fprintf(fo,'  <p align="left" class="style6"> Geodetic (Lat,Long,h): \n');
    lat=parPPP(end,8);
    lon=parPPP(end,9);
    h=parPPP(end,10);
    fprintf(fo,'%16.9f\n%16.9f\n%13.4f\n',lat,lon,h);
    fprintf(fo,' (dd.mmsssss,dd.mmsssss,m)</p>\n');
    %fprintf(fo,'  <p align="left" class="style6">NAD : \n');
    %fprintf(fo,'%6.4f\n',parPPP(end,20));
    %fprintf(fo,' +/- \n');
    %fprintf(fo,'%6.4f\n',sdvPPP(end,14));
    %fprintf(fo,' m</p>\n');

    fprintf(fo,'</blockquote>\n');

    fprintf(fo,'<p align="left" class="style3">A-priori coordinates:</p>\n');
    fprintf(fo,'<blockquote class="style6">\n');
    fprintf(fo,'  <p align="left">	Cartesian (X,Y,Z): \n');
    fprintf(fo,'%15.4f\n%15.4f\n%15.4f\n',uirecxyz);
    fprintf(fo,'(m) </p>\n');
    fprintf(fo,'  <p align="left">  Geodetic (Lat,Long,h): \n');
    lat=rad2dms(uirecllh(1,1));
    lon=rad2dms(uirecllh(2,1));
    h=uirecllh(3,1);
    fprintf(fo,'%16.9f\n%16.9f\n%13.4f\n',lat,lon,h);
    fprintf(fo,'(dd.mmsssss,dd.mmsssss,m) </p>\n');
    fprintf(fo,'  <p align="left">A-prori coordinates standard deviation: \n');
    if sdp>0
        fprintf(fo,'%10.7f\n',sdp);
        fprintf(fo,' m</p>\n');
    else
        fprintf(fo,'unconstrained</p>\n');
    end



    fprintf(fo,'</blockquote>\n');
    fprintf(fo,'<p align="left" class="style3">Final offsets w.r.t. a-priori coordinates:</p>\n');
    fprintf(fo,'<blockquote>\n');
    fprintf(fo,'  <p align="left" class="style6">Cartesian (X,Y,Z): \n');
    fprintf(fo,'%15.4f\n%15.4f\n%15.4f\n',parPPP(end,17:19));
    fprintf(fo,' (m)</p>\n');
    fprintf(fo,'  <p align="left" class="style6"> Geodetic (Lat,Long,h): \n');
    lat=parPPP(end,11);
    lon=parPPP(end,12);
    h=parPPP(end,13);
    fprintf(fo,'%15.4f\n%15.4f\n%15.4f\n',lat,lon,h);
    fprintf(fo,' (m)</p>\n');
    fprintf(fo,'  <p align="left" class="style6">Horizontal/3D: \n');
    fprintf(fo,'%15.4f\n%15.4f\n',norm([lat lon]),norm(parPPP(end,17:19)));
    fprintf(fo,' (m)</p>\n');


    fprintf(fo,'</blockquote>\n');
    fprintf(fo,'<p align="left" class="style3">Residuals:</p>\n');
    fprintf(fo,'<blockquote>\n');
    fprintf(fo,'<p align="left" class="style6">Carrier-phase:\n');
    if ~isempty(resPPP)
        fprintf(fo,' Mean = %7.3fm\n',mean(resPPP(:,4)));
        fprintf(fo,' / Std Dev = %7.3fm\n',std(resPPP(:,4)));
        fprintf(fo,' / RMS = %7.3fm</p>\n',norm(resPPP(:,4))/sqrt(size(resPPP,1)));
        fprintf(fo,'<p align="left" class="style6">Pseudorange:\n');
        fprintf(fo,' Mean = %7.3fm\n',mean(resPPP(:,3)));
        fprintf(fo,' / Std Dev = %7.3fm\n',std(resPPP(:,3)));
        fprintf(fo,' / RMS = %7.3fm</p>\n',norm(resPPP(:,3))/sqrt(size(resPPP,1)));
    else
        fprintf(fo,' Mean = N/A\n');
        fprintf(fo,' / Std Dev = N/A\n');
        fprintf(fo,' / RMS = N/A</p>\n');
        fprintf(fo,'<p align="left" class="style6">Pseudorange:\n');
        fprintf(fo,' Mean = N/A\n');
        fprintf(fo,' / Std Dev = N/A\n');
        fprintf(fo,' / RMS = N/A</p>\n');
    end

    fprintf(fo,'</blockquote>\n');
else
    fprintf(fo,' No output available.');

end


fprintf(fo,'  <p align="left" class="style3">&nbsp;</p>\n');
fprintf(fo,'<p align="left" class="style3">_______________________<br />\n');
fprintf(fo,'Coordinates convergence</p>\n');
fprintf(fo,'<p align="left" class="style3"><img src="coord1.%s" width="600" height="450" />\n',picfmt);
fprintf(fo,'<p align="left" class="style3"><img src="coord2.%s" width="600" height="450" />\n');
fprintf(fo,'<p align="left" class="style3"><img src="coord3.%s" width="600" height="450" />\n',picfmt);
fprintf(fo,'<p align="left" class="style3"><img src="coord4.%s" width="600" height="450" /></p>\n',picfmt);
fprintf(fo,'<p align="left" class="style3">_______________<br />\n');
fprintf(fo,'Neutral Atmosphere Zenith delay</p>\n');
fprintf(fo,'<p align="left" class="style3"><img src="NAD.%s" width="600" height="450" /></p>\n',picfmt);
fprintf(fo,'<p align="left" class="style3">_________<br />\n');
fprintf(fo,'Vertical Ionospheric delay</p>\n');
fprintf(fo,'<p align="left" class="style3"><img src="ION.%s" width="600" height="450" /></p>\n',picfmt);
fprintf(fo,'<p align="left" class="style3">_________<br />\n');
fprintf(fo,'Residuals</p>\n');
fprintf(fo,'<p align="left" class="style3"><img src="res.%s" width="600" height="450" /></p>\n',picfmt);
fprintf(fo,'<p align="left" class="style3"><img src="col.gif" /></p>\n');
fprintf(fo,'<p align="left" class="style3">&nbsp; </p>\n');

return;

% MP Plots
fprintf(fo,'<p align="left" class="style3">_________<br />\n');
fprintf(fo,'Code Multipath</p>\n');
fprintf(fo,'<p align="left" class="style3"><img src="MP.%s" width="600" height="450" /></p>\n',picfmt);
for prn=1:40
    if prn>9
        file_name = [defname 'MP' num2str(prn) '.' picfmt];
    else
        file_name = [defname 'MP0' num2str(prn) '.' picfmt];
    end
    files = dir(file_name);
    if size(files,1)==1
        fprintf(fo,'<p align="left" class="style3"><img src="%s" width="600" height="450" /></p>\n',file_name);
    end
end
fprintf(fo,'<blockquote>\n');
fprintf(fo,'  <p align="left" class="style3">&nbsp;</p>\n');
fprintf(fo,'  <p align="left" class="style2">&nbsp;</p>\n');
fprintf(fo,'  <p align="left" class="style2"><br />\n');
fprintf(fo,'  </p>\n');
fprintf(fo,'</blockquote>\n');
fprintf(fo,'<p align="left" class="style2">&nbsp;  </p>\n');
fprintf(fo,'<p align="left" class="style2">&nbsp;</p>\n');
fprintf(fo,'</body>\n');
fprintf(fo,'</html>\n');

fclose(fo);