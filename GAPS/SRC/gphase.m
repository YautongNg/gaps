function b=gphase(nb)
%
% Ref: Gabor & Nerem 2002

b=atan2(sin(2*pi*nb),cos(2*pi*(nb)))/(2*pi);