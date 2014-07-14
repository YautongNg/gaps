% lat: radians
% lon: radians
% h: meters
% day: vector with year, month (1-12), day
% time: seconds of the day
% elev: radians
% azim: radians
function factors = my_map_func (data,lat, lon, h, day, time, elev, azim)
    %TODO: check if data file is valid for lat, lon, h, day.
    lat = lat*180/pi;  lon = lon*180/pi;  
    elev = elev*180/pi;  azim = azim*180/pi;
    if (azim > 180),  azim = azim - 360;  end

   


    idx = true([size(data,1),1]);
    
    % find the closest matches in time:
    time_discr = abs(data(:,1) - time);
    time_discr_min = min(time_discr(idx));
    idx = idx & (time_discr == time_discr_min);

    % find the closest matches in elevation, 
    % among the closest matches in time:
    elev_discr = abs(data(:,2) - elev);
    elev_discr_min = min(elev_discr(idx));
    idx = idx & (elev_discr == elev_discr_min);

    % find the closest matches in azimuth, 
    % among the closest matches in elevation and time:
    azim_discr = abs(data(:,3) - azim);
    azim_discr_min = min(azim_discr(idx));
    idx = idx & (azim_discr == azim_discr_min);

    ind = find(idx);
    factors = data(ind(1),4:5)';

    %whos, keyboard  % DEBUG
    %return;
    tol = sqrt(eps);
    if     ((time_discr_min) > 0.001) ...
        || ((elev_discr_min) > 0.1) ...
        || ((azim_discr_min) > 0.1)
        warning('my_map_func:discr', sprintf(...
            'time discr.=%fs\telev. discr.=%f º\tazim. discr.=%fº', ...
            time_discr_min, elev_discr_min, azim_discr_min));
    end
end

%!shared
%! data = load('map_func.dat');

%!test
%! for i=1:size(data,1)
%!     %i, %data(i,:)  % DEBUG
%!     factors = my_map_func ([], [], [], [], data(i,1), ...
%!         data(i,2)*pi/180, data(i,3)*pi/180);
%!     %data(i,4:5); factors  % DEBUG
%!     %[data(i,4:5); factors]  % DEBUG
%!     assert(factors, data(i,4:5))
%! end

%!test
%! idx = (data(:,3) < 0);  data(idx,3) = data(idx,3) + 360;
%! for i=1:size(data,1)
%!     %i, %data(i,:)  % DEBUG
%!     factors = my_map_func ([], [], [], [], data(i,1), ...
%!         data(i,2)*pi/180, data(i,3)*pi/180);
%!     %data(i,4:5); factors  % DEBUG
%!     %[data(i,4:5); factors]  % DEBUG
%!     assert(factors, data(i,4:5))
%! end

%!test
%! data(:,1:3) = data(:,1:3) + sqrt(eps) * rand(size(data,1),3);
%! for i=1:size(data,1)
%!     %i, %data(i,:)  % DEBUG
%!     factors = my_map_func ([], [], [], [], data(i,1), ...
%!         data(i,2)*pi/180, data(i,3)*pi/180);
%!     %data(i,4:5); factors  % DEBUG
%!     %[data(i,4:5); factors]  % DEBUG
%!     assert(factors, data(i,4:5))
%! end

