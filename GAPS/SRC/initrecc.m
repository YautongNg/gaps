function [irecxyz irecllh uirecxyz uirecllh]=initrecc(irecc,hobs)
%
% Function initrecc
% =================
%
%       This function initializes the receiver coordinates
%
% Sintax
% ======
%
%       [irecxyz irecllh]=initrecc(irecc,hobs)
%
% Input
% =====
%
%       irecc -> Initial rec. coordinates (XYZ or llh) - from commmand file
%       hobs -> Structure with observation file header
%
% Output
% ======
%
%       irecxyz -> Initial receiver cartesian coordinates
%       irecllh -> Initial receiver geodetic coordinates
%
% Created/Modified
% ================
%
% When         Who                 What
% ----         ---                 ----
% 2006/06/28   Rodrigo Leandro     Function created
% 2006/07/12   Rodrigo Leandro     Add ARP offset to antenna height
%
% Comments
% ========
%
%       No comments
%
%
% ==============================
% Copyright 2006 Rodrigo Leandro
% ==============================

%=====================================
% If user informed initial coordinates
if irecc~=zeros(3,1)
    
    %=======================================
    % If cartesian coordinates were informed
    if abs(irecc(1,1))>90
        irecxyz=irecc;
        uirecxyz=irecc;
        uirecllh=cart2geod(irecxyz);
        irecllh(1:2,1)=uirecllh(1:2,1);
        irecllh(3,1)=uirecllh(3,1)+hobs.deltah;
        irecxyz=geod2cart(irecllh);        
    %---------------------------------------
    % If geodetic coordinates were informed
    else
        uirecllh(1,1)=dms2rad(irecc(1,1));
        uirecllh(2,1)=dms2rad(irecc(2,1));
        irecllh(1:2,1)=uirecllh(1:2,1);
        uirecllh(3,1)=irecc(3,1);
        irecllh(3,1)=uirecllh(3,1)+hobs.deltah;
        irecxyz=geod2cart(irecllh);
        uirecxyz=geod2cart(uirecllh);
    end
    %=======================================

%-------------------------------------
% If user didn't inform initial coordinates
else

    %==================================
    % Get coordinates from RINEX header
    uirecxyz=[hobs.aproxx;hobs.aproxy;hobs.aproxz];
    uirecllh=cart2geod(uirecxyz);
    irecllh(1:2,1)=uirecllh(1:2,1);
    irecllh(3,1)=uirecllh(3,1)+hobs.deltah;
    if uirecxyz~=zeros(3,1)
        irecxyz=geod2cart(irecllh);
    else
        irecxyz=zeros(3,1);
    end
    %==================================

end
%===================================
