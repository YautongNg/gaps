function y  = polyvalr(p,x)

y=0;
fac=1;
for i=size(p,2):-1:1 , y=y+p(i)*fac; fac=fac*x; end
