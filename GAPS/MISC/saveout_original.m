namedir=[oobsname '_' exten(2:end) direx];
pato=[namedir '/output'];
pati=[namedir '/input'];
mkdir(pato);
mkdir(pati);
pato=[pato '/'];
pati=[pati '/'];

% Save Filter file
fltnameo=[defname '.flt'];
save(fltnameo,'cx0','cxi0','cx12','ionop','obuf','pfn','npf','amb','ambi','amb1','amb2','jmp','pwu','recclk','zennad','recxyz','recllh'); 

movefile([defname '.html'],[namedir ['/' defname '.html']]);
copyfile('c:\ppp\dev\ell.gif',[namedir '/ell.gif']);
copyfile('c:\ppp\dev\ell2.gif',[namedir '/ell2.gif']);
copyfile('c:\ppp\dev\col.gif',[namedir '/col.gif']);

if exist([defname '1.' picfmt],'file')
    movefile([defname '1.' picfmt],[namedir '/coord1.' picfmt]);
end
if exist([defname '2.' picfmt],'file')
    movefile([defname '2.' picfmt],[namedir '/coord2.' picfmt]);
end
if exist([defname '3.' picfmt],'file')
    movefile([defname '3.' picfmt],[namedir '/coord3.' picfmt]);
end
if exist([defname '4.' picfmt],'file')
    movefile([defname '4.' picfmt],[namedir '/coord4.' picfmt]);
end
if exist([defname '5.' picfmt],'file')
    movefile([defname '5.' picfmt],[namedir '/NAD.' picfmt]);
end
if exist([defname '6.' picfmt],'file')
    movefile([defname '6.' picfmt],[namedir '/res.' picfmt]);
end
if exist([defname '7.' picfmt],'file')
    movefile([defname '7.' picfmt],[namedir '/ION.' picfmt]);
end

%%%% COMMENTED OUT TO DISABLE MP PLOTS - RL20090607 %%%%%
% movefile([defname 'MP.' picfmt],[namedir '/MP.' picfmt]);
% for prn=1:40
%     if prn>9
%         file_name = [defname 'MP' num2str(prn) '.' picfmt];
%     else
%         file_name = [defname 'MP0' num2str(prn) '.' picfmt];
%     end
%     files = dir(file_name);
%     if size(files,1)==1
%         movefile(file_name,[namedir '/' file_name]);
%     end
% end

movefile(outname,[pato outname]);
movefile(outnamer,[pato outnamer]);
movefile(outnamep,[pato outnamep]);
movefile(outnamesd,[pato outnamesd]);
movefile(fltnameo,[pato fltnameo]);
if ~strcmp(fltname,'none')
    movefile(fltname,[pati fltname]);
end
obsnameo=[oobsname exten(2:end)];
%movefile(obsname,[pati obsnameo]);
zip([namedir '.zip'],[namedir '/*.*']);
rmdir(pato,'s');
rmdir(pati,'s');
movefile([namedir '.zip'],[namedir '/' namedir '.zip']);
%prename1o=prename1(end-11:end);
%movefile(prename1,[pati prename1o]);
%delete(prename1);
%delete(prename2);
%delete(clkname1);
%delete(clkname2);
%prename2o=prename2(end-11:end);
%movefile(prename2,[pati prename2o]);
%clkname1o=clkname1(end-11:end);
%movefile(clkname1,[pati clkname1o]);
%clkname2o=clkname2(end-11:end);
%movefile(clkname2,[pati clkname2o]);
%winopen([pato 'PPP.html']);