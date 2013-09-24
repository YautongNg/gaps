namedir=[oobsname '_' exten(2:end) direx];
pato=fullfile(out,namedir);
%pati=[namedir '/input'];
mkdir(pato);
%mkdir(pati);
%pato=[pato '/'];
%pati=[pati '/'];

% Save Filter file
fltnameo=[fullfile(filt,defname) '.flt'];
save(fltnameo,'cx0','cxi0','cx12','ionop','obuf','pfn','npf','amb','ambi','amb1','amb2','jmp','pwu','recclk','zennad','recxyz','recllh'); 

movefile([fullfile(out,defname) '.html'],[fullfile(out,namedir,defname) '.html']);
%copyfile('c:\ppp\dev\ell.gif',[namedir '/ell.gif']);
%copyfile('c:\ppp\dev\ell2.gif',[namedir '/ell2.gif']);
%copyfile('c:\ppp\dev\col.gif',[namedir '/col.gif']);

if exist([fullfile(out,defname) '1.' picfmt],'file')
    movefile([fullfile(out,defname) '1.' picfmt],[fullfile(out,namedir) '/coord1.' picfmt]);
end
if exist([fullfile(out,defname) '2.' picfmt],'file')
    movefile([fullfile(out,defname) '2.' picfmt],[fullfile(out,namedir) '/coord2.' picfmt]);
end
if exist([fullfile(out,defname) '3.' picfmt],'file')
    movefile([fullfile(out,defname) '3.' picfmt],[fullfile(out,namedir) '/coord3.' picfmt]);
end
if exist([fullfile(out,defname) '4.' picfmt],'file')
    movefile([fullfile(out,defname) '4.' picfmt],[fullfile(out,namedir) '/coord4.' picfmt]);
end
if exist([fullfile(out,defname) '5.' picfmt],'file')
    movefile([fullfile(out,defname) '5.' picfmt],[fullfile(out,namedir) '/NAD.' picfmt]);
end
if exist([fullfile(out,defname) '6.' picfmt],'file')
    movefile([fullfile(out,defname) '6.' picfmt],[fullfile(out,namedir) '/res.' picfmt]);
end
if exist([fullfile(out,defname) '7.' picfmt],'file')
    movefile([fullfile(out,defname) '7.' picfmt],[fullfile(out,namedir) '/ION.' picfmt]);
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

movefile(fullfile(out,outname),fullfile(pato, outname));
movefile(fullfile(out,outnamer),fullfile(pato, outnamer));
movefile(fullfile(out,outnamep),fullfile(pato, outnamep));
movefile(fullfile(out,outnamesd),fullfile(pato, outnamesd));
%movefile(fullfile(out,fltnameo),[pato fltnameo]);
%if ~strcmp(fullfile(filt,fltname),'none')
%    movefile(fullfile(filt,fltname),[pati fltname]);
%end
obsnameo=[oobsname exten(2:end)];
%movefile(obsname,[pati obsnameo]);
zip([fullfile(out,namedir) '.zip'],[fullfile(out,namedir) '/*.*']);
%rmdir(pato,'s');
%rmdir(pati,'s');
movefile([fullfile(out,namedir) '.zip'],[fullfile(out,namedir) '/' namedir '.zip']);
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