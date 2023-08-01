clc; close all; clear all;
cd D:\Maestria\MER\Intership\baleares\practicas_Daniel\datos_ambientales\vorticidad;
%% 
file='cmems_obs-sl_eur_phy-ssh_my_allsat-l4-duacs-0.125deg_P1D_1649325087308.nc'; 

%ncdisp(file);

lat=double(ncread(file,'latitude')); lon=double(ncread(file,'longitude'));
crs=double(ncread(file,'crs'));

ADT=ncread(file, 'adt');%lon,lat,time
ADT=permute(ADT,[2 1 3]); %lat, lon, time.
ADT2=ADT(5:end,20:end,:);
lat2=lat(5:end);
lon2=lon(20:end);

V=vorticity(lon2,lat2,ADT2); %%Calculo vorticidad como segunda derivada de ADT (función vorticity)
%solucionado

time=double(ncread(file,'time'));
time2=datenum(1950,1,1)+time;
ttime=datevec(time2); 
[yr,mo,da,hr]=datevec(double(time)+datenum(1950,1,1,0,0,0));
           
clim=nanmean(ADT2,3);
%%
%%Bucle para sacar media de la zona por cada time step (datos diarios)
for i=1:size(ADT2,3)

    a=reshape(V(:,:,i),[size(lon2,1)*size(lat2,1) 1]);
    media(i,:)=nanmean(a,1);%promedio diario por toda la zona
    disp(datestr(datenum(yr(i),mo(i),da(i))))
% 
end
%%
m=ttime(:,2);y=ttime(:,1); 
um=unique(m);uy=unique(y); %%veo que años y meses tengo

cont=0; %%contador a 0

for j=1:size(uy,1)
for k=1:size(um,1)
   ind=((mo==um(k))&(yr==uy(j))); %%indice que va buscando filas para cada mes de cada año
   f=nanmean(media(ind,1),1); %%promedio las filas seleccionadas con indice 
   monthly_s(cont+1,:)=f; %%%guardo en fila
   leg(cont+1,:)=[uy(j),um(k)]; %%%saco columna de año y mes, compruebo que está bien
   %leg es año+mes
   cont=cont+1;
end
end
  
vort=cat(2,leg,monthly_s);
%%
%%%%%Segunda parte
% for y=1:size(um,1)
%     ind2=(leg(:,2)==um(y)); %%%busco filas para cada mes (en loop)
%     av=nanmean(monthly_s(ind2,:),1); %%media para cada mes
%     sdev=std(monthly_s(ind2,:),1,'omitnan');%% desviacion tipica para cada mes
%     anom(ind2,:)=(monthly_s(ind2,:)-av)./sdev; %%cálculo la anomalia mensual z-score= (x-media)/desviacion tipica
% end
%     
%     csum=cumsum(anom,1); %%calculo cumulative sum (easy)
%     
%     series_m=cat(2,leg,monthly_s,anom,csum); %%concateno matrices para salvar
%     
    ym=leg(:,1)+(leg(:,2)-0.5)./12; %%año en fracción
    
    series_m=cat(2,leg,monthly_s);
    save serie_vort2.mat series_m;

%% algunos graficos


grayColor = [.7 .7 .7];

figure
for ii=1:size(ADT2,3)
pcolor(lon2,lat2,V(:,:,ii));shading interp; colorbar;
pause(0.5)
clf
% hold on
% borders('countries','facecolor',grayColor);
end

%% climatologia mensual de la vorticidad
for ik=1:1:12

    indxclim=find(mo==ik);
    Vclim(:,:,ik)=nanmean(V(:,:,indxclim),3);

end

%% plot clim
aviobj = QTWriter('Vorticidad_mensual.mov','FrameRate',1);%aviobj.Quality = 100;

figure
for ii=1:size(Vclim,3)
pcolor(lon2,lat2,Vclim(:,:,ii));shading interp; colorbar;
disp(['Mes ',num2str(ii)])
title(['Mes ',num2str(ii)]);
colormap jet
caxis([-7*10^-5 7*10^-5]);
text(1.4,42,'Climatologia Mensual Vorticidad','FontWeight','bold');
 M1=getframe(gcf);
 writeMovie(aviobj, M1);
% hold on
% borders('countries','facecolor',grayColor);
pause(1)
clf
end
close(aviobj);
%% promedio mensual de la vorticidad y anomalias
yrst=1993;
yren=2020;

most=1; moen=12;
daen=30;
jj=0;
for iy=yrst:1:yren

    for imo=most:1:moen

        if imo==2
            daen=28;
        else
            daen=30;
        end
        
        fechas=[datenum(iy,imo,01) datenum(iy,imo,daen)];
        indxtime=find(time2>=fechas(1)&time2<=fechas(2));
        disp(datestr(datenum(iy,imo,30)))
        %disp(['Procesando mes',' ',num2str(imo),'-',num2str(iy)])
        jj=jj+1;
        vort_mes=nanmean(V(:,:,indxtime),3);
        Vmonmean(:,:,jj)=vort_mes;

        Vanom(:,:,jj)=vort_mes-Vclim(:,:,imo);
        timeis(jj)=datenum(iy,imo,15);
    end
end

%% Monthly mean
%aviobj = QTWriter('Vorticidad_mensual.mov','FrameRate',1);%aviobj.Quality = 100;

figure

for ii=1:size(Vmonmean,3)
pcolor(lon2,lat2,Vmonmean(:,:,ii));shading interp; colorbar;
disp(datestr(timeis(ii)))
title(datestr(timeis(ii)))
colormap jet
caxis([-7*10^-5 7*10^-5]);
text(1.4,42,'Promedio Mensual Vorticidad','FontWeight','bold');
 %M1=getframe(gcf);
 %writeMovie(aviobj, M1);
% hold on
% borders('countries','facecolor',grayColor);
pause(0.5)
clf
end
%close(aviobj);

%% Anomalias
%aviobj = QTWriter('Vorticidad_anomalia_mensual.mov','FrameRate',1);%aviobj.Quality = 100;

figure
for ii=1:size(Vanom,3)
pcolor(lon2,lat2,Vanom(:,:,ii));shading interp; colorbar;
disp(datestr(timeis(ii)))
title(datestr(timeis(ii)))
cmocean balance
caxis([-5*10^-5 5*10^-5]);
text(1.4,42,'Anomalia Mensual Vorticidad','FontWeight','bold');
 %M1=getframe(gcf);
 %writeMovie(aviobj, M1);
pause(0.5)
clf
% hold on
% borders('countries','facecolor',grayColor);
end
%close(aviobj);

%% Anomalia promedio de la zona
Z_vanom=nanmean(nanmean(Vanom,1),2);
Z_Vanom=permute(Z_vanom,[3 1 2]);

Z_prom=nanmean(nanmean(Vmonmean,1),2);
Z_Prom=permute(Z_prom,[3 1 2]);
%% ploteo
yyaxis right;
plot(Z_Vanom);
hold on
yyaxis left;
plot(Z_Prom);
hold on
plot(monthly_s,'k:');
%%
save('vorticidades.mat','lon2','lat2','timeis','Vmonmean','Vanom');




