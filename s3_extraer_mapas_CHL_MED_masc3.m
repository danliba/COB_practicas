%%%
%%%Código para extraer variable  (con ventana espacial), 
%%%Hago mascara en funcion de lon/lat de variables y profundidad y aplico
clear,clc;
cd D:\Maestria\MER\Intership\baleares\practicas_Daniel\datos_ambientales\clorofila
%% 
%--- 
file='chlor.nc'; 
lat=double(ncread(file,'lat')); lon=double(ncread(file,'lon'));


time=double(ncread(file,'time'));
time=datenum(1981,1,1)+time./86400;
ttime=datevec(time); m=ttime(:,2);y=ttime(:,1);

%--- limites de la zona que quiero coger
% lonmin=-0.5; lonmax=5; latmin=38; latmax=44;
lonmin=-6; lonmax=5.5; latmin=34; latmax=43;


%--- buscamos lon indices que quiero
inlo=find(lon>=lonmin,1,'first'); dxlo=find(lon<=lonmax,1,'last')-inlo+1;
inla=find(lat>=latmin,1,'first'); dxla=find(lat<=latmax,1,'last')-inla+1;
loni=lon(inlo+[0:dxlo-1]); lati=lat(inla+[0:dxla-1]);
CHL=ncread(file, 'CHL',[inlo,inla,1],[dxlo,dxla,Inf]); %seleccionamos la region que queremos
CHL=permute(CHL,[2 1 3]);

[LON,LAT]=meshgrid(loni,lati);
lon1=double(reshape(LON,size(LON,1)*size(LON,2),1)); %vectorizamos
lat1=double(reshape(LAT,size(LON,1)*size(LON,2),1)); %vectorizamos 


lon2=(lonmin:0.05:lonmax);lat2=(latmin:0.05:latmax); %%%Hago otro grid de lon/lat para tener todo en misma resolucin
[LON2,LAT2]=meshgrid(lon2,lat2); 


%%%Hago mascara con funcion
[Xq,Yq,eq] = get_mask(LON2,LAT2); %%%Extraigo batimetría con otra funcion (saco de GEBCO database, netcd en disco duro)
ind=find((eq<=0)&(-1000<=eq)); %%%Aplico profundidades

 eq((ind))=1;eq(not(eq==1))=0;
 for na=1:size(CHL,3)
        disp(na);
       
       var_or1=CHL(:,:,na);
%         var_or=var_or-273.15;

[var_m] = griddata(LON,LAT,var_or1,LON2,LAT2); %%a cada time step (dimension 3) adapto a nuevo grid
var_or2=var_m.*eq;
var_g(:,:, na)=var_or2;


leg(na,:)=[y(na), m(na)];
   disp(na)
end


var_g(var_g==0)=NaN;
a=nanmean(var_g,3); %%%Climatologia

%% Pinto
grayColor = [.7 .7 .7];
m_proj('Mercator','longitudes',[lonmin lonmax],'latitudes',[latmin latmax]); hold on;
% m_proj('mercator','longitude',[lonmin,lonmax],'latitude',[latmin,latmax]);
m_pcolor(lon2,lat2,log10(a)); shading flat; caxis([-1. 0])
colorbar; 
tit=title(['CHL mg m-3']);
hold on
borders('countries','facecolor',grayColor);
% m_gshhs_h('patch',[0.66 0.66 0.66]); % draws the coastline
% m_grid('linest','none','box','fancy','tickdir','in','fontsize',8,'xtick',8,'ytick',6);

lon=lon2; lat=lat2;
%save CHL_Med_1000m_v3.mat var_g lon lat leg;

%% plot
pcolor(lon2,lat2,log10(a)); shading interp; caxis([-1. 0]); colormap jet;
colorbar; 
tit=title(['CHL mg m-3']);
hold on
borders('countries','facecolor',grayColor);

