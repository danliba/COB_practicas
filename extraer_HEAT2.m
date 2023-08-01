%%%Script para extraer heatloss ò intercambio calor atmosfera-oceano ERA5
%%%Copernicus ->pasar de  J m-2 a W m-2

clear,clc
%%%datos en 3 archivos, leo y concateno
file1='h1.nc';
file2='h2.nc';
file3='h3.nc';

%% 
ncdisp(file1)
% slhf : 'surface_upward_latent_heat_flux' %surface latent heat flux
% ssr: 'surface_net_downward_shortwave_flux' %surface net solar radiation
% str: 'surface_net_upward_longwave_flux' %'Surface net thermal radiation'
% sshf: 'surface_upward_sensible_heat_flux' % Surface sensible heat flux  


lon=double(ncread(file1,'longitude'));
lat=double(ncread(file1,'latitude'));

timeo1=double(ncread(file1,'time'));
time1=datenum(1900,1,1)+timeo1./24;
ttime1=datevec(time1);
timeo2=double(ncread(file2,'time'));
time2=datenum(1900,1,1)+timeo2./24;
ttime2=datevec(time2);
timeo3=double(ncread(file3,'time'));
time3=datenum(1900,1,1)+timeo3./24;
ttime3=datevec(time3);

%%%Zona de interés
 lonmin=-8.; lonmax=37.; latmin=30.; latmax=46.;

 %%Heatloss neto suma de 4 variables
 slhf1=ncread(file1,'slhf');
 ssr1=ncread(file1,'ssr');
 str1=ncread(file1,'str');
 sshf1=ncread(file1,'sshf');  
 heat1=slhf1+str1+ssr1+sshf1;heat1=permute(heat1,[2 1 3]);%lat lon time
 
 slhf2=ncread(file2,'slhf');
 ssr2=ncread(file2,'ssr');
 str2=ncread(file2,'str');
 sshf2=ncread(file2,'sshf');  
 heat2=slhf2+str2+ssr2+sshf2;heat2=permute(heat2,[2 1 3]);
 
 slhf3=ncread(file3,'slhf');
 ssr3=ncread(file3,'ssr');
 str3=ncread(file3,'str');
 sshf3=ncread(file3,'sshf');  
 heat3=slhf3+str3+ssr3+sshf3;heat3=permute(heat3,[2 1 3]);
 
 heat=cat(3,heat1,heat2,heat3);%cat time
 time=cat(1,ttime1,ttime2,ttime3);
    
% evap=double(ncread(file,'e'));
% prec=double(ncread(file,'tp'));

[LON1,LAT1]=meshgrid(lon,lat);
LON=double(reshape(LON1,size(LON1,1)*size(LON1,2),1));
LAT=double(reshape(LAT1,size(LON1,1)*size(LON1,2),1));

%%Extraigo para una zona (polígono) extraído con Google Earth
arch_kml_zona1='D:\Maestria\MER\Intership\baleares\practicas_Daniel\datos_ambientales\zonas\NWMED.kml';
R1=kml2struct(arch_kml_zona1); lonb1=R1.Lon; latb1=R1.Lat;

ind1=inpolygon(LON,LAT,lonb1,latb1);
% ind1(ind1==0)=NaN;
ii=double(repmat(ind1,1,size(heat,3)));ii(ii==0)=NaN; %mascara del tamaño de heat

% 
  heat_f=1/86400.*nanmean(ii.*(squeeze(reshape(heat,size(heat,1)*size(heat,2),1,size(heat,3)))),1);

timeis=datenum(time(:,1),time(:,2),time(:,3));

plot(timeis,heat_f);datetick('x');

heatloss=cat(2,time(:,1:2),heat_f');



 heatm=reshape(heat_f,[12 42]);
 heatm=heatm';
