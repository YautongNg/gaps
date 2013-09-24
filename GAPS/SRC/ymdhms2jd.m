function jd=ymdhms2jd(epoch)
%
% Function ymdhms2jd(epoch)
%
%  Returns Julian Day for given Year, Month, Day, Hour*, 
% Minute* and Seconds*
%
%  *Optional
%
% Written by F. Nievinski
%
% Modifications: R. Leandro - Input in separated values instead of vector
%                (20060306)

   year = epoch(1);  month = epoch(2);  day = epoch(3);
   hour = epoch(4);  minute = epoch(5);  second = epoch(6);


    if (month < 3)
        month = month + 12;
        year = year - 1;
    end
    jd = day + fix( (153 * month - 457) / 5 ) + 365 * year ...
         + floor(year / 4) - floor(year / 100) + floor(year / 400) ...
         + 1721118.5;

    hour_dec = hour + (minute + second / 60) / 60;
    jd = jd + hour_dec / 24;
    
end

%!test
%! assert (get_JD ([-4713 11 24 12 0 0]), 0)

%!test
%! assert (get_JD ([-4713 11 24 0 0 0]), -0.5)

%!test
%! assert (get_JD ([-4713 11 24 0 0 0]), -0.5)

% examples from table 1 at <http://vsg.cape.com/~pbaum/date/back.htm>
% Gregorian Date Time JD number
% December 31, 1979 noon 2444239.0
% January 1, 1980 start of the day (just after midnight) 2444239.5
% January 1, 1980 noon 2444240.0
% January 1, 1980 no time specified 2444240
% January 1, 1980 midnight commencing January 2 2444240.5

%!test
%! assert (get_JD ([1979 12 31 12 0 0]), 2444239.0)

%!test
%! assert (get_JD ([1980 01 01 0 0 0]), 2444239.5)

%!test
%! assert (get_JD ([1980 01 01 12 0 0]), 2444240.0)

%!test
%! assert (get_JD ([1980 01 01 24 0 0]), 2444240.5)

% Some more examples.
% Year Month Day JD for Julian date JD for Gregorian date Comment
% -4713 11 24.0 -38.5 -0.5 middle of JD before Gregorian reference
% -4713 11 24.5 -38.0 0.0 Gregorian date of JD reference
% -4713 11 25.0 -37.5 0.5 middle of JD reference day (midnight)
% -4712 1 1.0 -0.5 37.5 middle of day before JD reference
% -4712 1 1.5 0.0 38.0 Julian date of JD reference
% -4712 1 2.0 0.5 38.5 middle of JD reference day
% 0 1 1.0 1721057.5 1721059.5 The first day of 1 B.C.
% 0 2 29.0 1721116.5 1721118.5 Rata Die = -306
% 0 3 1.0 1721117.5 1721119.5 Rata Die = -305
% 0 12 31.0 1721422.5 1721424.5 Rata Die = 0
% 1 1 1.0 1721423.5 1721425.5 Rata Die = 1
% 1582 10 4.0 2299159.5 2299149.5 last day before Gregorian reform
% 1582 10 15.0 2299170.5 2299160.5 first day of Gregorian reform
% 1840 12 31.0 2393482.5 2393470.5 M programming language reference
% 1858 11 17.0 2400012.5 2400000.5 Modified Julian Day 0.0
% 1900 1 1.0 2415032.5 2415020.5 
% 1901 1 1.0 2415398.5 2415385.5 start of the 20th century
% 1970 1 1.0 2440600.5 2440587.5 Unix reference
% 1980 1 1.0 2444252.5 2444239.5 PC (DOS) reference
