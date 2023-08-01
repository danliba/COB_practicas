clc; close all; clear all;
fn='med-cmcc-tem-rean-m_1689601621692.nc'; %file2='2001_2020.nc'; %%%Leo SST en dos archivos y concateno
lat=double(ncread(fn,'lat')); lon=double(ncread(fn,'lon'));

% SST1=ncread(file1, 'analysed_sst');
%          SST1=permute(SST1,[2 1 3]);
%          time1=double(ncread(file1,'time'));
%          time1=datenum(1981,1,1)+time1./86400;
%          ttime1=datevec(time1); 
% 
% SST2=ncread(file2, 'analysed_sst');
%         SST2=permute(SST2,[2 1 3]);
%          time2=double(ncread(file2,'time'));
%          time2=datenum(1981,1,1)+time2./86400;
%          ttime2=datevec(time2); 
% 
% SST=cat(3,SST1,SST2);
%          SST(SST==-32768)=NaN;SST=SST-273.15;
%          time=cat(1,time1,time2);
%          ttime=datevec(time);mt=ttime(:,2);yt=ttime(:,1);

SST=double(ncread(fn,'thetao')); SST=permute(SST,[1 2 4 3]);
time=double(ncread(fn,'time'));
time=datenum(1900,1,1)+time./1440;
ttime=datevec(time); 

SST1=permute(SST,[2 1 3]);
        
clim=nanmean(SST,3);

%pcolor(lon,lat,clim'); shading flat; colorbar; colormap jet;
  %%%Leo shapefiles de zonas FAO_GFCM para promediar
S = shaperead('D:\Maestria\MER\Intership\baleares\practicas_Daniel\datos_ambientales\zonas\GSAs_simplified\GSAs_simplified.shp');

[LON,LAT]=meshgrid(lon,lat);
lon1=double(reshape(LON,size(LON,1)*size(LON,2),1));
lat1=double(reshape(LAT,size(LON,1)*size(LON,2),1));

%para las 9 zonas
for k=1:9 %numel(S)
  lonb{k}=S(k).X;
  latb{k}=S(k).Y;
end

 for na=1:size(SST,3) 
            na
        var_or=squeeze(SST(:,:,na));%var_or=var_or';
        var_or=(reshape(var_or,size(var_or,1)*size(var_or,2),1));
        
for n=1:9%numel(S)
    ii=inpolygon(lon1,lat1,lonb{n},latb{n});
     m(na,n)=nanmean(var_or((ii),:));
end   

 end
 
 table=cat(2,ttime(:,1:2),m);
 series_sst = array2table(table, 'VariableNames', {'year','month',S(1:9).SECT_COD});
 clim_sst=clim;
% 
 save SST_series_daily2.mat clim_sst lon lat series_sst table; 