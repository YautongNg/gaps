cd('c:\work\m');do_addpath;cd('C:\temp\temp\GAPS_FT');
cdate=[2010 ;01 ;07; 0; 0; 0]  ;  
recllh=[deg2rad(45.9588);deg2rad(281.9286); 202.0000];
recxyz=geod2cart(recllh);
%======================================================================
    % Compute Sun and Moon Position
    %----------------------------------------------------------------------
    [mjd fullmjd fracmjd] = date2mjd(cdate);
    sidt=mjd2sdt(mjd,cdate);
    xsun=suncrd(mjd,sidt);
    xmoon=mooncrd(mjd,sidt);
    %======================================================================

    %======================================================================
    % Compute Body Tide
    %   btdllh -> tide in U,N,E directions
    %   btdxyz -> tide in X,Y,Z directions
    %----------------------------------------------------------------------
    btdxyz = detide(recxyz,xsun,xmoon,fullmjd,fracmjd);
    ell=get_ellipsoid('wgs84');
    [pt_local, J] = convert_to_local_cart ((recxyz+btdxyz)', [rad2deg(recllh(1)) rad2deg(recllh(2)) recllh(3)], ell)
    

    
    