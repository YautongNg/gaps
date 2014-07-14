function [otlxyz]=xyzotl(pos_geod,otlneu)

ell1.a= 6378137;
ell1.e_sq= 0.0067;
ell1.e= 0.0818;
ell1.b= 6.3568e+006;
ell1.f= 0.0034;


     J = get_jacobian_local2cart(pos_geod, ell1);


%    for i=1:n 
%     otlxyz(i,:) = (J(:,:,i) * otlneu(i,:)')'; 
%    end

     otlxyz(1,:) = (J(:,:,1) * otlneu(1,:)')'; 

end
