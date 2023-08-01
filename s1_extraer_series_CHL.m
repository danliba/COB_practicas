clc; close all; clear all;
cd D:\Maestria\MER\Intership\baleares\practicas_Daniel\datos_ambientales\clorofila
%% 
%%%Extraer y promediar series de CHL de CMEMS para cada area GFCM.

%--- 
file='chlor.nc'; 
lat=double(ncread(file,'lat')); lon=double(ncread(file,'lon'));


CHL=ncread(file, 'CHL');
CHL=permute(CHL,[2 1 3]);
time=double(ncread(file,'time'));
time=datenum(1900,1,1)+time;
ttime=datevec(time); m=ttime(:,2);y=ttime(:,1);

clim=nanmean(CHL,3);

S = shaperead('D:\Maestria\MER\Intership\baleares\practicas_Daniel\datos_ambientales\zonas\GSAs_simplified\GSAs_simplified.shp'); %%%Zonas FAO-GFCM

[LON,LAT]=meshgrid(lon,lat);
lon1=double(reshape(LON,size(LON,1)*size(LON,2),1));%reshape en la 1era dimension
lat1=double(reshape(LAT,size(LON,1)*size(LON,2),1)); %vectorizamos

for k=1:9 %numel(S) 
  lonb{k}=S(k).X;
  latb{k}=S(k).Y;
end

 for na=1:size(CHL,3) 
            na
        var_or=squeeze(CHL(:,:,na));%var_or=var_or';
        var_or=(reshape(var_or,size(var_or,1)*size(var_or,2),1));%vectorizamos
        
for n=1:9%numel(S)
    ii=inpolygon(lon1,lat1,lonb{n},latb{n});
     m2(na,n)=nanmean(var_or((ii),:)); %promedio por area S (9 areas) y por dia
end   

 end
 
 table=cat(2,ttime(:,1:2),m2);
series_chl = array2table(table, 'VariableNames', {'year','month',S(1:9).SECT_COD});
clim_chl=clim;

save CHL_series_clean.mat clim_chl lon lat series_chl table; 

%% plotting the shapefiles
for k=1:31 %numel(S) 
  lonb{k}=S(k).X;
  latb{k}=S(k).Y;
end

for ii=1:1:31
plot(lonb{1,ii},latb{1,ii});
hold on
end
