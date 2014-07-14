
recxyz=[+4075580.6852;+931853.6596;+4801568.0542 ];
recllh=[+12.8789;+49.1442;+666.000];
years=2010;
hobs.fyear=2010;
hobs.fhour=00;
hobs.fminute=00;
hobs.fsecond=00;
btdxyz1=[];
bdytde1=[];


for k=1:length(years)
    for i=01:12
        hobs.fmonth=i;   
        for j=001:030
            hobs.fday=j;

                cdate=[hobs.fyear;hobs.fmonth;hobs.fday;hobs.fhour;hobs.fminute;hobs.fsecond];              
                ctime=0;
                prog=0;
                [mjd fullmjd fracmjd] = date2mjd(cdate);
                doy=ymd2doy(cdate);
                sidt=mjd2sdt(mjd,cdate);
                xsun=suncrd(mjd,sidt);
                xmoon=mooncrd(mjd,sidt);
                bdytde=btide(recllh,cdate);
                bdytde1=[bdytde1;bdytde'];
                btdxyz = detide(recxyz,xsun,xmoon,fullmjd,fracmjd);
                btdxyz1=[btdxyz1;btdxyz'];
                

        end
    
    end    
end


save('btdXYZ.txt', 'btdxyz1','-ASCII');
save('bddUNE.txt', 'bdytde1','-ASCII');