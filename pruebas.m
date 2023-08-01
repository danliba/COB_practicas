% clear,clc
cd D:\Maestria\MER\Intership\baleares\practicas_Daniel\datos_ambientales\GEBCO_19_May_2022_b49d488cb0b3
%% 
file='gebco_2021_n90.0_s27.386706948280334_w-64.54687392711641_e70.31250858306883.nc';
a=ncread(file,'elevation');
lon=ncread(file,'lon');
lat=ncread(file,'lat');

%--- limites de la zona que quiero coger
% lonmin=-0.5; lonmax=5; latmin=38; latmax=44;
lonmin=-6; lonmax=8; latmin=34; latmax=45;
%--- buscamos lon indices que quiero
inlo=find(lon>=lonmin,1,'first'); dxlo=find(lon<=lonmax,1,'last')-inlo+1;
inla=find(lat>=latmin,1,'first'); dxla=find(lat<=latmax,1,'last')-inla+1;
lon=lon(inlo+[0:dxlo-1]); lat=lat(inla+[0:dxla-1]);
%encontramos la region deseada 
var=ncread(file,'elevation',[inlo,inla],[dxlo,dxla]);

[LON,LAT]=meshgrid(lon,lat);
var=permute(var,[2 1 3]); 
ind=find((var<=0)&(-800<=var));var=var(ind);LON=LON(ind); LAT=LAT(ind);
scatter(LON,LAT)


masc=polyshape(LON,LAT);

%     xlin = linspace(min(LON), max(LON), 1000);
%     ylin = linspace(min(LAT), max(LAT), 1000);
%     [X,Y] = meshgrid(xlin, ylin);
%     % Z = griddata(x,y,z,X,Y,'natural');
%     % Z = griddata(x,y,z,X,Y,'cubic');
%     Z = griddata(LON,LAT,double(var),X,Y);
%     
%     pcolor(X,Y,Z); shading flat
  [LON2,LAT2]=meshgrid(lon,lat);
lon2=double(reshape(LON2,size(LON2,1)*size(LON2,2),1));
lat2=double(reshape(LAT2,size(LON2,1)*size(LON2,2),1));

 a=inpolygon(lon2,lat2,LON,LAT);

idx = isinterior(masc,[lon2,lat2]);
in = insidepoly(lon2,lat2,LON,LAT); 
%% 
