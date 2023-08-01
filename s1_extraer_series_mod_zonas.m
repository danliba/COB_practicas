%%Extraigo velocidad por zonas 
clc; close all; clear all;
cd D:\Maestria\MER\Intership\baleares\practicas_Daniel\datos_ambientales\vorticidad;
%%
%file='cmems_obs-sl_eur_phy-ssh_my_allsat-l4-duacs-0.125deg_P1D_1649325087308.nc'; 
file='cmems_obs-sl_eur_phy-ssh_my_allsat-l4-duacs-0.125deg_P1D_1650897343606.nc'; 

lonmin=0; lonmax=5; latmin=38; latmax=42; dl=0.125;
ncdisp(file);

lat=double(ncread(file,'latitude'));lat=lat(1:end);
lon=double(ncread(file,'longitude'));lon=lon(1:end);
crs=double(ncread(file,'crs'));

u=ncread(file,'ugos');u=permute(u,[2 1 3]);
v=ncread(file,'vgos');v=permute(v,[2 1 3]);

% velint=abs(u+1i*v);
velint=sqrt(u.^2+v.^2); %velocidad geost
 velint=velint(1:end,1:end,:);


[LON1,LAT1]=meshgrid(lon,lat);
LON=double(reshape(LON1,size(LON1,1)*size(LON1,2),1));
LAT=double(reshape(LAT1,size(LON1,1)*size(LON1,2),1));

arch_kml_zona1='D:\Maestria\MER\Intership\baleares\practicas_Daniel\datos_ambientales\vorticidad\NCN.kml';
R1=kml2struct(arch_kml_zona1); lonb1=R1.Lon; latb1=R1.Lat;

ind1=inpolygon(LON,LAT,lonb1,latb1);
% ind1(ind1==0)=NaN;
ii1=double(repmat(ind1,1,size(velint,3)));ii1(ii1==0)=NaN;

arch_kml_zona2='D:\Maestria\MER\Intership\baleares\practicas_Daniel\datos_ambientales\vorticidad\IBI.kml';
R2=kml2struct(arch_kml_zona2); lonb2=R2.Lon; latb2=R2.Lat;

ind2=inpolygon(LON,LAT,lonb2,latb2); % busca puntos dentro del poligono
% ind1(ind1==0)=NaN;
ii2=double(repmat(ind2,1,size(velint,3)));ii2(ii2==0)=NaN;


%  heat(heat<-30000)=NaN;
%   prec(prec<-30000)=NaN;
% 
  vel_cat=nanmean(ii1.*(squeeze(reshape(velint,size(velint,1)*size(velint,2),1,size(velint,3)))),1);
  vel_mall=nanmean(ii2.*(squeeze(reshape(velint,size(velint,1)*size(velint,2),1,size(velint,3)))),1);
  vel_cat=vel_cat'; vel_mall=vel_mall';
  
time=double(ncread(file,'time'));
time=datenum(1950,1,1)+time;
ttime=datevec(time); 

m=ttime(:,2);y=ttime(:,1);
um=unique(m);uy=unique(y);

cont=0;

%creamos el promedio mensual 
for j=1:size(uy,1)
for k=1:size(um,1)
   ind=(m==um(k)&(y==uy(j)));
   f1=nanmean(vel_cat(ind,:),1);
   f2=nanmean(vel_mall(ind,:),1);
   monthly_s(cont+1,:,:)=[f1,f2];
   leg(cont+1,:)=[uy(j),um(k)];
   cont=cont+1;
end
end

vel=cat(2,leg,squeeze(monthly_s));

%% plot
timeis=datenum(vel(:,1),vel(:,2),15);

plot(timeis,vel(:,3)); hold on; plot(timeis,vel(:,4));
legend('NCN','IBI');
datetick('x');
grid on; 
title('Velocidad geostrofica por zona')

%% save
Tvel=array2table(vel);
labs={'yr','mo','NCN','IBI'};
Tvel.Properties.VariableNames=labs;

save('vorticity_NCN_IBI.mat','Tvel');
%% 

my_file=['mar_balear.xlsx'];
writetable(Tvel,my_file,'Sheet',2);

