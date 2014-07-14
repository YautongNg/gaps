clear;

p1 =[      3966260.66380431
           1046450.2725837
          4869538.70235858];
      
p2=[3918048.64958489
          1137556.84865841
          4888102.71941542];
      
p1g=cart2geod(p1);
p2g=cart2geod(p2);      

dist0=norm(p1-p2);

res=[];

for d=1:14
    for h=0:23
        cdate=[1998;03;d;h;0;0];
        t1=btide(p1g,cdate);
        t2=btide(p2g,cdate);
        dxyz1=offllh2xyz(p1g,t1);
        dxyz2=offllh2xyz(p2g,t2);
        p1p=p1+dxyz1;
        p2p=p2+dxyz2;
        dist=norm(p1p-p2p);
        res=[res; cdate(1:4,1)' dist-dist0 t1' t2'];
    end
end