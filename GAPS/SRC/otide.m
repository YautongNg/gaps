function otlxyz=otide(otldisp,cdate,recllh)
hod=cdate(4)+cdate(5)/60+cdate(6)/3600;
epochs=[0:1:24]';
ind=find(epochs<=hod);
ind=ind(end);
dt=hod-epochs(ind);
offllh(2)=otldisp(ind,1)+dt*((otldisp(ind+1,1)-otldisp(ind,1))/ (epochs(ind+1)-epochs(ind)));
offllh(3)=otldisp(ind,2)+dt*((otldisp(ind+1,2)-otldisp(ind,2))/ (epochs(ind+1)-epochs(ind)));
offllh(1)=otldisp(ind,3)+dt*((otldisp(ind+1,3)-otldisp(ind,3))/ (epochs(ind+1)-epochs(ind)));

otlxyz=offllh2xyz(recllh,offllh');