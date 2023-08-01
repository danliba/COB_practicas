function V=vorticity(lon,lat,adt)
%--- definimos gravedad
g=9.81; %--- m/s^2

%--- calculamos distancias
[LON,LAT]=meshgrid(lon,lat);
[x,y] = ll2utm(LAT,LON,'wgs84',31);
[dx,~]=gradient(x); [~,dy]=gradient(y);

%--- calculo el parámetro de coriolis
T=23*3600+56*60+4.1; %--- periodo de rotacion de la tierra en segundos
f=(2./T)*sind(LAT);

%--- la primera derivada.
[auxx,auxy]=gradient(adt); adtx=auxx./dx; adty=auxy./dy;

%--- ahora la segunda derivada
[auxxx,~]=gradient(adtx); [~,auxyy]=gradient(adty);
adtxx=auxxx./dx; adtyy=auxyy./dy;

%--- calculamos la vorticidad
V=(g./f).*(adtxx+adtyy);
end


