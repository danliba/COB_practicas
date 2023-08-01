%vamos a calcular la vorticidad mi gente
%The absolute dynamic topography is the sea surface height above geoid; 
% the adt is obtained as follows: adt=sla+mdt where mdt is the mean dynamic 
% topography; see the product user manual for details
adt1=ADT2(:,:,2);

%% vorticidad
g=9.81; %--- m/s^2

%--- calculamos distancias
[LON,LAT]=meshgrid(lon2,lat2);
[x,y] = ll2utm(LAT,LON,'wgs84',31); %x is longitud % y es latitud
[dx,~]=gradient(x); [~,dy]=gradient(y);

%--- calculo el parámetro de coriolis
T=23*3600+56*60+4.1; %--- periodo de rotacion de la tierra en segundos
f=(2./T)*sind(LAT); %seno en grados 

%--- la primera derivada.
[FX,FY]=gradient(adt1); %columnas, filas
%La primera salida FX siempre es el gradiente en la segunda dimensión de F,
% que va de columna a columna. La segunda salida FY siempre es el gradiente 
% en la primera dimensión de F, que va de fila en fila.

adtx=FX./dx; %gradiente de FX de adt sobre la gradiente de la longitud (dx)
adty=FY./dy; %gradiente de FY de adt sobre la gradiente de la latitud (dy)

%--- ahora la segunda derivada
%La segunda derivada espacial de ADT en las direcciones x e y (adtxx y adtyy)
% permite cuantificar cómo varía el gradiente de ADT a medida que nos alejamos 
% de un punto dado en la malla. Esto se logra al considerar las diferencias 
% de las primeras derivadas espaciales en cada dirección.

[auxxx,~]=gradient(adtx); 
[~,auxyy]=gradient(adty);

adtxx=auxxx./dx; %se divide 2 veces por dx, dx^2
adtyy=auxyy./dy;

--- calculamos la vorticidad
V=(g./f).*(adtxx+adtyy);


%% otra forma
% %primera derivada 
% [dudx,~]=gradient(u);
% [~,dudy]=gradient(u);
% [dvdx,~]=gradiet(v);
% [~,dvdx]=gradient(v);
% 
% %segunda derivada 