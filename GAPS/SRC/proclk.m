function [clk clk3 clkint]=proclk(clkname1,clkname2,sp3clk)
%
% Process Precise clock files and generate polinomials
% for each satellite
% 
% It adjusts a 2nd degree polynomial for each 20 min arc, for each
% satellite
%
% OUTPUT : clk = structure
%          clk{prn,idx} = 3x1 vector with polinomial coefficients
%          idx = arc (in sod)    number
%                0-1200      ->  1
%                1200-2400   ->  2
%                2400-3600   ->  3
%                ...             ...
%                85200-86400 ->  72
%
%           clk1 = matrix with clock file contents
%
% Created/Modified
% ================
%
% When              Who                     What
% ----              ---                     ----
% 2006/04/01        Rodrigo Leandro         Function created
% 2007/02/01        Rodrigo Leandro         Added output: clk1
% 2009/12/15        Landon Urquhart         Support up to 120 satellites
%
% 
%=================================================================
% Copyright 2006-2007 Rodrigo Leandro, University of New Brunswick
%=================================================================

% Preallocating Space in Memory
clk{120,72}=zeros(3,1);

fprintf(1,'Generating clocks:\n')
fprintf(1,'    Reading clock files...\n')

% Read Precise Ephemeris files
if ~strcmp(clkname1,'none')
    clk1=readclk2(clkname1);
else
    clk1=sp3clk;
end
if ~strcmp(clkname2,'none')
    clk2=readclk2(clkname2);
    % Add Next day first obs. to complete time series
    if ~strcmp(clkname2,'none')
        clk2p=clk2(clk2(:,1)==0,:);
        clk2p(:,1)=86400;
        clk1=[clk1;clk2p];
    end
end

fprintf(1,'    Processing...\n')


% Time Tag Vector is the first column of clk
% (in seconds of day)

% Get vector containing PRN list
prnl=unique(clk1(:,2));

% get list of timetags
timetagl=unique(clk1(:,1));
intervals = unique(diff(timetagl));
clkint = intervals(round(size(intervals,1)/2));



% Generate clocks for each PRN
for i=1:size(prnl,1)
    clk_prn = clk1(clk1(:,2)==prnl(i),:);
    for j=0:1200:85200
    % Generating polinomials for each period (5 points each = 20 min)    
        idx=j/1200+1;
        ts=clk_prn(clk_prn(:,1)>=j & clk_prn(:,1)<=j+1200,:);
        if size(ts,1)>=5
            clk{prnl(i),idx}=polyfitr(ts(:,1),ts(:,3),2);
        end
    end
end

%fprintf(1,'    Cloks computed for %i Satellites...\n',max(prnl));

% Re-organize CLK structure to alow faster access
for i=size(prnl,1):-1:1
    m = clk1(clk1(:,2)==prnl(i),:);
    clk3{prnl(i)}.clk = m;
end

fprintf(1,'    Done.\n')