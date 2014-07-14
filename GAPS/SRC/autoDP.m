%This is first attempt at running GAPS
function autoDP()

    fclose('all');
    cd('c:/phpdev/www/ppp/files')
    fi=dir('*.*o');

if size(fi,1)>0
    
    %nfile=mget(f,fi(1,1).name);
    %delete(f,fi(1,1).name);
    oobsname=['c:\phpdev\www\ppp\files\' fi(1,1).name];
    obsname=fi(1,1).name;
    movefile(oobsname,'C:\PPP');
    if strcmp(obsname(end),'o')||strcmp(obsname(end),'O')
        cd('C:\PPP');
        save rodrigo
        !autoPPP
        namedir=[obsname(end-11:end-4) '_' obsname(end-2:end)];
        newdir=['c:/phpdev/www/ppp_results/' namedir];
        movefile(namedir,newdir);
    end
    %delete(obsname);
end

    %fprintf(1,'   Closing connection...\n');
    %close(f);